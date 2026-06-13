<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/../../includes/config_sunat.php';
requireLogin();
requireRole([ROL_ADMIN]);
$db = getDB();

// Load all config as key=>value
$rows = $db->query("SELECT clave, valor FROM configuracion")->fetchAll();
$cfg  = [];
foreach ($rows as $r) $cfg[$r['clave']] = $r['valor'];

function cfgSet(PDO $db, string $clave, string $valor): void {
    $exists = $db->prepare("SELECT COUNT(*) FROM configuracion WHERE clave=?")->execute([$clave]);
    $db->prepare("INSERT INTO configuracion (clave,valor) VALUES (?,?) ON DUPLICATE KEY UPDATE valor=?")
       ->execute([$clave, $valor, $valor]);
}

// ─── POST ────────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ap = $_POST['accion'] ?? 'guardar';

    if ($ap === 'guardar') {
        $campos = [
            'empresa_ruc'        => preg_replace('/\D/', '', $_POST['empresa_ruc'] ?? ''),
            'empresa_nombre'     => trim($_POST['empresa_nombre']     ?? ''),
            'empresa_direccion'  => trim($_POST['empresa_direccion']  ?? ''),
            'sunat_ubigeo'       => trim($_POST['sunat_ubigeo']       ?? ''),
            'sunat_departamento' => trim($_POST['sunat_departamento'] ?? ''),
            'sunat_provincia'    => trim($_POST['sunat_provincia']     ?? ''),
            'sunat_distrito'     => trim($_POST['sunat_distrito']      ?? ''),
            'sunat_modo'         => in_array($_POST['sunat_modo'] ?? '', ['beta','produccion'], true) ? $_POST['sunat_modo'] : 'beta',
            'sunat_usuario_sol'  => trim($_POST['sunat_usuario_sol']  ?? ''),
            'serie_boleta'       => strtoupper(trim($_POST['serie_boleta']  ?? 'B001')),
            'serie_factura'      => strtoupper(trim($_POST['serie_factura'] ?? 'F001')),
        ];

        // Only update clave_sol if a new value was entered
        $nuevaClave = trim($_POST['sunat_clave_sol'] ?? '');
        if ($nuevaClave !== '') {
            $campos['sunat_clave_sol'] = $nuevaClave;
        }

        if (strlen($campos['empresa_ruc']) !== 11) {
            setFlash('danger', 'El RUC debe tener exactamente 11 dígitos.');
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }

        foreach ($campos as $clave => $valor) {
            cfgSet($db, $clave, $valor);
        }

        setFlash('success', 'Configuración SUNAT guardada correctamente.');
        redirect(BASE_URL . 'modules/configuracion/sunat.php');
    }

    // ─── Subir certificado .pem al API SUNAT ─────────────────────────
    if ($ap === 'subir_pem') {
        $ruc = preg_replace('/\D/', '', $cfg['empresa_ruc'] ?? '');
        if (strlen($ruc) !== 11) {
            setFlash('danger', 'Guardá un RUC válido (11 dígitos) antes de subir el certificado.');
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }
        if (empty($_FILES['pem']['name']) || $_FILES['pem']['error'] !== UPLOAD_ERR_OK) {
            setFlash('danger', 'Seleccioná un archivo .pem válido.');
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }
        $ext = strtolower(pathinfo($_FILES['pem']['name'], PATHINFO_EXTENSION));
        if ($ext !== 'pem') {
            setFlash('danger', 'Solo se acepta archivo .pem (convertido desde .pfx con OpenSSL).');
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }
        if ($_FILES['pem']['size'] > 512 * 1024) {
            setFlash('danger', 'El certificado no debe superar 512 KB.');
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }

        $endpoint = rtrim(SUNAT_API_URL, '/') . '/guardar/certificado/' . $ruc;
        $cfile    = curl_file_create($_FILES['pem']['tmp_name'], 'application/x-pem-file', $_FILES['pem']['name']);

        $ch = curl_init($endpoint);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => ['certificado' => $cfile],
            CURLOPT_TIMEOUT        => 60,
            CURLOPT_HTTPHEADER     => ['Accept: application/json'],
            CURLOPT_SSL_VERIFYPEER => false,
        ]);
        $res  = curl_exec($ch);
        $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err  = curl_error($ch);
        curl_close($ch);

        if ($res === false) {
            setFlash('danger', "No se pudo conectar al API SUNAT: $err");
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }
        $j = json_decode($res, true);
        if (!is_array($j) || empty($j['estado'])) {
            $msg = $j['mensaje'] ?? "HTTP $code: " . substr($res, 0, 200);
            setFlash('danger', "El API rechazó el certificado: $msg");
            redirect(BASE_URL . 'modules/configuracion/sunat.php');
        }

        cfgSet($db, 'sunat_certificado_subido', '1');
        cfgSet($db, 'sunat_certificado_fecha', date('Y-m-d H:i:s'));
        setFlash('success', 'Certificado .pem subido correctamente al API SUNAT (RUC ' . $ruc . ').');
        redirect(BASE_URL . 'modules/configuracion/sunat.php');
    }
}

$certSubido = !empty($cfg['sunat_certificado_subido']);
$certFecha  = $cfg['sunat_certificado_fecha'] ?? '';

$pageTitle  = 'Configuración SUNAT — ' . APP_NAME;
$breadcrumb = [
    ['label' => 'Configuración', 'url' => BASE_URL . 'modules/configuracion/index.php'],
    ['label' => 'SUNAT',         'url' => null],
];
require_once __DIR__ . '/../../includes/header.php';

function cv(string $key, array $cfg, string $default = ''): string {
    return sanitize($cfg[$key] ?? $default);
}
?>

<h5 class="fw-bold mb-4">Configuración SUNAT / Facturación electrónica</h5>

<form method="POST">
<input type="hidden" name="accion" value="guardar"/>
<div class="row g-3">

  <!-- Columna izquierda -->
  <div class="col-lg-6">

    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">DATOS DEL EMISOR</h6></div>
      <div class="tr-card-body">
        <div class="row g-2">
          <div class="col-12">
            <label class="tr-form-label">RUC * (11 dígitos)</label>
            <div class="input-group">
              <input type="text" id="rucInp" name="empresa_ruc"
                     value="<?= cv('empresa_ruc', $cfg) ?>"
                     maxlength="11" inputmode="numeric" class="form-control" required/>
              <button type="button" class="btn btn-outline-secondary btn-sm" id="btnBuscarRuc">
                <i data-feather="search" style="width:14px;height:14px"></i> Buscar SUNAT
              </button>
            </div>
            <small id="rucMsg" class="text-muted" style="font-size:11px"></small>
          </div>
          <div class="col-12">
            <label class="tr-form-label">Razón social *</label>
            <input type="text" name="empresa_nombre" class="form-control"
                   value="<?= cv('empresa_nombre', $cfg) ?>" required/>
          </div>
          <div class="col-12">
            <label class="tr-form-label">Dirección</label>
            <input type="text" name="empresa_direccion" class="form-control"
                   value="<?= cv('empresa_direccion', $cfg) ?>" placeholder="Av. Principal 123"/>
          </div>
        </div>
      </div>
    </div>

    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">UBICACIÓN (UBIGEO)</h6></div>
      <div class="tr-card-body">
        <div class="row g-2">
          <div class="col-md-4">
            <label class="tr-form-label">Ubigeo</label>
            <input type="text" name="sunat_ubigeo" class="form-control"
                   value="<?= cv('sunat_ubigeo', $cfg) ?>" maxlength="6" placeholder="150101"/>
          </div>
          <div class="col-md-4">
            <label class="tr-form-label">Departamento</label>
            <input type="text" name="sunat_departamento" class="form-control"
                   value="<?= cv('sunat_departamento', $cfg) ?>"/>
          </div>
          <div class="col-md-4">
            <label class="tr-form-label">Provincia</label>
            <input type="text" name="sunat_provincia" class="form-control"
                   value="<?= cv('sunat_provincia', $cfg) ?>"/>
          </div>
          <div class="col-md-6">
            <label class="tr-form-label">Distrito</label>
            <input type="text" name="sunat_distrito" class="form-control"
                   value="<?= cv('sunat_distrito', $cfg) ?>"/>
          </div>
        </div>
      </div>
    </div>

    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">SERIES DE COMPROBANTES</h6></div>
      <div class="tr-card-body">
        <div class="row g-2">
          <div class="col-md-6">
            <label class="tr-form-label">Serie Boleta</label>
            <input type="text" name="serie_boleta" class="form-control"
                   value="<?= cv('serie_boleta', $cfg, 'B001') ?>" maxlength="4" placeholder="B001"/>
            <small class="text-muted" style="font-size:11px">Debe empezar con B</small>
          </div>
          <div class="col-md-6">
            <label class="tr-form-label">Serie Factura</label>
            <input type="text" name="serie_factura" class="form-control"
                   value="<?= cv('serie_factura', $cfg, 'F001') ?>" maxlength="4" placeholder="F001"/>
            <small class="text-muted" style="font-size:11px">Debe empezar con F</small>
          </div>
        </div>
      </div>
    </div>

  </div>

  <!-- Columna derecha -->
  <div class="col-lg-6">

    <div class="tr-card mb-3">
      <div class="tr-card-header d-flex justify-content-between align-items-center">
        <h6 class="mb-0 small fw-semibold">CREDENCIALES SOL</h6>
        <span class="badge bg-<?= ($cfg['sunat_modo'] ?? 'beta') === 'produccion' ? 'success' : 'warning text-dark' ?>">
          <?= ($cfg['sunat_modo'] ?? 'beta') === 'produccion' ? 'PRODUCCIÓN' : 'BETA' ?>
        </span>
      </div>
      <div class="tr-card-body">
        <div class="row g-2">
          <div class="col-12">
            <label class="tr-form-label">Modo SUNAT</label>
            <select name="sunat_modo" class="form-select">
              <option value="beta"       <?= ($cfg['sunat_modo'] ?? 'beta') === 'beta'       ? 'selected' : '' ?>>BETA — Pruebas (MODDATOS)</option>
              <option value="produccion" <?= ($cfg['sunat_modo'] ?? '') === 'produccion'      ? 'selected' : '' ?>>PRODUCCIÓN — Real</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="tr-form-label">Usuario SOL</label>
            <input type="text" name="sunat_usuario_sol" class="form-control"
                   value="<?= cv('sunat_usuario_sol', $cfg) ?>" placeholder="Ej: TUUSER01"/>
            <small class="text-muted" style="font-size:11px">BETA: usar <code>MODDATOS</code></small>
          </div>
          <div class="col-md-6">
            <label class="tr-form-label">Clave SOL</label>
            <input type="password" name="sunat_clave_sol" class="form-control"
                   placeholder="Dejar vacío para no cambiar"/>
            <small class="text-muted" style="font-size:11px">BETA: usar <code>MODDATOS</code></small>
          </div>
        </div>
      </div>
    </div>

    <div class="tr-card mb-3">
      <div class="tr-card-header d-flex justify-content-between align-items-center">
        <h6 class="mb-0 small fw-semibold">CERTIFICADO DIGITAL (.pem)</h6>
        <?php if ($certSubido): ?>
          <span class="badge bg-success">Cargado <?= sanitize(substr($certFecha, 0, 10)) ?></span>
        <?php else: ?>
          <span class="badge bg-danger">Sin certificado</span>
        <?php endif; ?>
      </div>
      <div class="tr-card-body">
        <p class="small text-muted mb-3">
          El certificado se envía directamente al API Laravel firmador y se guarda allí, no en este servidor.<br>
          Si tu certificado es <code>.pfx</code>, conviértelo con:<br>
          <code>openssl pkcs12 -in cert.pfx -out cert.pem -nodes</code>
        </p>
        <button type="button" class="btn btn-outline-primary btn-sm" id="btnSelectPem">
          <i data-feather="upload" style="width:13px;height:13px"></i>
          <?= $certSubido ? 'Reemplazar certificado' : 'Subir certificado .pem' ?>
        </button>
        <small id="pemFileName" class="text-muted ms-2" style="font-size:11px"></small>
      </div>
    </div>

    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">API SUNAT</h6></div>
      <div class="tr-card-body">
        <div class="d-flex justify-content-between small mb-1">
          <span class="text-muted">Endpoint API</span>
          <code class="small"><?= sanitize(SUNAT_API_URL) ?></code>
        </div>
        <div class="d-flex justify-content-between small mb-1">
          <span class="text-muted">Entorno activo</span>
          <span class="fw-semibold"><?= defined('APP_ENV') && APP_ENV === 'production' ? 'Producción' : 'Local' ?></span>
        </div>
        <div class="d-flex justify-content-between small">
          <span class="text-muted">RUC activo</span>
          <code><?= sanitize(SUNAT_RUC) ?></code>
        </div>
      </div>
    </div>

  </div>

  <div class="col-12">
    <button type="submit" class="btn btn-primary">
      <i data-feather="save" style="width:14px;height:14px"></i> Guardar configuración
    </button>
  </div>
</div>
</form>

<!-- Form aparte para el .pem (sube al API, no a la BD) -->
<form method="POST" enctype="multipart/form-data" id="frmPem" style="display:none">
  <input type="hidden" name="accion" value="subir_pem"/>
  <input type="file" name="pem" id="pemFile" accept=".pem"/>
</form>

<script>
(function(){
  // RUC lookup
  var rucInp = document.getElementById('rucInp');
  var msgEl  = document.getElementById('rucMsg');
  var btn    = document.getElementById('btnBuscarRuc');
  rucInp.addEventListener('input', function(){ rucInp.value = rucInp.value.replace(/\D/g,''); });
  rucInp.addEventListener('keydown', function(e){ if(e.key==='Enter'){e.preventDefault();btn.click();} });
  btn.addEventListener('click', async function(){
    var doc = rucInp.value.trim();
    if(doc.length!==11){ msgEl.textContent='El RUC debe tener 11 dígitos.'; msgEl.style.color='#dc3545'; return; }
    var orig = btn.innerHTML;
    btn.disabled=true; btn.textContent='Consultando...';
    msgEl.textContent='Consultando SUNAT...'; msgEl.style.color='#6c757d';
    try {
      var r = await fetch('<?= BASE_URL ?>modules/clientes/api_documento.php?doc='+doc, {headers:{'Accept':'application/json'}});
      var j = await r.json();
      if(!r.ok||!j.ok){ msgEl.textContent=j.msg||'No se encontró el RUC.'; msgEl.style.color='#dc3545'; return; }
      document.querySelector('input[name="empresa_nombre"]').value    = j.data.razon_social||'';
      if(j.data.direccion)    document.querySelector('input[name="empresa_direccion"]').value   = j.data.direccion;
      if(j.data.departamento) document.querySelector('input[name="sunat_departamento"]').value  = j.data.departamento;
      if(j.data.provincia)    document.querySelector('input[name="sunat_provincia"]').value     = j.data.provincia;
      if(j.data.distrito)     document.querySelector('input[name="sunat_distrito"]').value      = j.data.distrito;
      msgEl.textContent='✓ '+j.data.razon_social; msgEl.style.color='#198754';
    } catch(err){
      msgEl.textContent='Error de red: '+err.message; msgEl.style.color='#dc3545';
    } finally {
      btn.disabled=false; btn.innerHTML=orig;
    }
  });

  // Certificate upload
  var btnPem  = document.getElementById('btnSelectPem');
  var pemFile = document.getElementById('pemFile');
  var pemName = document.getElementById('pemFileName');
  var frmPem  = document.getElementById('frmPem');
  btnPem.addEventListener('click', function(){ pemFile.click(); });
  pemFile.addEventListener('change', function(){
    var f = pemFile.files[0];
    if(!f) return;
    if(!/\.pem$/i.test(f.name)){ alert('Solo se acepta archivo .pem'); pemFile.value=''; return; }
    if(f.size>512*1024){ alert('El certificado no debe superar 512 KB.'); pemFile.value=''; return; }
    pemName.textContent='📄 '+f.name+' ('+Math.round(f.size/1024)+' KB)';
    if(confirm('¿Subir "'+f.name+'" al API SUNAT para el RUC actual?\nReemplazará cualquier certificado anterior.')){
      frmPem.submit();
    } else { pemFile.value=''; pemName.textContent=''; }
  });
})();
</script>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
