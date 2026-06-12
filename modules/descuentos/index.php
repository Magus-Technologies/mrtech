<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN]);
$db   = getDB();
$user = currentUser();

// Verificar tabla existe
try {
    $db->query("SELECT 1 FROM codigos_descuento LIMIT 1");
} catch (\Exception $e) {
    setFlash('danger', '⚠️ Ejecuta primero el SQL <code>vendedoras_descuentos.sql</code> en phpMyAdmin. Error: ' . $e->getMessage());
    $pageTitle  = 'Códigos de descuento — '.APP_NAME;
    $breadcrumb = [['label'=>'Descuentos','url'=>null]];
    require_once __DIR__ . '/../../includes/header.php';
    require_once __DIR__ . '/../../includes/footer.php';
    exit;
}

// CREAR
if ($_SERVER['REQUEST_METHOD']==='POST' && ($_POST['action']??'')==='crear') {
    $vid = !empty($_POST['vendedor_id']) ? (int)$_POST['vendedor_id'] : null;
    $lim = !empty($_POST['limite_usos'])  ? (int)$_POST['limite_usos']  : null;
    $fin = !empty($_POST['fecha_fin'])    ? $_POST['fecha_fin']          : null;
    $ini = !empty($_POST['fecha_inicio']) ? $_POST['fecha_inicio']       : null;
    $min = !empty($_POST['monto_minimo']) ? (float)$_POST['monto_minimo']: null;
    try {
        $db->prepare("INSERT INTO codigos_descuento
            (codigo,descripcion,tipo,valor,vendedor_id,limite_usos,monto_minimo,fecha_inicio,fecha_fin,creado_por)
            VALUES (?,?,?,?,?,?,?,?,?,?)")
        ->execute([
            strtoupper(trim($_POST['codigo'])),
            trim($_POST['descripcion']??''),
            $_POST['tipo']??'porcentaje',
            (float)$_POST['valor'],
            $vid,$lim,$min,$ini,$fin,$user['id']
        ]);
        setFlash('success','✅ Código de descuento creado.');
    } catch(\Exception $e) {
        setFlash('danger','Error: el código ya existe.');
    }
    redirect(BASE_URL.'modules/descuentos/index.php');
}

// EDITAR
if ($_SERVER['REQUEST_METHOD']==='POST' && ($_POST['action']??'')==='editar') {
    $id  = (int)$_POST['id'];
    $vid = !empty($_POST['vendedor_id']) ? (int)$_POST['vendedor_id'] : null;
    $lim = !empty($_POST['limite_usos'])  ? (int)$_POST['limite_usos']  : null;
    $fin = !empty($_POST['fecha_fin'])    ? $_POST['fecha_fin']          : null;
    $ini = !empty($_POST['fecha_inicio']) ? $_POST['fecha_inicio']       : null;
    $min = !empty($_POST['monto_minimo']) ? (float)$_POST['monto_minimo']: null;
    $db->prepare("UPDATE codigos_descuento SET
        descripcion=?,tipo=?,valor=?,vendedor_id=?,limite_usos=?,
        monto_minimo=?,fecha_inicio=?,fecha_fin=?,activo=? WHERE id=?")
    ->execute([
        trim($_POST['descripcion']??''),
        $_POST['tipo']??'porcentaje',
        (float)$_POST['valor'],
        $vid,$lim,$min,$ini,$fin,
        isset($_POST['activo'])?1:0,
        $id
    ]);
    setFlash('success','Código actualizado.');
    redirect(BASE_URL.'modules/descuentos/index.php');
}

// ELIMINAR
if (isset($_GET['del'])) {
    $id = (int)$_GET['del'];
    $usos = $db->prepare("SELECT usos_actuales FROM codigos_descuento WHERE id=?"); $usos->execute([$id]);
    if ((int)$usos->fetchColumn() > 0) {
        setFlash('danger','No se puede eliminar: ya fue usado en ventas.');
    } else {
        $db->prepare("DELETE FROM codigos_descuento WHERE id=?")->execute([$id]);
        setFlash('success','Código eliminado.');
    }
    redirect(BASE_URL.'modules/descuentos/index.php');
}

$codigos   = $db->query("
    SELECT cd.*, CONCAT(u.nombre,' ',u.apellido) AS vendedor_nombre,
           CONCAT(c.nombre,' ',c.apellido) AS creador_nombre
    FROM codigos_descuento cd
    LEFT JOIN usuarios u ON u.id=cd.vendedor_id
    JOIN  usuarios c ON c.id=cd.creado_por
    ORDER BY cd.created_at DESC")->fetchAll();

$vendedoras = $db->query("SELECT id,CONCAT(nombre,' ',apellido) AS nombre FROM usuarios WHERE rol='vendedor' AND activo=1 ORDER BY nombre")->fetchAll();

$pageTitle  = 'Códigos de descuento — '.APP_NAME;
$breadcrumb = [['label'=>'Descuentos','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-4">
  <h5 class="fw-bold mb-0">🏷 Códigos de descuento</h5>
  <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modal-nuevo">
    <i data-feather="plus" style="width:14px;height:14px"></i> Nuevo código
  </button>
</div>

<div class="tr-card">
  <div class="tr-card-body p-0" style="overflow:hidden">
    <div style="overflow-x:auto">
    <table class="tr-table">
      <thead>
        <tr>
          <th>Código</th><th>Descripción</th><th>Tipo</th><th>Valor</th>
          <th>Vendedora</th><th>Usos</th><th>Mín. compra</th>
          <th>Validez</th><th>Estado</th><th></th>
        </tr>
      </thead>
      <tbody>
      <?php foreach($codigos as $c):
        $agotado  = $c['limite_usos'] && $c['usos_actuales'] >= $c['limite_usos'];
        $vencido  = $c['fecha_fin'] && $c['fecha_fin'] < date('Y-m-d');
        $ok       = $c['activo'] && !$agotado && !$vencido;
      ?>
      <tr>
        <td><code class="fw-bold" style="font-size:14px;letter-spacing:.05em"><?= sanitize($c['codigo']) ?></code></td>
        <td class="small"><?= sanitize($c['descripcion']?:'—') ?></td>
        <td><span class="badge bg-<?= $c['tipo']==='porcentaje'?'primary':'success' ?>">
          <?= $c['tipo']==='porcentaje'?'%':'S/' ?>
        </span></td>
        <td class="fw-bold">
          <?= $c['tipo']==='porcentaje'
            ? number_format($c['valor'],1).'%'
            : 'S/ '.number_format($c['valor'],2) ?>
        </td>
        <td class="small"><?= $c['vendedor_nombre'] ? sanitize($c['vendedor_nombre']) : '<span class="text-muted">Todas</span>' ?></td>
        <td class="text-center">
          <?= $c['usos_actuales'] ?>
          <?php if($c['limite_usos']): ?>
          / <?= $c['limite_usos'] ?>
          <?php else: ?>
          <span class="text-muted small">/ ∞</span>
          <?php endif; ?>
        </td>
        <td class="small"><?= $c['monto_minimo'] ? 'S/ '.number_format($c['monto_minimo'],2) : '—' ?></td>
        <td class="small">
          <?php if($c['fecha_inicio'] || $c['fecha_fin']): ?>
          <?= $c['fecha_inicio'] ? date('d/m/y',strtotime($c['fecha_inicio'])) : '—' ?>
          → <?= $c['fecha_fin'] ? date('d/m/y',strtotime($c['fecha_fin'])) : '∞' ?>
          <?php else: ?><span class="text-muted">Sin límite</span><?php endif; ?>
        </td>
        <td>
          <?php if(!$c['activo']): ?>
          <span class="badge bg-secondary">Inactivo</span>
          <?php elseif($vencido): ?>
          <span class="badge bg-danger">Vencido</span>
          <?php elseif($agotado): ?>
          <span class="badge bg-warning text-dark">Agotado</span>
          <?php else: ?>
          <span class="badge bg-success">Activo</span>
          <?php endif; ?>
        </td>
        <td>
          <div class="btn-group btn-group-sm">
            <button class="btn btn-outline-primary"
                    onclick="abrirEditar(<?= htmlspecialchars(json_encode($c),ENT_QUOTES) ?>)">
              <i data-feather="edit-2" style="width:13px;height:13px"></i>
            </button>
            <a href="?del=<?= $c['id'] ?>" class="btn btn-outline-danger"
               data-confirm="¿Eliminar código '<?= sanitize($c['codigo']) ?>'?">
              <i data-feather="trash-2" style="width:13px;height:13px"></i>
            </a>
          </div>
        </td>
      </tr>
      <?php endforeach; ?>
      <?php if(empty($codigos)): ?>
      <tr><td colspan="10" class="text-center text-muted py-4">Sin códigos creados</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
    </div>
  </div>
</div>

<!-- Modal Nuevo -->
<div class="modal fade" id="modal-nuevo" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="POST">
        <input type="hidden" name="action" value="crear"/>
        <div class="modal-header"><h6 class="modal-title fw-bold">Nuevo código de descuento</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <div class="modal-body">
          <?php include __DIR__ . '/form_fields.php'; ?>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary btn-sm">Crear código</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Editar -->
<div class="modal fade" id="modal-editar" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="POST">
        <input type="hidden" name="action" value="editar"/>
        <input type="hidden" name="id" id="edit-id"/>
        <div class="modal-header"><h6 class="modal-title fw-bold">Editar código</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="tr-form-label">Código</label>
            <input type="text" id="edit-codigo" class="form-control bg-light" readonly/>
          </div>
          <?php include __DIR__ . '/form_fields.php'; ?>
          <div class="form-check mt-2">
            <input type="checkbox" class="form-check-input" name="activo" id="edit-activo"/>
            <label class="form-check-label small" for="edit-activo">Activo</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary btn-sm">Guardar cambios</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function abrirEditar(c) {
  document.getElementById('edit-id').value     = c.id;
  document.getElementById('edit-codigo').value  = c.codigo;
  document.getElementById('edit-desc').value    = c.descripcion||'';
  document.getElementById('edit-tipo').value    = c.tipo;
  document.getElementById('edit-valor').value   = c.valor;
  document.getElementById('edit-vend').value    = c.vendedor_id||'';
  document.getElementById('edit-lim').value     = c.limite_usos||'';
  document.getElementById('edit-min').value     = c.monto_minimo||'';
  document.getElementById('edit-ini').value     = c.fecha_inicio||'';
  document.getElementById('edit-fin').value     = c.fecha_fin||'';
  document.getElementById('edit-activo').checked= c.activo==1;
  new bootstrap.Modal(document.getElementById('modal-editar')).show();
}
</script>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
