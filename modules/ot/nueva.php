<?php
// Aumentar límites en tiempo de ejecución (funciona si PHP-FPM lo permite)
@ini_set('memory_limit', '256M');
@set_time_limit(300);
@ini_set('max_input_time', '300');
ini_set('log_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();

$db   = getDB();
$user = currentUser();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $cliente_id = (int)($_POST['cliente_id'] ?? 0);
    if (!$cliente_id && !empty($_POST['cliente_nombre'])) {
        $cCodigo = generarCodigoCliente($db);
        $db->prepare("INSERT INTO clientes (codigo,nombre,ruc_dni,telefono,whatsapp,email,tipo) VALUES (?,?,?,?,?,?,?)")
           ->execute([$cCodigo,trim($_POST['cliente_nombre']),trim($_POST['cliente_dni']??''),trim($_POST['cliente_tel']??''),trim($_POST['cliente_wa']??''),trim($_POST['cliente_email']??''),$_POST['cliente_tipo']??'persona']);
        $cliente_id = $db->lastInsertId();
    }

    $equipo_id = (int)($_POST['equipo_id'] ?? 0);
    if (!$equipo_id) {
        $db->prepare("INSERT INTO equipos (tipo_equipo_id,cliente_id,marca,modelo,serial,color,descripcion) VALUES (?,?,?,?,?,?,?)")
           ->execute([(int)$_POST['tipo_equipo_id'],$cliente_id,trim($_POST['equipo_marca']??''),trim($_POST['equipo_modelo']??''),trim($_POST['equipo_serial']??''),trim($_POST['equipo_color']??''),trim($_POST['equipo_desc']??'')]);
        $equipo_id = $db->lastInsertId();
    }

    // Checklist dinámico: items del DB + extras del form
    $checklistItems = $db->query("SELECT id,nombre FROM checklist_items WHERE activo=1 ORDER BY orden")->fetchAll();
    $checklist = [];
    foreach ($checklistItems as $item) {
        $key = 'check_item_' . $item['id'];
        $checklist[$item['nombre']] = $_POST[$key] ?? 'no_aplica';
    }
    $checklist['_observacion'] = trim($_POST['check_obs'] ?? '');

    // Prevenir duplicados: misma combinación cliente+equipo en los últimos 2 minutos
    $dup = $db->prepare("SELECT id, codigo_ot, created_at FROM ordenes_trabajo WHERE cliente_id=? AND equipo_id=? AND created_at > DATE_SUB(NOW(), INTERVAL 2 MINUTE) LIMIT 1");
    $dup->execute([$cliente_id, $equipo_id]);
    $dupOt = $dup->fetch();
    if ($dupOt) {
        setFlash('warning', '⚠️ Ya se creó una OT para este cliente y equipo hace menos de 2 minutos: <a href="'.BASE_URL.'modules/ot/ver.php?id='.$dupOt['id'].'" class="fw-bold">'.$dupOt['codigo_ot'].'</a>. Verifica antes de continuar.');
        redirect(BASE_URL . 'modules/ot/nueva.php');
    }

    $costoRep = (float)($_POST['costo_repuestos'] ?? 0);
    $costoMO  = (float)($_POST['costo_mano_obra']  ?? 0);
    $total    = $costoRep + $costoMO;
    $tecnico  = $_POST['tecnico_id'] ? (int)$_POST['tecnico_id'] : null;

    // Insertar la OT con reintento: si el código correlativo choca (huecos por borrados
    // o dos guardados en simultáneo), se regenera y reintenta en vez de reventar con un 500.
    $otId = 0;
    for ($intento = 1; $intento <= 5; $intento++) {
        $codigoOT      = generarCodigoOT($db);
        $codigoPublico = generarCodigoPublicoOT();
        try {
            $db->prepare("INSERT INTO ordenes_trabajo (codigo_ot,codigo_publico,cliente_id,equipo_id,servicio_id,tecnico_id,usuario_creador_id,estado,problema_reportado,diagnostico_inicial,checklist,costo_repuestos,costo_mano_obra,costo_total,precio_final,fecha_estimada,firma_cliente,garantia_dias) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
               ->execute([$codigoOT,$codigoPublico,$cliente_id,$equipo_id,$_POST['servicio_id']?:(null),$tecnico,$user['id'],'ingresado',trim($_POST['problema_reportado']??''),trim($_POST['diagnostico_inicial']??''),json_encode($checklist,JSON_UNESCAPED_UNICODE),$costoRep,$costoMO,$total,$total,$_POST['fecha_estimada']?:null,$_POST['firma_cliente']?:null,(int)($_POST['garantia_dias']??30)]);
            $otId = (int)$db->lastInsertId();
            break;
        } catch (\PDOException $e) {
            // 23000 = violación de clave única (código repetido) → regenerar y reintentar
            if ($e->getCode() === '23000' && $intento < 5) { continue; }
            error_log('Error al crear OT: ' . $e->getMessage());
            setFlash('danger', '❌ No se pudo guardar la orden de trabajo. Volvé a intentar; si el problema persiste avisá al administrador.');
            redirect(BASE_URL . 'modules/ot/nueva.php');
        }
    }

    $db->prepare("INSERT INTO historial_ot (ot_id,usuario_id,estado_nuevo,comentario) VALUES (?,?,?,?)")
       ->execute([$otId,$user['id'],'ingresado','OT creada']);

    // Subir fotos
    if (!empty($_FILES['fotos']['name'][0])) {
        foreach ($_FILES['fotos']['name'] as $i => $fname) {
            if ($_FILES['fotos']['error'][$i] === 0) {
                $ruta = uploadFoto(['name'=>$fname,'type'=>$_FILES['fotos']['type'][$i],'tmp_name'=>$_FILES['fotos']['tmp_name'][$i],'size'=>$_FILES['fotos']['size'][$i]],'ot/'.$otId);
                if ($ruta) {
                    // Intentar con columna tipo_archivo (si ya existe), sino sin ella
                    try {
                        $db->prepare("INSERT INTO fotos_ot (ot_id,ruta,tipo_archivo,tipo) VALUES (?,?,'foto','ingreso')")->execute([$otId,$ruta]);
                    } catch (\Exception $e) {
                        $db->prepare("INSERT INTO fotos_ot (ot_id,ruta,tipo) VALUES (?,?,'ingreso')")->execute([$otId,$ruta]);
                    }
                }
            }
        }
    }
    // Videos: ya fueron subidos via chunk upload ANTES del submit del form
    // Los IDs de videos pendientes vienen en campo oculto video_ot_ids[]
    // El chunk endpoint ya los guardó en fotos_ot con ot_id=0, ahora los reasignamos
    if (!empty($_POST['video_chunk_ids'])) {
        $ids = array_filter(array_map('intval', explode(',', $_POST['video_chunk_ids'])));
        foreach ($ids as $vidId) {
            // ot_id IS NULL porque el FK no permite 0
            $db->prepare("UPDATE fotos_ot SET ot_id=? WHERE id=? AND ot_id IS NULL")
               ->execute([$otId, $vidId]);
        }
    }

    // Guardar repuestos (manuales, del servicio o del INVENTARIO)
    $repDescs   = $_POST['rep_desc']        ?? [];
    $repCants   = $_POST['rep_cant']        ?? [];
    $repPrecios = $_POST['rep_precio']      ?? [];
    $repProdIds = $_POST['rep_producto_id'] ?? [];

    // Almacén principal (para sincronizar stock y kardex, igual que el POS)
    $almacenPrincipal = null;
    try {
        $almacenPrincipal = $db->query("SELECT id FROM almacenes WHERE principal=1 LIMIT 1")->fetchColumn() ?: null;
    } catch (\Throwable $e) { /* módulo de traslados no instalado */ }

    $avisosStock = [];
    foreach ($repDescs as $i => $rd) {
        $rd  = trim($rd);
        $rc  = (float)($repCants[$i]   ?? 1);
        $rp  = (float)($repPrecios[$i] ?? 0);
        $pid = (int)($repProdIds[$i]   ?? 0);
        if (!$rd) continue;

        $db->prepare("INSERT INTO ot_repuestos (ot_id,producto_id,descripcion,cantidad,precio_unit,subtotal) VALUES (?,?,?,?,?,?)")
           ->execute([$otId, $pid ?: null, $rd, $rc, $rp, round($rc*$rp,2)]);

        // Si el repuesto viene del inventario → descontar stock + kardex
        if ($pid > 0 && $rc > 0) {
            try {
                $prod = $db->prepare("SELECT nombre, stock_actual FROM productos WHERE id=? FOR UPDATE");
                $prod->execute([$pid]);
                $p = $prod->fetch();
                if ($p) {
                    $antes = (float)$p['stock_actual'];
                    $descontar = min($rc, max($antes, 0)); // no dejar stock negativo
                    $despues = round($antes - $descontar, 2);
                    if ($descontar < $rc) {
                        $avisosStock[] = "«{$p['nombre']}»: stock insuficiente (disponible {$antes}, solicitado {$rc}). Se descontó solo {$descontar}.";
                    }
                    if ($descontar > 0) {
                        $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")->execute([$despues, $pid]);
                        if ($almacenPrincipal) {
                            $db->prepare("UPDATE stock_almacen SET cantidad=? WHERE almacen_id=? AND producto_id=?")
                               ->execute([$despues, $almacenPrincipal, $pid]);
                        }
                        $db->prepare("INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id) VALUES (?,?,?,?,?,?,?,?,?,?)")
                           ->execute([$pid, $almacenPrincipal, 'salida', $descontar, $antes, $despues, $rp, 'Repuesto OT', $codigoOT, $user['id']]);
                    }
                }
            } catch (\Throwable $e) { /* no bloquear la creación de la OT por un fallo de stock */ }
        }
    }

    if (!empty($avisosStock)) {
        setFlash('warning', "OT $codigoOT creada. Código cliente: <strong>$codigoPublico</strong><br>⚠️ " . implode('<br>⚠️ ', $avisosStock));
    } else {
        setFlash('success', "OT $codigoOT creada. Código cliente: <strong>$codigoPublico</strong>");
    }
    redirect(BASE_URL . 'modules/ot/ver.php?id=' . $otId);}

// Cargar datos
$tiposEquipo    = $db->query("SELECT * FROM tipos_equipo WHERE activo=1 ORDER BY nombre")->fetchAll();
$marcas         = $db->query("SELECT * FROM marcas_equipo WHERE activo=1 ORDER BY nombre")->fetchAll();
$tecnicos       = $db->query("SELECT id,CONCAT(nombre,' ',apellido) as nombre FROM usuarios WHERE rol='tecnico' AND activo=1")->fetchAll();
$clientes       = $db->query("SELECT id,codigo,nombre,telefono FROM clientes WHERE activo=1 ORDER BY nombre")->fetchAll();
$checklistItems = $db->query("SELECT * FROM checklist_items WHERE activo=1 ORDER BY orden")->fetchAll();

$pageTitle  = 'Nueva OT — '.APP_NAME;
$breadcrumb = [['label'=>'Órdenes de trabajo','url'=>BASE_URL.'modules/ot/index.php'],['label'=>'Nueva OT','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<h5 class="fw-bold mb-4">Nueva orden de trabajo</h5>

<form method="POST" enctype="multipart/form-data" id="form-nueva-ot">
<div class="row g-3">
  <div class="col-lg-8">

    <!-- Cliente -->
    <div class="tr-card mb-3">
      <div class="tr-card-header">
        <h6 class="mb-0"><i data-feather="user" class="me-2" style="width:16px;height:16px"></i>Datos del cliente</h6>
        <div class="form-check form-switch mb-0">
          <input class="form-check-input" type="checkbox" id="toggle-nuevo-cliente" onchange="toggleNuevoCliente(this.checked)">
          <label class="form-check-label small" for="toggle-nuevo-cliente">Cliente nuevo</label>
        </div>
      </div>
      <div class="tr-card-body">
        <div id="bloque-cliente-existente">
          <label class="tr-form-label">Buscar cliente registrado *</label>
          <!-- Select oculto: es el que envía cliente_id al POST -->
          <select name="cliente_id" id="sel-cliente" style="display:none">
            <option value="">— Seleccionar cliente —</option>
            <?php foreach($clientes as $c): ?>
            <option value="<?= $c['id'] ?>"><?= sanitize($c['codigo'].' — '.$c['nombre']) ?><?= $c['telefono'] ? ' ('.$c['telefono'].')' : '' ?></option>
            <?php endforeach; ?>
          </select>
          <!-- Input visible de búsqueda -->
          <div class="position-relative">
            <input type="text" id="input-buscar-cliente" class="form-control" placeholder="Escribe nombre, código o teléfono..." autocomplete="off"/>
            <div id="dropdown-clientes" class="list-group position-absolute w-100 shadow-sm" style="display:none;z-index:1050;max-height:220px;overflow-y:auto;top:100%"></div>
          </div>
          <div id="cliente-seleccionado" class="form-text text-success" style="min-height:1.2em"></div>
        </div>
        <div id="bloque-cliente-nuevo" style="display:none">
          <div class="row g-2">
            <div class="col-md-2"><label class="tr-form-label">Tipo</label><select name="cliente_tipo" id="nuevo-cliente-tipo" class="form-select form-select-sm"><option value="persona">Persona</option><option value="empresa">Empresa</option></select></div>
            <div class="col-md-3">
              <label class="tr-form-label">DNI / RUC</label>
              <div class="input-group input-group-sm">
                <input type="text" name="cliente_dni" id="nuevo-cliente-dni" class="form-control form-control-sm" maxlength="11" inputmode="numeric" autocomplete="off"/>
                <span class="input-group-text" id="nuevo-doc-spinner" style="display:none"><span class="spinner-border spinner-border-sm"></span></span>
              </div>
              <div id="nuevo-doc-msg" class="form-text" style="min-height:1.1em"></div>
            </div>
            <div class="col-md-4"><label class="tr-form-label">Nombre *</label><input type="text" name="cliente_nombre" id="nuevo-cliente-nombre" class="form-control form-control-sm"/></div>
            <div class="col-md-3"><label class="tr-form-label">Teléfono</label><input type="text" name="cliente_tel" class="form-control form-control-sm"/></div>
            <div class="col-md-3"><label class="tr-form-label">WhatsApp</label><input type="text" name="cliente_wa" class="form-control form-control-sm" placeholder="51999..."/></div>
            <div class="col-md-5"><label class="tr-form-label">Correo</label><input type="email" name="cliente_email" class="form-control form-control-sm"/></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Equipo -->
    <div class="tr-card mb-3">
      <div class="tr-card-header">
        <h6 class="mb-0"><i data-feather="cpu" class="me-2" style="width:16px;height:16px"></i>Datos del equipo</h6>
      </div>
      <div class="tr-card-body">
        <div class="row g-2">

          <!-- Tipo equipo + botón + -->
          <div class="col-md-4">
            <label class="tr-form-label">Tipo de equipo *</label>
            <div class="input-group">
              <select name="tipo_equipo_id" id="sel-tipo-equipo" class="form-select" required>
                <option value="">— Tipo —</option>
                <?php foreach($tiposEquipo as $t): ?>
                <option value="<?= $t['id'] ?>"><?= sanitize($t['nombre']) ?></option>
                <?php endforeach; ?>
              </select>
              <button type="button" class="btn btn-outline-success" title="Agregar nuevo tipo"
                      onclick="abrirPanelOpciones('tipo_equipo','sel-tipo-equipo')">
                <i data-feather="settings" style="width:14px;height:14px"></i>
              </button>
            </div>
          </div>

          <!-- Marca + botón + -->
          <div class="col-md-4">
            <label class="tr-form-label">Marca</label>
            <div class="input-group">
              <select name="equipo_marca" id="sel-marca" class="form-select">
                <option value="">— Marca —</option>
                <?php foreach($marcas as $m): ?>
                <option value="<?= sanitize($m['nombre']) ?>" data-id="<?= $m['id'] ?>"><?= sanitize($m['nombre']) ?></option>
                <?php endforeach; ?>
              </select>
              <button type="button" class="btn btn-outline-success" title="Agregar nueva marca"
                      onclick="abrirPanelOpciones('marca','sel-marca')">
                <i data-feather="settings" style="width:14px;height:14px"></i>
              </button>
            </div>
          </div>

          <div class="col-md-4"><label class="tr-form-label">Modelo</label><input type="text" name="equipo_modelo" class="form-control"/></div>
          <div class="col-md-4"><label class="tr-form-label">Serial / N° serie</label><input type="text" name="equipo_serial" class="form-control" placeholder="Importante para garantía"/></div>
          <div class="col-md-2"><label class="tr-form-label">Color</label><input type="text" name="equipo_color" class="form-control" placeholder="Negro"/></div>
          <div class="col-md-6"><label class="tr-form-label">Descripción adicional</label><input type="text" name="equipo_desc" class="form-control" placeholder="Stickers, abolladuras previas..."/></div>
        </div>
      </div>
    </div>

    <!-- Diagnóstico -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0"><i data-feather="search" class="me-2" style="width:16px;height:16px"></i>Diagnóstico</h6></div>
      <div class="tr-card-body">
        <div class="mb-3">
          <label class="tr-form-label">Problema reportado por el cliente *</label>
          <textarea name="problema_reportado" class="form-control" rows="3" required placeholder="Describe lo que el cliente indica que falla..."></textarea>
        </div>
        <div>
          <label class="tr-form-label">Diagnóstico inicial (técnico)</label>
          <textarea name="diagnostico_inicial" class="form-control" rows="2" placeholder="Primera revisión rápida..."></textarea>
        </div>
      </div>
    </div>

    <!-- Fotos -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0"><i data-feather="camera" class="me-2" style="width:16px;height:16px"></i>Fotos del equipo</h6></div>
      <div class="tr-card-body">
        <div class="foto-drop-zone" id="foto-drop">
          <i data-feather="upload-cloud" style="width:32px;height:32px;color:#9ca3af"></i>
          <p class="text-muted mb-0 mt-2">Arrastra fotos aquí o haz clic</p>
          <p class="text-muted small">JPG, PNG, WEBP — máx. 5MB</p>
          <input type="file" id="input-fotos" name="fotos[]" multiple accept="image/*" style="display:none"/>
        </div>
        <div class="foto-preview-grid mt-2" id="preview-fotos"></div>

        <!-- ── VIDEOS (chunk upload — evita límite 2MB del servidor) ── -->
        <hr class="my-3"/>
        <div class="d-flex align-items-center justify-content-between mb-2">
          <div>
            <i data-feather="video" style="width:16px;height:16px" class="me-1"></i>
            <span class="fw-semibold small">Videos del equipo</span>
          </div>
          <span class="badge bg-info text-dark" style="font-size:10px">
            🎬 Compresión automática · Sin límite de tamaño
          </span>
        </div>
        <div class="video-drop-zone" id="video-drop"
             style="border:2px dashed #c7d2fe;border-radius:10px;padding:20px;
                    text-align:center;cursor:pointer;background:#f5f3ff;
                    transition:border-color .2s,background .2s">
          <i data-feather="film" style="width:28px;height:28px;color:#818cf8"></i>
          <p class="mb-0 mt-2 small fw-semibold" style="color:#6366f1">Arrastra videos aquí o haz clic</p>
          <p class="text-muted small mb-0" style="font-size:11px">MP4, MOV, AVI, MKV — cualquier tamaño</p>
          <input type="file" id="input-videos" multiple
                 accept="video/mp4,video/quicktime,video/avi,video/webm,.mp4,.mov,.avi,.mkv,.webm,.3gp"
                 style="display:none"/>
        </div>
        <div id="preview-videos" class="mt-2"></div>
        <!-- IDs de videos ya subidos via chunk (se envían con el form) -->
        <input type="hidden" name="video_chunk_ids" id="video-chunk-ids" value=""/>
      </div>
    </div>

    <!-- Repuestos: del inventario, del servicio o manuales -->
    <div class="tr-card mb-3" id="bloque-rep-servicio">
      <div class="tr-card-header">
        <h6 class="mb-0"><i data-feather="tool" class="me-2" style="width:16px;height:16px"></i>Repuestos</h6>
        <button type="button" class="btn btn-outline-success btn-sm py-0" onclick="agregarRepuestoManual()">
          <i data-feather="plus" style="width:13px;height:13px"></i> Manual
        </button>
      </div>
      <div class="tr-card-body">
        <!-- Buscador de inventario -->
        <div class="position-relative mb-2">
          <div class="input-group input-group-sm">
            <span class="input-group-text"><i data-feather="search" style="width:14px;height:14px"></i></span>
            <input type="text" id="buscar-rep-inv" class="form-control"
                   placeholder="Buscar repuesto en inventario (nombre o código)..."
                   autocomplete="off"/>
          </div>
          <div id="resultados-rep-inv" class="list-group position-absolute w-100 shadow"
               style="z-index:1050;max-height:260px;overflow-y:auto;display:none"></div>
        </div>
      </div>
      <div class="tr-card-body p-0 pt-0">
        <table class="tr-table" id="tabla-rep-ot">
          <thead><tr><th>Descripción</th><th style="width:80px">Cant.</th><th style="width:100px">P. Unit (S/)</th><th style="width:90px">Subtotal</th><th style="width:36px"></th></tr></thead>
          <tbody id="tbody-rep-ot">
            <tr id="fila-vacia-rep-ot"><td colspan="5" class="text-center text-muted py-3 small">Sin repuestos — busca en el inventario o agrega manual</td></tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>

  <!-- Columna derecha -->
  <div class="col-lg-4">

    <!-- Checklist dinámico -->
    <div class="tr-card mb-3">
      <div class="tr-card-header">
        <h6 class="mb-0"><i data-feather="check-square" class="me-2" style="width:16px;height:16px"></i>Checklist físico</h6>
        <button type="button" class="btn btn-outline-success btn-sm py-0"
                onclick="agregarChecklistItem()" title="Agregar nuevo ítem">
          <i data-feather="plus" style="width:13px;height:13px"></i> Ítem
        </button>
      </div>
      <div class="tr-card-body p-2" id="checklist-container">
        <?php foreach($checklistItems as $item): ?>
        <div class="checklist-item" id="chk-row-<?= $item['id'] ?>">
          <span class="small" id="chk-label-<?= $item['id'] ?>"><?= sanitize($item['nombre']) ?></span>
          <div class="d-flex align-items-center gap-1">
            <div class="btn-group btn-group-sm" role="group">
              <?php foreach(['bueno'=>'Bueno','malo'=>'Malo','no_aplica'=>'N/A'] as $val=>$txt): ?>
              <input type="radio" class="btn-check" name="check_item_<?= $item['id'] ?>" id="c_<?= $item['id'] ?>_<?= $val ?>" value="<?= $val ?>" <?= $val==='no_aplica'?'checked':'' ?>>
              <label class="btn btn-outline-<?= $val==='bueno'?'success':($val==='malo'?'danger':'secondary') ?> btn-sm py-0"
                     for="c_<?= $item['id'] ?>_<?= $val ?>" style="font-size:11px"><?= $txt ?></label>
              <?php endforeach; ?>
            </div>
            <button type="button" class="btn btn-outline-primary btn-sm py-0 px-1" title="Editar"
                    onclick="editarChecklistItem(<?= $item['id'] ?>, this)">
              <i data-feather="edit-2" style="width:11px;height:11px"></i>
            </button>
            <button type="button" class="btn btn-outline-danger btn-sm py-0 px-1" title="Eliminar"
                    onclick="eliminarChecklistItem(<?= $item['id'] ?>, this)">
              <i data-feather="trash-2" style="width:11px;height:11px"></i>
            </button>
          </div>
        </div>
        <?php endforeach; ?>
        <div class="mt-2">
          <label class="tr-form-label small">Observación</label>
          <textarea name="check_obs" class="form-control form-control-sm" rows="2" placeholder="Golpes, rayones, partes faltantes..."></textarea>
        </div>
      </div>
    </div>

    <!-- Asignación -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0"><i data-feather="settings" class="me-2" style="width:16px;height:16px"></i>Asignación</h6></div>
      <div class="tr-card-body">
        <div class="mb-2"><label class="tr-form-label">Técnico asignado</label>
          <select name="tecnico_id" class="form-select form-select-sm">
            <option value="">Sin asignar</option>
            <?php foreach($tecnicos as $t): ?><option value="<?= $t['id'] ?>"><?= sanitize($t['nombre']) ?></option><?php endforeach; ?>
          </select>
        </div>
        <div class="mb-2"><label class="tr-form-label">Fecha estimada de entrega</label><input type="date" name="fecha_estimada" class="form-control form-control-sm" min="<?= date('Y-m-d') ?>"/></div>
        <div class="mb-2"><label class="tr-form-label">Garantía (días)</label><input type="number" name="garantia_dias" class="form-control form-control-sm" value="30" min="0"/></div>
      </div>
    </div>

    <!-- Presupuesto -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0"><i data-feather="dollar-sign" class="me-2" style="width:16px;height:16px"></i>Presupuesto inicial</h6></div>
      <div class="tr-card-body">
        <div class="mb-2">
          <label class="tr-form-label">Servicio</label>
          <select id="sel-servicio-ot" class="form-select form-select-sm" onchange="cargarServicio(this.value); document.getElementById('servicio_id_hidden').value = this.value;">
            <option value="">— Seleccionar servicio (opcional) —</option>
            <?php
            $svsOT = $db->query("SELECT id, nombre, precio, garantia_dias, requiere_repuestos FROM servicios WHERE activo=1 ORDER BY nombre")->fetchAll();
            foreach ($svsOT as $sv): ?>
            <option value="<?= $sv['id'] ?>"><?= sanitize($sv['nombre']) ?> — <?= formatMoney($sv['precio']) ?></option>
            <?php endforeach; ?>
          </select>
          <input type="hidden" name="servicio_id" id="servicio_id_hidden" value=""/>
        </div>
        <div class="mb-2"><label class="tr-form-label">Costo repuestos (S/)</label><input type="number" id="costo_repuestos" name="costo_repuestos" class="form-control form-control-sm currency-input" step="0.01" value="0"/></div>
        <div class="mb-2"><label class="tr-form-label">Mano de obra (S/)</label><input type="number" id="costo_mano_obra" name="costo_mano_obra" class="form-control form-control-sm currency-input" step="0.01" value="0"/></div>
        <div class="mb-2"><label class="tr-form-label">Descuento (S/)</label><input type="number" id="descuento" name="descuento" class="form-control form-control-sm currency-input" step="0.01" value="0"/></div>
        <div class="p-2 bg-light rounded text-end">
          <span class="small text-muted">Total:</span>
          <span class="fw-bold fs-5 ms-2" id="total_display">S/ 0.00</span>
          <input type="hidden" name="precio_final" id="precio_final" value="0"/>
        </div>
      </div>
    </div>

    <!-- Firma -->
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0"><i data-feather="edit-3" class="me-2" style="width:16px;height:16px"></i>Firma del cliente</h6></div>
      <div class="tr-card-body">
        <p class="text-muted small mb-2">El cliente acepta el ingreso y condiciones del servicio.</p>
        <div id="firma-canvas-wrapper" style="height:120px"><canvas id="firma-canvas" style="width:100%;height:120px"></canvas></div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2 w-100" id="btn-clear-firma">
          <i data-feather="trash-2" style="width:13px;height:13px"></i> Limpiar firma
        </button>
        <input type="hidden" name="firma_cliente" id="firma_cliente"/>
      </div>
    </div>

    <button type="submit" class="btn btn-primary w-100 btn-lg">
      <i data-feather="save" style="width:18px;height:18px"></i> Crear orden de trabajo
    </button>
  </div>
</div>
</form>

<!-- Modal para agregar tipo/marca -->
<div class="modal fade" id="modal-agregar" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header py-2">
        <h6 class="modal-title" id="modal-agregar-titulo">Agregar nuevo</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="text" id="input-nuevo-valor" class="form-control" placeholder="Nombre..."/>
        <div class="text-danger small mt-1" id="error-agregar" style="display:none"></div>
      </div>
      <div class="modal-footer py-2">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-success btn-sm" id="btn-confirmar-agregar">
          <i data-feather="plus" style="width:13px;height:13px"></i> Agregar
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal panel gestión tipo/marca (tabla con editar/eliminar) -->
<div class="modal fade" id="modal-panel-opciones" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header py-2">
        <h6 class="modal-title" id="modal-panel-titulo">Gestionar opciones</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body p-2">
        <div class="input-group input-group-sm mb-2">
          <input type="text" id="input-panel-nuevo" class="form-control" placeholder="Nuevo nombre..."/>
          <button type="button" class="btn btn-success" id="btn-panel-agregar">
            <i data-feather="plus" style="width:13px;height:13px"></i> Agregar
          </button>
        </div>
        <div class="text-danger small mb-1" id="error-panel" style="display:none"></div>
        <table class="table table-sm table-bordered mb-0" id="tabla-panel-opciones">
          <thead class="table-light"><tr><th>Nombre</th><th style="width:90px">Acciones</th></tr></thead>
          <tbody id="tbody-panel-opciones"></tbody>
        </table>
      </div>
      <div class="modal-footer py-2">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal para nuevo ítem checklist -->
<div class="modal fade" id="modal-checklist" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header py-2">
        <h6 class="modal-title">Nuevo ítem de checklist</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="text" id="input-nuevo-check" class="form-control" placeholder="Ej: Micrófono funcional"/>
      </div>
      <div class="modal-footer py-2">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-success btn-sm" id="btn-confirmar-check">Agregar</button>
      </div>
    </div>
  </div>
</div>

<?php
$pageScripts = <<<'JS'
<script>
// ── Toggle cliente nuevo/existente ───────────────────────
function toggleNuevoCliente(nuevo) {
  document.getElementById('bloque-cliente-existente').style.display = nuevo ? 'none' : '';
  document.getElementById('bloque-cliente-nuevo').style.display     = nuevo ? ''     : 'none';
  document.getElementById('sel-cliente').required = !nuevo;
}

// ── Prevenir doble envío ──────────────────────────────────
(function() {
  const form = document.getElementById('form-nueva-ot');
  const btn  = form ? form.querySelector('button[type="submit"]') : null;
  if (form && btn) {
    let submitted = false;
    form.addEventListener('submit', function(e) {
      const toggle = document.getElementById('toggle-nuevo-cliente');
      if (!toggle.checked) {
        const sel = document.getElementById('sel-cliente');
        if (!sel.value) {
          e.preventDefault();
          document.getElementById('input-buscar-cliente').focus();
          document.getElementById('cliente-seleccionado').textContent = '⚠ Debes seleccionar un cliente.';
          document.getElementById('cliente-seleccionado').style.color = 'red';
          return;
        }
      }
      if (submitted) {
        e.preventDefault();
        return;
      }
      submitted = true;
      btn.disabled = true;
      btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Guardando...';
    });
  }
})();

// ── Buscador de cliente (filtra select oculto, sin AJAX) ─
(function() {
  const selOculto  = document.getElementById('sel-cliente');
  const inputBusca = document.getElementById('input-buscar-cliente');
  const dropdown   = document.getElementById('dropdown-clientes');
  const infoSel    = document.getElementById('cliente-seleccionado');

  // Construir array de opciones una sola vez
  const opciones = Array.from(selOculto.options)
    .filter(o => o.value)
    .map(o => ({ id: o.value, texto: o.text }));

  function mostrarDropdown(filtro) {
    const q = filtro.toLowerCase().trim();
    const resultados = q.length < 1 ? [] : opciones.filter(o => o.texto.toLowerCase().includes(q)).slice(0, 30);
    dropdown.innerHTML = '';
    if (!resultados.length) { dropdown.style.display = 'none'; return; }
    resultados.forEach(op => {
      const a = document.createElement('button');
      a.type = 'button';
      a.className = 'list-group-item list-group-item-action py-1 px-2 small';
      a.textContent = op.texto;
      a.addEventListener('mousedown', function(e) {
        e.preventDefault();
        selOculto.value   = op.id;
        inputBusca.value  = op.texto;
        infoSel.textContent = '✓ Seleccionado';
        dropdown.style.display = 'none';
      });
      dropdown.appendChild(a);
    });
    dropdown.style.display = '';
  }

  inputBusca.addEventListener('input', function() {
    selOculto.value = '';
    infoSel.textContent = '';
    mostrarDropdown(this.value);
  });

  inputBusca.addEventListener('focus', function() {
    if (this.value) mostrarDropdown(this.value);
  });

  document.addEventListener('click', function(e) {
    if (!inputBusca.contains(e.target) && !dropdown.contains(e.target)) {
      dropdown.style.display = 'none';
    }
  });
})();

// ── Firma y fotos ────────────────────────────────────────
initFirma('firma-canvas', 'firma_cliente');
// ── FOTOS CON COMPRESIÓN CLIENT-SIDE (evita límite 2MB) ─────────────────
(function() {
  var dropZone   = document.getElementById('foto-drop');
  var inputFotos = document.getElementById('input-fotos');
  var preview    = document.getElementById('preview-fotos');
  if (!dropZone || !inputFotos || !preview) return;

  dropZone.addEventListener('click', function() { inputFotos.click(); });
  dropZone.addEventListener('dragover', function(e) {
    e.preventDefault(); dropZone.classList.add('dragover');
  });
  dropZone.addEventListener('dragleave', function() {
    dropZone.classList.remove('dragover');
  });
  dropZone.addEventListener('drop', function(e) {
    e.preventDefault(); dropZone.classList.remove('dragover');
    procesarFotos(e.dataTransfer.files);
  });
  inputFotos.addEventListener('change', function() {
    procesarFotos(this.files);
    this.value = '';
  });

  // Comprimir foto con Canvas antes de adjuntarla al form
  function comprimirFoto(file, callback) {
    var MAX_W   = 1280;
    var MAX_H   = 1280;
    var QUALITY = 0.82;
    var reader  = new FileReader();
    reader.onload = function(e) {
      var img = new Image();
      img.onload = function() {
        var w = img.width, h = img.height;
        if (w > MAX_W) { h = Math.round(h * MAX_W / w); w = MAX_W; }
        if (h > MAX_H) { w = Math.round(w * MAX_H / h); h = MAX_H; }
        var canvas = document.createElement('canvas');
        canvas.width = w; canvas.height = h;
        canvas.getContext('2d').drawImage(img, 0, 0, w, h);
        canvas.toBlob(function(blob) {
          var newFile = new File([blob], file.name.replace(/\.[^.]+$/, '.jpg'), {type:'image/jpeg'});
          callback(newFile, URL.createObjectURL(blob));
        }, 'image/jpeg', QUALITY);
      };
      img.src = e.target.result;
    };
    reader.readAsDataURL(file);
  }

  function procesarFotos(files) {
    var allowed = ['jpg','jpeg','png','webp','gif','heic','heif'];
    Array.from(files).forEach(function(file) {
      var ext = file.name.split('.').pop().toLowerCase();
      if (!allowed.includes(ext)) {
        alert('Formato no soportado: ' + file.name); return;
      }
      comprimirFoto(file, function(compressed, previewUrl) {
        // Agregar al input con DataTransfer
        var dt = new DataTransfer();
        // Copiar archivos ya existentes
        Array.from(inputFotos.files).forEach(function(f) { dt.items.add(f); });
        dt.items.add(compressed);
        inputFotos.files = dt.files;

        // Mostrar preview
        var div = document.createElement('div');
        div.className = 'foto-preview-item';
        var szKB = Math.round(compressed.size / 1024);
        div.innerHTML = '<img src="' + previewUrl + '" style="width:100%;height:100%;object-fit:cover;border-radius:7px">'
          + '<div class="btn-remove" onclick="quitarFoto(this)" style="position:absolute;top:3px;right:3px;'
          + 'width:22px;height:22px;border-radius:50%;background:rgba(0,0,0,.6);color:#fff;border:none;'
          + 'display:flex;align-items:center;justify-content:center;font-size:12px;cursor:pointer">✕</div>'
          + '<div style="position:absolute;bottom:3px;left:3px;font-size:9px;background:rgba(0,0,0,.5);'
          + 'color:#fff;padding:1px 5px;border-radius:10px">' + szKB + 'KB</div>';
        div.style.position = 'relative';
        preview.appendChild(div);
      });
    });
  }

  window.quitarFoto = function(btn) {
    var item = btn.closest('.foto-preview-item');
    var idx  = Array.from(preview.children).indexOf(item);
    if (idx >= 0) {
      var dt = new DataTransfer();
      Array.from(inputFotos.files).forEach(function(f, i) {
        if (i !== idx) dt.items.add(f);
      });
      inputFotos.files = dt.files;
    }
    item.remove();
  };
})();

// ── VIDEO UPLOAD — CHUNK MODE (evita límite upload_max_filesize) ──────────
(function() {
  var dropZone   = document.getElementById('video-drop');
  var input      = document.getElementById('input-videos');
  var previewDiv = document.getElementById('preview-videos');
  var chunkIdsEl = document.getElementById('video-chunk-ids');
  var submitBtn  = document.querySelector('#form-nueva-ot button[type="submit"]');

  if (!dropZone || !input || !previewDiv) return;

  var CHUNK_SIZE   = 1 * 1024 * 1024; // 1MB por chunk (bajo el límite de 2MB)
  var uploadedIds  = [];   // IDs de fotos_ot insertadas por el servidor
  var uploading    = 0;    // cuántos videos están subiendo

  // Drag & drop
  dropZone.addEventListener('click',    function() { input.click(); });
  dropZone.addEventListener('dragover', function(e) {
    e.preventDefault(); dropZone.style.borderColor='#6366f1'; dropZone.style.background='#eef2ff';
  });
  dropZone.addEventListener('dragleave', function() {
    dropZone.style.borderColor='#c7d2fe'; dropZone.style.background='#f5f3ff';
  });
  dropZone.addEventListener('drop', function(e) {
    e.preventDefault(); dropZone.style.borderColor='#c7d2fe'; dropZone.style.background='#f5f3ff';
    uploadVideos(e.dataTransfer.files);
  });
  input.addEventListener('change', function() { uploadVideos(this.files); input.value=''; });

  function uploadVideos(files) {
    var validExts = ['mp4','mov','avi','mkv','webm','3gp','wmv','m4v'];
    Array.from(files).forEach(function(file) {
      var ext = file.name.split('.').pop().toLowerCase();
      if (!validExts.includes(ext)) {
        alert('Formato no válido: ' + file.name); return;
      }
      startChunkUpload(file);
    });
  }

  function startChunkUpload(file) {
    var fileId     = 'f' + Date.now() + Math.random().toString(36).substr(2,6);
    var totalChunks= Math.ceil(file.size / CHUNK_SIZE);
    var mb         = (file.size / 1024 / 1024).toFixed(1);

    // Crear tarjeta de progreso
    var card = document.createElement('div');
    card.id  = 'vc_' + fileId;
    card.style.cssText = 'display:flex;align-items:center;gap:10px;padding:10px 12px;'
      + 'background:#f5f3ff;border:1px solid #c7d2fe;border-radius:8px;margin-bottom:8px';
    card.innerHTML =
      '<span style="font-size:22px">🎬</span>'
      + '<div style="flex:1;min-width:0">'
      + '<div class="fw-semibold small text-truncate">' + esc(file.name) + '</div>'
      + '<div style="font-size:11px;color:#6b7280" id="vstatus_'+fileId+'">Preparando...</div>'
      + '<div class="progress mt-1" style="height:5px;border-radius:3px;background:#e0d9ff">'
      + '<div id="vprog_'+fileId+'" class="progress-bar" style="width:0%;background:#6366f1;transition:width .3s"></div>'
      + '</div></div>'
      + '<span id="vcheck_'+fileId+'" style="font-size:18px;display:none">✅</span>'
      + '<span id="verr_'+fileId+'"  style="font-size:18px;display:none;color:#dc2626">❌</span>';
    previewDiv.appendChild(card);

    uploading++;
    if (submitBtn) { submitBtn.disabled = true; submitBtn.textContent = 'Esperando videos...'; }

    uploadChunk(file, fileId, 0, totalChunks, mb);
  }

  function uploadChunk(file, fileId, chunkIndex, totalChunks, mb) {
    var start  = chunkIndex * CHUNK_SIZE;
    var end    = Math.min(start + CHUNK_SIZE, file.size);
    var chunk  = file.slice(start, end);

    var statusEl = document.getElementById('vstatus_' + fileId);
    var progEl   = document.getElementById('vprog_'   + fileId);
    var pct      = Math.round((chunkIndex / totalChunks) * 100);

    if (statusEl) statusEl.textContent = 'Subiendo... ' + pct + '% (' + mb + ' MB)';
    if (progEl)   progEl.style.width   = pct + '%';

    var fd = new FormData();
    fd.append('chunk',       chunk, file.name);
    fd.append('chunkIndex',  chunkIndex);
    fd.append('totalChunks', totalChunks);
    fd.append('fileId',      fileId);
    fd.append('fileName',    file.name);
    fd.append('otId',        0); // 0 = no OT todavía, se reasignará al guardar

    fetch(window.BASE_URL + 'modules/ot/upload_video_chunk.php', {
      method: 'POST', body: fd
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.error) {
        onVideoError(fileId, data.error); return;
      }
      if (data.status === 'chunk_ok') {
        // Siguiente chunk
        uploadChunk(file, fileId, chunkIndex + 1, totalChunks, mb);
      } else if (data.status === 'complete') {
        onVideoComplete(fileId, data, mb);
      }
    })
    .catch(function(err) {
      onVideoError(fileId, 'Error de red: ' + err.message);
    });
  }

  function onVideoComplete(fileId, data, mb) {
    var statusEl = document.getElementById('vstatus_' + fileId);
    var progEl   = document.getElementById('vprog_'   + fileId);
    var checkEl  = document.getElementById('vcheck_'  + fileId);

    if (progEl)  progEl.style.width = '100%';
    var finalMb = data.final_size_mb || mb;
    var txt = data.compressed
      ? '✓ Comprimido: ' + finalMb + ' MB'
      : '✓ Guardado: ' + finalMb + ' MB';
    if (statusEl) statusEl.textContent = txt;
    if (checkEl)  checkEl.style.display = '';

    // Guardar el ID del fotos_ot para reasignar al hacer submit
    if (data.fotos_ot_id) {
      uploadedIds.push(data.fotos_ot_id);
      if (chunkIdsEl) chunkIdsEl.value = uploadedIds.join(',');
    }

    uploading--;
    if (uploading <= 0) {
      uploading = 0;
      if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'Crear Orden de Trabajo'; }
    }
  }

  function onVideoError(fileId, msg) {
    var statusEl = document.getElementById('vstatus_' + fileId);
    var errEl    = document.getElementById('verr_'    + fileId);
    if (statusEl) { statusEl.textContent = 'Error: ' + msg; statusEl.style.color='#dc2626'; }
    if (errEl)    errEl.style.display = '';
    uploading--;
    if (uploading <= 0) {
      uploading = 0;
      if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'Crear Orden de Trabajo'; }
    }
  }

  function esc(s) {
    return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }
})();

// ── Cargar servicio seleccionado → precargar repuestos ───
function cargarServicio(id) {
  const tbody  = document.getElementById('tbody-rep-ot');
  if (!id) { quitarRepDeServicio(); return; }

  fetch(window.BASE_URL + 'modules/servicios/api_servicio.php?id=' + id)
    .then(r => r.json())
    .then(data => {
      if (!data.ok) return;
      // Setear mano de obra con el precio del servicio
      const mo = document.getElementById('costo_mano_obra');
      if (mo) { mo.value = parseFloat(data.precio).toFixed(2); calcularTotalOT(); }
      // Setear garantía
      const gar = document.querySelector('input[name="garantia_dias"]');
      if (gar) gar.value = data.garantia;

      // Precargar repuestos del servicio (sin borrar los del inventario/manuales)
      quitarRepDeServicio();
      if (data.requiere && data.repuestos.length > 0) {
        data.repuestos.forEach(r => agregarFilaRepOT(r.nombre + (r.codigo ? ' ['+r.codigo+']' : ''), r.cantidad, r.precio_referencial, 0, null, true));
        recalcTodosRep();
      }
    })
    .catch(() => {});
}

function quitarRepDeServicio() {
  document.querySelectorAll('#tbody-rep-ot tr.rep-servicio').forEach(tr => tr.remove());
  recalcTodosRep();
  mostrarFilaVaciaRep();
}

function mostrarFilaVaciaRep() {
  const tbody = document.getElementById('tbody-rep-ot');
  const vacia = document.getElementById('fila-vacia-rep-ot');
  const filas = tbody.querySelectorAll('tr.rep-row-ot').length;
  if (vacia) vacia.style.display = filas > 0 ? 'none' : '';
}

function agregarFilaRepOT(desc, cant, precio, prodId, stock, esServicio) {
  const tbody = document.getElementById('tbody-rep-ot');
  const vacia = document.getElementById('fila-vacia-rep-ot');
  if (vacia) vacia.style.display = 'none';
  prodId = prodId || 0;
  const sub   = (parseFloat(cant) * parseFloat(precio)).toFixed(2);
  const tr    = document.createElement('tr');
  tr.className = 'rep-row-ot' + (esServicio ? ' rep-servicio' : '');
  const maxAttr   = (prodId && stock !== null && stock !== undefined) ? `max="${stock}"` : '';
  const stockNote = (prodId && stock !== null && stock !== undefined)
    ? `<div class="small text-muted" style="font-size:10px">📦 Stock: ${stock}</div>` : '';
  const descCell = prodId
    ? `<input type="text" name="rep_desc[]" class="form-control form-control-sm" value="${escHtmlOT(desc)}" readonly style="background:#f0fdf4"/>${stockNote}`
    : `<input type="text" name="rep_desc[]" class="form-control form-control-sm" value="${escHtmlOT(desc)}" required/>`;
  tr.innerHTML = `
    <td><input type="hidden" name="rep_producto_id[]" value="${prodId}"/>${descCell}</td>
    <td><input type="number" name="rep_cant[]" class="form-control form-control-sm text-center rep-cant-ot" value="${cant}" min="0.01" ${maxAttr} step="0.01" onchange="recalcFilaOT(this)"/></td>
    <td><input type="number" name="rep_precio[]" class="form-control form-control-sm text-end rep-precio-ot" value="${parseFloat(precio).toFixed(2)}" min="0" step="0.01" onchange="recalcFilaOT(this)"/></td>
    <td class="rep-sub-ot fw-semibold text-end small pe-2">S/ ${sub}</td>
    <td><button type="button" class="btn btn-sm btn-outline-danger py-0 px-1" onclick="this.closest('tr').remove();recalcTodosRep();mostrarFilaVaciaRep()">✕</button></td>`;
  tbody.appendChild(tr);
}

function agregarRepuestoManual() {
  agregarFilaRepOT('', 1, 0, 0, null, false);
}

// ── Buscador de repuestos del INVENTARIO ─────────────────
(function() {
  const input = document.getElementById('buscar-rep-inv');
  const lista = document.getElementById('resultados-rep-inv');
  if (!input || !lista) return;
  let timerInv = null;

  input.addEventListener('input', function() {
    const q = this.value.trim();
    clearTimeout(timerInv);
    if (q.length < 2) { lista.style.display = 'none'; lista.innerHTML = ''; return; }
    timerInv = setTimeout(() => {
      fetch(window.BASE_URL + 'modules/ventas/api_productos.php?accion=buscar&q=' + encodeURIComponent(q), {cache:'no-store'})
        .then(r => r.json())
        .then(res => {
          const data = res.data || [];
          if (!data.length) {
            lista.innerHTML = '<div class="list-group-item small text-muted">Sin resultados en inventario</div>';
            lista.style.display = '';
            return;
          }
          lista.innerHTML = '';
          data.forEach(p => {
            const stock   = parseFloat(p.stock_actual);
            const sinStock = stock <= 0;
            const item = document.createElement('button');
            item.type = 'button';
            item.className = 'list-group-item list-group-item-action py-2' + (sinStock ? ' disabled text-muted' : '');
            item.innerHTML = `
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <div class="small fw-semibold">${escHtmlOT(p.nombre)}</div>
                  <div class="text-muted" style="font-size:11px">${escHtmlOT(p.codigo)} · S/ ${parseFloat(p.precio_venta).toFixed(2)}</div>
                </div>
                <span class="badge ${sinStock ? 'bg-danger' : 'bg-success'}">${sinStock ? 'Sin stock' : 'Stock: ' + stock}</span>
              </div>`;
            if (!sinStock) {
              item.addEventListener('click', () => {
                agregarFilaRepOT(p.nombre + ' [' + p.codigo + ']', 1, p.precio_venta, p.id, stock, false);
                recalcTodosRep();
                input.value = '';
                lista.style.display = 'none';
                lista.innerHTML = '';
              });
            }
            lista.appendChild(item);
          });
          lista.style.display = '';
        })
        .catch(() => {});
    }, 300);
  });

  // Cerrar lista al hacer clic fuera
  document.addEventListener('click', function(e) {
    if (!lista.contains(e.target) && e.target !== input) lista.style.display = 'none';
  });
})();

function recalcFilaOT(inp) {
  const tr  = inp.closest('tr');
  const c   = parseFloat(tr.querySelector('.rep-cant-ot').value)   || 0;
  const p   = parseFloat(tr.querySelector('.rep-precio-ot').value) || 0;
  tr.querySelector('.rep-sub-ot').textContent = 'S/ ' + (c*p).toFixed(2);
  recalcTodosRep();
}

function recalcTodosRep() {
  let total = 0;
  document.querySelectorAll('.rep-row-ot').forEach(tr => {
    const c = parseFloat(tr.querySelector('.rep-cant-ot')?.value)   || 0;
    const p = parseFloat(tr.querySelector('.rep-precio-ot')?.value) || 0;
    total += c * p;
  });
  const crep = document.getElementById('costo_repuestos');
  if (crep) { crep.value = total.toFixed(2); calcularTotalOT(); }
}

function escHtmlOT(s) {
  return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// ── DNI/RUC autocomplete en cliente nuevo ────────────────
(function() {
  const campoDni  = document.getElementById('nuevo-cliente-dni');
  const campoNom  = document.getElementById('nuevo-cliente-nombre');
  const campoTipo = document.getElementById('nuevo-cliente-tipo');
  const spinner   = document.getElementById('nuevo-doc-spinner');
  const msg       = document.getElementById('nuevo-doc-msg');
  let timer = null;

  // Guard: elementos pueden no existir si el formulario cambia
  if (!campoDni || !campoNom) return;

  campoDni.addEventListener('keydown', function(e) {
    const allowed = ['Backspace','Delete','ArrowLeft','ArrowRight','Tab','Enter'];
    if (!allowed.includes(e.key) && !/^\d$/.test(e.key)) e.preventDefault();
  });

  campoDni.addEventListener('input', function() {
    this.value = this.value.replace(/\D/g, '');
    clearTimeout(timer);
    msg.textContent = '';
    spinner.style.display = 'none';
    const len = this.value.length;
    if (len !== 8 && len !== 11) return;
    timer = setTimeout(() => consultarDoc(this.value), 400);
  });

  function consultarDoc(doc) {
    spinner.style.display = '';
    msg.textContent = '';
    fetch(window.BASE_URL + 'modules/clientes/api_documento.php?doc=' + encodeURIComponent(doc))
      .then(r => r.json())
      .then(data => {
        spinner.style.display = 'none';
        if (data.ok) {
          campoNom.value  = data.nombre;
          campoTipo.value = data.tipo;
          msg.textContent = 'Encontrado';
          msg.style.color = 'green';
        } else {
          msg.textContent = 'No encontrado';
          msg.style.color = 'red';
        }
      })
      .catch(() => {
        spinner.style.display = 'none';
        msg.textContent = 'No encontrado';
        msg.style.color = 'red';
      });
  }
})();
// ── Panel gestión tipo equipo / marca ────────────────────
let _panelAccion = '';
let _panelSelect = null;
// Datos en memoria para el panel activo
let _panelItems  = [];

function abrirPanelOpciones(accion, selectId) {
  _panelAccion = accion;
  _panelSelect = document.getElementById(selectId);
  document.getElementById('modal-panel-titulo').textContent =
    accion === 'tipo_equipo' ? '⚙️ Tipos de equipo' : '⚙️ Marcas';
  document.getElementById('input-panel-nuevo').value = '';
  document.getElementById('error-panel').style.display = 'none';

  // Cargar items desde el select actual
  _panelItems = [];
  Array.from(_panelSelect.options).forEach(opt => {
    if (!opt.value) return;
    // Para marcas el value es el nombre; el id real está en data-id
    const realId = accion === 'marca' ? (opt.dataset.id || '') : opt.value;
    _panelItems.push({ id: realId, nombre: opt.text, optValue: opt.value });
  });
  renderTablaPanel();
  new bootstrap.Modal(document.getElementById('modal-panel-opciones')).show();
  setTimeout(() => document.getElementById('input-panel-nuevo').focus(), 400);
}

function renderTablaPanel() {
  const tbody = document.getElementById('tbody-panel-opciones');
  tbody.innerHTML = '';
  _panelItems.forEach(item => {
    const tr = document.createElement('tr');
    tr.id = 'panel-row-' + item.id;
    tr.innerHTML = `
      <td><span id="panel-label-${item.id}">${escHtml(item.nombre)}</span></td>
      <td>
        <button type="button" class="btn btn-outline-primary btn-sm py-0 px-1 me-1" onclick="editarPanelItem('${item.id}','${escHtml(item.nombre).replace(/'/g,"\\'")}')">
          <i data-feather="edit-2" style="width:12px;height:12px"></i>
        </button>
        <button type="button" class="btn btn-outline-danger btn-sm py-0 px-1" onclick="eliminarPanelItem('${item.id}')">
          <i data-feather="trash-2" style="width:12px;height:12px"></i>
        </button>
      </td>`;
    tbody.appendChild(tr);
  });
  feather.replace();
}

// Agregar desde panel
document.getElementById('btn-panel-agregar').addEventListener('click', async function() {
  const valor = document.getElementById('input-panel-nuevo').value.trim();
  if (!valor) return;
  const errDiv = document.getElementById('error-panel');
  errDiv.style.display = 'none';

  const fd = new FormData();
  fd.append('accion', _panelAccion);
  fd.append('valor',  valor);
  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    // Agregar al select
    const opt = new Option(d.nombre, _panelAccion === 'tipo_equipo' ? d.id : d.nombre, false, false);
    if (_panelAccion === 'marca') opt.dataset.id = d.id;
    _panelSelect.add(opt);
    // Agregar a memoria y re-render
    const realId  = String(d.id);
    const optValue = _panelAccion === 'tipo_equipo' ? String(d.id) : d.nombre;
    _panelItems.push({ id: realId, nombre: d.nombre, optValue });
    document.getElementById('input-panel-nuevo').value = '';
    renderTablaPanel();
  } else {
    errDiv.textContent = d.error || 'Error';
    errDiv.style.display = '';
  }
});

document.getElementById('input-panel-nuevo').addEventListener('keydown', e => {
  if (e.key === 'Enter') { e.preventDefault(); document.getElementById('btn-panel-agregar').click(); }
});

async function editarPanelItem(id, nombreActual) {
  const nuevoNombre = prompt('Nuevo nombre:', nombreActual);
  if (!nuevoNombre || nuevoNombre.trim() === nombreActual) return;
  const accionEditar = _panelAccion === 'tipo_equipo' ? 'editar_tipo_equipo' : 'editar_marca';

  const fd = new FormData();
  fd.append('accion', accionEditar);
  fd.append('id',     id);
  fd.append('valor',  nuevoNombre.trim());
  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    // Actualizar select
    const item = _panelItems.find(i => String(i.id) === String(id));
    Array.from(_panelSelect.options).forEach(opt => {
      const matchVal = item ? item.optValue : id;
      if (opt.value === matchVal || String(opt.value) === String(id)) {
        opt.text  = d.nombre;
        opt.value = _panelAccion === 'tipo_equipo' ? String(d.id) : d.nombre;
        if (_panelAccion === 'marca') opt.dataset.id = d.id;
      }
    });
    // Actualizar memoria y re-render
    if (item) { item.nombre = d.nombre; item.optValue = _panelAccion === 'tipo_equipo' ? String(d.id) : d.nombre; }
    renderTablaPanel();
  } else {
    alert(d.error || 'Error al editar');
  }
}

async function eliminarPanelItem(id) {
  if (!confirm('¿Eliminar esta opción?')) return;
  const accionEliminar = _panelAccion === 'tipo_equipo' ? 'eliminar_tipo_equipo' : 'eliminar_marca';

  const fd = new FormData();
  fd.append('accion', accionEliminar);
  fd.append('id',     id);
  fd.append('valor',  '_');
  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    const item = _panelItems.find(i => String(i.id) === String(id));
    // Quitar del select usando optValue (para marcas el value es el nombre)
    Array.from(_panelSelect.options).forEach(opt => {
      const matchVal = item ? item.optValue : id;
      if (opt.value === matchVal || String(opt.value) === String(id)) opt.remove();
    });
    _panelItems = _panelItems.filter(i => String(i.id) !== String(id));
    renderTablaPanel();
  } else {
    alert(d.error || 'Error al eliminar');
  }
}

// ── Agregar ítem checklist ───────────────────────────────
function agregarChecklistItem() {
  document.getElementById('input-nuevo-check').value = '';
  new bootstrap.Modal(document.getElementById('modal-checklist')).show();
  setTimeout(() => document.getElementById('input-nuevo-check').focus(), 400);
}

document.getElementById('btn-confirmar-check').addEventListener('click', async function() {
  const valor = document.getElementById('input-nuevo-check').value.trim();
  if (!valor) return;

  const fd = new FormData();
  fd.append('accion', 'checklist_item');
  fd.append('valor',  valor);

  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    const container = document.getElementById('checklist-container');
    const obsDiv    = container.querySelector('div.mt-2');
    const id        = d.id;
    const div       = document.createElement('div');
    div.className   = 'checklist-item';
    div.id          = 'chk-row-' + id;
    div.innerHTML   = `
      <span class="small" id="chk-label-${id}">${escHtml(d.nombre)}</span>
      <div class="d-flex align-items-center gap-1">
        <div class="btn-group btn-group-sm" role="group">
          ${['bueno','malo','no_aplica'].map((v,i) => `
            <input type="radio" class="btn-check" name="check_item_${id}" id="c_${id}_${v}" value="${v}" ${v==='no_aplica'?'checked':''}>
            <label class="btn btn-outline-${v==='bueno'?'success':v==='malo'?'danger':'secondary'} btn-sm py-0"
                   for="c_${id}_${v}" style="font-size:11px">${['Bueno','Malo','N/A'][i]}</label>
          `).join('')}
        </div>
        <button type="button" class="btn btn-outline-primary btn-sm py-0 px-1" title="Editar"
                onclick="editarChecklistItem(${id}, this)">
          <i data-feather="edit-2" style="width:11px;height:11px"></i>
        </button>
        <button type="button" class="btn btn-outline-danger btn-sm py-0 px-1" title="Eliminar"
                onclick="eliminarChecklistItem(${id}, this)">
          <i data-feather="trash-2" style="width:11px;height:11px"></i>
        </button>
      </div>`;
    container.insertBefore(div, obsDiv);
    bootstrap.Modal.getInstance(document.getElementById('modal-checklist')).hide();
    feather.replace();
  }
});

document.getElementById('input-nuevo-check').addEventListener('keydown', e => {
  if (e.key === 'Enter') { e.preventDefault(); document.getElementById('btn-confirmar-check').click(); }
});

// ── Editar / Eliminar checklist item ─────────────────────
async function editarChecklistItem(id, btn) {
  const labelEl = document.getElementById('chk-label-' + id);
  const actual  = labelEl ? labelEl.textContent : '';
  const nuevo   = prompt('Nuevo nombre:', actual);
  if (!nuevo || nuevo.trim() === actual) return;

  const fd = new FormData();
  fd.append('accion', 'editar_checklist_item');
  fd.append('id',     id);
  fd.append('valor',  nuevo.trim());
  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    if (labelEl) labelEl.textContent = d.nombre;
  } else {
    alert(d.error || 'Error al editar');
  }
}

async function eliminarChecklistItem(id, btn) {
  if (!confirm('¿Eliminar este ítem del checklist?')) return;

  const fd = new FormData();
  fd.append('accion', 'eliminar_checklist_item');
  fd.append('id',     id);
  fd.append('valor',  '_');
  const r = await fetch('api_agregar.php', { method:'POST', body: fd });
  const d = await r.json();

  if (d.ok) {
    const row = document.getElementById('chk-row-' + id);
    if (row) row.remove();
  } else {
    alert(d.error || 'Error al eliminar');
  }
}

function escHtml(s) {
  return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
JS;
require_once __DIR__ . '/../../includes/footer.php';
?>
