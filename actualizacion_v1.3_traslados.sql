-- =====================================================================
--  TechRepair Pro — Actualización v1.3
--  MÓDULO DE TRASLADOS DE PRODUCTOS ENTRE ALMACENES
-- =====================================================================
--  Cómo aplicar:
--    phpMyAdmin → base de datos `demorepair` → pestaña Importar
--    → seleccionar este archivo → Continuar
--
--  Es SEGURO ejecutarlo sobre una BD con datos: usa IF NOT EXISTS,
--  no borra nada y migra el stock actual al almacén "Tienda".
--  Se puede ejecutar más de una vez sin duplicar (idempotente).
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- 1) ALMACENES
--    `principal = 1` marca el almacén cuyo stock está sincronizado con
--    productos.stock_actual (el que ya usa POS / ventas / OT / compras).
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `almacenes` (
  `id`         int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo`     varchar(20)  NOT NULL,
  `nombre`     varchar(100) NOT NULL,
  `tipo`       enum('tienda','almacen','deposito') NOT NULL DEFAULT 'almacen',
  `direccion`  varchar(255) DEFAULT NULL,
  `principal`  tinyint(1)   NOT NULL DEFAULT 0 COMMENT 'Sincronizado con productos.stock_actual',
  `activo`     tinyint(1)   NOT NULL DEFAULT 1,
  `created_at` datetime     NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime     NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Almacenes por defecto: Tienda (principal) y Almacén 1
INSERT INTO `almacenes` (`codigo`,`nombre`,`tipo`,`principal`,`activo`)
SELECT 'TIE','Tienda','tienda',1,1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `almacenes` WHERE `codigo`='TIE');

INSERT INTO `almacenes` (`codigo`,`nombre`,`tipo`,`principal`,`activo`)
SELECT 'ALM1','Almacén 1','almacen',0,1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `almacenes` WHERE `codigo`='ALM1');

-- ---------------------------------------------------------------------
-- 2) STOCK POR ALMACÉN
--    Cantidad de cada producto en cada almacén.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `stock_almacen` (
  `id`           int(10) unsigned NOT NULL AUTO_INCREMENT,
  `almacen_id`   int(10) unsigned NOT NULL,
  `producto_id`  int(10) unsigned NOT NULL,
  `cantidad`     decimal(10,2) NOT NULL DEFAULT 0.00,
  `updated_at`   datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_alm_prod` (`almacen_id`,`producto_id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `fk_sa_almacen`  FOREIGN KEY (`almacen_id`)  REFERENCES `almacenes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sa_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migrar el stock actual de TODOS los productos al almacén principal (Tienda).
-- Solo inserta los que aún no tengan registro, así no pisa datos si se re-ejecuta.
INSERT INTO `stock_almacen` (`almacen_id`,`producto_id`,`cantidad`)
SELECT a.id, p.id, p.stock_actual
FROM `productos` p
CROSS JOIN `almacenes` a
WHERE a.principal = 1
  AND NOT EXISTS (
    SELECT 1 FROM `stock_almacen` sa
    WHERE sa.almacen_id = a.id AND sa.producto_id = p.id
  );

-- Crear filas en 0 para el Almacén 1 (para que aparezcan todos los productos).
INSERT INTO `stock_almacen` (`almacen_id`,`producto_id`,`cantidad`)
SELECT a.id, p.id, 0
FROM `productos` p
CROSS JOIN `almacenes` a
WHERE a.codigo = 'ALM1'
  AND NOT EXISTS (
    SELECT 1 FROM `stock_almacen` sa
    WHERE sa.almacen_id = a.id AND sa.producto_id = p.id
  );

-- ---------------------------------------------------------------------
-- 3) TRASLADOS (cabecera)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `traslados` (
  `id`             int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo`         varchar(30) NOT NULL,
  `almacen_origen` int(10) unsigned NOT NULL,
  `almacen_destino`int(10) unsigned NOT NULL,
  `estado`         enum('borrador','en_transito','recibido','anulado') NOT NULL DEFAULT 'recibido',
  `observacion`    varchar(500) DEFAULT NULL,
  `usuario_id`     int(10) unsigned NOT NULL,
  `usuario_recibe` int(10) unsigned DEFAULT NULL,
  `total_items`    int(10) unsigned NOT NULL DEFAULT 0,
  `total_unidades` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at`     datetime NOT NULL DEFAULT current_timestamp(),
  `recibido_at`    datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_origen` (`almacen_origen`),
  KEY `idx_destino` (`almacen_destino`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `fk_tr_origen`  FOREIGN KEY (`almacen_origen`)  REFERENCES `almacenes` (`id`),
  CONSTRAINT `fk_tr_destino` FOREIGN KEY (`almacen_destino`) REFERENCES `almacenes` (`id`),
  CONSTRAINT `fk_tr_usuario` FOREIGN KEY (`usuario_id`)      REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 4) TRASLADO_DETALLE (líneas)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `traslado_detalle` (
  `id`           int(10) unsigned NOT NULL AUTO_INCREMENT,
  `traslado_id`  int(10) unsigned NOT NULL,
  `producto_id`  int(10) unsigned NOT NULL,
  `cantidad`     decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_traslado` (`traslado_id`),
  KEY `idx_producto` (`producto_id`),
  CONSTRAINT `fk_td_traslado` FOREIGN KEY (`traslado_id`) REFERENCES `traslados` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_td_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 5) KARDEX: ampliar tipos para registrar traslados, y guardar almacén.
--    La columna almacen_id es NULL para movimientos antiguos (compatibilidad).
-- ---------------------------------------------------------------------
ALTER TABLE `kardex`
  MODIFY COLUMN `tipo`
  enum('entrada','salida','ajuste','devolucion','traslado_salida','traslado_entrada') NOT NULL;

-- Agregar columna almacen_id al kardex si no existe.
SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'kardex'
    AND COLUMN_NAME = 'almacen_id'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE `kardex` ADD COLUMN `almacen_id` int(10) unsigned DEFAULT NULL COMMENT ''Almacén donde ocurre el movimiento'' AFTER `producto_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
--  FIN — La instalación quedó lista. Recargar el sistema.
-- =====================================================================
