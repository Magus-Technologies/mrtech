<?php
/**
 * reporte_pdf.php — Genera reporte de caja en PDF (estilo Punto de Venta mejorado)
 * Uso: ?id=X  (id de la caja)
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_VENDEDOR]);

$db = getDB();
$id = (int)($_GET['id'] ?? 0);
if (!$id) {
    header('Location: ' . BASE_URL . 'modules/caja/index.php');
    exit;
}

// ── Cargar caja ──────────────────────────────────────────
$stmt = $db->prepare("
    SELECT ca.*,
           CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre,
           u.email AS usuario_email
    FROM cajas ca
    JOIN usuarios u ON u.id = ca.usuario_id
    WHERE ca.id = ?
");
$stmt->execute([$id]);
$caja = $stmt->fetch();
if (!$caja) {
    die('<p style="color:red;font-family:sans-serif;padding:20px">Caja no encontrada.</p>');
}

// Seguridad: el vendedor solo puede imprimir el reporte de SU propia caja
$uAct = currentUser();
if ($uAct['rol'] !== ROL_ADMIN && (int)$caja['usuario_id'] !== (int)$uAct['id']) {
    die('<p style="color:red;font-family:sans-serif;padding:20px">No autorizado para ver esta caja.</p>');
}

// ── Cargar movimientos ───────────────────────────────────
$stmt2 = $db->prepare("
    SELECT mv.*, CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre
    FROM movimientos_caja mv
    JOIN usuarios u ON u.id = mv.usuario_id
    WHERE mv.caja_id = ?
    ORDER BY mv.created_at ASC
");
$stmt2->execute([$id]);
$movimientos = $stmt2->fetchAll();

// ── Calcular totales ─────────────────────────────────────
$totalIng = 0; $totalEgr = 0;
$ingresos = []; $egresos = [];
$metodos  = [];
foreach ($movimientos as $mv) {
    $monto = (float)$mv['monto'];
    if ($mv['tipo'] === 'ingreso') {
        $totalIng += $monto;
        $ingresos[] = $mv;
        // Agrupar por método de pago si viene de venta
        $ref = trim($mv['referencia'] ?? '');
        // Lo agrupamos por concepto para simplificar
    } else {
        $totalEgr += $monto;
        $egresos[] = $mv;
    }
}
$saldoInicial = (float)$caja['saldo_inicial'];
$saldoFinal   = $caja['estado'] === 'cerrada' ? (float)$caja['saldo_final'] : round($saldoInicial + $totalIng - $totalEgr, 2);
$diferencia   = (float)($caja['diferencia_cierre'] ?? 0);
$saldoEsperado = round($saldoInicial + $totalIng - $totalEgr, 2);

// ── Agrupar ingresos por método de pago ─
// Usa metodo_pago de movimientos_caja cuando existe; fallback a string parsing para registros viejos
$hasMetodoPDF   = cajaTieneMetodoPago();
$ingPorMetodo = [
    'Efectivo'      => 0,
    'Tarjeta crédito' => 0,
    'Tarjeta débito'  => 0,
    'Yape / Plin'   => 0,
    'Transferencia' => 0,
    'Otros'         => 0,
];
foreach ($ingresos as $mv) {
    $monto = (float)$mv['monto'];
    if ($hasMetodoPDF && !empty($mv['metodo_pago'])) {
        $mp = $mv['metodo_pago'];
        if (in_array($mp, ['yape','plin'])) {
            $ingPorMetodo['Yape / Plin'] += $monto;
        } elseif ($mp === 'tarjeta') {
            $ingPorMetodo['Tarjeta crédito'] += $monto;
        } elseif ($mp === 'transferencia') {
            $ingPorMetodo['Transferencia'] += $monto;
        } elseif ($mp === 'efectivo') {
            $ingPorMetodo['Efectivo'] += $monto;
        } else {
            $ingPorMetodo['Otros'] += $monto;
        }
        continue;
    }
    // Fallback: parsear concepto/referencia para registros sin metodo_pago
    $ref = trim($mv['referencia'] ?? '');
    $concepto = strtolower($mv['concepto'] ?? '');
    if (str_contains($concepto, 'yape') || str_contains($concepto, 'plin')) {
        $ingPorMetodo['Yape / Plin'] += $monto;
    } elseif (str_contains($concepto, 'transferencia')) {
        $ingPorMetodo['Transferencia'] += $monto;
    } elseif (str_contains($concepto, 'tarjeta') || str_contains($concepto, 'visa') || str_contains($concepto, 'mastercard')) {
        $ingPorMetodo['Tarjeta crédito'] += $monto;
    } elseif (str_contains($concepto, 'efectivo') || str_starts_with($ref, 'VTA-') || str_starts_with($ref, 'OT-')) {
        // Intentar obtener método real de la venta
        if (str_starts_with($ref, 'VTA-')) {
            $sv = $db->prepare("SELECT metodo_pago, total FROM ventas WHERE codigo=? LIMIT 1");
            $sv->execute([$ref]);
            $vrow = $sv->fetch();
            if ($vrow) {
                $mp = $vrow['metodo_pago'];
                if (in_array($mp, ['yape','plin'])) {
                    $ingPorMetodo['Yape / Plin'] += $monto;
                } elseif ($mp === 'tarjeta') {
                    $ingPorMetodo['Tarjeta crédito'] += $monto;
                } elseif ($mp === 'transferencia') {
                    $ingPorMetodo['Transferencia'] += $monto;
                } else {
                    $ingPorMetodo['Efectivo'] += $monto;
                }
                continue;
            }
        }
        if (str_starts_with($ref, 'OT-')) {
            $so = $db->prepare("SELECT metodo_pago, precio_final FROM ordenes_trabajo WHERE codigo_ot=? LIMIT 1");
            $so->execute([$ref]);
            $orow = $so->fetch();
            if ($orow) {
                $mp = $orow['metodo_pago'];
                if (in_array($mp, ['yape','plin'])) {
                    $ingPorMetodo['Yape / Plin'] += $monto;
                } elseif ($mp === 'tarjeta') {
                    $ingPorMetodo['Tarjeta crédito'] += $monto;
                } elseif ($mp === 'transferencia') {
                    $ingPorMetodo['Transferencia'] += $monto;
                } else {
                    $ingPorMetodo['Efectivo'] += $monto;
                }
                continue;
            }
        }
        $ingPorMetodo['Efectivo'] += $monto;
    } else {
        $ingPorMetodo['Otros'] += $monto;
    }
}
// Si ingreso_caja manual existe, ya está en efectivo
if ($saldoInicial > 0) {
    $ingPorMetodo['Efectivo'] += $saldoInicial;
}

// ── Denominaciones ───────────────────────────────────────
$billetes  = [200, 100, 50, 20, 10];
$monedas   = [5.00, 2.00, 1.00, 0.50, 0.20, 0.10];
$densAp    = json_decode($caja['denominaciones_apertura'] ?? '{}', true) ?: [];
$densCi    = json_decode($caja['denominaciones_cierre']   ?? '{}', true) ?: [];

function dKey($tipo, $v) {
    return $tipo === 'bil' ? 'bil_'.(int)$v : 'mon_'.str_replace('.','_',number_format((float)$v,2,'_',''));
}

// ── Config empresa ───────────────────────────────────────
$empresa  = APP_NAME;
$fechaRep = date('Y-m-d H:i:s');
$fechaCaja = date('d/m/Y', strtotime($caja['fecha']));

// ── Logo (si existe) ─────────────────────────────────────
$logoPath = BASE_PATH . 'assets/img/uploads/logos/logo_empresa.png';
$logoB64  = '';
if (file_exists($logoPath)) {
    $logoB64 = 'data:image/png;base64,' . base64_encode(file_get_contents($logoPath));
}

// ── HTML para impresión / PDF ────────────────────────────
header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Reporte de Caja — <?= $fechaCaja ?></title>
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #1a1a2e;
    background: #fff;
  }
  .page {
    width: 210mm;
    min-height: 297mm;
    margin: 0 auto;
    padding: 12mm 15mm;
    background: #fff;
  }

  /* ── ENCABEZADO ── */
  .header-wrap {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 3px solid #1a1a2e;
    padding-bottom: 10px;
    margin-bottom: 12px;
  }
  .header-left { flex: 1; }
  .header-logo img { height: 50px; margin-bottom: 4px; }
  .company-name { font-size: 16px; font-weight: 700; color: #1a1a2e; }
  .company-sub  { font-size: 10px; color: #555; margin-top: 2px; }
  .report-title {
    font-size: 20px;
    font-weight: 700;
    color: #1a1a2e;
    text-align: right;
  }
  .report-meta {
    font-size: 10px;
    color: #555;
    text-align: right;
    margin-top: 4px;
    line-height: 1.6;
  }

  /* ── BLOQUE INFO SUPERIOR ── */
  .info-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    margin-bottom: 12px;
    overflow: hidden;
  }
  .info-cell {
    padding: 6px 10px;
    border-right: 1px solid #d1d5db;
    border-bottom: 1px solid #d1d5db;
  }
  .info-cell:nth-child(even) { border-right: none; }
  .info-label { font-size: 9px; text-transform: uppercase; color: #6b7280; font-weight: 600; }
  .info-value { font-size: 11px; font-weight: 600; color: #1a1a2e; margin-top: 1px; }

  /* ── KPI CARDS ── */
  .kpi-row {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
    margin-bottom: 12px;
  }
  .kpi-box {
    border: 1px solid #e5e7eb;
    border-radius: 6px;
    padding: 8px 10px;
    text-align: center;
  }
  .kpi-box.green  { background: #f0fdf4; border-color: #86efac; }
  .kpi-box.blue   { background: #eff6ff; border-color: #93c5fd; }
  .kpi-box.red    { background: #fef2f2; border-color: #fca5a5; }
  .kpi-box.purple { background: #f5f3ff; border-color: #c4b5fd; }
  .kpi-box.yellow { background: #fefce8; border-color: #fde047; }
  .kpi-label-sm   { font-size: 9px; color: #6b7280; text-transform: uppercase; font-weight: 600; }
  .kpi-value-lg   { font-size: 16px; font-weight: 700; margin-top: 2px; }
  .kpi-value-lg.green  { color: #16a34a; }
  .kpi-value-lg.blue   { color: #2563eb; }
  .kpi-value-lg.red    { color: #dc2626; }
  .kpi-value-lg.purple { color: #7c3aed; }
  .kpi-value-lg.yellow { color: #b45309; }

  /* ── SECCIONES ── */
  .section-title {
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #fff;
    background: #1a1a2e;
    padding: 5px 10px;
    margin-bottom: 0;
  }
  .section-wrap { margin-bottom: 12px; border: 1px solid #d1d5db; border-radius: 4px; overflow: hidden; }

  /* ── TABLAS ── */
  table { width: 100%; border-collapse: collapse; font-size: 10px; }
  thead tr { background: #3b4a6b; color: #fff; }
  thead th { padding: 5px 8px; text-align: left; font-weight: 600; font-size: 9.5px; }
  tbody tr:nth-child(even) { background: #f9fafb; }
  tbody td { padding: 4px 8px; border-bottom: 1px solid #f3f4f6; }
  tfoot td { padding: 5px 8px; font-weight: 700; background: #1a1a2e; color: #fff; }
  .text-right { text-align: right; }
  .text-center { text-align: center; }
  .badge-ing { background: #dcfce7; color: #166534; border-radius: 3px; padding: 1px 5px; font-size: 9px; font-weight: 700; }
  .badge-egr { background: #fee2e2; color: #991b1b; border-radius: 3px; padding: 1px 5px; font-size: 9px; font-weight: 700; }

  /* ── DOS COLUMNAS ── */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 12px; }

  /* ── TABLA MÉTODOS ── */
  .metodos-table td { padding: 5px 8px; border-bottom: 1px solid #f3f4f6; }
  .metodos-table tr:last-child td { border-bottom: none; }
  .numero-row { display: flex; justify-content: space-between; align-items: center; }
  .indicator { display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 5px; }

  /* ── DENOMINACIONES ── */
  .dens-table td { padding: 4px 8px; border-bottom: 1px solid #f3f4f6; font-size: 10px; }
  .dens-sep td { background: #f3f4f6; font-weight: 700; font-size: 9.5px; }

  /* ── COMPARATIVO BARRAS ── */
  .bar-wrap { margin-bottom: 6px; }
  .bar-label { display: flex; justify-content: space-between; font-size: 9.5px; margin-bottom: 2px; }
  .bar-track { background: #e5e7eb; border-radius: 4px; height: 10px; }
  .bar-fill  { height: 10px; border-radius: 4px; }

  /* ── ESTADO CAJA ── */
  .estado-badge {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 3px;
    font-size: 10px;
    font-weight: 700;
  }
  .estado-abierta { background: #d1fae5; color: #065f46; }
  .estado-cerrada { background: #e5e7eb; color: #374151; }

  /* ── DIFERENCIA ── */
  .dif-ok  { color: #16a34a; font-weight: 700; }
  .dif-pos { color: #d97706; font-weight: 700; }
  .dif-neg { color: #dc2626; font-weight: 700; }

  /* ── FIRMA ── */
  .firma-row {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 20px;
    margin-top: 20px;
  }
  .firma-box { text-align: center; }
  .firma-line { border-top: 1px solid #374151; padding-top: 4px; font-size: 9px; color: #374151; margin-top: 30px; }

  /* ── FOOTER ── */
  .page-footer {
    margin-top: 15px;
    padding-top: 8px;
    border-top: 1px solid #d1d5db;
    font-size: 9px;
    color: #9ca3af;
    display: flex;
    justify-content: space-between;
  }

  /* ── PRINT ── */
  @media print {
    .no-print { display: none !important; }
    body { background: #fff; }
    .page { margin: 0; padding: 8mm 10mm; }
  }
  @page { size: A4; margin: 0; }
</style>
</head>
<body>

<!-- Botones de acción (no se imprimen) -->
<div class="no-print" style="background:#1a1a2e;padding:10px 20px;display:flex;gap:10px;align-items:center">
  <span style="color:#fff;font-size:13px;font-weight:700;flex:1">📊 Reporte de Caja — <?= $fechaCaja ?></span>
  <button onclick="window.print()" style="background:#16a34a;color:#fff;border:none;padding:7px 18px;border-radius:5px;cursor:pointer;font-size:13px;font-weight:700">🖨️ Imprimir / Guardar PDF</button>
  <a href="<?= BASE_URL ?>modules/caja/index.php" style="background:#6b7280;color:#fff;padding:7px 15px;border-radius:5px;text-decoration:none;font-size:12px">← Volver</a>
</div>

<div class="page">

  <!-- ══ ENCABEZADO ══ -->
  <div class="header-wrap">
    <div class="header-left">
      <?php if ($logoB64): ?>
      <div class="header-logo"><img src="<?= $logoB64 ?>" alt="Logo"></div>
      <?php else: ?>
      <div class="company-name"><?= htmlspecialchars($empresa) ?></div>
      <?php endif; ?>
      <div class="company-sub">Sistema de Gestión TechRepair</div>
    </div>
    <div>
      <div class="report-title">Reporte Punto de Venta</div>
      <div class="report-meta">
        <strong>Fecha reporte:</strong> <?= date('Y-m-d') ?><br>
        <strong>Caja N°:</strong> <?= str_pad($caja['id'], 5, '0', STR_PAD_LEFT) ?><br>
        <strong>Estado:</strong>
        <span class="estado-badge estado-<?= $caja['estado'] ?>">
          <?= strtoupper($caja['estado']) ?>
        </span>
      </div>
    </div>
  </div>

  <!-- ══ INFO EMPRESA / CAJA ══ -->
  <div class="info-grid">
    <div class="info-cell">
      <div class="info-label">Vendedor / Cajero</div>
      <div class="info-value"><?= htmlspecialchars($caja['usuario_nombre']) ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Fecha reporte</div>
      <div class="info-value"><?= date('Y-m-d') ?> &nbsp;·&nbsp; <?= date('H:i:s') ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Estado de caja</div>
      <div class="info-value">
        <?= $caja['estado'] === 'abierta' ? 'Aperturada' : 'Cerrada' ?>
      </div>
    </div>
    <div class="info-cell">
      <div class="info-label">Fecha y hora apertura</div>
      <div class="info-value"><?= date('Y-m-d', strtotime($caja['fecha'])) ?> &nbsp;·&nbsp; <?= date('H:i:s', strtotime($caja['created_at'])) ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Saldo inicial</div>
      <div class="info-value"><?= formatMoney($saldoInicial) ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Saldo final</div>
      <div class="info-value"><?= formatMoney($saldoFinal) ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Ingreso caja</div>
      <div class="info-value"><?= formatMoney($totalIng) ?></div>
    </div>
    <div class="info-cell">
      <div class="info-label">Egreso caja</div>
      <div class="info-value"><?= formatMoney($totalEgr) ?></div>
    </div>
  </div>

  <!-- ══ KPIs PRINCIPALES ══ -->
  <div class="kpi-row">
    <div class="kpi-box green">
      <div class="kpi-label-sm">Saldo inicial</div>
      <div class="kpi-value-lg green"><?= formatMoney($saldoInicial) ?></div>
    </div>
    <div class="kpi-box blue">
      <div class="kpi-label-sm">Total ingresos</div>
      <div class="kpi-value-lg blue"><?= formatMoney($totalIng) ?></div>
    </div>
    <div class="kpi-box red">
      <div class="kpi-label-sm">Total egresos</div>
      <div class="kpi-value-lg red"><?= formatMoney($totalEgr) ?></div>
    </div>
    <div class="kpi-box <?= $diferencia == 0 ? 'green' : ($diferencia > 0 ? 'yellow' : 'red') ?>">
      <div class="kpi-label-sm"><?= $caja['estado']==='cerrada' ? 'S. Final / Dif.' : 'Saldo esperado' ?></div>
      <div class="kpi-value-lg <?= $diferencia == 0 ? 'green' : ($diferencia > 0 ? 'yellow' : 'red') ?>"><?= formatMoney($saldoFinal) ?></div>
      <?php if($caja['estado']==='cerrada' && $diferencia != 0): ?>
      <div style="font-size:9px;margin-top:2px" class="<?= $diferencia>0?'dif-pos':'dif-neg' ?>">
        <?= $diferencia>0?'⚠️ Sobrante':'❌ Faltante' ?>: <?= formatMoney(abs($diferencia)) ?>
      </div>
      <?php elseif($caja['estado']==='cerrada'): ?>
      <div style="font-size:9px;margin-top:2px" class="dif-ok">✅ Cuadra perfectamente</div>
      <?php endif; ?>
    </div>
  </div>

  <!-- ══ DOS COLUMNAS: MÉTODOS + DENOMINACIONES APERTURA ══ -->
  <div class="two-col">

    <!-- Métodos de pago (tabla resumen tipo la imagen) -->
    <div class="section-wrap">
      <div class="section-title">💳 Resumen por forma de pago</div>
      <table class="metodos-table" style="font-size:10px">
        <thead>
          <tr>
            <th>#</th>
            <th>Descripción</th>
            <th class="text-right">Suma</th>
          </tr>
        </thead>
        <tbody>
          <?php
          $metodosDisplay = [
            ['Efectivo',        $ingPorMetodo['Efectivo'],         '#10b981'],
            ['Tarjeta de crédito', $ingPorMetodo['Tarjeta crédito'], '#3b82f6'],
            ['Tarjeta de débito',  $ingPorMetodo['Tarjeta débito'],  '#6366f1'],
            ['Yape / Plin',     $ingPorMetodo['Yape / Plin'],      '#f59e0b'],
            ['Transferencia',   $ingPorMetodo['Transferencia'],     '#8b5cf6'],
            ['Otros / Crédito', $ingPorMetodo['Otros'],            '#6b7280'],
          ];
          foreach ($metodosDisplay as $i => $m): ?>
          <tr>
            <td class="text-center" style="color:#6b7280;font-size:9px"><?= $i+1 ?></td>
            <td>
              <span class="indicator" style="background:<?= $m[2] ?>"></span>
              <?= htmlspecialchars($m[0]) ?>
            </td>
            <td class="text-right fw-bold"><?= number_format($m[1], 2) ?></td>
          </tr>
          <?php endforeach; ?>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="2" class="text-right">TOTAL INGRESOS</td>
            <td class="text-right"><?= number_format($totalIng, 2) ?></td>
          </tr>
        </tfoot>
      </table>
    </div>

    <!-- Denominaciones apertura -->
    <div class="section-wrap">
      <div class="section-title">💰 Denominaciones — Apertura</div>
      <table class="dens-table">
        <thead><tr><th>Denominación</th><th class="text-center">Cant.</th><th class="text-right">Subtotal</th></tr></thead>
        <tbody>
          <?php
          $hasDens = false;
          foreach ($billetes as $b) {
              $k = dKey('bil', $b); $c = (int)($densAp[$k] ?? 0);
              if (!$c) continue; $hasDens = true;
          ?>
          <tr>
            <td>S/ <?= number_format($b, 2) ?></td>
            <td class="text-center"><?= $c ?></td>
            <td class="text-right"><?= number_format($c * $b, 2) ?></td>
          </tr>
          <?php } foreach ($monedas as $m) {
              $k = dKey('mon', $m); $c = (int)($densAp[$k] ?? 0);
              if (!$c) continue; $hasDens = true;
          ?>
          <tr>
            <td>S/ <?= number_format($m, 2) ?></td>
            <td class="text-center"><?= $c ?></td>
            <td class="text-right"><?= number_format($c * $m, 2) ?></td>
          </tr>
          <?php } ?>
          <?php if (!$hasDens): ?>
          <tr><td colspan="3" style="text-align:center;color:#9ca3af;font-style:italic">Sin denominaciones registradas</td></tr>
          <?php endif; ?>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="2" class="text-right">TOTAL</td>
            <td class="text-right"><?= number_format($saldoInicial, 2) ?></td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>

  <!-- ══ SECCIÓN INGRESOS ══ -->
  <?php if (!empty($ingresos)): ?>
  <div class="section-wrap" style="margin-bottom:12px">
    <div class="section-title">⬆️ Ingresos (<?= count($ingresos) ?> movimientos)</div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Tipo</th>
          <th>Concepto</th>
          <th>Referencia</th>
          <th>Usuario</th>
          <th>Hora</th>
          <th class="text-right">Monto</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($ingresos as $i => $mv): ?>
        <tr>
          <td class="text-center" style="color:#9ca3af"><?= $i+1 ?></td>
          <td><span class="badge-ing">↑ Ingreso</span></td>
          <td><?= htmlspecialchars($mv['concepto']) ?></td>
          <td style="font-family:monospace;font-size:9px"><?= htmlspecialchars($mv['referencia'] ?: '—') ?></td>
          <td style="color:#6b7280"><?= htmlspecialchars($mv['usuario_nombre']) ?></td>
          <td style="color:#6b7280"><?= date('H:i', strtotime($mv['created_at'])) ?></td>
          <td class="text-right" style="color:#16a34a;font-weight:700">+<?= number_format($mv['monto'], 2) ?></td>
        </tr>
        <?php endforeach; ?>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="6" class="text-right">TOTAL INGRESOS</td>
          <td class="text-right">+<?= number_format($totalIng, 2) ?></td>
        </tr>
      </tfoot>
    </table>
  </div>
  <?php endif; ?>

  <!-- ══ SECCIÓN EGRESOS ══ -->
  <?php if (!empty($egresos)): ?>
  <div class="section-wrap" style="margin-bottom:12px">
    <div class="section-title">⬇️ Egresos (<?= count($egresos) ?> movimientos)</div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Tipo</th>
          <th>Concepto</th>
          <th>Referencia</th>
          <th>Usuario</th>
          <th>Hora</th>
          <th class="text-right">Monto</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($egresos as $i => $mv): ?>
        <tr>
          <td class="text-center" style="color:#9ca3af"><?= $i+1 ?></td>
          <td><span class="badge-egr">↓ Egreso</span></td>
          <td><?= htmlspecialchars($mv['concepto']) ?></td>
          <td style="font-family:monospace;font-size:9px"><?= htmlspecialchars($mv['referencia'] ?: '—') ?></td>
          <td style="color:#6b7280"><?= htmlspecialchars($mv['usuario_nombre']) ?></td>
          <td style="color:#6b7280"><?= date('H:i', strtotime($mv['created_at'])) ?></td>
          <td class="text-right" style="color:#dc2626;font-weight:700">-<?= number_format($mv['monto'], 2) ?></td>
        </tr>
        <?php endforeach; ?>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="6" class="text-right">TOTAL EGRESOS</td>
          <td class="text-right">-<?= number_format($totalEgr, 2) ?></td>
        </tr>
      </tfoot>
    </table>
  </div>
  <?php endif; ?>

  <!-- ══ COMPARATIVO CIERRE (si cerrada) ══ -->
  <?php if ($caja['estado'] === 'cerrada' && !empty($densCi)): ?>
  <div class="two-col">
    <!-- Comparativo esperado vs contado -->
    <div class="section-wrap">
      <div class="section-title">📊 Comparativo de cierre</div>
      <table style="font-size:10px">
        <tbody>
          <tr>
            <td style="padding:7px 10px">Saldo inicial</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700"><?= formatMoney($saldoInicial) ?></td>
          </tr>
          <tr>
            <td style="padding:7px 10px">+ Ingresos del día</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700;color:#16a34a">+<?= formatMoney($totalIng) ?></td>
          </tr>
          <tr>
            <td style="padding:7px 10px">− Egresos del día</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700;color:#dc2626">-<?= formatMoney($totalEgr) ?></td>
          </tr>
          <tr style="background:#f3f4f6">
            <td style="padding:7px 10px;font-weight:700">= Saldo esperado (BD)</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700;color:#2563eb"><?= formatMoney($saldoEsperado) ?></td>
          </tr>
          <tr>
            <td style="padding:7px 10px">Saldo contado (físico)</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700;color:#7c3aed"><?= formatMoney($saldoFinal) ?></td>
          </tr>
          <tr style="background:<?= $diferencia==0?'#f0fdf4':($diferencia>0?'#fef9c3':'#fef2f2') ?>">
            <td style="padding:7px 10px;font-weight:700">Diferencia</td>
            <td class="text-right" style="padding:7px 10px;font-weight:700" class="<?= $diferencia==0?'dif-ok':($diferencia>0?'dif-pos':'dif-neg') ?>">
              <span style="color:<?= $diferencia==0?'#16a34a':($diferencia>0?'#d97706':'#dc2626') ?>">
                <?= $diferencia==0 ? '✅ Sin diferencia' : ($diferencia>0?'⚠️ Sobrante ':'❌ Faltante ').formatMoney(abs($diferencia)) ?>
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Denominaciones cierre -->
    <div class="section-wrap">
      <div class="section-title">💰 Denominaciones — Cierre</div>
      <table class="dens-table">
        <thead><tr><th>Denominación</th><th class="text-center">Cant.</th><th class="text-right">Subtotal</th></tr></thead>
        <tbody>
          <?php
          $hasDensCi = false;
          foreach ($billetes as $b) {
              $k = dKey('bil', $b); $c = (int)($densCi[$k] ?? 0);
              if (!$c) continue; $hasDensCi = true;
          ?>
          <tr>
            <td>S/ <?= number_format($b, 2) ?></td>
            <td class="text-center"><?= $c ?></td>
            <td class="text-right"><?= number_format($c * $b, 2) ?></td>
          </tr>
          <?php } foreach ($monedas as $m) {
              $k = dKey('mon', $m); $c = (int)($densCi[$k] ?? 0);
              if (!$c) continue; $hasDensCi = true;
          ?>
          <tr>
            <td>S/ <?= number_format($m, 2) ?></td>
            <td class="text-center"><?= $c ?></td>
            <td class="text-right"><?= number_format($c * $m, 2) ?></td>
          </tr>
          <?php } ?>
          <?php if (!$hasDensCi): ?>
          <tr><td colspan="3" style="text-align:center;color:#9ca3af;font-style:italic">Sin denominaciones de cierre</td></tr>
          <?php endif; ?>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="2" class="text-right">TOTAL CONTADO</td>
            <td class="text-right"><?= number_format($saldoFinal, 2) ?></td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
  <?php endif; ?>

  <!-- ══ NOTAS ══ -->
  <?php if ($caja['observaciones']): ?>
  <div class="section-wrap" style="margin-bottom:12px">
    <div class="section-title">📝 Observaciones</div>
    <div style="padding:8px 10px;font-size:10px"><?= nl2br(htmlspecialchars($caja['observaciones'])) ?></div>
  </div>
  <?php endif; ?>

  <!-- ══ FIRMA ══ -->
  <div class="firma-row">
    <div class="firma-box">
      <div class="firma-line">Cajero / Vendedor<br><strong><?= htmlspecialchars($caja['usuario_nombre']) ?></strong></div>
    </div>
    <div class="firma-box">
      <div class="firma-line">Supervisor / Administrador</div>
    </div>
    <div class="firma-box">
      <div class="firma-line">Contabilidad / Revisado</div>
    </div>
  </div>

  <!-- ══ PIE DE PÁGINA ══ -->
  <div class="page-footer">
    <span><?= htmlspecialchars($empresa) ?> — Sistema TechRepair Pro</span>
    <span>Generado: <?= date('d/m/Y H:i:s') ?></span>
    <span>Caja #<?= str_pad($caja['id'], 5, '0', STR_PAD_LEFT) ?> — <?= $fechaCaja ?></span>
  </div>

</div><!-- /page -->

<script>
// Auto-print si viene con ?print=1
if (new URLSearchParams(window.location.search).get('print') === '1') {
  window.addEventListener('load', () => setTimeout(() => window.print(), 500));
}
</script>
</body>
</html>
