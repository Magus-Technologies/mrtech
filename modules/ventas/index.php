<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_VENDEDOR]);
$db = getDB();

$desde  = $_GET['desde'] ?? date('Y-m-d');
$hasta  = $_GET['hasta'] ?? date('Y-m-d');
$q      = trim($_GET['q'] ?? '');
$print  = $_GET['print'] ?? '';
$formato = $_GET['formato'] ?? 'a4';

$where  = ['DATE(v.created_at) BETWEEN ? AND ?'];
$params = [$desde, $hasta];
if ($q) { $where[] = '(v.codigo LIKE ? OR c.nombre LIKE ?)'; $like='%'.$q.'%'; $params=array_merge($params,[$like,$like]); }

$ventas = $db->prepare("
  SELECT v.*, c.nombre as cliente_nombre, CONCAT(u.nombre,' ',u.apellido) as vendedor
  FROM ventas v
  LEFT JOIN clientes c ON c.id=v.cliente_id
  JOIN usuarios u ON u.id=v.usuario_id
  WHERE ".implode(' AND ',$where)."
  ORDER BY v.created_at DESC LIMIT 300");
$ventas->execute($params);
$ventas = $ventas->fetchAll();

$totalDia = array_sum(array_map(fn($v)=>$v['estado']==='completada'?$v['total']:0, $ventas));
$totalBase = array_sum(array_map(fn($v)=>$v['estado']==='completada'?$v['subtotal']:0, $ventas));
$totalIgv = array_sum(array_map(fn($v)=>$v['estado']==='completada'?$v['igv']:0, $ventas));
$empresa  = $db->query("SELECT valor FROM configuracion WHERE clave='empresa_nombre'")->fetchColumn() ?: APP_NAME;
$empresaRuc = $db->query("SELECT valor FROM configuracion WHERE clave='empresa_ruc'")->fetchColumn() ?: '';

$esPrint  = $print === '1';
$esThermal = in_array($formato, ['ticket58','ticket80']);

if ($esPrint):
?><!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<title>Reporte de ventas — <?= sanitize($empresa) ?></title>
<?php if ($esThermal): ?>
<?php $is58 = $formato === 'ticket58'; $pageW = $is58 ? '58mm' : '80mm'; $fontS = $is58 ? '9px' : '11px'; ?>
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'Courier New',Courier,monospace; font-size:<?= $fontS ?>; color:#000; background:#fff; padding:<?= $is58?'6px 4px':'10px 8px' ?>; }
  .c { text-align:center; }
  .r { text-align:right; }
  .b { font-weight:bold; }
  hr { border:none; border-top:1px dashed #000; margin:3px 0; }
  table { width:100%; border-collapse:collapse; }
  th, td { padding:1px 0; }
  th { border-bottom:1px dashed #000; }
  .tt { font-weight:bold; }
  @media print { @page { size:<?= $pageW ?> auto; margin:0; } body { padding:<?= $is58?'3mm':'5mm' ?>; } }
</style>
</head>
<body>
<div class="c b" style="font-size:<?= $is58?'11px':'13px' ?>"><?= sanitize($empresa) ?></div>
<div class="c"><?= sanitize($empresaRuc) ?></div>
<div class="c">REPORTE DE VENTAS</div>
<div class="c"><?= date('d/m/Y',strtotime($desde)) ?> → <?= date('d/m/Y',strtotime($hasta)) ?></div>
<hr/>
<table>
  <tr><th>COD</th><th>CLIENTE</th><th>MONTO</th><th>MET</th></tr>
  <?php foreach($ventas as $v): ?>
  <tr>
    <td><?= sanitize($v['codigo']) ?></td>
    <td><?= sanitize(mb_strimwidth($v['cliente_nombre']??'CF',0,$is58?18:28,'…')) ?></td>
    <td class="r"><?= number_format($v['total'],2) ?></td>
    <td><?= ucfirst(substr($v['metodo_pago'],0,4)) ?></td>
  </tr>
  <?php endforeach; ?>
</table>
<hr/>
<div class="r">
  BASE: S/ <?= number_format($totalBase,2) ?><br/>
  IGV: S/ <?= number_format($totalIgv,2) ?><br/>
  <span class="tt">TOTAL: S/ <?= number_format($totalDia,2) ?></span>
</div>
<div class="c" style="margin-top:4px"><?= sanitize($empresa) ?> — ¡Gracias!</div>
<script>window.addEventListener('load',()=>setTimeout(()=>window.print(),300));</script>
</body>
</html>
<?php return; endif; // ─═ FIN THERMAL ═─ ?>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:'Inter',Arial,sans-serif; font-size:12px; color:#1a1a1a; background:#f0f0f0; padding:20px; }
  .page { background:#fff; width:297mm; min-height:180mm; margin:0 auto; padding:10mm 12mm; box-shadow:0 2px 20px rgba(0,0,0,.12); }
  h2 { font-size:18px; font-weight:800; color:#1a1a2e; }
  .sub { font-size:10px; color:#6b7280; margin-bottom:8px; }
  table { width:100%; border-collapse:collapse; }
  th { background:#1a1a2e; color:#fff; font-size:9px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; padding:5px 6px; text-align:left; }
  td { padding:4px 6px; border-bottom:1px solid #e5e7eb; font-size:10px; }
  tr:nth-child(even) td { background:#f9fafb; }
  .r { text-align:right; }
  .c { text-align:center; }
  .b { font-weight:700; }
  .tot { text-align:right; border-top:2px solid #1a1a2e; padding:6px; font-size:13px; font-weight:800; }
  .no-print { display:flex; gap:8px; align-items:center; margin-bottom:12px; flex-wrap:wrap; }
  @media print {
    body { background:#fff; padding:0; }
    .page { box-shadow:none; padding:8mm 10mm; width:100%; min-height:auto; }
    .no-print { display:none !important; }
    @page { size:297mm auto; margin:0; }
  }
</style>
</head>
<body>
<div class="no-print">
  <button onclick="window.print()" style="background:#1a1a2e;color:#fff;border:none;border-radius:8px;padding:10px 20px;font-size:14px;font-weight:700;cursor:pointer">🖨️ Imprimir PDF</button>
  <button onclick="window.close()" style="background:#f3f4f6;border:none;border-radius:8px;padding:10px 16px;font-size:14px;cursor:pointer">← Volver</button>
  <span class="text-muted" style="font-size:12px">Formato: A4 apaisado</span>
</div>
<div class="page">
  <div style="display:flex;justify-content:space-between;align-items:flex-start;border-bottom:3px solid #1a1a2e;padding-bottom:8px;margin-bottom:10px">
    <div><h2><?= sanitize($empresa) ?></h2><div style="font-size:10px;color:#6b7280"><?= sanitize($empresaRuc) ?></div></div>
    <div style="text-align:right"><div style="font-size:14px;font-weight:800;color:#1a1a2e">REPORTE DE VENTAS</div><div style="font-size:10px;color:#9ca3af"><?= date('d/m/Y',strtotime($desde)) ?> → <?= date('d/m/Y',strtotime($hasta)) ?></div></div>
  </div>
  <table>
    <thead><tr><th>#</th><th>Código</th><th>Cliente</th><th>Doc.</th><th class="r">Base</th><th class="r">IGV</th><th class="r">Total</th><th>Método</th><th>Estado</th><th>Fecha</th></tr></thead>
    <tbody>
      <?php foreach($ventas as $i=>$v): ?>
      <tr>
        <td class="c text-muted"><?= $i+1 ?></td>
        <td><b><?= sanitize($v['codigo']) ?></b></td>
        <td><?= sanitize($v['cliente_nombre']??'Consumidor final') ?></td>
        <td class="c"><?= ucfirst($v['tipo_doc']) ?></td>
        <td class="r"><?= number_format($v['subtotal'],2) ?></td>
        <td class="r text-muted"><?= number_format($v['igv'],2) ?></td>
        <td class="r b"><?= number_format($v['total'],2) ?></td>
        <td class="c"><?= ucfirst($v['metodo_pago']) ?></td>
        <td class="c"><?= ucfirst($v['estado']) ?></td>
        <td style="font-size:9px;color:#9ca3af"><?= date('d/m/Y',strtotime($v['created_at'])) ?></td>
      </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
  <div style="display:flex;justify-content:flex-end;margin-top:8px">
    <div style="width:220px">
      <div class="tot">TOTAL: S/ <?= number_format($totalDia,2) ?></div>
    </div>
  </div>
</div>
<script>if(new URLSearchParams(window.location.search).get('print')==='1'){window.addEventListener('load',()=>setTimeout(()=>window.print(),400));}</script>
</body>
</html>
<?php return; endif; // ─═ FIN PRINT ═─

$pageTitle  = 'Historial de ventas — '.APP_NAME;
$breadcrumb = [['label'=>'Ventas','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Historial de ventas</h5>
  <div class="d-flex gap-2">
    <div class="dropdown">
      <button class="btn btn-outline-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown">
        <i data-feather="printer" style="width:13px;height:13px"></i> Imprimir
      </button>
      <ul class="dropdown-menu dropdown-menu-end" style="font-size:13px">
        <li><a class="dropdown-item" href="?print=1&formato=a4&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">📄 A4 apaisado</a></li>
        <li><a class="dropdown-item" href="?print=1&formato=ticket80&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">🧾 Voucher 80mm</a></li>
        <li><a class="dropdown-item" href="?print=1&formato=ticket58&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">🧾 Ticket 58mm</a></li>
      </ul>
    </div>
    <a href="<?= BASE_URL ?>modules/ventas/pos.php" class="btn btn-primary btn-sm">
      <i data-feather="shopping-cart" style="width:14px;height:14px"></i> Ir al POS
    </a>
  </div>
</div>
<div class="tr-card mb-3">
  <div class="tr-card-body py-2">
    <form method="GET" class="row g-2 align-items-end">
      <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Código o cliente..." value="<?= sanitize($q) ?>"/></div>
      <div class="col-md-2"><input type="date" name="desde" class="form-control form-control-sm" value="<?= $desde ?>"/></div>
      <div class="col-md-2"><input type="date" name="hasta" class="form-control form-control-sm" value="<?= $hasta ?>"/></div>
      <div class="col-md-1"><button type="submit" class="btn btn-primary btn-sm w-100">Filtrar</button></div>
      <div class="col-md-4 text-end">
        <span class="text-muted small">Total período: </span>
        <span class="fw-bold text-success"><?= formatMoney($totalDia) ?></span>
      </div>
    </form>
  </div>
</div>
<div class="tr-card">
  <div class="tr-card-body p-0" style="overflow:hidden"><div class="table-responsive-wrapper" style="overflow-x:auto;-webkit-overflow-scrolling:touch">
    <table class="tr-table">
      <thead><tr><th>Código</th><th>Cliente</th><th>Tipo doc.</th><th>Subtotal</th><th>IGV</th><th>Total</th><th>Método</th><th>Vendedor</th><th>Estado</th><th>SUNAT</th><th>Fecha</th><th></th></tr></thead>
      <tbody>
        <?php foreach($ventas as $v): ?>
        <?php
          $sunatBadge = match($v['sunat_estado'] ?? null) {
              'aceptado'  => '<span class="badge bg-success">Aceptado</span>',
              'rechazado' => '<span class="badge bg-danger">Rechazado</span>',
              'pendiente' => '<span class="badge bg-warning text-dark">Pendiente</span>',
              default     => in_array($v['tipo_doc'],['factura','boleta']) ? '<span class="badge bg-secondary">Sin emitir</span>' : '—',
          };
        ?>
        <tr>
          <td><span class="fw-semibold small text-primary"><?= sanitize($v['codigo']) ?></span></td>
          <td class="small"><?= sanitize($v['cliente_nombre'] ?? '— Consumidor final —') ?></td>
          <td><span class="badge bg-secondary"><?= ucfirst($v['tipo_doc']) ?></span></td>
          <td class="small"><?= formatMoney($v['subtotal']) ?></td>
          <td class="small text-muted"><?= formatMoney($v['igv']) ?></td>
          <td class="fw-bold"><?= formatMoney($v['total']) ?></td>
          <td class="small"><?= ucfirst($v['metodo_pago']) ?></td>
          <td class="small text-muted"><?= sanitize($v['vendedor']) ?></td>
          <td><span class="badge bg-<?= $v['estado']==='completada'?'success':($v['estado']==='anulada'?'danger':'warning') ?>"><?= ucfirst($v['estado']) ?></span></td>
          <td><?= $sunatBadge ?></td>
          <td class="small text-muted"><?= formatDateTime($v['created_at']) ?></td>
              <td>
              <div class="btn-group btn-group-sm">
                <a href="<?= BASE_URL ?>modules/ventas/detalle.php?id=<?= $v['id'] ?>" class="btn btn-outline-primary" title="Ver detalle"><i data-feather="eye" style="width:13px;height:13px"></i></a>
                <a href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>" target="_blank" class="btn btn-outline-secondary" title="Imprimir comprobante"><i data-feather="printer" style="width:13px;height:13px"></i></a>
              </div>
            </td>
        </tr>
        <?php endforeach; ?>
        <?php if(empty($ventas)): ?><tr><td colspan="12" class="text-center text-muted py-4">Sin ventas en el período</td></tr><?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
