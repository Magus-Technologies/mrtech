-- 005_usuario_almacen.sql
-- Assigns each user/vendedor to a specific almacén (store/warehouse).
-- When a vendedor sells in the POS, stock exits from their assigned almacén.
-- Users without an almacén (NULL) fall back to the principal almacén.

ALTER TABLE usuarios
  ADD COLUMN almacen_id INT UNSIGNED NULL DEFAULT NULL AFTER rol;

ALTER TABLE usuarios
  ADD CONSTRAINT fk_usuario_almacen
  FOREIGN KEY (almacen_id) REFERENCES almacenes(id) ON DELETE SET NULL;
