<?php
/**
 * reporte_comprobantes.php — Reporte completo de comprobantes emitidos
 * Para la contadora: filtros por fecha, tipo doc, estado; descarga Excel
 */

use PhpOffice\PhpSpreadsheet\Cell\DataType;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Worksheet\PageSetup;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN]);

$db = getDB();

// ── Filtros ───────────────────────────────────────────────
$desde    = $_GET['desde']     ?? date('Y-m-01');
$hasta    = $_GET['hasta']     ?? date('Y-m-d');
$tipodoc  = $_GET['tipo_doc']  ?? '';
$estado   = $_GET['estado']    ?? '';
$metpago  = $_GET['metodo']    ?? '';
$origen   = $_GET['origen']    ?? '';  // ventas | ots | ambos
$exportar = isset($_GET['export']);

if (!$origen) $origen = 'ambos';

// ── Consultar VENTAS ─────────────────────────────────────
$paramV = [$desde, $hasta];
$whereV = "DATE(v.created_at) BETWEEN ? AND ?";
if ($tipodoc) { $whereV .= " AND v.tipo_doc = ?"; $paramV[] = $tipodoc; }
if ($estado)  { $whereV .= " AND v.estado = ?";   $paramV[] = $estado; }
// ¿Existe la tabla de pagos múltiples?
$tienePagosMultiples = false;
try {
    $db->query("SELECT 1 FROM venta_pagos LIMIT 1");
    $tienePagosMultiples = true;
} catch (\Throwable $e) { /* tabla no creada */ }

if ($metpago) {
    if ($tienePagosMultiples) {
        $whereV .= " AND (v.metodo_pago = ? OR v.id IN (SELECT venta_id FROM venta_pagos WHERE metodo = ?))";
        $paramV[] = $metpago;
        $paramV[] = $metpago;
    } else {
        $whereV .= " AND v.metodo_pago = ?";
        $paramV[] = $metpago;
    }
}

$sqlVentas = "
    SELECT
        v.id                   AS id,
        v.codigo               AS codigo,
        DATE(v.created_at)     AS fecha,
        TIME(v.created_at)     AS hora,
        'Venta'                AS origen,
        v.tipo_doc             AS tipo_doc,
        CONCAT(COALESCE(v.serie_doc,''), IF(v.num_doc IS NOT NULL, CONCAT('-', v.num_doc), '')) AS serie_numero,
        COALESCE(c.nombre, 'Consumidor Final') AS cliente,
        COALESCE(c.ruc_dni, '')                AS ruc_dni,
        COALESCE(c.tipo, 'persona')            AS tipo_cliente,
        v.subtotal             AS base_imponible,
        v.igv                  AS igv,
        v.descuento            AS descuento,
        v.total                AS total,
        v.metodo_pago          AS metodo_pago,
        v.monto_pagado         AS monto_pagado,
        v.vuelto               AS vuelto,
        v.estado               AS estado,
        CONCAT(u.nombre,' ',u.apellido) AS usuario,
        v.notas                AS notas
    FROM ventas v
    LEFT JOIN clientes c ON c.id = v.cliente_id
    JOIN usuarios u ON u.id = v.usuario_id
    WHERE $whereV
    ORDER BY v.created_at DESC
";

$stmtV = $db->prepare($sqlVentas);
$stmtV->execute($paramV);
$ventas = $stmtV->fetchAll();

// ── Consultar OTs PAGADAS ────────────────────────────────
$paramO = [$desde, $hasta];
$whereO = "DATE(ot.fecha_pago) BETWEEN ? AND ? AND ot.pagado = 1";
if ($metpago) { $whereO .= " AND ot.metodo_pago = ?"; $paramO[] = $metpago; }

$sqlOTs = "
    SELECT
        NULL                   AS id,
        ot.codigo_ot           AS codigo,
        DATE(ot.fecha_pago)    AS fecha,
        TIME(ot.fecha_pago)    AS hora,
        'Reparación'           AS origen,
        'sin_comprobante'      AS tipo_doc,
        ''                     AS serie_numero,
        c.nombre               AS cliente,
        COALESCE(c.ruc_dni,'') AS ruc_dni,
        COALESCE(c.tipo,'persona') AS tipo_cliente,
        ROUND(ot.precio_final / 1.18, 2) AS base_imponible,
        ROUND(ot.precio_final - (ot.precio_final / 1.18), 2) AS igv,
        COALESCE(ot.descuento, 0) AS descuento,
        ot.precio_final        AS total,
        ot.metodo_pago         AS metodo_pago,
        ot.precio_final        AS monto_pagado,
        0                      AS vuelto,
        ot.estado              AS estado,
        CONCAT(u.nombre,' ',u.apellido) AS usuario,
        ot.observaciones       AS notas
    FROM ordenes_trabajo ot
    JOIN clientes c ON c.id = ot.cliente_id
    LEFT JOIN usuarios u ON u.id = ot.tecnico_id
    WHERE $whereO
    ORDER BY ot.fecha_pago DESC
";

$stmtO = $db->prepare($sqlOTs);
$stmtO->execute($paramO);
$ots = $stmtO->fetchAll();

// ── Combinar según origen seleccionado ───────────────────
$registros = [];
if ($origen === 'ventas' || $origen === 'ambos') $registros = array_merge($registros, $ventas);
if ($origen === 'ots'    || $origen === 'ambos') $registros = array_merge($registros, $ots);

// Ordenar por fecha desc
usort($registros, fn($a, $b) => strcmp($b['fecha'].$b['hora'], $a['fecha'].$a['hora']));

// Cargar pagos múltiples (venta_pagos) de TODAS las ventas mostradas, una sola vez.
// $pagosPorVenta[venta_id] = [['metodo'=>..,'monto'=>..], ...]
$pagosPorVenta = [];
$idsVentas = [];
foreach ($registros as $r) {
    if (($r['origen'] ?? '') === 'Venta' && !empty($r['id'])) $idsVentas[] = (int)$r['id'];
}
if ($idsVentas) {
    try {
        $in = implode(',', array_fill(0, count($idsVentas), '?'));
        $st = $db->prepare("SELECT venta_id, metodo, monto FROM venta_pagos WHERE venta_id IN ($in) ORDER BY id");
        $st->execute($idsVentas);
        foreach ($st->fetchAll() as $p) {
            $pagosPorVenta[$p['venta_id']][] = $p;
        }
    } catch (\Throwable $e) { /* tabla aún no creada */ }
}

// ── Totales ───────────────────────────────────────────────
$totBase  = array_sum(array_column($registros, 'base_imponible'));
$totIGV   = array_sum(array_column($registros, 'igv'));
$totDesc  = array_sum(array_column($registros, 'descuento'));
$totTotal = array_sum(array_column($registros, 'total'));

// Por tipo de documento
$porTipo = [];
foreach ($registros as $r) {
    $t = $r['tipo_doc'] ?: 'sin_comprobante';
    if (!isset($porTipo[$t])) $porTipo[$t] = ['n'=>0,'total'=>0];
    $porTipo[$t]['n']++;
    $porTipo[$t]['total'] += (float)$r['total'];
}

// ── EXPORTAR EXCEL (.xlsx con formato real) ───────────────
if ($exportar) {
    $autoload = __DIR__ . '/../../vendor/autoload.php';
    if (!is_file($autoload)) {
        die('Faltan dependencias. Ejecuta "composer install" en la raiz del proyecto.');
    }
    require_once $autoload;

    $tipoLabels = ['boleta'=>'Boleta','factura'=>'Factura','ticket'=>'Ticket/NV','sin_comprobante'=>'Sin comprobante'];
    $metodos    = ['efectivo'=>'Efectivo','yape'=>'Yape','plin'=>'Plin','tarjeta'=>'Tarjeta','transferencia'=>'Transferencia','mixto'=>'Mixto'];
    $tipoDoc    = ['boleta'=>'Boleta de Venta','factura'=>'Factura','ticket'=>'Ticket / NV','sin_comprobante'=>'Sin Comprobante'];
    $estadoL    = ['completada'=>'Completada','anulada'=>'Anulada','pendiente'=>'Pendiente','entregado'=>'Entregado'];

    $NAVY = '1A1A2E'; $BLUE = '3B4A6B'; $ZEBRA = 'F5F7FA'; $TOTBG = 'EEF2F7';
    $FMT_MONEY = '#,##0.00';
    $ULT_COL   = 'S';

    $ss = new Spreadsheet();
    $sh = $ss->getActiveSheet();
    $sh->setTitle('Comprobantes');

    $pintar = function (string $rango, string $fondo, string $texto = 'FFFFFF') use ($sh) {
        $sh->getStyle($rango)->getFont()->setBold(true)->getColor()->setRGB($texto);
        $sh->getStyle($rango)->getFill()->setFillType(Fill::FILL_SOLID)->getStartColor()->setRGB($fondo);
    };

    // ── Encabezado del reporte ──
    $sh->setCellValue('A1', APP_NAME);
    $sh->mergeCells("A1:{$ULT_COL}1");
    $sh->getStyle('A1')->getFont()->setBold(true)->setSize(16)->getColor()->setRGB($NAVY);

    $sh->setCellValue('A2', 'REPORTE DE COMPROBANTES EMITIDOS');
    $sh->mergeCells("A2:{$ULT_COL}2");
    $sh->getStyle('A2')->getFont()->setBold(true)->setSize(12);

    $sh->setCellValue('A3', 'Periodo: ' . date('d/m/Y', strtotime($desde)) . ' al ' . date('d/m/Y', strtotime($hasta))
                          . '     Generado: ' . date('d/m/Y H:i:s'));
    $sh->mergeCells("A3:{$ULT_COL}3");
    $sh->getStyle('A3')->getFont()->setSize(10)->getColor()->setRGB('55607A');

    // ── Resumen por tipo de comprobante ──
    $fila = 5;
    $sh->setCellValue("A{$fila}", 'RESUMEN POR TIPO DE COMPROBANTE');
    $sh->mergeCells("A{$fila}:C{$fila}");
    $pintar("A{$fila}:C{$fila}", $NAVY);
    $filaResumenIni = $fila;
    $fila++;

    $sh->fromArray(['Tipo', 'Cantidad', 'Total (S/)'], null, "A{$fila}");
    $pintar("A{$fila}:C{$fila}", $BLUE);
    $fila++;

    foreach ($porTipo as $tipo => $dat) {
        $sh->setCellValue("A{$fila}", $tipoLabels[$tipo] ?? ucfirst($tipo));
        $sh->setCellValue("B{$fila}", (int)$dat['n']);
        $sh->setCellValue("C{$fila}", (float)$dat['total']);
        $sh->getStyle("C{$fila}")->getNumberFormat()->setFormatCode($FMT_MONEY);
        $fila++;
    }
    $sh->setCellValue("A{$fila}", 'TOTAL');
    $sh->setCellValue("B{$fila}", count($registros));
    $sh->setCellValue("C{$fila}", (float)$totTotal);
    $sh->getStyle("C{$fila}")->getNumberFormat()->setFormatCode($FMT_MONEY);
    $pintar("A{$fila}:C{$fila}", $TOTBG, $NAVY);
    $sh->getStyle("A{$filaResumenIni}:C{$fila}")->getBorders()->getAllBorders()
       ->setBorderStyle(Border::BORDER_THIN)->getColor()->setRGB('B7C0CD');
    $fila += 2;

    // ── Detalle ──
    $sh->setCellValue("A{$fila}", 'DETALLE DE COMPROBANTES');
    $sh->mergeCells("A{$fila}:{$ULT_COL}{$fila}");
    $pintar("A{$fila}:{$ULT_COL}{$fila}", $NAVY);
    $fila++;

    $sh->fromArray([
        'N°', 'Fecha', 'Hora', 'Origen', 'Tipo Doc.', 'Serie-Número',
        'Cliente / Razón Social', 'RUC/DNI', 'Tipo Cliente',
        'Base Imponible', 'IGV', 'Descuento', 'TOTAL',
        'Método de Pago', 'Monto Pagado', 'Vuelto',
        'Estado', 'Usuario', 'Notas',
    ], null, "A{$fila}");
    $filaHeader = $fila;
    $pintar("A{$fila}:{$ULT_COL}{$fila}", $BLUE);
    $sh->getStyle("A{$fila}:{$ULT_COL}{$fila}")->getAlignment()
       ->setHorizontal(Alignment::HORIZONTAL_CENTER)
       ->setVertical(Alignment::VERTICAL_CENTER)
       ->setWrapText(true);
    $sh->getRowDimension($fila)->setRowHeight(30);
    $fila++;

    $filaPrimerDato = $fila;
    foreach ($registros as $i => $r) {
        // Metodo de pago (contempla pago mixto: "Efectivo S/50.00 + Yape S/50.00")
        $pgs = $pagosPorVenta[(int)($r['id'] ?? 0)] ?? [];
        if (count($pgs) > 1) {
            $partes = [];
            foreach ($pgs as $pg) {
                $partes[] = ($metodos[$pg['metodo']] ?? ucfirst($pg['metodo'])) . ' S/' . number_format($pg['monto'], 2);
            }
            $metodoTxt = implode(' + ', $partes);
        } else {
            $metodoTxt = $metodos[$r['metodo_pago']] ?? ucfirst($r['metodo_pago']);
        }

        $sh->setCellValue("A{$fila}", $i + 1);
        $sh->setCellValue("B{$fila}", date('d/m/Y', strtotime($r['fecha'])));
        $sh->setCellValue("C{$fila}", $r['hora'] ? substr($r['hora'], 0, 5) : '');
        $sh->setCellValue("D{$fila}", $r['origen']);
        $sh->setCellValue("E{$fila}", $tipoDoc[$r['tipo_doc']] ?? ucfirst($r['tipo_doc']));
        // Serie-Numero y RUC/DNI como texto: conservan los ceros a la izquierda
        $sh->setCellValueExplicit("F{$fila}", (string)($r['serie_numero'] ?: '—'), DataType::TYPE_STRING);
        $sh->setCellValue("G{$fila}", $r['cliente']);
        $sh->setCellValueExplicit("H{$fila}", (string)$r['ruc_dni'], DataType::TYPE_STRING);
        $sh->setCellValue("I{$fila}", ucfirst($r['tipo_cliente']));
        $sh->setCellValue("J{$fila}", (float)$r['base_imponible']);
        $sh->setCellValue("K{$fila}", (float)$r['igv']);
        $sh->setCellValue("L{$fila}", (float)$r['descuento']);
        $sh->setCellValue("M{$fila}", (float)$r['total']);
        $sh->setCellValue("N{$fila}", $metodoTxt);
        $sh->setCellValue("O{$fila}", (float)$r['monto_pagado']);
        $sh->setCellValue("P{$fila}", (float)$r['vuelto']);
        $sh->setCellValue("Q{$fila}", $estadoL[$r['estado']] ?? ucfirst($r['estado']));
        $sh->setCellValue("R{$fila}", $r['usuario']);
        $sh->setCellValue("S{$fila}", str_replace(["\n", "\t", "\r"], ' ', $r['notas'] ?? ''));

        if ($r['estado'] === 'anulada') {
            $sh->getStyle("A{$fila}:{$ULT_COL}{$fila}")->getFont()->setStrikethrough(true)->getColor()->setRGB('B00020');
        } elseif ($i % 2 === 1) {
            $sh->getStyle("A{$fila}:{$ULT_COL}{$fila}")->getFill()
               ->setFillType(Fill::FILL_SOLID)->getStartColor()->setRGB($ZEBRA);
        }
        $fila++;
    }
    $filaUltimoDato = $fila - 1;

    // ── Fila de totales ──
    $sh->setCellValue("I{$fila}", 'TOTALES');
    $sh->setCellValue("J{$fila}", (float)$totBase);
    $sh->setCellValue("K{$fila}", (float)$totIGV);
    $sh->setCellValue("L{$fila}", (float)$totDesc);
    $sh->setCellValue("M{$fila}", (float)$totTotal);
    $pintar("A{$fila}:{$ULT_COL}{$fila}", $TOTBG, $NAVY);
    $sh->getStyle("I{$fila}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_RIGHT);
    $filaTotales = $fila;

    // Formato de moneda en las columnas de dinero (datos + fila de totales)
    foreach (['J', 'K', 'L', 'M', 'O', 'P'] as $col) {
        $sh->getStyle("{$col}{$filaPrimerDato}:{$col}{$filaTotales}")->getNumberFormat()->setFormatCode($FMT_MONEY);
    }
    $sh->getStyle("A{$filaPrimerDato}:A{$filaTotales}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
    $sh->getStyle("A{$filaHeader}:{$ULT_COL}{$filaTotales}")->getBorders()->getAllBorders()
       ->setBorderStyle(Border::BORDER_THIN)->getColor()->setRGB('B7C0CD');

    // Filtros por columna sobre el encabezado del detalle
    if ($filaUltimoDato >= $filaPrimerDato) {
        $sh->setAutoFilter("A{$filaHeader}:{$ULT_COL}{$filaUltimoDato}");
    }

    // Anchos de columna
    $anchos = ['A'=>6,'B'=>11,'C'=>7,'D'=>10,'E'=>17,'F'=>16,'G'=>34,'H'=>14,'I'=>12,
               'J'=>14,'K'=>11,'L'=>12,'M'=>13,'N'=>26,'O'=>14,'P'=>10,'Q'=>12,'R'=>18,'S'=>32];
    foreach ($anchos as $col => $w) {
        $sh->getColumnDimension($col)->setWidth($w);
    }

    // Impresion: horizontal, ajustado al ancho, encabezado repetido en cada hoja
    $sh->getPageSetup()->setOrientation(PageSetup::ORIENTATION_LANDSCAPE)
       ->setPaperSize(PageSetup::PAPERSIZE_A4)->setFitToWidth(1)->setFitToHeight(0);
    $sh->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd($filaHeader, $filaHeader);
    $sh->setSelectedCell('A1');

    $filename = 'comprobantes_' . str_replace('-', '', $desde) . '_' . str_replace('-', '', $hasta) . '.xlsx';
    while (ob_get_level()) { ob_end_clean(); }
    header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    header('Cache-Control: max-age=0');
    (new Xlsx($ss))->save('php://output');
    exit;
}

// ── VISTA HTML ────────────────────────────────────────────
$pageTitle  = 'Reporte de Comprobantes — ' . APP_NAME;
$breadcrumb = [
    ['label' => 'Reportes', 'url' => BASE_URL . 'modules/reportes/index.php'],
    ['label' => 'Comprobantes', 'url' => null],
];
require_once __DIR__ . '/../../includes/header.php';

$tipoDocLabels = ['boleta'=>'Boleta','factura'=>'Factura','ticket'=>'Ticket/NV','sin_comprobante'=>'Sin Comprobante'];
$metodoLabels  = ['efectivo'=>'Efectivo','yape'=>'Yape','plin'=>'Plin','tarjeta'=>'Tarjeta','transferencia'=>'Transf.','mixto'=>'Mixto'];
?>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
  <h5 class="fw-bold mb-0">📄 Reporte de Comprobantes Emitidos</h5>
  <a href="?<?= http_build_query(array_merge($_GET, ['export'=>'1'])) ?>"
     class="btn btn-success fw-semibold">
    <i data-feather="download" style="width:15px;height:15px"></i>
    Descargar Excel
  </a>
</div>

<!-- ══ FILTROS ══ -->
<div class="tr-card mb-3">
  <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">🔍 FILTROS</h6></div>
  <div class="tr-card-body">
    <form method="GET" class="row g-2 align-items-end">
      <div class="col-6 col-md-2">
        <label class="tr-form-label">Desde</label>
        <input type="date" name="desde" class="form-control form-control-sm" value="<?= $desde ?>">
      </div>
      <div class="col-6 col-md-2">
        <label class="tr-form-label">Hasta</label>
        <input type="date" name="hasta" class="form-control form-control-sm" value="<?= $hasta ?>">
      </div>
      <div class="col-6 col-md-2">
        <label class="tr-form-label">Tipo documento</label>
        <select name="tipo_doc" class="form-select form-select-sm">
          <option value="">Todos</option>
          <option value="boleta"          <?= $tipodoc==='boleta'?'selected':'' ?>>Boleta</option>
          <option value="factura"         <?= $tipodoc==='factura'?'selected':'' ?>>Factura</option>
          <option value="ticket"          <?= $tipodoc==='ticket'?'selected':'' ?>>Ticket / NV</option>
          <option value="sin_comprobante" <?= $tipodoc==='sin_comprobante'?'selected':'' ?>>Sin comprobante</option>
        </select>
      </div>
      <div class="col-6 col-md-2">
        <label class="tr-form-label">Método de pago</label>
        <select name="metodo" class="form-select form-select-sm">
          <option value="">Todos</option>
          <?php foreach (['efectivo'=>'Efectivo','yape'=>'Yape','plin'=>'Plin','tarjeta'=>'Tarjeta','transferencia'=>'Transferencia','mixto'=>'Mixto'] as $v=>$l): ?>
          <option value="<?= $v ?>" <?= $metpago===$v?'selected':'' ?>><?= $l ?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="col-6 col-md-2">
        <label class="tr-form-label">Origen</label>
        <select name="origen" class="form-select form-select-sm">
          <option value="ambos"  <?= $origen==='ambos'?'selected':'' ?>>Ventas + OTs</option>
          <option value="ventas" <?= $origen==='ventas'?'selected':'' ?>>Solo Ventas</option>
          <option value="ots"    <?= $origen==='ots'?'selected':'' ?>>Solo Reparaciones</option>
        </select>
      </div>
      <div class="col-6 col-md-2 d-flex gap-1">
        <button type="submit" class="btn btn-primary btn-sm flex-fill">Aplicar</button>
        <a href="?" class="btn btn-outline-secondary btn-sm">✕</a>
      </div>
      <!-- Accesos rápidos -->
      <div class="col-12">
        <div class="d-flex gap-1 flex-wrap">
          <span class="text-muted small me-1">Rápido:</span>
          <?php
          $qs = ['tipo_doc'=>$tipodoc,'metodo'=>$metpago,'origen'=>$origen,'estado'=>$estado];
          $shortcuts2 = [
            'Hoy'       => [date('Y-m-d'), date('Y-m-d')],
            'Semana'    => [date('Y-m-d', strtotime('-7 days')), date('Y-m-d')],
            'Este mes'  => [date('Y-m-01'), date('Y-m-d')],
            'Mes pasado'=> [date('Y-m-01', strtotime('first day of last month')), date('Y-m-t', strtotime('first day of last month'))],
            'Este año'  => [date('Y-01-01'), date('Y-m-d')],
          ];
          foreach ($shortcuts2 as $label => [$d, $h]):
          ?>
          <a href="?<?= http_build_query(array_merge($qs, ['desde'=>$d,'hasta'=>$h])) ?>"
             class="btn btn-outline-secondary btn-sm py-0" style="font-size:10px"><?= $label ?></a>
          <?php endforeach; ?>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- ══ KPIs ══ -->
<div class="row g-3 mb-3">
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Total documentos</div>
      <div class="kpi-value fw-bold" style="font-size:24px"><?= count($registros) ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Base imponible</div>
      <div class="kpi-value text-secondary"><?= formatMoney($totBase) ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">IGV total</div>
      <div class="kpi-value text-warning"><?= formatMoney($totIGV) ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Total facturado</div>
      <div class="kpi-value text-primary fw-bold"><?= formatMoney($totTotal) ?></div>
    </div>
  </div>
</div>

<!-- ══ RESUMEN POR TIPO + MÉTODO ══ -->
<div class="row g-3 mb-3">
  <!-- Por tipo de documento -->
  <div class="col-md-6">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">📋 POR TIPO DE DOCUMENTO</h6></div>
      <div class="tr-card-body p-0">
        <table class="tr-table" style="font-size:11px">
          <thead>
            <tr><th>Tipo</th><th class="text-center">Cantidad</th><th class="text-end" style="padding-right:12px">Total</th><th class="text-end" style="padding-right:12px">%</th></tr>
          </thead>
          <tbody>
            <?php foreach ($porTipo as $tipo => $dat): ?>
            <tr>
              <td>
                <?php $colors = ['boleta'=>'primary','factura'=>'success','ticket'=>'warning text-dark','sin_comprobante'=>'secondary']; ?>
                <span class="badge bg-<?= $colors[$tipo] ?? 'secondary' ?>" style="font-size:9px">
                  <?= $tipoDocLabels[$tipo] ?? ucfirst($tipo) ?>
                </span>
              </td>
              <td class="text-center fw-semibold"><?= $dat['n'] ?></td>
              <td class="text-end fw-semibold" style="padding-right:12px"><?= formatMoney($dat['total']) ?></td>
              <td class="text-end text-muted" style="padding-right:12px">
                <?= $totTotal > 0 ? number_format($dat['total']/$totTotal*100,1).'%' : '0%' ?>
              </td>
            </tr>
            <?php endforeach; ?>
            <?php if (empty($porTipo)): ?>
            <tr><td colspan="4" class="text-center text-muted py-3">Sin datos</td></tr>
            <?php endif; ?>
          </tbody>
          <tfoot>
            <tr>
              <td class="fw-bold">TOTAL</td>
              <td class="text-center fw-bold"><?= count($registros) ?></td>
              <td class="text-end fw-bold" style="padding-right:12px"><?= formatMoney($totTotal) ?></td>
              <td class="text-end" style="padding-right:12px">100%</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>

  <!-- Por método de pago -->
  <div class="col-md-6">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">💳 POR MÉTODO DE PAGO</h6></div>
      <div class="tr-card-body p-0">
        <table class="tr-table" style="font-size:11px">
          <thead>
            <tr><th>Método</th><th class="text-center">Cantidad</th><th class="text-end" style="padding-right:12px">Total</th></tr>
          </thead>
          <tbody>
            <?php
            // Pre-cargar los pagos detallados de TODAS las ventas mostradas, en una sola consulta.
            // Si la venta tiene pagos en venta_pagos, se usan esos (desglosados por método real).
            // Si no (compras o ventas antiguas), se usa el metodo_pago/total del registro.
            $idsVentas = [];
            foreach ($registros as $r) {
                if (($r['origen'] ?? '') !== 'OT' && !empty($r['id'])) $idsVentas[] = (int)$r['id'];
            }
            $pagosPorVenta = [];
            if ($idsVentas) {
                try {
                    $in = implode(',', array_fill(0, count($idsVentas), '?'));
                    $st = $db->prepare("SELECT venta_id, metodo, monto FROM venta_pagos WHERE venta_id IN ($in)");
                    $st->execute($idsVentas);
                    foreach ($st->fetchAll() as $p) {
                        $pagosPorVenta[$p['venta_id']][] = $p;
                    }
                } catch (\Throwable $e) { /* tabla no creada */ }
            }

            $porMetodo = [];
            foreach ($registros as $r) {
                $vid = (int)($r['id'] ?? 0);
                if (!empty($pagosPorVenta[$vid])) {
                    // Venta con pagos múltiples: distribuir el monto por método real
                    foreach ($pagosPorVenta[$vid] as $pg) {
                        $mp = $pg['metodo'];
                        if (!isset($porMetodo[$mp])) $porMetodo[$mp] = ['n'=>0,'total'=>0];
                        $porMetodo[$mp]['total'] += (float)$pg['monto'];
                    }
                    // Solo contar la venta una vez en el método "principal" (el de mayor monto)
                    usort($pagosPorVenta[$vid], fn($a,$b) => (float)$b['monto'] <=> (float)$a['monto']);
                    $porMetodo[$pagosPorVenta[$vid][0]['metodo']]['n']++;
                } else {
                    $mp = $r['metodo_pago'] ?: 'efectivo';
                    if (!isset($porMetodo[$mp])) $porMetodo[$mp] = ['n'=>0,'total'=>0];
                    $porMetodo[$mp]['n']++;
                    $porMetodo[$mp]['total'] += (float)$r['total'];
                }
            }
            uasort($porMetodo, fn($a,$b) => $b['total'] <=> $a['total']);
            $mpColors = ['efectivo'=>'success','yape'=>'warning text-dark','plin'=>'info','tarjeta'=>'primary','transferencia'=>'secondary','mixto'=>'dark'];
            foreach ($porMetodo as $mp => $dat):
            ?>
            <tr>
              <td>
                <span class="badge bg-<?= $mpColors[$mp] ?? 'secondary' ?>" style="font-size:9px">
                  <?= $metodoLabels[$mp] ?? ucfirst($mp) ?>
                </span>
              </td>
              <td class="text-center fw-semibold"><?= $dat['n'] ?></td>
              <td class="text-end fw-semibold" style="padding-right:12px"><?= formatMoney($dat['total']) ?></td>
            </tr>
            <?php endforeach; ?>
            <?php if (empty($porMetodo)): ?>
            <tr><td colspan="3" class="text-center text-muted py-3">Sin datos</td></tr>
            <?php endif; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ══ TABLA DETALLE ══ -->
<div class="tr-card">
  <div class="tr-card-header">
    <h6 class="mb-0 small fw-semibold">
      DETALLE DE COMPROBANTES
      <span class="badge bg-secondary ms-1"><?= count($registros) ?></span>
    </h6>
    <a href="?<?= http_build_query(array_merge($_GET, ['export'=>'1'])) ?>"
       class="btn btn-success btn-sm">
      <i data-feather="download" style="width:13px;height:13px"></i>
      Excel
    </a>
  </div>
  <div class="tr-card-body p-0">
    <div class="table-responsive-wrapper" style="overflow-x:auto">
      <table class="tr-table" id="tabla-comprobantes" style="font-size:11px">
        <thead>
          <tr>
            <th>#</th>
            <th>Fecha</th>
            <th>Código</th>
            <th>Origen</th>
            <th>Tipo doc.</th>
            <th>Serie-N°</th>
            <th>Cliente</th>
            <th>RUC/DNI</th>
            <th class="text-end">Base Imp.</th>
            <th class="text-end">IGV</th>
            <th class="text-end">Descuento</th>
            <th class="text-end" style="padding-right:12px">TOTAL</th>
            <th>Método</th>
            <th>Estado</th>
            <th>Usuario</th>
          </tr>
        </thead>
        <tbody>
          <?php if (empty($registros)): ?>
          <tr>
            <td colspan="15" class="text-center text-muted py-5">
              <div style="font-size:32px">📭</div>
              <div class="mt-2">No hay comprobantes en el período seleccionado</div>
            </td>
          </tr>
          <?php endif; ?>
          <?php foreach ($registros as $i => $r):
            $estadoColor = ['completada'=>'success','anulada'=>'danger','pendiente'=>'warning text-dark','entregado'=>'primary'];
            $ec = $estadoColor[$r['estado']] ?? 'secondary';
          ?>
          <tr class="<?= $r['estado']==='anulada' ? 'text-decoration-line-through opacity-50' : '' ?>">
            <td class="text-muted"><?= $i+1 ?></td>
            <td class="small fw-semibold"><?= date('d/m/Y', strtotime($r['fecha'])) ?></td>
            <td>
              <code style="font-size:10px"><?= htmlspecialchars($r['codigo']) ?></code>
            </td>
            <td>
              <span class="badge bg-<?= $r['origen']==='Venta'?'primary':'success' ?>" style="font-size:9px">
                <?= $r['origen'] ?>
              </span>
            </td>
            <td>
              <?php $tdColors = ['boleta'=>'primary','factura'=>'success','ticket'=>'warning text-dark','sin_comprobante'=>'secondary']; ?>
              <span class="badge bg-<?= $tdColors[$r['tipo_doc']] ?? 'secondary' ?>" style="font-size:9px">
                <?= $tipoDocLabels[$r['tipo_doc']] ?? ucfirst($r['tipo_doc']) ?>
              </span>
            </td>
            <td class="small text-muted"><?= htmlspecialchars($r['serie_numero'] ?: '—') ?></td>
            <td class="small fw-semibold" style="max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
              <?= htmlspecialchars($r['cliente']) ?>
            </td>
            <td class="small text-muted"><?= htmlspecialchars($r['ruc_dni'] ?: '—') ?></td>
            <td class="text-end small"><?= number_format($r['base_imponible'], 2) ?></td>
            <td class="text-end small text-muted"><?= number_format($r['igv'], 2) ?></td>
            <td class="text-end small <?= $r['descuento']>0?'text-danger':'' ?>">
              <?= $r['descuento']>0 ? '-'.number_format($r['descuento'],2) : '—' ?>
            </td>
            <td class="text-end fw-bold" style="padding-right:12px">
              <?= formatMoney($r['total']) ?>
            </td>
            <td>
              <?php
              $vid = (int)($r['id'] ?? 0);
              $pgs = $pagosPorVenta[$vid] ?? [];
              if (count($pgs) > 1):
                // Pago mixto: un badge por método con su monto
                foreach ($pgs as $pg):
                  $mp = $pg['metodo'];
              ?>
                <span class="badge bg-<?= $mpColors[$mp] ?? 'secondary' ?> me-1 mb-1" style="font-size:9px"
                      title="<?= ($metodoLabels[$mp] ?? ucfirst($mp)) ?>: S/ <?= number_format($pg['monto'],2) ?>">
                  <?= $metodoLabels[$mp] ?? ucfirst($mp) ?> S/<?= number_format($pg['monto'],0) ?>
                </span>
              <?php endforeach; else: ?>
                <span class="badge bg-<?= $mpColors[$r['metodo_pago']] ?? 'secondary' ?>" style="font-size:9px">
                  <?= $metodoLabels[$r['metodo_pago']] ?? ucfirst($r['metodo_pago']) ?>
                </span>
              <?php endif; ?>
            </td>
            <td>
              <span class="badge bg-<?= $ec ?>" style="font-size:9px">
                <?= ucfirst($r['estado']) ?>
              </span>
            </td>
            <td class="small text-muted hide-mobile"><?= htmlspecialchars($r['usuario']) ?></td>
          </tr>
          <?php endforeach; ?>
        </tbody>
        <?php if (!empty($registros)): ?>
        <tfoot>
          <tr style="background:#1a1a2e;color:#fff;font-weight:700">
            <td colspan="8" class="text-end small">TOTALES (<?= count($registros) ?> documentos):</td>
            <td class="text-end small"><?= number_format($totBase, 2) ?></td>
            <td class="text-end small"><?= number_format($totIGV, 2) ?></td>
            <td class="text-end small"><?= number_format($totDesc, 2) ?></td>
            <td class="text-end" style="padding-right:12px"><?= number_format($totTotal, 2) ?></td>
            <td colspan="3"></td>
          </tr>
        </tfoot>
        <?php endif; ?>
      </table>
    </div>
  </div>
</div>

<!-- ══ AVISO PARA LA CONTADORA ══ -->
<div class="alert alert-info mt-3 d-flex gap-2 align-items-start" style="font-size:12px">
  <span style="font-size:18px">💡</span>
  <div>
    <strong>Nota para contabilidad:</strong> El archivo Excel contiene: número correlativo, fecha, tipo de comprobante, RUC/DNI,
    cliente, base imponible, IGV (18%), descuentos y total por cada documento.
    Las reparaciones (OTs) se incluyen con IGV calculado sobre el precio final.
    Los documentos <strong>anulados</strong> aparecen marcados pero no se excluyen del reporte.
  </div>
</div>

<script>
// Búsqueda rápida en tabla
document.addEventListener('DOMContentLoaded', () => {
    // Agregar buscador inline
    const tabla = document.getElementById('tabla-comprobantes');
    if (!tabla) return;
    const wrapper = tabla.closest('.tr-card-body');
    const input = document.createElement('input');
    input.type = 'text';
    input.className = 'form-control form-control-sm mb-2 mx-3 mt-2';
    input.style.maxWidth = '300px';
    input.placeholder = '🔍 Filtrar por cliente, código, RUC...';
    wrapper.insertBefore(input, wrapper.firstChild);

    input.addEventListener('input', () => {
        const q = input.value.toLowerCase();
        tabla.querySelectorAll('tbody tr').forEach(tr => {
            tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
});
</script>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
