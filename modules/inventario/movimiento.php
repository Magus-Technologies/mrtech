<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);
$db   = getDB();
$id   = (int)($_GET['id'] ?? 0);
$user = currentUser();

$prod = $db->prepare("SELECT p.*, c.nombre as cat_nombre FROM productos p JOIN categorias c ON c.id=p.categoria_id WHERE p.id=?");
$prod->execute([$id]);
$prod = $prod->fetch();
if (!$prod) { setFlash('danger','Producto no encontrado'); redirect(BASE_URL.'modules/inventario/index.php'); }

// Cargar almacenes activos
$almacenes = [];
$almPrincipalId = null;
try {
    $almacenes = $db->query("SELECT id, codigo, nombre, principal FROM almacenes WHERE activo=1 ORDER BY principal DESC, nombre")->fetchAll();
    foreach ($almacenes as $a) { if ($a['principal']) $almPrincipalId = (int)$a['id']; }
} catch (\Throwable $e) { /* módulo no instalado */ }

// Stock por almacén para este producto
$stockPorAlmacen = [];
if ($almacenes) {
    $stSa = $db->prepare("SELECT almacen_id, cantidad FROM stock_almacen WHERE producto_id=?");
    $stSa->execute([$id]);
    foreach ($stSa->fetchAll() as $sa) {
        $stockPorAlmacen[(int)$sa['almacen_id']] = (float)$sa['cantidad'];
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $tipo     = $_POST['tipo'];
    $cantidad = (float)$_POST['cantidad'];
    $precioU  = (float)($_POST['precio_unit'] ?? 0);
    $motivo   = trim($_POST['motivo'] ?? '');
    $ref      = trim($_POST['referencia'] ?? '');
    $almId   = (int)($_POST['almacen_id'] ?? 0) ?: $almPrincipalId;

    if ($cantidad <= 0) { setFlash('danger','La cantidad debe ser mayor a 0.'); redirect(BASE_URL.'modules/inventario/movimiento.php?id='.$id); }

    // Determinar stock antes/después según el almacén
    if ($almId && $almacenes) {
        // Leer stock del almacén seleccionado
        $antes = $stockPorAlmacen[$almId] ?? 0;
    } else {
        // Sin módulo de almacenes: usar stock_actual global
        $antes = (float)$prod['stock_actual'];
    }

    if ($tipo === 'entrada') {
        $despues = $antes + $cantidad;
    } else {
        $despues = $antes - $cantidad;
    }

    if ($despues < 0) { setFlash('danger','No hay suficiente stock en este almacén para esta salida.'); redirect(BASE_URL.'modules/inventario/movimiento.php?id='.$id); }

    // Actualizar stock_almacen del almacén seleccionado
    if ($almId && $almacenes) {
        $db->prepare("INSERT INTO stock_almacen (almacen_id,producto_id,cantidad) VALUES (?,?,?) ON DUPLICATE KEY UPDATE cantidad=?")
           ->execute([$almId, $id, $despues, $despues]);

        // Si el almacén es el principal, sincronizar productos.stock_actual
        if ($almId === $almPrincipalId) {
            $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")->execute([$despues, $id]);
        }
    } else {
        // Sin módulo de almacenes: actualizar directamente
        $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")->execute([$despues, $id]);
    }

    // Kardex CON almacen_id
    $db->prepare("INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id) VALUES (?,?,?,?,?,?,?,?,?,?)")
       ->execute([$id, $almId ?: null, $tipo, $cantidad, $antes, $despues, $precioU, $motivo, $ref, $user['id']]);

    $nombAlm = '';
    foreach ($almacenes as $a) { if ((int)$a['id'] === $almId) { $nombAlm = $a['nombre']; break; } }
    setFlash('success', ucfirst($tipo).' registrada' . ($nombAlm ? ' en '.$nombAlm : '') . '. Nuevo stock: '.$despues.' '.$prod['unidad']);
    redirect(BASE_URL.'modules/inventario/movimiento.php?id='.$id);
}

// Historial reciente del producto
$historial = $db->prepare("
    SELECT k.*, CONCAT(u.nombre,' ',u.apellido) as usr, a.nombre as alm_nombre, a.codigo as alm_codigo
    FROM kardex k
    JOIN usuarios u ON u.id=k.usuario_id
    LEFT JOIN almacenes a ON a.id=k.almacen_id
    WHERE k.producto_id=? ORDER BY k.created_at DESC LIMIT 15");
$historial->execute([$id]);
$historial = $historial->fetchAll();

$pageTitle  = 'Entrada/Salida — '.APP_NAME;
$breadcrumb = [
    ['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],
    ['label'=>sanitize($prod['nombre']),'url'=>BASE_URL.'modules/inventario/editar.php?id='.$id],
    ['label'=>'Movimiento','url'=>null],
];
require_once __DIR__ . '/../../includes/header.php';
?>
<h5 class="fw-bold mb-1">Entrada / Salida de stock</h5>
<p class="text-muted mb-4"><?= sanitize($prod['nombre']) ?> — <code><?= sanitize($prod['codigo']) ?></code></p>

<div class="row g-3">
  <div class="col-lg-5">

    <!-- Stock actual -->
    <div class="tr-card mb-3">
      <div class="tr-card-body">
        <div class="row g-2 text-center">
          <div class="col-4">
            <div class="fw-bold fs-3 <?= $prod['stock_actual'] <= $prod['stock_minimo'] ? 'text-danger' : 'text-success' ?>"><?= number_format($prod['stock_actual'],2) ?></div>
            <div class="text-muted small">Stock Tienda</div>
          </div>
          <div class="col-4">
            <div class="fw-bold fs-5 text-warning"><?= number_format($prod['stock_minimo'],2) ?></div>
            <div class="text-muted small">Mínimo</div>
          </div>
          <div class="col-4">
            <div class="fw-bold fs-5"><?= formatMoney($prod['precio_venta']) ?></div>
            <div class="text-muted small">P. Venta</div>
          </div>
        </div>
        <?php if($prod['stock_actual'] <= $prod['stock_minimo']): ?>
        <div class="alert alert-danger mt-2 mb-0 py-1 small text-center">⚠️ Stock en mínimo o por debajo</div>
        <?php endif; ?>

        <?php if ($almacenes): ?>
        <hr class="my-3">
        <div class="tr-section-title mb-2">Stock por local</div>
        <div class="d-flex flex-wrap gap-2">
          <?php foreach ($almacenes as $a):
            $stk = $stockPorAlmacen[(int)$a['id']] ?? 0;
          ?>
          <div class="p-2 rounded text-center <?= (int)$a['id']===$almPrincipalId?'bg-success bg-opacity-10':'bg-light' ?>" style="min-width:90px">
            <div class="small text-muted"><?= sanitize($a['codigo']) ?></div>
            <div class="fw-bold <?= $stk > 0 ? 'text-success' : 'text-muted' ?>"><?= number_format($stk, 2) ?></div>
            <div class="small" style="font-size:10px"><?= sanitize($a['nombre']) ?></div>
          </div>
          <?php endforeach; ?>
        </div>
        <?php endif; ?>
      </div>
    </div>

    <!-- Formulario -->
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">REGISTRAR MOVIMIENTO</h6></div>
      <div class="tr-card-body">
        <form method="POST">
          <?php if ($almacenes): ?>
          <div class="mb-3">
            <label class="tr-form-label">Local / Almacén *</label>
            <select name="almacen_id" class="form-select" required>
              <?php foreach ($almacenes as $a): ?>
              <option value="<?= $a['id'] ?>" <?= (int)$a['id']===$almPrincipalId?'selected':'' ?>>
                <?= sanitize($a['nombre']) ?>
                <?= $a['principal'] ? ' (Principal)' : '' ?>
                — Stock: <?= number_format($stockPorAlmacen[(int)$a['id']] ?? 0, 2) ?>
              </option>
              <?php endforeach; ?>
            </select>
            <div class="form-text small">El stock se afecta en el local que elijas.</div>
          </div>
          <?php endif; ?>

          <div class="mb-3">
            <label class="tr-form-label">Tipo de movimiento *</label>
            <div class="d-flex gap-2">
              <div><input type="radio" class="btn-check" name="tipo" id="t_ent" value="entrada" checked><label class="btn btn-outline-success" for="t_ent">📦 Entrada</label></div>
              <div><input type="radio" class="btn-check" name="tipo" id="t_sal" value="salida"><label class="btn btn-outline-danger" for="t_sal">📤 Salida</label></div>
              <div><input type="radio" class="btn-check" name="tipo" id="t_aj" value="ajuste"><label class="btn btn-outline-warning" for="t_aj">⚖️ Ajuste</label></div>
            </div>
          </div>
          <div class="mb-2">
            <label class="tr-form-label">Cantidad *</label>
            <input type="number" name="cantidad" class="form-control" step="0.01" min="0.01" required autofocus placeholder="0.00"/>
          </div>
          <div class="mb-2">
            <label class="tr-form-label">Precio unitario (S/) <span class="text-muted small">(para kardex de costo)</span></label>
            <input type="number" name="precio_unit" class="form-control currency-input" step="0.01" value="<?= $prod['precio_costo'] ?>"/>
          </div>
          <div class="mb-2">
            <label class="tr-form-label">Motivo *</label>
            <select name="motivo" class="form-select">
              <option value="Compra de stock">Compra de stock</option>
              <option value="Devolución de cliente">Devolución de cliente</option>
              <option value="Ajuste de inventario">Ajuste de inventario</option>
              <option value="Uso en reparación">Uso en reparación</option>
              <option value="Venta directa">Venta directa</option>
              <option value="Pérdida / Merma">Pérdida / Merma</option>
              <option value="Otro">Otro</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="tr-form-label">Referencia <span class="text-muted small">(OT, factura proveedor...)</span></label>
            <input type="text" name="referencia" class="form-control form-control-sm" placeholder="OT-2024-0001 / FAC-001"/>
          </div>
          <button type="submit" class="btn btn-primary w-100">Registrar movimiento</button>
        </form>
      </div>
    </div>
  </div>

  <div class="col-lg-7">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">HISTORIAL RECIENTE</h6></div>
      <div class="tr-card-body p-0">
        <table class="tr-table">
          <thead><tr><th>Tipo</th><th>Cant.</th><th>Antes</th><th>Después</th><th>Local</th><th>Motivo</th><th>Usuario</th><th>Fecha</th></tr></thead>
          <tbody>
            <?php foreach($historial as $h):
              $tc=['entrada'=>'success','salida'=>'danger','ajuste'=>'warning','devolucion'=>'info',
                   'devolucion_venta'=>'info','traslado_salida'=>'warning','traslado_entrada'=>'primary'];
            ?>
            <tr>
              <td><span class="badge bg-<?= $tc[$h['tipo']] ?? 'secondary' ?>"><?= ucfirst(str_replace('_',' ',$h['tipo'])) ?></span></td>
              <td class="fw-bold <?= $h['tipo']==='entrada'||$h['tipo']==='traslado_entrada'?'text-success':'text-danger' ?>"><?= $h['tipo']==='entrada'||$h['tipo']==='traslado_entrada'?'+':'-' ?><?= number_format($h['cantidad'],2) ?></td>
              <td class="text-muted small"><?= number_format($h['stock_antes'],2) ?></td>
              <td class="fw-semibold small"><?= number_format($h['stock_despues'],2) ?></td>
              <td class="small">
                <?php if (!empty($h['alm_codigo'])): ?>
                  <span class="badge bg-light text-dark"><?= sanitize($h['alm_codigo']) ?></span>
                <?php else: ?>
                  <span class="text-muted">—</span>
                <?php endif; ?>
              </td>
              <td class="small"><?= sanitize($h['motivo'] ?? '—') ?></td>
              <td class="small text-muted"><?= sanitize($h['usr']) ?></td>
              <td class="small text-muted"><?= formatDate($h['created_at']) ?></td>
            </tr>
            <?php endforeach; ?>
            <?php if(empty($historial)): ?><tr><td colspan="8" class="text-center text-muted py-3">Sin movimientos</td></tr><?php endif; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
