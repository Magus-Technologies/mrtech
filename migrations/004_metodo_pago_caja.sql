-- Migration: 004_metodo_pago_caja
-- Agrega el método de pago a los movimientos de caja para que el cierre del día
-- distingue entre efectivo, yape, plin, tarjeta y transferencia.
-- Antes, TODO ingreso/egreso se asumía efectivo, por lo que los pagos por Yape de
-- reparaciones inflaban el efectivo esperado y generaban diferencias falsas.

ALTER TABLE `movimientos_caja`
    ADD COLUMN `metodo_pago` ENUM('efectivo','yape','plin','tarjeta','transferencia')
        CHARACTER SET latin1 COLLATE latin1_swedish_ci
        NOT NULL DEFAULT 'efectivo' AFTER `referencia`;

-- ── Backfill: pagos de reparación toman el método real de la OT ──
UPDATE `movimientos_caja` mc
JOIN `ordenes_trabajo` ot ON ot.codigo_ot = mc.referencia
SET mc.metodo_pago = ot.metodo_pago
WHERE mc.tipo = 'ingreso'
  AND mc.concepto LIKE 'Pago reparación%'
  AND ot.metodo_pago IS NOT NULL;

-- ── Backfill: ventas según la etiqueta del concepto "Venta ... (Método)" ──
UPDATE `movimientos_caja` SET metodo_pago = 'yape'          WHERE concepto LIKE '%(Yape)%';
UPDATE `movimientos_caja` SET metodo_pago = 'plin'          WHERE concepto LIKE '%(Plin)%';
UPDATE `movimientos_caja` SET metodo_pago = 'tarjeta'       WHERE concepto LIKE '%(Tarjeta)%';
UPDATE `movimientos_caja` SET metodo_pago = 'transferencia' WHERE concepto LIKE '%(Transferencia)%';
UPDATE `movimientos_caja` SET metodo_pago = 'efectivo'      WHERE concepto LIKE '%(Efectivo)%';
