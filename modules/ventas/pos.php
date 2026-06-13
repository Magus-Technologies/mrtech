<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_VENDEDOR]);

$db   = getDB();
$user = currentUser();

// ── API: Buscar productos ─────────────────────────────────
if (isset($_GET['api']) && $_GET['api'] === 'buscar') {
    header('Content-Type: application/json');
    $q = '%' . trim($_GET['q'] ?? '') . '%';
    $r = $db->prepare("
        SELECT id, codigo, nombre, precio_venta, stock_actual, unidad
        FROM productos
        WHERE activo=1
          AND (nombre LIKE ? OR codigo LIKE ?)
        LIMIT 20");
    $r->execute([$q, $q]);
    echo json_encode($r->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

// ── API: Validar código de descuento ─────────────────────
if (isset($_GET['api']) && $_GET['api'] === 'validar_codigo') {
    header('Content-Type: application/json');
    $cod    = strtoupper(trim($_GET['codigo'] ?? ''));
    $vidReq = (int)($_GET['vendedor_id'] ?? 0);
    if (!$cod) { echo json_encode(['valido'=>false,'msg'=>'Código vacío']); exit; }
    $c = $db->prepare("SELECT * FROM codigos_descuento WHERE codigo=? AND activo=1");
    $c->execute([$cod]);
    $c = $c->fetch();
    if (!$c) { echo json_encode(['valido'=>false,'msg'=>'Código inválido o inactivo']); exit; }
    if ($c['limite_usos'] && $c['usos_actuales'] >= $c['limite_usos']) {
        echo json_encode(['valido'=>false,'msg'=>'Código agotado']); exit;
    }
    $hoy = date('Y-m-d');
    if ($c['fecha_inicio'] && $c['fecha_inicio'] > $hoy) {
        echo json_encode(['valido'=>false,'msg'=>'Código aún no está vigente']); exit;
    }
    if ($c['fecha_fin'] && $c['fecha_fin'] < $hoy) {
        echo json_encode(['valido'=>false,'msg'=>'Código vencido']); exit;
    }
    if ($c['vendedor_id'] && $c['vendedor_id'] != $vidReq) {
        echo json_encode(['valido'=>false,'msg'=>'Código no válido para esta vendedora']); exit;
    }
    echo json_encode([
        'valido'      => true,
        'tipo'        => $c['tipo'],
        'valor'       => (float)$c['valor'],
        'descripcion' => $c['descripcion'],
        'id'          => $c['id'],
    ]);
    exit;
}

// ── Procesar venta ────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD']==='POST' && ($_POST['action']??'')==='procesar_venta') {
    $items      = json_decode($_POST['items'] ?? '[]', true);
    $clienteId  = (int)($_POST['cliente_id']  ?? 0) ?: null;
    $vendedorId = (int)($_POST['vendedor_id'] ?? 0) ?: null;
    $metPago    = $_POST['metodo_pago']       ?? 'efectivo';
    $tipoDoc    = $_POST['tipo_doc']          ?? 'boleta';
    $descGlobal = (float)($_POST['descuento_global'] ?? 0);
    $codDescId  = (int)($_POST['codigo_descuento_id'] ?? 0) ?: null;

    // Pagos múltiples (opcional). Si no llega, se arma uno solo en backend.
    $pagos = json_decode($_POST['pagos'] ?? '[]', true);
    if (!is_array($pagos)) $pagos = [];
    // Limpiar: solo pagos con monto > 0 y método válido
    $metodosValidos = array_keys(getMetodosPago());
    $pagos = array_values(array_filter(array_map(function($p) use ($metodosValidos){
        $m = $p['metodo'] ?? '';
        $mt = (float)($p['monto'] ?? 0);
        if ($mt <= 0 || !in_array($m, $metodosValidos, true)) return null;
        return ['metodo' => $m, 'monto' => round($mt, 2)];
    }, $pagos)));

    if (!empty($items)) {
        $subtotalBruto = 0;
        foreach ($items as $item) {
            $subtotalBruto += (float)$item['precio'] * (float)$item['cantidad'];
        }
        $subtotalBruto = max(0, round($subtotalBruto - $descGlobal, 2));
        $subtotalBase  = round($subtotalBruto / 1.18, 2);
        $igv           = round($subtotalBruto - $subtotalBase, 2);
        $total         = $subtotalBruto;
        $montoPag = (float)($_POST['monto_pagado'] ?? $total);
        $vuelto   = max(0, round($montoPag - $total, 2));

        // ¿Existe el módulo de almacenes? Si es así, las salidas se marcan en
        // el almacén principal (Tienda). Si no, queda en NULL (compatibilidad).
        $almacenPrincipal = null;
        try {
            $almacenPrincipal = $db->query("SELECT id FROM almacenes WHERE principal=1 LIMIT 1")->fetchColumn() ?: null;
        } catch (\Throwable $e) { /* módulo de traslados no instalado */ }

        // ── Toda la venta es atómica: o se guarda completa, o no se guarda nada ──
        $db->beginTransaction();
        try {
            $codigo = generarCodigoVenta($db);

            // Assign SUNAT series and correlative (only for factura/boleta)
            $serieDoc = null;
            $numDoc   = null;
            if (in_array($tipoDoc, ['factura', 'boleta'], true)) {
                $serieKey = $tipoDoc === 'factura' ? 'serie_factura' : 'serie_boleta';
                $st = $db->prepare("SELECT valor FROM configuracion WHERE clave=? LIMIT 1");
                $st->execute([$serieKey]);
                $serieDoc = $st->fetchColumn() ?: ($tipoDoc === 'factura' ? 'F001' : 'B001');
                $st = $db->prepare("SELECT COALESCE(MAX(CAST(num_doc AS UNSIGNED)),0)+1 FROM ventas WHERE serie_doc=?");
                $st->execute([$serieDoc]);
                $numDoc = (int)$st->fetchColumn();
            }

            $db->prepare("INSERT INTO ventas
                (codigo,cliente_id,usuario_id,vendedor_id,tipo_doc,serie_doc,num_doc,subtotal,igv,descuento,codigo_descuento_id,total,metodo_pago,monto_pagado,vuelto)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
               ->execute([$codigo,$clienteId,$user['id'],$vendedorId,$tipoDoc,$serieDoc,$numDoc,
                          $subtotalBase,$igv,$descGlobal,$codDescId,$total,$metPago,$montoPag,$vuelto]);
            $ventaId = $db->lastInsertId();

            foreach ($items as $item) {
                $pid    = (int)$item['id'];
                $cant   = (float)$item['cantidad'];
                $precio = (float)$item['precio'];

                if ($pid <= 0 || $cant <= 0) {
                    throw new RuntimeException('Línea de venta inválida.');
                }
                $sub = round($cant * $precio, 2);

                // Bloquear la fila del producto para evitar ventas simultáneas
                // que dejen stock negativo (condición de carrera).
                $prod = $db->prepare("SELECT nombre, stock_actual FROM productos WHERE id=? FOR UPDATE");
                $prod->execute([$pid]);
                $p = $prod->fetch();
                if (!$p) {
                    throw new RuntimeException('Producto no encontrado (ID '.$pid.').');
                }
                $antes   = (float)$p['stock_actual'];
                $despues = $antes - $cant;

                // Validación de stock en el servidor (no confiar solo en el navegador)
                if ($despues < 0) {
                    throw new RuntimeException('Stock insuficiente de «'.$p['nombre'].'». Disponible: '.$antes.', solicitado: '.$cant.'.');
                }

                $db->prepare("INSERT INTO venta_detalle (venta_id,producto_id,cantidad,precio_unit,subtotal) VALUES (?,?,?,?,?)")
                   ->execute([$ventaId,$pid,$cant,$precio,$sub]);

                $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")->execute([$despues,$pid]);

                // Sincronizar el stock del almacén principal (Tienda) si el módulo existe
                if ($almacenPrincipal) {
                    $db->prepare("UPDATE stock_almacen SET cantidad=? WHERE almacen_id=? AND producto_id=?")
                       ->execute([$despues, $almacenPrincipal, $pid]);
                }

                $db->prepare("INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id) VALUES (?,?,?,?,?,?,?,?,?,?)")
                   ->execute([$pid,$almacenPrincipal,'salida',$cant,$antes,$despues,$precio,'Venta',$codigo,$user['id']]);
            }

            // Incrementar uso código descuento
            if ($codDescId) {
                $db->prepare("UPDATE codigos_descuento SET usos_actuales=usos_actuales+1 WHERE id=?")->execute([$codDescId]);
            }

            // Si vinieron pagos múltiples, validarlos y guardarlos.
            // Si no vinieron (compatibilidad), armar uno solo con el total.
            if (empty($pagos)) {
                $pagos = [['metodo' => $metPago, 'monto' => round($total, 2)]];
            }
            $sumaPagos = array_sum(array_column($pagos, 'monto'));
            // Debe cubrir el total (con margen de redondeo). Puede ser más si hay vuelto en efectivo.
            if ($sumaPagos + 0.001 < $total) {
                throw new RuntimeException('El monto pagado (S/'.number_format($sumaPagos,2).
                    ') no cubre el total (S/'.number_format($total,2).').');
            }
            foreach ($pagos as $pg) {
                $db->prepare("INSERT INTO venta_pagos (venta_id,metodo,monto) VALUES (?,?,?)")
                   ->execute([$ventaId, $pg['metodo'], $pg['monto']]);
            }

            // Registrar en caja un movimiento por cada método de pago, así el
            // reporte de caja refleja correctamente cuánto entró por cada uno.
            // Cada usuario tiene SU propia caja: se usa la caja abierta del usuario logueado.
            $caja = $db->prepare("SELECT id FROM cajas WHERE estado='abierta' AND usuario_id=? ORDER BY fecha DESC, id DESC LIMIT 1");
            $caja->execute([$user['id']]);
            $cajaId = $caja->fetchColumn();
            if ($cajaId) {
                $metodosCfg = getMetodosPago();
                foreach ($pagos as $pg) {
                    // Si hubo vuelto y este pago es en efectivo, descontarlo del movimiento
                    $montoMov = $pg['monto'];
                    if ($pg['metodo'] === 'efectivo' && $vuelto > 0) {
                        $montoMov = max(0, $pg['monto'] - $vuelto);
                        $vuelto = 0; // ya se aplicó
                    }
                    if ($montoMov <= 0) continue;
                    $lbl = $metodosCfg[$pg['metodo']]['label'] ?? $pg['metodo'];
                    $db->prepare("INSERT INTO movimientos_caja (caja_id,tipo,concepto,monto,referencia,usuario_id) VALUES (?,?,?,?,?,?)")
                       ->execute([$cajaId, 'ingreso', 'Venta '.$codigo.' ('.$lbl.')', $montoMov, $codigo, $user['id']]);
                }
            }

            $db->commit();

            header('Content-Type: application/json');
            echo json_encode(['success'=>true,'codigo'=>$codigo,'total'=>$total,'venta_id'=>$ventaId]);
            exit;

        } catch (\Throwable $e) {
            $db->rollBack();
            header('Content-Type: application/json');
            http_response_code(422);
            echo json_encode(['success'=>false,'error'=>$e->getMessage()]);
            exit;
        }
    }
}

// ── Cargar datos para la vista ────────────────────────────
$clientes = $db->query("SELECT id,codigo,nombre FROM clientes WHERE activo=1 ORDER BY nombre LIMIT 500")->fetchAll();
$vendedoras = $db->query("SELECT id, CONCAT(nombre,' ',apellido) AS nombre FROM usuarios WHERE rol IN ('vendedor','admin') AND activo=1 ORDER BY nombre")->fetchAll();

$pageTitle  = 'Punto de venta — '.APP_NAME;
$breadcrumb = [['label'=>'Ventas','url'=>BASE_URL.'modules/ventas/index.php'],['label'=>'POS','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<h5 class="fw-bold mb-3">Punto de venta</h5>

<div class="row g-3">

  <!-- ═══ IZQUIERDA: Búsqueda + Carrito ═══ -->
  <div class="col-lg-7">

    <!-- Buscador -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">BUSCAR PRODUCTO</h6></div>
      <div class="tr-card-body">
        <div class="input-group mb-2">
          <span class="input-group-text">
            <i data-feather="search" style="width:16px;height:16px"></i>
          </span>
          <input type="text" id="buscar-producto" class="form-control"
                 placeholder="Nombre o código del producto..." autocomplete="off"/>
        </div>
        <div id="resultados-busqueda" class="list-group shadow-sm"></div>
      </div>
    </div>

    <!-- Carrito -->
    <div class="tr-card">
      <div class="tr-card-header">
        <h6 class="mb-0 small fw-semibold">CARRITO</h6>
        <button class="btn btn-outline-danger btn-sm" onclick="limpiarCarrito()">
          🗑 Limpiar
        </button>
      </div>
      <div class="tr-card-body p-0" style="overflow:hidden">
        <div style="overflow-x:auto">
          <table class="tr-table" id="tabla-carrito">
            <thead>
              <tr><th>Producto</th><th>Precio</th><th>Cant.</th><th>Subtotal</th><th></th></tr>
            </thead>
            <tbody id="carrito-body">
              <tr id="carrito-vacio">
                <td colspan="5" class="text-center text-muted py-4">Carrito vacío</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- ═══ DERECHA: Resumen + Pago ═══ -->
  <div class="col-lg-5">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">RESUMEN DE VENTA</h6></div>
      <div class="tr-card-body">

        <!-- Vendedora -->
        <div class="mb-3">
          <label class="tr-form-label">Vendedora</label>
          <select id="sel-vendedora" class="form-select form-select-sm">
            <option value="">— Sin asignar —</option>
            <?php foreach($vendedoras as $v): ?>
            <option value="<?= $v['id'] ?>"
              <?= ($user['rol']==='vendedor' && $user['id']==$v['id']) ? 'selected' : '' ?>>
              <?= sanitize($v['nombre']) ?>
            </option>
            <?php endforeach; ?>
          </select>
        </div>

        <!-- Cliente -->
        <div class="mb-3">
          <label class="tr-form-label">Cliente (opcional)</label>
          <select id="sel-cliente-venta" class="form-select form-select-sm">
            <option value="">— Sin cliente —</option>
            <?php foreach ($clientes as $c): ?>
            <option value="<?= $c['id'] ?>"><?= sanitize($c['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
        </div>

        <!-- Código de descuento -->
        <div class="mb-3">
          <label class="tr-form-label">Código de descuento</label>
          <div class="input-group input-group-sm">
            <input type="text" id="cod-descuento" class="form-control text-uppercase"
                   placeholder="INGRESAR CÓDIGO..."
                   style="font-family:monospace;font-weight:bold;letter-spacing:.06em"/>
            <button type="button" class="btn btn-outline-secondary" onclick="validarCodigo()">
              <i data-feather="check" style="width:13px;height:13px"></i> Aplicar
            </button>
          </div>
          <div id="cod-msg" class="mt-1 small" style="display:none"></div>
          <input type="hidden" id="cod-descuento-id" value=""/>
        </div>

        <!-- Comprobante -->
        <div class="mb-3">
          <label class="tr-form-label">Comprobante</label>
          <select id="tipo-doc" class="form-select form-select-sm">
            <option value="ticket">Ticket</option>
            <option value="boleta">Boleta</option>
            <option value="factura">Factura</option>
            <option value="sin_comprobante">Sin comprobante</option>
          </select>
        </div>

        <!-- Descuento manual -->
        <div class="mb-3">
          <label class="tr-form-label">Descuento adicional (S/)</label>
          <input type="number" id="descuento-global" class="form-control form-control-sm currency-input"
                 value="0" step="0.01" min="0"/>
        </div>

        <!-- Totales -->
        <div class="rounded p-3 mb-3" style="background:#f8fafc;border:1px solid #e5e7eb">
          <div class="d-flex justify-content-between small mb-1">
            <span>Base imponible:</span><span id="txt-subtotal">S/ 0.00</span>
          </div>
          <div class="d-flex justify-content-between small mb-1">
            <span>IGV (18%):</span><span id="txt-igv">S/ 0.00</span>
          </div>
          <div class="d-flex justify-content-between small mb-1 text-danger">
            <span>Descuento:</span><span id="txt-desc">S/ 0.00</span>
          </div>
          <hr class="my-2"/>
          <div class="d-flex justify-content-between fw-bold fs-5">
            <span>TOTAL:</span><span id="txt-total">S/ 0.00</span>
          </div>
        </div>

        <!-- Pagos (múltiples) -->
        <div class="mb-3">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <label class="tr-form-label mb-0">Pagos</label>
            <button type="button" class="btn btn-sm btn-outline-primary" id="btn-add-pago">
              + Agregar otro pago
            </button>
          </div>
          <div id="lista-pagos"></div>
          <div class="d-flex justify-content-between mt-2 small">
            <span class="text-muted">Total pagado:</span>
            <span class="fw-bold" id="txt-pagado">S/ 0.00</span>
          </div>
          <div class="d-flex justify-content-between small">
            <span class="text-muted">Diferencia:</span>
            <span class="fw-bold" id="txt-diferencia">S/ 0.00</span>
          </div>
          <div class="mt-1 small text-success" id="txt-vuelto"></div>
        </div>

        <button class="btn btn-primary w-100 btn-lg" onclick="procesarVenta()">
          <i data-feather="check-circle" style="width:18px;height:18px"></i> Confirmar venta
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal ticket -->
<div class="modal fade" id="modal-ticket" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h6 class="modal-title">✅ Venta registrada</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <div class="fs-1">🎉</div>
        <div id="ticket-codigo" class="fw-bold fs-5 mt-2"></div>
        <div id="ticket-total" class="text-muted"></div>
        <div class="d-flex gap-2 justify-content-center mt-3">
          <button class="btn btn-primary btn-sm" onclick="nuevaVenta()">Nueva venta</button>
          <a id="btn-imprimir-ticket" href="#" target="_blank"
             class="btn btn-outline-secondary btn-sm">Imprimir</a>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
const BASE_URL_JS = <?php echo json_encode(BASE_URL); ?>;
const METODOS_PAGO = <?php echo json_encode(getMetodosPago()); ?>;
let carrito = [];
let descuentoCodigo = 0;  // monto de descuento del código aplicado

// ── BUSCAR PRODUCTO ──────────────────────────────────────
let timeoutBusq;
document.getElementById('buscar-producto').addEventListener('input', function() {
  clearTimeout(timeoutBusq);
  const q = this.value.trim();
  const div = document.getElementById('resultados-busqueda');
  if (q.length < 2) { div.innerHTML = ''; return; }
  timeoutBusq = setTimeout(() => {
    fetch(BASE_URL_JS + 'modules/ventas/api_productos.php?accion=buscar&q=' + encodeURIComponent(q), {cache:'no-store'})
      .then(r => r.json())
      .then(resp => {
        const data = Array.isArray(resp) ? resp : (resp.data || []);
        if (!data.length) {
          div.innerHTML = '<div class="list-group-item text-muted small py-2">Sin resultados para "' + q + '"</div>';
          return;
        }
        div.innerHTML = data.map(p => {
          return '<button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-2"'
               + ' onclick="agregarCarrito(' + JSON.stringify(p).replace(/"/g,'&quot;') + ')">'
               + '<div><div class="fw-semibold small">' + p.nombre + '</div>'
               + '<div class="text-muted" style="font-size:11px">' + p.codigo + '</div></div>'
               + '<div class="text-end"><div class="text-primary fw-bold">S/ ' + parseFloat(p.precio_venta).toFixed(2) + '</div>'
               + '<div class="text-muted small">Stock: ' + p.stock_actual + '</div></div>'
               + '</button>';
        }).join('');
      })
      .catch(err => {
        div.innerHTML = '<div class="list-group-item text-danger small py-2">❌ Error de conexión: ' + err.message + '</div>';
      });
  }, 280);
});

function agregarCarrito(p) {
  const idx = carrito.findIndex(i => i.id == p.id);
  if (idx >= 0) carrito[idx].cantidad++;
  else carrito.push({id:p.id, nombre:p.nombre, precio:parseFloat(p.precio_venta), cantidad:1, stock:parseFloat(p.stock_actual)});
  renderCarrito();
  document.getElementById('buscar-producto').value = '';
  document.getElementById('resultados-busqueda').innerHTML = '';
}

// ── CARRITO ───────────────────────────────────────────────
function renderCarrito() {
  const tbody = document.getElementById('carrito-body');
  if (!carrito.length) {
    tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">Carrito vacío</td></tr>';
    calcularTotales(); return;
  }
  tbody.innerHTML = carrito.map((item, i) =>
    '<tr>'
    + '<td class="small">' + item.nombre + '</td>'
    + '<td><input type="number" class="form-control form-control-sm" style="width:80px"'
    +    ' value="' + item.precio.toFixed(2) + '" step="0.01"'
    +    ' onchange="carrito[' + i + '].precio=parseFloat(this.value)||0;renderCarrito()"/></td>'
    + '<td><input type="number" class="form-control form-control-sm" style="width:65px"'
    +    ' value="' + item.cantidad + '" min="1" max="' + item.stock + '"'
    +    ' onchange="carrito[' + i + '].cantidad=parseInt(this.value)||1;renderCarrito()"/></td>'
    + '<td class="fw-semibold">S/ ' + (item.precio*item.cantidad).toFixed(2) + '</td>'
    + '<td><button class="btn btn-sm btn-outline-danger py-0" onclick="carrito.splice(' + i + ',1);renderCarrito()">✕</button></td>'
    + '</tr>'
  ).join('');
  calcularTotales();
}

// ── TOTALES ───────────────────────────────────────────────
function calcularTotales() {
  const descManual = parseFloat(document.getElementById('descuento-global').value) || 0;
  const descTotal  = descManual + descuentoCodigo;
  let subBruto = Math.max(0, carrito.reduce((s,i) => s + i.precio*i.cantidad, 0) - descTotal);
  const base   = subBruto / 1.18;
  const igv    = subBruto - base;
  const total  = subBruto;
  document.getElementById('txt-subtotal').textContent = 'S/ ' + base.toFixed(2);
  document.getElementById('txt-igv').textContent      = 'S/ ' + igv.toFixed(2);
  document.getElementById('txt-desc').textContent     = 'S/ ' + descTotal.toFixed(2);
  document.getElementById('txt-total').textContent    = 'S/ ' + total.toFixed(2);
  actualizarPagos();
}

document.getElementById('descuento-global').addEventListener('input', calcularTotales);

// ── CÓDIGO DE DESCUENTO ───────────────────────────────────
function validarCodigo() {
  const cod    = document.getElementById('cod-descuento').value.trim().toUpperCase();
  const vidEl  = document.getElementById('sel-vendedora');
  const vidId  = vidEl ? vidEl.value : '';
  const msgEl  = document.getElementById('cod-msg');
  msgEl.style.display = '';
  document.getElementById('cod-descuento-id').value = '';
  descuentoCodigo = 0;

  if (!cod) { msgEl.innerHTML = '<span class="text-muted">Ingresa un código</span>'; calcularTotales(); return; }

  fetch(BASE_URL_JS + 'modules/ventas/pos.php?api=validar_codigo&codigo=' + encodeURIComponent(cod) + '&vendedor_id=' + vidId)
    .then(r => r.json())
    .then(data => {
      if (!data.valido) {
        msgEl.innerHTML = '<span class="text-danger">❌ ' + data.msg + '</span>';
        descuentoCodigo = 0;
      } else {
        const subtotalBruto = carrito.reduce((s,i) => s + i.precio*i.cantidad, 0);
        if (data.tipo === 'porcentaje') {
          descuentoCodigo = Math.round(subtotalBruto * data.valor / 100 * 100) / 100;
          msgEl.innerHTML = '<span class="text-success">✅ ' + data.valor + '% descuento aplicado = S/ ' + descuentoCodigo.toFixed(2) + '</span>';
        } else {
          descuentoCodigo = data.valor;
          msgEl.innerHTML = '<span class="text-success">✅ S/ ' + data.valor.toFixed(2) + ' de descuento aplicado</span>';
        }
        if (data.descripcion) msgEl.innerHTML += ' <span class="text-muted">— ' + data.descripcion + '</span>';
        document.getElementById('cod-descuento-id').value = data.id;
      }
      calcularTotales();
    });
}

document.getElementById('cod-descuento').addEventListener('keydown', function(e) {
  if (e.key === 'Enter') { e.preventDefault(); validarCodigo(); }
});

document.getElementById('sel-vendedora')?.addEventListener('change', function() {
  document.getElementById('cod-descuento').value = '';
  document.getElementById('cod-descuento-id').value = '';
  document.getElementById('cod-msg').style.display = 'none';
  descuentoCodigo = 0;
  calcularTotales();
});

// ── LIMPIAR ───────────────────────────────────────────────
function limpiarCarrito() {
  carrito = [];
  pagos = [{ metodo:'efectivo', monto:0 }];
  pintarPagos();
  descuentoCodigo = 0;
  document.getElementById('cod-descuento').value = '';
  document.getElementById('cod-descuento-id').value = '';
  document.getElementById('cod-msg').style.display = 'none';
  document.getElementById('descuento-global').value = '0';
  renderCarrito();
}

// ── PAGOS MÚLTIPLES ───────────────────────────────────────
function obtenerTotal(){
  return parseFloat(document.getElementById('txt-total').textContent.replace('S/ ','')) || 0;
}

function pintarPagos(){
  const lista = document.getElementById('lista-pagos');
  lista.innerHTML = '';
  pagos.forEach((p, i) => {
    const row = document.createElement('div');
    row.className = 'd-flex gap-2 mb-2 align-items-center';
    let opts = '';
    Object.entries(METODOS_PAGO).forEach(([k,v]) => {
      opts += `<option value="${k}" ${p.metodo===k?'selected':''}>${v.icon} ${v.label}</option>`;
    });
    row.innerHTML = `
      <select class="form-select form-select-sm flex-shrink-0" style="width:140px" data-i="${i}" data-f="metodo">
        ${opts}
      </select>
      <input type="number" class="form-control form-control-sm" step="0.01" min="0"
             placeholder="Monto" value="${p.monto||''}" data-i="${i}" data-f="monto">
      ${pagos.length>1?`<button type="button" class="btn btn-sm btn-outline-danger" data-i="${i}" data-f="del">×</button>`:''}
    `;
    lista.appendChild(row);
  });
  // Listeners (delegación simple)
  lista.querySelectorAll('[data-i]').forEach(el => {
    const i = +el.dataset.i, f = el.dataset.f;
    if (f === 'del') el.addEventListener('click', () => { pagos.splice(i,1); pintarPagos(); actualizarPagos(); });
    else el.addEventListener('input', () => {
      if (f === 'metodo') pagos[i].metodo = el.value;
      else                pagos[i].monto  = parseFloat(el.value) || 0;
      actualizarPagos();
    });
  });
}

function actualizarPagos(){
  const total  = obtenerTotal();
  const pagado = pagos.reduce((s,p) => s + (parseFloat(p.monto)||0), 0);
  const dif    = +(total - pagado).toFixed(2);
  document.getElementById('txt-pagado').textContent     = 'S/ ' + pagado.toFixed(2);
  const elDif = document.getElementById('txt-diferencia');
  elDif.textContent  = 'S/ ' + dif.toFixed(2);
  elDif.classList.toggle('text-danger', dif > 0.001);
  elDif.classList.toggle('text-success', Math.abs(dif) <= 0.001);
  // Vuelto solo aplica si el pago en efectivo cubre la diferencia (cliente paga de más)
  const efectivo = pagos.filter(p => p.metodo === 'efectivo').reduce((s,p) => s + (parseFloat(p.monto)||0), 0);
  const vuelto = pagado - total;
  document.getElementById('txt-vuelto').textContent =
    (vuelto > 0.001 && efectivo > 0) ? 'Vuelto: S/ ' + vuelto.toFixed(2) : '';
}

// Inicializar con un pago en efectivo
let pagos = [{ metodo:'efectivo', monto:0 }];
pintarPagos();

document.getElementById('btn-add-pago').addEventListener('click', () => {
  // Sugerir como monto la diferencia pendiente
  const total  = obtenerTotal();
  const pagado = pagos.reduce((s,p) => s + (parseFloat(p.monto)||0), 0);
  const dif    = Math.max(0, +(total - pagado).toFixed(2));
  // Sugerir un método distinto al último
  const usados = pagos.map(p => p.metodo);
  const sugerido = Object.keys(METODOS_PAGO).find(k => !usados.includes(k)) || 'yape';
  pagos.push({ metodo: sugerido, monto: dif });
  pintarPagos();
  actualizarPagos();
});

// ── PROCESAR VENTA ────────────────────────────────────────
function procesarVenta() {
  if (!carrito.length) { alert('Agrega productos al carrito.'); return; }

  // Validar pagos
  const total  = obtenerTotal();
  const pagosValidos = pagos.filter(p => parseFloat(p.monto) > 0);
  if (!pagosValidos.length) { alert('Ingresa el monto pagado.'); return; }
  const pagado = pagosValidos.reduce((s,p) => s + parseFloat(p.monto), 0);
  if (pagado + 0.001 < total) {
    alert('Falta cubrir S/ ' + (total - pagado).toFixed(2) + '. Agrega otro pago o ajusta el monto.');
    return;
  }
  // Si paga de más, solo se permite si hay efectivo (vuelto)
  const tieneEfectivo = pagosValidos.some(p => p.metodo === 'efectivo');
  if (pagado - total > 0.001 && !tieneEfectivo) {
    alert('El monto pagado excede el total. Solo se permite vuelto cuando hay efectivo.');
    return;
  }

  const metodoCabecera = pagosValidos.length === 1 ? pagosValidos[0].metodo : 'mixto';
  const descMan  = parseFloat(document.getElementById('descuento-global').value) || 0;
  const descTotal= descMan + descuentoCodigo;
  const payload  = new FormData();
  payload.append('action',              'procesar_venta');
  payload.append('items',               JSON.stringify(carrito));
  payload.append('cliente_id',          document.getElementById('sel-cliente-venta').value);
  payload.append('vendedor_id',         document.getElementById('sel-vendedora').value || '');
  payload.append('codigo_descuento_id', document.getElementById('cod-descuento-id').value || '');
  payload.append('tipo_doc',            document.getElementById('tipo-doc').value);
  payload.append('metodo_pago',         metodoCabecera);
  payload.append('pagos',               JSON.stringify(pagosValidos));
  payload.append('descuento_global',    descTotal.toString());
  payload.append('monto_pagado',        pagado.toString());

  fetch(BASE_URL_JS + 'modules/ventas/pos.php', {method:'POST', body:payload})
    .then(r => r.json())
    .then(data => {
      if (data.success) {
        document.getElementById('ticket-codigo').textContent = data.codigo;
        document.getElementById('ticket-total').textContent  = 'Total: S/ ' + parseFloat(data.total).toFixed(2);
        document.getElementById('btn-imprimir-ticket').href  = BASE_URL_JS + 'modules/ventas/ticket.php?id=' + data.venta_id + '&print=1';
        new bootstrap.Modal(document.getElementById('modal-ticket')).show();
        limpiarCarrito();
      } else {
        alert(data.error || 'Error al procesar la venta.');
      }
    })
    .catch(err => alert('Error de conexión: ' + err.message));
}

function nuevaVenta() {
  bootstrap.Modal.getInstance(document.getElementById('modal-ticket'))?.hide();
  limpiarCarrito();
}
</script>
<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
