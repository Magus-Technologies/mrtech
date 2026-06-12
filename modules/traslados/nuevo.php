<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/_lib.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

$db   = getDB();
$user = currentUser();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $origen      = (int)($_POST['almacen_origen'] ?? 0);
    $destino     = (int)($_POST['almacen_destino'] ?? 0);
    $observacion = trim($_POST['observacion'] ?? '');
    $enTransito  = ($_POST['modo'] ?? 'transito') !== 'inmediato';

    // Reconstruir items: arrays paralelos producto_id[] y cantidad[]
    $items = [];
    $pids  = $_POST['producto_id'] ?? [];
    $cants = $_POST['cantidad'] ?? [];
    foreach ($pids as $i => $pid) {
        $items[] = ['producto_id' => (int)$pid, 'cantidad' => (float)($cants[$i] ?? 0)];
    }

    try {
        $trasladoId = ejecutarTraslado($db, $origen, $destino, $items, $observacion, $user['id'], $enTransito);
        $msg = $enTransito
            ? 'Traslado creado en tránsito. Confírmalo en destino cuando llegue.'
            : 'Traslado realizado. Stock actualizado en ambos almacenes.';
        setFlash('success', $msg);
        redirect(BASE_URL . 'modules/traslados/ver.php?id=' . $trasladoId);
    } catch (\Throwable $e) {
        setFlash('danger', 'No se pudo realizar el traslado: ' . $e->getMessage());
        // Caemos al formulario manteniendo lo posible
    }
}

$almacenes = listarAlmacenes($db);
if (count($almacenes) < 2) {
    setFlash('danger', 'Necesitas al menos 2 almacenes activos. Crea uno en la sección Almacenes.');
    redirect(BASE_URL . 'modules/traslados/almacenes.php');
}

$principalId = almacenPrincipalId($db);

$pageTitle  = 'Nuevo traslado — ' . APP_NAME;
$breadcrumb = [
    ['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],
    ['label'=>'Traslados','url'=>BASE_URL.'modules/traslados/index.php'],
    ['label'=>'Nuevo','url'=>null],
];
require_once __DIR__ . '/../../includes/header.php';
?>

<h5 class="fw-bold mb-3">Nuevo traslado de productos</h5>

<form method="POST" id="form-traslado">
<div class="row g-3">
  <!-- Configuración -->
  <div class="col-lg-4">
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">DÓNDE</h6></div>
      <div class="tr-card-body">
        <div class="mb-3">
          <label class="tr-form-label">Almacén de origen *</label>
          <select name="almacen_origen" id="sel-origen" class="form-select" required>
            <option value="">Seleccionar...</option>
            <?php foreach ($almacenes as $a): ?>
            <option value="<?= $a['id'] ?>"><?= sanitize($a['nombre']) ?><?= $a['principal']?' (Tienda)':'' ?></option>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="text-center text-muted mb-2"><i data-feather="arrow-down"></i></div>
        <div class="mb-3">
          <label class="tr-form-label">Almacén de destino *</label>
          <select name="almacen_destino" id="sel-destino" class="form-select" required>
            <option value="">Seleccionar...</option>
            <?php foreach ($almacenes as $a): ?>
            <option value="<?= $a['id'] ?>"><?= sanitize($a['nombre']) ?><?= $a['principal']?' (Tienda)':'' ?></option>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="mb-3">
          <label class="tr-form-label">Modo</label>
          <select name="modo" class="form-select form-select-sm">
            <option value="transito" selected>En tránsito (destino confirma recepción)</option>
            <option value="inmediato">Inmediato (entra al confirmar)</option>
          </select>
          <div class="form-text">En tránsito: el stock sale del origen ahora y entra al destino cuando se confirma la recepción.</div>
        </div>
        <div class="mb-0">
          <label class="tr-form-label">Observación</label>
          <textarea name="observacion" class="form-control form-control-sm" rows="2" placeholder="Motivo, guía de remisión, etc."></textarea>
        </div>
      </div>
    </div>
  </div>

  <!-- Productos -->
  <div class="col-lg-8">
    <div class="tr-card mb-3">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">QUÉ TRASLADAR</h6></div>
      <div class="tr-card-body">
        <div class="position-relative mb-3">
          <input type="text" id="buscar-prod" class="form-control" autocomplete="off"
                 placeholder="Buscar producto por nombre, código o serial..." disabled/>
          <div id="resultados" class="list-group position-absolute w-100 shadow-sm" style="z-index:20;max-height:280px;overflow:auto;display:none"></div>
          <div class="form-text" id="hint-origen">Primero elige el almacén de origen.</div>
        </div>

        <div class="table-responsive">
          <table class="tr-table" id="tabla-items">
            <thead>
              <tr><th>Producto</th><th style="width:110px">Disponible</th><th style="width:130px">Cantidad</th><th style="width:40px"></th></tr>
            </thead>
            <tbody id="items-body">
              <tr id="fila-vacia"><td colspan="4" class="text-center text-muted py-3">Sin productos agregados</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="d-flex justify-content-end gap-2">
      <a href="<?= BASE_URL ?>modules/traslados/index.php" class="btn btn-outline-secondary">Cancelar</a>
      <button type="submit" id="btn-guardar" class="btn btn-primary" disabled>
        <i data-feather="repeat" style="width:15px;height:15px"></i> Realizar traslado
      </button>
    </div>
  </div>
</div>
</form>

<script>
(function(){
  const selOrigen  = document.getElementById('sel-origen');
  const selDestino = document.getElementById('sel-destino');
  const buscar     = document.getElementById('buscar-prod');
  const resultados = document.getElementById('resultados');
  const itemsBody  = document.getElementById('items-body');
  const filaVacia  = document.getElementById('fila-vacia');
  const btnGuardar = document.getElementById('btn-guardar');
  const hintOrigen = document.getElementById('hint-origen');
  const agregados  = {}; // producto_id -> {stock}

  let timer = null;

  function evitarMismoAlmacen(changed){
    if (selOrigen.value && selOrigen.value === selDestino.value){
      const other = (changed === selOrigen) ? selDestino : selOrigen;
      other.value = '';
      alert('El origen y el destino deben ser almacenes distintos.');
    }
  }

  function refrescarBuscador(){
    const tieneOrigen = !!selOrigen.value;
    buscar.disabled = !tieneOrigen;
    hintOrigen.style.display = tieneOrigen ? 'none' : 'block';
    if (!tieneOrigen){ vaciarTabla(); }
    else { // cambiar de origen invalida los items (otro stock)
      vaciarTabla();
    }
  }

  function vaciarTabla(){
    Object.keys(agregados).forEach(k=>delete agregados[k]);
    itemsBody.querySelectorAll('tr[data-pid]').forEach(tr=>tr.remove());
    filaVacia.style.display = '';
    actualizarBoton();
  }

  selOrigen.addEventListener('change', ()=>{ evitarMismoAlmacen(selOrigen); refrescarBuscador(); });
  selDestino.addEventListener('change', ()=>{ evitarMismoAlmacen(selDestino); actualizarBoton(); });

  buscar.addEventListener('input', function(){
    clearTimeout(timer);
    const q = this.value.trim();
    timer = setTimeout(()=>cargar(q), 250);
  });

  function cargar(q){
    if (!selOrigen.value){ return; }
    fetch(window.BASE_URL+'modules/traslados/api_productos.php?almacen='+selOrigen.value+'&q='+encodeURIComponent(q))
      .then(r=>r.json())
      .then(data=>{
        resultados.innerHTML='';
        if (!data.length){
          resultados.innerHTML='<div class="list-group-item small text-muted">Sin resultados</div>';
        } else {
          data.forEach(p=>{
            if (agregados[p.id]) return; // ya agregado
            const item=document.createElement('button');
            item.type='button';
            item.className='list-group-item list-group-item-action d-flex justify-content-between align-items-center';
            const sinStock = parseFloat(p.stock) <= 0;
            item.innerHTML =
              '<span><span class="fw-semibold">'+esc(p.nombre)+'</span> '+
              '<code class="small">'+esc(p.codigo)+'</code></span>'+
              '<span class="badge bg-'+(sinStock?'secondary':'success')+'">'+fmt(p.stock)+' '+esc(p.unidad||'')+'</span>';
            if (sinStock){ item.classList.add('disabled'); }
            else { item.addEventListener('click', ()=>agregar(p)); }
            resultados.appendChild(item);
          });
        }
        resultados.style.display='block';
      })
      .catch(()=>{ resultados.innerHTML='<div class="list-group-item small text-danger">Error al buscar</div>'; resultados.style.display='block'; });
  }

  function agregar(p){
    if (agregados[p.id]) return;
    agregados[p.id] = {stock: parseFloat(p.stock)};
    filaVacia.style.display='none';
    const tr=document.createElement('tr');
    tr.dataset.pid=p.id;
    tr.innerHTML =
      '<td><div class="fw-semibold">'+esc(p.nombre)+'</div>'+
        '<div class="text-muted small"><code>'+esc(p.codigo)+'</code> '+esc((p.marca||'')+' '+(p.modelo||''))+'</div>'+
        '<input type="hidden" name="producto_id[]" value="'+p.id+'"></td>'+
      '<td><span class="badge bg-light text-dark border">'+fmt(p.stock)+'</span></td>'+
      '<td><input type="number" name="cantidad[]" class="form-control form-control-sm cant" '+
          'step="0.01" min="0.01" max="'+p.stock+'" value="1" required></td>'+
      '<td><button type="button" class="btn btn-sm btn-outline-danger btn-quitar"><i data-feather="x" style="width:13px;height:13px"></i></button></td>';
    itemsBody.appendChild(tr);

    tr.querySelector('.btn-quitar').addEventListener('click', ()=>{
      delete agregados[p.id]; tr.remove();
      if (!itemsBody.querySelector('tr[data-pid]')) filaVacia.style.display='';
      actualizarBoton();
    });
    tr.querySelector('.cant').addEventListener('input', function(){
      const max=parseFloat(this.max);
      if (parseFloat(this.value)>max){ this.value=max; this.classList.add('is-invalid'); }
      else this.classList.remove('is-invalid');
      actualizarBoton();
    });

    resultados.style.display='none';
    buscar.value=''; buscar.focus();
    if (window.feather) feather.replace();
    actualizarBoton();
  }

  function actualizarBoton(){
    const hayItems = !!itemsBody.querySelector('tr[data-pid]');
    const okDestino = !!selDestino.value && selDestino.value !== selOrigen.value;
    btnGuardar.disabled = !(hayItems && okDestino && selOrigen.value);
  }

  document.addEventListener('click', e=>{
    if (!resultados.contains(e.target) && e.target!==buscar) resultados.style.display='none';
  });

  document.getElementById('form-traslado').addEventListener('submit', function(e){
    let valido=true;
    itemsBody.querySelectorAll('.cant').forEach(inp=>{
      const v=parseFloat(inp.value), max=parseFloat(inp.max);
      if (!(v>0) || v>max){ inp.classList.add('is-invalid'); valido=false; }
    });
    if (!valido){ e.preventDefault(); alert('Revisa las cantidades: deben ser mayores a 0 y no superar el stock disponible.'); }
  });

  function esc(s){ return String(s==null?'':s).replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c])); }
  function fmt(n){ return parseFloat(n||0).toLocaleString('es-PE',{maximumFractionDigits:2}); }
})();
</script>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
