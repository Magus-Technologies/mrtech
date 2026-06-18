<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN]);
$db   = getDB();
$user = currentUser();

// Cargar almacenes activos para los selects
$almacenes = [];
try {
    $almacenes = $db->query("SELECT id, codigo, nombre, tipo, principal FROM almacenes WHERE activo=1 ORDER BY principal DESC, nombre")->fetchAll();
} catch (\Throwable $e) { /* módulo no instalado */ }

// ── Crear usuario ─────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'crear') {
    $pass = password_hash(trim($_POST['password']), PASSWORD_BCRYPT);
    $almId = (int)($_POST['almacen_id'] ?? 0) ?: null;
    $db->prepare("INSERT INTO usuarios (nombre,apellido,email,password_hash,rol,telefono,almacen_id) VALUES (?,?,?,?,?,?,?)")
       ->execute([trim($_POST['nombre']),trim($_POST['apellido']),trim($_POST['email']),$pass,$_POST['rol'],trim($_POST['telefono']??''),$almId]);
    setFlash('success','Usuario creado correctamente.');
    redirect(BASE_URL.'modules/tecnicos/index.php');
}

// ── Editar usuario ────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'editar') {
    $uid   = (int)$_POST['id'];
    $almId = (int)($_POST['almacen_id'] ?? 0) ?: null;
    $pass  = trim($_POST['password'] ?? '');
    if ($pass) {
        $hash = password_hash($pass, PASSWORD_BCRYPT);
        $db->prepare("UPDATE usuarios SET nombre=?,apellido=?,email=?,rol=?,telefono=?,almacen_id=?,password_hash=? WHERE id=?")
           ->execute([trim($_POST['nombre']),trim($_POST['apellido']),trim($_POST['email']),$_POST['rol'],trim($_POST['telefono']??''),$almId,$hash,$uid]);
    } else {
        $db->prepare("UPDATE usuarios SET nombre=?,apellido=?,email=?,rol=?,telefono=?,almacen_id=? WHERE id=?")
           ->execute([trim($_POST['nombre']),trim($_POST['apellido']),trim($_POST['email']),$_POST['rol'],trim($_POST['telefono']??''),$almId,$uid]);
    }
    setFlash('success','Usuario actualizado correctamente.');
    redirect(BASE_URL.'modules/tecnicos/index.php');
}

// ── Cambiar estado ────────────────────────────────────────
if (isset($_GET['toggle'])) {
    $uid = (int)$_GET['toggle'];
    $db->prepare("UPDATE usuarios SET activo = 1-activo WHERE id=? AND id != ?")->execute([$uid,$user['id']]);
    redirect(BASE_URL.'modules/tecnicos/index.php');
}

$usuarios = $db->query("
  SELECT u.*, a.nombre as almacen_nombre, a.codigo as almacen_codigo,
    (SELECT COUNT(*) FROM ordenes_trabajo WHERE tecnico_id=u.id) as total_ots,
    (SELECT COUNT(*) FROM ordenes_trabajo WHERE tecnico_id=u.id AND estado='entregado') as ots_completadas
  FROM usuarios u
  LEFT JOIN almacenes a ON a.id = u.almacen_id
  ORDER BY u.activo DESC, u.nombre
")->fetchAll();

$pageTitle  = 'Usuarios y técnicos — '.APP_NAME;
$breadcrumb = [['label'=>'Usuarios','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Usuarios del sistema</h5>
  <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modal-nuevo">
    <i data-feather="user-plus" style="width:14px;height:14px"></i> Nuevo usuario
  </button>
</div>

<div class="tr-card">
  <div class="tr-card-body p-0" style="overflow:hidden"><div class="table-responsive-wrapper" style="overflow-x:auto;-webkit-overflow-scrolling:touch">
    <table class="tr-table">
      <thead><tr><th>Usuario</th><th>Rol</th><th>Local / Almacén</th><th>Email</th><th>Teléfono</th><th>OTs</th><th>Completadas</th><th>Último acceso</th><th>Estado</th><th></th></tr></thead>
      <tbody>
        <?php foreach($usuarios as $u): ?>
        <tr class="<?= !$u['activo']?'opacity-50':'' ?>">
          <td>
            <div class="d-flex align-items-center gap-2">
              <div class="tr-avatar" style="width:30px;height:30px;font-size:12px"><?= strtoupper(substr($u['nombre'],0,1)) ?></div>
              <div>
                <div class="fw-semibold small"><?= sanitize($u['nombre'].' '.$u['apellido']) ?></div>
              </div>
            </div>
          </td>
          <td><span class="badge bg-<?= $u['rol']==='admin'?'danger':($u['rol']==='tecnico'?'primary':'success') ?>"><?= ucfirst($u['rol']) ?></span></td>
          <td class="small">
            <?php if (!empty($u['almacen_nombre'])): ?>
              <span class="badge bg-info"><?= sanitize($u['almacen_codigo']) ?></span>
              <?= sanitize($u['almacen_nombre']) ?>
            <?php else: ?>
              <span class="text-muted">— Principal —</span>
            <?php endif; ?>
          </td>
          <td class="small"><?= sanitize($u['email']) ?></td>
          <td class="small"><?= sanitize($u['telefono']??'—') ?></td>
          <td class="text-center"><?= $u['total_ots'] ?></td>
          <td class="text-center text-success fw-semibold"><?= $u['ots_completadas'] ?></td>
          <td class="small text-muted"><?= $u['ultimo_acceso']?formatDateTime($u['ultimo_acceso']):'Nunca' ?></td>
          <td><span class="badge bg-<?= $u['activo']?'success':'secondary' ?>"><?= $u['activo']?'Activo':'Inactivo' ?></span></td>
          <td>
            <div class="d-flex gap-1">
              <button class="btn btn-sm btn-outline-primary py-0"
                      onclick="editarUsuario(<?= htmlspecialchars(json_encode($u), ENT_QUOTES) ?>)"
                      title="Editar">
                <i data-feather="edit-2" style="width:13px;height:13px"></i>
              </button>
              <?php if($u['id'] != $user['id']): ?>
              <a href="?toggle=<?= $u['id'] ?>" class="btn btn-sm btn-outline-<?= $u['activo']?'danger':'success' ?> py-0"
                 data-confirm="¿<?= $u['activo']?'Desactivar':'Activar' ?> este usuario?">
                <?= $u['activo']?'Desactivar':'Activar' ?>
              </a>
              <?php endif; ?>
            </div>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<!-- Modal nuevo usuario -->
<div class="modal fade" id="modal-nuevo" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="POST">
        <input type="hidden" name="action" value="crear"/>
        <div class="modal-header">
          <h6 class="modal-title fw-bold">Nuevo usuario</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row g-2">
            <div class="col-md-6"><label class="tr-form-label">Nombre *</label><input type="text" name="nombre" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Apellido *</label><input type="text" name="apellido" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Email *</label><input type="email" name="email" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Teléfono</label><input type="text" name="telefono" class="form-control"/></div>
            <div class="col-md-6">
              <label class="tr-form-label">Rol *</label>
              <select name="rol" class="form-select" id="nuevo-rol">
                <option value="tecnico">Técnico</option>
                <option value="vendedor">Vendedor</option>
                <option value="admin">Administrador</option>
              </select>
            </div>
            <div class="col-md-6"><label class="tr-form-label">Contraseña *</label><input type="password" name="password" class="form-control" minlength="6" required/></div>
            <div class="col-12" id="nuevo-almacen-wrap">
              <label class="tr-form-label">Local / Almacén asignado</label>
              <select name="almacen_id" class="form-select">
                <option value="">— Principal (sin asignar) —</option>
                <?php foreach ($almacenes as $a): ?>
                <option value="<?= $a['id'] ?>">
                  <?= sanitize($a['nombre']) ?>
                  <?= $a['principal'] ? ' (Principal)' : '' ?>
                  [<?= sanitize($a['codigo']) ?>]
                </option>
                <?php endforeach; ?>
              </select>
              <div class="form-text small">El vendedor vende del stock de este local. Si no se asigna, usa el almacén principal.</div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary btn-sm">Crear usuario</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal editar usuario -->
<div class="modal fade" id="modal-editar" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="POST">
        <input type="hidden" name="action" value="editar"/>
        <input type="hidden" name="id" id="edit-id"/>
        <div class="modal-header">
          <h6 class="modal-title fw-bold">Editar usuario</h6>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row g-2">
            <div class="col-md-6"><label class="tr-form-label">Nombre *</label><input type="text" name="nombre" id="edit-nombre" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Apellido *</label><input type="text" name="apellido" id="edit-apellido" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Email *</label><input type="email" name="email" id="edit-email" class="form-control" required/></div>
            <div class="col-md-6"><label class="tr-form-label">Teléfono</label><input type="text" name="telefono" id="edit-telefono" class="form-control"/></div>
            <div class="col-md-6">
              <label class="tr-form-label">Rol *</label>
              <select name="rol" class="form-select" id="edit-rol">
                <option value="tecnico">Técnico</option>
                <option value="vendedor">Vendedor</option>
                <option value="admin">Administrador</option>
              </select>
            </div>
            <div class="col-md-6"><label class="tr-form-label">Nueva contraseña (vacío = sin cambio)</label><input type="password" name="password" id="edit-password" class="form-control" minlength="6"/></div>
            <div class="col-12" id="edit-almacen-wrap">
              <label class="tr-form-label">Local / Almacén asignado</label>
              <select name="almacen_id" id="edit-almacen" class="form-select">
                <option value="">— Principal (sin asignar) —</option>
                <?php foreach ($almacenes as $a): ?>
                <option value="<?= $a['id'] ?>">
                  <?= sanitize($a['nombre']) ?>
                  <?= $a['principal'] ? ' (Principal)' : '' ?>
                  [<?= sanitize($a['codigo']) ?>]
                </option>
                <?php endforeach; ?>
              </select>
              <div class="form-text small">El vendedor vende del stock de este local. Si no se asigna, usa el almacén principal.</div>
            </div>
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
function editarUsuario(u) {
  document.getElementById('edit-id').value       = u.id;
  document.getElementById('edit-nombre').value   = u.nombre;
  document.getElementById('edit-apellido').value = u.apellido;
  document.getElementById('edit-email').value    = u.email;
  document.getElementById('edit-telefono').value = u.telefono || '';
  document.getElementById('edit-rol').value      = u.rol;
  document.getElementById('edit-almacen').value  = u.almacen_id || '';
  document.getElementById('edit-password').value = '';
  new bootstrap.Modal(document.getElementById('modal-editar')).show();
}

// Mostrar/ocultar campo almacén según el rol (admin no necesita almacén)
function toggleAlmacenSelect(rolSel, wrapId) {
  const wrap = document.getElementById(wrapId);
  if (!wrap) return;
  wrap.style.display = rolSel.value === 'admin' ? 'none' : '';
}
document.getElementById('nuevo-rol').addEventListener('change', function() {
  toggleAlmacenSelect(this, 'nuevo-almacen-wrap');
});
document.getElementById('edit-rol').addEventListener('change', function() {
  toggleAlmacenSelect(this, 'edit-almacen-wrap');
});
</script>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
