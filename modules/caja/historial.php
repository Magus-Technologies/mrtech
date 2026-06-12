<?php
/**
 * historial.php — Ver historial de cajas con selector de fecha
 * Permite consultar cualquier caja pasada con todos sus movimientos
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_VENDEDOR]);

$db      = getDB();
$user    = currentUser();
$esAdmin = ($user['rol'] === ROL_ADMIN);

// ── Parámetros ────────────────────────────────────────────
$fechaDesde = $_GET['desde'] ?? date('Y-m-01');  // Primer día del mes
$fechaHasta = $_GET['hasta'] ?? date('Y-m-d');   // Hoy
$cajaSelId  = (int)($_GET['caja_id'] ?? 0);

// ── Listar cajas en rango (vendedor: solo las suyas) ─────
$filtroUsuario = $esAdmin ? "" : " AND ca.usuario_id = " . (int)$user['id'];
$stmtCajas = $db->prepare("
    SELECT ca.*,
           CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre,
           (SELECT COALESCE(SUM(monto),0) FROM movimientos_caja WHERE caja_id=ca.id AND tipo='ingreso') AS ing_real,
           (SELECT COALESCE(SUM(monto),0) FROM movimientos_caja WHERE caja_id=ca.id AND tipo='egreso')  AS egr_real,
           (SELECT COUNT(*) FROM movimientos_caja WHERE caja_id=ca.id) AS total_movs
    FROM cajas ca
    JOIN usuarios u ON u.id = ca.usuario_id
    WHERE ca.fecha BETWEEN ? AND ? $filtroUsuario
    ORDER BY ca.fecha DESC, ca.id DESC
");
$stmtCajas->execute([$fechaDesde, $fechaHasta]);
$cajas = $stmtCajas->fetchAll();

// ── Si hay caja seleccionada, cargar su detalle ──────────
$cajaActual  = null;
$movimientos = [];
$ventasInfo  = [];

if ($cajaSelId) {
    $stmtC = $db->prepare("
        SELECT ca.*, CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre
        FROM cajas ca JOIN usuarios u ON u.id = ca.usuario_id
        WHERE ca.id = ?
    ");
    $stmtC->execute([$cajaSelId]);
    $cajaActual = $stmtC->fetch();

    // Seguridad: el vendedor solo puede ver el detalle de SUS cajas
    if ($cajaActual && !$esAdmin && (int)$cajaActual['usuario_id'] !== (int)$user['id']) {
        $cajaActual = null;
    }

    if ($cajaActual) {
        $stmtM = $db->prepare("
            SELECT mv.*, CONCAT(u.nombre,' ',u.apellido) AS usuario_nombre
            FROM movimientos_caja mv
            JOIN usuarios u ON u.id = mv.usuario_id
            WHERE mv.caja_id = ?
            ORDER BY mv.created_at ASC
        ");
        $stmtM->execute([$cajaSelId]);
        $movimientos = $stmtM->fetchAll();

        // Enriquecer con info de ventas/OTs
        foreach ($movimientos as &$mv) {
            $ref = trim($mv['referencia'] ?? '');
            if (str_starts_with($ref, 'VTA-')) {
                $sv = $db->prepare("SELECT v.codigo, v.tipo_doc, v.metodo_pago, v.total, c.nombre AS cliente FROM ventas v LEFT JOIN clientes c ON c.id=v.cliente_id WHERE v.codigo=? LIMIT 1");
                $sv->execute([$ref]);
                $mv['_venta'] = $sv->fetch() ?: null;
            } elseif (str_starts_with($ref, 'OT-')) {
                $so = $db->prepare("SELECT ot.codigo_ot, ot.estado, ot.precio_final, c.nombre AS cliente FROM ordenes_trabajo ot JOIN clientes c ON c.id=ot.cliente_id WHERE ot.codigo_ot=? LIMIT 1");
                $so->execute([$ref]);
                $mv['_ot'] = $so->fetch() ?: null;
            }
        }
        unset($mv);
    }
}

// ── Totales del rango para KPIs superiores ───────────────
$stmtTot = $db->prepare("
    SELECT
        COUNT(*) as total_cajas,
        COALESCE(SUM((SELECT SUM(monto) FROM movimientos_caja WHERE caja_id=ca.id AND tipo='ingreso')),0) AS total_ing,
        COALESCE(SUM((SELECT SUM(monto) FROM movimientos_caja WHERE caja_id=ca.id AND tipo='egreso')),0)  AS total_egr,
        COALESCE(SUM(ca.saldo_inicial),0) AS total_apertura
    FROM cajas ca
    WHERE ca.fecha BETWEEN ? AND ?
");
$stmtTot->execute([$fechaDesde, $fechaHasta]);
$totalesRango = $stmtTot->fetch();

// Calcular totales propios del detalle
$totalIng = 0; $totalEgr = 0;
foreach ($movimientos as $mv) {
    if ($mv['tipo'] === 'ingreso') $totalIng += (float)$mv['monto'];
    else                           $totalEgr += (float)$mv['monto'];
}
$saldoEsperado = $cajaActual ? round((float)$cajaActual['saldo_inicial'] + $totalIng - $totalEgr, 2) : 0;

$pageTitle  = 'Historial de Cajas — ' . APP_NAME;
$breadcrumb = [
    ['label' => 'Caja', 'url' => BASE_URL . 'modules/caja/index.php'],
    ['label' => 'Historial', 'url' => null],
];
require_once __DIR__ . '/../../includes/header.php';
?>

<!-- ══ CABECERA ══ -->
<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
  <h5 class="fw-bold mb-0">📅 Historial de Cajas</h5>
  <div class="d-flex gap-2">
    <a href="<?= BASE_URL ?>modules/caja/index.php" class="btn btn-outline-secondary btn-sm">
      ← Caja actual
    </a>
  </div>
</div>

<!-- ══ FILTRO FECHAS ══ -->
<div class="tr-card mb-3">
  <div class="tr-card-body py-2">
    <form method="GET" class="d-flex flex-wrap gap-2 align-items-center">
      <input type="hidden" name="caja_id" value="<?= $cajaSelId ?>">
      <label class="tr-form-label mb-0 fw-semibold">Rango de fechas:</label>
      <div class="d-flex gap-1 align-items-center">
        <input type="date" name="desde" class="form-control form-control-sm" value="<?= $fechaDesde ?>" style="width:140px">
        <span class="text-muted small">a</span>
        <input type="date" name="hasta" class="form-control form-control-sm" value="<?= $fechaHasta ?>" style="width:140px">
      </div>
      <button type="submit" class="btn btn-primary btn-sm">🔍 Buscar</button>
      <!-- Accesos rápidos -->
      <div class="d-flex gap-1 flex-wrap ms-2">
        <?php
        $shortcuts = [
          'Hoy'       => [date('Y-m-d'), date('Y-m-d')],
          'Ayer'      => [date('Y-m-d', strtotime('-1 day')), date('Y-m-d', strtotime('-1 day'))],
          '7 días'    => [date('Y-m-d', strtotime('-7 days')), date('Y-m-d')],
          'Este mes'  => [date('Y-m-01'), date('Y-m-d')],
          'Mes pasado'=> [date('Y-m-01', strtotime('first day of last month')), date('Y-m-t', strtotime('first day of last month'))],
        ];
        foreach ($shortcuts as $label => [$d, $h]):
        ?>
        <a href="?desde=<?= $d ?>&hasta=<?= $h ?>" class="btn btn-outline-secondary btn-sm py-0" style="font-size:11px"><?= $label ?></a>
        <?php endforeach; ?>
      </div>
    </form>
  </div>
</div>

<!-- ══ KPIs DEL RANGO ══ -->
<div class="row g-3 mb-3">
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Cajas en rango</div>
      <div class="kpi-value fw-bold" style="font-size:24px"><?= (int)$totalesRango['total_cajas'] ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Total ingresos</div>
      <div class="kpi-value text-success"><?= formatMoney($totalesRango['total_ing']) ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Total egresos</div>
      <div class="kpi-value text-danger"><?= formatMoney($totalesRango['total_egr']) ?></div>
    </div>
  </div>
  <div class="col-6 col-md-3">
    <div class="kpi-card">
      <div class="kpi-label">Neto del período</div>
      <div class="kpi-value fw-bold" style="color:<?= ($totalesRango['total_ing']-$totalesRango['total_egr'])>=0?'#16a34a':'#dc2626' ?>">
        <?= formatMoney($totalesRango['total_ing'] - $totalesRango['total_egr']) ?>
      </div>
    </div>
  </div>
</div>

<div class="row g-3">

  <!-- ══ LISTA DE CAJAS ══ -->
  <div class="col-lg-4">
    <div class="tr-card">
      <div class="tr-card-header">
        <h6 class="mb-0 small fw-semibold">CAJAS DEL PERÍODO</h6>
        <span class="badge bg-secondary"><?= count($cajas) ?></span>
      </div>
      <div class="tr-card-body p-0" style="max-height:600px;overflow-y:auto">
        <?php if (empty($cajas)): ?>
        <div class="text-center text-muted py-4">
          <div style="font-size:32px">📭</div>
          <div class="small mt-2">Sin cajas en este rango</div>
        </div>
        <?php else: ?>
        <?php foreach ($cajas as $c):
          $cIng  = (float)$c['ing_real'];
          $cEgr  = (float)$c['egr_real'];
          $cSf   = $c['estado']==='cerrada' ? (float)$c['saldo_final'] : round((float)$c['saldo_inicial']+$cIng-$cEgr,2);
          $isSelected = ($c['id'] == $cajaSelId);
          $dif   = (float)($c['diferencia_cierre'] ?? 0);
        ?>
        <a href="?desde=<?= $fechaDesde ?>&hasta=<?= $fechaHasta ?>&caja_id=<?= $c['id'] ?>"
           class="d-block text-decoration-none <?= $isSelected ? 'bg-primary bg-opacity-10 border-start border-primary border-3' : '' ?>"
           style="padding:10px 14px;border-bottom:1px solid #f3f4f6">
          <div class="d-flex justify-content-between align-items-start">
            <div>
              <div class="fw-semibold small" style="color:#1a1a2e">
                <?= date('d/m/Y', strtotime($c['fecha'])) ?>
                <?php if ($c['fecha'] === date('Y-m-d')): ?>
                <span class="badge bg-success ms-1" style="font-size:9px">HOY</span>
                <?php endif; ?>
              </div>
              <div class="text-muted" style="font-size:10px"><?= htmlspecialchars($c['usuario_nombre']) ?></div>
            </div>
            <div class="text-end">
              <span class="badge bg-<?= $c['estado']==='cerrada'?'secondary':'success' ?>" style="font-size:9px">
                <?= $c['estado']==='cerrada' ? 'Cerrada' : '🟢 Abierta' ?>
              </span>
              <?php if ($c['estado']==='cerrada' && $dif != 0): ?>
              <div style="font-size:9px;margin-top:2px" class="<?= $dif>0?'text-warning':'text-danger' ?>">
                <?= $dif>0?'⚠️':'❌' ?> <?= formatMoney(abs($dif)) ?>
              </div>
              <?php elseif ($c['estado']==='cerrada'): ?>
              <div style="font-size:9px;margin-top:2px" class="text-success">✅ Cuadra</div>
              <?php endif; ?>
            </div>
          </div>
          <div class="d-flex gap-3 mt-1" style="font-size:10px">
            <span class="text-success">↑ <?= number_format($cIng,2) ?></span>
            <span class="text-danger">↓ <?= number_format($cEgr,2) ?></span>
            <span class="fw-semibold">= <?= number_format($cSf,2) ?></span>
            <span class="text-muted ms-auto"><?= $c['total_movs'] ?> movs.</span>
          </div>
        </a>
        <?php endforeach; ?>
        <?php endif; ?>
      </div>
    </div>
  </div>

  <!-- ══ DETALLE DE CAJA SELECCIONADA ══ -->
  <div class="col-lg-8">
    <?php if (!$cajaActual): ?>
    <div class="tr-card h-100 d-flex align-items-center justify-content-center" style="min-height:300px">
      <div class="text-center text-muted">
        <div style="font-size:48px">👈</div>
        <div class="fw-semibold mt-2">Selecciona una caja de la lista</div>
        <div class="small mt-1">para ver sus movimientos detallados</div>
      </div>
    </div>
    <?php else: ?>

    <!-- Header de la caja seleccionada -->
    <div class="tr-card mb-3">
      <div class="tr-card-header">
        <div>
          <h6 class="mb-0 fw-bold">📅 Caja del <?= date('d/m/Y', strtotime($cajaActual['fecha'])) ?></h6>
          <div class="small text-muted">Cajero: <?= htmlspecialchars($cajaActual['usuario_nombre']) ?></div>
        </div>
        <div class="d-flex gap-2">
          <a href="<?= BASE_URL ?>modules/caja/reporte_pdf.php?id=<?= $cajaActual['id'] ?>"
             target="_blank" class="btn btn-danger btn-sm">
            📄 PDF
          </a>
          <span class="badge bg-<?= $cajaActual['estado']==='cerrada'?'secondary':'success' ?> align-self-center">
            <?= $cajaActual['estado']==='cerrada' ? '🔒 Cerrada' : '🟢 Abierta' ?>
          </span>
        </div>
      </div>
    </div>

    <!-- KPIs del día seleccionado -->
    <div class="row g-2 mb-3">
      <div class="col-6 col-md-3">
        <div class="kpi-card">
          <div class="kpi-label">Saldo inicial</div>
          <div class="kpi-value text-success" style="font-size:16px"><?= formatMoney($cajaActual['saldo_inicial']) ?></div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="kpi-card">
          <div class="kpi-label">Ingresos</div>
          <div class="kpi-value text-primary" style="font-size:16px"><?= formatMoney($totalIng) ?></div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="kpi-card">
          <div class="kpi-label">Egresos</div>
          <div class="kpi-value text-danger" style="font-size:16px"><?= formatMoney($totalEgr) ?></div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <?php $dif = (float)($cajaActual['diferencia_cierre'] ?? 0); ?>
        <div class="kpi-card" style="<?= $cajaActual['estado']==='cerrada' && $dif!=0 ? 'border-color:'.($dif>0?'#fde047':'#fca5a5') : '' ?>">
          <div class="kpi-label"><?= $cajaActual['estado']==='cerrada' ? 'Saldo final' : 'Esperado' ?></div>
          <div class="kpi-value fw-bold" style="font-size:16px"><?= formatMoney($cajaActual['estado']==='cerrada'?(float)$cajaActual['saldo_final']:$saldoEsperado) ?></div>
          <?php if ($cajaActual['estado']==='cerrada'): ?>
          <div class="small <?= $dif==0?'text-success':($dif>0?'text-warning':'text-danger') ?>">
            <?= $dif==0?'✅ Cuadra':($dif>0?'⚠️ Sobrante':'❌ Faltante').': '.formatMoney(abs($dif)) ?>
          </div>
          <?php endif; ?>
        </div>
      </div>
    </div>

    <!-- Tabs -->
    <div class="tr-card">
      <div class="tr-card-body p-0">
        <ul class="nav nav-tabs px-3 pt-3" style="font-size:12px">
          <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-movs">
              📋 Todos los movimientos
              <span class="badge bg-secondary ms-1"><?= count($movimientos) ?></span>
            </button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-ing">
              ⬆️ Ingresos
              <span class="badge bg-success ms-1"><?= count(array_filter($movimientos, fn($m)=>$m['tipo']==='ingreso')) ?></span>
            </button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-egr">
              ⬇️ Egresos
              <span class="badge bg-danger ms-1"><?= count(array_filter($movimientos, fn($m)=>$m['tipo']==='egreso')) ?></span>
            </button>
          </li>
          <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-comparativo">
              📊 Comparativo
            </button>
          </li>
        </ul>

        <div class="tab-content px-0">

          <!-- ─ Tab: TODOS LOS MOVIMIENTOS ─ -->
          <div class="tab-pane fade show active" id="tab-movs">
            <div class="table-responsive-wrapper" style="overflow-x:auto">
              <table class="tr-table">
                <thead>
                  <tr>
                    <th>Hora</th>
                    <th>Tipo</th>
                    <th>Concepto</th>
                    <th>Referencia</th>
                    <th>Cliente</th>
                    <th>Usuario</th>
                    <th class="text-end" style="padding-right:12px">Monto</th>
                  </tr>
                </thead>
                <tbody>
                  <?php if (empty($movimientos)): ?>
                  <tr><td colspan="7" class="text-center text-muted py-4">Sin movimientos en esta caja</td></tr>
                  <?php endif; ?>
                  <?php foreach ($movimientos as $mv):
                    $venta = $mv['_venta'] ?? null;
                    $ot    = $mv['_ot']    ?? null;
                  ?>
                  <tr>
                    <td class="text-muted small"><?= date('H:i', strtotime($mv['created_at'])) ?></td>
                    <td>
                      <span class="badge bg-<?= $mv['tipo']==='ingreso'?'success':'danger' ?>" style="font-size:10px">
                        <?= $mv['tipo']==='ingreso' ? '↑ Ing' : '↓ Egr' ?>
                      </span>
                    </td>
                    <td class="small"><?= htmlspecialchars($mv['concepto']) ?></td>
                    <td class="small">
                      <?php $ref = trim($mv['referencia'] ?? ''); ?>
                      <?php if ($ref): ?>
                      <code style="font-size:10px"><?= htmlspecialchars($ref) ?></code>
                      <?php else: echo '—'; endif; ?>
                    </td>
                    <td class="small text-muted">
                      <?= $venta ? htmlspecialchars($venta['cliente'] ?: 'Consumidor') :
                         ($ot ? htmlspecialchars($ot['cliente']) : '—') ?>
                    </td>
                    <td class="small text-muted hide-mobile"><?= htmlspecialchars($mv['usuario_nombre']) ?></td>
                    <td class="fw-semibold text-end small <?= $mv['tipo']==='ingreso'?'text-success':'text-danger' ?>" style="padding-right:12px">
                      <?= $mv['tipo']==='ingreso' ? '+' : '-' ?><?= formatMoney($mv['monto']) ?>
                    </td>
                  </tr>
                  <?php endforeach; ?>
                </tbody>
                <?php if (!empty($movimientos)): ?>
                <tfoot>
                  <tr style="background:#f9fafb">
                    <td colspan="5"></td>
                    <td class="small fw-bold text-end text-success">+<?= formatMoney($totalIng) ?></td>
                    <td class="small fw-bold text-end text-danger" style="padding-right:12px">-<?= formatMoney($totalEgr) ?></td>
                  </tr>
                </tfoot>
                <?php endif; ?>
              </table>
            </div>
          </div>

          <!-- ─ Tab: INGRESOS ─ -->
          <div class="tab-pane fade" id="tab-ing">
            <div class="table-responsive-wrapper" style="overflow-x:auto">
              <table class="tr-table">
                <thead>
                  <tr>
                    <th>Hora</th>
                    <th>Concepto</th>
                    <th>Referencia</th>
                    <th>Tipo doc</th>
                    <th>Cliente</th>
                    <th>Método</th>
                    <th class="text-end" style="padding-right:12px">Monto</th>
                  </tr>
                </thead>
                <tbody>
                  <?php $ings = array_filter($movimientos, fn($m)=>$m['tipo']==='ingreso');
                  if (empty($ings)): ?>
                  <tr><td colspan="7" class="text-center text-muted py-4">Sin ingresos</td></tr>
                  <?php endif; ?>
                  <?php foreach ($ings as $mv):
                    $venta = $mv['_venta'] ?? null;
                    $ot    = $mv['_ot']    ?? null;
                  ?>
                  <tr>
                    <td class="text-muted small"><?= date('H:i', strtotime($mv['created_at'])) ?></td>
                    <td class="small"><?= htmlspecialchars($mv['concepto']) ?></td>
                    <td class="small"><code style="font-size:10px"><?= htmlspecialchars($mv['referencia'] ?: '—') ?></code></td>
                    <td>
                      <?php if ($venta): ?>
                      <span class="badge bg-primary" style="font-size:9px"><?= ucfirst($venta['tipo_doc']) ?></span>
                      <?php elseif ($ot): ?>
                      <span class="badge bg-success" style="font-size:9px">OT</span>
                      <?php else: echo '—'; endif; ?>
                    </td>
                    <td class="small text-muted">
                      <?= $venta ? htmlspecialchars($venta['cliente'] ?: 'Consumidor') :
                         ($ot ? htmlspecialchars($ot['cliente']) : '—') ?>
                    </td>
                    <td class="small text-muted">
                      <?= $venta ? ucfirst($venta['metodo_pago']) : ($ot ? 'OT' : '—') ?>
                    </td>
                    <td class="fw-semibold text-end text-success" style="padding-right:12px">
                      +<?= formatMoney($mv['monto']) ?>
                    </td>
                  </tr>
                  <?php endforeach; ?>
                </tbody>
                <?php if (!empty($ings)): ?>
                <tfoot>
                  <tr><td colspan="6" class="text-end fw-bold">TOTAL INGRESOS</td>
                  <td class="text-end fw-bold text-success" style="padding-right:12px">+<?= formatMoney($totalIng) ?></td></tr>
                </tfoot>
                <?php endif; ?>
              </table>
            </div>
          </div>

          <!-- ─ Tab: EGRESOS ─ -->
          <div class="tab-pane fade" id="tab-egr">
            <div class="table-responsive-wrapper" style="overflow-x:auto">
              <table class="tr-table">
                <thead>
                  <tr>
                    <th>Hora</th>
                    <th>Concepto</th>
                    <th>Referencia</th>
                    <th>Usuario</th>
                    <th class="text-end" style="padding-right:12px">Monto</th>
                  </tr>
                </thead>
                <tbody>
                  <?php $egrs = array_filter($movimientos, fn($m)=>$m['tipo']==='egreso');
                  if (empty($egrs)): ?>
                  <tr><td colspan="5" class="text-center text-muted py-4">Sin egresos registrados</td></tr>
                  <?php endif; ?>
                  <?php foreach ($egrs as $mv): ?>
                  <tr>
                    <td class="text-muted small"><?= date('H:i', strtotime($mv['created_at'])) ?></td>
                    <td class="small"><?= htmlspecialchars($mv['concepto']) ?></td>
                    <td class="small"><code style="font-size:10px"><?= htmlspecialchars($mv['referencia'] ?: '—') ?></code></td>
                    <td class="small text-muted"><?= htmlspecialchars($mv['usuario_nombre']) ?></td>
                    <td class="fw-semibold text-end text-danger" style="padding-right:12px">
                      -<?= formatMoney($mv['monto']) ?>
                    </td>
                  </tr>
                  <?php endforeach; ?>
                </tbody>
                <?php if (!empty($egrs)): ?>
                <tfoot>
                  <tr><td colspan="4" class="text-end fw-bold">TOTAL EGRESOS</td>
                  <td class="text-end fw-bold text-danger" style="padding-right:12px">-<?= formatMoney($totalEgr) ?></td></tr>
                </tfoot>
                <?php endif; ?>
              </table>
            </div>
          </div>

          <!-- ─ Tab: COMPARATIVO ─ -->
          <div class="tab-pane fade" id="tab-comparativo">
            <div class="p-3">
              <div class="row g-3">

                <!-- Resumen financiero comparativo -->
                <div class="col-md-6">
                  <div class="fw-semibold small mb-2">📊 Flujo del día</div>
                  <?php
                  $saldoIni = (float)$cajaActual['saldo_inicial'];
                  $saldoFin = $cajaActual['estado']==='cerrada' ? (float)$cajaActual['saldo_final'] : $saldoEsperado;
                  $maxVal   = max($saldoIni + $totalIng, 1);
                  ?>
                  <table style="width:100%;font-size:11px;border-collapse:collapse">
                    <tbody>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:6px 4px">Saldo inicial</td>
                        <td style="width:40%;padding:6px 4px">
                          <div style="background:#e5e7eb;border-radius:3px;height:8px">
                            <div style="width:<?= min(100, round($saldoIni/$maxVal*100)) ?>%;background:#16a34a;height:8px;border-radius:3px"></div>
                          </div>
                        </td>
                        <td class="text-end fw-semibold text-success" style="padding:6px 4px"><?= formatMoney($saldoIni) ?></td>
                      </tr>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:6px 4px">+ Ingresos</td>
                        <td style="padding:6px 4px">
                          <div style="background:#e5e7eb;border-radius:3px;height:8px">
                            <div style="width:<?= min(100, round($totalIng/$maxVal*100)) ?>%;background:#2563eb;height:8px;border-radius:3px"></div>
                          </div>
                        </td>
                        <td class="text-end fw-semibold text-primary" style="padding:6px 4px">+<?= formatMoney($totalIng) ?></td>
                      </tr>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:6px 4px">− Egresos</td>
                        <td style="padding:6px 4px">
                          <div style="background:#e5e7eb;border-radius:3px;height:8px">
                            <div style="width:<?= min(100, round($totalEgr/$maxVal*100)) ?>%;background:#dc2626;height:8px;border-radius:3px"></div>
                          </div>
                        </td>
                        <td class="text-end fw-semibold text-danger" style="padding:6px 4px">-<?= formatMoney($totalEgr) ?></td>
                      </tr>
                      <tr style="background:#f9fafb">
                        <td style="padding:6px 4px;font-weight:700">= Saldo esperado</td>
                        <td style="padding:6px 4px">
                          <div style="background:#e5e7eb;border-radius:3px;height:8px">
                            <div style="width:<?= min(100, round($saldoEsperado/$maxVal*100)) ?>%;background:#7c3aed;height:8px;border-radius:3px"></div>
                          </div>
                        </td>
                        <td class="text-end fw-bold" style="padding:6px 4px;color:#7c3aed"><?= formatMoney($saldoEsperado) ?></td>
                      </tr>
                      <?php if ($cajaActual['estado']==='cerrada'): ?>
                      <tr>
                        <td style="padding:6px 4px">Saldo contado</td>
                        <td style="padding:6px 4px">
                          <div style="background:#e5e7eb;border-radius:3px;height:8px">
                            <div style="width:<?= min(100, round($saldoFin/$maxVal*100)) ?>%;background:#f59e0b;height:8px;border-radius:3px"></div>
                          </div>
                        </td>
                        <td class="text-end fw-semibold" style="padding:6px 4px;color:#f59e0b"><?= formatMoney($saldoFin) ?></td>
                      </tr>
                      <?php $dif = (float)($cajaActual['diferencia_cierre'] ?? 0); if ($cajaActual['estado']==='cerrada'): ?>
                      <tr style="background:<?= $dif==0?'#f0fdf4':($dif>0?'#fef9c3':'#fef2f2') ?>">
                        <td colspan="2" style="padding:6px 4px;font-weight:700">
                          <?= $dif==0 ? '✅ Cuadra perfectamente' : ($dif>0?'⚠️ Sobrante':'❌ Faltante') ?>
                        </td>
                        <td class="text-end fw-bold <?= $dif==0?'text-success':($dif>0?'text-warning':'text-danger') ?>" style="padding:6px 4px">
                          <?= formatMoney(abs($dif)) ?>
                        </td>
                      </tr>
                      <?php endif; ?>
                      <?php endif; ?>
                    </tbody>
                  </table>
                </div>

                <!-- Resumen de movimientos por tipo -->
                <div class="col-md-6">
                  <div class="fw-semibold small mb-2">📋 Resumen de movimientos</div>
                  <?php
                  $ventasCount = 0; $ventasMonto = 0;
                  $otsCount    = 0; $otsMonto    = 0;
                  $manuCount   = 0; $manuMonto   = 0;
                  foreach (array_filter($movimientos, fn($m)=>$m['tipo']==='ingreso') as $mv) {
                      $ref = trim($mv['referencia'] ?? '');
                      if (str_starts_with($ref,'VTA-')) { $ventasCount++; $ventasMonto += $mv['monto']; }
                      elseif (str_starts_with($ref,'OT-')) { $otsCount++; $otsMonto += $mv['monto']; }
                      else { $manuCount++; $manuMonto += $mv['monto']; }
                  }
                  $egrCount = count(array_filter($movimientos, fn($m)=>$m['tipo']==='egreso'));
                  ?>
                  <table style="width:100%;font-size:11px;border-collapse:collapse">
                    <thead style="background:#3b4a6b;color:#fff">
                      <tr><th style="padding:5px 8px">Tipo</th><th class="text-center" style="padding:5px 8px">Cant.</th><th class="text-end" style="padding:5px 8px">Total</th></tr>
                    </thead>
                    <tbody>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:5px 8px">🛒 Ventas</td>
                        <td class="text-center" style="padding:5px 8px"><?= $ventasCount ?></td>
                        <td class="text-end text-success fw-semibold" style="padding:5px 8px">+<?= formatMoney($ventasMonto) ?></td>
                      </tr>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:5px 8px">🔧 Reparaciones</td>
                        <td class="text-center" style="padding:5px 8px"><?= $otsCount ?></td>
                        <td class="text-end text-success fw-semibold" style="padding:5px 8px">+<?= formatMoney($otsMonto) ?></td>
                      </tr>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:5px 8px">➕ Ingresos manuales</td>
                        <td class="text-center" style="padding:5px 8px"><?= $manuCount ?></td>
                        <td class="text-end text-success fw-semibold" style="padding:5px 8px">+<?= formatMoney($manuMonto) ?></td>
                      </tr>
                      <tr style="border-bottom:1px solid #f3f4f6">
                        <td style="padding:5px 8px">➖ Egresos</td>
                        <td class="text-center" style="padding:5px 8px"><?= $egrCount ?></td>
                        <td class="text-end text-danger fw-semibold" style="padding:5px 8px">-<?= formatMoney($totalEgr) ?></td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr style="background:#1a1a2e;color:#fff">
                        <td colspan="2" style="padding:5px 8px;font-weight:700">NETO DEL DÍA</td>
                        <td class="text-end fw-bold" style="padding:5px 8px;color:<?= ($totalIng-$totalEgr)>=0?'#4ade80':'#f87171' ?>">
                          <?= formatMoney($totalIng - $totalEgr) ?>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

              </div>

              <!-- Botón PDF grande -->
              <div class="text-center mt-4">
                <a href="<?= BASE_URL ?>modules/caja/reporte_pdf.php?id=<?= $cajaActual['id'] ?>"
                   target="_blank" class="btn btn-danger btn-lg px-5">
                  📄 Generar Reporte PDF completo
                </a>
                <div class="text-muted small mt-2">El PDF incluye todos los movimientos, denominaciones, comparativo y firmas</div>
              </div>

            </div>
          </div>

        </div><!-- /tab-content -->
      </div><!-- /tr-card-body -->
    </div><!-- /tr-card -->

    <?php endif; ?>
  </div><!-- /col-lg-8 -->

</div><!-- /row -->

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
