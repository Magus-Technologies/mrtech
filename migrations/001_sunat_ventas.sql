-- Migration: 001_sunat_ventas
-- Adds SUNAT columns to ventas and seeds configuracion with billing keys.
-- Run locally first, then on production.

ALTER TABLE ventas
    ADD COLUMN sunat_estado   ENUM('pendiente','aceptado','rechazado') NULL DEFAULT NULL,
    ADD COLUMN sunat_xml      LONGTEXT NULL,
    ADD COLUMN sunat_cdr      LONGTEXT NULL,
    ADD COLUMN sunat_hash     VARCHAR(100) NULL,
    ADD COLUMN sunat_qr       TEXT NULL,
    ADD COLUMN sunat_mensaje  VARCHAR(1000) NULL,
    ADD COLUMN sunat_fecha    DATETIME NULL;

-- SUNAT credentials and series (fill in real values before running on production)
INSERT IGNORE INTO configuracion (clave, valor) VALUES
    ('sunat_usuario_sol', 'MODDATOS'),
    ('sunat_clave_sol',   'MODDATOS'),
    ('sunat_modo',        'beta'),
    ('sunat_ubigeo',      '150143'),
    ('sunat_distrito',    'VILLA MARIA DEL TRIUNFO'),
    ('sunat_provincia',   'LIMA'),
    ('sunat_departamento','LIMA'),
    ('serie_boleta',      'B001'),
    ('serie_factura',     'F001');
