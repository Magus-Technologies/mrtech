<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/_lib.php';
requireLogin();
requireRole([ROL_ADMIN]);

$db = getDB();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $accion = $_POST['accion'] ?? '';

    if ($accion === 'guardar') {
        $id        = (int)($_POST['id'] ?? 0);
        $codigo    = strtoupper(trim($_POST['codigo'] ?? ''));
        $nombre    = trim($_POST['nombre'] ?? '');
        $tipo      = $_POST['tipo'] ?? 'almacen';
        $direccion = trim($_POST['direccion'] ?? '');
        $activo    = isset($_POST['activo']) ? 1 : 0;

        if ($codigo === '' || $nombre === '') {
            setFlash('danger','Código y nombre son obligatorios.');
            redirect(BASE_URL.'modules/traslados/almacenes.php');
        }
        if (!in_array($tipo, ['tienda','almacen','deposito'])) $tipo = 'almacen';

        try {
            if ($id > 0) {
                $db->prepare("UPDATE almacenes SET codigo=?, nombre=?, tipo=?, direccion=?, activo=? WHERE id=?")
                   ->execute([$codigo,$nombre,$tipo,$direccion,$activo,$id]);
                setFlash('success','Almacén actualizado.');
            } else {
                $db->prepare("INSERT INTO almacenes (codigo,nombre,tipo,direccion,activo,principal) VALUES (?,?,?,?,?,0)")
                   ->execute([$codigo,$nombre,$tipo,$direccion,$activo]);
                // Crear filas de stock en 0 para todos los productos del nuevo almacén
                $nuevoId = (int)$db->lastInsertId();
                $db->prepare("INSERT IGNORE INTO stock_almacen (almacen_id,producto_id,cantidad)
                              SELECT ?, id, 0 FROM productos")->execute([$nuevoId]);
                setFlash('success','Almacén creado.');
            }
        } catch (\PDOException $e) {
            setFlash('danger', str_contains($e->getMessage(),'Duplicate')
                ? 'Ya existe un almacén con ese código.'
                : 'Error al guardar el almacén.');
        }
        redirect(BASE_URL.'modules/traslados/almacenes.php');
    }
}

$almacenes = listarAlmacenes($db, false);

// Valor del inventario por almacén (informativo)
$valores = $db->query("
    SELECT sa.almacen_id,
           SUM(sa.cantidad)                       AS unidades,
           SUM(sa.cantidad * p.precio_costo)      AS valor
    FROM stock_almacen sa
    JOIN productos p ON p.id=sa.producto_id
    GROUP BY sa.almacen_id
")->fetchAll(PDO::FETCH_UNIQUE);

$pageTitle  = 'Almacenes — '.APP_NAME;
$breadcrumb = [
    ['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],
    ['label'=>'Traslados','url'=>BASE_URL.'modules/traslados/index.php'],
    ['label'=>'Almacenes','url'=>null],
];
require_once __DIR__ . '/../../includes/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Almacenes</h5>
  <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalAlmacen" onclick="nuevoAlmacen()">
    <i data-feather="plus" style="width:14px;height:14px"></i> Nuevo almacén
  </button>
</div>

<div class="tr-card">
  <div class="tr-card-body p-0">
    <table class="tr-table">
      <thead><tr><th>Código</th><th>Nombre</th><th>Tipo</th><th>Unidades</th><th>Valor (costo)</th><th>Estado</th><th></th></tr></thead>
      <tbody>
        <?php foreach ($almacenes as $a):
          $v = $valores[$a['id']] ?? ['unidades'=>0,'valor'=>0]; ?>
        <tr>
          <td><code><?= sanitize($a['codigo']) ?></code></td>
          <td class="fw-semibold">
            <?= sanitize($a['nombre']) ?>
            <?php if ($a['principal']): ?><span class="badge bg-primary ms-1" style="font-size:10px">PRINCIPAL</span><?php endif; ?>
          </td>
          <td><span class="badge bg-secondary"><?= ucfirst($a['tipo']) ?></span></td>
          <td><?= number_format($v['unidades'] ?? 0,0) ?></td>
          <td><?= formatMoney($v['valor'] ?? 0) ?></td>
          <td><?= $a['activo'] ? '<span class="badge bg-success">Activo</span>' : '<span class="badge bg-secondary">Inactivo</span>' ?></td>
          <td class="text-end">
            <button class="btn btn-sm btn-outline-secondary"
                    onclick='editarAlmacen(<?= json_encode($a, JSON_HEX_APOS|JSON_HEX_QUOT) ?>)'
                    data-bs-toggle="modal" data-bs-target="#modalAlmacen" title="Editar">
              <i data-feather="edit-2" style="width:13px;height:13px"></i>
            </button>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<p class="text-muted small mt-2">
  El almacén <strong>principal</strong> está sincronizado con el stock que usan ventas, POS, OT y compras.
  Por seguridad no se puede eliminar; si dejas de usar uno, márcalo como inactivo.
</p>

<!-- Modal -->
<div class="modal fade" id="modalAlmacen" tabindex="-1">
  <div class="modal-dialog">
    <form method="POST" class="modal-content">
      <input type="hidden" name="accion" value="guardar">
      <input type="hidden" name="id" id="alm-id">
      <div class="modal-header">
        <h6 class="modal-title fw-bold" id="modal-titulo">Nuevo almacén</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-2">
          <div class="col-4">
            <label class="tr-form-label">Código *</label>
            <input type="text" name="codigo" id="alm-codigo" class="form-control" maxlength="20" required>
          </div>
          <div class="col-8">
            <label class="tr-form-label">Nombre *</label>
            <input type="text" name="nombre" id="alm-nombre" class="form-control" maxlength="100" required>
          </div>
          <div class="col-12">
            <label class="tr-form-label">Tipo</label>
            <select name="tipo" id="alm-tipo" class="form-select">
              <option value="tienda">Tienda</option>
              <option value="almacen">Almacén</option>
              <option value="deposito">Depósito</option>
            </select>
          </div>
          <div class="col-12">
            <label class="tr-form-label">Dirección</label>
            <input type="text" name="direccion" id="alm-direccion" class="form-control" maxlength="255">
          </div>
          <div class="col-12">
            <div class="form-check">
              <input type="checkbox" name="activo" id="alm-activo" class="form-check-input" checked>
              <label class="form-check-label" for="alm-activo">Activo</label>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-primary">Guardar</button>
      </div>
    </form>
  </div>
</div>

<script>
function nuevoAlmacen(){
  document.getElementById('modal-titulo').textContent='Nuevo almacén';
  document.getElementById('alm-id').value='';
  document.getElementById('alm-codigo').value='';
  document.getElementById('alm-codigo').readOnly=false;
  document.getElementById('alm-nombre').value='';
  document.getElementById('alm-tipo').value='almacen';
  document.getElementById('alm-direccion').value='';
  document.getElementById('alm-activo').checked=true;
}
function editarAlmacen(a){
  document.getElementById('modal-titulo').textContent='Editar almacén';
  document.getElementById('alm-id').value=a.id;
  document.getElementById('alm-codigo').value=a.codigo;
  document.getElementById('alm-nombre').value=a.nombre;
  document.getElementById('alm-tipo').value=a.tipo;
  document.getElementById('alm-direccion').value=a.direccion||'';
  document.getElementById('alm-activo').checked=(a.activo==1);
}
</script>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
