-- Migration: 003_notas_aplica_igv
-- Agrega columna aplica_igv a notas_credito para guardar el estado IGV
-- exactamente como estaba en el comprobante original.

ALTER TABLE notas_credito
    ADD COLUMN aplica_igv TINYINT(1) NOT NULL DEFAULT 1 AFTER total;
