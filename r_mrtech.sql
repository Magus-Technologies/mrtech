/*
 Navicat Premium Dump SQL

 Source Server         : ecommerce
 Source Server Type    : MySQL
 Source Server Version : 100527 (10.5.27-MariaDB)
 Source Host           : 173.249.36.119:3306
 Source Schema         : r_mrtech

 Target Server Type    : MySQL
 Target Server Version : 100527 (10.5.27-MariaDB)
 File Encoding         : 65001

 Date: 12/06/2026 18:46:53
*/
create database if not exists `r_mrtech` default character set utf8mb4 collate utf8mb4_general_ci;
use `r_mrtech`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for almacenes
-- ----------------------------
DROP TABLE IF EXISTS `almacenes`;
CREATE TABLE `almacenes`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('tienda','almacen','deposito') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'almacen',
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `principal` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Sincronizado con productos.stock_actual',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of almacenes
-- ----------------------------
INSERT INTO `almacenes` VALUES (1, 'TIE', 'Tienda', 'tienda', NULL, 1, 1, '2026-05-26 21:34:23', '2026-05-26 21:34:23');
INSERT INTO `almacenes` VALUES (2, 'ALM1', 'Almacén 1', 'almacen', NULL, 0, 1, '2026-05-26 21:34:23', '2026-05-26 21:34:23');

-- ----------------------------
-- Table structure for cajas
-- ----------------------------
DROP TABLE IF EXISTS `cajas`;
CREATE TABLE `cajas`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` int UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `saldo_inicial` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `total_ingresos` decimal(10, 2) NULL DEFAULT 0.00,
  `total_egresos` decimal(10, 2) NULL DEFAULT 0.00,
  `saldo_final` decimal(10, 2) NULL DEFAULT 0.00,
  `estado` enum('abierta','cerrada') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'abierta',
  `observaciones` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `fecha_cierre` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `denominaciones_apertura` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `denominaciones_cierre` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `diferencia_cierre` decimal(10, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_fecha_usuario`(`fecha` ASC, `usuario_id` ASC) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  CONSTRAINT `cajas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cajas
-- ----------------------------
INSERT INTO `cajas` VALUES (5, 1, '2026-06-07', 0.00, 65.00, 0.00, 0.00, 'cerrada', NULL, '2026-06-11 09:33:12', '2026-06-07 17:51:06', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -65.00);

-- ----------------------------
-- Table structure for catalogo_banners
-- ----------------------------
DROP TABLE IF EXISTS `catalogo_banners`;
CREATE TABLE `catalogo_banners`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `subtitulo` varchar(300) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `imagen` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `url_link` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `orden` int NULL DEFAULT 0,
  `activo` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of catalogo_banners
-- ----------------------------

-- ----------------------------
-- Table structure for categorias
-- ----------------------------
DROP TABLE IF EXISTS `categorias`;
CREATE TABLE `categorias`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tipo` varchar(60) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'repuesto',
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 87 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categorias
-- ----------------------------
INSERT INTO `categorias` VALUES (1, 'Pantallas / Displays', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (2, 'Baterías', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (3, 'Teclados laptop', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (4, 'Placas madre', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (5, 'Fuentes de poder', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (6, 'Discos SSD', 'hardware', NULL, 1);
INSERT INTO `categorias` VALUES (7, 'Discos HDD', 'hardware', NULL, 1);
INSERT INTO `categorias` VALUES (8, 'Memorias RAM', 'hardware', NULL, 1);
INSERT INTO `categorias` VALUES (9, 'Procesadores', 'hardware', NULL, 1);
INSERT INTO `categorias` VALUES (10, 'Tarjetas de video', 'hardware', NULL, 1);
INSERT INTO `categorias` VALUES (11, 'Mouse', 'ofimatica', NULL, 1);
INSERT INTO `categorias` VALUES (12, 'Teclados', 'ofimatica', NULL, 1);
INSERT INTO `categorias` VALUES (13, 'Cables y adaptadores', 'accesorio', NULL, 1);
INSERT INTO `categorias` VALUES (14, 'Audífonos / Headsets', 'accesorio', NULL, 1);
INSERT INTO `categorias` VALUES (15, 'Antivirus / Licencias', 'software', NULL, 1);
INSERT INTO `categorias` VALUES (16, 'Pads térmicos / Pasta', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (17, 'Ventiladores / Coolers', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (18, 'BATERIAS LAPTOP', 'repuesto', 'HOLA', 1);
INSERT INTO `categorias` VALUES (19, 'HP', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (20, 'Hardware', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (21, 'GENERICO', 'generico', 'SERVICIO VARIOS', 1);
INSERT INTO `categorias` VALUES (22, 'Otro', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (23, 'CARCASA', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (24, 'ABCUB012', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (25, 'ABFXU', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (26, 'ASR31', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (27, 'AVDR02', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (28, 'CBRMATC', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (29, 'CBTPV3', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (30, 'CBVATC', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (31, 'CH90360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (32, 'CMG10', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (33, 'CPSJ2CORE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (34, 'CRDWTC5A', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (35, 'CRDWV8', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (36, 'CRRDV875W', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (37, 'CRTYV8', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (38, 'CSA02R', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (39, 'CSA02S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (40, 'CSA03', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (41, 'CSA03S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (42, 'CSA04S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (43, 'CSA05S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (44, 'CSA06', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (45, 'CSA10360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (46, 'CSA11D', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (47, 'CSA12360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (48, 'CSA16360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (49, 'CSA20S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (50, 'CSA21S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (51, 'CSA224G', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (52, 'CSA224G360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (53, 'CSA23', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (54, 'CSA25', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (55, 'CSA26360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (56, 'CSA30S', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (57, 'CSA31', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (58, 'CSA32', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (59, 'CSA33', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (60, 'CSA34', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (61, 'CSA36360', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (62, 'CSA51', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (63, 'CSA52', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (64, 'ACCESORIOS', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (65, 'AUDIFONO CON CABLE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (66, 'CABLE AUX', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (67, 'CABLE V3', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (68, 'CAMARA', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (69, 'CARGADOR TIPO C', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (70, 'CARGADOR TIPO V8', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (71, 'CABLE TIPO V8', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (72, 'CABLE IPHONE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (73, 'FLEX CONECTOR', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (74, 'PANTALLA', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (75, 'LENTE DE CAMARA', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (76, 'MICA COMPLETA', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (77, 'MICA SIMPLE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (78, 'OTG', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (79, 'BOTON INTERNO', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (80, 'CABEZA CARGADOR', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (81, 'CARGADOR TIPO IPHONE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (82, 'CABLE USB A IPHONE', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (83, 'CABLE USB A TC', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (84, 'ZOCALO TIPO V8', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (85, 'ZOCALO TIPO C', 'repuesto', NULL, 1);
INSERT INTO `categorias` VALUES (86, 'ZOCALO V3', 'repuesto', NULL, 1);

-- ----------------------------
-- Table structure for categorias_tipos
-- ----------------------------
DROP TABLE IF EXISTS `categorias_tipos`;
CREATE TABLE `categorias_tipos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `orden` int NULL DEFAULT 0,
  `activo` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `nombre`(`nombre` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categorias_tipos
-- ----------------------------
INSERT INTO `categorias_tipos` VALUES (1, 'repuesto', 1, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (2, 'hardware', 2, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (3, 'ofimatica', 3, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (4, 'accesorio', 4, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (5, 'software', 5, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (6, 'servicio', 6, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (7, 'otro', 7, 1, '2026-05-13 07:02:37');
INSERT INTO `categorias_tipos` VALUES (8, 'generico', 8, 1, '2026-06-07 10:27:19');

-- ----------------------------
-- Table structure for checklist_items
-- ----------------------------
DROP TABLE IF EXISTS `checklist_items`;
CREATE TABLE `checklist_items`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `activo` tinyint(1) NULL DEFAULT 1,
  `orden` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checklist_items
-- ----------------------------

-- ----------------------------
-- Table structure for clientes
-- ----------------------------
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'CLI-0001',
  `tipo` enum('persona','empresa') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'persona',
  `nombre` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ruc_dni` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `whatsapp` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `direccion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `distrito` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `segmento` enum('nuevo','frecuente','empresa','vip') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'nuevo',
  `notas` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `idx_ruc_dni`(`ruc_dni` ASC) USING BTREE,
  INDEX `idx_telefono`(`telefono` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 598 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clientes
-- ----------------------------
INSERT INTO `clientes` VALUES (597, 'CLI-0001', 'persona', 'JAMESSON RAUL SAENZ PAJUELO', '40578849', '', '957357537', '957357537', 'JR PACHCUTEC 2890', 'VILLA MARIA DEL TRIUNFO', 'nuevo', '', 1, '2026-06-07 09:44:17', '2026-06-07 09:44:17');

-- ----------------------------
-- Table structure for codigos_descuento
-- ----------------------------
DROP TABLE IF EXISTS `codigos_descuento`;
CREATE TABLE `codigos_descuento`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `tipo` enum('porcentaje','monto_fijo') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'porcentaje',
  `valor` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `vendedor_id` int UNSIGNED NULL DEFAULT NULL,
  `limite_usos` int UNSIGNED NULL DEFAULT NULL,
  `usos_actuales` int UNSIGNED NOT NULL DEFAULT 0,
  `monto_minimo` decimal(10, 2) NULL DEFAULT NULL,
  `fecha_inicio` date NULL DEFAULT NULL,
  `fecha_fin` date NULL DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_por` int UNSIGNED NOT NULL,
  `created_at` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `idx_vendedor`(`vendedor_id` ASC) USING BTREE,
  INDEX `idx_creado_por`(`creado_por` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of codigos_descuento
-- ----------------------------

-- ----------------------------
-- Table structure for compra_detalle
-- ----------------------------
DROP TABLE IF EXISTS `compra_detalle`;
CREATE TABLE `compra_detalle`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `compra_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  `precio_unit` decimal(10, 2) NOT NULL,
  `subtotal` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `compra_id`(`compra_id` ASC) USING BTREE,
  INDEX `producto_id`(`producto_id` ASC) USING BTREE,
  CONSTRAINT `compra_detalle_ibfk_1` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `compra_detalle_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compra_detalle
-- ----------------------------

-- ----------------------------
-- Table structure for compras
-- ----------------------------
DROP TABLE IF EXISTS `compras`;
CREATE TABLE `compras`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `proveedor` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `tipo_doc` enum('factura','boleta','guia','sin_doc') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'factura',
  `nro_doc` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `total` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `metodo_pago` enum('efectivo','transferencia','tarjeta','credito') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'efectivo',
  `notas` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `usuario_id` int UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of compras
-- ----------------------------

-- ----------------------------
-- Table structure for configuracion
-- ----------------------------
DROP TABLE IF EXISTS `configuracion`;
CREATE TABLE `configuracion`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `valor` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `tipo` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'texto',
  `grupo` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'general',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `clave`(`clave` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of configuracion
-- ----------------------------
INSERT INTO `configuracion` VALUES (1, 'empresa_nombre', 'Mr tech', 'texto', 'empresa');
INSERT INTO `configuracion` VALUES (2, 'empresa_ruc', '10405788492', 'texto', 'empresa');
INSERT INTO `configuracion` VALUES (3, 'empresa_direccion', 'AV. Pachacutec 2890 CC. Plaza Micaela Tda D30 VILLA MARIA DEL TRIUNFO Lima, Perú', 'texto', 'empresa');
INSERT INTO `configuracion` VALUES (4, 'empresa_telefono', '922364303', 'texto', 'empresa');
INSERT INTO `configuracion` VALUES (5, 'empresa_email', '', 'texto', 'empresa');
INSERT INTO `configuracion` VALUES (6, 'empresa_logo', '', 'imagen', 'empresa');
INSERT INTO `configuracion` VALUES (7, 'igv_porcentaje', '18', 'numero', 'facturacion');
INSERT INTO `configuracion` VALUES (8, 'garantia_defecto_dias', '30', 'numero', 'reparaciones');
INSERT INTO `configuracion` VALUES (9, 'whatsapp_api_token', '', 'texto', 'notificaciones');
INSERT INTO `configuracion` VALUES (10, 'whatsapp_phone_id', '', 'texto', 'notificaciones');
INSERT INTO `configuracion` VALUES (11, 'smtp_host', '', 'texto', 'email');
INSERT INTO `configuracion` VALUES (12, 'smtp_user', 'admin@techrepair.com', 'texto', 'email');
INSERT INTO `configuracion` VALUES (13, 'smtp_pass', 'demo5060', 'texto', 'email');
INSERT INTO `configuracion` VALUES (14, 'smtp_port', '587', 'numero', 'email');
INSERT INTO `configuracion` VALUES (15, 'moneda', 'PEN', 'texto', 'general');
INSERT INTO `configuracion` VALUES (16, 'moneda_simbolo', 'S/', 'texto', 'general');
INSERT INTO `configuracion` VALUES (17, 'catalogo_nombre', 'Catálogo', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (18, 'catalogo_whatsapp', '51972781904', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (19, 'catalogo_mensaje_wa', 'Hola, me interesa el producto: {producto} (S/ {precio}). ¿Está disponible?', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (20, 'catalogo_color_primario', '#0d9488', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (21, 'catalogo_mostrar_precio', '1', 'numero', 'catalogo');
INSERT INTO `configuracion` VALUES (22, 'catalogo_productos_por_pagina', '12', 'numero', 'catalogo');
INSERT INTO `configuracion` VALUES (23, 'print_logo', 'logos/logo_empresa.png', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (24, 'print_mostrar_logo', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (25, 'print_mostrar_qr', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (26, 'print_cabecera', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (27, 'print_cuentas', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (28, 'print_msg_inferior', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (29, 'print_despedida', '¡Gracias por su preferencia!', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (30, 'print_mostrar_cabecera', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (31, 'print_mostrar_inferior', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (32, 'print_mostrar_despedida', '1', 'numero', 'impresion');

-- ----------------------------
-- Table structure for equipos
-- ----------------------------
DROP TABLE IF EXISTS `equipos`;
CREATE TABLE `equipos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_equipo_id` int UNSIGNED NOT NULL,
  `cliente_id` int UNSIGNED NOT NULL,
  `marca` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `modelo` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `serial` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `color` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tipo_equipo_id`(`tipo_equipo_id` ASC) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  INDEX `idx_serial`(`serial` ASC) USING BTREE,
  CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`tipo_equipo_id`) REFERENCES `tipos_equipo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `equipos_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1080 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipos
-- ----------------------------
INSERT INTO `equipos` VALUES (1077, 7, 597, 'HONOR', '200', '1234574578686', 'NT', '', '2026-06-07 17:44:14');
INSERT INTO `equipos` VALUES (1078, 7, 597, 'HONOR', '2010', '', '', '', '2026-06-07 17:58:04');
INSERT INTO `equipos` VALUES (1079, 7, 597, 'HONOR', '200', '', '', '', '2026-06-07 17:59:19');

-- ----------------------------
-- Table structure for estados_ot
-- ----------------------------
DROP TABLE IF EXISTS `estados_ot`;
CREATE TABLE `estados_ot`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `clave` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'clave_interna sin espacios',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Texto visible',
  `color` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'secondary' COMMENT 'Bootstrap color',
  `icono` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'circle',
  `orden` int NOT NULL DEFAULT 0,
  `es_final` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1=no permite más cambios',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `clave`(`clave` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of estados_ot
-- ----------------------------
INSERT INTO `estados_ot` VALUES (1, 'ingresado', 'RECIBIDO', 'warning', 'star', 1, 0, 1, '2026-05-05 20:14:56');
INSERT INTO `estados_ot` VALUES (4, 'listo', 'CONFIRMADO', 'success', 'check-circle', 4, 0, 1, '2026-05-05 20:14:56');
INSERT INTO `estados_ot` VALUES (5, 'entregado', 'ENTREGADO', 'primary', 'package', 9, 0, 1, '2026-05-05 20:14:56');
INSERT INTO `estados_ot` VALUES (6, 'cancelado', 'CLIENTE AVISADO', 'danger', 'x-circle', 8, 0, 1, '2026-05-05 20:14:56');
INSERT INTO `estados_ot` VALUES (7, 'en_espera_repuesto', 'ESPERANDO REPUESTO', 'secondary', 'clock', 5, 0, 1, '2026-05-05 23:10:45');
INSERT INTO `estados_ot` VALUES (8, 'control_calidad', 'CONTROL CALIDAD Y DETAILING', 'secondary', 'shield', 7, 0, 1, '2026-05-05 23:11:59');
INSERT INTO `estados_ot` VALUES (9, 'en_mesa', 'EN MESA DE TRABAJO', 'secondary', 'tool', 2, 0, 1, '2026-05-05 23:12:58');
INSERT INTO `estados_ot` VALUES (12, 'diagnosticado', 'DIAGNOSTICADO', 'info', 'inbox', 3, 0, 1, '2026-05-05 23:16:33');
INSERT INTO `estados_ot` VALUES (13, 'testeado', 'TESTEADO', 'warning', 'inbox', 6, 0, 1, '2026-05-05 23:17:45');
INSERT INTO `estados_ot` VALUES (14, 'en_revision', 'En revisión', 'info', 'search', 2, 0, 1, '2026-05-12 21:20:42');
INSERT INTO `estados_ot` VALUES (15, 'en_reparacion', 'En reparación', 'warning', 'tool', 3, 0, 1, '2026-05-12 21:20:42');

-- ----------------------------
-- Table structure for fotos_ot
-- ----------------------------
DROP TABLE IF EXISTS `fotos_ot`;
CREATE TABLE `fotos_ot`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ot_id` int UNSIGNED NULL DEFAULT NULL,
  `ruta` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tipo_archivo` enum('foto','video') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'foto',
  `duracion_seg` int NULL DEFAULT NULL,
  `tamano_bytes` int UNSIGNED NULL DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `tipo` enum('ingreso','proceso','entrega') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'ingreso',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ot_id`(`ot_id` ASC) USING BTREE,
  CONSTRAINT `fotos_ot_ibfk_1` FOREIGN KEY (`ot_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fotos_ot
-- ----------------------------

-- ----------------------------
-- Table structure for garantias
-- ----------------------------
DROP TABLE IF EXISTS `garantias`;
CREATE TABLE `garantias`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo` enum('reparacion','producto') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `referencia_id` int UNSIGNED NOT NULL COMMENT 'ot_id o venta_id',
  `cliente_id` int UNSIGNED NOT NULL,
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_vence` date NOT NULL,
  `estado` enum('vigente','vencida','reclamada') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'vigente',
  `notas` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  CONSTRAINT `garantias_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of garantias
-- ----------------------------

-- ----------------------------
-- Table structure for historial_ot
-- ----------------------------
DROP TABLE IF EXISTS `historial_ot`;
CREATE TABLE `historial_ot`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ot_id` int UNSIGNED NOT NULL,
  `usuario_id` int UNSIGNED NOT NULL,
  `estado_antes` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `estado_nuevo` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `comentario` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ot_id`(`ot_id` ASC) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  CONSTRAINT `historial_ot_ibfk_1` FOREIGN KEY (`ot_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `historial_ot_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of historial_ot
-- ----------------------------
INSERT INTO `historial_ot` VALUES (62, 1070, 4, NULL, 'ingresado', 'OT creada', '2026-06-07 17:44:14');
INSERT INTO `historial_ot` VALUES (63, 1070, 4, 'ingresado', 'en_mesa', 'DESARMADO SIN DETALLES', '2026-06-07 17:44:53');
INSERT INTO `historial_ot` VALUES (64, 1070, 4, 'en_mesa', 'entregado', '', '2026-06-07 17:45:11');
INSERT INTO `historial_ot` VALUES (65, 1071, 4, NULL, 'ingresado', 'OT creada', '2026-06-07 17:58:04');
INSERT INTO `historial_ot` VALUES (66, 1072, 4, NULL, 'ingresado', 'OT creada', '2026-06-07 17:59:19');
INSERT INTO `historial_ot` VALUES (67, 1072, 4, 'ingresado', 'en_espera_repuesto', '', '2026-06-07 18:01:29');
INSERT INTO `historial_ot` VALUES (68, 1072, 4, 'en_espera_repuesto', 'diagnosticado', 'SE ENCONTRO PANTALLA MALOGRADA , SE RECOMIENDA CAMBIO', '2026-06-07 18:04:44');

-- ----------------------------
-- Table structure for kardex
-- ----------------------------
DROP TABLE IF EXISTS `kardex`;
CREATE TABLE `kardex`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `producto_id` int UNSIGNED NOT NULL,
  `almacen_id` int UNSIGNED NULL DEFAULT NULL COMMENT 'Almacén donde ocurre el movimiento',
  `tipo` enum('entrada','salida','ajuste','devolucion','traslado_salida','traslado_entrada') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  `stock_antes` decimal(10, 2) NOT NULL,
  `stock_despues` decimal(10, 2) NOT NULL,
  `precio_unit` decimal(10, 2) NULL DEFAULT 0.00,
  `motivo` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `referencia` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'OT-2024-0001 o VTA-0001',
  `usuario_id` int UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  INDEX `idx_producto_fecha`(`producto_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `kardex_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `kardex_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 431 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kardex
-- ----------------------------
INSERT INTO `kardex` VALUES (14, 7, 1, 'entrada', 1000.00, 0.00, 1000.00, 1.00, 'Stock inicial', 'INICIO', 1, '2026-06-07 10:28:55');
INSERT INTO `kardex` VALUES (15, 7, 1, 'salida', 1.00, 1000.00, 999.00, 5.00, 'Venta', 'VTA-2026-0001', 4, '2026-06-07 10:36:49');
INSERT INTO `kardex` VALUES (16, 7, 1, 'salida', 1.00, 999.00, 998.00, 20.00, 'Venta', 'VTA-2026-0002', 4, '2026-06-07 10:40:29');
INSERT INTO `kardex` VALUES (17, 7, 1, 'salida', 1.00, 998.00, 997.00, 10.00, 'Venta', 'VTA-2026-0003', 4, '2026-06-07 10:42:47');
INSERT INTO `kardex` VALUES (18, 8, 1, 'entrada', 10.00, 0.00, 10.00, 120.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (19, 9, 1, 'entrada', 25.00, 0.00, 25.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (20, 10, 1, 'entrada', 2.00, 0.00, 2.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (21, 11, 1, 'entrada', 11.00, 0.00, 11.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (22, 12, 1, 'entrada', 23.00, 0.00, 23.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (23, 13, 1, 'entrada', 2.00, 0.00, 2.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (24, 14, 1, 'entrada', 2.00, 0.00, 2.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (25, 15, 1, 'entrada', 2.00, 0.00, 2.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (26, 16, 1, 'entrada', 12.00, 0.00, 12.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (27, 17, 1, 'entrada', 12.00, 0.00, 12.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (28, 18, 1, 'entrada', 15.00, 0.00, 15.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (29, 19, 1, 'entrada', 16.00, 0.00, 16.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (30, 20, 1, 'entrada', 3.00, 0.00, 3.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (31, 21, 1, 'entrada', 4.00, 0.00, 4.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (32, 22, 1, 'entrada', 7.00, 0.00, 7.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (33, 23, 1, 'entrada', 12.00, 0.00, 12.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (34, 24, 1, 'entrada', 3.00, 0.00, 3.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (35, 25, 1, 'entrada', 2.00, 0.00, 2.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (36, 26, 1, 'entrada', 2.00, 0.00, 2.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (37, 27, 1, 'entrada', 3.00, 0.00, 3.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (38, 28, 1, 'entrada', 3.00, 0.00, 3.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (39, 29, 1, 'entrada', 6.00, 0.00, 6.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (40, 30, 1, 'entrada', 4.00, 0.00, 4.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (41, 31, 1, 'entrada', 3.00, 0.00, 3.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (42, 32, 1, 'entrada', 4.00, 0.00, 4.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (43, 33, 1, 'entrada', 5.00, 0.00, 5.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (44, 34, 1, 'entrada', 4.00, 0.00, 4.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (45, 35, 1, 'entrada', 5.00, 0.00, 5.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (46, 36, 1, 'entrada', 2.00, 0.00, 2.00, 9.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (47, 37, 1, 'entrada', 5.00, 0.00, 5.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (48, 38, 1, 'entrada', 11.00, 0.00, 11.00, 13.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (49, 39, 1, 'entrada', 2.00, 0.00, 2.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (50, 40, 1, 'entrada', 2.00, 0.00, 2.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (51, 41, 1, 'entrada', 2.00, 0.00, 2.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (52, 42, 1, 'entrada', 13.00, 0.00, 13.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (53, 43, 1, 'entrada', 12.00, 0.00, 12.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (54, 44, 1, 'entrada', 13.00, 0.00, 13.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (55, 45, 1, 'entrada', 3.00, 0.00, 3.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 16:56:22');
INSERT INTO `kardex` VALUES (56, 46, 1, 'entrada', 10.00, 0.00, 10.00, 120.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 17:00:16');
INSERT INTO `kardex` VALUES (57, 47, 1, 'entrada', 25.00, 0.00, 25.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-07 17:00:16');
INSERT INTO `kardex` VALUES (58, 50, 1, 'entrada', 2.00, 0.00, 2.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (59, 51, 1, 'entrada', 1.00, 0.00, 1.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (60, 52, 1, 'entrada', 1.00, 0.00, 1.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (61, 53, 1, 'entrada', 1.00, 0.00, 1.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (62, 54, 1, 'entrada', 3.00, 0.00, 3.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (63, 55, 1, 'entrada', 4.00, 0.00, 4.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (64, 56, 1, 'entrada', 6.00, 0.00, 6.00, 5.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (65, 57, 1, 'entrada', 1.00, 0.00, 1.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (66, 58, 1, 'entrada', 3.00, 0.00, 3.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (67, 59, 1, 'entrada', 1.00, 0.00, 1.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (68, 60, 1, 'entrada', 10.00, 0.00, 10.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (69, 61, 1, 'entrada', 5.00, 0.00, 5.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (70, 62, 1, 'entrada', 2.00, 0.00, 2.00, 11.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (71, 63, 1, 'entrada', 1.00, 0.00, 1.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (72, 64, 1, 'entrada', 3.00, 0.00, 3.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (73, 65, 1, 'entrada', 5.00, 0.00, 5.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (74, 66, 1, 'entrada', 128.00, 0.00, 128.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (75, 67, 1, 'entrada', 1.00, 0.00, 1.00, 7.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (76, 68, 1, 'entrada', 1.00, 0.00, 1.00, 7.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (77, 69, 1, 'entrada', 1.00, 0.00, 1.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (78, 70, 1, 'entrada', 1.00, 0.00, 1.00, 20.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (79, 71, 1, 'entrada', 1.00, 0.00, 1.00, 7.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (80, 72, 1, 'entrada', 1.00, 0.00, 1.00, 7.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (81, 73, 1, 'entrada', 2.00, 0.00, 2.00, 34.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (82, 74, 1, 'entrada', 3.00, 0.00, 3.00, 45.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (83, 75, 1, 'entrada', 3.00, 0.00, 3.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (84, 76, 1, 'entrada', 3.00, 0.00, 3.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (85, 77, 1, 'entrada', 3.00, 0.00, 3.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (86, 78, 1, 'entrada', 2.00, 0.00, 2.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (87, 79, 1, 'entrada', 1.00, 0.00, 1.00, 45.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (88, 80, 1, 'entrada', 2.00, 0.00, 2.00, 38.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (89, 81, 1, 'entrada', 2.00, 0.00, 2.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (90, 82, 1, 'entrada', 1.00, 0.00, 1.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (91, 83, 1, 'entrada', 1.00, 0.00, 1.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (92, 84, 1, 'entrada', 1.00, 0.00, 1.00, 38.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (93, 85, 1, 'entrada', 1.00, 0.00, 1.00, 42.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (94, 86, 1, 'entrada', 7.00, 0.00, 7.00, 80.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (95, 87, 1, 'entrada', 1.00, 0.00, 1.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (96, 88, 1, 'entrada', 1.00, 0.00, 1.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (97, 89, 1, 'entrada', 1.00, 0.00, 1.00, 45.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (98, 90, 1, 'entrada', 2.00, 0.00, 2.00, 42.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (99, 91, 1, 'entrada', 1.00, 0.00, 1.00, 42.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (100, 92, 1, 'entrada', 2.00, 0.00, 2.00, 41.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (101, 93, 1, 'entrada', 3.00, 0.00, 3.00, 63.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (102, 94, 1, 'entrada', 4.00, 0.00, 4.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (103, 95, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (104, 96, 1, 'entrada', 6.00, 0.00, 6.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (105, 97, 1, 'entrada', 3.00, 0.00, 3.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (106, 98, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (107, 99, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (108, 100, 1, 'entrada', 6.00, 0.00, 6.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (109, 101, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (110, 102, 1, 'entrada', 1.00, 0.00, 1.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (111, 103, 1, 'entrada', 1.00, 0.00, 1.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (112, 104, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (113, 105, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (114, 106, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (115, 107, 1, 'entrada', 1.00, 0.00, 1.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (116, 108, 1, 'entrada', 5.00, 0.00, 5.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (117, 109, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (118, 110, 1, 'entrada', 5.00, 0.00, 5.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (119, 111, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (120, 112, 1, 'entrada', 2.00, 0.00, 2.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (121, 113, 1, 'entrada', 3.00, 0.00, 3.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (122, 114, 1, 'entrada', 4.00, 0.00, 4.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (123, 115, 1, 'entrada', 1.00, 0.00, 1.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (124, 116, 1, 'entrada', 2.00, 0.00, 2.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (125, 117, 1, 'entrada', 1.00, 0.00, 1.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (126, 118, 1, 'entrada', 2.00, 0.00, 2.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (127, 119, 1, 'entrada', 1.00, 0.00, 1.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (128, 120, 1, 'entrada', 14.00, 0.00, 14.00, 8.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (129, 121, 1, 'entrada', 2.00, 0.00, 2.00, 4.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (130, 122, 1, 'entrada', 8.00, 0.00, 8.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (131, 123, 1, 'entrada', 8.00, 0.00, 8.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (132, 124, 1, 'entrada', 2.00, 0.00, 2.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (133, 125, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (134, 126, 1, 'entrada', 7.00, 0.00, 7.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (135, 127, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (136, 128, 1, 'entrada', 2.00, 0.00, 2.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (137, 129, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (138, 130, 1, 'entrada', 13.00, 0.00, 13.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (139, 131, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (140, 132, 1, 'entrada', 4.00, 0.00, 4.00, 1.05, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (141, 133, 1, 'entrada', 19.00, 0.00, 19.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (142, 134, 1, 'entrada', 13.00, 0.00, 13.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (143, 135, 1, 'entrada', 6.00, 0.00, 6.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (144, 136, 1, 'entrada', 20.00, 0.00, 20.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (145, 137, 1, 'entrada', 17.00, 0.00, 17.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (146, 138, 1, 'entrada', 13.00, 0.00, 13.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (147, 139, 1, 'entrada', 4.00, 0.00, 4.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (148, 140, 1, 'entrada', 6.00, 0.00, 6.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (149, 141, 1, 'entrada', 13.00, 0.00, 13.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (150, 142, 1, 'entrada', 21.00, 0.00, 21.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (151, 143, 1, 'entrada', 5.00, 0.00, 5.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (152, 144, 1, 'entrada', 4.00, 0.00, 4.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (153, 145, 1, 'entrada', 2.00, 0.00, 2.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (154, 146, 1, 'entrada', 11.00, 0.00, 11.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (155, 147, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (156, 148, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (157, 149, 1, 'entrada', 19.00, 0.00, 19.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (158, 150, 1, 'entrada', 10.00, 0.00, 10.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (159, 151, 1, 'entrada', 22.00, 0.00, 22.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (160, 152, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (161, 153, 1, 'entrada', 16.00, 0.00, 16.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (162, 154, 1, 'entrada', 5.00, 0.00, 5.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (163, 155, 1, 'entrada', 10.00, 0.00, 10.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (164, 156, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (165, 157, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (166, 158, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (167, 159, 1, 'entrada', 6.00, 0.00, 6.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (168, 160, 1, 'entrada', 10.00, 0.00, 10.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (169, 161, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (170, 162, 1, 'entrada', 11.00, 0.00, 11.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (171, 163, 1, 'entrada', 1.00, 0.00, 1.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (172, 164, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (173, 165, 1, 'entrada', 9.00, 0.00, 9.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (174, 166, 1, 'entrada', 11.00, 0.00, 11.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (175, 167, 1, 'entrada', 8.00, 0.00, 8.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (176, 168, 1, 'entrada', 2.00, 0.00, 2.00, 1.30, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (177, 169, 1, 'entrada', 10.00, 0.00, 10.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (178, 170, 1, 'entrada', 1.00, 0.00, 1.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (179, 171, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (180, 172, 1, 'entrada', 4.00, 0.00, 4.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (181, 173, 1, 'entrada', 2.00, 0.00, 2.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (182, 174, 1, 'entrada', 12.00, 0.00, 12.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (183, 175, 1, 'entrada', 7.00, 0.00, 7.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (184, 176, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (185, 177, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (186, 178, 1, 'entrada', 4.00, 0.00, 4.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (187, 179, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (188, 180, 1, 'entrada', 2.00, 0.00, 2.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (189, 181, 1, 'entrada', 10.00, 0.00, 10.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (190, 182, 1, 'entrada', 12.00, 0.00, 12.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (191, 183, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (192, 184, 1, 'entrada', 8.00, 0.00, 8.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (193, 185, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (194, 186, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (195, 187, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (196, 188, 1, 'entrada', 16.00, 0.00, 16.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (197, 189, 1, 'entrada', 1.00, 0.00, 1.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (198, 190, 1, 'entrada', 2.00, 0.00, 2.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (199, 191, 1, 'entrada', 2.00, 0.00, 2.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (200, 192, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (201, 193, 1, 'entrada', 9.00, 0.00, 9.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (202, 194, 1, 'entrada', 5.00, 0.00, 5.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (203, 195, 1, 'entrada', 8.00, 0.00, 8.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (204, 196, 1, 'entrada', 19.00, 0.00, 19.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (205, 197, 1, 'entrada', 9.00, 0.00, 9.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (206, 198, 1, 'entrada', 2.00, 0.00, 2.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (207, 199, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (208, 200, 1, 'entrada', 13.00, 0.00, 13.00, 1.20, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (209, 201, 1, 'entrada', 4.00, 0.00, 4.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (210, 202, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (211, 203, 1, 'entrada', 4.00, 0.00, 4.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (212, 204, 1, 'entrada', 25.00, 0.00, 25.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (213, 205, 1, 'entrada', 12.00, 0.00, 12.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (214, 206, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (215, 207, 1, 'entrada', 2.00, 0.00, 2.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (216, 208, 1, 'entrada', 8.00, 0.00, 8.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (217, 209, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (218, 210, 1, 'entrada', 2.00, 0.00, 2.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (219, 211, 1, 'entrada', 14.00, 0.00, 14.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (220, 212, 1, 'entrada', 8.00, 0.00, 8.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (221, 213, 1, 'entrada', 11.00, 0.00, 11.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (222, 214, 1, 'entrada', 2.00, 0.00, 2.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (223, 215, 1, 'entrada', 16.00, 0.00, 16.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (224, 216, 1, 'entrada', 1.00, 0.00, 1.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (225, 217, 1, 'entrada', 9.00, 0.00, 9.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (226, 218, 1, 'entrada', 9.00, 0.00, 9.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (227, 219, 1, 'entrada', 7.00, 0.00, 7.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (228, 220, 1, 'entrada', 2.00, 0.00, 2.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (229, 221, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (230, 222, 1, 'entrada', 3.00, 0.00, 3.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (231, 223, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (232, 224, 1, 'entrada', 19.00, 0.00, 19.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (233, 225, 1, 'entrada', 3.00, 0.00, 3.00, 1.35, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (234, 226, 1, 'entrada', 18.00, 0.00, 18.00, 1.05, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (235, 227, 1, 'entrada', 1.00, 0.00, 1.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (236, 228, 1, 'entrada', 2.00, 0.00, 2.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (237, 229, 1, 'entrada', 2.00, 0.00, 2.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (238, 230, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (239, 231, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (240, 232, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (241, 233, 1, 'entrada', 2.00, 0.00, 2.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (242, 234, 1, 'entrada', 2.00, 0.00, 2.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (243, 235, 1, 'entrada', 7.00, 0.00, 7.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (244, 236, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (245, 237, 1, 'entrada', 2.00, 0.00, 2.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (246, 238, 1, 'entrada', 5.00, 0.00, 5.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (247, 239, 1, 'entrada', 5.00, 0.00, 5.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (248, 240, 1, 'entrada', 11.00, 0.00, 11.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (249, 241, 1, 'entrada', 10.00, 0.00, 10.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (250, 242, 1, 'entrada', 3.00, 0.00, 3.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (251, 243, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (252, 244, 1, 'entrada', 12.00, 0.00, 12.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (253, 245, 1, 'entrada', 6.00, 0.00, 6.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (254, 246, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (255, 247, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (256, 248, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (257, 249, 1, 'entrada', 3.00, 0.00, 3.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (258, 250, 1, 'entrada', 5.00, 0.00, 5.00, 0.83, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (259, 251, 1, 'entrada', 5.00, 0.00, 5.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (260, 252, 1, 'entrada', 5.00, 0.00, 5.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (261, 253, 1, 'entrada', 5.00, 0.00, 5.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (262, 254, 1, 'entrada', 6.00, 0.00, 6.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (263, 255, 1, 'entrada', 1.00, 0.00, 1.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (264, 256, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (265, 257, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (266, 258, 1, 'entrada', 1.00, 0.00, 1.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (267, 259, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (268, 260, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (269, 261, 1, 'entrada', 3.00, 0.00, 3.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (270, 262, 1, 'entrada', 2.00, 0.00, 2.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (271, 263, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (272, 264, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (273, 265, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (274, 266, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (275, 267, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (276, 268, 1, 'entrada', 2.00, 0.00, 2.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (277, 269, 1, 'entrada', 6.00, 0.00, 6.00, 0.83, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (278, 270, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (279, 271, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (280, 272, 1, 'entrada', 13.00, 0.00, 13.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (281, 273, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (282, 274, 1, 'entrada', 7.00, 0.00, 7.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (283, 275, 1, 'entrada', 5.00, 0.00, 5.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (284, 276, 1, 'entrada', 8.00, 0.00, 8.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (285, 277, 1, 'entrada', 5.00, 0.00, 5.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (286, 278, 1, 'entrada', 6.00, 0.00, 6.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (287, 279, 1, 'entrada', 5.00, 0.00, 5.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (288, 280, 1, 'entrada', 7.00, 0.00, 7.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (289, 281, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (290, 282, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (291, 283, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (292, 284, 1, 'entrada', 2.00, 0.00, 2.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (293, 285, 1, 'entrada', 2.00, 0.00, 2.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (294, 286, 1, 'entrada', 3.00, 0.00, 3.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (295, 287, 1, 'entrada', 1.00, 0.00, 1.00, 1.40, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (296, 288, 1, 'entrada', 4.00, 0.00, 4.00, 0.85, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (297, 289, 1, 'entrada', 3.00, 0.00, 3.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (298, 290, 1, 'entrada', 4.00, 0.00, 4.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (299, 291, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (300, 292, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (301, 293, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (302, 294, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (303, 295, 1, 'entrada', 3.00, 0.00, 3.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (304, 296, 1, 'entrada', 1.00, 0.00, 1.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (305, 297, 1, 'entrada', 1.00, 0.00, 1.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (306, 298, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (307, 299, 1, 'entrada', 1.00, 0.00, 1.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (308, 300, 1, 'entrada', 1.00, 0.00, 1.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (309, 301, 1, 'entrada', 2.00, 0.00, 2.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (310, 302, 1, 'entrada', 3.00, 0.00, 3.00, 0.90, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (311, 303, 1, 'entrada', 5.00, 0.00, 5.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (312, 304, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (313, 305, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (314, 306, 1, 'entrada', 3.00, 0.00, 3.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (315, 307, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (316, 308, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (317, 309, 1, 'entrada', 10.00, 0.00, 10.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (318, 310, 1, 'entrada', 11.00, 0.00, 11.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (319, 311, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (320, 312, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (321, 313, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (322, 314, 1, 'entrada', 8.00, 0.00, 8.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (323, 315, 1, 'entrada', 1.00, 0.00, 1.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (324, 316, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (325, 317, 1, 'entrada', 4.00, 0.00, 4.00, 0.72, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (326, 318, 1, 'entrada', 2.00, 0.00, 2.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (327, 319, 1, 'entrada', 4.00, 0.00, 4.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (328, 320, 1, 'entrada', 6.00, 0.00, 6.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (329, 321, 1, 'entrada', 5.00, 0.00, 5.00, 0.92, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (330, 322, 1, 'entrada', 9.00, 0.00, 9.00, 0.82, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (331, 323, 1, 'entrada', 2.00, 0.00, 2.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (332, 324, 1, 'entrada', 1.00, 0.00, 1.00, 45.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (333, 325, 1, 'entrada', 3.00, 0.00, 3.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (334, 326, 1, 'entrada', 2.00, 0.00, 2.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (335, 327, 1, 'entrada', 4.00, 0.00, 4.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (336, 328, 1, 'entrada', 3.00, 0.00, 3.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (337, 329, 1, 'entrada', 1.00, 0.00, 1.00, 90.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (338, 330, 1, 'entrada', 2.00, 0.00, 2.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (339, 331, 1, 'entrada', 1.00, 0.00, 1.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (340, 332, 1, 'entrada', 4.00, 0.00, 4.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (341, 333, 1, 'entrada', 1.00, 0.00, 1.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (342, 334, 1, 'entrada', 1.00, 0.00, 1.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (343, 335, 1, 'entrada', 3.00, 0.00, 3.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (344, 336, 1, 'entrada', 2.00, 0.00, 2.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (345, 337, 1, 'entrada', 2.00, 0.00, 2.00, 39.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (346, 338, 1, 'entrada', 3.00, 0.00, 3.00, 39.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (347, 339, 1, 'entrada', 2.00, 0.00, 2.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (348, 340, 1, 'entrada', 2.00, 0.00, 2.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (349, 341, 1, 'entrada', 2.00, 0.00, 2.00, 36.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (350, 342, 1, 'entrada', 3.00, 0.00, 3.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (351, 343, 1, 'entrada', 1.00, 0.00, 1.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (352, 344, 1, 'entrada', 2.00, 0.00, 2.00, 36.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (353, 345, 1, 'entrada', 3.00, 0.00, 3.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (354, 346, 1, 'entrada', 2.00, 0.00, 2.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (355, 347, 1, 'entrada', 3.00, 0.00, 3.00, 37.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (356, 348, 1, 'entrada', 1.00, 0.00, 1.00, 35.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (357, 349, 1, 'entrada', 2.00, 0.00, 2.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (358, 350, 1, 'entrada', 1.00, 0.00, 1.00, 38.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (359, 351, 1, 'entrada', 1.00, 0.00, 1.00, 3.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (360, 352, 1, 'entrada', 3.00, 0.00, 3.00, 40.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (361, 353, 1, 'entrada', 2.00, 0.00, 2.00, 38.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (362, 354, 1, 'entrada', 2.00, 0.00, 2.00, 39.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (363, 355, 1, 'entrada', 2.00, 0.00, 2.00, 44.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (364, 356, 1, 'entrada', 1.00, 0.00, 1.00, 45.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (365, 357, 1, 'entrada', 5.00, 0.00, 5.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (366, 358, 1, 'entrada', 2.00, 0.00, 2.00, 4.70, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (367, 359, 1, 'entrada', 4.00, 0.00, 4.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:27');
INSERT INTO `kardex` VALUES (368, 360, 1, 'entrada', 2.00, 0.00, 2.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (369, 361, 1, 'entrada', 4.00, 0.00, 4.00, 6.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (370, 362, 1, 'entrada', 4.00, 0.00, 4.00, 6.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (371, 363, 1, 'entrada', 1.00, 0.00, 1.00, 11.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (372, 364, 1, 'entrada', 2.00, 0.00, 2.00, 4.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (373, 365, 1, 'entrada', 6.00, 0.00, 6.00, 12.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (374, 366, 1, 'entrada', 1.00, 0.00, 1.00, 13.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (375, 367, 1, 'entrada', 7.00, 0.00, 7.00, 12.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (376, 368, 1, 'entrada', 5.00, 0.00, 5.00, 10.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (377, 369, 1, 'entrada', 2.00, 0.00, 2.00, 10.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (378, 370, 1, 'entrada', 2.00, 0.00, 2.00, 4.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (379, 371, 1, 'entrada', 4.00, 0.00, 4.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (380, 372, 1, 'entrada', 3.00, 0.00, 3.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (381, 373, 1, 'entrada', 9.00, 0.00, 9.00, 12.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (382, 374, 1, 'entrada', 1.00, 0.00, 1.00, 4.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (383, 375, 1, 'entrada', 5.00, 0.00, 5.00, 3.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (384, 376, 1, 'entrada', 7.00, 0.00, 7.00, 6.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (385, 377, 1, 'entrada', 93.00, 0.00, 93.00, 0.80, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (386, 378, 1, 'entrada', 89.00, 0.00, 89.00, 0.30, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (387, 379, 1, 'entrada', 61.00, 0.00, 61.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (388, 380, 1, 'entrada', 3.00, 0.00, 3.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (389, 381, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (390, 382, 1, 'entrada', 3.00, 0.00, 3.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (391, 383, 1, 'entrada', 3.00, 0.00, 3.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (392, 385, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (393, 386, 1, 'entrada', 142.00, 0.00, 142.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (394, 387, 1, 'entrada', 2.00, 0.00, 2.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (395, 388, 1, 'entrada', 2.00, 0.00, 2.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (396, 390, 1, 'entrada', 1.00, 0.00, 1.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (397, 391, 1, 'entrada', 2.00, 0.00, 2.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (398, 392, 1, 'entrada', 4.00, 0.00, 4.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (399, 394, 1, 'entrada', 84.00, 0.00, 84.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (400, 395, 1, 'entrada', 93.00, 0.00, 93.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (401, 396, 1, 'entrada', 2.00, 0.00, 2.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (402, 397, 1, 'entrada', 2.00, 0.00, 2.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (403, 398, 1, 'entrada', 1.00, 0.00, 1.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (404, 399, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (405, 402, 1, 'entrada', 2.00, 0.00, 2.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (406, 403, 1, 'entrada', 6.00, 0.00, 6.00, 5.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (407, 404, 1, 'entrada', 4.00, 0.00, 4.00, 2.00, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (408, 405, 1, 'entrada', 3.00, 0.00, 3.00, 2.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (409, 406, 1, 'entrada', 152.00, 0.00, 152.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (410, 407, 1, 'entrada', 7.00, 0.00, 7.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (411, 408, 1, 'entrada', 3.00, 0.00, 3.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (412, 409, 1, 'entrada', 9.00, 0.00, 9.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (413, 410, 1, 'entrada', 31.00, 0.00, 31.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (414, 411, 1, 'entrada', 5.00, 0.00, 5.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (415, 412, 1, 'entrada', 3.00, 0.00, 3.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (416, 413, 1, 'entrada', 12.00, 0.00, 12.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (417, 414, 1, 'entrada', 13.00, 0.00, 13.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (418, 415, 1, 'entrada', 75.00, 0.00, 75.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (419, 416, 1, 'entrada', 4.00, 0.00, 4.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (420, 417, 1, 'entrada', 1.00, 0.00, 1.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (421, 418, 1, 'entrada', 4.00, 0.00, 4.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (422, 419, 1, 'entrada', 7.00, 0.00, 7.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (423, 420, 1, 'entrada', 70.00, 0.00, 70.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (424, 421, 1, 'entrada', 7.00, 0.00, 7.00, 0.50, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (425, 422, 1, 'entrada', 3.00, 0.00, 3.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (426, 423, 1, 'entrada', 141.00, 0.00, 141.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (427, 424, 1, 'entrada', 75.00, 0.00, 75.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (428, 425, 1, 'entrada', 14.00, 0.00, 14.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (429, 427, 1, 'entrada', 8.00, 0.00, 8.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');
INSERT INTO `kardex` VALUES (430, 428, 1, 'entrada', 7.00, 0.00, 7.00, 0.60, 'Importación masiva', 'IMPORT', 1, '2026-06-12 11:37:28');

-- ----------------------------
-- Table structure for marcas_equipo
-- ----------------------------
DROP TABLE IF EXISTS `marcas_equipo`;
CREATE TABLE `marcas_equipo`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `activo` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `nombre`(`nombre` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marcas_equipo
-- ----------------------------
INSERT INTO `marcas_equipo` VALUES (20, 'Xiaomi', 1);
INSERT INTO `marcas_equipo` VALUES (41, 'Ninebot', 1);
INSERT INTO `marcas_equipo` VALUES (42, 'Kaabo', 1);
INSERT INTO `marcas_equipo` VALUES (43, 'Vsett', 1);
INSERT INTO `marcas_equipo` VALUES (44, 'Dualtron', 1);
INSERT INTO `marcas_equipo` VALUES (45, 'HONOR', 1);
INSERT INTO `marcas_equipo` VALUES (46, 'SAMSUNG', 1);
INSERT INTO `marcas_equipo` VALUES (47, 'ZTE', 1);

-- ----------------------------
-- Table structure for movimientos_caja
-- ----------------------------
DROP TABLE IF EXISTS `movimientos_caja`;
CREATE TABLE `movimientos_caja`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `caja_id` int UNSIGNED NOT NULL,
  `tipo` enum('ingreso','egreso') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `concepto` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `monto` decimal(10, 2) NOT NULL,
  `referencia` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `usuario_id` int UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `caja_id`(`caja_id` ASC) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  CONSTRAINT `movimientos_caja_ibfk_1` FOREIGN KEY (`caja_id`) REFERENCES `cajas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `movimientos_caja_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of movimientos_caja
-- ----------------------------
INSERT INTO `movimientos_caja` VALUES (5, 5, 'ingreso', 'Pago reparación OT-2026-0003', 65.00, 'OT-2026-0003', 4, '2026-06-07 18:00:02');

-- ----------------------------
-- Table structure for notificaciones
-- ----------------------------
DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE `notificaciones`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ot_id` int UNSIGNED NULL DEFAULT NULL,
  `cliente_id` int UNSIGNED NULL DEFAULT NULL,
  `tipo` enum('whatsapp','email','sistema') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `asunto` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `mensaje` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `estado` enum('pendiente','enviado','error') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'pendiente',
  `enviado_at` datetime NULL DEFAULT NULL,
  `error_msg` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ot_id`(`ot_id` ASC) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`ot_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `notificaciones_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notificaciones
-- ----------------------------

-- ----------------------------
-- Table structure for ordenes_trabajo
-- ----------------------------
DROP TABLE IF EXISTS `ordenes_trabajo`;
CREATE TABLE `ordenes_trabajo`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo_ot` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'OT-2024-0001',
  `codigo_publico` varchar(12) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Para consulta del cliente: ABC12345',
  `cliente_id` int UNSIGNED NOT NULL,
  `equipo_id` int UNSIGNED NOT NULL,
  `servicio_id` int UNSIGNED NULL DEFAULT NULL,
  `tecnico_id` int UNSIGNED NULL DEFAULT NULL,
  `usuario_creador_id` int UNSIGNED NOT NULL,
  `estado` varchar(60) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'ingresado',
  `problema_reportado` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Lo que dice el cliente',
  `diagnostico_inicial` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'Primera revisión del técnico',
  `diagnostico_tecnico` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'Diagnóstico detallado',
  `observaciones` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `checklist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT 'Estado físico del equipo al ingreso',
  `costo_diagnostico` decimal(10, 2) NULL DEFAULT 0.00,
  `costo_repuestos` decimal(10, 2) NULL DEFAULT 0.00,
  `costo_mano_obra` decimal(10, 2) NULL DEFAULT 0.00,
  `costo_total` decimal(10, 2) NULL DEFAULT 0.00,
  `descuento` decimal(10, 2) NULL DEFAULT 0.00,
  `precio_final` decimal(10, 2) NULL DEFAULT 0.00,
  `presupuesto_aprobado` tinyint(1) NULL DEFAULT 0,
  `aprobado_por` enum('firma','whatsapp','llamada','email') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'firma',
  `fecha_aprobacion` datetime NULL DEFAULT NULL,
  `firma_cliente` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'SVG base64 de la firma',
  `garantia_dias` int NULL DEFAULT 30,
  `garantia_vence` date NULL DEFAULT NULL,
  `fecha_ingreso` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_estimada` date NULL DEFAULT NULL,
  `fecha_entrega` datetime NULL DEFAULT NULL,
  `pagado` tinyint(1) NULL DEFAULT 0,
  `metodo_pago` enum('efectivo','yape','plin','tarjeta','transferencia') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `fecha_pago` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo_ot`(`codigo_ot` ASC) USING BTREE,
  UNIQUE INDEX `codigo_publico`(`codigo_publico` ASC) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  INDEX `equipo_id`(`equipo_id` ASC) USING BTREE,
  INDEX `tecnico_id`(`tecnico_id` ASC) USING BTREE,
  INDEX `usuario_creador_id`(`usuario_creador_id` ASC) USING BTREE,
  INDEX `idx_estado`(`estado` ASC) USING BTREE,
  INDEX `idx_codigo_publico`(`codigo_publico` ASC) USING BTREE,
  INDEX `idx_fecha_ingreso`(`fecha_ingreso` ASC) USING BTREE,
  INDEX `servicio_id`(`servicio_id` ASC) USING BTREE,
  CONSTRAINT `ordenes_trabajo_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ordenes_trabajo_ibfk_2` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ordenes_trabajo_ibfk_3` FOREIGN KEY (`tecnico_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ordenes_trabajo_ibfk_4` FOREIGN KEY (`usuario_creador_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1073 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordenes_trabajo
-- ----------------------------
INSERT INTO `ordenes_trabajo` VALUES (1070, 'OT-2026-0001', '715A463B', 597, 1077, 8, 5, 4, 'entregado', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 65.00, 10.00, 75.00, 0.00, 75.00, 1, 'whatsapp', '2026-06-07 17:50:33', NULL, 0, NULL, '2026-06-07 17:44:14', '2026-06-07', '2026-06-07 17:45:11', 1, 'efectivo', '2026-06-07 17:50:41', '2026-06-07 17:44:14', '2026-06-07 17:50:41');
INSERT INTO `ordenes_trabajo` VALUES (1071, 'OT-2026-0002', '820607BF', 597, 1078, 13, 5, 4, 'ingresado', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 30.00, 35.00, 65.00, 0.00, 65.00, 1, 'firma', '2026-06-07 17:58:14', NULL, 30, NULL, '2026-06-07 17:58:04', NULL, NULL, 0, NULL, NULL, '2026-06-07 17:58:04', '2026-06-07 17:58:14');
INSERT INTO `ordenes_trabajo` VALUES (1072, 'OT-2026-0003', '2501DE48', 597, 1079, 13, NULL, 4, 'diagnosticado', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 30.00, 35.00, 65.00, 0.00, 65.00, 1, 'whatsapp', '2026-06-07 17:59:48', NULL, 30, NULL, '2026-06-07 17:59:19', NULL, NULL, 1, 'efectivo', '2026-06-07 18:00:02', '2026-06-07 17:59:19', '2026-06-07 18:04:44');

-- ----------------------------
-- Table structure for ot_repuestos
-- ----------------------------
DROP TABLE IF EXISTS `ot_repuestos`;
CREATE TABLE `ot_repuestos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ot_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NULL DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL DEFAULT 1.00,
  `precio_unit` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(10, 2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ot_id`(`ot_id` ASC) USING BTREE,
  CONSTRAINT `ot_repuestos_ibfk_1` FOREIGN KEY (`ot_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1469 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ot_repuestos
-- ----------------------------
INSERT INTO `ot_repuestos` VALUES (1467, 1071, NULL, 'CARCASA SAMSUNG A12 360 [CSA12360]', 1.00, 30.00, 30.00);
INSERT INTO `ot_repuestos` VALUES (1468, 1072, NULL, 'CARCASA SAMSUNG A12 360 [CSA12360]', 1.00, 30.00, 30.00);

-- ----------------------------
-- Table structure for productos
-- ----------------------------
DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `nombre` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `categoria_id` int UNSIGNED NOT NULL,
  `marca` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `modelo` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `serial` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `ubicacion` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'Estante/fila/columna en almacén',
  `precio_costo` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `precio_venta` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `stock_actual` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `stock_minimo` decimal(10, 2) NOT NULL DEFAULT 1.00,
  `stock_maximo` decimal(10, 2) NULL DEFAULT 100.00,
  `unidad` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'unidad',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  `visible_catalogo` tinyint(1) NULL DEFAULT 0 COMMENT 'Mostrar en catálogo público',
  `precio_oferta` decimal(10, 2) NULL DEFAULT NULL,
  `descripcion_larga` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `fotos_catalogo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT 'Array de rutas de imágenes',
  `destacado` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `idx_categoria`(`categoria_id` ASC) USING BTREE,
  INDEX `idx_stock_minimo`(`stock_actual` ASC, `stock_minimo` ASC) USING BTREE,
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 429 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productos
-- ----------------------------
INSERT INTO `productos` VALUES (7, 'PRD-00001', 'GENERICO', 'PRODUCTO VARIADO', 21, '', '', '', 'VIRTUAL', 1.00, 100.00, 997.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 10:28:55', '2026-06-07 10:42:47', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (8, 'PRD-00002', 'csa31', '', 22, '', '', '', '', 120.00, 180.00, 10.00, 1.00, 100.00, 'unidad', 0, '2026-06-07 16:56:22', '2026-06-07 16:58:05', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (9, 'PRD-00003', 'Cargador Tipo C', '', 22, 'Genérico', '', '', '', 8.00, 20.00, 25.00, 1.00, 100.00, 'unidad', 0, '2026-06-07 16:56:22', '2026-06-07 16:58:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (10, 'CSA31', 'CARCASA SAMSUNG A31', '', 23, 'GENERICO', 'A31', '', '', 9.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (11, 'CSA51', 'CARCASA SAMSUNG A51', '', 23, 'GENERICO', 'A51', '', '', 5.00, 15.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (12, 'CSA52', 'CARCASA SAMSUNG A52', '', 23, 'GENERICO', 'A52', '', '', 10.00, 25.00, 23.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (13, 'CSA30S', 'CARCASA SAMSUNG A30S/A50', '', 23, 'GENERICO', 'A30S', '', '', 6.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (14, 'CSA54', 'CARCASA SAMSUNG A54', '', 23, 'GENERICO', 'A54', '', '', 6.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (15, 'CSA71CL', 'CARCASA SAMSUNG A71', '', 23, 'GENERICO', 'A71', '', '', 6.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (16, 'CSA32', 'CARCASA SAMSUNG A32', '', 23, 'GENERICO', 'A32', '', '', 9.00, 20.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (17, 'CSA33', 'CARCASA SAMSUNG A33', '', 23, 'GENERICO', 'A33', '', '', 9.00, 20.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (18, 'CSA34', 'CARCASA SAMSUNG A34', '', 23, 'GENERICO', 'A34', '', '', 6.00, 20.00, 15.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (19, 'CSA224G360', 'CARCASA SAMSUNG A22 4G 360', '', 23, 'GENERICO', 'A22 360', '', '', 8.00, 30.00, 16.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (20, 'CSA224G', 'CARCASA SAMSUNG A22 4G', '', 23, 'GENERICO', 'A22', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (21, 'CSA23', 'CARCASA SAMSUNG A23', '', 23, 'GENERICO', 'A32', '', '', 9.00, 20.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (22, 'CSA25', 'CARCASA SAMSUNG A25', '', 23, 'GENERICO', 'A25', '', '', 6.00, 20.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (23, 'CSA26360', 'CARCASA SAMSUNG A26 360', '', 23, 'GENERICO', 'A26 360', '', '', 8.00, 30.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (24, 'CSA06', 'CARCASA SAMSUNG A06', '', 23, 'GENERICO', 'A06', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (25, 'CMG10', 'CARCASA MOTO G10/G20/G30', '', 23, 'GENERICO', 'G10', '', '', 8.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (26, 'CSA02R', 'CARCASA SAMSUNG A02 ROBOT', '', 23, 'GENERICO', '02 R', '', '', 10.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (27, 'CSA02S', 'CARCASA SAMSUNG A02S', '', 23, 'GENERICO', 'A02S', '', '', 9.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (28, 'CSA03S', 'CARCASA SAMSUNG A03S', '', 23, 'GENERICO', 'A03S', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (29, 'CSA03', 'CARCASA SAMSUNG A03', '', 23, 'GENERICO', 'A03', '', '', 8.00, 20.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (30, 'CSA05S', 'CARCASA SAMSUNG A05S', '', 23, 'GENERICO', 'A05S', '', '', 6.00, 20.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (31, 'CSA04S', 'CARCASA SAMSUNG A04S', '', 23, 'GENERICO', 'A04S', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (32, 'CSA10360', 'CARCASA SAMSUNG A10 360', '', 23, 'GENERICO', 'A10', '', '', 8.00, 30.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (33, 'CSA11D', 'CARCASA SAMSUNG A11 DISEÑO', '', 23, 'GENERICO', 'A11', '', '', 5.00, 15.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (34, 'CSA12360', 'CARCASA SAMSUNG A12 360', '', 23, 'GENERICO', 'A12 360', '', '', 8.00, 30.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (35, 'CSA16360', 'CARCASA SAMSUNG A16 360', '', 23, 'GENERICO', 'A16 360', '', '', 8.00, 30.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (36, 'CSA21S', 'CARCASA SAMSUNG A21S', '', 23, 'GENERICO', 'A21S', '', '', 9.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (37, 'CSA20S', 'CARCASA SAMSUNG A20S', '', 23, 'GENERICO', 'A20S', '', '', 5.00, 15.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (38, 'CSS25U360', 'CARCASA SAMSUNG S25 ULTRA 360', '', 23, 'GENERICO', 'S25 ULTRA 360', '', '', 13.00, 30.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (39, 'CSS23FE360', 'CARCASA SAMSUNG S23FE 360', '', 23, 'GENERICO', 'S23 FE 360', '', '', 8.00, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (40, 'CSS23360', 'CARCASA SAMSUNG S23 360', '', 23, 'GENERICO', 'S23360', '', '', 8.00, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (41, 'CSS20FE', 'CARCASA SAMSUNG S20FE', '', 23, 'GENERICO', 'S20 FE', '', '', 10.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (42, 'CSA36360', 'CARCASA SAMSUNG A36 360', '', 23, 'GENERICO', 'A36 360', '', '', 8.00, 30.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (43, 'CSA72', 'CARCASA SAMSUNG A72', '', 23, 'GENERICO', 'A72', '', '', 6.00, 20.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (44, 'CSA73DP', 'CARCASA SAMSUNG A73 5G DISEÑO PULSERA', '', 23, 'GENERICO', 'A73', '', '', 10.00, 20.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (45, 'CH90360', 'CARCASA HONOR 90 360', '', 23, 'GENERICO', '90 360', '', '', 8.00, 30.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (46, 'PRD-00040', 'csa31', '', 22, '', '', '', '', 120.00, 180.00, 10.00, 1.00, 100.00, 'unidad', 0, '2026-06-07 17:00:16', '2026-06-07 17:00:38', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (47, 'PRD-00041', 'Cargador Tipo C', '', 22, 'Genérico', '', '', '', 8.00, 20.00, 25.00, 1.00, 100.00, 'unidad', 0, '2026-06-07 17:00:16', '2026-06-07 17:00:33', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (48, 'PRD-00042', 'csa31', '', 24, 'ADAPTADOR DE AUDIO A TC BIXOSS', '', 'ACCESORIOS', 'BIXOSS', 0.00, 0.00, 0.00, 5.00, 10.00, '2', 1, '2026-06-12 11:35:12', '2026-06-12 11:35:12', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (49, 'PRD-00043', 'Cargador Tipo C', '', 25, 'AUDIFONO BFXU CABLE BUDS 2 PLUS', '', 'AUDIFONO CON CABLE', 'BFXU', 0.00, 0.00, 0.00, 3.00, 10.00, '1', 1, '2026-06-12 11:35:12', '2026-06-12 11:35:12', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (50, 'ABCUB012', 'ADAPTADOR DE AUDIO A TC BIXOSS', '', 64, 'BIXOSS', 'JACK A TC', '', '', 5.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:43:55', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (51, 'ABFXU', 'AUDIFONO BFXU CABLE BUDS 2 PLUS', '', 65, 'BFXU', 'AUDIFONO', '', '', 3.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (52, 'ASR31', 'AUDIFONO CON CABLE SMARTEL R31', '', 65, 'SMARTEL', 'AUDIFONO', '', '', 5.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (53, 'AVDR02', 'AUDIFONO CON CABLE VDENMENV DR02', '', 65, 'VDENMENV', 'AUDIFONO', '', '', 2.50, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (54, 'CBRMATC', 'CABLE ROMAX AUXILIAR TC', '', 66, 'ROMAX', 'AUX A TC', '', '', 6.00, 15.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (55, 'CBTPV3', 'CABLE USB V3', '', 67, 'GENERICO', 'USB A V3', '', '', 3.00, 15.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (56, 'CBVATC', 'CABLE VEX AUXILIAR TC', '', 66, 'VEX', 'AUX A TC', '', '', 5.50, 10.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (57, 'CPSJ2CORE', 'CAMARA POSTERIOR J2 CORE', '', 68, 'TIPO', 'J2', '', '', 10.00, 30.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (58, 'CRDWTC5A', 'CARGADOR DW TC 5,5A', '', 69, 'DW', 'USB A TC', '', '', 12.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (59, 'CRDWV8', 'CARGADOR DW TV8 6A', '', 70, 'DW', 'TV8', '', '', 12.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (60, 'CRRDV875W', 'CARGADOR REDD TV8 75W', '', 70, 'REDD', 'TV8', '', '', 12.00, 25.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (61, 'CRTYV8', 'CARGADOR TRANYCO TV8 30W', '', 71, 'TRANYCO', 'V8', '', '', 12.00, 25.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (62, 'CSTV8', 'CARGADOR SAMSUNG TIPO ORIGINAL V8', '', 70, 'TIPO', 'CARGADOR TIPO V8', '', '', 11.50, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (63, 'CTIP5A', 'CABLE TRANYCO IPHONE 5A', '', 72, 'TRANYCO', 'USB A IPHONE', '', '', 12.00, 20.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (64, 'CTX3V', 'CABLE TRANYCO 5A', '', 71, 'TRANYCO', 'V8', '', '', 12.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (65, 'CVEXIP', 'CABLE VEX TC IPHONE 2A', '', 72, 'VEX', 'USB A TC', '', '', 3.00, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (66, 'CVM', 'CAMARA VARIAS MARCAS', '', 68, 'TIPO', 'VARIOS', '', '', 5.00, 30.00, 128.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (67, 'FLXA10SM15', 'FLEX CONECTOR SAMSUNG A10S-M15', '', 73, 'TIPO', 'A10S M15', '', '', 7.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (68, 'FLXA10SM16', 'FLEX CONECTOR SAMSUNG A10S-M16', '', 73, 'TIPO', 'A10S M16', '', '', 7.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (69, 'FLXA20', 'FLEX CONECTOR SAMSUNG A20', '', 73, 'TIPO', 'A20', '', '', 8.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (70, 'FLXA72', 'FLEX CONECTOR SAMSUNG A72', '', 73, 'TIPO', 'A72', '', '', 20.00, 40.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (71, 'FLXNT8', 'FLEX CONECTOR REDMI NOTE 8', '', 73, 'TIPO', 'NT8', '', '', 7.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (72, 'FLXPSMART19', 'FLEX CONECTOR HUAWEI PSMART 2019', '', 73, 'TIPO', 'PSMART19', '', '', 7.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (73, 'L00284', 'PANTALLA HUAWEI Y6 2019', '', 74, 'TIPO', 'Y6 2019', '', '', 34.00, 44.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (74, 'L01728', 'PANTALLA IPHONE 11 - INCELL', '', 74, 'TIPO', 'IPHONE 11', '', '', 45.00, 55.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (75, 'L01889', 'PANTALLA SAMSUNG A04 - ORIGINAL', '', 74, 'TIPO', 'A04', '', '', 40.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (76, 'L02974', 'PANTALLA SAMSUNG A10 - LUMINANCIA ALTA', '', 74, 'TIPO', 'A10', '', '', 35.00, 45.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (77, 'L02975', 'PANTALLA SAMSUNG A10S - Original Self Welded', '', 74, 'TIPO', 'A10S', '', '', 35.00, 45.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (78, 'L02980', 'PANTALLA SAMSUNG A20S - Original Self Welded', '', 74, 'TIPO', 'A20S', '', '', 37.00, 47.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (79, 'L02989', 'PANTALLA SAMSUNG A30S - LUMINANCIA ALTA', '', 74, 'TIPO', 'A30S', '', '', 45.00, 50.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (80, 'L07646', 'PANTALLA Y9 2019 /Y8S', '', 74, 'TIPO', 'Y92019', '', '', 38.00, 48.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (81, 'L14607', 'PANTALLA SAMSUNG A30/A50/A50S INCELL CM', '', 74, 'TIPO', 'A30', '', '', 40.00, 50.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (82, 'L17760', 'PANTALLA REDMI NOTE 10 /10S INCELL', '', 74, 'TIPO', 'NOTE 10', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (83, 'L18356', 'PANTALLA HUAWEI Y9 PRIME / Y9S', '', 74, 'TIPO', 'Y9 PRIME', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (84, 'L25188', 'PANTALLA HONOR X7 - Original Self Welded', '', 74, 'TIPO', 'X7', '', '', 38.00, 48.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (85, 'L25189', 'PANTALLA HONOR X8 - Original Self Welded', '', 74, 'TIPO', 'X8', '', '', 42.00, 52.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (86, 'L31758', 'PANTALLA SAMSUNG A53 CON MARCO - INCELL', '', 74, 'TIPO', 'A53', '', '', 80.00, 90.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (87, 'L37739', 'PANTALLA HUAWEI P40 LITE', '', 74, 'TIPO', 'P40LITE', '', '', 40.00, 50.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (88, 'L38241', 'PANTALLA SAMSUNG A02S/A03/A03S', '', 74, 'TIPO', 'A02S', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (89, 'L39124', 'PANTALLA SAMSUNG A13/A23 4G', '', 74, 'TIPO', 'A13', '', '', 45.00, 50.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (90, 'L39513', 'PANTALLA SAMSUNG A32 4G CON MARCO', '', 74, 'TIPO', 'A32', '', '', 42.00, 52.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (91, 'L44051', 'PANTALLA POCO X3/X3PRO', '', 74, 'TIPO', 'X3/X3PRO', '', '', 42.00, 52.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (92, 'L44509', 'PANTALLA SAMSUNG J4 - LUMINANCIA ALTA', '', 74, 'TIPO', 'J4', '', '', 41.00, 50.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (93, 'L45921', 'PANTALLA IPHONE XR - GX', '', 74, 'TIPO', 'XR', '', '', 63.00, 70.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (94, 'LCHP20L', 'LENTE DE CAM. HUAWEI P20 LITE', '', 75, 'TIPO', 'P20L', '', '', 4.00, 25.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (95, 'LCHP30L', 'LENTE DE CAM. HUAWEI P30 LITE', '', 75, 'TIPO', 'P30L', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (96, 'LCHY62018', 'LENTE DE CAM. HUAWEI Y6(2018)', '', 75, 'TIPO', 'Y62018', '', '', 4.00, 25.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (97, 'LCHY72018', 'LENTE DE CAM. HUAWEI Y7(2018)', '', 75, 'TIPO', 'Y72018', '', '', 4.00, 25.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (98, 'LCHY8S', 'LENTE DE CAM. HUAWEI Y8S', '', 75, 'TIPO', 'Y8S', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (99, 'LCHY9S', 'LENTE DE CAM. HUAWEI Y9S', '', 75, 'TIPO', 'Y9S', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (100, 'LCIPX', 'LENTE DE CAM. IPHONE', '', 75, 'TIPO', 'PX', '', '', 4.00, 30.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (101, 'LCME5', 'LENTE DE CAM. MOTOROLA E5', '', 75, 'TIPO', 'E5', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (102, 'LCMOTOG8PLUS', 'LENTE DE CAM. MOTOROLA G8 PLUS', '', 75, 'TIPO', 'G8PLUS', '', '', 4.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (103, 'LCPM3', 'LENTE DE CAM. POCO M3', '', 75, 'TIPO', 'M3', '', '', 4.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (104, 'LCPX3', 'LENTE DE CAM. POCO X3', '', 75, 'TIPO', 'X3', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (105, 'LCPX3GT', 'LENTE DE CAM. POCO X3 GT', '', 75, 'TIPO', 'X3GT', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (106, 'LCR9A', 'LENTE DE CAM. REDMI 9A', '', 75, 'TIPO', '9A', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (107, 'LCR9C', 'LENTE DE CAM. REDMI 9C', '', 75, 'TIPO', '9C', '', '', 4.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (108, 'LCRNT10P', 'LENTE DE CAM. REDMI NOTE 10 PRO', '', 75, 'TIPO', 'NT10P', '', '', 4.00, 25.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (109, 'LCRNT10S', 'LENTE DE CAM. REDMI NOTE 10S', '', 75, 'TIPO', 'NT10S', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (110, 'LCRNT8P', 'LENTE DE CAM. REDMI NOTE 8 PRO', '', 75, 'TIPO', 'NT8P', '', '', 4.00, 25.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (111, 'LCSA02S', 'LENTE DE CAM. SAMSUNG A02S', '', 75, 'TIPO', 'A02S', '', '', 4.00, 35.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (112, 'LCSA10A20A30', 'LENTE DE CAM. SAMSUNG A10/A20/A30', '', 75, 'TIPO', 'A10A20A30', '', '', 3.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (113, 'LCSA10S', 'LENTE DE CAM. SAMSUNG A10S', '', 75, 'TIPO', 'A10S', '', '', 4.00, 25.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (114, 'LCSA20S', 'LENTE DE CAM. SAMSUNG A20S', '', 75, 'TIPO', 'A20S', '', '', 3.00, 35.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (115, 'LCSA21S', 'LENTE DE CAM. SAMSUNG A21S', '', 75, 'TIPO', 'A21S', '', '', 4.00, 35.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (116, 'LCSA30S', 'LENTE DE CAM. SAMSUNG A30S', '', 75, 'TIPO', 'A30S', '', '', 3.00, 35.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (117, 'LCSA31', 'LENTE DE CAM. SAMSUNG A31', '', 75, 'TIPO', 'A31', '', '', 4.00, 35.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (118, 'LCSA50', 'LENTE DE CAM. SAMSUNG A50', '', 75, 'TIPO', 'A50', '', '', 3.00, 35.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (119, 'LCSA70', 'LENTE DE CAM. SAMSUNG A70', '', 75, 'TIPO', 'A70', '', '', 3.00, 35.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (120, 'LCSA71', 'LENTE DE CAM. SAMSUNG A71', '', 75, 'TIPO', 'A71', '', '', 8.00, 35.00, 14.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (121, 'LCXM11L', 'LENTE DE CAM. XIAOMI MI 11 LITE', '', 75, 'TIPO', 'M11L', '', '', 4.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (122, 'MCA06', 'MICA COMPLETA SAMSUNG A06', '', 76, 'GENERICO', 'A06', '', '', 0.90, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (123, 'MCA55', 'MICA COMPLETA SAMSUNG A55', '', 76, 'GENERICO', 'A55', '', '', 1.00, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (124, 'MCHMATE10LITE', 'MICA COMPLETA HUAWEI MATE10 LITE', '', 76, 'GENERICO', 'MATE10LITE', '', '', 1.20, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (125, 'MCHONORX8B', 'MICA COMPLETA HONOR X8B', '', 76, 'GENERICO', 'X8B', '', '', 1.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (126, 'MCHP20LITE', 'MICA COMPLETA HUAWEI P20 LITE', '', 76, 'GENERICO', 'P20LITE', '', '', 1.20, 10.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (127, 'MCHP20PRO', 'MICA COMPLETA HUAWEI P20 PRO', '', 76, 'GENERICO', 'P20PRO', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (128, 'MCHP40LITE', 'MICA COMPLETA HUAWEI P40 LITE', '', 76, 'GENERICO', 'P40LITE', '', '', 1.35, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (129, 'MCHX5P', 'MICA COMPLETA HONOR X5 PLUS', '', 76, 'GENERICO', 'X5P', '', '', 0.90, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (130, 'MCHX6A', 'MICA COMPLETA HONOR X6A', '', 76, 'GENERICO', 'X6A', '', '', 0.90, 10.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (131, 'MCHX7A', 'MICA COMPLETA HONOR X7A', '', 76, 'GENERICO', 'X7A', '', '', 1.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (132, 'MCHX8', 'MICA COMPLETA HONOR X8', '', 76, 'GENERICO', 'X8', '', '', 1.05, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (133, 'MCHY5P', 'MICA COMPLETA HUAWEI Y5P', '', 76, 'GENERICO', 'Y5P', '', '', 1.35, 10.00, 19.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (134, 'MCHY62018', 'MICA COMPLETA HUAWEI Y62018', '', 76, 'GENERICO', 'Y62018', '', '', 1.35, 10.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (135, 'MCHY62019', 'MICA COMPLETA HUAWEI Y62019', '', 76, 'GENERICO', 'Y62019', '', '', 1.35, 10.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (136, 'MCHY6P', 'MICA COMPLETA HUAWEI Y6P', '', 76, 'GENERICO', 'Y6P', '', '', 1.40, 10.00, 20.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (137, 'MCHY6S', 'MICA COMPLETA HUAWEI Y6S', '', 76, 'GENERICO', 'Y6S', '', '', 1.35, 10.00, 17.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (138, 'MCHY72018', 'MICA COMPLETA HUAWEI Y72018', '', 76, 'GENERICO', 'Y72018', '', '', 1.35, 10.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (139, 'MCHY72019', 'MICA COMPLETA HUAWEI Y72019', '', 76, 'GENERICO', 'Y72019', '', '', 1.35, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (140, 'MCHY7A', 'MICA COMPLETA HUAWEI Y7A', '', 76, 'GENERICO', 'Y7A', '', '', 1.35, 10.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (141, 'MCHY7P', 'MICA COMPLETA HUAWEI Y7P', '', 76, 'GENERICO', 'Y7P', '', '', 1.00, 10.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (142, 'MCHY8P', 'MICA COMPLETA HUAWEI Y8P', '', 76, 'GENERICO', 'Y8P', '', '', 1.35, 10.00, 21.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (143, 'MCHY92019', 'MICA COMPLETA HUAWEI Y92019', '', 76, 'GENERICO', 'Y92019', '', '', 1.00, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (144, 'MCHY9A', 'MICA COMPLETA HUAWEI Y9A', '', 76, 'GENERICO', 'Y9A', '', '', 1.00, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (145, 'MCHY9S', 'MICA COMPLETA HUAWEI Y9S', '', 76, 'GENERICO', 'Y9S', '', '', 1.35, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (146, 'MCIP11PM', 'MICA COMPLETA IPHONE 11PM-XSPM', '', 76, 'GENERICO', 'I11PM', '', '', 0.90, 10.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (147, 'MCIP11PMXSPM', 'MICA COMPLETA IPHONE11PM/XSPM', '', 76, 'GENERICO', 'I11PMXSPM', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (148, 'MCIP11PRO', 'MICA COMPLETA IPHONE 11PRO', '', 76, 'GENERICO', 'I11PRO', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (149, 'MCIP12PRO', 'MICA COMPLETA IPHONE 12/12PRO', '', 76, 'GENERICO', 'I12PRO', '', '', 1.35, 10.00, 19.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (150, 'MCIP12PROMAX', 'MICA COMPLETA IPHONE 12 PRO MAX', '', 76, 'GENERICO', 'I12PROMAX', '', '', 1.35, 10.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (151, 'MCIP13PM', 'MICA COMPLETA IPHONE 13 PRO MAX', '', 76, 'GENERICO', 'I13PM', '', '', 1.00, 10.00, 22.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (152, 'MCIP14', 'MICA COMPLETA IPHONE 14', '', 76, 'GENERICO', 'I14', '', '', 1.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (153, 'MCIP14PM', 'MICA COMPLETA IPHONE 14 PRO MAX', '', 76, 'GENERICO', 'I14PM', '', '', 1.00, 10.00, 16.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (154, 'MCIP15', 'MICA COMPLETA IPHONE 15', '', 76, 'GENERICO', 'I15', '', '', 1.00, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (155, 'MCIP15PM', 'MICA COMPLETA IPHONE 15 PRO MAX', '', 76, 'GENERICO', 'I15PM', '', '', 0.90, 10.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (156, 'MCIP16', 'MICA COMPLETA IPHONE 16', '', 76, 'GENERICO', 'I16', '', '', 0.90, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (157, 'MCIP16P', 'MICA COMPLETA IPHONE 16 PRO', '', 76, 'GENERICO', 'I16P', '', '', 0.90, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (158, 'MCIP16PM', 'MICA COMPLETA IPHONE 16 PRO MAX', '', 76, 'GENERICO', 'I16PM', '', '', 0.90, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (159, 'MCIP6PLUS', 'MICA COMPLETA IPHONE 6+/7+/8+', '', 76, 'GENERICO', 'I6PLUS', '', '', 1.35, 10.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (160, 'MCIPH15PROMAX', 'MICA COMPLETA IPHONE 15 PROMAX', '', 76, 'GENERICO', 'I15PROMAX', '', '', 0.90, 10.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (161, 'MCIPXR11', 'MICA COMPLETA IPHONE XR/11', '', 76, 'GENERICO', 'IXR11', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (162, 'MCIPXS', 'MICA COMPLETA IPXS', '', 76, 'GENERICO', 'IXS', '', '', 0.90, 10.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (163, 'MCME20L', 'MICA COMPLETA MOTOROLA EDGE 20 LITE', '', 76, 'GENERICO', 'E20L', '', '', 1.20, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (164, 'MCME6S', 'MICA COMPLETA MOTOROLA E6S', '', 76, 'GENERICO', 'E6S', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (165, 'MCME7POWER', 'MICA COMPLETA MOTOROLA E7POWER', '', 76, 'GENERICO', 'E7POWER', '', '', 1.35, 10.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (166, 'MCMG10', 'MICA COMPLETA MOTOROLA G10/G20/G30', '', 76, 'GENERICO', 'G10', '', '', 1.35, 10.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (167, 'MCMG31', 'MICA COMPLETA MOTOROLA G31', '', 76, 'GENERICO', 'G31', '', '', 1.20, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (168, 'MCMG32', 'MICA COMPLETA MOTOROLA G32', '', 76, 'GENERICO', 'G32', '', '', 1.30, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (169, 'MCMG51', 'MICA COMPLETA MOTOROLA G51', '', 76, 'GENERICO', 'G51', '', '', 1.20, 10.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (170, 'MCMG60S', 'MICA COMPLETA MOTOROLA G60S', '', 76, 'GENERICO', 'G60S', '', '', 1.20, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (171, 'MCMG7PLUS', 'MICA COMPLETA MOTOROLA G7+', '', 76, 'GENERICO', 'G7PLUS', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (172, 'MCMG7POWER', 'MICA COMPLETA MOTOROLA G7POWER', '', 76, 'GENERICO', 'G7POWER', '', '', 1.35, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (173, 'MCMG8PLAY', 'MICA COMPLETA MOTOROLA G8 PLAY', '', 76, 'GENERICO', 'G8PLAY', '', '', 1.35, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (174, 'MCMG8POWERL', 'MICA COMPLETA MOTOROLA G8 POWER LITE', '', 76, 'GENERICO', 'G8POWERL', '', '', 1.35, 10.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (175, 'MCMONEFUSION', 'MICA COMPLETA MOTOROLA ONEFUSION', '', 76, 'GENERICO', 'ONEFUSION', '', '', 1.35, 10.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (176, 'MCMONEMACRO', 'MICA COMPLETA MOTOROLA ONEMACRO', '', 76, 'GENERICO', 'ONEMACRO', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (177, 'MCMONEVISION', 'MICA COMPLETA MOTOROLA ONEVISION', '', 76, 'GENERICO', 'ONEVISION', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (178, 'MCPF2PRO', 'MICA COMPLET POCO F2PRO', '', 76, 'GENERICO', 'F2PRO', '', '', 1.00, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (179, 'MCPOCOX3', 'MICA COMPLETA POCO X3/X3 PRO', '', 76, 'GENERICO', 'X3', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (180, 'MCR10A', 'MICA COMPLETA REDMI 10A', '', 76, 'GENERICO', '10A', '', '', 1.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (181, 'MCR10C', 'MICA COMPLETA REDMI 10C', '', 76, 'GENERICO', '10C', '', '', 1.00, 10.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (182, 'MCR12C', 'MICA COMPLETA REDMI 12C', '', 76, 'GENERICO', '12C', '', '', 0.90, 10.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (183, 'MCR9A', 'MICA COMPLETA REDMI 9A/9C', '', 76, 'GENERICO', '9A', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (184, 'MCRN11P', 'MICA COMPLETA IPHONE 11 PRO', '', 76, 'GENERICO', 'N11P', '', '', 0.90, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (185, 'MCRNOTE115G', 'MICA COMPLETA REDMI NOTE 11 5G', '', 76, 'GENERICO', 'NOTE115G', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (186, 'MCRNOTE8PRO', 'MICA COMPLETA REDMI NOTE 8 PRO', '', 76, 'GENERICO', 'NOTE8PRO', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (187, 'MCRNOTE9PRO', 'MICA COMPLETA REDMI NOTE 9 PRO/S', '', 76, 'GENERICO', 'NOTE9PRO', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (188, 'MCSA01CORE', 'MICA COMPLETA SAMSUNG A01 CORE', '', 76, 'GENERICO', 'A01CORE', '', '', 1.35, 10.00, 16.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (189, 'MCSA05S', 'MICA COMPLETA SAMSUNG A05S', '', 76, 'GENERICO', 'A05S', '', '', 0.90, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (190, 'MCSA06', 'MICA COMPLETA SAMSUNG A06', '', 76, 'GENERICO', 'A06', '', '', 0.90, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (191, 'MCSA072018', 'MICA COMPLETA SAMSUNG A07 2018', '', 76, 'GENERICO', 'A072018', '', '', 1.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (192, 'MCSA10', 'MICA COMPLETA SAMSUNG A10/A10S', '', 76, 'GENERICO', 'A10', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (193, 'MCSA11', 'MICA COMPLETA SAMSUNG A11', '', 76, 'GENERICO', 'A11', '', '', 1.00, 10.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (194, 'MCSA12', 'MICA COMPLETA SAMSUNG A12', '', 76, 'GENERICO', 'A12', '', '', 1.35, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (195, 'MCSA14', 'MICA COMPLETA SAMSUNG A14', '', 76, 'GENERICO', 'A14', '', '', 1.00, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (196, 'MCSA15', 'MICA COMPLETA SAMSUNG A15', '', 76, 'GENERICO', 'A15', '', '', 0.90, 10.00, 19.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (197, 'MCSA20', 'MICA COMPLETA SAMSUNG A20/A30', '', 76, 'GENERICO', 'A20', '', '', 1.35, 10.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (198, 'MCSA20S', 'MICA COMPLETA SAMSUNG A20S', '', 76, 'GENERICO', 'A20S', '', '', 1.35, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (199, 'MCSA21S', 'MICA COMPLETA SAMSUNG A21S', '', 76, 'GENERICO', 'A21S', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (200, 'MCSA224G', 'MICA COMPLETA SAMSUNG A22 4G', '', 76, 'GENERICO', 'A224G', '', '', 1.20, 10.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (201, 'MCSA225G', 'MICA COMPLETA SAMSUNG A22 5G', '', 76, 'GENERICO', 'A225G', '', '', 1.35, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (202, 'MCSA23', 'MICA COMPLETA SAMSUNG A23', '', 76, 'GENERICO', 'A23', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (203, 'MCSA30', 'MICA COMPLETA SAMSUNG A30', '', 76, 'GENERICO', 'A30', '', '', 0.90, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (204, 'MCSA30S', 'MICA COMPLETA SAMSUNG A30S/A50S', '', 76, 'GENERICO', 'A30S', '', '', 1.35, 10.00, 25.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (205, 'MCSA31', 'MICA COMPLETA SAMSUNG A31', '', 76, 'GENERICO', 'A31', '', '', 1.35, 10.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (206, 'MCSA324G', 'MICA COMPLETA SAMSUNG A324G', '', 76, 'GENERICO', 'A324G', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (207, 'MCSA34', 'MICA COMPLETA SAMSUNG A34', '', 76, 'GENERICO', 'A34', '', '', 1.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (208, 'MCSA35', 'MICA COMPLETA SAMSUNG A35', '', 76, 'GENERICO', 'A35', '', '', 0.90, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (209, 'MCSA50', 'MICA COMPLETA SAMSUNG A50', '', 76, 'GENERICO', 'A50', '', '', 0.90, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (210, 'MCSA51', 'MICA COMPLETA SAMSUNG A51', '', 76, 'GENERICO', 'A51', '', '', 1.35, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (211, 'MCSA52', 'MICA COMPLETA SAMSUNG A524G/5G', '', 76, 'GENERICO', 'A52', '', '', 1.35, 10.00, 14.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (212, 'MCSA52S', 'MICA COMPLETA SAMSUNG A52S', '', 76, 'GENERICO', 'A52S', '', '', 0.90, 10.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (213, 'MCSA53', 'MICA COMPLETA SAMSUNG A53 5G', '', 76, 'GENERICO', 'A53', '', '', 1.00, 10.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (214, 'MCSA54', 'MICA COMPLETA SAMSUNG A54', '', 76, 'GENERICO', 'A54', '', '', 1.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (215, 'MCSA70', 'MICA COMPLETA SAMSUNG A70', '', 76, 'GENERICO', 'A70', '', '', 1.35, 10.00, 16.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (216, 'MCSA71', 'MICA COMPLETA SAMSUNG A71', '', 76, 'GENERICO', 'A71', '', '', 1.35, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (217, 'MCSA72', 'MICA COMPLETA SAMSUNG A72', '', 76, 'GENERICO', 'A72', '', '', 1.35, 10.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (218, 'MCSA80', 'MICA COMPLETA SAMSUNG A80/A90', '', 76, 'GENERICO', 'A80', '', '', 1.35, 10.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (219, 'MCSJ4', 'MICA COMPLETA SAMSUNG J4/J4 PLUS/J6PLUS', '', 76, 'GENERICO', 'J4', '', '', 1.35, 10.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (220, 'MCSJ4CORE', 'MICA COMPLETA SAMSUNG J4 CORE', '', 76, 'GENERICO', 'J4CORE', '', '', 1.00, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (221, 'MCSJ62018', 'MICA COMPLETA SAMSUNG J6 2018', '', 76, 'GENERICO', 'J62018', '', '', 1.00, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (222, 'MCSJ7', 'MICA COMPLETA SAMSUNG J7', '', 76, 'GENERICO', 'J7', '', '', 1.00, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (223, 'MCSJ7NEO', 'MICA COMPLETA SAMSUNG J7 NEO', '', 76, 'GENERICO', 'J7NEO', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (224, 'MCZTEV10VITA', 'MICA COMPLETA ZTE V10VITA', '', 76, 'GENERICO', 'V10VITA', '', '', 1.35, 10.00, 19.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (225, 'MCZTEV30', 'MICA COMPLETA ZTE V30 VITA', '', 76, 'GENERICO', 'V30VITA', '', '', 1.35, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (226, 'MCZTEV40VT', 'MICA COMPLETA ZTE V40 VITA', '', 76, 'GENERICO', 'V40VITA', '', '', 1.05, 10.00, 18.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (227, 'MCZV50V', 'MICA COMPLETA ZTE V50 VITA', '', 76, 'GENERICO', 'V50VITA', '', '', 0.90, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (228, 'MHP20LITE', 'MICA SIMPLE HUAWEI P20LITE', '', 77, 'GENERICO', '20LITE', '', '', 0.92, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (229, 'MHP20PRO', 'MICA SIMPLE HUAWEI P20PRO', '', 77, 'GENERICO', '20PRO', '', '', 1.40, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (230, 'MHY518', 'MICA SIMPLE HUAWEI Y5(2018)', '', 77, 'GENERICO', 'Y5 2018', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (231, 'MHY519', 'MICA SIMPLE HUAWEI Y519', '', 77, 'GENERICO', 'Y5 2019', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (232, 'MHY5P', 'MICA SIMPLE HUAWEI Y5P', '', 77, 'GENERICO', 'Y5P', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (233, 'MHY62018', 'MICA SIMPLE HUAWEI Y62018', '', 77, 'GENERICO', 'Y6 2018', '', '', 1.40, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (234, 'MPOCOM3', 'MICA SIMPLE POCO M3', '', 77, 'GENERICO', 'M3', '', '', 0.82, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (235, 'MSA02', 'MICA SIMPLE SAMSUNG A02', '', 77, 'GENERICO', 'A02', '', '', 0.82, 10.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (236, 'MSA04', 'MICA SIMPLE SAMSUNG  A04', '', 77, 'GENERICO', 'A04', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (237, 'MSA12', 'MICA SIMPLE SAMSUNG A12', '', 77, 'GENERICO', 'A12', '', '', 0.92, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (238, 'MSA20S', 'MICA SIMPLE SAMSUNG A20S', '', 77, 'GENERICO', '20S', '', '', 0.92, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (239, 'MSA31', 'MICA SIMPLE SAMSUNG A31', '', 77, 'GENERICO', 'A31', '', '', 1.40, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (240, 'MSA51', 'MICA SIMPLE SAMSUNG A51', '', 77, 'GENERICO', 'A51', '', '', 0.92, 5.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (241, 'MSA52', 'MICA SIMPLE SAMSUNG A52', '', 77, 'GENERICO', 'A52', '', '', 0.80, 5.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (242, 'MSA70', 'MICA SIMPLE SAMSUNG A70', '', 77, 'GENERICO', 'A70', '', '', 1.40, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (243, 'MSHP30LITE', 'MICA SIMPLE HUAWEI P30 LITE', '', 77, 'GENERICO', 'P30LITE', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (244, 'MSHP40LITE', 'MICA SIMPLE HUAWEI P40LITE', '', 77, 'GENERICO', 'P40LITE', '', '', 1.40, 5.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (245, 'MSHPSMART2019', 'MICA SIMPLE HUAWEI PSMART 2019', '', 77, 'GENERICO', 'PSMART2019', '', '', 0.80, 5.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (246, 'MSHX6A', 'MICA SIMPLE HONOR X6A', '', 77, 'GENERICO', 'X6A', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (247, 'MSHX6B', 'MICA SIMPLE HONOR X6B', '', 77, 'GENERICO', 'X6B', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (248, 'MSHX7A', 'MICA SIMPLE HONOR X7A', '', 77, 'GENERICO', 'X7A', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (249, 'MSHY6II', 'MICA SIMPLE HUAWEI Y6II', '', 77, 'GENERICO', 'Y6II', '', '', 0.82, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (250, 'MSHY6P', 'MICA SIMPLE HUAWEI Y6P', '', 77, 'GENERICO', 'Y6P', '', '', 0.83, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (251, 'MSHY6S', 'MICA SIMPLE HUAWEI Y6S', '', 77, 'GENERICO', 'Y6S', '', '', 0.80, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (252, 'MSHY7PRIME', 'MICA SIMPLE HUAWEI Y7 PRIME', '', 77, 'GENERICO', 'Y7PRIME', '', '', 0.80, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (253, 'MSHY7PRO', 'MICA SIMPLE HUAWEI Y7P', '', 77, 'GENERICO', 'Y7PRO', '', '', 1.40, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (254, 'MSHY8P', 'MICA SIMPLE HUAWEI Y8P', '', 77, 'GENERICO', 'Y8P', '', '', 1.40, 5.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (255, 'MSHY9A', 'MICA SIMPLE HUAWEI Y9A', '', 77, 'GENERICO', 'Y9A', '', '', 0.82, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (256, 'MSHY9S', 'MICA SIMPLE HUAWEI Y9S', '', 77, 'GENERICO', 'Y9S', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (257, 'MSJ2C', 'MICA SIMPLE SAMSUNG J2 CORE', '', 77, 'GENERICO', 'J2CORE', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (258, 'MSJ52016', 'MICA SIMPLE SAMSUNG J52016', '', 77, 'GENERICO', 'J5 2016', '', '', 0.90, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (259, 'MSJ7N', 'MICA SIMPLE SAMSUNG J7 NEO', '', 77, 'GENERICO', 'J7', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (260, 'MSJ7PRIME', 'MICA SIMPLE SAMSUNG J7 PRIME', '', 77, 'GENERICO', '7PRIME', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (261, 'MSLGK102018', 'MICA SIMPLE LG K102018', '', 77, 'GENERICO', 'K10 2018', '', '', 0.82, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (262, 'MSLGK20', 'MICA SIMPLE LG K20', '', 77, 'GENERICO', 'K20', '', '', 0.82, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (263, 'MSLGK9', 'MICA SIMPLE LG K9', '', 77, 'GENERICO', 'K9', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (264, 'MSLGSTYLUS3', 'MICA SIMPLE LG STYLUS 3', '', 77, 'GENERICO', 'STYLUS3', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (265, 'MSME2020', 'MICA SIMPLE MOTOROLA E2020', '', 77, 'GENERICO', 'E2020', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (266, 'MSME20L', 'MICA SIMPLE MOTOROLA EDGE 20 LITE', '', 77, 'GENERICO', 'E20L', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (267, 'MSME5PLAY', 'MICA SIMPLE MOTOROLA E5 PLAY', '', 77, 'GENERICO', 'E5PLAY', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (268, 'MSME6PLAY', 'MICA SIMPLE MOTOROLA E6 PLAY', '', 77, 'GENERICO', 'E6PLAY', '', '', 0.60, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (269, 'MSME7POWER', 'MICA SIMPLE MOTOROLA E7POWER', '', 77, 'GENERICO', 'E7POWER', '', '', 0.83, 5.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (270, 'MSMG10', 'MICA SIMPLE MOTOROLA G10', '', 77, 'GENERICO', 'G10', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (271, 'MSMG100', 'MICA SIMPLE MOTOROLA G100', '', 77, 'GENERICO', 'G100', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (272, 'MSMG13', 'MICA SIMPLE MOTOROLA G13', '', 77, 'GENERICO', 'G13', '', '', 0.80, 5.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (273, 'MSMG14', 'MICA SIMPLE MOTOROLA G14', '', 77, 'GENERICO', 'G14', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (274, 'MSMG22', 'MICA SIMPLE MOTOROLA G22', '', 77, 'GENERICO', 'G22', '', '', 0.80, 5.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (275, 'MSMG23', 'MICA SIMPLE MOTOROLA G23', '', 77, 'GENERICO', 'G23', '', '', 0.80, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (276, 'MSMG31', 'MICA SIMPLE MOTOROLA G31', '', 77, 'GENERICO', 'G31', '', '', 0.80, 5.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (277, 'MSMG50', 'MICA SIMPLE MOTOROLA G50', '', 77, 'GENERICO', 'G50', '', '', 0.80, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (278, 'MSMG51', 'MICA SIMPLE MOTOROLA G51', '', 77, 'GENERICO', 'G51', '', '', 0.80, 5.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (279, 'MSMG60S', 'MICA SIMPLE MOTOROLA G60S', '', 77, 'GENERICO', 'G60S', '', '', 0.80, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (280, 'MSMG8PLAY', 'MICA SIMPLE MOTOROLA G8 PLAY / ONE MACRO', '', 77, 'GENERICO', 'G8PLAY', '', '', 1.40, 5.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (281, 'MSMG8POWER', 'MICA SIMPLE MOTOROLA G8 POWER', '', 77, 'GENERICO', 'G8POWER', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (282, 'MSMG8POWER LITE', 'MICA SIMPLE MOTOROLA G8 POWER LITE', '', 77, 'GENERICO', 'G8POWER LITE', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (283, 'MSMG9PLAY', 'MICA SIMPLE MOTOROLA G9 PLAY', '', 77, 'GENERICO', 'G9PLAY', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (284, 'MSMG9PLUS', 'MICA SIMPLE MOTOROLA G9 PLUS', '', 77, 'GENERICO', 'G9PLUS', '', '', 0.82, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (285, 'MSMG9POWER', 'MICA SIMPLE MOTOROLA G9POWER', '', 77, 'GENERICO', 'G9POWER', '', '', 0.82, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (286, 'MSMOM', 'MICA SIMPLE MOTOROLA ONE MACRO', '', 77, 'GENERICO', 'OM', '', '', 1.40, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (287, 'MSMONEACTION', 'MICA SIMPLE MOTOROLA ONE ACTION', '', 77, 'GENERICO', 'ONEACTION', '', '', 1.40, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (288, 'MSMONEFUSION', 'MICA SIMPLE MOTOROLA ONE FUSION', '', 77, 'GENERICO', 'ONEFUSION', '', '', 0.85, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (289, 'MSPF2P', 'MICA SIMPLE POCO F2PRO', '', 77, 'GENERICO', 'F2P', '', '', 0.82, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (290, 'MSPX3', 'MICA SIMPLE POCO X3/X3PRO', '', 77, 'GENERICO', 'X3', '', '', 0.82, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (291, 'MSR10C', 'MICA SIMPLE REDMI 10C', '', 77, 'GENERICO', '10C', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (292, 'MSR124G', 'MICA SIMPLE REDMI 12 4G', '', 77, 'GENERICO', '124G', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (293, 'MSR125G', 'MICA SIMPLE REDMI 12 5G', '', 77, 'GENERICO', '125G', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (294, 'MSR13C', 'MICA SIMPLE REDMI 13C', '', 77, 'GENERICO', '13C', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (295, 'MSR9', 'MICA SIMPLE REDMI 9', '', 77, 'GENERICO', '9', '', '', 0.92, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (296, 'MSR9A', 'MICA SIMPLE REDMI 9A/9C POCO C3', '', 77, 'GENERICO', '9A', '', '', 0.92, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (297, 'MSRN104G', 'MICA SIMPLEREDMI NOTE104G/NOTE114G', '', 77, 'GENERICO', 'N104G', '', '', 0.82, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (298, 'MSRN13PRO', 'MICA SIMPLE REDMI NOTE 13 PRO', '', 77, 'GENERICO', 'N13PRO', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (299, 'MSRN8PRO', 'MICA SIMPLE REDMI NOTE 8 PRO', '', 77, 'GENERICO', 'N8PRO', '', '', 0.82, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (300, 'MSRNOTE10PRO', 'MICA SIMPLE REDMI NOTE 10 PRO', '', 77, 'GENERICO', 'NOTE10PRO', '', '', 0.82, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (301, 'MSRNOTE11', 'MICA SIMPLE REDMI NOTE 11', '', 77, 'GENERICO', 'NOTE11', '', '', 0.90, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (302, 'MSRNOTE11PRO', 'MICA SIMPLE REDMI NOTE 11 PRO', '', 77, 'GENERICO', 'NOTE11PRO', '', '', 0.90, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (303, 'MSRNOTE9PRO', 'MICA SIMPLE REDMI NOTE 9 PRO', '', 77, 'GENERICO', 'NOTE9PRO', '', '', 0.82, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (304, 'MSRNT12PRO', 'MICA SIMPLE REDMI NOTE 12 PRO', '', 77, 'GENERICO', 'NT12PRO', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (305, 'MSSA02S', 'MICA SIMPLE SAMSUNG A02S/A03/A03S', '', 77, 'GENERICO', 'A02S', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (306, 'MSSA06', 'MICA SIMPLE SAMSUNG A06', '', 77, 'GENERICO', 'A06', '', '', 0.80, 5.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (307, 'MSSA11', 'MICA SIMPLE SAMSUNG A11', '', 77, 'GENERICO', 'A11', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (308, 'MSSA14', 'MICA SIMPLE SAMSUNG A14', '', 77, 'GENERICO', 'A14', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (309, 'MSSA15', 'MICA SIMPLE SAMSUNG A15', '', 77, 'GENERICO', 'A15', '', '', 1.00, 5.00, 10.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (310, 'MSSA20', 'MICA SIMPLE SAMSUNG A20', '', 77, 'GENERICO', 'A20', '', '', 0.80, 5.00, 11.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (311, 'MSSA224G', 'MICA SIMPLE SAMSUNG A22 4G', '', 77, 'GENERICO', 'A224G', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (312, 'MSSA23', 'MICA SIMPLE SAMSUNG A23', '', 77, 'GENERICO', 'A23', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (313, 'MSSA25', 'MICA SIMPLE SAMSUNG A25', '', 77, 'GENERICO', 'A25', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (314, 'MSSA33', 'MICA SIMPLE SAMSUNG A33', '', 77, 'GENERICO', 'A33', '', '', 0.80, 5.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (315, 'MSSA35', 'MICA SIMPLE SAMSUNG A35', '', 77, 'GENERICO', 'A35', '', '', 0.80, 5.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (316, 'MSSA54', 'MICA SIMPLE SAMSUNG A54', '', 77, 'GENERICO', 'A54', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (317, 'MSSA72', 'MICA SIMPLE SAMSUNG A72 4G/5G', '', 77, 'GENERICO', 'A72', '', '', 0.72, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (318, 'MSSJ1', 'MICA SIMPLE SAMSUNG J1', '', 77, 'GENERICO', 'J1', '', '', 0.80, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (319, 'MSZA520', 'MICA SIMPLE ZTE A5 2020', '', 77, 'GENERICO', 'A520', '', '', 0.80, 5.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (320, 'MSZTEV40V', 'MICA SIMPLE ZTE V40 VITA', '', 77, 'GENERICO', 'V40VITA', '', '', 0.80, 5.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (321, 'MZTEA72018', 'MICA SIMPLE ZTE A72018', '', 77, 'GENERICO', 'A72018', '', '', 0.92, 5.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (322, 'MZTEV10VITA', 'MICA SIMPLE ZTE V 10VITA', '', 77, 'GENERICO', 'V10VITA', '', '', 0.82, 5.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (323, 'OTGV8', 'OTG V8 A USB', '', 78, 'GENERICO', 'V8 A USB', '', '', 3.00, 5.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (324, 'PHM20L', 'PANTALLA HUAWEI MATE 20', '', 74, 'TIPO', 'HUAWEI MATE', '', '', 45.00, 50.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (325, 'PHNY60', 'PANTALLA HUAWEI NOVA Y60', '', 74, 'TIPO', 'Y60', '', '', 37.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (326, 'PHX6A', 'PANTALLA HONOR X6A', '', 74, 'TIPO', 'X6A', '', '', 37.00, 47.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (327, 'PHX6B', 'PANTALLA HONOR X6B', '', 74, 'TIPO', 'X6B', '', '', 37.00, 47.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (328, 'PHX7A', 'PANTALLA HONOR X7A', '', 74, 'TIPO', 'X7A', '', '', 37.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (329, 'PHX8B', 'PANTALLA HONOR X8B AMOLED', '', 74, 'TIPO', 'X8B', '', '', 90.00, 100.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (330, 'PHY7P', 'PANTALLA HUAWEI Y7P', '', 74, 'TIPO', 'Y7P', '', '', 35.00, 45.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (331, 'PME22', 'PANTALLA MOTOROLA E22/E22I', '', 74, 'TIPO', 'E22/E22I', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (332, 'PME7E7IE7P', 'PANTALLA E7/E7I/E7POWER', '', 74, 'TIPO', 'E7I', '', '', 35.00, 45.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (333, 'PMG7POWER', 'PANTALLA MOTOROLA G7 POWER', '', 74, 'TIPO', 'G7 POWER', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (334, 'PMG8PONEM', 'PANTALLA MOTOTROLA G8 PLAY/ONE MACRO', '', 74, 'TIPO', 'G8 PLAY', '', '', 40.00, 80.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (335, 'PMG9P', 'PANTALLA MOTOROLA G9 POWER', '', 74, 'TIPO', 'G9 POWER', '', '', 40.00, 50.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (336, 'POPA16', 'PANTALLA OPPO A16', '', 74, 'TIPO', 'A16', '', '', 37.00, 47.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (337, 'POPA54', 'PANTALLA OPPO A54 4G', '', 74, 'TIPO', 'A54 4G', '', '', 39.00, 49.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (338, 'POPY20', 'PANTALLA OPPO Y20/Y20S/Y20I', '', 74, 'TIPO', 'Y20', '', '', 39.00, 49.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (339, 'PR13C', 'PANTALLA REDMI 13C/POCO C65', '', 74, 'TIPO', '13C', '', '', 37.00, 47.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (340, 'PR14C', 'PANTALLA REDMI 14C', '', 74, 'TIPO', '14C', '', '', 40.00, 50.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (341, 'PR9PM2', 'PANTALLA REDMI 9 POCO M2', '', 74, 'TIPO', 'M2', '', '', 36.00, 46.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (342, 'PR9TM3', 'PANTALLA REDMI 9T/POCO M3 ORIGINAL', '', 74, 'TIPO', '9T', '', '', 37.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (343, 'PRN12', 'PANTALLA NOTE 12 4G INCELL', '', 74, 'TIPO', 'NOTE 12', '', '', 40.00, 53.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (344, 'PRNOTE9', 'PANTALLA REDMI NOTE 9', '', 74, 'TIPO', 'REDMINNOTE', '', '', 36.00, 46.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (345, 'PRNOTE9PRO9S', 'PANTALLA REDNI NOTE 9PRO NOTE 9S', '', 74, 'TIPO', 'NOTE', '', '', 37.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (346, 'PSA03C', 'PANTALLA SAMSUNG A03 CORE', '', 74, 'TIPO', 'A03 CORE', '', '', 35.00, 45.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (347, 'PSA04S', 'PANTALLA SAMSUNG A04S/A13 5G', '', 74, 'TIPO', 'A04S', '', '', 37.00, 47.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (348, 'PSA06', 'PANTALLA SAMSUNG A06', '', 74, 'TIPO', 'A06', '', '', 35.00, 40.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (349, 'PSA144G', 'PANTALLA SAMSUNG A14 4G', '', 74, 'TIPO', 'A14 4G', '', '', 40.00, 50.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (350, 'PSA20CM', 'PANTALLA SAMSUNG A20 CON MARCO', '', 74, 'TIPO', 'A20', '', '', 38.00, 48.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (351, 'PULS4PIP', 'PULSADOR BOTON DE 4 PINES IPHONE', '', 79, 'TIPO', '4 PIN', '', '', 3.00, 35.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (352, 'PZA02520', 'PANTALLA ZTE A5 2020 / A7 2019', '', 74, 'TIPO', 'A05', '', '', 40.00, 50.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (353, 'PZA34', 'PANTALLA ZTA A34/54', '', 74, 'TIPO', 'A34', '', '', 38.00, 48.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (354, 'PZTEA17', 'PANTALLA ZTE A17/A57/A77', '', 74, 'TIPO', 'A17', '', '', 39.00, 49.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (355, 'PZTEV40V', 'PANTALLA V40 VITA/V40 SMART/A72/A72S', '', 74, 'TIPO', 'V40VITA', '', '', 44.00, 55.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (356, 'PZV40D', 'PANTALLA ZTE V40 DESIG', '', 74, 'TIPO', 'V40DESIG', '', '', 45.00, 55.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (357, 'RD4058', 'CARGADOR PARA CARRO REDD 5.5A V8', '', 70, 'REDD', 'C V8', '', '', 10.00, 10.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (358, 'RD6034', 'CARGADOR REDD 3.1A TIPO V8', '', 70, 'REDD', 'V8', '', '', 4.70, 15.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (359, 'RD6136', 'CARGADOR REDD USB A TC 7.2A 80W', '', 69, 'REDD', 'USB A TC', '', '', 12.00, 25.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (360, 'RD8', 'CABEZAL REDD TURBO 6.2A 67W', '', 80, 'REDD', 'CABEZA', '', '', 6.00, 15.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (361, 'RD9', 'CABEZAL REDD TURBO 6.2A', '', 80, 'REDD', 'CABEZA', '', '', 6.00, 15.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (362, 'SC36MT', 'CARGADOR REDD 3.6A TIPO C', '', 69, 'REDD', 'TC A TC', '', '', 6.50, 15.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (363, 'TCC0110', 'CARGADOR ROMAX CARRO 60W 6.2A', '', 80, 'ROMAX', 'CARGADOR AUTO', '', '', 11.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (364, 'TCC0321', 'CARGADOR ORIGINAL 4.2A TC', '', 69, 'DW', 'USB A TC', '', '', 4.50, 15.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (365, 'TCC0338', 'CARGADOR ROMAX 6.2A 66W USB A TC', '', 69, 'ROMAX', 'USB A TC', '', '', 12.50, 20.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (366, 'TCC0373', 'CARGADOR ROMAX 6.2A 66W TIPO V8', '', 70, 'ROMAX', 'USB A V8', '', '', 13.00, 25.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (367, 'TCC0493', 'CARCADOR ROMAX TURBO POWER 6.2A 60W V8', '', 70, 'ROMAX', 'USB A V8', '', '', 12.50, 25.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (368, 'TCC0541', 'CARGADOR ROMAX 6.2A 60W USB A TC', '', 69, 'ROMAX', 'USB A TC', '', '', 10.00, 20.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (369, 'TCC0543', 'CARGADOR ROMAX 6.2A 60W USB A IPHONE', '', 81, 'ROMAX', 'USB A IPHONE', '', '', 10.50, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (370, 'TCD0050', 'CABLE ROMAX 5.5A TV8', '', 71, 'ROMAX', 'TV8', '', '', 4.50, 15.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (371, 'TCD0240', 'CABLE ROMAX 6A TV8', '', 71, 'ROMAX', 'TV8', '', '', 5.00, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (372, 'TCD0558', 'CABLE ROMAX 6A 66W USB A IPHONE', '', 72, 'ROMAX', 'USB A IPHONE', '', '', 5.00, 15.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (373, 'TCD0562', 'CABLE ROMAX 6A 100W TC A TC', '', 83, 'ROMAX', 'TC A TC', '', '', 12.00, 20.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (374, 'TCD0609', 'OTG ROMAX C A USB', '', 64, 'ROMAX', 'C A USB', '', '', 4.80, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (375, 'TCD468', 'CABLE ROMAX 6A 55W USB A TC', '', 83, 'ROMAX', 'USB A TC', '', '', 3.80, 18.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (376, 'TX21V', 'CABLE TRANYCO 6A TV8', '', 70, 'TRANYCO', 'TV8', '', '', 6.80, 20.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (377, 'ZCLMTV8G1', 'ZOCALO MOTOROLA V8 G1', '', 84, 'TIPO', 'G1', '', '', 0.80, 1.00, 93.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (378, 'ZTCA02S', 'ZOCALO TIPO C SAMSUNG A02S A11 A13 A15', '', 85, 'TIPO', 'A02S', '', '', 0.30, 2.00, 89.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (379, 'ZTCA20', 'ZOCALO TIPO C SAMSUNG A20/A30/A50', '', 85, 'TIPO', 'A20', '', '', 0.60, 20.00, 61.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (380, 'ZTCA80', 'ZOCALO TIPO C SAMSUNG A80', '', 85, 'TIPO', 'A80', '', '', 2.50, 30.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (381, 'ZTCC20', 'ZOCALO TIPO C SAMSUNG S20', '', 85, 'TIPO', 'C20', '', '', 1.00, 2.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (382, 'ZTCG7PLUS', 'ZOCALO TIPO C MOTOROLA G7 PLUS', '', 85, 'TIPO', 'G7PLUS', '', '', 1.00, 10.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (383, 'ZTCHP10', 'ZOCALO TIPO C HUAWEI P10', '', 85, 'TIPO', 'P10', '', '', 2.50, 30.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (384, 'ZTCHP30', 'ZOCALO TIPO C HUAWEI P30', '', 85, 'TIPO', 'P30', '', '', 5.00, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (385, 'ZTCHP9', 'ZOCALO TIPO C HUAWEI P9', '', 85, 'TIPO', 'P9', '', '', 1.00, 2.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (386, 'ZTCHY718', 'ZOCALO V8 HUAWEI Y7 2018', '', 84, 'TIPO', 'Y7', '', '', 0.60, 20.00, 142.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (387, 'ZTCK51S', 'ZOCALO TIPO C LG K50/K51S', '', 85, 'TIPO', 'K51S', '', '', 5.00, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (388, 'ZTCLGV30', 'ZOCALO TIPO C LG V30', '', 85, 'TIPO', 'LGV30', '', '', 2.50, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (389, 'ZTCNT11P', 'ZOCALO TIPO C REDMI NOTE 11 PRO', '', 85, 'TIPO', 'NT11P', '', '', 2.50, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (390, 'ZTCOP2', 'ZOCALO TIPO C OPPO Y REALME 2', '', 85, 'TIPO', 'OP2', '', '', 2.50, 30.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (391, 'ZTCOPR1', 'ZOCALO TIPO C OPPO Y REALME 1', '', 85, 'TIPO', 'OPR1', '', '', 2.50, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (392, 'ZTCP', 'ZOCALO TIPO C PARLANTES', '', 85, 'TIPO', 'PARLANTE', '', '', 1.00, 30.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (393, 'ZTCR10C', 'ZOCALO TIPO C REDMI 10C', '', 85, 'TIPO', '10C', '', '', 2.50, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (394, 'ZTCR7AL11', 'ZOCALO TIPO C REDMI 7 AL 11', '', 85, 'TIPO', 'R7AL11', '', '', 1.00, 2.00, 84.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (395, 'ZTCSA20S', 'ZOCALO SAMSUNG A20S A21 LG K41S K61', '', 85, 'TIPO', 'SA20S', '', '', 1.00, 2.00, 93.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (396, 'ZTCSA5', 'ZOCALO TIPO C SAMSUNG A5 2017', '', 85, 'TIPO', 'A5', '', '', 2.50, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (397, 'ZTCSA7', 'ZOCALO TIPO C TABLET SAMSUNG A7(2019)', '', 85, 'TIPO', 'A7', '', '', 2.50, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (398, 'ZTCSA8', 'ZOCALO TC SAMSUNG A8S', '', 85, 'TIPO', 'A8', '', '', 5.00, 30.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (399, 'ZTCSL1', 'ZOCALO TIPO C SONY L1', '', 85, 'TIPO', 'L1', '', '', 1.00, 30.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (400, 'ZTCSS10', 'ZOCALO TIPO C SAMSUNG S10', '', 85, 'TIPO', 'S10', '', '', 5.00, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (401, 'ZTCTA', 'ZOCALO TIPO C TABLET ADVANCE', '', 85, 'TIPO', 'TA', '', '', 2.50, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (402, 'ZTCV30VT', 'ZOCALO TIPO C ZTE V30 VITA', '', 85, 'TIPO', 'V30VITA', '', '', 2.50, 30.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (403, 'ZTCXM10', 'ZOCALO TIPO C XIOMI MI 10', '', 85, 'TIPO', 'XM10', '', '', 5.00, 30.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (404, 'ZTCXM9L', 'ZOCALO TIPO C XIOMI MI 9LITE', '', 85, 'TIPO', 'XM9L', '', '', 2.00, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (405, 'ZTCY3050', 'ZOCALO TIPO C VIVO Y30/Y50/Y70S', '', 85, 'TIPO', 'Y3050', '', '', 2.50, 30.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (406, 'ZTV8SA10S', 'ZOCALO V8 SAMSUNG A10S', '', 84, 'TIPO', 'A10S', '', '', 0.60, 20.00, 152.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (407, 'ZV3A', 'ZOCALO V3 ADAPTABLE', '', 86, 'TIPO', 'V3', '', '', 0.60, 20.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (408, 'ZV80R3', 'ZOCALO V8 OPPO REALME 3 PRO 5 5I 5S C2 A8 A15 A12 A31', '', 84, 'TIPO', 'REALME 3 PRO', '', '', 0.60, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (409, 'ZV80R4', 'ZOCALO V8 OPPO REALME 1', '', 84, 'TIPO', 'REALME 1', '', '', 0.60, 20.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (410, 'ZV8A10', 'ZOCALO V8 ADAPTABLE A10', '', 84, 'TIPO', 'A10', '', '', 0.60, 20.00, 31.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (411, 'ZV8HP8L', 'ZOCALO V8 HUAWEI P8 LITE', '', 84, 'TIPO', 'P8', '', '', 0.60, 20.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (412, 'ZV8HY6II', 'ZOCALO V8 HUAWEY Y6 II', '', 84, 'TIPO', 'Y6', '', '', 0.60, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (413, 'ZV8LGG4', 'ZOCALO V8 LG G4', '', 84, 'TIPO', 'G4', '', '', 0.60, 20.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (414, 'ZV8LGK10', 'ZOCALO V8 LG K10', '', 84, 'TIPO', 'K10', '', '', 0.60, 20.00, 13.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (415, 'ZV8MC', 'ZOCALO V8 MOTOROLA MOTO C', '', 84, 'TIPO', 'MOTO C', '', '', 0.60, 20.00, 75.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (416, 'ZV8MG2', 'ZOCALO V8 MOTOROLA G2', '', 84, 'TIPO', 'G2', '', '', 0.60, 20.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (417, 'ZV8MG4', 'ZOCALO V8 MOTOROLA G4 / G4 PLUS', '', 84, 'TIPO', 'G4', '', '', 0.60, 20.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (418, 'ZV8MG5', 'ZOCALO V8 MOTOROLA G5 / G5 PLUS', '', 84, 'TIPO', 'G5', '', '', 0.60, 20.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (419, 'ZV8OR2', 'ZOCALO V8 OPPO REALME 2 / 2VPRO / C', '', 84, 'TIPO', 'REALME 2', '', '', 0.60, 20.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (420, 'ZV8R9A', 'ZOCALO V8 REDMI 9A/9C POCO', '', 84, 'TIPO', '9A', '', '', 0.60, 20.00, 70.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (421, 'ZV8SEX1', 'ZOCALO TIPO V8 SONY EXPERI Z1', '', 84, 'TIPO', 'Z1', '', '', 0.50, 1.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (422, 'ZV8SGT4', 'ZOCALO V8 SAMSUNG GALAXY TAB 4', '', 84, 'TIPO', 'GALAXY TAB 4', '', '', 0.60, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (423, 'ZV8SJ4', 'ZOCALO V8 SAMSUNG J4/ J4+', '', 70, 'TIPO', 'SJ4', '', '', 0.60, 20.00, 141.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (424, 'ZV8SJ7', 'ZOCALO V8 SAMSUNG J7/J2/J5', '', 84, 'TIPO', 'J7', '', '', 0.60, 20.00, 75.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (425, 'ZV8SS6', 'ZOCALO V8 SAMSUNG S6', '', 84, 'TIPO', 'S6', '', '', 0.60, 20.00, 14.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (426, 'ZV8SS7', 'ZOCALO V8 SAMSUNG S7', '', 84, 'TIPO', 'S7', '', '', 2.50, 30.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (427, 'ZV8ST3', 'ZOCALO V8 SAMSUNG TAB 3', '', 84, 'TIPO', 'TAB 3', '', '', 0.60, 20.00, 8.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (428, 'ZV8STE', 'ZOCALO V8 SAMSUNG TABLET TAB E', '', 84, 'TIPO', 'TAB E', '', '', 0.60, 20.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for servicio_repuestos
-- ----------------------------
DROP TABLE IF EXISTS `servicio_repuestos`;
CREATE TABLE `servicio_repuestos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `servicio_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL DEFAULT 1.00,
  `precio_referencial` decimal(10, 2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `servicio_id`(`servicio_id` ASC) USING BTREE,
  INDEX `producto_id`(`producto_id` ASC) USING BTREE,
  CONSTRAINT `sr_ibfk_1` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `sr_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicio_repuestos
-- ----------------------------
INSERT INTO `servicio_repuestos` VALUES (1, 13, 34, 1.00, 30.00);

-- ----------------------------
-- Table structure for servicios
-- ----------------------------
DROP TABLE IF EXISTS `servicios`;
CREATE TABLE `servicios`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `descripcion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `categoria` enum('diagnostico','reparacion','mantenimiento','instalacion','otro') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'reparacion',
  `precio` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `precio_minimo` decimal(10, 2) NULL DEFAULT NULL,
  `duracion_estimada` int NULL DEFAULT NULL COMMENT 'En minutos',
  `garantia_dias` int NOT NULL DEFAULT 30,
  `requiere_repuestos` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `notas` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicios
-- ----------------------------
INSERT INTO `servicios` VALUES (7, 'MANO DE OBRA PANTALLA 5', 'MANO DE OBRA POR PEGADO DE PANTALLA', 'instalacion', 5.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:33:12', '2026-06-07 17:35:06');
INSERT INTO `servicios` VALUES (8, 'MANO DE OBRA PANTALLA 10', 'MANO DE OBRA PEGADO DE PANTALLA', 'instalacion', 10.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:33:57', '2026-06-07 17:33:57');
INSERT INTO `servicios` VALUES (9, 'MANO DE OBRA PANTALLA 15', 'MANO DE OBRA PEGADO DE PANTALLA', 'instalacion', 15.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:34:47', '2026-06-07 17:36:17');
INSERT INTO `servicios` VALUES (10, 'MANO DE OBRA PANTALLA 20', 'MANO DE OBRA PEGADO DE PANTALLA', 'instalacion', 20.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:34:47', '2026-06-07 17:36:23');
INSERT INTO `servicios` VALUES (11, 'MANO DE OBRA PANTALLA 25', 'MANO DE OBRA PEGADO DE PANTALA', 'instalacion', 25.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:36:06', '2026-06-07 17:36:06');
INSERT INTO `servicios` VALUES (12, 'MANO DE OBRA PANTALLA 30', 'MANO DE OBRA PEGADO DE PANTALLA', 'instalacion', 30.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:37:02', '2026-06-07 17:37:02');
INSERT INTO `servicios` VALUES (13, 'PRUEBA', '', 'diagnostico', 35.00, NULL, NULL, 30, 1, 1, '', '2026-06-07 17:54:52', '2026-06-07 17:54:52');

-- ----------------------------
-- Table structure for stock_almacen
-- ----------------------------
DROP TABLE IF EXISTS `stock_almacen`;
CREATE TABLE `stock_almacen`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `almacen_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_alm_prod`(`almacen_id` ASC, `producto_id` ASC) USING BTREE,
  INDEX `idx_producto`(`producto_id` ASC) USING BTREE,
  CONSTRAINT `fk_sa_almacen` FOREIGN KEY (`almacen_id`) REFERENCES `almacenes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sa_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 857 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stock_almacen
-- ----------------------------
INSERT INTO `stock_almacen` VALUES (13, 1, 7, 997.00, '2026-06-07 10:42:47');
INSERT INTO `stock_almacen` VALUES (14, 2, 7, 0.00, '2026-06-07 10:28:55');
INSERT INTO `stock_almacen` VALUES (15, 1, 8, 10.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (16, 2, 8, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (17, 1, 9, 25.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (18, 2, 9, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (19, 1, 10, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (20, 2, 10, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (21, 1, 11, 11.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (22, 2, 11, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (23, 1, 12, 23.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (24, 2, 12, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (25, 1, 13, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (26, 2, 13, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (27, 1, 14, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (28, 2, 14, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (29, 1, 15, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (30, 2, 15, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (31, 1, 16, 12.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (32, 2, 16, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (33, 1, 17, 12.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (34, 2, 17, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (35, 1, 18, 15.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (36, 2, 18, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (37, 1, 19, 16.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (38, 2, 19, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (39, 1, 20, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (40, 2, 20, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (41, 1, 21, 4.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (42, 2, 21, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (43, 1, 22, 7.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (44, 2, 22, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (45, 1, 23, 12.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (46, 2, 23, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (47, 1, 24, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (48, 2, 24, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (49, 1, 25, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (50, 2, 25, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (51, 1, 26, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (52, 2, 26, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (53, 1, 27, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (54, 2, 27, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (55, 1, 28, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (56, 2, 28, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (57, 1, 29, 6.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (58, 2, 29, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (59, 1, 30, 4.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (60, 2, 30, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (61, 1, 31, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (62, 2, 31, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (63, 1, 32, 4.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (64, 2, 32, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (65, 1, 33, 5.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (66, 2, 33, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (67, 1, 34, 4.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (68, 2, 34, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (69, 1, 35, 5.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (70, 2, 35, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (71, 1, 36, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (72, 2, 36, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (73, 1, 37, 5.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (74, 2, 37, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (75, 1, 38, 11.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (76, 2, 38, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (77, 1, 39, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (78, 2, 39, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (79, 1, 40, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (80, 2, 40, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (81, 1, 41, 2.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (82, 2, 41, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (83, 1, 42, 13.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (84, 2, 42, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (85, 1, 43, 12.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (86, 2, 43, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (87, 1, 44, 13.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (88, 2, 44, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (89, 1, 45, 3.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (90, 2, 45, 0.00, '2026-06-07 16:56:22');
INSERT INTO `stock_almacen` VALUES (91, 1, 46, 10.00, '2026-06-07 17:00:16');
INSERT INTO `stock_almacen` VALUES (92, 2, 46, 0.00, '2026-06-07 17:00:16');
INSERT INTO `stock_almacen` VALUES (93, 1, 47, 25.00, '2026-06-07 17:00:16');
INSERT INTO `stock_almacen` VALUES (94, 2, 47, 0.00, '2026-06-07 17:00:16');
INSERT INTO `stock_almacen` VALUES (95, 1, 48, 0.00, '2026-06-12 11:35:12');
INSERT INTO `stock_almacen` VALUES (96, 2, 48, 0.00, '2026-06-12 11:35:12');
INSERT INTO `stock_almacen` VALUES (97, 1, 49, 0.00, '2026-06-12 11:35:12');
INSERT INTO `stock_almacen` VALUES (98, 2, 49, 0.00, '2026-06-12 11:35:12');
INSERT INTO `stock_almacen` VALUES (99, 1, 50, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (100, 2, 50, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (101, 1, 51, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (102, 2, 51, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (103, 1, 52, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (104, 2, 52, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (105, 1, 53, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (106, 2, 53, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (107, 1, 54, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (108, 2, 54, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (109, 1, 55, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (110, 2, 55, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (111, 1, 56, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (112, 2, 56, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (113, 1, 57, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (114, 2, 57, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (115, 1, 58, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (116, 2, 58, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (117, 1, 59, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (118, 2, 59, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (119, 1, 60, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (120, 2, 60, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (121, 1, 61, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (122, 2, 61, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (123, 1, 62, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (124, 2, 62, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (125, 1, 63, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (126, 2, 63, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (127, 1, 64, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (128, 2, 64, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (129, 1, 65, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (130, 2, 65, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (131, 1, 66, 128.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (132, 2, 66, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (133, 1, 67, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (134, 2, 67, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (135, 1, 68, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (136, 2, 68, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (137, 1, 69, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (138, 2, 69, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (139, 1, 70, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (140, 2, 70, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (141, 1, 71, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (142, 2, 71, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (143, 1, 72, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (144, 2, 72, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (145, 1, 73, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (146, 2, 73, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (147, 1, 74, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (148, 2, 74, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (149, 1, 75, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (150, 2, 75, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (151, 1, 76, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (152, 2, 76, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (153, 1, 77, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (154, 2, 77, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (155, 1, 78, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (156, 2, 78, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (157, 1, 79, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (158, 2, 79, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (159, 1, 80, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (160, 2, 80, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (161, 1, 81, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (162, 2, 81, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (163, 1, 82, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (164, 2, 82, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (165, 1, 83, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (166, 2, 83, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (167, 1, 84, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (168, 2, 84, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (169, 1, 85, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (170, 2, 85, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (171, 1, 86, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (172, 2, 86, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (173, 1, 87, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (174, 2, 87, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (175, 1, 88, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (176, 2, 88, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (177, 1, 89, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (178, 2, 89, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (179, 1, 90, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (180, 2, 90, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (181, 1, 91, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (182, 2, 91, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (183, 1, 92, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (184, 2, 92, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (185, 1, 93, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (186, 2, 93, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (187, 1, 94, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (188, 2, 94, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (189, 1, 95, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (190, 2, 95, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (191, 1, 96, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (192, 2, 96, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (193, 1, 97, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (194, 2, 97, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (195, 1, 98, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (196, 2, 98, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (197, 1, 99, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (198, 2, 99, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (199, 1, 100, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (200, 2, 100, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (201, 1, 101, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (202, 2, 101, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (203, 1, 102, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (204, 2, 102, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (205, 1, 103, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (206, 2, 103, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (207, 1, 104, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (208, 2, 104, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (209, 1, 105, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (210, 2, 105, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (211, 1, 106, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (212, 2, 106, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (213, 1, 107, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (214, 2, 107, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (215, 1, 108, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (216, 2, 108, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (217, 1, 109, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (218, 2, 109, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (219, 1, 110, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (220, 2, 110, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (221, 1, 111, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (222, 2, 111, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (223, 1, 112, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (224, 2, 112, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (225, 1, 113, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (226, 2, 113, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (227, 1, 114, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (228, 2, 114, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (229, 1, 115, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (230, 2, 115, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (231, 1, 116, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (232, 2, 116, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (233, 1, 117, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (234, 2, 117, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (235, 1, 118, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (236, 2, 118, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (237, 1, 119, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (238, 2, 119, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (239, 1, 120, 14.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (240, 2, 120, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (241, 1, 121, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (242, 2, 121, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (243, 1, 122, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (244, 2, 122, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (245, 1, 123, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (246, 2, 123, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (247, 1, 124, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (248, 2, 124, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (249, 1, 125, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (250, 2, 125, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (251, 1, 126, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (252, 2, 126, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (253, 1, 127, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (254, 2, 127, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (255, 1, 128, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (256, 2, 128, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (257, 1, 129, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (258, 2, 129, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (259, 1, 130, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (260, 2, 130, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (261, 1, 131, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (262, 2, 131, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (263, 1, 132, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (264, 2, 132, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (265, 1, 133, 19.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (266, 2, 133, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (267, 1, 134, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (268, 2, 134, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (269, 1, 135, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (270, 2, 135, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (271, 1, 136, 20.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (272, 2, 136, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (273, 1, 137, 17.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (274, 2, 137, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (275, 1, 138, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (276, 2, 138, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (277, 1, 139, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (278, 2, 139, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (279, 1, 140, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (280, 2, 140, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (281, 1, 141, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (282, 2, 141, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (283, 1, 142, 21.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (284, 2, 142, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (285, 1, 143, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (286, 2, 143, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (287, 1, 144, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (288, 2, 144, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (289, 1, 145, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (290, 2, 145, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (291, 1, 146, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (292, 2, 146, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (293, 1, 147, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (294, 2, 147, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (295, 1, 148, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (296, 2, 148, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (297, 1, 149, 19.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (298, 2, 149, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (299, 1, 150, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (300, 2, 150, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (301, 1, 151, 22.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (302, 2, 151, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (303, 1, 152, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (304, 2, 152, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (305, 1, 153, 16.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (306, 2, 153, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (307, 1, 154, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (308, 2, 154, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (309, 1, 155, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (310, 2, 155, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (311, 1, 156, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (312, 2, 156, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (313, 1, 157, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (314, 2, 157, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (315, 1, 158, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (316, 2, 158, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (317, 1, 159, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (318, 2, 159, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (319, 1, 160, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (320, 2, 160, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (321, 1, 161, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (322, 2, 161, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (323, 1, 162, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (324, 2, 162, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (325, 1, 163, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (326, 2, 163, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (327, 1, 164, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (328, 2, 164, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (329, 1, 165, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (330, 2, 165, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (331, 1, 166, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (332, 2, 166, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (333, 1, 167, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (334, 2, 167, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (335, 1, 168, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (336, 2, 168, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (337, 1, 169, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (338, 2, 169, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (339, 1, 170, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (340, 2, 170, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (341, 1, 171, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (342, 2, 171, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (343, 1, 172, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (344, 2, 172, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (345, 1, 173, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (346, 2, 173, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (347, 1, 174, 12.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (348, 2, 174, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (349, 1, 175, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (350, 2, 175, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (351, 1, 176, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (352, 2, 176, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (353, 1, 177, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (354, 2, 177, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (355, 1, 178, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (356, 2, 178, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (357, 1, 179, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (358, 2, 179, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (359, 1, 180, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (360, 2, 180, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (361, 1, 181, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (362, 2, 181, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (363, 1, 182, 12.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (364, 2, 182, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (365, 1, 183, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (366, 2, 183, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (367, 1, 184, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (368, 2, 184, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (369, 1, 185, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (370, 2, 185, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (371, 1, 186, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (372, 2, 186, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (373, 1, 187, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (374, 2, 187, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (375, 1, 188, 16.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (376, 2, 188, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (377, 1, 189, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (378, 2, 189, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (379, 1, 190, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (380, 2, 190, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (381, 1, 191, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (382, 2, 191, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (383, 1, 192, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (384, 2, 192, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (385, 1, 193, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (386, 2, 193, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (387, 1, 194, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (388, 2, 194, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (389, 1, 195, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (390, 2, 195, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (391, 1, 196, 19.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (392, 2, 196, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (393, 1, 197, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (394, 2, 197, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (395, 1, 198, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (396, 2, 198, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (397, 1, 199, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (398, 2, 199, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (399, 1, 200, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (400, 2, 200, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (401, 1, 201, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (402, 2, 201, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (403, 1, 202, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (404, 2, 202, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (405, 1, 203, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (406, 2, 203, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (407, 1, 204, 25.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (408, 2, 204, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (409, 1, 205, 12.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (410, 2, 205, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (411, 1, 206, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (412, 2, 206, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (413, 1, 207, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (414, 2, 207, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (415, 1, 208, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (416, 2, 208, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (417, 1, 209, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (418, 2, 209, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (419, 1, 210, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (420, 2, 210, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (421, 1, 211, 14.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (422, 2, 211, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (423, 1, 212, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (424, 2, 212, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (425, 1, 213, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (426, 2, 213, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (427, 1, 214, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (428, 2, 214, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (429, 1, 215, 16.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (430, 2, 215, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (431, 1, 216, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (432, 2, 216, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (433, 1, 217, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (434, 2, 217, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (435, 1, 218, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (436, 2, 218, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (437, 1, 219, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (438, 2, 219, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (439, 1, 220, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (440, 2, 220, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (441, 1, 221, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (442, 2, 221, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (443, 1, 222, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (444, 2, 222, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (445, 1, 223, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (446, 2, 223, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (447, 1, 224, 19.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (448, 2, 224, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (449, 1, 225, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (450, 2, 225, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (451, 1, 226, 18.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (452, 2, 226, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (453, 1, 227, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (454, 2, 227, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (455, 1, 228, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (456, 2, 228, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (457, 1, 229, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (458, 2, 229, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (459, 1, 230, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (460, 2, 230, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (461, 1, 231, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (462, 2, 231, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (463, 1, 232, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (464, 2, 232, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (465, 1, 233, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (466, 2, 233, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (467, 1, 234, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (468, 2, 234, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (469, 1, 235, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (470, 2, 235, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (471, 1, 236, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (472, 2, 236, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (473, 1, 237, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (474, 2, 237, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (475, 1, 238, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (476, 2, 238, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (477, 1, 239, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (478, 2, 239, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (479, 1, 240, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (480, 2, 240, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (481, 1, 241, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (482, 2, 241, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (483, 1, 242, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (484, 2, 242, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (485, 1, 243, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (486, 2, 243, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (487, 1, 244, 12.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (488, 2, 244, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (489, 1, 245, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (490, 2, 245, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (491, 1, 246, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (492, 2, 246, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (493, 1, 247, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (494, 2, 247, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (495, 1, 248, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (496, 2, 248, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (497, 1, 249, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (498, 2, 249, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (499, 1, 250, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (500, 2, 250, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (501, 1, 251, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (502, 2, 251, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (503, 1, 252, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (504, 2, 252, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (505, 1, 253, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (506, 2, 253, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (507, 1, 254, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (508, 2, 254, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (509, 1, 255, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (510, 2, 255, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (511, 1, 256, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (512, 2, 256, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (513, 1, 257, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (514, 2, 257, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (515, 1, 258, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (516, 2, 258, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (517, 1, 259, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (518, 2, 259, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (519, 1, 260, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (520, 2, 260, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (521, 1, 261, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (522, 2, 261, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (523, 1, 262, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (524, 2, 262, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (525, 1, 263, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (526, 2, 263, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (527, 1, 264, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (528, 2, 264, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (529, 1, 265, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (530, 2, 265, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (531, 1, 266, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (532, 2, 266, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (533, 1, 267, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (534, 2, 267, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (535, 1, 268, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (536, 2, 268, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (537, 1, 269, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (538, 2, 269, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (539, 1, 270, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (540, 2, 270, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (541, 1, 271, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (542, 2, 271, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (543, 1, 272, 13.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (544, 2, 272, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (545, 1, 273, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (546, 2, 273, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (547, 1, 274, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (548, 2, 274, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (549, 1, 275, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (550, 2, 275, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (551, 1, 276, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (552, 2, 276, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (553, 1, 277, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (554, 2, 277, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (555, 1, 278, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (556, 2, 278, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (557, 1, 279, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (558, 2, 279, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (559, 1, 280, 7.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (560, 2, 280, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (561, 1, 281, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (562, 2, 281, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (563, 1, 282, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (564, 2, 282, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (565, 1, 283, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (566, 2, 283, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (567, 1, 284, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (568, 2, 284, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (569, 1, 285, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (570, 2, 285, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (571, 1, 286, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (572, 2, 286, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (573, 1, 287, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (574, 2, 287, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (575, 1, 288, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (576, 2, 288, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (577, 1, 289, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (578, 2, 289, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (579, 1, 290, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (580, 2, 290, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (581, 1, 291, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (582, 2, 291, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (583, 1, 292, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (584, 2, 292, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (585, 1, 293, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (586, 2, 293, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (587, 1, 294, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (588, 2, 294, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (589, 1, 295, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (590, 2, 295, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (591, 1, 296, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (592, 2, 296, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (593, 1, 297, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (594, 2, 297, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (595, 1, 298, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (596, 2, 298, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (597, 1, 299, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (598, 2, 299, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (599, 1, 300, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (600, 2, 300, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (601, 1, 301, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (602, 2, 301, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (603, 1, 302, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (604, 2, 302, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (605, 1, 303, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (606, 2, 303, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (607, 1, 304, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (608, 2, 304, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (609, 1, 305, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (610, 2, 305, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (611, 1, 306, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (612, 2, 306, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (613, 1, 307, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (614, 2, 307, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (615, 1, 308, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (616, 2, 308, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (617, 1, 309, 10.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (618, 2, 309, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (619, 1, 310, 11.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (620, 2, 310, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (621, 1, 311, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (622, 2, 311, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (623, 1, 312, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (624, 2, 312, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (625, 1, 313, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (626, 2, 313, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (627, 1, 314, 8.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (628, 2, 314, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (629, 1, 315, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (630, 2, 315, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (631, 1, 316, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (632, 2, 316, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (633, 1, 317, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (634, 2, 317, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (635, 1, 318, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (636, 2, 318, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (637, 1, 319, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (638, 2, 319, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (639, 1, 320, 6.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (640, 2, 320, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (641, 1, 321, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (642, 2, 321, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (643, 1, 322, 9.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (644, 2, 322, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (645, 1, 323, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (646, 2, 323, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (647, 1, 324, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (648, 2, 324, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (649, 1, 325, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (650, 2, 325, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (651, 1, 326, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (652, 2, 326, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (653, 1, 327, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (654, 2, 327, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (655, 1, 328, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (656, 2, 328, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (657, 1, 329, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (658, 2, 329, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (659, 1, 330, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (660, 2, 330, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (661, 1, 331, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (662, 2, 331, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (663, 1, 332, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (664, 2, 332, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (665, 1, 333, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (666, 2, 333, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (667, 1, 334, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (668, 2, 334, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (669, 1, 335, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (670, 2, 335, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (671, 1, 336, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (672, 2, 336, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (673, 1, 337, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (674, 2, 337, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (675, 1, 338, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (676, 2, 338, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (677, 1, 339, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (678, 2, 339, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (679, 1, 340, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (680, 2, 340, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (681, 1, 341, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (682, 2, 341, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (683, 1, 342, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (684, 2, 342, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (685, 1, 343, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (686, 2, 343, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (687, 1, 344, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (688, 2, 344, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (689, 1, 345, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (690, 2, 345, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (691, 1, 346, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (692, 2, 346, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (693, 1, 347, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (694, 2, 347, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (695, 1, 348, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (696, 2, 348, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (697, 1, 349, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (698, 2, 349, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (699, 1, 350, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (700, 2, 350, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (701, 1, 351, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (702, 2, 351, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (703, 1, 352, 3.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (704, 2, 352, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (705, 1, 353, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (706, 2, 353, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (707, 1, 354, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (708, 2, 354, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (709, 1, 355, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (710, 2, 355, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (711, 1, 356, 1.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (712, 2, 356, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (713, 1, 357, 5.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (714, 2, 357, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (715, 1, 358, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (716, 2, 358, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (717, 1, 359, 4.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (718, 2, 359, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (719, 1, 360, 2.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (720, 2, 360, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (721, 1, 361, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (722, 2, 361, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (723, 1, 362, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (724, 2, 362, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (725, 1, 363, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (726, 2, 363, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (727, 1, 364, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (728, 2, 364, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (729, 1, 365, 6.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (730, 2, 365, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (731, 1, 366, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (732, 2, 366, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (733, 1, 367, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (734, 2, 367, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (735, 1, 368, 5.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (736, 2, 368, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (737, 1, 369, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (738, 2, 369, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (739, 1, 370, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (740, 2, 370, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (741, 1, 371, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (742, 2, 371, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (743, 1, 372, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (744, 2, 372, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (745, 1, 373, 9.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (746, 2, 373, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (747, 1, 374, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (748, 2, 374, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (749, 1, 375, 5.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (750, 2, 375, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (751, 1, 376, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (752, 2, 376, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (753, 1, 377, 93.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (754, 2, 377, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (755, 1, 378, 89.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (756, 2, 378, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (757, 1, 379, 61.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (758, 2, 379, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (759, 1, 380, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (760, 2, 380, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (761, 1, 381, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (762, 2, 381, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (763, 1, 382, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (764, 2, 382, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (765, 1, 383, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (766, 2, 383, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (767, 1, 384, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (768, 2, 384, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (769, 1, 385, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (770, 2, 385, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (771, 1, 386, 142.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (772, 2, 386, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (773, 1, 387, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (774, 2, 387, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (775, 1, 388, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (776, 2, 388, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (777, 1, 389, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (778, 2, 389, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (779, 1, 390, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (780, 2, 390, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (781, 1, 391, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (782, 2, 391, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (783, 1, 392, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (784, 2, 392, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (785, 1, 393, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (786, 2, 393, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (787, 1, 394, 84.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (788, 2, 394, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (789, 1, 395, 93.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (790, 2, 395, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (791, 1, 396, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (792, 2, 396, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (793, 1, 397, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (794, 2, 397, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (795, 1, 398, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (796, 2, 398, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (797, 1, 399, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (798, 2, 399, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (799, 1, 400, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (800, 2, 400, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (801, 1, 401, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (802, 2, 401, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (803, 1, 402, 2.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (804, 2, 402, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (805, 1, 403, 6.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (806, 2, 403, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (807, 1, 404, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (808, 2, 404, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (809, 1, 405, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (810, 2, 405, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (811, 1, 406, 152.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (812, 2, 406, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (813, 1, 407, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (814, 2, 407, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (815, 1, 408, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (816, 2, 408, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (817, 1, 409, 9.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (818, 2, 409, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (819, 1, 410, 31.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (820, 2, 410, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (821, 1, 411, 5.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (822, 2, 411, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (823, 1, 412, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (824, 2, 412, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (825, 1, 413, 12.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (826, 2, 413, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (827, 1, 414, 13.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (828, 2, 414, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (829, 1, 415, 75.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (830, 2, 415, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (831, 1, 416, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (832, 2, 416, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (833, 1, 417, 1.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (834, 2, 417, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (835, 1, 418, 4.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (836, 2, 418, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (837, 1, 419, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (838, 2, 419, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (839, 1, 420, 70.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (840, 2, 420, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (841, 1, 421, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (842, 2, 421, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (843, 1, 422, 3.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (844, 2, 422, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (845, 1, 423, 141.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (846, 2, 423, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (847, 1, 424, 75.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (848, 2, 424, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (849, 1, 425, 14.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (850, 2, 425, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (851, 1, 426, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (852, 2, 426, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (853, 1, 427, 8.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (854, 2, 427, 0.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (855, 1, 428, 7.00, '2026-06-12 11:37:28');
INSERT INTO `stock_almacen` VALUES (856, 2, 428, 0.00, '2026-06-12 11:37:28');

-- ----------------------------
-- Table structure for tipos_equipo
-- ----------------------------
DROP TABLE IF EXISTS `tipos_equipo`;
CREATE TABLE `tipos_equipo`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `icono` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'laptop',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tipos_equipo
-- ----------------------------
INSERT INTO `tipos_equipo` VALUES (1, 'Laptop', 'laptop', 1);
INSERT INTO `tipos_equipo` VALUES (7, 'Smartphone', 'smartphone', 1);
INSERT INTO `tipos_equipo` VALUES (8, 'Impresora', 'printer', 1);
INSERT INTO `tipos_equipo` VALUES (14, 'Ps5 Slim', 'package', 1);

-- ----------------------------
-- Table structure for traslado_detalle
-- ----------------------------
DROP TABLE IF EXISTS `traslado_detalle`;
CREATE TABLE `traslado_detalle`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `traslado_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_traslado`(`traslado_id` ASC) USING BTREE,
  INDEX `idx_producto`(`producto_id` ASC) USING BTREE,
  CONSTRAINT `fk_td_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_td_traslado` FOREIGN KEY (`traslado_id`) REFERENCES `traslados` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of traslado_detalle
-- ----------------------------

-- ----------------------------
-- Table structure for traslados
-- ----------------------------
DROP TABLE IF EXISTS `traslados`;
CREATE TABLE `traslados`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `almacen_origen` int UNSIGNED NOT NULL,
  `almacen_destino` int UNSIGNED NOT NULL,
  `estado` enum('borrador','en_transito','recibido','anulado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'recibido',
  `observacion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `usuario_id` int UNSIGNED NOT NULL,
  `usuario_recibe` int UNSIGNED NULL DEFAULT NULL,
  `total_items` int UNSIGNED NOT NULL DEFAULT 0,
  `total_unidades` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `recibido_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `idx_origen`(`almacen_origen` ASC) USING BTREE,
  INDEX `idx_destino`(`almacen_destino` ASC) USING BTREE,
  INDEX `idx_estado`(`estado` ASC) USING BTREE,
  INDEX `fk_tr_usuario`(`usuario_id` ASC) USING BTREE,
  CONSTRAINT `fk_tr_destino` FOREIGN KEY (`almacen_destino`) REFERENCES `almacenes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tr_origen` FOREIGN KEY (`almacen_origen`) REFERENCES `almacenes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tr_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of traslados
-- ----------------------------

-- ----------------------------
-- Table structure for usuarios
-- ----------------------------
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `rol` enum('admin','tecnico','vendedor') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'tecnico',
  `telefono` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `ultimo_acceso` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuarios
-- ----------------------------
INSERT INTO `usuarios` VALUES (1, 'Administrador', 'Sistema', 'admin@mrtech.com', '$2y$10$pZEk0vSEGqKzCYlzddismeHer0lfzXHj2UWq0N65NBCrtUo4lnmdq', 'admin', NULL, NULL, 1, '2026-06-12 16:57:24', '2026-04-13 08:46:29', '2026-06-12 16:57:24');
INSERT INTO `usuarios` VALUES (4, 'Valentina', 'Teran Orellana', 'caja@mrtech.com', '$2y$10$ofEJjyXEve4A.oFzasF2PO6w.MTrJ0C50A/jdf5HKrexsRGAXTdIu', 'vendedor', '934420779', NULL, 1, '2026-06-11 09:33:21', '2026-06-07 09:30:09', '2026-06-11 09:33:21');
INSERT INTO `usuarios` VALUES (5, 'MIGUEL', 'RODRIGUEZ LUGO', 'tecmiguel@mrtech.com', '$2y$10$956d3/iQsKbqq4e/Kl/bme9kMQU5rIPIr7abvqQOsKnBZZQ1eZX9y', 'tecnico', '934701423', NULL, 1, NULL, '2026-06-07 17:05:06', '2026-06-07 17:05:06');
INSERT INTO `usuarios` VALUES (6, 'ANDRIWS', 'FLORES RODRIGUEZ', 'tecandriws@mrtech.com', '$2y$10$vijhMOINZ7Zpv27QNa8k3.jat9Y9PvniZLRAnLYB1zxkAtQBCjINi', 'tecnico', '922097542', NULL, 1, NULL, '2026-06-07 17:07:09', '2026-06-07 17:07:09');
INSERT INTO `usuarios` VALUES (7, 'FRANKLIN', 'MONTIEL PADRON', 'tecfrankin@mrtech.com', '$2y$10$B5q7MzC2iDl7Uz/goJRlH.L0GCivH0/t.WHrB1E9cs3sSKJnsKPTa', 'tecnico', '924413438', NULL, 1, NULL, '2026-06-07 17:09:59', '2026-06-07 17:09:59');
INSERT INTO `usuarios` VALUES (8, 'Manu', 'demo', 'manu@gmail.com', '$2y$10$XST.zhIS5/jn0Y8naFCf9.RCx38IwDt0mNaR/Hp9o4WqqiS41tpXW', 'vendedor', '', NULL, 1, '2026-06-11 07:54:00', '2026-06-11 07:53:41', '2026-06-11 07:54:00');

-- ----------------------------
-- Table structure for venta_detalle
-- ----------------------------
DROP TABLE IF EXISTS `venta_detalle`;
CREATE TABLE `venta_detalle`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `venta_id` int UNSIGNED NOT NULL,
  `producto_id` int UNSIGNED NOT NULL,
  `cantidad` decimal(10, 2) NOT NULL,
  `precio_unit` decimal(10, 2) NOT NULL,
  `descuento` decimal(10, 2) NULL DEFAULT 0.00,
  `subtotal` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `venta_id`(`venta_id` ASC) USING BTREE,
  INDEX `producto_id`(`producto_id` ASC) USING BTREE,
  CONSTRAINT `venta_detalle_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `venta_detalle_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of venta_detalle
-- ----------------------------
INSERT INTO `venta_detalle` VALUES (8, 8, 7, 1.00, 5.00, 0.00, 5.00);
INSERT INTO `venta_detalle` VALUES (9, 9, 7, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (10, 10, 7, 1.00, 10.00, 0.00, 10.00);

-- ----------------------------
-- Table structure for venta_pagos
-- ----------------------------
DROP TABLE IF EXISTS `venta_pagos`;
CREATE TABLE `venta_pagos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `venta_id` int UNSIGNED NOT NULL,
  `metodo` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(10, 2) NOT NULL,
  `referencia` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Nº operación Yape/Plin/transferencia',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_venta`(`venta_id` ASC) USING BTREE,
  INDEX `idx_metodo`(`metodo` ASC) USING BTREE,
  CONSTRAINT `fk_vp_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of venta_pagos
-- ----------------------------
INSERT INTO `venta_pagos` VALUES (8, 8, 'efectivo', 5.00, NULL, '2026-06-07 10:36:49');
INSERT INTO `venta_pagos` VALUES (9, 9, 'efectivo', 20.00, NULL, '2026-06-07 10:40:29');
INSERT INTO `venta_pagos` VALUES (10, 10, 'efectivo', 10.01, NULL, '2026-06-07 10:42:47');

-- ----------------------------
-- Table structure for ventas
-- ----------------------------
DROP TABLE IF EXISTS `ventas`;
CREATE TABLE `ventas`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'VTA-2024-0001',
  `cliente_id` int UNSIGNED NULL DEFAULT NULL,
  `usuario_id` int UNSIGNED NOT NULL,
  `vendedor_id` int UNSIGNED NULL DEFAULT NULL,
  `tipo_doc` enum('boleta','factura','ticket','sin_comprobante') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'boleta',
  `serie_doc` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `num_doc` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `subtotal` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `igv` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `descuento` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `codigo_descuento_id` int UNSIGNED NULL DEFAULT NULL,
  `total` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `metodo_pago` enum('efectivo','yape','plin','tarjeta','transferencia','mixto') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'efectivo',
  `monto_pagado` decimal(10, 2) NULL DEFAULT NULL,
  `vuelto` decimal(10, 2) NULL DEFAULT 0.00,
  `estado` enum('completada','anulada','pendiente') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'completada',
  `notas` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  INDEX `idx_fecha`(`created_at` ASC) USING BTREE,
  INDEX `idx_estado`(`estado` ASC) USING BTREE,
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (8, 'VTA-2026-0001', NULL, 4, 4, 'ticket', NULL, NULL, 4.24, 0.76, 0.76, NULL, 5.00, 'efectivo', 5.00, 0.00, 'completada', NULL, '2026-06-07 10:36:49');
INSERT INTO `ventas` VALUES (9, 'VTA-2026-0002', NULL, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 3.05, NULL, 20.00, 'efectivo', 20.00, 0.00, 'completada', NULL, '2026-06-07 10:40:29');
INSERT INTO `ventas` VALUES (10, 'VTA-2026-0003', NULL, 4, 4, 'ticket', NULL, NULL, 8.48, 1.53, 1.52, NULL, 10.01, 'efectivo', 10.01, 0.00, 'completada', NULL, '2026-06-07 10:42:47');

-- ----------------------------
-- Table structure for wa_plantillas
-- ----------------------------
DROP TABLE IF EXISTS `wa_plantillas`;
CREATE TABLE `wa_plantillas`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` enum('reparacion','venta','general') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'general',
  `texto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `usuario_id` int UNSIGNED NULL DEFAULT NULL,
  `activo` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_plantillas
-- ----------------------------
INSERT INTO `wa_plantillas` VALUES (1, 'Equipo listo para recoger', 'reparacion', 'Hola {nombre} í ½í±\n\nÂ¡Tu equipo ya estÃ¡ *listo para recoger* en {empresa}! í ¼í¾\n\nCÃ³digo OT: *{codigo_ot}*\nCÃ³digo consulta: *{codigo_consulta}*\n\nRecuerda traer tu DNI. Â¡Te esperamos!', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (2, 'Equipo en reparaciÃ³n', 'reparacion', 'Hola {nombre}, tu equipo estÃ¡ siendo reparado en {empresa} í ½í´§\n\nOT: *{codigo_ot}*\n\nTe avisamos en cuanto estÃ© listo.', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (3, 'Presupuesto para aprobaciÃ³n', 'reparacion', 'Hola {nombre} í ½í±\n\nHemos revisado tu equipo en {empresa} y el presupuesto estÃ¡ listo.\n\nOT: *{codigo_ot}*\nTotal: *{total}*\n\nResponde para confirmar. Â¡Gracias!', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (4, 'Equipo entregado - Gracias', 'reparacion', 'Â¡Gracias por confiar en {empresa}! í ½í¹\n\nTu equipo fue entregado correctamente.\nOT: *{codigo_ot}*\n\nRecuerda que tienes garantÃ­a. Â¡Hasta pronto!', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (5, 'Recordatorio de recojo', 'reparacion', 'Hola {nombre}, te recordamos que tu equipo lleva varios dÃ­as listo en {empresa}.\n\nOT: *{codigo_ot}*\n\nPor favor coordina el recojo. Â¡Gracias!', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (6, 'Consulta estado en lÃ­nea', 'reparacion', 'Hola {nombre} í ½í´\n\nPuedes consultar el estado de tu reparaciÃ³n en lÃ­nea con tu cÃ³digo: *{codigo_consulta}*', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (7, 'DiagnÃ³stico listo', 'reparacion', 'Hola {nombre}, ya tenemos el diagnÃ³stico de tu equipo en {empresa} í ½í´¬\n\nOT: *{codigo_ot}*\nFecha estimada: *{fecha_estimada}*\n\nÂ¿Deseas que procedamos con la reparaciÃ³n?', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (8, 'PromociÃ³n / Oferta especial', 'venta', 'Hola {nombre} í ½í±\n\n{empresa} tiene ofertas especiales para ti esta semana. VisÃ­tanos o escrÃ­benos para mÃ¡s informaciÃ³n. Â¡Te esperamos!', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (9, 'CotizaciÃ³n de producto', 'venta', 'Hola {nombre}, gracias por tu consulta en {empresa} í ½í¸\n\nTe enviamos la cotizaciÃ³n solicitada. Â¿Tienes alguna pregunta?', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (10, 'Saludo general', 'general', 'Hola {nombre}, gracias por contactar a {empresa} í ½í¸\n\nÂ¿En quÃ© podemos ayudarte hoy?', NULL, 1, '2026-04-28 18:50:05');
INSERT INTO `wa_plantillas` VALUES (11, 'Aviso de cierre / horario', 'general', 'Hola {nombre} í ½í±\n\nTe informamos que {empresa} atiende de lunes a sÃ¡bado.\n\nEscrÃ­benos cuando gustes. Â¡Gracias!', NULL, 1, '2026-04-28 18:50:05');

SET FOREIGN_KEY_CHECKS = 1;
