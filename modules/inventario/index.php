<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();

$db = getDB();

// Eliminar (desactivar) un producto. Solo admin/técnico.
// No se borra físicamente para no romper ventas, kardex o traslados que lo
// referencien: se marca como inactivo y deja de aparecer en el sistema.
if (($_GET['accion'] ?? '') === 'eliminar' && isset($_GET['id'])) {
    requireRole([ROL_ADMIN, ROL_TECNICO]);
    $pid = (int)$_GET['id'];
    try {
        $db->prepare("UPDATE productos SET activo=0 WHERE id=?")->execute([$pid]);
        setFlash('success', 'Producto eliminado del inventario.');
    } catch (\Throwable $e) {
        setFlash('danger', 'No se pudo eliminar el producto.');
    }
    redirect(BASE_URL . 'modules/inventario/index.php');
}

$f_cat    = $_GET['categoria'] ?? '';
$f_buscar = trim($_GET['q'] ?? '');
$f_stock  = $_GET['stock'] ?? '';
$f_alm    = $_GET['almacen'] ?? '';   // '' = todos, o un id de almacén

// ¿Está instalado el módulo de almacenes?
$almacenes = [];
$almPrincipalId = null;
try {
    $almacenes = $db->query("SELECT id,nombre,codigo,principal FROM almacenes WHERE activo=1 ORDER BY principal DESC, nombre")->fetchAll();
    foreach ($almacenes as $a) { if ($a['principal']) $almPrincipalId = (int)$a['id']; }
} catch (\Throwable $e) { /* módulo no instalado */ }

$f_alm = (int)$f_alm ?: '';   // normalizar a int o ''

$where = ['p.activo=1'];
$params = [];
if ($f_cat)   { $where[] = 'p.categoria_id=?'; $params[] = $f_cat; }
if ($f_buscar){ $where[] = '(p.nombre LIKE ? OR p.codigo LIKE ? OR p.serial LIKE ?)'; $like='%'.$f_buscar.'%'; $params=array_merge($params,[$like,$like,$like]); }

// Si se filtra por un almacén concreto, el "stock" mostrado es el de ese almacén.
// Si no, se usa el stock global (productos.stock_actual = Tienda principal).
if ($f_alm && $almacenes) {
    // Stock del almacén seleccionado vía LEFT JOIN
    $selStock = 'COALESCE(sa.cantidad,0)';
    $joinStock = 'LEFT JOIN stock_almacen sa ON sa.producto_id=p.id AND sa.almacen_id=?';
    // El parámetro del JOIN va primero en el orden de binding
    array_unshift($params, $f_alm);
    // Al filtrar por un almacén, mostrar SOLO los productos que tienen stock ahí
    if ($f_stock === 'bajo')     { $where[] = 'COALESCE(sa.cantidad,0) <= p.stock_minimo'; }
    else                         { $where[] = 'COALESCE(sa.cantidad,0) > 0'; }
} else {
    $selStock = 'p.stock_actual';
    $joinStock = '';
    if ($f_stock === 'bajo')     { $where[] = 'p.stock_actual <= p.stock_minimo'; }
    if ($f_stock === 'con_stock'){ $where[] = 'p.stock_actual > 0'; }
}

$sql = "SELECT p.*, c.nombre as cat_nombre, c.tipo as cat_tipo, $selStock AS stock_mostrado
        FROM productos p
        JOIN categorias c ON c.id=p.categoria_id
        $joinStock
        WHERE " . implode(' AND ', $where) . "
        ORDER BY stock_mostrado<=p.stock_minimo DESC, p.nombre
        LIMIT 300";
$stmt = $db->prepare($sql);
$stmt->execute($params);
$productos = $stmt->fetchAll();

// Desglose de stock por almacén (solo cuando se ven TODOS los almacenes)
$stockPorAlmacen = [];
if (!$f_alm && $almacenes && $productos) {
    $ids = array_column($productos, 'id');
    $in  = implode(',', array_fill(0, count($ids), '?'));
    $rs = $db->prepare("SELECT sa.producto_id, a.codigo, a.nombre, sa.cantidad
                        FROM stock_almacen sa JOIN almacenes a ON a.id=sa.almacen_id
                        WHERE a.activo=1 AND sa.producto_id IN ($in)
                        ORDER BY a.principal DESC, a.nombre");
    $rs->execute($ids);
    foreach ($rs->fetchAll() as $r) {
        $stockPorAlmacen[$r['producto_id']][] = $r;
    }
}

$categorias = $db->query("SELECT * FROM categorias WHERE activo=1 ORDER BY tipo,nombre")->fetchAll();

// Nombre del almacén filtrado (para el encabezado)
$almNombre = '';
if ($f_alm) { foreach ($almacenes as $a) { if ((int)$a['id']===$f_alm) $almNombre = $a['nombre']; } }

$pageTitle  = 'Inventario — ' . APP_NAME;
$breadcrumb = [['label'=>'Inventario','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">
    Inventario de productos
    <?php if ($almNombre): ?><span class="text-muted fw-normal fs-6">— <?= sanitize($almNombre) ?></span><?php endif; ?>
  </h5>
  <div class="d-flex gap-2">
    <a href="<?= BASE_URL ?>modules/inventario/exportar.php" class="btn btn-outline-secondary btn-sm">
      <i data-feather="download" style="width:14px;height:14px"></i> Exportar
    </a>
    <a href="<?= BASE_URL ?>modules/inventario/importar.php" class="btn btn-outline-secondary btn-sm">
      <i data-feather="upload" style="width:14px;height:14px"></i> Importar
    </a>
    <a href="<?= BASE_URL ?>modules/inventario/kardex.php" class="btn btn-outline-secondary btn-sm">
      <i data-feather="bar-chart-2" style="width:14px;height:14px"></i> Kardex
    </a>
    <a href="<?= BASE_URL ?>modules/inventario/nuevo.php" class="btn btn-primary btn-sm">
      <i data-feather="plus" style="width:14px;height:14px"></i> Nuevo producto
    </a>
  </div>
</div>

<!-- Filtros -->
<div class="tr-card mb-3">
  <div class="tr-card-body py-2">
    <form method="GET" class="row g-2 align-items-end">
      <div class="col-md-4">
        <input type="text" name="q" class="form-control form-control-sm" placeholder="Buscar por nombre, código, serial..." value="<?= sanitize($f_buscar) ?>"/>
      </div>
      <div class="col-md-3">
        <select name="categoria" class="form-select form-select-sm">
          <option value="">Todas las categorías</option>
          <?php foreach ($categorias as $cat): ?>
          <option value="<?= $cat['id'] ?>" <?= $f_cat==$cat['id']?'selected':'' ?>><?= sanitize($cat['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <?php if (!empty($almacenes)): ?>
      <div class="col-md-2">
        <select name="almacen" class="form-select form-select-sm">
          <option value="">Todos los almacenes</option>
          <?php foreach ($almacenes as $a): ?>
          <option value="<?= $a['id'] ?>" <?= $f_alm===(int)$a['id']?'selected':'' ?>>
            <?= sanitize($a['nombre']) ?><?= $a['principal']?' (Tienda)':'' ?>
          </option>
          <?php endforeach; ?>
        </select>
      </div>
      <?php endif; ?>
      <div class="col-md-2">
        <select name="stock" class="form-select form-select-sm">
          <option value="">Todo el stock</option>
          <option value="con_stock" <?= $f_stock==='con_stock'?'selected':'' ?>>Con stock (&gt; 0)</option>
          <option value="bajo" <?= $f_stock==='bajo'?'selected':'' ?>>⚠️ Stock mínimo</option>
        </select>
      </div>
      <div class="col-md-1"><button type="submit" class="btn btn-primary btn-sm w-100">Filtrar</button></div>
    </form>
  </div>
</div>

<!-- Tabla -->
<div class="tr-card">
  <div class="tr-card-body p-0" style="overflow:hidden"><div class="table-responsive-wrapper" style="overflow-x:auto;-webkit-overflow-scrolling:touch">
    <table class="tr-table">
      <thead>
        <tr>
          <th>Código</th><th>Producto</th><th>Categoría</th>
          <th>Serial</th><th>Ubicación</th>
          <th>Costo</th><th>Precio venta</th>
          <th><?= $f_alm ? 'Stock' : 'Stock (Tienda)' ?></th>
          <?php if (!$f_alm && !empty($almacenes)): ?><th>Por almacén</th><?php endif; ?>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($productos as $p): 
          $stockVal  = (float)($p['stock_mostrado'] ?? $p['stock_actual']);
          $stockBajo = $stockVal <= $p['stock_minimo'];
        ?>
        <tr class="<?= $stockBajo ? 'table-warning' : '' ?>">
          <td><code><?= sanitize($p['codigo']) ?></code></td>
          <td>
            <div class="fw-semibold"><?= sanitize($p['nombre']) ?></div>
            <?php if ($p['marca']): ?><div class="text-muted small"><?= sanitize($p['marca'].' '.($p['modelo']??'')) ?></div><?php endif; ?>
          </td>
          <td><span class="badge bg-secondary"><?= sanitize($p['cat_nombre']) ?></span></td>
          <td class="small"><?= $p['serial'] ? '<code>'.sanitize($p['serial']).'</code>' : '—' ?></td>
          <td class="small text-muted"><?= sanitize($p['ubicacion'] ?? '—') ?></td>
          <td><?= formatMoney($p['precio_costo']) ?></td>
          <td class="fw-semibold"><?= formatMoney($p['precio_venta']) ?></td>
          <td>
            <span class="fw-bold <?= $stockBajo ? 'text-danger' : 'text-success' ?>">
              <?= number_format($stockVal,0) ?>
            </span>
            <span class="text-muted small"> / min <?= number_format($p['stock_minimo'],0) ?></span>
            <?php if ($stockBajo): ?>
            <span class="badge bg-danger ms-1" style="font-size:10px">BAJO</span>
            <?php endif; ?>
          </td>
          <?php if (!$f_alm && !empty($almacenes)): ?>
          <td class="small">
            <?php if (!empty($stockPorAlmacen[$p['id']])): ?>
              <?php foreach ($stockPorAlmacen[$p['id']] as $sa): ?>
              <span class="badge bg-light text-dark border me-1" title="<?= sanitize($sa['nombre']) ?>">
                <?= sanitize($sa['codigo']) ?>: <strong><?= number_format($sa['cantidad'],0) ?></strong>
              </span>
              <?php endforeach; ?>
            <?php else: ?>
              <span class="text-muted">—</span>
            <?php endif; ?>
          </td>
          <?php endif; ?>
          <td>
            <div class="btn-group btn-group-sm">
              <a href="<?= BASE_URL ?>modules/inventario/editar.php?id=<?= $p['id'] ?>"
                 class="btn btn-outline-secondary" title="Editar">
                <i data-feather="edit-2" style="width:13px;height:13px"></i>
              </a>
              <a href="<?= BASE_URL ?>modules/inventario/movimiento.php?id=<?= $p['id'] ?>"
                 class="btn btn-outline-primary" title="Entrada/Salida">
                <i data-feather="refresh-cw" style="width:13px;height:13px"></i>
              </a>
              <a href="<?= BASE_URL ?>modules/inventario/index.php?accion=eliminar&id=<?= $p['id'] ?>"
                 class="btn btn-outline-danger" title="Eliminar"
                 onclick="return confirm('¿Eliminar «<?= sanitize(addslashes($p['nombre'])) ?>» del inventario?\n\nEsto lo quita de la lista. No se borran sus ventas ni movimientos anteriores.');">
                <i data-feather="trash-2" style="width:13px;height:13px"></i>
              </a>
            </div>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
