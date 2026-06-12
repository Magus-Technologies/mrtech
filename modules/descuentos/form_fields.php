<?php
// Campos compartidos entre crear y editar
// $vendedoras debe estar definida en el scope del padre
$pfx = isset($edit) ? 'edit-' : '';
?>
<div class="row g-3">
  <?php if(!isset($edit)): ?>
  <div class="col-md-4">
    <label class="tr-form-label">Código * <span class="text-muted small">(se guarda en mayúsculas)</span></label>
    <input type="text" name="codigo" class="form-control text-uppercase"
           required maxlength="30" placeholder="VERANO20" style="font-family:monospace;font-weight:bold"/>
  </div>
  <?php endif; ?>
  <div class="col-md-8">
    <label class="tr-form-label">Descripción</label>
    <input type="text" name="descripcion" id="edit-desc" class="form-control" maxlength="200"
           placeholder="Ej: Descuento especial para vendedora Ana"/>
  </div>
  <div class="col-md-3">
    <label class="tr-form-label">Tipo de descuento</label>
    <select name="tipo" id="edit-tipo" class="form-select">
      <option value="porcentaje">% Porcentaje</option>
      <option value="monto_fijo">S/ Monto fijo</option>
    </select>
  </div>
  <div class="col-md-3">
    <label class="tr-form-label">Valor del descuento *</label>
    <div class="input-group">
      <input type="number" name="valor" id="edit-valor" class="form-control" required
             step="0.01" min="0.01" placeholder="10"/>
    </div>
  </div>
  <div class="col-md-6">
    <label class="tr-form-label">Asignar a vendedora <span class="text-muted small">(vacío = todas)</span></label>
    <select name="vendedor_id" id="edit-vend" class="form-select">
      <option value="">— Todas las vendedoras —</option>
      <?php foreach($vendedoras as $v): ?>
      <option value="<?= $v['id'] ?>"><?= sanitize($v['nombre']) ?></option>
      <?php endforeach; ?>
    </select>
  </div>
  <div class="col-md-4">
    <label class="tr-form-label">Límite de usos <span class="text-muted small">(vacío = sin límite)</span></label>
    <input type="number" name="limite_usos" id="edit-lim" class="form-control"
           min="1" placeholder="∞ sin límite"/>
  </div>
  <div class="col-md-4">
    <label class="tr-form-label">Monto mínimo de compra (S/)</label>
    <input type="number" name="monto_minimo" id="edit-min" class="form-control"
           step="0.01" min="0" placeholder="Sin mínimo"/>
  </div>
  <div class="col-md-4"></div>
  <div class="col-md-4">
    <label class="tr-form-label">Válido desde</label>
    <input type="date" name="fecha_inicio" id="edit-ini" class="form-control"/>
  </div>
  <div class="col-md-4">
    <label class="tr-form-label">Válido hasta</label>
    <input type="date" name="fecha_fin" id="edit-fin" class="form-control"/>
  </div>
</div>
