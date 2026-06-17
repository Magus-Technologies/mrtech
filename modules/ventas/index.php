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
$esPdfReport = $esPrint && isset($_GET['pdf']);

// ── Helper: renderiza HTML del reporte ─────────────
function renderReportHtml(array $ventas, string $empresa, string $empresaRuc, string $formato, string $desde, string $hasta, float $totalBase, float $totalIgv, float $totalDia): string {
    $esThermal = in_array($formato, ['ticket58','ticket80']);
    $is58 = $formato === 'ticket58';
    ob_start();
    if ($esThermal): ?>
<div style="font-family:'Courier New',Courier,monospace;font-size:<?= $is58?'8px':'10px' ?>;padding:<?= $is58?'2mm 3mm':'3mm 5mm' ?>">
  <div style="text-align:center;font-weight:bold;font-size:<?= $is58?'10px':'12px' ?>"><?= sanitize($empresa) ?></div>
  <div style="text-align:center;font-size:<?= $is58?'7px':'9px' ?>"><?= sanitize($empresaRuc) ?></div>
  <div style="text-align:center;font-weight:bold">REPORTE DE VENTAS</div>
  <div style="text-align:center;font-size:<?= $is58?'7px':'9px' ?>;border-bottom:1px dashed #000;padding-bottom:2px;margin-bottom:2px"><?= date('d/m/Y',strtotime($desde)) ?> → <?= date('d/m/Y',strtotime($hasta)) ?></div>
  <table style="width:100%;border-collapse:collapse"><tr><th style="text-align:left;border-bottom:1px dashed #000;padding:1px 2px">CÓDIGO</th><th style="text-align:left;border-bottom:1px dashed #000;padding:1px 2px">CLIENTE</th><th style="text-align:right;border-bottom:1px dashed #000;padding:1px 2px" colspan="2">MONTO</th></tr>
    <?php foreach($ventas as $v): ?><tr><td style="padding:1px 2px;font-size:<?= $is58?'7px':'9px' ?>"><?= sanitize($v['codigo']) ?></td><td style="padding:1px 2px;font-size:<?= $is58?'7px':'9px' ?>"><?= sanitize(mb_strimwidth($v['cliente_nombre']??'CF',0,$is58?14:22,'…')) ?></td><td style="text-align:right;padding:1px 2px;font-size:<?= $is58?'7px':'9px' ?>"><?= number_format($v['total'],2) ?></td><td style="text-align:center;padding:1px 2px;font-size:<?= $is58?'7px':'9px' ?>"><?= substr($v['metodo_pago'],0,4) ?></td></tr><?php endforeach; ?>
  </table>
  <div style="border-top:1px dashed #000;margin:2px 0"></div>
  <div style="text-align:right;font-size:<?= $is58?'8px':'10px' ?>">BASE: S/ <?= number_format($totalBase,2) ?><br/>IGV: S/ <?= number_format($totalIgv,2) ?><br/><span style="font-weight:bold;font-size:<?= $is58?'10px':'12px' ?>">TOTAL: S/ <?= number_format($totalDia,2) ?></span></div>
  <div style="text-align:center;margin-top:3px;font-size:<?= $is58?'7px':'9px' ?>"><?= sanitize($empresa) ?></div>
</div>
    <?php else: ?>
<div style="font-family:Helvetica,Arial,sans-serif;padding:5mm 7mm">
  <div style="display:flex;justify-content:space-between;align-items:flex-start;border-bottom:3px solid #1a1a2e;padding-bottom:8px;margin-bottom:10px">
    <div><h2 style="font-size:18px;font-weight:800;color:#1a1a2e;margin:0"><?= sanitize($empresa) ?></h2><div style="font-size:10px;color:#6b7280"><?= sanitize($empresaRuc) ?></div></div>
    <div style="text-align:right;font-weight:800;color:#1a1a2e">REPORTE DE VENTAS<br/><span style="font-weight:400;font-size:10px;color:#9ca3af"><?= date('d/m/Y',strtotime($desde)) ?> → <?= date('d/m/Y',strtotime($hasta)) ?></span></div>
  </div>
  <table style="width:100%;border-collapse:collapse"><thead><tr><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:left;border:1px solid #d1d5db">#</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:left;border:1px solid #d1d5db">Código</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:left;border:1px solid #d1d5db">Cliente</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:center;border:1px solid #d1d5db">Doc.</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:right;border:1px solid #d1d5db">Base</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:right;border:1px solid #d1d5db">IGV</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:right;border:1px solid #d1d5db">Total</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:center;border:1px solid #d1d5db">Método</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:center;border:1px solid #d1d5db">Estado</th><th style="background:#1a1a2e;color:#fff;font-size:9px;font-weight:700;text-transform:uppercase;padding:5px 6px;text-align:center;border:1px solid #d1d5db">Fecha</th></tr></thead><tbody><?php foreach($ventas as $i=>$v): ?><tr><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:center"><?= $i+1 ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;font-weight:600"><?= sanitize($v['codigo']) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px"><?= sanitize($v['cliente_nombre']??'Consumidor final') ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:center"><?= ucfirst($v['tipo_doc']) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:right"><?= number_format($v['subtotal'],2) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:right;color:#6b7280"><?= number_format($v['igv'],2) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:right;font-weight:700"><?= number_format($v['total'],2) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:center"><?= ucfirst($v['metodo_pago']) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:10px;text-align:center"><?= ucfirst($v['estado']) ?></td><td style="padding:4px 6px;border:1px solid #e5e7eb;font-size:9px;text-align:center;color:#9ca3af"><?= date('d/m/Y',strtotime($v['created_at'])) ?></td></tr><?php endforeach; ?></tbody></table>
  <div style="display:flex;justify-content:flex-end;margin-top:8px"><div style="width:220px"><div style="text-align:right;border-top:2px solid #1a1a2e;padding:5px 0;font-weight:800;font-size:13px">TOTAL: S/ <?= number_format($totalDia,2) ?></div></div></div>
  <div style="text-align:center;margin-top:12px;border-top:1px dashed #e5e7eb;padding-top:8px;font-size:10px;color:#6b7280"><?= sanitize($empresa) ?> — Reporte generado el <?= date('d/m/Y H:i') ?></div>
</div>
    <?php endif;
    return ob_get_clean();
}

// ── PDF del reporte ───────────────────────────────
if ($esPdfReport):
    $html = renderReportHtml($ventas, $empresa, $empresaRuc, $formato, $desde, $hasta, $totalBase, $totalIgv, $totalDia);
    try {
        $autoloadPath = realpath(__DIR__ . '/../../vendor/autoload.php');
        if ($autoloadPath) require_once $autoloadPath;
        if ($esThermal) {
            $pageSize = $formato === 'ticket58' ? [0,0,58*2.8346,297*2.8346] : [0,0,80*2.8346,297*2.8346];
            $orientation = 'portrait';
        } else {
            $pageSize = 'A4';
            $orientation = 'landscape';
        }
        $pdf = generarPdf($html, $pageSize, $orientation);
        $pdf->stream('reporte-ventas-'.$desde.'-'.$hasta.'.pdf', ['Attachment' => false]);
    } catch (\Throwable $e) {
        die('Error al generar PDF: ' . $e->getMessage());
    }
    exit;
endif;

// ── Vista previa imprimible del reporte ───────────
if ($esPrint):
?><!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<title>Reporte de ventas — <?= sanitize($empresa) ?></title>
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'Courier New',Courier,monospace; font-size:9px; color:#000; background:#fff; padding:5mm; }
  @media print { @page { margin:0; } body { padding:3mm; } }
</style>
</head>
<body>
<?= renderReportHtml($ventas, $empresa, $empresaRuc, $formato, $desde, $hasta, $totalBase, $totalIgv, $totalDia) ?>
<script>window.addEventListener('load',()=>setTimeout(()=>window.print(),300));</script>
</body>
</html>
<?php return; endif; // ─═ FIN REPORTE ═─

$pageTitle  = 'Historial de ventas — '.APP_NAME;
$breadcrumb = [['label'=>'Ventas','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Historial de ventas</h5>
  <div class="d-flex gap-2">
    <div class="dropdown">
      <button class="btn btn-outline-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown">
        <i data-feather="printer" style="width:13px;height:13px"></i> Reporte
      </button>
      <ul class="dropdown-menu dropdown-menu-end" style="font-size:13px">
        <li><a class="dropdown-item" href="?print=1&pdf=1&formato=a4&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">📄 A4 apaisado</a></li>
        <li><a class="dropdown-item" href="?print=1&pdf=1&formato=ticket80&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">🧾 Voucher 80mm</a></li>
        <li><a class="dropdown-item" href="?print=1&pdf=1&formato=ticket58&desde=<?= urlencode($desde) ?>&hasta=<?= urlencode($hasta) ?>&q=<?= urlencode($q) ?>" target="_blank">🧾 Ticket 58mm</a></li>
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
  <div class="tr-card-body p-0"><div class="table-responsive-wrapper" style="overflow-x:auto;-webkit-overflow-scrolling:touch">
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
                <div class="btn-group btn-group-sm" data-bs-boundary="viewport">
                  <button class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" title="Imprimir comprobante"><i data-feather="printer" style="width:13px;height:13px"></i></button>
                  <ul class="dropdown-menu dropdown-menu-end" style="font-size:12px;min-width:160px">
                    <li><a class="dropdown-item" href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>" target="_blank">👁 Vista previa</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><h6 class="dropdown-header">Descargar PDF</h6></li>
                    <li><a class="dropdown-item" href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>&pdf=1" target="_blank">📄 A4</a></li>
                    <li><a class="dropdown-item" href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>&pdf=1&formato=ticket80" target="_blank">🧾 80mm</a></li>
                    <li><a class="dropdown-item" href="<?= BASE_URL ?>modules/ventas/ticket.php?id=<?= $v['id'] ?>&pdf=1&formato=ticket58" target="_blank">🧾 58mm</a></li>
                  </ul>
                </div>
              </div>
            </td>
        </tr>
        <?php endforeach; ?>
        <?php if(empty($ventas)): ?><tr><td colspan="12" class="text-center text-muted py-4">Sin ventas en el período</td></tr><?php endif; ?>
      </tbody>
    </table>
  </div>
</div>
<script>
// Evita scroll horizontal cuando se abre dropdown en tabla responsive
document.addEventListener('show.bs.dropdown', function(e) {
  var w = e.target.closest('.table-responsive-wrapper');
  if (w) w.style.overflow = 'visible';
});
document.addEventListener('hidden.bs.dropdown', function(e) {
  var w = e.target.closest('.table-responsive-wrapper');
  if (w) w.style.overflow = '';
});
</script>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
