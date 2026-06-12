<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN]);
$db = getDB();

// Verificar que las columnas nuevas existen
$colsVentas = array_column($db->query("SHOW COLUMNS FROM ventas")->fetchAll(),'Field');
$tieneVendedor = in_array('vendedor_id', $colsVentas);
$tieneCodigoDesc = in_array('codigo_descuento_id', $colsVentas);

if (!$tieneVendedor) {
    setFlash('warning', '⚠️ Ejecuta primero el SQL: <code>vendedoras_descuentos.sql</code> en phpMyAdmin para habilitar este módulo.');
}

$desde    = $_GET['desde']      ?? date('Y-m-01');
$hasta    = $_GET['hasta']      ?? date('Y-m-d');
$vendId   = (int)($_GET['vendedor'] ?? 0);

// Resumen por vendedora
try {
    $resumen = $db->prepare("
        SELECT u.id, CONCAT(u.nombre,' ',u.apellido) AS vendedora,
               COUNT(v.id)            AS total_ventas,
               SUM(v.total)           AS total_monto,
               SUM(v.descuento)       AS total_descuentos,
               AVG(v.total)           AS ticket_promedio,
               COUNT(DISTINCT v.cliente_id) AS clientes_atendidos
        FROM usuarios u
        LEFT JOIN ventas v ON v.vendedor_id = u.id
            AND v.estado != 'anulada'
            AND DATE(v.created_at) BETWEEN ? AND ?
        WHERE u.rol = 'vendedor' AND u.activo = 1
        GROUP BY u.id
        ORDER BY total_monto DESC
    ");
    $resumen->execute([$desde, $hasta]);
    $resumen = $resumen->fetchAll();
} catch (\Exception $e) {
    $resumen = [];
    setFlash('danger', 'Error al cargar resumen: ' . htmlspecialchars($e->getMessage()));
}

// Ventas detalladas
$params = [$desde, $hasta];
if ($tieneVendedor && $vendId) $params[] = $vendId;

// Build query dynamically based on available columns
$selectExtra = $tieneCodigoDesc
    ? "cd.codigo AS cod_desc_codigo, cd.valor AS cod_desc_valor, cd.tipo AS cod_desc_tipo,"
    : "NULL AS cod_desc_codigo, NULL AS cod_desc_valor, NULL AS cod_desc_tipo,";
$joinCod = $tieneCodigoDesc
    ? "LEFT JOIN codigos_descuento cd ON cd.id = v.codigo_descuento_id"
    : "";
$vendedorCol = $tieneVendedor
    ? "COALESCE(CONCAT(u.nombre,' ',u.apellido), 'Sin asignar') AS vendedora_nombre"
    : "'Sin asignar' AS vendedora_nombre";
$joinVend = $tieneVendedor ? "LEFT JOIN usuarios u ON u.id = v.vendedor_id" : "";
$whereVendSQL = ($tieneVendedor && $vendId) ? 'AND v.vendedor_id = ?' : '';

try {
    $ventas = $db->prepare("
        SELECT v.*,
               $vendedorCol,
               cl.nombre AS cliente_nombre,
               $selectExtra
               GROUP_CONCAT(p.nombre ORDER BY vd.id SEPARATOR ', ') AS productos
        FROM ventas v
        $joinVend
        LEFT JOIN clientes cl ON cl.id = v.cliente_id
        $joinCod
        LEFT JOIN venta_detalle vd ON vd.venta_id = v.id
        LEFT JOIN productos p ON p.id = vd.producto_id
        WHERE v.estado != 'anulada'
          AND DATE(v.created_at) BETWEEN ? AND ?
          $whereVendSQL
        GROUP BY v.id
        ORDER BY v.created_at DESC
        LIMIT 500
    ");
    $ventas->execute($params);
    $ventas = $ventas->fetchAll();
} catch (\Exception $e) {
    $ventas = [];
    setFlash('danger', 'Error al cargar ventas: ' . htmlspecialchars($e->getMessage()));
}

$vendedoras = $db->query("SELECT id, CONCAT(nombre,' ',apellido) AS nombre FROM usuarios WHERE rol='vendedor' AND activo=1 ORDER BY nombre")->fetchAll();

$pageTitle  = 'Reporte vendedoras — '.APP_NAME;
$breadcrumb = [['label'=>'Ventas','url'=>BASE_URL.'modules/ventas/index.php'],['label'=>'Reporte vendedoras','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-4">
  <h5 class="fw-bold mb-0">📊 Reporte por vendedora</h5>
  <a href="<?= BASE_URL ?>modules/descuentos/index.php" class="btn btn-outline-primary btn-sm">
    <i data-feather="tag" style="width:14px;height:14px"></i> Códigos de descuento
  </a>
</div>

<!-- Filtros -->
<div class="tr-card mb-4">
  <div class="tr-card-body py-2">
    <form method="GET" class="d-flex flex-wrap gap-2 align-items-end">
      <div>
        <label class="tr-form-label">Desde</label>
        <input type="date" name="desde" class="form-control form-control-sm" value="<?= $desde ?>"/>
      </div>
      <div>
        <label class="tr-form-label">Hasta</label>
        <input type="date" name="hasta" class="form-control form-control-sm" value="<?= $hasta ?>"/>
      </div>
      <div>
        <label class="tr-form-label">Vendedora</label>
        <select name="vendedor" class="form-select form-select-sm" style="min-width:160px">
          <option value="">Todas</option>
          <?php foreach($vendedoras as $v): ?>
          <option value="<?= $v['id'] ?>" <?= $vendId==$v['id']?'selected':'' ?>><?= sanitize($v['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <button type="submit" class="btn btn-primary btn-sm">Filtrar</button>
      <a href="?" class="btn btn-outline-secondary btn-sm">Limpiar</a>
    </form>
  </div>
</div>

<!-- KPIs por vendedora -->
<?php if(!$vendId): ?>
<div class="row g-3 mb-4">
  <?php foreach($resumen as $r): ?>
  <div class="col-md-6 col-lg-4">
    <div class="tr-card h-100">
      <div class="tr-card-body">
        <div class="d-flex align-items-center gap-3 mb-3">
          <div style="width:44px;height:44px;border-radius:50%;background:linear-gradient(135deg,#4f46e5,#7c3aed);
                      color:#fff;display:flex;align-items:center;justify-content:center;font-size:18px;font-weight:800;flex-shrink:0">
            <?= strtoupper(substr($r['vendedora'],0,1)) ?>
          </div>
          <div>
            <div class="fw-bold"><?= sanitize($r['vendedora']) ?></div>
            <div class="text-muted small"><?= $r['total_ventas'] ?> venta(s) · <?= $r['clientes_atendidos'] ?> cliente(s)</div>
          </div>
        </div>
        <div class="row g-2 text-center">
          <div class="col-4">
            <div class="p-2 rounded" style="background:#f0fdf4">
              <div class="fw-bold text-success" style="font-size:15px"><?= formatMoney($r['total_monto']??0) ?></div>
              <div style="font-size:10px;color:#6b7280">Total vendido</div>
            </div>
          </div>
          <div class="col-4">
            <div class="p-2 rounded" style="background:#eff6ff">
              <div class="fw-bold text-primary" style="font-size:15px"><?= formatMoney($r['ticket_promedio']??0) ?></div>
              <div style="font-size:10px;color:#6b7280">Ticket prom.</div>
            </div>
          </div>
          <div class="col-4">
            <div class="p-2 rounded" style="background:#fef2f2">
              <div class="fw-bold text-danger" style="font-size:15px"><?= formatMoney($r['total_descuentos']??0) ?></div>
              <div style="font-size:10px;color:#6b7280">Descuentos</div>
            </div>
          </div>
        </div>
        <div class="mt-2 text-end">
          <a href="?desde=<?= $desde ?>&hasta=<?= $hasta ?>&vendedor=<?= $r['id'] ?>"
             class="btn btn-outline-primary btn-sm py-0" style="font-size:12px">
            Ver sus ventas →
          </a>
        </div>
      </div>
    </div>
  </div>
  <?php endforeach; ?>
  <?php if(empty($resumen)): ?>
  <div class="col-12"><div class="alert alert-info">No hay vendedoras registradas.</div></div>
  <?php endif; ?>
</div>
<?php else: ?>
<!-- Header de vendedora seleccionada -->
<?php $vSel = array_filter($resumen, fn($r) => $r['id'] == $vendId); $vSel = reset($vSel); ?>
<?php if($vSel): ?>
<div class="row g-3 mb-4">
  <div class="col-md-3"><div class="kpi-card"><div class="kpi-label">Total vendido</div><div class="kpi-value text-success"><?= formatMoney($vSel['total_monto']??0) ?></div></div></div>
  <div class="col-md-3"><div class="kpi-card"><div class="kpi-label">Nº de ventas</div><div class="kpi-value text-primary"><?= $vSel['total_ventas'] ?></div></div></div>
  <div class="col-md-3"><div class="kpi-card"><div class="kpi-label">Ticket promedio</div><div class="kpi-value"><?= formatMoney($vSel['ticket_promedio']??0) ?></div></div></div>
  <div class="col-md-3"><div class="kpi-card"><div class="kpi-label">Descuentos otorgados</div><div class="kpi-value text-danger"><?= formatMoney($vSel['total_descuentos']??0) ?></div></div></div>
</div>
<?php endif; ?>
<?php endif; ?>

<!-- Tabla de ventas detalladas -->
<div class="tr-card">
  <div class="tr-card-header">
    <h6 class="mb-0 small fw-semibold">
      VENTAS DETALLADAS
      <?php if($vendId && $vSel): ?> — <?= sanitize($vSel['vendedora']) ?><?php endif; ?>
    </h6>
    <span class="text-muted small"><?= count($ventas) ?> registro(s)</span>
  </div>
  <div class="tr-card-body p-0" style="overflow:hidden">
    <div style="overflow-x:auto">
    <table class="tr-table">
      <thead>
        <tr>
          <th>Nº Venta</th>
          <?php if(!$vendId): ?><th>Vendedora</th><?php endif; ?>
          <th>Fecha</th>
          <th>Cliente</th>
          <th>Productos</th>
          <th>Comprobante</th>
          <th>Cód. Descuento</th>
          <th>Descuento</th>
          <th>Total</th>
          <th>Pago</th>
          <th>Estado</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
      <?php foreach($ventas as $v): ?>
      <tr>
        <td class="fw-semibold"><a href="<?= BASE_URL ?>modules/ventas/detalle.php?id=<?= $v['id'] ?>"
            class="text-primary text-decoration-none"><?= sanitize($v['codigo']) ?></a></td>
        <?php if(!$vendId): ?>
        <td class="small fw-semibold"><?= sanitize($v['vendedora_nombre']??'—') ?></td>
        <?php endif; ?>
        <td class="small text-muted"><?= date('d/m/Y H:i',strtotime($v['created_at'])) ?></td>
        <td class="small"><?= sanitize($v['cliente_nombre'] ?: 'Consumidor final') ?></td>
        <td class="small text-muted" style="max-width:200px">
          <span title="<?= sanitize($v['productos']??'') ?>">
            <?= sanitize(mb_strimwidth($v['productos']??'—',0,60,'…')) ?>
          </span>
        </td>
        <td><span class="badge bg-secondary" style="font-size:10px"><?= strtoupper($v['tipo_doc']) ?></span></td>
        <td>
          <?php if($v['cod_desc_codigo']): ?>
          <span class="badge bg-info text-dark" style="font-size:10px;font-family:monospace">
            <?= sanitize($v['cod_desc_codigo']) ?>
          </span>
          <div style="font-size:10px;color:#6b7280">
            <?= $v['cod_desc_tipo']==='porcentaje' ? $v['cod_desc_valor'].'%' : 'S/'.number_format($v['cod_desc_valor'],2) ?>
          </div>
          <?php else: ?>—<?php endif; ?>
        </td>
        <td class="text-danger"><?= $v['descuento']>0 ? '-'.formatMoney($v['descuento']) : '—' ?></td>
        <td class="fw-bold"><?= formatMoney($v['total']) ?></td>
        <td><span class="badge bg-light text-dark border" style="font-size:10px"><?= ucfirst($v['metodo_pago']) ?></span></td>
        <td>
          <span class="badge bg-<?= $v['estado']==='completada'?'success':($v['estado']==='anulada'?'danger':'warning') ?>">
            <?= ucfirst($v['estado']) ?>
          </span>
        </td>
        <td>
          <a href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>" target="_blank"
             class="btn btn-sm btn-outline-secondary py-0" title="Ticket">
            <i data-feather="printer" style="width:12px;height:12px"></i>
          </a>
        </td>
      </tr>
      <?php endforeach; ?>
      <?php if(empty($ventas)): ?>
      <tr><td colspan="12" class="text-center text-muted py-4">Sin ventas en el período seleccionado</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
    </div>
  </div>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
