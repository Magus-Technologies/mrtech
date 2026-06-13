<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/../../includes/config_sunat.php';
require_once __DIR__ . '/../../includes/sunat/SunatService.php';
requireLogin();
$db = getDB();

$accion = $_GET['accion'] ?? 'lista';
$id     = (int)($_GET['id'] ?? 0);

// ─── POST ───────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ap = $_POST['accion'] ?? '';

    if ($ap === 'crear') {
        $venta_id   = (int)($_POST['venta_id']   ?? 0);
        $tipo_nota  = $_POST['tipo_nota']         ?? 'credito';
        $cod_motivo = trim($_POST['cod_motivo']   ?? '');
        $des_motivo = trim($_POST['des_motivo']   ?? '');

        if (!in_array($tipo_nota, ['credito', 'debito'], true)) {
            setFlash('danger', 'Tipo de nota inválido.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=nueva');
        }
        if (!$venta_id || !$cod_motivo || !$des_motivo) {
            setFlash('danger', 'Completá todos los campos requeridos.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=nueva');
        }

        $st = $db->prepare("SELECT * FROM ventas WHERE id=? AND tipo_doc IN('boleta','factura') AND sunat_xml IS NOT NULL");
        $st->execute([$venta_id]);
        $venta = $st->fetch();
        if (!$venta) {
            setFlash('danger', 'Venta no encontrada o sin XML generado.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=nueva');
        }
        if ($venta['estado'] === 'anulada') {
            setFlash('danger', 'Esta venta ya está anulada.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=nueva');
        }
        $stNC = $db->prepare("SELECT id FROM notas_credito WHERE venta_id=? AND tipo_nota='credito' AND sunat_estado='aceptado' LIMIT 1");
        $stNC->execute([$venta_id]);
        if ($stNC->fetch()) {
            setFlash('danger', 'Esta venta ya tiene una nota de crédito aceptada por SUNAT.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=nueva');
        }

        if ($tipo_nota === 'credito') {
            $serie = $venta['tipo_doc'] === 'factura' ? SUNAT_SERIE_NC_FACTURA : SUNAT_SERIE_NC_BOLETA;
        } else {
            $serie = $venta['tipo_doc'] === 'factura' ? SUNAT_SERIE_ND_FACTURA : SUNAT_SERIE_ND_BOLETA;
        }
        $numero = SunatService::siguienteNumeroNota($db, $serie);

        $db->prepare("
            INSERT INTO notas_credito (venta_id, tipo_nota, serie, numero, cod_motivo, des_motivo, total)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ")->execute([$venta_id, $tipo_nota, $serie, $numero, $cod_motivo, $des_motivo, (float)$venta['total']]);

        $notaId = (int)$db->lastInsertId();
        setFlash('success', 'Nota creada. Podés generar el XML ahora.');
        redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=ver&id=' . $notaId);
    }

    if ($ap === 'emitir' || $ap === 'regenerar') {
        $nid = (int)$_POST['id'];
        $r   = (new SunatService($db))->generarXmlNota($nid);
        setFlash($r['ok'] ? 'success' : 'danger', $r['ok'] ? 'XML generado. Listo para enviar a SUNAT.' : 'Error: ' . $r['mensaje']);
        redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=ver&id=' . $nid);
    }

    if ($ap === 'enviar_sunat') {
        $nid = (int)$_POST['id'];
        $r   = (new SunatService($db))->enviarSunatNota($nid);
        setFlash($r['ok'] ? 'success' : 'danger', ($r['ok'] ? 'SUNAT aceptó: ' : 'SUNAT rechazó: ') . $r['mensaje']);
        redirect(BASE_URL . 'modules/ventas/notas_credito.php?accion=ver&id=' . $nid);
    }
}

// ─── DESCARGAS ──────────────────────────────────────────────────────
if (in_array($accion, ['xml', 'cdr'], true) && $id) {
    $st = $db->prepare("SELECT * FROM notas_credito WHERE id=?");
    $st->execute([$id]);
    $nota = $st->fetch();
    if (!$nota) { http_response_code(404); echo 'No encontrado.'; exit; }

    $base = 'nota_' . $nota['serie'] . '-' . str_pad((string)$nota['numero'], 8, '0', STR_PAD_LEFT);
    if ($accion === 'xml') {
        if (empty($nota['sunat_xml'])) { http_response_code(404); echo 'Sin XML.'; exit; }
        header('Content-Type: application/xml; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $base . '.xml"');
        echo base64_decode($nota['sunat_xml']); exit;
    }
    if (empty($nota['sunat_cdr'])) { http_response_code(404); echo 'Sin CDR.'; exit; }
    header('Content-Type: application/zip');
    header('Content-Disposition: attachment; filename="R-' . $base . '.zip"');
    echo base64_decode($nota['sunat_cdr']); exit;
}

// ─── LISTA ──────────────────────────────────────────────────────────
if ($accion === 'lista') {
    $fdesde = $_GET['desde'] ?? date('Y-m-01');
    $fhasta = $_GET['hasta'] ?? date('Y-m-d');
    $ftipo  = $_GET['tipo']  ?? '';
    $fsun   = $_GET['sun']   ?? '';

    $w  = "WHERE DATE(n.created_at) BETWEEN ? AND ?";
    $pm = [$fdesde, $fhasta];
    if ($ftipo) { $w .= " AND n.tipo_nota=?"; $pm[] = $ftipo; }
    if ($fsun)  { $w .= " AND n.sunat_estado=?"; $pm[] = $fsun; }

    $st = $db->prepare("
        SELECT n.*, v.tipo_doc, v.serie_doc, v.num_doc, c.nombre as cliente_nombre
        FROM notas_credito n
        JOIN ventas v ON n.venta_id = v.id
        LEFT JOIN clientes c ON c.id = v.cliente_id
        $w
        ORDER BY n.created_at DESC
    ");
    $st->execute($pm);
    $lista = $st->fetchAll();

    $pageTitle  = 'Notas de Crédito — ' . APP_NAME;
    $breadcrumb = [
        ['label' => 'Historial ventas', 'url' => BASE_URL . 'modules/ventas/index.php'],
        ['label' => 'Notas de Crédito', 'url' => null],
    ];
    require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="fw-bold mb-0">Notas de Crédito / Débito</h5>
  <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php?accion=nueva" class="btn btn-primary btn-sm">+ Nueva nota</a>
</div>
<div class="tr-card mb-3">
  <div class="tr-card-body py-2">
    <form method="GET" class="row g-2 align-items-end">
      <input type="hidden" name="accion" value="lista"/>
      <div class="col-md-2"><input type="date" name="desde" class="form-control form-control-sm" value="<?= $fdesde ?>"/></div>
      <div class="col-md-2"><input type="date" name="hasta" class="form-control form-control-sm" value="<?= $fhasta ?>"/></div>
      <div class="col-md-2">
        <select name="tipo" class="form-select form-select-sm">
          <option value="">— Tipo —</option>
          <option value="credito" <?= $ftipo==='credito'?'selected':'' ?>>Crédito</option>
          <option value="debito"  <?= $ftipo==='debito'?'selected':''  ?>>Débito</option>
        </select>
      </div>
      <div class="col-md-2">
        <select name="sun" class="form-select form-select-sm">
          <option value="">— Estado SUNAT —</option>
          <option value="pendiente"  <?= $fsun==='pendiente'?'selected':''  ?>>Pendiente</option>
          <option value="aceptado"   <?= $fsun==='aceptado'?'selected':''   ?>>Aceptado</option>
          <option value="rechazado"  <?= $fsun==='rechazado'?'selected':''  ?>>Rechazado</option>
        </select>
      </div>
      <div class="col-md-1"><button type="submit" class="btn btn-primary btn-sm w-100">Filtrar</button></div>
    </form>
  </div>
</div>
<div class="tr-card">
  <div class="tr-card-body p-0">
    <div class="table-responsive-wrapper" style="overflow-x:auto">
    <table class="tr-table">
      <thead><tr><th>Nota</th><th>Comprobante afectado</th><th>Cliente</th><th>Motivo</th><th class="text-end">Total</th><th>Estado SUNAT</th><th></th></tr></thead>
      <tbody>
      <?php foreach ($lista as $n):
        $se = $n['sunat_estado'];
        $tn = $n['tipo_nota'] === 'credito' ? 'N. CRÉDITO' : 'N. DÉBITO';
        $badgeClass = match($se) { 'aceptado' => 'success', 'rechazado' => 'danger', 'pendiente' => 'warning', default => 'secondary' };
      ?>
      <tr>
        <td>
          <span class="badge bg-<?= $n['tipo_nota']==='credito'?'info':'warning' ?> text-dark"><?= $tn ?></span>
          <div class="small text-muted mt-1"><?= sanitize($n['serie']) ?>-<?= str_pad((string)$n['numero'],8,'0',STR_PAD_LEFT) ?></div>
        </td>
        <td>
          <span class="badge bg-secondary"><?= ucfirst($n['tipo_doc']) ?></span>
          <div class="small text-muted mt-1"><?= sanitize($n['serie_doc']) ?>-<?= str_pad((string)$n['num_doc'],8,'0',STR_PAD_LEFT) ?></div>
        </td>
        <td class="small"><?= sanitize($n['cliente_nombre'] ?? '— Consumidor final —') ?></td>
        <td><span class="badge bg-secondary"><?= sanitize($n['cod_motivo']) ?></span></td>
        <td class="fw-bold text-end"><?= formatMoney($n['total']) ?></td>
        <td><span class="badge bg-<?= $badgeClass ?>"><?= $se ? ucfirst($se) : 'Sin emitir' ?></span></td>
        <td>
          <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php?accion=ver&id=<?= $n['id'] ?>" class="btn btn-outline-primary btn-sm" title="Ver">
            <i data-feather="eye" style="width:13px;height:13px"></i>
          </a>
        </td>
      </tr>
      <?php endforeach; if (empty($lista)): ?>
      <tr><td colspan="7" class="text-center text-muted py-4">Sin notas en el período</td></tr>
      <?php endif; ?>
      </tbody>
    </table>
    </div>
  </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php';

// ─── VER DETALLE ────────────────────────────────────────────────────
} elseif ($accion === 'ver' && $id) {
    $st = $db->prepare("
        SELECT n.*, v.tipo_doc, v.serie_doc, v.num_doc, v.total as v_total, v.igv,
               c.nombre as cliente_nombre, c.ruc_dni
        FROM notas_credito n
        JOIN ventas v ON n.venta_id = v.id
        LEFT JOIN clientes c ON c.id = v.cliente_id
        WHERE n.id=?
    ");
    $st->execute([$id]);
    $nota = $st->fetch();
    if (!$nota) { setFlash('danger', 'Nota no encontrada.'); redirect(BASE_URL . 'modules/ventas/notas_credito.php'); }

    $tituloNota = ($nota['tipo_nota'] === 'credito' ? 'Nota de Crédito' : 'Nota de Débito') . ' ' .
                  $nota['serie'] . '-' . str_pad((string)$nota['numero'], 8, '0', STR_PAD_LEFT);
    $se = $nota['sunat_estado'];
    $badgeClass = match($se) { 'aceptado' => 'success', 'rechazado' => 'danger', 'pendiente' => 'warning', default => 'secondary' };
    $motivos = ['01' => 'Anulación de la operación', '02' => 'Anulación por error en el RUC',
                '06' => 'Devolución total', '07' => 'Devolución por ítem(s)', '13' => 'Ajuste en exportación'];

    $pageTitle  = $tituloNota . ' — ' . APP_NAME;
    $breadcrumb = [
        ['label' => 'Notas', 'url' => BASE_URL . 'modules/ventas/notas_credito.php'],
        ['label' => $tituloNota, 'url' => null],
    ];
    require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-4">
  <div>
    <h4 class="fw-bold mb-0"><?= sanitize($tituloNota) ?></h4>
    <span class="badge bg-<?= $badgeClass ?>"><?= $se ? ucfirst($se) : 'Sin emitir' ?></span>
  </div>
  <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php" class="btn btn-outline-secondary btn-sm">← Volver</a>
</div>

<div class="row g-3">
  <div class="col-lg-8">
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">COMPROBANTE AFECTADO</h6></div>
      <div class="tr-card-body">
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Tipo</span>
          <span class="fw-semibold"><?= ucfirst($nota['tipo_doc']) ?></span>
        </div>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Serie / N°</span>
          <span class="fw-semibold"><?= sanitize($nota['serie_doc']) ?>-<?= str_pad((string)$nota['num_doc'],8,'0',STR_PAD_LEFT) ?></span>
        </div>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Cliente</span>
          <span class="fw-semibold"><?= sanitize($nota['cliente_nombre'] ?? '— Consumidor final —') ?></span>
        </div>
        <?php if ($nota['ruc_dni']): ?>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">RUC/DNI</span>
          <span class="fw-semibold"><?= sanitize($nota['ruc_dni']) ?></span>
        </div>
        <?php endif; ?>
        <div class="d-flex justify-content-between small mb-2 pb-1 border-bottom">
          <span class="text-muted">Total original</span>
          <span class="fw-semibold"><?= formatMoney($nota['v_total']) ?></span>
        </div>
        <div class="mt-3 p-3 rounded bg-light">
          <div class="small text-muted mb-1">Motivo</div>
          <span class="badge bg-secondary me-2"><?= sanitize($nota['cod_motivo']) ?></span>
          <strong><?= sanitize($motivos[$nota['cod_motivo']] ?? $nota['cod_motivo']) ?></strong>
          <div class="mt-1 small text-muted"><?= sanitize($nota['des_motivo']) ?></div>
        </div>
      </div>
    </div>
    <a href="<?= BASE_URL ?>modules/ventas/detalle.php?id=<?= $nota['venta_id'] ?>" class="btn btn-outline-secondary btn-sm">
      <i data-feather="external-link" style="width:13px;height:13px"></i> Ver venta original
    </a>
  </div>

  <div class="col-lg-4">
    <div class="tr-card">
      <div class="tr-card-header d-flex justify-content-between align-items-center">
        <h6 class="mb-0 small fw-semibold">SUNAT</h6>
        <span class="badge bg-<?= $badgeClass ?>"><?= $se ? ucfirst($se) : 'Sin emitir' ?></span>
      </div>
      <div class="tr-card-body">
        <?php if ($nota['sunat_mensaje']): ?>
        <p class="small text-muted mb-3"><?= sanitize($nota['sunat_mensaje']) ?></p>
        <?php endif; ?>

        <div class="d-flex flex-column gap-2">
          <?php if ($se !== 'aceptado'): ?>
          <form method="POST">
            <input type="hidden" name="accion" value="<?= empty($nota['sunat_xml']) ? 'emitir' : 'regenerar' ?>"/>
            <input type="hidden" name="id" value="<?= $id ?>"/>
            <button type="submit" class="btn btn-outline-primary btn-sm w-100">
              <i data-feather="file-text" style="width:13px;height:13px"></i>
              <?= empty($nota['sunat_xml']) ? 'Generar XML' : 'Regenerar XML' ?>
            </button>
          </form>
          <?php endif; ?>

          <?php if (!empty($nota['sunat_xml']) && $se !== 'aceptado'): ?>
          <form method="POST">
            <input type="hidden" name="accion" value="enviar_sunat"/>
            <input type="hidden" name="id" value="<?= $id ?>"/>
            <button type="submit" class="btn btn-success btn-sm w-100"
                    data-confirm="¿Enviar esta nota a SUNAT? Si es aceptada, la venta original quedará anulada.">
              <i data-feather="send" style="width:13px;height:13px"></i> Enviar a SUNAT
            </button>
          </form>
          <?php endif; ?>

          <?php if (!empty($nota['sunat_xml'])): ?>
          <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php?accion=xml&id=<?= $id ?>"
             class="btn btn-outline-secondary btn-sm">
            <i data-feather="download" style="width:13px;height:13px"></i> Descargar XML
          </a>
          <?php endif; ?>

          <?php if (!empty($nota['sunat_cdr'])): ?>
          <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php?accion=cdr&id=<?= $id ?>"
             class="btn btn-outline-secondary btn-sm">
            <i data-feather="download" style="width:13px;height:13px"></i> Descargar CDR
          </a>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php';

// ─── NUEVA NOTA ─────────────────────────────────────────────────────
} elseif ($accion === 'nueva') {
    $preselect = (int)($_GET['venta_id'] ?? 0);
    $ventas = $db->query("
        SELECT v.id, v.tipo_doc, v.serie_doc, v.num_doc, v.total, v.created_at, v.sunat_estado,
               c.nombre as cliente_nombre
        FROM ventas v
        LEFT JOIN clientes c ON c.id = v.cliente_id
        WHERE v.tipo_doc IN ('boleta','factura')
          AND v.sunat_xml IS NOT NULL
          AND v.estado != 'anulada'
          AND NOT EXISTS (
              SELECT 1 FROM notas_credito nc
              WHERE nc.venta_id = v.id AND nc.tipo_nota='credito' AND nc.sunat_estado='aceptado'
          )
        ORDER BY v.created_at DESC
        LIMIT 500
    ")->fetchAll();

    $pageTitle  = 'Nueva Nota de Crédito — ' . APP_NAME;
    $breadcrumb = [
        ['label' => 'Notas', 'url' => BASE_URL . 'modules/ventas/notas_credito.php'],
        ['label' => 'Nueva', 'url' => null],
    ];
    require_once __DIR__ . '/../../includes/header.php';
?>
<div class="d-flex justify-content-between align-items-center mb-4">
  <h4 class="fw-bold mb-0">Nueva Nota de Crédito / Débito</h4>
  <a href="<?= BASE_URL ?>modules/ventas/notas_credito.php" class="btn btn-outline-secondary btn-sm">← Volver</a>
</div>

<form method="POST">
  <input type="hidden" name="accion" value="crear"/>
  <div class="row g-3">
    <div class="col-lg-8">
      <div class="tr-card mb-3">
        <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">COMPROBANTE A AFECTAR</h6></div>
        <div class="tr-card-body">
          <label class="form-label small fw-semibold">Comprobante (solo con XML generado) *</label>
          <select name="venta_id" class="form-select" required id="selVenta">
            <option value="">— Seleccioná un comprobante —</option>
            <?php foreach ($ventas as $v): ?>
            <option value="<?= $v['id'] ?>"
                    data-tipo="<?= sanitize($v['tipo_doc']) ?>"
                    data-total="<?= $v['total'] ?>"
                    <?= $preselect === $v['id'] ? 'selected' : '' ?>>
              [<?= strtoupper($v['sunat_estado']) ?>] <?= ucfirst($v['tipo_doc']) ?> ·
              <?= sanitize($v['serie_doc']) ?>-<?= str_pad((string)$v['num_doc'],8,'0',STR_PAD_LEFT) ?> ·
              <?= sanitize($v['cliente_nombre'] ?? '— Consumidor final —') ?> ·
              <?= formatMoney($v['total']) ?> · <?= sanitize(substr($v['created_at'],0,10)) ?>
            </option>
            <?php endforeach; ?>
          </select>
          <?php if (!$ventas): ?>
          <div class="mt-2 small text-warning">No hay comprobantes con XML generado disponibles.</div>
          <?php endif; ?>
        </div>
      </div>

      <div class="tr-card">
        <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">MOTIVO</h6></div>
        <div class="tr-card-body">
          <label class="form-label small fw-semibold">Código de motivo (catálogo SUNAT 09) *</label>
          <select name="cod_motivo" class="form-select mb-3" required>
            <option value="">— Seleccioná el motivo —</option>
            <option value="01">01 — Anulación de la operación</option>
            <option value="02">02 — Anulación por error en el RUC</option>
            <option value="06">06 — Devolución total</option>
            <option value="07">07 — Devolución por ítem(s) de la operación</option>
            <option value="13">13 — Ajuste en operaciones de exportación</option>
          </select>
          <label class="form-label small fw-semibold">Descripción del motivo *</label>
          <textarea name="des_motivo" class="form-control" rows="3" required
                    placeholder="Describí brevemente el motivo..."></textarea>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="tr-card mb-3">
        <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">TIPO DE NOTA</h6></div>
        <div class="tr-card-body">
          <div class="d-flex gap-2 mb-3">
            <div class="form-check">
              <input class="form-check-input" type="radio" name="tipo_nota" id="tNC" value="credito" checked>
              <label class="form-check-label" for="tNC">Nota de Crédito</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="tipo_nota" id="tND" value="debito">
              <label class="form-check-label" for="tND">Nota de Débito</label>
            </div>
          </div>
          <p class="small text-muted" id="tipoInfo">
            <strong>Crédito:</strong> reduce el importe del comprobante (devoluciones, anulaciones).
          </p>
          <div class="small text-muted p-2 bg-light rounded" id="seriePreview">
            Serie asignada automáticamente al guardar.
          </div>
        </div>
      </div>
      <button type="submit" class="btn btn-primary w-100">Crear nota</button>
    </div>
  </div>
</form>

<script>
(function(){
  var tNC  = document.getElementById('tNC');
  var tND  = document.getElementById('tND');
  var inf  = document.getElementById('tipoInfo');
  var pre  = document.getElementById('seriePreview');
  var sel  = document.getElementById('selVenta');
  var seriesMap = {
    credito: { factura: '<?= SUNAT_SERIE_NC_FACTURA ?>', boleta: '<?= SUNAT_SERIE_NC_BOLETA ?>' },
    debito:  { factura: '<?= SUNAT_SERIE_ND_FACTURA ?>', boleta: '<?= SUNAT_SERIE_ND_BOLETA ?>' }
  };
  function update() {
    var tipo   = tNC.checked ? 'credito' : 'debito';
    var opt    = sel.options[sel.selectedIndex];
    var tipDoc = opt ? (opt.dataset.tipo || '') : '';
    inf.innerHTML = tipo === 'credito'
      ? '<strong>Crédito:</strong> reduce el importe del comprobante (devoluciones, anulaciones).'
      : '<strong>Débito:</strong> aumenta el importe del comprobante (cobros adicionales).';
    pre.textContent = (tipDoc && seriesMap[tipo] && seriesMap[tipo][tipDoc])
      ? 'Serie: ' + seriesMap[tipo][tipDoc]
      : 'Serie asignada automáticamente al guardar.';
  }
  tNC.addEventListener('change', update);
  tND.addEventListener('change', update);
  sel.addEventListener('change', update);
  update();
})();
</script>
<?php require_once __DIR__ . '/../../includes/footer.php';

} else {
    redirect(BASE_URL . 'modules/ventas/notas_credito.php');
}
