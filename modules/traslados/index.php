<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/_lib.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

$db = getDB();

// Acción rápida: recibir traslado en tránsito
if (($_GET['accion'] ?? '') === 'recibir' && isset($_GET['id'])) {
    try {
        recibirTraslado($db, (int)$_GET['id'], currentUser()['id']);
        setFlash('success', 'Traslado recibido. Stock actualizado en destino.');
    } catch (\Throwable $e) {
        setFlash('danger', $e->getMessage());
    }
    redirect(BASE_URL . 'modules/traslados/index.php');
}

// Filtros
$f_estado  = $_GET['estado'] ?? '';
$f_origen  = $_GET['origen'] ?? '';
$f_destino = $_GET['destino'] ?? '';

$where = ['1=1']; $params = [];
if ($f_estado)  { $where[] = 't.estado=?';          $params[] = $f_estado; }
if ($f_origen)  { $where[] = 't.almacen_origen=?';  $params[] = $f_origen; }
if ($f_destino) { $where[] = 't.almacen_destino=?'; $params[] = $f_destino; }

$sql = "SELECT t.*,
               ao.nombre AS origen_nombre,
               ad.nombre AS destino_nombre,
               CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre
        FROM traslados t
        JOIN almacenes ao ON ao.id = t.almacen_origen
        JOIN almacenes ad ON ad.id = t.almacen_destino
        JOIN usuarios  u  ON u.id  = t.usuario_id
        WHERE " . implode(' AND ', $where) . "
        ORDER BY t.created_at DESC
        LIMIT 200";
$st = $db->prepare($sql);
$st->execute($params);
$traslados = $st->fetchAll();

$almacenes = listarAlmacenes($db);

// KPIs
$kpi = $db->query("
    SELECT
      COUNT(*)                                              AS total,
      SUM(estado='en_transito')                             AS en_transito,
      SUM(estado='recibido' AND DATE(created_at)=CURDATE()) AS hoy
    FROM traslados
")->fetch();

$estadoBadge = [
    'borrador'    => ['Borrador','secondary'],
    'en_transito' => ['En tránsito','warning'],
    'recibido'    => ['Recibido','success'],
    'anulado'     => ['Anulado','danger'],
];

$pageTitle  = 'Traslados — ' . APP_NAME;
$breadcrumb = [['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],['label'=>'Traslados','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Traslados de productos</h5>
  <div class="d-flex gap-2">
    <a href="<?= BASE_URL ?>modules/traslados/almacenes.php" class="btn btn-outline-secondary btn-sm">
      <i data-feather="database" style="width:14px;height:14px"></i> Almacenes
    </a>
    <a href="<?= BASE_URL ?>modules/traslados/nuevo.php" class="btn btn-primary btn-sm">
      <i data-feather="repeat" style="width:14px;height:14px"></i> Nuevo traslado
    </a>
  </div>
</div>

<!-- KPIs -->
<div class="row g-2 mb-3">
  <div class="col-4">
    <div class="tr-card"><div class="tr-card-body text-center py-3">
      <div class="fw-bold fs-4"><?= (int)$kpi['total'] ?></div>
      <div class="text-muted small">Traslados totales</div>
    </div></div>
  </div>
  <div class="col-4">
    <div class="tr-card"><div class="tr-card-body text-center py-3">
      <div class="fw-bold fs-4 text-warning"><?= (int)$kpi['en_transito'] ?></div>
      <div class="text-muted small">En tránsito</div>
    </div></div>
  </div>
  <div class="col-4">
    <div class="tr-card"><div class="tr-card-body text-center py-3">
      <div class="fw-bold fs-4 text-success"><?= (int)$kpi['hoy'] ?></div>
      <div class="text-muted small">Recibidos hoy</div>
    </div></div>
  </div>
</div>

<!-- Filtros -->
<div class="tr-card mb-3">
  <div class="tr-card-body py-2">
    <form method="GET" class="row g-2 align-items-end">
      <div class="col-md-3">
        <label class="tr-form-label small">Estado</label>
        <select name="estado" class="form-select form-select-sm">
          <option value="">Todos</option>
          <?php foreach ($estadoBadge as $k=>$v): ?>
          <option value="<?= $k ?>" <?= $f_estado===$k?'selected':'' ?>><?= $v[0] ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-3">
        <label class="tr-form-label small">Origen</label>
        <select name="origen" class="form-select form-select-sm">
          <option value="">Todos</option>
          <?php foreach ($almacenes as $a): ?>
          <option value="<?= $a['id'] ?>" <?= $f_origen==$a['id']?'selected':'' ?>><?= sanitize($a['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-3">
        <label class="tr-form-label small">Destino</label>
        <select name="destino" class="form-select form-select-sm">
          <option value="">Todos</option>
          <?php foreach ($almacenes as $a): ?>
          <option value="<?= $a['id'] ?>" <?= $f_destino==$a['id']?'selected':'' ?>><?= sanitize($a['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-md-3 d-flex gap-2">
        <button type="submit" class="btn btn-primary btn-sm w-100">Filtrar</button>
        <a href="<?= BASE_URL ?>modules/traslados/index.php" class="btn btn-outline-secondary btn-sm">Limpiar</a>
      </div>
    </form>
  </div>
</div>

<!-- Tabla -->
<div class="tr-card">
  <div class="tr-card-body p-0"><div class="table-responsive-wrapper" style="overflow-x:auto;-webkit-overflow-scrolling:touch">
    <table class="tr-table">
      <thead>
        <tr>
          <th>Código</th><th>Fecha</th><th>Origen</th><th></th><th>Destino</th>
          <th>Items</th><th>Unidades</th><th>Estado</th><th>Usuario</th><th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($traslados as $t):
          [$elabel,$ecolor] = $estadoBadge[$t['estado']] ?? [$t['estado'],'secondary'];
        ?>
        <tr>
          <td><code><?= sanitize($t['codigo']) ?></code></td>
          <td class="small text-muted"><?= formatDateTime($t['created_at']) ?></td>
          <td class="small"><?= sanitize($t['origen_nombre']) ?></td>
          <td class="text-center text-muted"><i data-feather="arrow-right" style="width:14px;height:14px"></i></td>
          <td class="small fw-semibold"><?= sanitize($t['destino_nombre']) ?></td>
          <td class="text-center"><?= (int)$t['total_items'] ?></td>
          <td class="text-center fw-semibold"><?= number_format($t['total_unidades'],0) ?></td>
          <td><span class="badge bg-<?= $ecolor ?>"><?= $elabel ?></span></td>
          <td class="small text-muted"><?= sanitize($t['usuario_nombre']) ?></td>
          <td>
            <div class="btn-group btn-group-sm">
              <a href="<?= BASE_URL ?>modules/traslados/ver.php?id=<?= $t['id'] ?>"
                 class="btn btn-outline-secondary" title="Ver detalle">
                <i data-feather="eye" style="width:13px;height:13px"></i>
              </a>
              <?php if ($t['estado']==='en_transito'): ?>
              <a href="<?= BASE_URL ?>modules/traslados/index.php?accion=recibir&id=<?= $t['id'] ?>"
                 class="btn btn-outline-success" title="Confirmar recepción"
                 onclick="return confirm('¿Confirmar la recepción de este traslado? El stock entrará al destino.')">
                <i data-feather="check" style="width:13px;height:13px"></i>
              </a>
              <?php endif; ?>
            </div>
          </td>
        </tr>
        <?php endforeach; ?>
        <?php if (empty($traslados)): ?>
        <tr><td colspan="10" class="text-center text-muted py-4">
          Sin traslados registrados. <a href="<?= BASE_URL ?>modules/traslados/nuevo.php">Crear el primero</a>.
        </td></tr>
        <?php endif; ?>
      </tbody>
    </table>
  </div></div>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
