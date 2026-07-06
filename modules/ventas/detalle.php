<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
$db = getDB();

$sunatEnabled = false;
try {
    require_once __DIR__ . '/../../includes/config_sunat.php';
    require_once __DIR__ . '/../../includes/sunat/SunatService.php';
    $sunatEnabled = true;
} catch (Throwable $e) { /* SUNAT module not available */ }

// Acepta: ?id=123  O  ?codigo=VTA-2024-0001  O  ?ref=VTA-2024-0001
$id     = (int)($_GET['id']     ?? 0);
$codigo = trim($_GET['codigo']  ?? $_GET['ref'] ?? '');

// Si vino un código en lugar de id, buscar el id real
if (!$id && $codigo) {
    $busca = $db->prepare("SELECT id FROM ventas WHERE codigo = ? LIMIT 1");
    $busca->execute([$codigo]);
    $id = (int)$busca->fetchColumn();
}

$venta = $db->prepare("
    SELECT v.*, c.nombre as cliente_nombre, c.ruc_dni, c.telefono,
           CONCAT(u.nombre,' ',u.apellido) as vendedor_nombre
    FROM ventas v
    LEFT JOIN clientes c ON c.id=v.cliente_id
    JOIN usuarios u ON u.id=v.usuario_id
    WHERE v.id=?");
$venta->execute([$id]);
$venta = $venta->fetch();
if (!$venta) { setFlash('danger','Venta no encontrada (id='.$id.', codigo='.$codigo.')'); redirect(BASE_URL.'modules/ventas/index.php'); }

$detalle = $db->prepare("
    SELECT vd.*, p.nombre as prod_nombre, p.codigo as prod_codigo, p.marca
    FROM venta_detalle vd
    JOIN productos p ON p.id=vd.producto_id
    WHERE vd.venta_id=? ORDER BY vd.id");
$detalle->execute([$id]);
$detalle = $detalle->fetchAll();

// Pagos múltiples de la venta (si el módulo está instalado)
$pagosVenta = [];
try {
    $st = $db->prepare("SELECT metodo, monto FROM venta_pagos WHERE venta_id=? ORDER BY id");
    $st->execute([$id]);
    $pagosVenta = $st->fetchAll();
} catch (\Throwable $e) { /* tabla aún no creada */ }

// SUNAT actions
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $sunatEnabled) {
    $action = $_POST['action'] ?? '';

    if ($action === 'sunat_regenerar') {
        $svc    = new SunatService($db);
        $result = $svc->generarXml($id);
        setFlash($result['ok'] ? 'success' : 'danger', $result['mensaje']);
        redirect(BASE_URL . 'modules/ventas/detalle.php?id=' . $id);
    }

    if ($action === 'sunat_enviar') {
        $svc    = new SunatService($db);
        $result = $svc->enviarSunat($id);
        setFlash($result['ok'] ? 'success' : 'danger', $result['mensaje']);
        redirect(BASE_URL . 'modules/ventas/detalle.php?id=' . $id);
    }

    if ($action === 'sunat_descargar_xml') {
        $row = $db->prepare("SELECT sunat_xml, serie_doc, num_doc, tipo_doc FROM ventas WHERE id=?");
        $row->execute([$id]);
        $row = $row->fetch();
        if ($row && !empty($row['sunat_xml'])) {
            $filename = SunatService::nombreArchivo($row) . '.xml';
            header('Content-Type: application/xml; charset=utf-8');
            header('Content-Disposition: attachment; filename="' . $filename . '"');
            // XML se guarda crudo (no base64)
            echo $row['sunat_xml'];
            exit;
        }
        setFlash('warning', 'No hay XML disponible para descargar.');
        redirect(BASE_URL . 'modules/ventas/detalle.php?id=' . $id);
    }

    if ($action === 'sunat_descargar_cdr') {
        $row = $db->prepare("SELECT sunat_cdr, serie_doc, num_doc, tipo_doc FROM ventas WHERE id=?");
        $row->execute([$id]);
        $row = $row->fetch();
        if ($row && !empty($row['sunat_cdr'])) {
            $filename = 'R-' . SunatService::nombreArchivo($row) . '.zip';
            header('Content-Type: application/zip');
            header('Content-Disposition: attachment; filename="' . $filename . '"');
            echo base64_decode($row['sunat_cdr']);
            exit;
        }
        setFlash('warning', 'No hay CDR disponible para descargar.');
        redirect(BASE_URL . 'modules/ventas/detalle.php?id=' . $id);
    }
}

// Anular venta
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action']??'') === 'anular') {
    $user = currentUser();

    // ¿Existe el módulo de almacenes? Para sincronizar la Tienda.
    $almacenPrincipal = null;
    try {
        $almacenPrincipal = $db->query("SELECT id FROM almacenes WHERE principal=1 LIMIT 1")->fetchColumn() ?: null;
    } catch (\Throwable $e) { /* módulo de traslados no instalado */ }

    // Evitar anular dos veces (devolvería stock de más)
    if (($venta['estado'] ?? '') === 'anulada') {
        setFlash('warning','Esta venta ya estaba anulada.');
        redirect(BASE_URL.'modules/ventas/detalle.php?id='.$id);
    }

    // Toda la anulación es atómica: o se revierte todo, o nada.
    $db->beginTransaction();
    try {
        $db->prepare("UPDATE ventas SET estado='anulada' WHERE id=?")->execute([$id]);
        foreach ($detalle as $d) {
            $s = $db->prepare("SELECT stock_actual FROM productos WHERE id=? FOR UPDATE"); $s->execute([$d['producto_id']]);
            $antes = (float)$s->fetchColumn();
            $despues = $antes + $d['cantidad'];
            $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")->execute([$despues,$d['producto_id']]);
            if ($almacenPrincipal) {
                $db->prepare("UPDATE stock_almacen SET cantidad=? WHERE almacen_id=? AND producto_id=?")
                   ->execute([$despues, $almacenPrincipal, $d['producto_id']]);
            }
            $db->prepare("INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id) VALUES (?,?,?,?,?,?,?,?,?,?)")
               ->execute([$d['producto_id'],$almacenPrincipal,'devolucion',$d['cantidad'],$antes,$despues,$d['precio_unit'],'Venta anulada',$venta['codigo'],$user['id']]);
        }

        // Revertir el impacto en caja: por cada ingreso que generó esta venta se registra
        // el egreso opuesto (mismo método y misma caja), para que el cuadre no descuadre.
        $movs = $db->prepare("SELECT * FROM movimientos_caja WHERE referencia=? AND tipo='ingreso'");
        $movs->execute([$venta['codigo']]);
        foreach ($movs->fetchAll() as $mv) {
            $metodo = $mv['metodo_pago'] ?? 'efectivo';
            insertMovimientoCaja($db, (int)$mv['caja_id'], 'egreso', 'Anulación venta '.$venta['codigo'],
                                 (float)$mv['monto'], $venta['codigo'], (int)$user['id'], $metodo);
        }

        $db->commit();
        setFlash('success','Venta anulada: stock restaurado y caja ajustada.');
    } catch (\Throwable $e) {
        $db->rollBack();
        setFlash('danger','No se pudo anular la venta: '.$e->getMessage());
    }
    redirect(BASE_URL.'modules/ventas/detalle.php?id='.$id);
}

$pageTitle  = $venta['codigo'].' — '.APP_NAME;
$breadcrumb = [
    ['label'=>'Historial ventas','url'=>BASE_URL.'modules/ventas/index.php'],
    ['label'=>$venta['codigo'],'url'=>null],
];
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h4 class="fw-bold mb-0"><?= sanitize($venta['codigo']) ?></h4>
    <span class="badge bg-<?= $venta['estado']==='completada'?'success':($venta['estado']==='anulada'?'danger':'warning') ?>"><?= ucfirst($venta['estado']) ?></span>
    <span class="text-muted small ms-2"><?= formatDateTime($venta['created_at']) ?></span>
  </div>
  <div class="d-flex gap-2">
    <?php if($venta['estado']==='completada'): ?>
    <form method="POST" class="d-inline">
      <input type="hidden" name="action" value="anular"/>
      <button type="submit" class="btn btn-outline-danger btn-sm"
              data-confirm="¿Anular esta venta? Se restaurará el stock.">Anular venta</button>
    </form>
    <?php endif; ?>
    <a href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $id ?>" target="_blank" class="btn btn-outline-secondary btn-sm">
      <i data-feather="printer" style="width:14px;height:14px"></i> Imprimir
    </a>
    <a href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $id ?>&pdf=1" target="_blank" class="btn btn-primary btn-sm">
      <i data-feather="file-text" style="width:14px;height:14px"></i> PDF
    </a>
    <a href="<?= BASE_URL ?>modules/ventas/index.php" class="btn btn-outline-secondary btn-sm">← Volver</a>
  </div>
</div>

<div class="row g-3">
  <div class="col-lg-8">
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">PRODUCTOS VENDIDOS</h6></div>
      <div class="tr-card-body p-0">
        <table class="tr-table">
          <thead><tr><th>Código</th><th>Producto</th><th>Marca</th><th>Cantidad</th><th>P. Unit.</th><th>Descuento</th><th>Subtotal</th></tr></thead>
          <tbody>
            <?php foreach($detalle as $d): ?>
            <tr>
              <td><code class="small"><?= sanitize($d['prod_codigo']) ?></code></td>
              <td class="fw-semibold"><?= sanitize($d['prod_nombre']) ?></td>
              <td class="small text-muted"><?= sanitize($d['marca'] ?? '—') ?></td>
              <td><?= number_format($d['cantidad'],2) ?></td>
              <td><?= formatMoney($d['precio_unit']) ?></td>
              <td><?= ($d['descuento']??0)>0 ? formatMoney($d['descuento']) : '—' ?></td>
              <td class="fw-semibold"><?= formatMoney($d['subtotal']) ?></td>
            </tr>
            <?php endforeach; ?>
            <?php if(empty($detalle)): ?>
            <tr><td colspan="7" class="text-center text-muted py-3">Sin detalle de productos</td></tr>
            <?php endif; ?>
          </tbody>
          <tfoot>
            <tr class="table-light">
              <td colspan="5"></td>
              <td class="small text-muted">Base imponible:</td>
              <td class="fw-semibold"><?= formatMoney($venta['subtotal']) ?></td>
            </tr>
            <?php if($venta['descuento']>0): ?>
            <tr class="table-light">
              <td colspan="5"></td>
              <td class="small text-danger">Descuento:</td>
              <td class="fw-semibold text-danger">-<?= formatMoney($venta['descuento']) ?></td>
            </tr>
            <?php endif; ?>
            <tr class="table-light">
              <td colspan="5"></td>
              <td class="small text-muted">IGV (18%):</td>
              <td class="fw-semibold"><?= formatMoney($venta['igv']) ?></td>
            </tr>
            <tr class="table-warning">
              <td colspan="5"></td>
              <td class="fw-bold">TOTAL:</td>
              <td class="fw-bold fs-5"><?= formatMoney($venta['total']) ?></td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">DATOS DE LA VENTA</h6></div>
      <div class="tr-card-body">
        <?php
        $metCfg = function_exists('getMetodosPago') ? getMetodosPago() : [];
        $rows = [
            'Código'       => $venta['codigo'],
            'Vendedor'     => $venta['vendedor_nombre'],
            'Cliente'      => $venta['cliente_nombre'] ?? '— Consumidor final —',
            'DNI/RUC'      => $venta['ruc_dni']    ?? '—',
            'Teléfono'     => $venta['telefono']   ?? '—',
            'Comprobante'  => ucfirst($venta['tipo_doc']),
        ];
        foreach($rows as $label => $val): ?>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted"><?= $label ?></span>
          <span class="fw-semibold text-end"><?= sanitize((string)$val) ?></span>
        </div>
        <?php endforeach; ?>

        <!-- Desglose de pagos -->
        <div class="small mb-2 pb-1 border-bottom">
          <div class="text-muted mb-1">Pago<?= count($pagosVenta)>1 ? 's' : '' ?></div>
          <?php if (count($pagosVenta) >= 1): ?>
            <?php foreach ($pagosVenta as $pg): $lbl = $metCfg[$pg['metodo']]['label'] ?? ucfirst($pg['metodo']); ?>
            <div class="d-flex justify-content-between ms-2">
              <span><?= sanitize($lbl) ?></span>
              <span class="fw-semibold"><?= formatMoney($pg['monto']) ?></span>
            </div>
            <?php endforeach; ?>
          <?php else: ?>
            <div class="d-flex justify-content-between ms-2">
              <span><?= sanitize(ucfirst($venta['metodo_pago'])) ?></span>
              <span class="fw-semibold"><?= formatMoney($venta['monto_pagado'] ?? $venta['total']) ?></span>
            </div>
          <?php endif; ?>
        </div>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Vuelto</span>
          <span class="fw-semibold text-end"><?= formatMoney($venta['vuelto'] ?? 0) ?></span>
        </div>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Fecha</span>
          <span class="fw-semibold text-end"><?= sanitize(formatDateTime($venta['created_at'])) ?></span>
        </div>
      </div>
    </div>

    <?php if ($sunatEnabled && in_array($venta['tipo_doc'], ['factura','boleta']) && $venta['estado'] !== 'anulada'): ?>
    <?php
        $se  = $venta['sunat_estado'] ?? null;
        $badgeClass = match($se) {
            'aceptado'  => 'success',
            'rechazado' => 'danger',
            'pendiente' => 'warning',
            default     => 'secondary',
        };
        $badgeLabel = match($se) {
            'aceptado'  => 'Aceptado',
            'rechazado' => 'Rechazado',
            'pendiente' => 'Pendiente de envío',
            default     => 'No emitido',
        };
    ?>
    <div class="tr-card mt-3">
      <div class="tr-card-header d-flex justify-content-between align-items-center">
        <h6 class="mb-0 small fw-semibold">SUNAT</h6>
        <span class="badge bg-<?= $badgeClass ?>"><?= $badgeLabel ?></span>
      </div>
      <div class="tr-card-body">
        <?php if ($venta['sunat_mensaje']): ?>
        <p class="small text-muted mb-2"><?= sanitize($venta['sunat_mensaje']) ?></p>
        <?php endif; ?>

        <div class="d-flex flex-column gap-2">
          <?php if ($se !== 'aceptado'): ?>
          <form method="POST">
            <input type="hidden" name="action" value="sunat_regenerar"/>
            <button type="submit" class="btn btn-outline-primary btn-sm w-100">
              <i data-feather="file-text" style="width:13px;height:13px"></i>
              <?= $se === null ? 'Generar XML' : 'Regenerar XML' ?>
            </button>
          </form>
          <?php endif; ?>

          <?php if (!empty($venta['sunat_xml']) && $se !== 'aceptado'): ?>
          <form method="POST">
            <input type="hidden" name="action" value="sunat_enviar"/>
            <button type="submit" class="btn btn-success btn-sm w-100"
                    data-confirm="¿Enviar este comprobante a SUNAT?">
              <i data-feather="send" style="width:13px;height:13px"></i> Enviar a SUNAT
            </button>
          </form>
          <?php endif; ?>

          <?php if (!empty($venta['sunat_xml'])): ?>
          <form method="POST">
            <input type="hidden" name="action" value="sunat_descargar_xml"/>
            <button type="submit" class="btn btn-outline-secondary btn-sm w-100">
              <i data-feather="download" style="width:13px;height:13px"></i> Descargar XML
            </button>
          </form>
          <?php endif; ?>

          <?php if (!empty($venta['sunat_cdr'])): ?>
          <form method="POST">
            <input type="hidden" name="action" value="sunat_descargar_cdr"/>
            <button type="submit" class="btn btn-outline-secondary btn-sm w-100">
              <i data-feather="download" style="width:13px;height:13px"></i> Descargar CDR
            </button>
          </form>
          <?php endif; ?>

          <?php if ($se === 'aceptado'): ?>
          <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php?accion=nueva&venta_id=<?= $id ?>"
             class="btn btn-outline-warning btn-sm w-100">
            <i data-feather="minus-circle" style="width:13px;height:13px"></i> Nueva nota de crédito
          </a>
          <?php endif; ?>
        </div>
      </div>
    </div>
    <?php endif; ?>

  </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
