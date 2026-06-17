<?php
/**
 * ticket.php — Comprobante de venta (Boleta / Factura / Ticket)
 * Usar: modules/ventas/ticket.php?id=123
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
$autoloadPath = realpath(__DIR__ . '/../../vendor/autoload.php');
if ($autoloadPath) require_once $autoloadPath;
requireLogin();

$db = getDB();
$id = (int)($_GET['id'] ?? 0);

$venta = $db->prepare("
    SELECT v.*, c.nombre AS cliente_nombre, c.ruc_dni, c.telefono, c.direccion,
           CONCAT(u.nombre,' ',u.apellido) AS cajero_nombre,
           CONCAT(COALESCE(uv.nombre,''), ' ', COALESCE(uv.apellido,'')) AS vendedora_nombre
    FROM ventas v
    LEFT JOIN clientes c  ON c.id  = v.cliente_id
    JOIN  usuarios u      ON u.id  = v.usuario_id
    LEFT JOIN usuarios uv ON uv.id = v.vendedor_id
    WHERE v.id=?");
$venta->execute([$id]);
$venta = $venta->fetch();
if (!$venta) die('Venta no encontrada.');

$detalle = $db->prepare("
    SELECT vd.*, p.nombre AS prod_nombre, p.codigo AS prod_codigo, c.nombre AS cat_nombre
    FROM venta_detalle vd
    JOIN productos p ON p.id=vd.producto_id
    JOIN categorias c ON c.id=p.categoria_id
    WHERE vd.venta_id=? ORDER BY vd.id");
$detalle->execute([$id]);
$detalle = $detalle->fetchAll();

// Config empresa
$cfg = [];
foreach ($db->query("SELECT clave,valor FROM configuracion")->fetchAll() as $r) $cfg[$r['clave']] = $r['valor'];
$empresa    = $cfg['empresa_nombre']    ?? APP_NAME;
$empresaRuc = $cfg['empresa_ruc']       ?? '';
$empresaTel = $cfg['empresa_telefono']  ?? '';
$empresaDir = $cfg['empresa_direccion'] ?? '';
$moneda     = $cfg['moneda_simbolo']    ?? 'S/';
$igvPct     = (float)($cfg['igv_porcentaje'] ?? 18);

$tipoDocLabel = [
    'boleta'           => 'BOLETA DE VENTA',
    'factura'          => 'FACTURA',
    'ticket'           => 'TICKET DE VENTA',
    'sin_comprobante'  => 'COMPROBANTE INTERNO',
];
$docLabel = $tipoDocLabel[$venta['tipo_doc']] ?? 'COMPROBANTE';

// Código formateado: serie-num para SUNAT, codigo interno para otros
$codigoDisplay = (in_array($venta['tipo_doc'],['factura','boleta']) && $venta['serie_doc'])
    ? $venta['serie_doc'] . '-' . str_pad((int)$venta['num_doc'], 8, '0', STR_PAD_LEFT)
    : $codigoDisplay;

// ── Formato de impresión ────────────────────────────
$formato = $_GET['formato'] ?? $cfg['print_formato'] ?? 'a4';
$esThermal = in_array($formato, ['ticket58','ticket80']);
$esPdf    = isset($_GET['pdf']);

// ── PDF con Dompdf ──────────────────────────────────
if ($esPdf):
$html     = renderTicketHtml($venta, $detalle, $cfg, $docLabel, $moneda, $igvPct, $formato, $codigoDisplay);
try {
    $pageSize = $esThermal ? ($formato === 'ticket58' ? [0,0,58*2.8346,297*2.8346] : [0,0,80*2.8346,297*2.8346]) : 'A4';
    $pdf = generarPdf($html, $pageSize, 'portrait');
    $pdf->stream(($codigoDisplay??'comprobante').'.pdf', ['Attachment' => false]);
} catch (\Throwable $e) {
    die('Error al generar PDF: ' . $e->getMessage());
}
exit;
endif;

// Helper: renderiza el HTML del ticket sin envoltura HTML
function renderTicketHtml(array $venta, array $detalle, array $cfg, string $docLabel, string $moneda, float $igvPct, string $formato, string $codigoDisplay): string {
    $empresa    = $cfg['empresa_nombre']    ?? APP_NAME;
    $empresaRuc = $cfg['empresa_ruc']       ?? '';
    $empresaTel = $cfg['empresa_telefono']  ?? '';
    $empresaDir = $cfg['empresa_direccion'] ?? '';
    $esThermal  = in_array($formato, ['ticket58','ticket80']);
    $is58       = $formato === 'ticket58';
    ob_start();
    if ($esThermal): ?>
    <div style="font-family:Courier,monospace;font-size:<?= $is58?'8px':'10px' ?>;padding:<?= $is58?'2mm 3mm':'3mm 5mm' ?>">
      <div style="text-align:center;padding:0 0 3px"><b style="font-size:<?= $is58?'10px':'12px' ?>"><?= htmlspecialchars($empresa) ?></b><br/><?= htmlspecialchars($empresaRuc) ?><?php if($empresaDir): ?><br/><?= htmlspecialchars($empresaDir) ?><?php endif; ?></div>
      <div style="border-top:1px solid #000;height:0;margin:2px 0"></div>
      <div style="text-align:center;padding:2px 0;font-weight:bold"><?= $docLabel ?><br/><?= htmlspecialchars($codigoDisplay) ?><br/><?= date('d/m/Y H:i', strtotime($venta['created_at'])) ?></div>
      <div style="border-top:1px solid #000;height:0;margin:2px 0"></div>
      <div style="padding:2px 0"><?php if($venta['ruc_dni']): ?>CLIENTE: <?= htmlspecialchars($venta['ruc_dni']) ?><br/><?php endif; ?><?= htmlspecialchars($venta['cliente_nombre'] ?: 'Consumidor final') ?><br/>CAJERO: <?= htmlspecialchars(trim($venta['vendedora_nombre']) ?: $venta['cajero_nombre']) ?></div>
      <div style="border-top:1px solid #000;height:0;margin:2px 0"></div>
      <table style="width:100%;border-collapse:collapse"><?php foreach($detalle as $d): ?><tr><td style="padding:1px 0;white-space:nowrap;overflow:hidden"><?= htmlspecialchars($d['prod_nombre']) ?></td><td style="text-align:right;padding:1px 0 1px 4px;white-space:nowrap"><?= number_format($d['cantidad'],0) ?></td><td style="text-align:right;padding:1px 0 1px 4px;white-space:nowrap"><?= number_format($d['subtotal'],2) ?></td></tr><?php endforeach; ?></table>
      <div style="border-top:1px solid #000;height:0;margin:2px 0"></div>
      <div style="text-align:right;padding:2px 0">BASE: <?= $moneda ?> <?= number_format($venta['subtotal'],2) ?><br/>IGV <?= number_format($igvPct,0) ?>%: <?= $moneda ?> <?= number_format($venta['igv'],2) ?><br/><?php if($venta['descuento'] > 0): ?>DESC: -<?= $moneda ?> <?= number_format($venta['descuento'],2) ?><br/><?php endif; ?><b>TOTAL: <?= $moneda ?> <?= number_format($venta['total'],2) ?></b></div>
      <div style="border-top:1px solid #000;height:0;margin:2px 0"></div>
      <div style="text-align:center;padding:3px 0;font-size:<?= $is58?'7px':'9px' ?>"><?= htmlspecialchars($empresa) ?><br/>¡Gracias por su compra!<?php if($empresaTel): ?><br/>T: <?= htmlspecialchars($empresaTel) ?><?php endif; ?></div>
    </div>
    <?php else: ?>
    <div style="font-family:Helvetica,Arial,sans-serif;padding:4mm 5mm">
      <table style="width:100%;border-collapse:collapse"><tr>
        <td style="width:50%;vertical-align:top"><b style="font-size:18px"><?= htmlspecialchars($empresa) ?></b><br/><span style="font-size:9px;color:#555"><?php if($empresaRuc): ?>RUC: <?= htmlspecialchars($empresaRuc) ?><br/><?php endif; ?><?php if($empresaDir): ?><?= htmlspecialchars($empresaDir) ?><br/><?php endif; ?><?php if($empresaTel): ?>T: <?= htmlspecialchars($empresaTel) ?><?php endif; ?></span></td>
        <td style="width:50%;vertical-align:top;text-align:right"><b style="font-size:14px"><?= $docLabel ?></b><br/><span style="font-size:10px"><?= htmlspecialchars($codigoDisplay) ?><br/><?= date('d/m/Y H:i', strtotime($venta['created_at'])) ?></span></td>
      </tr></table>
      <div style="border-bottom:2px solid #1a1a2e;margin:4px 0 6px"></div>
      <table style="width:100%;border-collapse:collapse;font-size:9px">
        <tr><td style="background:#1a1a2e;color:#fff;padding:4px 6px;font-weight:bold" colspan="4">DATOS DEL CLIENTE</td></tr>
        <tr><td style="border:1px solid #ccc;padding:3px 5px;width:15%"><b>DNI/RUC</b></td><td style="border:1px solid #ccc;padding:3px 5px;width:35%"><?= htmlspecialchars($venta['ruc_dni'] ?: '—') ?></td><td style="border:1px solid #ccc;padding:3px 5px;width:15%"><b>CLIENTE</b></td><td style="border:1px solid #ccc;padding:3px 5px;width:35%"><?= htmlspecialchars($venta['cliente_nombre'] ?: 'Consumidor final') ?></td></tr>
        <tr><td style="border:1px solid #ccc;padding:3px 5px"><b>TELÉFONO</b></td><td style="border:1px solid #ccc;padding:3px 5px"><?= htmlspecialchars($venta['telefono'] ?: '—') ?></td><td style="border:1px solid #ccc;padding:3px 5px"><b>VENDEDOR</b></td><td style="border:1px solid #ccc;padding:3px 5px"><?= htmlspecialchars(trim($venta['vendedora_nombre']) ?: $venta['cajero_nombre']) ?></td></tr>
      </table>
      <table style="width:100%;border-collapse:collapse;margin-top:6px;font-size:9px">
        <tr><td style="background:#1a1a2e;color:#fff;padding:4px 6px;font-weight:bold" colspan="5">DETALLE DE PRODUCTOS / SERVICIOS</td></tr>
        <tr><th style="border:1px solid #ccc;padding:4px 5px;text-align:center;width:20px">#</th><th style="border:1px solid #ccc;padding:4px 5px;text-align:left">PRODUCTO / SERVICIO</th><th style="border:1px solid #ccc;padding:4px 5px;text-align:center;width:50px">CANT.</th><th style="border:1px solid #ccc;padding:4px 5px;text-align:right;width:70px">P. UNIT.</th><th style="border:1px solid #ccc;padding:4px 5px;text-align:right;width:70px">SUBTOTAL</th></tr>
        <?php foreach($detalle as $i=>$d): ?><tr><td style="border:1px solid #ccc;padding:3px 5px;text-align:center"><?= $i+1 ?></td><td style="border:1px solid #ccc;padding:3px 5px"><b><?= htmlspecialchars($d['prod_nombre']) ?></b><br/><span style="color:#999;font-size:8px"><?= htmlspecialchars($d['prod_codigo']) ?> — <?= htmlspecialchars($d['cat_nombre']) ?></span></td><td style="border:1px solid #ccc;padding:3px 5px;text-align:center"><?= number_format($d['cantidad'],2) ?></td><td style="border:1px solid #ccc;padding:3px 5px;text-align:right"><?= $moneda ?> <?= number_format($d['precio_unit'],2) ?></td><td style="border:1px solid #ccc;padding:3px 5px;text-align:right;font-weight:bold"><?= $moneda ?> <?= number_format($d['subtotal'],2) ?></td></tr><?php endforeach; ?>
      </table>
      <table style="width:100%;border-collapse:collapse;margin-top:4px;font-size:9px">
        <tr><td style="width:65%"></td><td style="border:1px solid #ccc;padding:3px 8px;width:35%"><table style="width:100%"><tr><td style="padding:2px 0;color:#666;font-weight:bold">BASE IMPONIBLE:</td><td style="text-align:right;font-weight:bold"><?= $moneda ?> <?= number_format($venta['subtotal'],2) ?></td></tr><tr><td style="padding:2px 0;color:#666">IGV (<?= $igvPct ?>%):</td><td style="text-align:right"><?= $moneda ?> <?= number_format($venta['igv'],2) ?></td></tr><?php if($venta['descuento'] > 0): ?><tr><td style="padding:2px 0;color:#dc2626">DESCUENTO:</td><td style="text-align:right;color:#dc2626">-<?= $moneda ?> <?= number_format($venta['descuento'],2) ?></td></tr><?php endif; ?><tr><td style="border-top:2px solid #1a1a2e;padding:4px 0;font-weight:bold;font-size:13px">TOTAL:</td><td style="border-top:2px solid #1a1a2e;text-align:right;font-weight:bold;font-size:13px"><?= $moneda ?> <?= number_format($venta['total'],2) ?></td></tr></table></td></tr>
      </table>
      <div style="text-align:center;margin-top:10px;border-top:1px solid #ccc;padding-top:6px;font-size:9px;color:#666"><b style="font-size:11px;color:#1a1a2e"><?= htmlspecialchars($empresa) ?></b><br/>¡Gracias por su compra!<?php if($empresaTel): ?><br/>📞 <?= htmlspecialchars($empresaTel) ?><?php endif; ?></div>
    </div>
    <?php endif;
    return ob_get_clean();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<title><?= $docLabel ?> <?= htmlspecialchars($codigoDisplay) ?></title>
<?php if ($esThermal): ?>
<?php
$is58 = $formato === 'ticket58';
$pageW = $is58 ? '58mm' : '80mm';
$fontS = $is58 ? '9px' : '11px';
$lh    = $is58 ? '1.25' : '1.35';
$pad   = $is58 ? '6px 4px' : '10px 8px';
$mono  = "'Courier New',Courier,monospace";
?>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: <?= $mono ?>;
    font-size: <?= $fontS ?>;
    line-height: <?= $lh ?>;
    color: #000;
    background: #f0f0f0;
    padding: 10px;
  }
  .ticket {
    background: #fff;
    width: <?= $is58 ? '200px' : '300px' ?>;
    margin: 0 auto;
    padding: <?= $pad ?>;
    box-shadow: 0 2px 12px rgba(0,0,0,.12);
    overflow: hidden;
  }
  .ticket .c { text-align: center; }
  .ticket .r { text-align: right; }
  .ticket .b { font-weight: bold; }
  .ticket hr { border: none; border-top: 1px dashed #000; margin: 4px 0; }
  .ticket table { width: 100%; border-collapse: collapse; }
  .ticket td, .ticket th { padding: 1px 0; }
  .ticket .tt { font-weight: bold; font-size: <?= $is58 ? '11px' : '13px' ?>; }

  @media print {
    body { background: #fff; padding: 0; }
    .ticket { box-shadow: none; margin: 0; padding: <?= $is58 ? '6px 3mm' : '8mm' ?>; width: 100%; }
    .no-print { display: none !important; }
    @page { size: <?= $pageW ?> auto; margin: 0; }
  }
</style>
</head>
<body>

<div class="no-print" style="max-width:300px;margin:0 auto 12px;display:flex;gap:6px;flex-wrap:wrap">
  <button onclick="window.print()" style="background:#111;color:#fff;border:none;border-radius:6px;padding:8px 14px;font-size:13px;font-weight:700;cursor:pointer">🖨️ Imprimir</button>
  <a href="?id=<?= $id ?>&pdf=1&formato=<?= $formato ?>" target="_blank" style="background:#2563eb;color:#fff;text-decoration:none;border:none;border-radius:6px;padding:8px 14px;font-size:13px;font-weight:600;cursor:pointer;display:inline-block">📄 PDF</a>
  <button onclick="window.close()" style="background:#f3f4f6;border:none;border-radius:6px;padding:8px 14px;font-size:13px;cursor:pointer">← Volver</button>
</div>

<div class="ticket">
  <div class="c">
    <b style="font-size:<?= $is58 ? '11px' : '13px' ?>"><?= htmlspecialchars($empresa) ?></b><br/>
    <?php if($empresaRuc): ?><?= htmlspecialchars($empresaRuc) ?><br/><?php endif; ?>
    <?php if($empresaDir): ?><?= htmlspecialchars($empresaDir) ?><br/><?php endif; ?>
    <?php if($empresaTel): ?>T: <?= htmlspecialchars($empresaTel) ?><br/><?php endif; ?>
  </div>
  <hr/>
  <div class="c b">
    <?= $docLabel ?><br/>
    <?= htmlspecialchars($codigoDisplay) ?><br/>
    <?= date('d/m/Y H:i', strtotime($venta['created_at'])) ?>
  </div>
  <hr/>
  <div>
    <?php if($venta['ruc_dni']): ?>CLIENTE: <?= htmlspecialchars($venta['ruc_dni']) ?><br/><?php endif; ?>
    <?= htmlspecialchars($venta['cliente_nombre'] ?: 'Consumidor final') ?><br/>
    CAJERO: <?= htmlspecialchars(trim($venta['vendedora_nombre']) ?: $venta['cajero_nombre']) ?>
  </div>
  <hr/>
  <table>
    <tr><th style="text-align:left">DESCRIPCIÓN</th><th style="text-align:center">CT</th><th style="text-align:right">TOTAL</th></tr>
    <?php foreach($detalle as $d): ?>
    <tr>
      <td><?= htmlspecialchars($d['prod_nombre']) ?></td>
      <td class="c"><?= number_format($d['cantidad'],0) ?></td>
      <td class="r"><?= number_format($d['subtotal'],2) ?></td>
    </tr>
    <?php endforeach; ?>
  </table>
  <hr/>
  <div class="r">
    BASE: <?= $moneda ?> <?= number_format($venta['subtotal'],2) ?><br/>
    IGV <?= number_format($igvPct,0) ?>%: <?= $moneda ?> <?= number_format($venta['igv'],2) ?><br/>
    <?php if($venta['descuento'] > 0): ?>DESC: -<?= $moneda ?> <?= number_format($venta['descuento'],2) ?><br/><?php endif; ?>
    <span class="tt">TOTAL: <?= $moneda ?> <?= number_format($venta['total'],2) ?></span>
  </div>
  <hr/>
  <div class="c">
    <?= htmlspecialchars($empresa) ?><br/>
    ¡Gracias por su compra!
    <?php if($empresaTel): ?><br/>📞 <?= htmlspecialchars($empresaTel) ?><?php endif; ?>
  </div>
</div>

<script>
if (new URLSearchParams(window.location.search).get('print') === '1') {
  window.addEventListener('load', () => setTimeout(() => window.print(), 400));
}
</script>
</body>
</html>
<?php return; endif; // ─═ FIN THERMAL ═─ ?>

<!-- ─═ FORMATO A4 (default) ═─ -->
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Inter', Arial, sans-serif;
    font-size: 12px;
    color: #1a1a1a;
    background: #f0f0f0;
    padding: 20px;
  }
  .page {
    background: #fff;
    width: 210mm;
    min-height: 200mm;
    margin: 0 auto;
    padding: 12mm 14mm;
    box-shadow: 0 2px 20px rgba(0,0,0,.12);
  }
  .doc-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    padding-bottom: 10px;
    border-bottom: 3px solid #1a1a2e;
    margin-bottom: 10px;
  }
  .empresa-info h2 { font-size: 20px; font-weight: 800; color: #1a1a2e; margin-bottom: 3px; }
  .empresa-info p  { font-size: 10px; color: #555; line-height: 1.6; }
  .doc-title-right { text-align: right; }
  .doc-tipo  { font-size: 14px; font-weight: 800; color: #1a1a2e; text-transform: uppercase; letter-spacing: .04em; }
  .doc-num   { font-size: 11px; color: #6b7280; margin-top: 2px; }
  .doc-fecha { font-size: 10px; color: #9ca3af; margin-top: 2px; }
  .sec-title {
    background: #1a1a2e; color: #fff;
    font-size: 10px; font-weight: 700;
    text-transform: uppercase; letter-spacing: .08em;
    padding: 5px 10px; margin-bottom: 0;
  }
  .info-row { display: flex; border: 1px solid #d1d5db; }
  .info-row + .info-row { border-top: none; }
  .info-cell { flex: 1; padding: 5px 8px; border-right: 1px solid #d1d5db; }
  .info-cell:last-child { border-right: none; }
  .info-cell .lbl { font-size: 9px; font-weight: 700; text-transform: uppercase; color: #6b7280; margin-bottom: 2px; }
  .info-cell .val { font-size: 12px; font-weight: 600; }
  table { width: 100%; border-collapse: collapse; }
  table th, table td { border: 1px solid #d1d5db; padding: 5px 8px; }
  table th { background: #1a1a2e; color: #fff; font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; }
  table tr:nth-child(even) td { background: #f9fafb; }
  .text-right  { text-align: right; }
  .text-center { text-align: center; }
  .totales-section { display: flex; justify-content: flex-end; border: 1px solid #d1d5db; border-top: none; }
  .totales-inner { width: 240px; }
  .tot-row { display: flex; border-bottom: 1px solid #e5e7eb; padding: 4px 10px; }
  .tot-row:last-child { border-bottom: none; }
  .tot-label { flex: 1; font-size: 10px; color: #6b7280; text-transform: uppercase; font-weight: 600; }
  .tot-value { font-weight: 700; text-align: right; min-width: 80px; }
  .tot-final { background: #1a1a2e; }
  .tot-final .tot-label, .tot-final .tot-value { color: #fff; font-size: 14px; }
  .pago-section { display: flex; gap: 10px; margin-top: 10px; }
  .pago-box { flex: 1; border: 1px solid #d1d5db; border-radius: 6px; padding: 8px 10px; }
  .pago-box .lbl { font-size: 9px; color: #6b7280; font-weight: 700; text-transform: uppercase; margin-bottom: 3px; }
  .pago-box .val { font-size: 13px; font-weight: 800; color: #1a1a2e; }
  .pago-box.destacado { background: #f0fdf4; border-color: #86efac; }
  .pago-box.destacado .val { color: #16a34a; }
  .gracias { text-align: center; margin-top: 16px; padding-top: 12px; border-top: 2px dashed #e5e7eb; color: #6b7280; }
  .gracias p { font-size: 11px; line-height: 1.7; }
  .gracias .empresa-nombre { font-size: 13px; font-weight: 800; color: #1a1a2e; }
  .badge { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 10px; font-weight: 700; }
  .badge-ok     { background: #dcfce7; color: #16a34a; }
  .badge-danger { background: #fee2e2; color: #dc2626; }
  .mt8  { margin-top: 8px; }
  .mt12 { margin-top: 12px; }
  .mb8  { margin-bottom: 8px; }
  @media print {
    body { background: #fff; padding: 0; }
    .page { box-shadow: none; padding: 8mm; width: 100%; min-height: auto; }
    .no-print { display: none !important; }
  }
</style>
</head>
<body>

<!-- Botones no imprimibles -->
<div class="no-print" style="max-width:210mm;margin:0 auto 12px;display:flex;gap:8px;flex-wrap:wrap">
  <button onclick="window.print()" style="background:#1a1a2e;color:#fff;border:none;border-radius:8px;padding:10px 20px;font-size:14px;font-weight:700;cursor:pointer">🖨️ Imprimir</button>
  <a href="?id=<?= $id ?>&pdf=1&formato=<?= $formato ?>" target="_blank" style="background:#2563eb;color:#fff;text-decoration:none;border-radius:8px;padding:10px 20px;font-size:14px;font-weight:600;cursor:pointer;display:inline-block">📄 Descargar PDF</a>
  <button onclick="window.close()" style="background:#f3f4f6;border:none;border-radius:8px;padding:10px 16px;font-size:14px;cursor:pointer">← Volver</button>
</div>

<div class="page">

  <!-- ══ HEADER ══ -->
  <div class="doc-header">
    <div class="empresa-info">
      <h2><?= htmlspecialchars($empresa) ?></h2>
      <?php if($empresaRuc): ?><p><strong>R.U.C.:</strong> <?= htmlspecialchars($empresaRuc) ?></p><?php endif; ?>
      <?php if($empresaDir): ?><p><?= htmlspecialchars($empresaDir) ?></p><?php endif; ?>
      <?php if($empresaTel): ?><p>📞 <?= htmlspecialchars($empresaTel) ?></p><?php endif; ?>
    </div>
    <div class="doc-title-right">
      <div class="doc-tipo"><?= $docLabel ?></div>
      <div class="doc-num"><?= htmlspecialchars($codigoDisplay) ?></div>
      <div class="doc-fecha"><?= date('d/m/Y H:i', strtotime($venta['created_at'])) ?></div>
      <div style="margin-top:6px">
        <span class="badge <?= $venta['estado']==='completada'?'badge-ok':'badge-danger' ?>">
          <?= $venta['estado']==='completada' ? '✔ COMPLETADA' : strtoupper($venta['estado']) ?>
        </span>
      </div>
    </div>
  </div>

  <!-- ══ CLIENTE ══ -->
  <div class="sec-title">Datos del cliente</div>
  <div class="info-row">
    <div class="info-cell" style="flex:0.7">
      <div class="lbl">DNI / RUC</div>
      <div class="val"><?= htmlspecialchars($venta['ruc_dni'] ?: '—') ?></div>
    </div>
    <div class="info-cell" style="flex:2">
      <div class="lbl">Cliente</div>
      <div class="val"><?= htmlspecialchars($venta['cliente_nombre'] ?: 'Consumidor final') ?></div>
    </div>
    <div class="info-cell">
      <div class="lbl">Teléfono</div>
      <div class="val"><?= htmlspecialchars($venta['telefono'] ?: '—') ?></div>
    </div>
    <div class="info-cell">
      <div class="lbl">Vendedor</div>
      <div class="val"><?= htmlspecialchars(trim($venta['vendedora_nombre']) ?: $venta['cajero_nombre']) ?></div>
    </div>
  </div>

  <!-- ══ PRODUCTOS ══ -->
  <div class="sec-title mt8">Detalle de productos / servicios</div>
  <table>
    <thead>
      <tr>
        <th style="width:28px" class="text-center">#</th>
        <th>Producto / Servicio</th>
        <th style="width:65px" class="text-center">Cant.</th>
        <th style="width:80px" class="text-right">P. Unit.</th>
        <?php if(array_sum(array_column($detalle,'descuento')) > 0): ?>
        <th style="width:70px" class="text-right">Desc.</th>
        <?php endif; ?>
        <th style="width:90px" class="text-right">Subtotal</th>
      </tr>
    </thead>
    <tbody>
      <?php $hayDescuento = array_sum(array_column($detalle,'descuento')) > 0; ?>
      <?php foreach($detalle as $i => $d): ?>
      <tr>
        <td class="text-center"><?= $i+1 ?></td>
        <td>
          <div style="font-weight:600"><?= htmlspecialchars($d['prod_nombre']) ?></div>
          <div style="font-size:10px;color:#9ca3af"><?= htmlspecialchars($d['prod_codigo']) ?> — <?= htmlspecialchars($d['cat_nombre']) ?></div>
        </td>
        <td class="text-center"><?= number_format($d['cantidad'],2) ?></td>
        <td class="text-right"><?= $moneda ?> <?= number_format($d['precio_unit'],2) ?></td>
        <?php if($hayDescuento): ?>
        <td class="text-right" style="color:#dc2626"><?= $d['descuento']>0?'-'.$moneda.' '.number_format($d['descuento'],2):'—' ?></td>
        <?php endif; ?>
        <td class="text-right" style="font-weight:700"><?= $moneda ?> <?= number_format($d['subtotal'],2) ?></td>
      </tr>
      <?php endforeach; ?>
    </tbody>
  </table>

  <!-- ══ TOTALES ══ -->
  <div class="totales-section">
    <div class="totales-inner">
      <div class="tot-row">
        <span class="tot-label">Base imponible:</span>
        <span class="tot-value"><?= $moneda ?> <?= number_format($venta['subtotal'],2) ?></span>
      </div>
      <div class="tot-row">
        <span class="tot-label">IGV (<?= $igvPct ?>%):</span>
        <span class="tot-value"><?= $moneda ?> <?= number_format($venta['igv'],2) ?></span>
      </div>
      <?php if($venta['descuento'] > 0): ?>
      <div class="tot-row">
        <span class="tot-label" style="color:#dc2626">Descuento:</span>
        <span class="tot-value" style="color:#dc2626">-<?= $moneda ?> <?= number_format($venta['descuento'],2) ?></span>
      </div>
      <?php endif; ?>
      <div class="tot-row tot-final">
        <span class="tot-label">TOTAL:</span>
        <span class="tot-value"><?= $moneda ?> <?= number_format($venta['total'],2) ?></span>
      </div>
    </div>
  </div>

  <!-- ══ PAGO ══ -->
  <div class="pago-section mt8">
    <div class="pago-box">
      <div class="lbl">Método de pago</div>
      <div class="val">
        <?php $iconos=['efectivo'=>'💵','yape'=>'💜','plin'=>'💚','tarjeta'=>'💳','transferencia'=>'🏦','mixto'=>'🔀'];
        echo ($iconos[$venta['metodo_pago']]??'💳').' '.ucfirst($venta['metodo_pago']); ?>
      </div>
    </div>
    <div class="pago-box">
      <div class="lbl">Monto recibido</div>
      <div class="val"><?= $moneda ?> <?= number_format($venta['monto_pagado'] ?? $venta['total'],2) ?></div>
    </div>
    <?php if(($venta['vuelto']??0) > 0): ?>
    <div class="pago-box destacado">
      <div class="lbl">Vuelto</div>
      <div class="val"><?= $moneda ?> <?= number_format($venta['vuelto'],2) ?></div>
    </div>
    <?php endif; ?>
    <?php if($venta['notas']): ?>
    <div class="pago-box" style="flex:2">
      <div class="lbl">Notas</div>
      <div class="val" style="font-size:11px;font-weight:500"><?= htmlspecialchars($venta['notas']) ?></div>
    </div>
    <?php endif; ?>
  </div>

  <!-- ══ PIE ══ -->
  <div class="gracias">
    <p class="empresa-nombre"><?= htmlspecialchars($empresa) ?></p>
    <p>¡Gracias por su compra! Si tiene alguna consulta comuníquese con nosotros.</p>
    <?php if($empresaTel): ?><p>📞 <?= htmlspecialchars($empresaTel) ?></p><?php endif; ?>
    <p style="margin-top:6px;font-size:10px;color:#9ca3af">
      <?= $docLabel ?> N° <?= htmlspecialchars($codigoDisplay) ?> — <?= date('d/m/Y H:i', strtotime($venta['created_at'])) ?>
    </p>
  </div>

</div><!-- /page -->

<script>
if (new URLSearchParams(window.location.search).get('print') === '1') {
  window.addEventListener('load', () => setTimeout(() => window.print(), 600));
}
</script>
</body>
</html>
