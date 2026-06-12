<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/_lib.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

$db = getDB();
$id = (int)($_GET['id'] ?? 0);

$st = $db->prepare("SELECT t.*,
                           ao.nombre AS origen_nombre, ao.codigo AS origen_codigo,
                           ad.nombre AS destino_nombre, ad.codigo AS destino_codigo,
                           CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre,
                           CONCAT(ur.nombre,' ',ur.apellido) AS recibe_nombre
                    FROM traslados t
                    JOIN almacenes ao ON ao.id=t.almacen_origen
                    JOIN almacenes ad ON ad.id=t.almacen_destino
                    JOIN usuarios  u  ON u.id=t.usuario_id
                    LEFT JOIN usuarios ur ON ur.id=t.usuario_recibe
                    WHERE t.id=?");
$st->execute([$id]);
$tr = $st->fetch();
if (!$tr) { setFlash('danger','Traslado no encontrado.'); redirect(BASE_URL.'modules/traslados/index.php'); }

$det = $db->prepare("SELECT td.*, p.codigo, p.nombre, p.marca, p.modelo, p.unidad
                     FROM traslado_detalle td
                     JOIN productos p ON p.id=td.producto_id
                     WHERE td.traslado_id=? ORDER BY p.nombre");
$det->execute([$id]);
$lineas = $det->fetchAll();

$estadoBadge = [
    'borrador'    => ['Borrador','secondary'],
    'en_transito' => ['En tránsito','warning'],
    'recibido'    => ['Recibido','success'],
    'anulado'     => ['Anulado','danger'],
];
[$elabel,$ecolor] = $estadoBadge[$tr['estado']] ?? [$tr['estado'],'secondary'];

$pageTitle  = 'Traslado '.$tr['codigo'].' — '.APP_NAME;
$breadcrumb = [
    ['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],
    ['label'=>'Traslados','url'=>BASE_URL.'modules/traslados/index.php'],
    ['label'=>$tr['codigo'],'url'=>null],
];
require_once __DIR__ . '/../../includes/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-3">
  <div>
    <h5 class="fw-bold mb-0">Traslado <code><?= sanitize($tr['codigo']) ?></code></h5>
    <span class="badge bg-<?= $ecolor ?> mt-1"><?= $elabel ?></span>
  </div>
  <div class="d-flex gap-2">
    <?php if ($tr['estado']==='en_transito'): ?>
    <a href="<?= BASE_URL ?>modules/traslados/index.php?accion=recibir&id=<?= $tr['id'] ?>"
       class="btn btn-success btn-sm"
       onclick="return confirm('¿Confirmar la recepción? El stock entrará al destino.')">
      <i data-feather="check" style="width:14px;height:14px"></i> Confirmar recepción
    </a>
    <?php endif; ?>
    <button onclick="window.print()" class="btn btn-outline-secondary btn-sm">
      <i data-feather="printer" style="width:14px;height:14px"></i> Imprimir
    </button>
    <a href="<?= BASE_URL ?>modules/traslados/index.php" class="btn btn-outline-secondary btn-sm">Volver</a>
  </div>
</div>

<div class="row g-3 mb-3">
  <div class="col-md-6">
    <div class="tr-card h-100"><div class="tr-card-body">
      <div class="text-muted small mb-1">ORIGEN</div>
      <div class="fw-bold"><?= sanitize($tr['origen_nombre']) ?> <code class="small"><?= sanitize($tr['origen_codigo']) ?></code></div>
    </div></div>
  </div>
  <div class="col-md-6">
    <div class="tr-card h-100"><div class="tr-card-body">
      <div class="text-muted small mb-1">DESTINO</div>
      <div class="fw-bold"><?= sanitize($tr['destino_nombre']) ?> <code class="small"><?= sanitize($tr['destino_codigo']) ?></code></div>
    </div></div>
  </div>
</div>

<div class="tr-card mb-3"><div class="tr-card-body">
  <div class="row g-3 small">
    <div class="col-md-3"><span class="text-muted d-block">Creado por</span><?= sanitize($tr['usuario_nombre']) ?></div>
    <div class="col-md-3"><span class="text-muted d-block">Fecha</span><?= formatDateTime($tr['created_at']) ?></div>
    <div class="col-md-3"><span class="text-muted d-block">Recibido por</span><?= $tr['recibe_nombre'] ? sanitize($tr['recibe_nombre']) : '—' ?></div>
    <div class="col-md-3"><span class="text-muted d-block">Recibido el</span><?= $tr['recibido_at'] ? formatDateTime($tr['recibido_at']) : '—' ?></div>
  </div>
  <?php if ($tr['observacion']): ?>
  <hr class="my-2"><div class="small"><span class="text-muted">Observación:</span> <?= sanitize($tr['observacion']) ?></div>
  <?php endif; ?>
</div></div>

<div class="tr-card">
  <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">PRODUCTOS TRASLADADOS</h6></div>
  <div class="tr-card-body p-0">
    <table class="tr-table">
      <thead><tr><th>Código</th><th>Producto</th><th class="text-end">Cantidad</th></tr></thead>
      <tbody>
        <?php foreach ($lineas as $l): ?>
        <tr>
          <td><code><?= sanitize($l['codigo']) ?></code></td>
          <td>
            <div class="fw-semibold"><?= sanitize($l['nombre']) ?></div>
            <?php if ($l['marca']): ?><div class="text-muted small"><?= sanitize($l['marca'].' '.($l['modelo']??'')) ?></div><?php endif; ?>
          </td>
          <td class="text-end fw-bold"><?= number_format($l['cantidad'],2) ?> <span class="text-muted small"><?= sanitize($l['unidad']) ?></span></td>
        </tr>
        <?php endforeach; ?>
      </tbody>
      <tfoot>
        <tr class="fw-bold"><td colspan="2" class="text-end">Total</td>
          <td class="text-end"><?= number_format($tr['total_unidades'],2) ?> u. / <?= (int)$tr['total_items'] ?> ítems</td></tr>
      </tfoot>
    </table>
  </div>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
