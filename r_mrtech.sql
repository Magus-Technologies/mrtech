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

 Date: 16/06/2026 18:21:41
*/

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of almacenes
-- ----------------------------
INSERT INTO `almacenes` VALUES (1, 'TIE', 'MICAELA TIENDA D29', 'tienda', '', 1, 1, '2026-05-26 21:34:23', '2026-06-14 15:07:30');
INSERT INTO `almacenes` VALUES (2, 'ALM1', 'ALMACEN D30', 'almacen', '', 0, 1, '2026-05-26 21:34:23', '2026-06-14 14:59:22');
INSERT INTO `almacenes` VALUES (3, 'ALM2', 'ALMACEN D32', 'almacen', '', 0, 1, '2026-06-14 15:05:58', '2026-06-14 15:06:06');
INSERT INTO `almacenes` VALUES (4, 'ALM3', 'ALMACEN D48', 'almacen', '', 0, 1, '2026-06-14 15:06:29', '2026-06-14 15:06:29');
INSERT INTO `almacenes` VALUES (5, 'ALM4', 'ALMACEN PRINCIPAL', 'almacen', '', 0, 1, '2026-06-14 15:06:48', '2026-06-14 15:06:48');
INSERT INTO `almacenes` VALUES (7, 'TIE2', 'SAN FRANCISCO 232', 'tienda', '', 0, 1, '2026-06-14 15:07:55', '2026-06-14 15:07:55');

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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cajas
-- ----------------------------
INSERT INTO `cajas` VALUES (5, 1, '2026-06-07', 0.00, 65.00, 0.00, 0.00, 'cerrada', NULL, '2026-06-11 09:33:12', '2026-06-07 17:51:06', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -65.00);
INSERT INTO `cajas` VALUES (6, 4, '2026-06-13', 0.00, 190.00, 40.00, 0.00, 'cerrada', NULL, '2026-06-13 20:18:44', '2026-06-13 18:35:08', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -150.00);
INSERT INTO `cajas` VALUES (7, 1, '2026-06-14', 0.00, 100.00, 0.00, 0.00, 'cerrada', NULL, '2026-06-15 09:33:11', '2026-06-14 08:54:00', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -100.00);
INSERT INTO `cajas` VALUES (8, 4, '2026-06-14', 0.00, 675.00, 225.00, 328.00, 'cerrada', NULL, '2026-06-14 20:22:11', '2026-06-14 08:57:06', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":3,\"bil_50\":0,\"bil_20\":1,\"bil_10\":0,\"mon_5_00\":1,\"mon_2_00\":1,\"mon_1_00\":1,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -122.00);
INSERT INTO `cajas` VALUES (9, 4, '2026-06-15', 0.00, 345.00, 85.00, 0.00, 'cerrada', NULL, '2026-06-15 20:28:41', '2026-06-15 09:18:21', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', -260.00);
INSERT INTO `cajas` VALUES (10, 1, '2026-06-15', 0.00, 0.00, 0.00, 0.00, 'abierta', NULL, NULL, '2026-06-15 09:35:21', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', NULL, 0.00);
INSERT INTO `cajas` VALUES (11, 4, '2026-06-16', 0.00, 0.00, 0.00, 0.00, 'abierta', NULL, NULL, '2026-06-16 09:40:42', '{\"bil_200\":0,\"bil_100\":0,\"bil_50\":0,\"bil_20\":0,\"bil_10\":0,\"mon_5_00\":0,\"mon_2_00\":0,\"mon_1_00\":0,\"mon_0_50\":0,\"mon_0_20\":0,\"mon_0_10\":0}', NULL, 0.00);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of catalogo_banners
-- ----------------------------
INSERT INTO `catalogo_banners` VALUES (4, '', '', 'img_6a2ee6ae5002a0.02876573.jpeg', '', 1, 1, '2026-06-14 12:36:46');

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
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categorias
-- ----------------------------
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
INSERT INTO `categorias` VALUES (87, 'CABLE TC A TC', 'accesorio', NULL, 1);
INSERT INTO `categorias` VALUES (88, 'CARCADOR TC A TC', 'accesorio', NULL, 1);
INSERT INTO `categorias` VALUES (89, 'AUDIFONO BLUETOOTH', 'accesorio', NULL, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 623 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clientes
-- ----------------------------
INSERT INTO `clientes` VALUES (597, 'CLI-0001', 'persona', 'JAMESSON RAUL SAENZ PAJUELO', '40578849', '', '957357537', '957357537', 'JR PACHCUTEC 2890', 'VILLA MARIA DEL TRIUNFO', 'nuevo', '', 1, '2026-06-07 09:44:17', '2026-06-07 09:44:17');
INSERT INTO `clientes` VALUES (598, 'CLI-0002', 'persona', 'PUBLICO EN GENERAL', '', '', '', '', '', '', 'nuevo', '', 1, '2026-06-13 16:16:52', '2026-06-13 16:16:52');
INSERT INTO `clientes` VALUES (599, 'CLI-0003', 'persona', 'FRANZ CRUZ GARCIA', '42196943', '', '998331554', '998331554', NULL, NULL, 'nuevo', NULL, 1, '2026-06-13 16:59:51', '2026-06-13 16:59:51');
INSERT INTO `clientes` VALUES (600, 'CLI-0004', 'persona', 'MARCOS BRYAN GONZA MAMANI', '74213015', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-13 19:38:20', '2026-06-13 19:38:20');
INSERT INTO `clientes` VALUES (601, 'CLI-0005', 'persona', 'GUSTAVO ORTIZ CALLE', '44630901', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 10:24:21', '2026-06-14 10:24:21');
INSERT INTO `clientes` VALUES (602, 'CLI-0006', 'persona', 'JUAN CARLOS CHALLCO MOGROVEJO', '41564120', '', '929025827', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 10:36:51', '2026-06-14 10:36:51');
INSERT INTO `clientes` VALUES (603, 'CLI-0007', 'persona', 'ALDAIR ABRAHAM FARRO REQUE', '76504725', '', '971255645', '971255645', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 10:39:40', '2026-06-14 10:39:40');
INSERT INTO `clientes` VALUES (604, 'CLI-0008', 'empresa', 'S & T INGENIEROS SERVICIOS GENERALES SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA', '20601923611', '', '992772956', '992772956', '', '', 'nuevo', '', 1, '2026-06-14 10:57:16', '2026-06-14 10:58:10');
INSERT INTO `clientes` VALUES (605, 'CLI-0009', 'persona', 'JORDI PAZOS VELASQUEZ', '74893053', '', '980611160', '980611160', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 12:36:53', '2026-06-14 12:36:53');
INSERT INTO `clientes` VALUES (606, 'CLI-0010', 'persona', 'JORGE LUIS QUISPE HINOJOSA', '48621340', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 14:15:05', '2026-06-14 14:15:05');
INSERT INTO `clientes` VALUES (607, 'CLI-0011', 'persona', 'WILLIAMS INSAPILLO SALAS', '46830225', '', '920517584', '920517584', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 16:26:33', '2026-06-14 16:26:33');
INSERT INTO `clientes` VALUES (608, 'CLI-0012', 'persona', 'ROSA MARIA MOLINA DE SERNA', '10081584', '', '944121544', '944121544', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 17:03:34', '2026-06-14 17:03:34');
INSERT INTO `clientes` VALUES (609, 'CLI-0013', 'persona', 'GUSTAVO ENRIQUE CASTILLO AGUERO', '10549647', '', '953614498', '953614498', '', '', 'nuevo', '', 1, '2026-06-14 17:48:13', '2026-06-14 17:49:32');
INSERT INTO `clientes` VALUES (610, 'CLI-0014', 'persona', 'FRANCO JUNIOR SANTIAGO MASGO', '77686500', '', '940839698', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-14 18:32:51', '2026-06-14 18:32:51');
INSERT INTO `clientes` VALUES (611, 'CLI-0015', 'persona', 'CARLOS ALBERTO MIRANDA QUISPE', '47905817', '', '953369714', '953369714', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 09:38:25', '2026-06-15 09:38:25');
INSERT INTO `clientes` VALUES (612, 'CLI-0016', 'persona', 'ELI RODRIGUEZ MOZOMBITE', '48303059', '', '923217050', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 14:55:16', '2026-06-15 14:55:16');
INSERT INTO `clientes` VALUES (613, 'CLI-0017', 'persona', 'TANIA DEL AGUILA ARCENTALES', '05352218', '', '906612846', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 16:56:14', '2026-06-15 16:56:14');
INSERT INTO `clientes` VALUES (614, 'CLI-0018', 'persona', 'BETTY JULIANA FLORENCIO TELLO', '41846722', '', '956399062', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 17:27:20', '2026-06-15 17:27:20');
INSERT INTO `clientes` VALUES (615, 'CLI-0019', 'persona', 'MAYRA JOSSELIN PAYTAN PAYTAN', '70681379', '', '985628078', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 18:08:27', '2026-06-15 18:08:27');
INSERT INTO `clientes` VALUES (616, 'CLI-0020', 'persona', 'SANTOS ROJAS HUILLCA', '31521270', '', '924054889', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 19:04:15', '2026-06-15 19:04:15');
INSERT INTO `clientes` VALUES (617, 'CLI-0021', 'persona', 'SANTOS ROJAS HUILLCA', '31521270', '', '924054889', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-15 19:04:16', '2026-06-15 19:04:16');
INSERT INTO `clientes` VALUES (618, 'CLI-0022', 'persona', 'PEDRO ADOLFO QUISPE VENEGAS', '49053536', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-16 10:53:21', '2026-06-16 10:53:21');
INSERT INTO `clientes` VALUES (619, 'CLI-0023', 'persona', 'FERNANDO ELIAS PAULINO LOPEZ', '07454214', '', '966329478', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-16 11:43:47', '2026-06-16 11:43:47');
INSERT INTO `clientes` VALUES (620, 'CLI-0024', 'persona', 'santocha', '', '', '900270586', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-16 12:26:24', '2026-06-16 12:26:24');
INSERT INTO `clientes` VALUES (621, 'CLI-0025', 'persona', 'IRVIN DAVID ROJAS VASQUEZ', '74350087', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-16 15:09:08', '2026-06-16 15:09:08');
INSERT INTO `clientes` VALUES (622, 'CLI-0026', 'persona', 'MIGUEL ANGEL HUAMAN DAMIAN', '43881274', '', '', '', NULL, NULL, 'nuevo', NULL, 1, '2026-06-16 18:12:19', '2026-06-16 18:12:19');

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
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of configuracion
-- ----------------------------
INSERT INTO `configuracion` VALUES (1, 'empresa_nombre', 'MR. TECH', 'texto', 'empresa');
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
INSERT INTO `configuracion` VALUES (18, 'catalogo_whatsapp', '51922364303', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (19, 'catalogo_mensaje_wa', 'Hola, me interesa el producto: {producto} (S/ {precio}). ¿Está disponible?', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (20, 'catalogo_color_primario', '#00e4fa', 'texto', 'catalogo');
INSERT INTO `configuracion` VALUES (21, 'catalogo_mostrar_precio', '1', 'numero', 'catalogo');
INSERT INTO `configuracion` VALUES (22, 'catalogo_productos_por_pagina', '8', 'numero', 'catalogo');
INSERT INTO `configuracion` VALUES (23, 'print_logo', 'logos/logo_empresa.jpeg', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (24, 'print_mostrar_logo', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (25, 'print_mostrar_qr', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (26, 'print_cabecera', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (27, 'print_cuentas', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (28, 'print_msg_inferior', '', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (29, 'print_despedida', '¡Gracias por su preferencia!', 'texto', 'impresion');
INSERT INTO `configuracion` VALUES (30, 'print_mostrar_cabecera', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (31, 'print_mostrar_inferior', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (32, 'print_mostrar_despedida', '1', 'numero', 'impresion');
INSERT INTO `configuracion` VALUES (43, 'sunat_usuario_sol', 'JAMESSON', 'texto', 'general');
INSERT INTO `configuracion` VALUES (44, 'sunat_clave_sol', '40578849aA@', 'texto', 'general');
INSERT INTO `configuracion` VALUES (45, 'sunat_modo', 'produccion', 'texto', 'general');
INSERT INTO `configuracion` VALUES (46, 'sunat_ubigeo', '150143', 'texto', 'general');
INSERT INTO `configuracion` VALUES (47, 'sunat_distrito', 'VILLA MARIA DEL TRIUNFO', 'texto', 'general');
INSERT INTO `configuracion` VALUES (48, 'sunat_provincia', 'LIMA', 'texto', 'general');
INSERT INTO `configuracion` VALUES (49, 'sunat_departamento', 'LIMA', 'texto', 'general');
INSERT INTO `configuracion` VALUES (50, 'serie_boleta', 'B001', 'texto', 'general');
INSERT INTO `configuracion` VALUES (51, 'serie_factura', 'F001', 'texto', 'general');
INSERT INTO `configuracion` VALUES (75, 'sunat_certificado_subido', '1', 'texto', 'general');
INSERT INTO `configuracion` VALUES (76, 'sunat_certificado_fecha', '2026-06-13 11:00:04', 'texto', 'general');
INSERT INTO `configuracion` VALUES (99, 'sunat_ultimo_boleta', '33', 'texto', 'general');
INSERT INTO `configuracion` VALUES (100, 'sunat_ultimo_factura', '0', 'texto', 'general');
INSERT INTO `configuracion` VALUES (101, 'sunat_ultimo_nc_factura', '0', 'texto', 'general');
INSERT INTO `configuracion` VALUES (102, 'sunat_ultimo_nc_boleta', '0', 'texto', 'general');
INSERT INTO `configuracion` VALUES (103, 'sunat_ultimo_nd_factura', '0', 'texto', 'general');
INSERT INTO `configuracion` VALUES (104, 'sunat_ultimo_nd_boleta', '0', 'texto', 'general');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1122 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of equipos
-- ----------------------------
INSERT INTO `equipos` VALUES (1077, 7, 597, 'HONOR', '200', '1234574578686', 'NT', '', '2026-06-07 17:44:14');
INSERT INTO `equipos` VALUES (1078, 7, 597, 'HONOR', '2010', '', '', '', '2026-06-07 17:58:04');
INSERT INTO `equipos` VALUES (1079, 7, 597, 'HONOR', '200', '', '', '', '2026-06-07 17:59:19');
INSERT INTO `equipos` VALUES (1080, 7, 599, 'oppo', 'a77', '', 'azul', 'tapa partida, no enciende', '2026-06-13 16:59:51');
INSERT INTO `equipos` VALUES (1081, 7, 600, 'oppo', 'a13', '', '', 'no carga bien, pantalla quebrada', '2026-06-13 19:38:20');
INSERT INTO `equipos` VALUES (1082, 7, 601, 'motorola', 'v50 desing', '', '', 'tapa quebrada', '2026-06-14 10:24:21');
INSERT INTO `equipos` VALUES (1083, 15, 602, '', 'parlante', '', '', '', '2026-06-14 10:36:51');
INSERT INTO `equipos` VALUES (1084, 16, 603, '', 'aro de luz mediano', '', '', '', '2026-06-14 10:39:40');
INSERT INTO `equipos` VALUES (1085, 7, 605, 'SAMSUNG', 'A02', '', '', '', '2026-06-14 12:36:53');
INSERT INTO `equipos` VALUES (1086, 15, 598, '', 'parlante', '', '', '', '2026-06-14 13:04:50');
INSERT INTO `equipos` VALUES (1087, 7, 606, 'Xiaomi', 'redmi note 14', '', '', '', '2026-06-14 14:15:05');
INSERT INTO `equipos` VALUES (1093, 7, 598, 'ZTE', 'blade a76', '', '', '', '2026-06-14 15:05:56');
INSERT INTO `equipos` VALUES (1094, 7, 598, '', '', '', '', '', '2026-06-14 15:19:07');
INSERT INTO `equipos` VALUES (1095, 17, 598, '', 'soldadura', '', '', '', '2026-06-14 16:06:01');
INSERT INTO `equipos` VALUES (1096, 7, 607, 'SAMSUNG', 'a13', '', '', '', '2026-06-14 16:26:33');
INSERT INTO `equipos` VALUES (1097, 7, 598, 'SAMSUNG', '', '', '', '', '2026-06-14 16:56:54');
INSERT INTO `equipos` VALUES (1098, 1, 608, 'lenovo', 'ideapad330', '', '', '', '2026-06-14 17:03:34');
INSERT INTO `equipos` VALUES (1099, 18, 598, '', '', '', '', '', '2026-06-14 17:08:35');
INSERT INTO `equipos` VALUES (1100, 7, 609, 'redmi', 'note 10', '004607', 'azul', '', '2026-06-14 17:48:13');
INSERT INTO `equipos` VALUES (1101, 7, 610, 'redmi', 'note 13 pro', '', '', '', '2026-06-14 18:32:51');
INSERT INTO `equipos` VALUES (1102, 7, 598, 'SAMSUNG', '', '', '', '', '2026-06-15 09:33:45');
INSERT INTO `equipos` VALUES (1103, 7, 611, 'realme', 'c33', '', '', '', '2026-06-15 09:38:25');
INSERT INTO `equipos` VALUES (1104, 16, 598, 'realme', '', '', '', '', '2026-06-15 13:04:51');
INSERT INTO `equipos` VALUES (1105, 7, 612, 'redmi', '', '', '', '', '2026-06-15 14:55:16');
INSERT INTO `equipos` VALUES (1106, 16, 613, '', 'romax tipo c', '', '', '', '2026-06-15 16:56:14');
INSERT INTO `equipos` VALUES (1107, 7, 614, 'redmi', '', '', '', '', '2026-06-15 17:27:20');
INSERT INTO `equipos` VALUES (1108, 16, 615, 'SAMSUNG', '', '', '', '', '2026-06-15 18:08:27');
INSERT INTO `equipos` VALUES (1109, 7, 598, 'SAMSUNG', '', '', '', '', '2026-06-15 18:16:04');
INSERT INTO `equipos` VALUES (1110, 7, 616, 'hawei', '', '', '', '', '2026-06-15 19:04:15');
INSERT INTO `equipos` VALUES (1111, 7, 617, 'hawei', '', '', '', '', '2026-06-15 19:04:16');
INSERT INTO `equipos` VALUES (1112, 7, 598, 'redmi', '', '', '', '', '2026-06-15 20:22:32');
INSERT INTO `equipos` VALUES (1113, 7, 598, 'redmi', '', '', '', '', '2026-06-16 10:44:26');
INSERT INTO `equipos` VALUES (1114, 7, 598, 'SAMSUNG', '', '', '', '', '2026-06-16 10:45:34');
INSERT INTO `equipos` VALUES (1115, 7, 618, 'redmi', '', '', '', '', '2026-06-16 10:53:21');
INSERT INTO `equipos` VALUES (1116, 1, 619, 'hp', '', '', '', '', '2026-06-16 11:43:47');
INSERT INTO `equipos` VALUES (1117, 7, 620, 'SAMSUNG', '', '', '', '', '2026-06-16 12:26:24');
INSERT INTO `equipos` VALUES (1118, 7, 621, 'redmi', '13', '', '', '', '2026-06-16 15:09:08');
INSERT INTO `equipos` VALUES (1119, 7, 621, 'redmi', '13', '', '', '', '2026-06-16 15:12:08');
INSERT INTO `equipos` VALUES (1120, 7, 598, 'SAMSUNG', '', '', '', '', '2026-06-16 16:44:18');
INSERT INTO `equipos` VALUES (1121, 7, 622, 'SAMSUNG', 'a16', '', '', '', '2026-06-16 18:12:19');

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `estados_ot` VALUES (20, 'devuelto_al_cliente', 'DEVUELTO AL CLIENTE', 'danger', 'x-circle', 10, 1, 1, '2026-06-14 19:41:58');

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
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fotos_ot
-- ----------------------------
INSERT INTO `fotos_ot` VALUES (35, 1075, 'ot/1075/img_6a2ec7a5f00020.87316243.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-14 10:24:21');
INSERT INTO `fotos_ot` VALUES (36, 1076, 'ot/1076/img_6a2eca93195fd2.31632909.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-14 10:36:51');
INSERT INTO `fotos_ot` VALUES (37, 1078, 'ot/1078/img_6a2ee6b5a8ce11.85357792.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-14 12:36:53');
INSERT INTO `fotos_ot` VALUES (38, 1088, 'ot/1088/img_6a2f2fad6b00b0.17855252.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-14 17:48:13');
INSERT INTO `fotos_ot` VALUES (39, 1089, 'ot/1089/img_6a2f3a2313f4f6.19693634.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-14 18:32:51');
INSERT INTO `fotos_ot` VALUES (40, 1091, 'ot/1091/img_6a300e6110a3b1.50914902.jpg', 'foto', NULL, NULL, NULL, 'ingreso', '2026-06-15 09:38:25');

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
) ENGINE = InnoDB AUTO_INCREMENT = 170 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `historial_ot` VALUES (69, 1073, 4, NULL, 'ingresado', 'OT creada', '2026-06-13 16:59:51');
INSERT INTO `historial_ot` VALUES (70, 1073, 4, 'ingresado', 'diagnosticado', 'equipo con problemas de carga', '2026-06-13 17:25:19');
INSERT INTO `historial_ot` VALUES (71, 1073, 4, 'diagnosticado', 'testeado', '', '2026-06-13 17:44:58');
INSERT INTO `historial_ot` VALUES (72, 1073, 4, 'testeado', 'cancelado', '', '2026-06-13 17:49:29');
INSERT INTO `historial_ot` VALUES (73, 1073, 4, 'cancelado', 'entregado', '', '2026-06-13 18:41:25');
INSERT INTO `historial_ot` VALUES (74, 1074, 4, NULL, 'ingresado', 'OT creada', '2026-06-13 19:38:20');
INSERT INTO `historial_ot` VALUES (75, 1074, 4, 'ingresado', 'entregado', '', '2026-06-13 19:38:49');
INSERT INTO `historial_ot` VALUES (76, 1075, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 10:24:21');
INSERT INTO `historial_ot` VALUES (77, 1076, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 10:36:51');
INSERT INTO `historial_ot` VALUES (78, 1076, 4, 'ingresado', 'en_mesa', '', '2026-06-14 10:37:05');
INSERT INTO `historial_ot` VALUES (79, 1077, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 10:39:40');
INSERT INTO `historial_ot` VALUES (80, 1077, 4, 'ingresado', 'entregado', '', '2026-06-14 10:39:59');
INSERT INTO `historial_ot` VALUES (81, 1075, 4, 'ingresado', 'en_mesa', '', '2026-06-14 10:42:40');
INSERT INTO `historial_ot` VALUES (82, 1076, 4, 'en_mesa', 'en_espera_repuesto', '', '2026-06-14 11:08:37');
INSERT INTO `historial_ot` VALUES (83, 1075, 4, 'en_mesa', 'entregado', '', '2026-06-14 11:57:19');
INSERT INTO `historial_ot` VALUES (84, 1078, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 12:36:53');
INSERT INTO `historial_ot` VALUES (85, 1079, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 13:04:50');
INSERT INTO `historial_ot` VALUES (86, 1079, 4, 'ingresado', 'entregado', '', '2026-06-14 13:05:19');
INSERT INTO `historial_ot` VALUES (87, 1078, 4, 'ingresado', 'en_mesa', '', '2026-06-14 13:05:56');
INSERT INTO `historial_ot` VALUES (88, 1078, 4, 'en_mesa', 'entregado', '', '2026-06-14 14:13:18');
INSERT INTO `historial_ot` VALUES (89, 1080, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 14:15:05');
INSERT INTO `historial_ot` VALUES (90, 1080, 4, 'ingresado', 'entregado', '', '2026-06-14 14:15:29');
INSERT INTO `historial_ot` VALUES (91, 1081, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 15:05:56');
INSERT INTO `historial_ot` VALUES (92, 1081, 4, 'ingresado', 'entregado', '', '2026-06-14 15:06:10');
INSERT INTO `historial_ot` VALUES (93, 1082, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 15:19:07');
INSERT INTO `historial_ot` VALUES (94, 1082, 4, 'ingresado', 'entregado', '', '2026-06-14 15:19:21');
INSERT INTO `historial_ot` VALUES (95, 1083, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 16:06:01');
INSERT INTO `historial_ot` VALUES (96, 1083, 4, 'ingresado', 'entregado', '', '2026-06-14 16:06:11');
INSERT INTO `historial_ot` VALUES (97, 1084, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 16:26:33');
INSERT INTO `historial_ot` VALUES (98, 1084, 4, 'ingresado', 'entregado', '', '2026-06-14 16:26:43');
INSERT INTO `historial_ot` VALUES (99, 1085, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 16:56:55');
INSERT INTO `historial_ot` VALUES (100, 1085, 4, 'ingresado', 'entregado', '', '2026-06-14 16:57:08');
INSERT INTO `historial_ot` VALUES (101, 1086, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 17:03:34');
INSERT INTO `historial_ot` VALUES (102, 1086, 4, 'ingresado', 'en_mesa', '', '2026-06-14 17:03:51');
INSERT INTO `historial_ot` VALUES (103, 1087, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 17:08:35');
INSERT INTO `historial_ot` VALUES (104, 1087, 4, 'ingresado', 'entregado', '', '2026-06-14 17:08:46');
INSERT INTO `historial_ot` VALUES (105, 1087, 4, 'entregado', 'ingresado', '', '2026-06-14 17:08:50');
INSERT INTO `historial_ot` VALUES (106, 1087, 4, 'ingresado', 'entregado', '', '2026-06-14 17:08:59');
INSERT INTO `historial_ot` VALUES (107, 1088, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 17:48:13');
INSERT INTO `historial_ot` VALUES (108, 1088, 4, 'ingresado', 'en_mesa', '', '2026-06-14 17:48:32');
INSERT INTO `historial_ot` VALUES (109, 1088, 4, 'en_mesa', 'control_calidad', '', '2026-06-14 18:28:23');
INSERT INTO `historial_ot` VALUES (110, 1089, 4, NULL, 'ingresado', 'OT creada', '2026-06-14 18:32:51');
INSERT INTO `historial_ot` VALUES (111, 1089, 4, 'ingresado', 'en_revision', '', '2026-06-14 18:33:05');
INSERT INTO `historial_ot` VALUES (112, 1088, 4, 'control_calidad', 'cancelado', '', '2026-06-14 18:40:15');
INSERT INTO `historial_ot` VALUES (113, 1088, 4, 'cancelado', 'entregado', '', '2026-06-14 18:50:09');
INSERT INTO `historial_ot` VALUES (114, 1089, 4, 'en_revision', 'cancelado', '', '2026-06-14 19:14:22');
INSERT INTO `historial_ot` VALUES (115, 1089, 4, 'cancelado', 'entregado', '', '2026-06-14 19:32:36');
INSERT INTO `historial_ot` VALUES (116, 1076, 4, 'en_espera_repuesto', 'devuelto_al_cliente', '', '2026-06-14 19:42:48');
INSERT INTO `historial_ot` VALUES (117, 1072, 4, 'diagnosticado', 'devuelto_al_cliente', 'NO REALIZO REPARACION', '2026-06-14 19:44:29');
INSERT INTO `historial_ot` VALUES (118, 1086, 4, 'en_mesa', 'control_calidad', '', '2026-06-14 19:54:19');
INSERT INTO `historial_ot` VALUES (119, 1086, 4, 'control_calidad', 'entregado', '', '2026-06-14 20:05:34');
INSERT INTO `historial_ot` VALUES (120, 1090, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 09:33:45');
INSERT INTO `historial_ot` VALUES (121, 1090, 4, 'ingresado', 'entregado', '', '2026-06-15 09:34:06');
INSERT INTO `historial_ot` VALUES (122, 1091, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 09:38:25');
INSERT INTO `historial_ot` VALUES (123, 1091, 4, 'ingresado', 'en_mesa', '', '2026-06-15 09:38:38');
INSERT INTO `historial_ot` VALUES (124, 1091, 4, 'en_mesa', 'cancelado', '', '2026-06-15 12:47:45');
INSERT INTO `historial_ot` VALUES (125, 1091, 4, 'cancelado', 'entregado', '', '2026-06-15 13:01:23');
INSERT INTO `historial_ot` VALUES (126, 1092, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 13:04:51');
INSERT INTO `historial_ot` VALUES (127, 1092, 4, 'ingresado', 'entregado', '', '2026-06-15 13:05:12');
INSERT INTO `historial_ot` VALUES (128, 1093, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 14:55:16');
INSERT INTO `historial_ot` VALUES (129, 1093, 4, 'ingresado', 'en_mesa', '', '2026-06-15 14:55:40');
INSERT INTO `historial_ot` VALUES (130, 1093, 4, 'en_mesa', 'entregado', '', '2026-06-15 15:33:35');
INSERT INTO `historial_ot` VALUES (131, 1094, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 16:56:14');
INSERT INTO `historial_ot` VALUES (132, 1094, 4, 'ingresado', 'entregado', '', '2026-06-15 17:00:27');
INSERT INTO `historial_ot` VALUES (133, 1095, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 17:27:20');
INSERT INTO `historial_ot` VALUES (134, 1095, 4, 'ingresado', 'en_mesa', '', '2026-06-15 17:27:26');
INSERT INTO `historial_ot` VALUES (135, 1096, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 18:08:27');
INSERT INTO `historial_ot` VALUES (136, 1097, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 18:16:04');
INSERT INTO `historial_ot` VALUES (137, 1097, 4, 'ingresado', 'entregado', '', '2026-06-15 18:16:25');
INSERT INTO `historial_ot` VALUES (138, 1098, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 19:04:15');
INSERT INTO `historial_ot` VALUES (139, 1099, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 19:04:16');
INSERT INTO `historial_ot` VALUES (140, 1095, 4, 'en_mesa', 'ingresado', '', '2026-06-15 19:06:00');
INSERT INTO `historial_ot` VALUES (141, 1095, 4, 'ingresado', 'entregado', '', '2026-06-15 19:06:12');
INSERT INTO `historial_ot` VALUES (142, 1100, 4, NULL, 'ingresado', 'OT creada', '2026-06-15 20:22:32');
INSERT INTO `historial_ot` VALUES (143, 1100, 4, 'ingresado', 'entregado', '', '2026-06-15 20:22:44');
INSERT INTO `historial_ot` VALUES (144, 1099, 4, 'ingresado', 'devuelto_al_cliente', '', '2026-06-15 20:23:35');
INSERT INTO `historial_ot` VALUES (145, 1096, 4, 'ingresado', 'entregado', '', '2026-06-15 20:24:54');
INSERT INTO `historial_ot` VALUES (146, 1101, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 10:44:26');
INSERT INTO `historial_ot` VALUES (147, 1102, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 10:45:34');
INSERT INTO `historial_ot` VALUES (148, 1103, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 10:53:21');
INSERT INTO `historial_ot` VALUES (149, 1104, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 11:43:47');
INSERT INTO `historial_ot` VALUES (150, 1104, 4, 'ingresado', 'en_mesa', '', '2026-06-16 11:44:05');
INSERT INTO `historial_ot` VALUES (151, 1104, 4, 'en_mesa', 'en_reparacion', '', '2026-06-16 11:44:21');
INSERT INTO `historial_ot` VALUES (152, 1105, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 12:26:24');
INSERT INTO `historial_ot` VALUES (153, 1105, 4, 'ingresado', 'entregado', '', '2026-06-16 12:26:46');
INSERT INTO `historial_ot` VALUES (154, 1106, 1, NULL, 'ingresado', 'OT creada', '2026-06-16 15:09:08');
INSERT INTO `historial_ot` VALUES (155, 1106, 1, 'ingresado', 'entregado', '', '2026-06-16 15:09:24');
INSERT INTO `historial_ot` VALUES (156, 1106, 4, 'entregado', 'devuelto_al_cliente', '', '2026-06-16 15:10:40');
INSERT INTO `historial_ot` VALUES (157, 1107, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 15:12:08');
INSERT INTO `historial_ot` VALUES (158, 1107, 4, 'ingresado', 'entregado', '', '2026-06-16 15:12:24');
INSERT INTO `historial_ot` VALUES (159, 1101, 4, 'ingresado', 'entregado', '', '2026-06-16 15:20:13');
INSERT INTO `historial_ot` VALUES (160, 1102, 4, 'ingresado', 'entregado', '', '2026-06-16 15:20:27');
INSERT INTO `historial_ot` VALUES (161, 1103, 4, 'ingresado', 'entregado', '', '2026-06-16 15:20:43');
INSERT INTO `historial_ot` VALUES (162, 1103, 4, 'entregado', 'entregado', '', '2026-06-16 15:20:45');
INSERT INTO `historial_ot` VALUES (163, 1104, 4, 'en_reparacion', 'cancelado', '', '2026-06-16 15:21:04');
INSERT INTO `historial_ot` VALUES (164, 1104, 4, 'cancelado', 'entregado', '', '2026-06-16 15:57:27');
INSERT INTO `historial_ot` VALUES (165, 1098, 4, 'ingresado', 'entregado', '', '2026-06-16 16:42:57');
INSERT INTO `historial_ot` VALUES (166, 1108, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 16:44:19');
INSERT INTO `historial_ot` VALUES (167, 1108, 4, 'ingresado', 'entregado', '', '2026-06-16 16:44:47');
INSERT INTO `historial_ot` VALUES (168, 1109, 4, NULL, 'ingresado', 'OT creada', '2026-06-16 18:12:19');
INSERT INTO `historial_ot` VALUES (169, 1109, 4, 'ingresado', 'control_calidad', '', '2026-06-16 18:14:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 482 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `kardex` VALUES (431, 29, 1, 'salida', 1.00, 6.00, 5.00, 20.00, 'Venta', 'VTA-2026-0004', 4, '2026-06-13 15:37:08');
INSERT INTO `kardex` VALUES (432, 368, 1, 'salida', 1.00, 5.00, 4.00, 20.00, 'Venta', 'VTA-2026-0004', 4, '2026-06-13 15:37:08');
INSERT INTO `kardex` VALUES (433, 429, 1, 'entrada', 1.00, 0.00, 1.00, 40.00, 'Stock inicial', 'INICIO', 1, '2026-06-13 16:53:51');
INSERT INTO `kardex` VALUES (434, 429, 1, 'salida', 1.00, 1.00, 0.00, 70.00, 'Repuesto OT', 'OT-2026-0004', 4, '2026-06-13 16:59:51');
INSERT INTO `kardex` VALUES (435, 374, 1, 'salida', 1.00, 1.00, 0.00, 10.00, 'Venta', 'VTA-2026-0005', 4, '2026-06-13 17:11:51');
INSERT INTO `kardex` VALUES (436, 430, 1, 'entrada', 1.00, 0.00, 1.00, 6.20, 'Stock inicial', 'INICIO', 1, '2026-06-13 18:26:53');
INSERT INTO `kardex` VALUES (437, 430, 1, 'salida', 1.00, 1.00, 0.00, 10.00, 'Venta', 'VTA-2026-0006', 4, '2026-06-13 18:30:40');
INSERT INTO `kardex` VALUES (438, 430, 1, 'devolucion', 1.00, 0.00, 1.00, 10.00, 'Venta anulada', 'VTA-2026-0006', 1, '2026-06-13 18:35:21');
INSERT INTO `kardex` VALUES (439, 374, 1, 'devolucion', 1.00, 0.00, 1.00, 10.00, 'Venta anulada', 'VTA-2026-0005', 1, '2026-06-13 18:35:31');
INSERT INTO `kardex` VALUES (440, 29, 1, 'devolucion', 1.00, 5.00, 6.00, 20.00, 'Venta anulada', 'VTA-2026-0004', 1, '2026-06-13 18:35:41');
INSERT INTO `kardex` VALUES (441, 368, 1, 'devolucion', 1.00, 4.00, 5.00, 20.00, 'Venta anulada', 'VTA-2026-0004', 1, '2026-06-13 18:35:41');
INSERT INTO `kardex` VALUES (442, 430, 1, 'salida', 1.00, 1.00, 0.00, 10.00, 'Venta', 'VTA-2026-0007', 4, '2026-06-13 18:37:16');
INSERT INTO `kardex` VALUES (443, 29, 1, 'salida', 1.00, 6.00, 5.00, 20.00, 'Venta', 'VTA-2026-0008', 4, '2026-06-13 18:38:00');
INSERT INTO `kardex` VALUES (444, 368, 1, 'salida', 1.00, 5.00, 4.00, 20.00, 'Venta', 'VTA-2026-0008', 4, '2026-06-13 18:38:00');
INSERT INTO `kardex` VALUES (445, 430, NULL, 'entrada', 1.00, 0.00, 1.00, 6.20, 'Compra de stock', '', 1, '2026-06-13 18:40:31');
INSERT INTO `kardex` VALUES (446, 430, 1, 'salida', 1.00, 1.00, 0.00, 10.00, 'Venta', 'VTA-2026-0009', 4, '2026-06-13 18:41:10');
INSERT INTO `kardex` VALUES (447, 368, 1, 'salida', 1.00, 4.00, 3.00, 20.00, 'Venta', 'VTA-2026-0010', 4, '2026-06-13 19:22:00');
INSERT INTO `kardex` VALUES (448, 431, 1, 'entrada', 1.00, 0.00, 1.00, 9.50, 'Stock inicial', 'INICIO', 1, '2026-06-13 19:22:36');
INSERT INTO `kardex` VALUES (449, 431, 1, 'salida', 1.00, 1.00, 0.00, 25.00, 'Venta', 'VTA-2026-0011', 4, '2026-06-13 19:24:05');
INSERT INTO `kardex` VALUES (450, 89, 1, 'salida', 1.00, 1.00, 0.00, 50.00, 'Repuesto OT', 'OT-2026-0005', 4, '2026-06-13 19:38:20');
INSERT INTO `kardex` VALUES (451, 432, 1, 'entrada', 1.00, 0.00, 1.00, 3.62, 'Stock inicial', 'INICIO', 1, '2026-06-14 10:37:30');
INSERT INTO `kardex` VALUES (452, 432, 1, 'salida', 1.00, 1.00, 0.00, 10.00, 'Venta', 'VTA-2026-0012', 4, '2026-06-14 10:41:59');
INSERT INTO `kardex` VALUES (453, 433, 1, 'entrada', 1.00, 0.00, 1.00, 1.00, 'Stock inicial', 'INICIO', 1, '2026-06-14 11:01:30');
INSERT INTO `kardex` VALUES (454, 433, 1, 'salida', 1.00, 1.00, 0.00, 100.00, 'Venta', 'VTA-2026-0013', 1, '2026-06-14 11:04:48');
INSERT INTO `kardex` VALUES (455, 158, 1, 'salida', 1.00, 3.00, 2.00, 10.00, 'Venta', 'VTA-2026-0014', 4, '2026-06-14 12:16:08');
INSERT INTO `kardex` VALUES (456, 88, 1, 'salida', 1.00, 1.00, 0.00, 65.00, 'Repuesto OT', 'OT-2026-0009', 4, '2026-06-14 12:36:53');
INSERT INTO `kardex` VALUES (457, 368, 1, 'salida', 1.00, 3.00, 2.00, 20.00, 'Venta', 'VTA-2026-0015', 4, '2026-06-14 14:12:50');
INSERT INTO `kardex` VALUES (458, 430, NULL, 'entrada', 50.00, 0.00, 50.00, 4.20, 'Ajuste de inventario', '', 1, '2026-06-14 14:35:12');
INSERT INTO `kardex` VALUES (459, 434, 1, 'entrada', 50.00, 0.00, 50.00, 3.90, 'Stock inicial', 'INICIO', 1, '2026-06-14 14:40:11');
INSERT INTO `kardex` VALUES (460, 435, 1, 'entrada', 100.00, 0.00, 100.00, 4.20, 'Stock inicial', 'INICIO', 1, '2026-06-14 15:27:32');
INSERT INTO `kardex` VALUES (461, 437, 1, 'entrada', 100.00, 0.00, 100.00, 14.50, 'Stock inicial', 'INICIO', 1, '2026-06-14 15:44:32');
INSERT INTO `kardex` VALUES (462, 438, 1, 'entrada', 100.00, 0.00, 100.00, 9.50, 'Stock inicial', 'INICIO', 1, '2026-06-14 16:08:03');
INSERT INTO `kardex` VALUES (463, 439, 1, 'entrada', 100.00, 0.00, 100.00, 5.00, 'Stock inicial', 'INICIO', 1, '2026-06-14 16:15:19');
INSERT INTO `kardex` VALUES (464, 440, 1, 'entrada', 100.00, 0.00, 100.00, 6.20, 'Stock inicial', 'INICIO', 1, '2026-06-14 16:30:59');
INSERT INTO `kardex` VALUES (465, 441, 1, 'entrada', 100.00, 0.00, 100.00, 2.50, 'Stock inicial', 'INICIO', 1, '2026-06-14 16:52:25');
INSERT INTO `kardex` VALUES (466, 442, 1, 'entrada', 100.00, 0.00, 100.00, 2.60, 'Stock inicial', 'INICIO', 1, '2026-06-14 17:05:16');
INSERT INTO `kardex` VALUES (467, 443, 1, 'entrada', 100.00, 0.00, 100.00, 5.00, 'Stock inicial', 'INICIO', 1, '2026-06-14 17:21:11');
INSERT INTO `kardex` VALUES (468, 432, NULL, 'entrada', 100.00, 0.00, 100.00, 2.00, 'Ajuste de inventario', '', 1, '2026-06-14 17:33:15');
INSERT INTO `kardex` VALUES (469, 444, 1, 'entrada', 100.00, 0.00, 100.00, 1.65, 'Stock inicial', 'INICIO', 1, '2026-06-14 17:39:25');
INSERT INTO `kardex` VALUES (470, 82, 1, 'salida', 1.00, 1.00, 0.00, 70.00, 'Repuesto OT', 'OT-2026-0019', 4, '2026-06-14 17:48:13');
INSERT INTO `kardex` VALUES (471, 445, 1, 'entrada', 100.00, 0.00, 100.00, 7.20, 'Stock inicial', 'INICIO', 1, '2026-06-14 17:48:29');
INSERT INTO `kardex` VALUES (472, 22, 1, 'salida', 1.00, 7.00, 6.00, 20.00, 'Venta', 'VTA-2026-0016', 4, '2026-06-14 19:08:58');
INSERT INTO `kardex` VALUES (473, 446, 1, 'entrada', 100.00, 0.00, 100.00, 0.00, 'Stock inicial', 'INICIO', 1, '2026-06-14 19:19:34');
INSERT INTO `kardex` VALUES (474, 446, 1, 'salida', 1.00, 100.00, 99.00, 10.00, 'Venta', 'VTA-2026-0017', 4, '2026-06-14 19:32:00');
INSERT INTO `kardex` VALUES (475, 446, 1, 'salida', 1.00, 99.00, 98.00, 20.00, 'Repuesto OT', 'OT-2026-0019', 4, '2026-06-14 19:33:37');
INSERT INTO `kardex` VALUES (476, 446, 1, 'salida', 1.00, 98.00, 97.00, 5.00, 'Repuesto OT', 'OT-2026-0019', 4, '2026-06-14 19:33:37');
INSERT INTO `kardex` VALUES (477, 246, 1, 'salida', 1.00, 1.00, 0.00, 5.00, 'Venta', 'VTA-2026-0018', 4, '2026-06-14 19:35:45');
INSERT INTO `kardex` VALUES (478, 446, 1, 'salida', 1.00, 97.00, 96.00, 80.00, 'Repuesto OT', 'OT-2026-0017', 4, '2026-06-14 19:37:26');
INSERT INTO `kardex` VALUES (479, 446, 1, 'salida', 1.00, 96.00, 95.00, 20.00, 'Repuesto OT', 'OT-2026-0017', 4, '2026-06-14 20:05:28');
INSERT INTO `kardex` VALUES (480, 435, 1, 'salida', 1.00, 100.00, 99.00, 10.00, 'Venta', 'VTA-2026-0019', 4, '2026-06-15 11:19:17');
INSERT INTO `kardex` VALUES (481, 368, 1, 'salida', 1.00, 2.00, 1.00, 20.00, 'Venta', 'VTA-2026-0020', 4, '2026-06-16 12:28:21');

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
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `marcas_equipo` VALUES (48, 'oppo', 1);
INSERT INTO `marcas_equipo` VALUES (49, 'motorola', 1);
INSERT INTO `marcas_equipo` VALUES (50, 'lenovo', 1);
INSERT INTO `marcas_equipo` VALUES (51, 'redmi', 1);
INSERT INTO `marcas_equipo` VALUES (52, 'realme', 1);
INSERT INTO `marcas_equipo` VALUES (53, 'hawei', 1);
INSERT INTO `marcas_equipo` VALUES (54, 'hp', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of movimientos_caja
-- ----------------------------
INSERT INTO `movimientos_caja` VALUES (5, 5, 'ingreso', 'Pago reparación OT-2026-0003', 65.00, 'OT-2026-0003', 4, '2026-06-07 18:00:02');
INSERT INTO `movimientos_caja` VALUES (6, 6, 'ingreso', 'Venta VTA-2026-0007 (Efectivo)', 10.00, 'VTA-2026-0007', 4, '2026-06-13 18:37:16');
INSERT INTO `movimientos_caja` VALUES (7, 6, 'ingreso', 'Venta VTA-2026-0008 (Yape)', 40.00, 'VTA-2026-0008', 4, '2026-06-13 18:38:00');
INSERT INTO `movimientos_caja` VALUES (8, 6, 'ingreso', 'Venta VTA-2026-0009 (Yape)', 10.00, 'VTA-2026-0009', 4, '2026-06-13 18:41:10');
INSERT INTO `movimientos_caja` VALUES (9, 6, 'ingreso', 'Venta VTA-2026-0010 (Efectivo)', 20.00, 'VTA-2026-0010', 4, '2026-06-13 19:22:00');
INSERT INTO `movimientos_caja` VALUES (10, 6, 'ingreso', 'Venta VTA-2026-0011 (Yape)', 25.00, 'VTA-2026-0011', 4, '2026-06-13 19:24:05');
INSERT INTO `movimientos_caja` VALUES (11, 6, 'ingreso', 'Pago reparación OT-2026-0005', 85.00, 'OT-2026-0005', 4, '2026-06-13 19:38:38');
INSERT INTO `movimientos_caja` VALUES (12, 6, 'egreso', 'compra de pantalla', 40.00, 'OT-2026-0005', 4, '2026-06-13 19:42:22');
INSERT INTO `movimientos_caja` VALUES (13, 8, 'ingreso', 'Pago reparación OT-2026-0008', 10.00, 'OT-2026-0008', 4, '2026-06-14 10:39:50');
INSERT INTO `movimientos_caja` VALUES (14, 8, 'ingreso', 'Venta VTA-2026-0012 (Efectivo)', 10.00, 'VTA-2026-0012', 4, '2026-06-14 10:41:59');
INSERT INTO `movimientos_caja` VALUES (15, 7, 'ingreso', 'Venta VTA-2026-0013 (Yape)', 100.00, 'VTA-2026-0013', 1, '2026-06-14 11:04:48');
INSERT INTO `movimientos_caja` VALUES (16, 8, 'ingreso', 'Pago reparación OT-2026-0006', 80.00, 'OT-2026-0006', 4, '2026-06-14 11:57:11');
INSERT INTO `movimientos_caja` VALUES (17, 8, 'ingreso', 'Venta VTA-2026-0014 (Yape)', 10.00, 'VTA-2026-0014', 4, '2026-06-14 12:16:08');
INSERT INTO `movimientos_caja` VALUES (18, 8, 'ingreso', 'Pago reparación OT-2026-0009', 80.00, 'OT-2026-0009', 4, '2026-06-14 12:39:38');
INSERT INTO `movimientos_caja` VALUES (19, 8, 'ingreso', 'Pago reparación OT-2026-0010', 15.00, 'OT-2026-0010', 4, '2026-06-14 13:05:09');
INSERT INTO `movimientos_caja` VALUES (20, 8, 'ingreso', 'Venta VTA-2026-0015 (Efectivo)', 20.00, 'VTA-2026-0015', 4, '2026-06-14 14:12:50');
INSERT INTO `movimientos_caja` VALUES (21, 8, 'ingreso', 'Pago reparación OT-2026-0011', 20.00, 'OT-2026-0011', 4, '2026-06-14 14:15:21');
INSERT INTO `movimientos_caja` VALUES (22, 8, 'ingreso', 'Pago reparación OT-2026-0012', 5.00, 'OT-2026-0012', 4, '2026-06-14 15:06:01');
INSERT INTO `movimientos_caja` VALUES (23, 8, 'ingreso', 'Pago reparación OT-2026-0013', 10.00, 'OT-2026-0013', 4, '2026-06-14 15:19:17');
INSERT INTO `movimientos_caja` VALUES (24, 8, 'egreso', 'pantalla samsung a02', 35.00, '', 4, '2026-06-14 15:23:05');
INSERT INTO `movimientos_caja` VALUES (25, 8, 'egreso', 'pantalla zte blade v50 desing', 47.00, '', 4, '2026-06-14 15:23:41');
INSERT INTO `movimientos_caja` VALUES (26, 8, 'ingreso', 'Pago reparación OT-2026-0014', 5.00, 'OT-2026-0014', 4, '2026-06-14 16:06:07');
INSERT INTO `movimientos_caja` VALUES (27, 8, 'ingreso', 'Pago reparación OT-2026-0015', 10.00, 'OT-2026-0015', 4, '2026-06-14 16:26:38');
INSERT INTO `movimientos_caja` VALUES (28, 8, 'ingreso', 'Pago reparación OT-2026-0016', 10.00, 'OT-2026-0016', 4, '2026-06-14 16:57:00');
INSERT INTO `movimientos_caja` VALUES (29, 8, 'ingreso', 'Pago reparación OT-2026-0018', 20.00, 'OT-2026-0018', 4, '2026-06-14 17:08:42');
INSERT INTO `movimientos_caja` VALUES (30, 8, 'ingreso', 'Venta VTA-2026-0016 (Yape)', 20.00, 'VTA-2026-0016', 4, '2026-06-14 19:08:58');
INSERT INTO `movimientos_caja` VALUES (31, 8, 'egreso', 'BANDEJA SIM', 15.00, '', 4, '2026-06-14 19:09:23');
INSERT INTO `movimientos_caja` VALUES (32, 8, 'egreso', 'PANTALLA REDMI NOTE 10', 40.00, '', 4, '2026-06-14 19:18:01');
INSERT INTO `movimientos_caja` VALUES (33, 8, 'ingreso', 'Venta VTA-2026-0017 (Yape)', 10.00, 'VTA-2026-0017', 4, '2026-06-14 19:32:00');
INSERT INTO `movimientos_caja` VALUES (34, 8, 'ingreso', 'Pago reparación OT-2026-0020', 20.00, 'OT-2026-0020', 4, '2026-06-14 19:32:31');
INSERT INTO `movimientos_caja` VALUES (35, 8, 'ingreso', 'Pago reparación OT-2026-0019', 105.00, 'OT-2026-0019', 4, '2026-06-14 19:33:43');
INSERT INTO `movimientos_caja` VALUES (36, 8, 'ingreso', 'Venta VTA-2026-0018 (Yape)', 5.00, 'VTA-2026-0018', 4, '2026-06-14 19:35:45');
INSERT INTO `movimientos_caja` VALUES (37, 8, 'egreso', 'COMPRA CARGADOR DE LAPTOP', 80.00, '', 4, '2026-06-14 19:37:57');
INSERT INTO `movimientos_caja` VALUES (38, 8, 'egreso', 'LENTE DE CAMARA REDMI NOTE 13 PRO', 8.00, '', 4, '2026-06-14 19:48:18');
INSERT INTO `movimientos_caja` VALUES (39, 8, 'ingreso', 'Pago reparación OT-2026-0017', 210.00, 'OT-2026-0017', 4, '2026-06-14 19:54:04');
INSERT INTO `movimientos_caja` VALUES (40, 9, 'ingreso', 'Pago reparación OT-2026-0021', 10.00, 'OT-2026-0021', 4, '2026-06-15 09:33:56');
INSERT INTO `movimientos_caja` VALUES (41, 9, 'ingreso', 'Venta VTA-2026-0019 (Efectivo)', 10.00, 'VTA-2026-0019', 4, '2026-06-15 11:19:17');
INSERT INTO `movimientos_caja` VALUES (42, 9, 'ingreso', 'Pago reparación OT-2026-0022', 80.00, 'OT-2026-0022', 4, '2026-06-15 13:00:44');
INSERT INTO `movimientos_caja` VALUES (43, 9, 'ingreso', 'Pago reparación OT-2026-0023', 15.00, 'OT-2026-0023', 4, '2026-06-15 13:05:04');
INSERT INTO `movimientos_caja` VALUES (44, 9, 'ingreso', 'Pago reparación OT-2026-0024', 75.00, 'OT-2026-0024', 4, '2026-06-15 15:33:27');
INSERT INTO `movimientos_caja` VALUES (45, 9, 'ingreso', 'Pago reparación OT-2026-0025', 20.00, 'OT-2026-0025', 4, '2026-06-15 17:00:16');
INSERT INTO `movimientos_caja` VALUES (46, 9, 'ingreso', 'Pago reparación OT-2026-0027', 35.00, 'OT-2026-0027', 4, '2026-06-15 18:08:50');
INSERT INTO `movimientos_caja` VALUES (47, 9, 'ingreso', 'Pago reparación OT-2026-0028', 5.00, 'OT-2026-0028', 4, '2026-06-15 18:16:14');
INSERT INTO `movimientos_caja` VALUES (48, 9, 'ingreso', 'Pago reparación OT-2026-0026', 85.00, 'OT-2026-0026', 4, '2026-06-15 19:05:49');
INSERT INTO `movimientos_caja` VALUES (49, 9, 'ingreso', 'Pago reparación OT-2026-0031', 10.00, 'OT-2026-0031', 4, '2026-06-15 20:22:37');
INSERT INTO `movimientos_caja` VALUES (50, 9, 'egreso', 'compra pantalla y9 2019', 40.00, '', 4, '2026-06-15 20:26:35');
INSERT INTO `movimientos_caja` VALUES (51, 9, 'egreso', 'pantalla redmi note 9', 45.00, '', 4, '2026-06-15 20:28:29');
INSERT INTO `movimientos_caja` VALUES (52, 11, 'ingreso', 'Pago reparación OT-2026-0032', 10.00, 'OT-2026-0032', 4, '2026-06-16 10:44:44');
INSERT INTO `movimientos_caja` VALUES (53, 11, 'ingreso', 'Pago reparación OT-2026-0033', 10.00, 'OT-2026-0033', 4, '2026-06-16 10:45:51');
INSERT INTO `movimientos_caja` VALUES (54, 11, 'ingreso', 'Pago reparación OT-2026-0034', 10.00, 'OT-2026-0034', 4, '2026-06-16 10:53:34');
INSERT INTO `movimientos_caja` VALUES (55, 11, 'ingreso', 'Pago reparación OT-2026-0036', 10.00, 'OT-2026-0036', 4, '2026-06-16 12:26:48');
INSERT INTO `movimientos_caja` VALUES (56, 11, 'ingreso', 'Venta VTA-2026-0020 (Efectivo)', 20.00, 'VTA-2026-0020', 4, '2026-06-16 12:28:21');
INSERT INTO `movimientos_caja` VALUES (57, 10, 'ingreso', 'Pago reparación OT-2026-0037', 10.00, 'OT-2026-0037', 1, '2026-06-16 15:09:17');
INSERT INTO `movimientos_caja` VALUES (58, 11, 'ingreso', 'Pago reparación OT-2026-0038', 10.00, 'OT-2026-0038', 4, '2026-06-16 15:12:27');
INSERT INTO `movimientos_caja` VALUES (59, 11, 'ingreso', 'Pago reparación OT-2026-0035', 50.00, 'OT-2026-0035', 4, '2026-06-16 15:57:22');
INSERT INTO `movimientos_caja` VALUES (60, 11, 'ingreso', 'Pago reparación OT-2026-0029', 75.00, 'OT-2026-0029', 4, '2026-06-16 16:42:50');
INSERT INTO `movimientos_caja` VALUES (61, 11, 'ingreso', 'Pago reparación OT-2026-0039', 10.00, 'OT-2026-0039', 4, '2026-06-16 16:44:36');

-- ----------------------------
-- Table structure for notas_credito
-- ----------------------------
DROP TABLE IF EXISTS `notas_credito`;
CREATE TABLE `notas_credito`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int NOT NULL,
  `tipo_nota` enum('credito','debito') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'credito',
  `serie` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` int UNSIGNED NOT NULL DEFAULT 1,
  `cod_motivo` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `des_motivo` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `aplica_igv` tinyint(1) NOT NULL DEFAULT 1,
  `sunat_xml` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `sunat_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sunat_qr` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `sunat_cdr` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `sunat_estado` enum('pendiente','aceptado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `sunat_mensaje` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sunat_fecha` datetime NULL DEFAULT NULL,
  `estado` enum('activa','anulada') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'activa',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_venta_id`(`venta_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notas_credito
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1110 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordenes_trabajo
-- ----------------------------
INSERT INTO `ordenes_trabajo` VALUES (1070, 'OT-2026-0001', '715A463B', 597, 1077, 8, 5, 4, 'entregado', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 65.00, 10.00, 75.00, 0.00, 75.00, 1, 'whatsapp', '2026-06-07 17:50:33', NULL, 0, NULL, '2026-06-07 17:44:14', '2026-06-07', '2026-06-07 17:45:11', 1, 'efectivo', '2026-06-07 17:50:41', '2026-06-07 17:44:14', '2026-06-07 17:50:41');
INSERT INTO `ordenes_trabajo` VALUES (1071, 'OT-2026-0002', '820607BF', 597, 1078, 13, 5, 4, 'ingresado', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 30.00, 35.00, 65.00, 0.00, 65.00, 1, 'firma', '2026-06-07 17:58:14', NULL, 30, NULL, '2026-06-07 17:58:04', NULL, NULL, 0, NULL, NULL, '2026-06-07 17:58:04', '2026-06-07 17:58:14');
INSERT INTO `ordenes_trabajo` VALUES (1072, 'OT-2026-0003', '2501DE48', 597, 1079, 13, NULL, 4, 'devuelto_al_cliente', 'PANTALLA', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 30.00, 35.00, 65.00, 0.00, 65.00, 1, 'whatsapp', '2026-06-07 17:59:48', NULL, 30, NULL, '2026-06-07 17:59:19', NULL, NULL, 1, 'efectivo', '2026-06-07 18:00:02', '2026-06-07 17:59:19', '2026-06-14 19:44:29');
INSERT INTO `ordenes_trabajo` VALUES (1073, 'OT-2026-0004', '78B8A1DB', 599, 1080, 9, 5, 4, 'entregado', 'pantalla rota', 'cambio de pantalla, no se descarta otra falla', NULL, NULL, '{\"_observacion\":\"no enciende, tapa trasera rota\"}', 0.00, 70.00, 15.00, 85.00, 0.00, 85.00, 1, 'firma', '2026-06-13 17:13:26', NULL, 0, NULL, '2026-06-13 16:59:51', '2026-06-13', '2026-06-13 18:41:25', 1, 'efectivo', '2026-06-13 17:13:35', '2026-06-13 16:59:51', '2026-06-13 18:41:25');
INSERT INTO `ordenes_trabajo` VALUES (1074, 'OT-2026-0005', '2D709E74', 600, 1081, 12, 5, 4, 'entregado', 'no carga bien, pantalla quebrada', 'no carga bien, pantalla quebrada', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 50.00, 35.00, 85.00, 0.00, 85.00, 1, 'firma', '2026-06-13 19:38:29', NULL, 0, NULL, '2026-06-13 19:38:20', '2026-06-13', '2026-06-13 19:38:49', 1, 'yape', '2026-06-13 19:38:38', '2026-06-13 19:38:20', '2026-06-13 19:38:49');
INSERT INTO `ordenes_trabajo` VALUES (1075, 'OT-2026-0006', '49434F39', 601, 1082, 8, 5, 4, 'entregado', 'pantalla rota', 'pantalla rota, nose reporta falla visible', NULL, NULL, '{\"_observacion\":\"tapa rota\"}', 0.00, 70.00, 10.00, 80.00, 0.00, 80.00, 1, 'firma', '2026-06-14 10:24:32', NULL, 0, NULL, '2026-06-14 10:24:21', '2026-06-14', '2026-06-14 11:57:19', 1, 'efectivo', '2026-06-14 11:57:11', '2026-06-14 10:24:21', '2026-06-14 11:57:19');
INSERT INTO `ordenes_trabajo` VALUES (1076, 'OT-2026-0007', 'C2D3556D', 602, 1083, 8, 6, 4, 'devuelto_al_cliente', 'sin zocalo', 'sin zocalo', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 30.00, 10.00, 40.00, 0.00, 40.00, 1, 'firma', '2026-06-14 10:36:54', NULL, 0, NULL, '2026-06-14 10:36:51', '2026-06-14', NULL, 0, NULL, NULL, '2026-06-14 10:36:51', '2026-06-14 19:42:48');
INSERT INTO `ordenes_trabajo` VALUES (1077, 'OT-2026-0008', '63481EAA', 603, 1084, 8, 7, 4, 'entregado', 'cables sueltos', 'cables sueltos', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-14 10:39:44', NULL, 0, NULL, '2026-06-14 10:39:40', '2026-06-14', '2026-06-14 10:39:59', 1, 'yape', '2026-06-14 10:39:50', '2026-06-14 10:39:40', '2026-06-14 10:39:59');
INSERT INTO `ordenes_trabajo` VALUES (1078, 'OT-2026-0009', '8D138ED4', 605, 1085, 9, 9, 4, 'entregado', 'PANTALLA ROTA', 'CAMBIO PANTALLA', '', '', '{\"_observacion\":\"\"}', 0.00, 65.00, 15.00, 80.00, 0.00, 80.00, 1, 'firma', '2026-06-14 12:37:09', NULL, 0, NULL, '2026-06-14 12:36:53', NULL, '2026-06-14 14:13:18', 1, 'efectivo', '2026-06-14 12:39:38', '2026-06-14 12:36:53', '2026-06-14 14:15:56');
INSERT INTO `ordenes_trabajo` VALUES (1079, 'OT-2026-0010', 'F1FA3EC8', 598, 1086, 8, 7, 4, 'entregado', 'zocalo', 'zocalo', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 5.00, 10.00, 15.00, 0.00, 15.00, 1, 'firma', '2026-06-14 13:04:58', NULL, 0, NULL, '2026-06-14 13:04:50', NULL, '2026-06-14 13:05:19', 1, 'yape', '2026-06-14 13:05:09', '2026-06-14 13:04:50', '2026-06-14 13:05:19');
INSERT INTO `ordenes_trabajo` VALUES (1080, 'OT-2026-0011', 'B061D80E', 606, 1087, 10, 9, 4, 'entregado', 'mantenimiento de zocalo', 'mantenimiento en zocalo', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 20.00, 20.00, 0.00, 20.00, 1, 'firma', '2026-06-14 14:15:10', NULL, 0, NULL, '2026-06-14 14:15:05', '2026-06-14', '2026-06-14 14:15:29', 1, 'yape', '2026-06-14 14:15:21', '2026-06-14 14:15:05', '2026-06-14 14:15:29');
INSERT INTO `ordenes_trabajo` VALUES (1081, 'OT-2026-0012', 'D574CD80', 598, 1093, 7, 6, 4, 'entregado', 'virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 5.00, 5.00, 0.00, 5.00, 1, 'firma', '2026-06-14 15:05:59', NULL, 0, NULL, '2026-06-14 15:05:56', '2026-06-14', '2026-06-14 15:06:10', 1, 'efectivo', '2026-06-14 15:06:01', '2026-06-14 15:05:56', '2026-06-14 15:06:10');
INSERT INTO `ordenes_trabajo` VALUES (1082, 'OT-2026-0013', 'AC911E4D', 598, 1094, 8, 6, 4, 'entregado', 'virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-14 15:19:11', NULL, 0, NULL, '2026-06-14 15:19:07', '2026-06-14', '2026-06-14 15:19:21', 1, 'efectivo', '2026-06-14 15:19:17', '2026-06-14 15:19:07', '2026-06-14 15:19:21');
INSERT INTO `ordenes_trabajo` VALUES (1083, 'OT-2026-0014', '80543CF2', 598, 1095, 7, 6, 4, 'entregado', 'soldadura de cables', 'soldadura de cables', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 5.00, 5.00, 0.00, 5.00, 1, 'firma', '2026-06-14 16:06:05', NULL, 0, NULL, '2026-06-14 16:06:01', '2026-06-14', '2026-06-14 16:06:11', 1, 'efectivo', '2026-06-14 16:06:07', '2026-06-14 16:06:01', '2026-06-14 16:06:11');
INSERT INTO `ordenes_trabajo` VALUES (1084, 'OT-2026-0015', '7835CB5D', 607, 1096, 8, 9, 4, 'entregado', 'virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-14 16:26:36', NULL, 0, NULL, '2026-06-14 16:26:33', '2026-06-14', '2026-06-14 16:26:43', 1, 'efectivo', '2026-06-14 16:26:38', '2026-06-14 16:26:33', '2026-06-14 16:26:43');
INSERT INTO `ordenes_trabajo` VALUES (1085, 'OT-2026-0016', '85DE11FB', 598, 1097, 8, 5, 4, 'entregado', 'virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-14 16:56:58', NULL, 0, NULL, '2026-06-14 16:56:54', '2026-06-14', '2026-06-14 16:57:08', 1, 'efectivo', '2026-06-14 16:57:00', '2026-06-14 16:56:54', '2026-06-14 16:57:08');
INSERT INTO `ordenes_trabajo` VALUES (1086, 'OT-2026-0017', '5C2A935A', 608, 1098, 13, 6, 4, 'entregado', 'falla cargador, teclado y sistema', 'falla cargador, teclado y sistema', '', '', '{\"_observacion\":\"\"}', 0.00, 100.00, 130.00, 230.00, 0.00, 230.00, 1, 'firma', '2026-06-14 17:03:40', NULL, 0, NULL, '2026-06-14 17:03:34', '2026-06-14', '2026-06-14 20:05:34', 1, 'efectivo', '2026-06-14 19:54:04', '2026-06-14 17:03:34', '2026-06-14 20:05:34');
INSERT INTO `ordenes_trabajo` VALUES (1087, 'OT-2026-0018', '19D12BFB', 598, 1099, 10, 7, 4, 'entregado', 'corto en placa', 'corto en placa', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 20.00, 20.00, 0.00, 20.00, 1, 'firma', '2026-06-14 17:08:39', NULL, 0, NULL, '2026-06-14 17:08:35', '2026-06-14', '2026-06-14 17:08:59', 1, 'yape', '2026-06-14 17:08:42', '2026-06-14 17:08:35', '2026-06-14 17:08:59');
INSERT INTO `ordenes_trabajo` VALUES (1088, 'OT-2026-0019', 'CBBF193B', 609, 1100, 8, 7, 4, 'entregado', 'no funciona el tactil', 'falla tactil', '', '', '{\"_observacion\":\"\"}', 0.00, 95.00, 10.00, 105.00, 0.00, 105.00, 1, 'firma', '2026-06-14 17:48:22', NULL, 0, NULL, '2026-06-14 17:48:13', '2026-06-14', '2026-06-14 18:50:09', 1, 'yape', '2026-06-14 19:33:43', '2026-06-14 17:48:13', '2026-06-14 19:33:43');
INSERT INTO `ordenes_trabajo` VALUES (1089, 'OT-2026-0020', 'A88F1C88', 610, 1101, 7, 5, 4, 'entregado', 'lente de camara rota', 'lente de camara rota', NULL, NULL, '{\"_observacion\":\"tapa rota, pantalla rota\"}', 0.00, 15.00, 5.00, 20.00, 0.00, 20.00, 1, 'firma', '2026-06-14 18:32:55', NULL, 0, NULL, '2026-06-14 18:32:51', '2026-06-14', '2026-06-14 19:32:36', 1, 'yape', '2026-06-14 19:32:31', '2026-06-14 18:32:51', '2026-06-14 19:32:36');
INSERT INTO `ordenes_trabajo` VALUES (1090, 'OT-2026-0021', 'DB59470E', 598, 1102, 8, 6, 4, 'entregado', 'eliminacion de virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-15 09:33:49', NULL, 0, NULL, '2026-06-15 09:33:45', '2026-06-15', '2026-06-15 09:34:06', 1, 'efectivo', '2026-06-15 09:33:56', '2026-06-15 09:33:45', '2026-06-15 09:34:06');
INSERT INTO `ordenes_trabajo` VALUES (1091, 'OT-2026-0022', '6B2ECC54', 611, 1103, 8, 5, 4, 'entregado', 'pantalla rota', 'pantalla rota', '', '', '{\"_observacion\":\"\"}', 0.00, 70.00, 10.00, 80.00, 0.00, 80.00, 1, 'firma', '2026-06-15 09:38:29', NULL, 0, NULL, '2026-06-15 09:38:25', '2026-06-15', '2026-06-15 13:01:23', 1, 'yape', '2026-06-15 13:00:44', '2026-06-15 09:38:25', '2026-06-15 13:03:10');
INSERT INTO `ordenes_trabajo` VALUES (1092, 'OT-2026-0023', '270DD2F3', 598, 1104, 9, 5, 4, 'entregado', 'cambio de pantalla', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 15.00, 15.00, 0.00, 15.00, 1, 'firma', '2026-06-15 13:04:57', NULL, 0, NULL, '2026-06-15 13:04:51', '2026-06-15', '2026-06-15 13:05:12', 1, 'efectivo', '2026-06-15 13:05:04', '2026-06-15 13:04:51', '2026-06-15 13:05:12');
INSERT INTO `ordenes_trabajo` VALUES (1093, 'OT-2026-0024', '7DCF438B', 612, 1105, NULL, 9, 4, 'entregado', 'cambio de pantalla', '', NULL, NULL, '{\"_observacion\":\"rayones\"}', 0.00, 75.00, 0.00, 75.00, 0.00, 75.00, 1, 'firma', '2026-06-15 14:55:28', NULL, 0, NULL, '2026-06-15 14:55:16', '2026-06-15', '2026-06-15 15:33:35', 1, 'efectivo', '2026-06-15 15:33:27', '2026-06-15 14:55:16', '2026-06-15 15:33:35');
INSERT INTO `ordenes_trabajo` VALUES (1094, 'OT-2026-0025', 'E5B39035', 613, 1106, NULL, 6, 4, 'entregado', 'venta de cargador', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 20.00, 0.00, 20.00, 0.00, 20.00, 1, 'firma', '2026-06-15 17:00:08', NULL, 0, NULL, '2026-06-15 16:56:14', '2026-06-15', '2026-06-15 17:00:27', 1, 'efectivo', '2026-06-15 17:00:16', '2026-06-15 16:56:14', '2026-06-15 17:00:27');
INSERT INTO `ordenes_trabajo` VALUES (1095, 'OT-2026-0026', '4E88C8B2', 614, 1107, 10, 5, 4, 'entregado', 'humedad', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 65.00, 20.00, 85.00, 0.00, 85.00, 1, 'firma', '2026-06-15 19:05:38', NULL, 0, NULL, '2026-06-15 17:27:20', '2026-06-15', '2026-06-15 19:06:12', 1, 'efectivo', '2026-06-15 19:05:49', '2026-06-15 17:27:20', '2026-06-15 19:06:12');
INSERT INTO `ordenes_trabajo` VALUES (1096, 'OT-2026-0027', 'A626C732', 615, 1108, NULL, 5, 4, 'entregado', 'carcasa', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 35.00, 0.00, 35.00, 0.00, 35.00, 1, 'firma', '2026-06-15 18:08:42', NULL, 0, NULL, '2026-06-15 18:08:27', '2026-06-15', '2026-06-15 20:24:54', 1, 'yape', '2026-06-15 18:08:50', '2026-06-15 18:08:27', '2026-06-15 20:24:54');
INSERT INTO `ordenes_trabajo` VALUES (1097, 'OT-2026-0028', 'B0AE1E61', 598, 1109, 7, 5, 4, 'entregado', 'limpieza de zocalo', 'limpieza de zocalo', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 5.00, 5.00, 0.00, 5.00, 1, 'firma', '2026-06-15 18:16:08', NULL, 0, NULL, '2026-06-15 18:16:04', '2026-06-15', '2026-06-15 18:16:25', 1, 'yape', '2026-06-15 18:16:14', '2026-06-15 18:16:04', '2026-06-15 18:16:25');
INSERT INTO `ordenes_trabajo` VALUES (1098, 'OT-2026-0029', 'C6A210D6', 616, 1110, 9, 5, 4, 'entregado', 'cambio de pantalla', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 60.00, 15.00, 75.00, 0.00, 75.00, 1, 'firma', '2026-06-16 16:42:47', NULL, 0, NULL, '2026-06-15 19:04:15', '2026-06-16', '2026-06-16 16:42:57', 1, 'efectivo', '2026-06-16 16:42:50', '2026-06-15 19:04:15', '2026-06-16 16:42:57');
INSERT INTO `ordenes_trabajo` VALUES (1099, 'OT-2026-0030', '196244C0', 617, 1111, 9, 5, 4, 'devuelto_al_cliente', 'cambio de pantalla', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 60.00, 15.00, 75.00, 0.00, 75.00, 1, 'firma', '2026-06-15 19:04:29', NULL, 0, NULL, '2026-06-15 19:04:16', '2026-06-16', NULL, 0, NULL, NULL, '2026-06-15 19:04:16', '2026-06-15 20:23:35');
INSERT INTO `ordenes_trabajo` VALUES (1100, 'OT-2026-0031', '54B69991', 598, 1112, 8, 7, 4, 'entregado', 'configuracion de sistema', 'configuracion de sistema', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-15 20:22:35', NULL, 0, NULL, '2026-06-15 20:22:32', '2026-06-15', '2026-06-15 20:22:44', 1, 'efectivo', '2026-06-15 20:22:37', '2026-06-15 20:22:32', '2026-06-15 20:22:44');
INSERT INTO `ordenes_trabajo` VALUES (1101, 'OT-2026-0032', '5736FBE5', 598, 1113, NULL, 6, 4, 'entregado', 'liberacion de virus', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 10.00, 0.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 10:44:37', NULL, 0, NULL, '2026-06-16 10:44:26', '2026-06-16', '2026-06-16 15:20:13', 1, 'efectivo', '2026-06-16 10:44:44', '2026-06-16 10:44:26', '2026-06-16 15:20:13');
INSERT INTO `ordenes_trabajo` VALUES (1102, 'OT-2026-0033', 'FEC170C4', 598, 1114, NULL, 6, 4, 'entregado', 'liberacion de virus', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 10.00, 0.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 10:45:46', NULL, 30, NULL, '2026-06-16 10:45:34', '2026-06-16', '2026-06-16 15:20:27', 1, 'yape', '2026-06-16 10:45:51', '2026-06-16 10:45:34', '2026-06-16 15:20:27');
INSERT INTO `ordenes_trabajo` VALUES (1103, 'OT-2026-0034', 'B21E2FE4', 618, 1115, NULL, 6, 4, 'entregado', 'optimizacion', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 10.00, 0.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 10:53:26', NULL, 0, NULL, '2026-06-16 10:53:21', '2026-06-16', '2026-06-16 15:20:45', 1, 'efectivo', '2026-06-16 10:53:34', '2026-06-16 10:53:21', '2026-06-16 15:20:45');
INSERT INTO `ordenes_trabajo` VALUES (1104, 'OT-2026-0035', 'BD0D9B56', 619, 1116, NULL, 6, 4, 'entregado', 'formateo', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 50.00, 0.00, 50.00, 0.00, 50.00, 1, 'firma', '2026-06-16 11:43:57', NULL, 0, NULL, '2026-06-16 11:43:47', '2026-06-16', '2026-06-16 15:57:27', 1, 'efectivo', '2026-06-16 15:57:22', '2026-06-16 11:43:47', '2026-06-16 15:57:27');
INSERT INTO `ordenes_trabajo` VALUES (1105, 'OT-2026-0036', '1F43AB8E', 620, 1117, 8, 9, 4, 'entregado', 'mantenimiento de zocalo', '', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 12:26:36', NULL, 0, NULL, '2026-06-16 12:26:24', '2026-06-16', '2026-06-16 12:26:46', 1, 'efectivo', '2026-06-16 12:26:48', '2026-06-16 12:26:24', '2026-06-16 12:26:48');
INSERT INTO `ordenes_trabajo` VALUES (1106, 'OT-2026-0037', '473EDCAE', 621, 1118, 8, 7, 1, 'devuelto_al_cliente', 'mojado y sin audio', 'mojado sin audio', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 15:09:11', NULL, 0, NULL, '2026-06-16 15:09:08', '2026-06-16', '2026-06-16 15:09:24', 1, 'yape', '2026-06-16 15:09:17', '2026-06-16 15:09:08', '2026-06-16 15:10:40');
INSERT INTO `ordenes_trabajo` VALUES (1107, 'OT-2026-0038', 'FAAD6F24', 621, 1119, 8, 7, 4, 'entregado', 'mojado sin audio', 'sin audio', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 15:12:16', NULL, 0, NULL, '2026-06-16 15:12:08', '2026-06-16', '2026-06-16 15:12:24', 1, 'efectivo', '2026-06-16 15:12:27', '2026-06-16 15:12:08', '2026-06-16 15:12:27');
INSERT INTO `ordenes_trabajo` VALUES (1108, 'OT-2026-0039', 'A5B74204', 598, 1120, 8, 7, 4, 'entregado', 'virus', 'virus', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 10.00, 10.00, 0.00, 10.00, 1, 'firma', '2026-06-16 16:44:28', NULL, 0, NULL, '2026-06-16 16:44:18', '2026-06-16', '2026-06-16 16:44:47', 1, 'yape', '2026-06-16 16:44:36', '2026-06-16 16:44:18', '2026-06-16 16:44:47');
INSERT INTO `ordenes_trabajo` VALUES (1109, 'OT-2026-0040', '904BBF69', 622, 1121, 12, 5, 4, 'control_calidad', 'FRP', 'FRP', NULL, NULL, '{\"_observacion\":\"\"}', 0.00, 0.00, 30.00, 30.00, 0.00, 30.00, 1, 'firma', '2026-06-16 18:12:22', NULL, 0, NULL, '2026-06-16 18:12:19', '2026-06-16', NULL, 0, NULL, NULL, '2026-06-16 18:12:19', '2026-06-16 18:14:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1492 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ot_repuestos
-- ----------------------------
INSERT INTO `ot_repuestos` VALUES (1467, 1071, NULL, 'CARCASA SAMSUNG A12 360 [CSA12360]', 1.00, 30.00, 30.00);
INSERT INTO `ot_repuestos` VALUES (1468, 1072, NULL, 'CARCASA SAMSUNG A12 360 [CSA12360]', 1.00, 30.00, 30.00);
INSERT INTO `ot_repuestos` VALUES (1469, 1073, 429, 'PANTALLA OPPO A77 [POA77]', 1.00, 70.00, 70.00);
INSERT INTO `ot_repuestos` VALUES (1470, 1074, 89, 'PANTALLA SAMSUNG A13/A23 4G [L39124]', 1.00, 50.00, 50.00);
INSERT INTO `ot_repuestos` VALUES (1471, 1075, NULL, 'pantalla motorola v50 desing', 1.00, 70.00, 70.00);
INSERT INTO `ot_repuestos` VALUES (1472, 1076, NULL, 'zocalo para parlante', 1.00, 30.00, 30.00);
INSERT INTO `ot_repuestos` VALUES (1474, 1078, 88, 'PANTALLA SAMSUNG A02S/A03/A03S [L38241]', 1.00, 65.00, 65.00);
INSERT INTO `ot_repuestos` VALUES (1476, 1089, NULL, 'lente de camara', 1.00, 15.00, 15.00);
INSERT INTO `ot_repuestos` VALUES (1477, 1088, 82, 'PANTALLA REDMI NOTE 10 /10S INCELL [L17760]', 1.00, 70.00, 70.00);
INSERT INTO `ot_repuestos` VALUES (1478, 1088, 446, 'PRODUCTOS VARIADOS [PRV]', 1.00, 20.00, 20.00);
INSERT INTO `ot_repuestos` VALUES (1479, 1088, 446, 'PRODUCTOS VARIADOS [PRV]', 1.00, 5.00, 5.00);
INSERT INTO `ot_repuestos` VALUES (1482, 1086, 446, 'PRODUCTOS VARIADOS [PRV]', 1.00, 80.00, 80.00);
INSERT INTO `ot_repuestos` VALUES (1483, 1086, 446, 'PRODUCTOS VARIADOS [PRV]', 1.00, 20.00, 20.00);
INSERT INTO `ot_repuestos` VALUES (1489, 1091, NULL, 'pantalla realme c33', 1.00, 70.00, 70.00);
INSERT INTO `ot_repuestos` VALUES (1490, 1098, NULL, 'compra de pantalla', 1.00, 60.00, 60.00);
INSERT INTO `ot_repuestos` VALUES (1491, 1099, NULL, 'compra de pantalla', 1.00, 60.00, 60.00);

-- ----------------------------
-- Table structure for ot_tecnicos
-- ----------------------------
DROP TABLE IF EXISTS `ot_tecnicos`;
CREATE TABLE `ot_tecnicos`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ot_id` int UNSIGNED NOT NULL,
  `tecnico_id` int UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_ot_tecnico`(`ot_id` ASC, `tecnico_id` ASC) USING BTREE,
  INDEX `idx_ot`(`ot_id` ASC) USING BTREE,
  INDEX `idx_tecnico`(`tecnico_id` ASC) USING BTREE,
  CONSTRAINT `ot_tecnicos_ibfk_ot` FOREIGN KEY (`ot_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ot_tecnicos_ibfk_tec` FOREIGN KEY (`tecnico_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ot_tecnicos
-- ----------------------------
INSERT INTO `ot_tecnicos` VALUES (1, 1070, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (2, 1071, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (3, 1073, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (4, 1074, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (5, 1075, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (6, 1085, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (7, 1089, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (8, 1091, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (9, 1092, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (10, 1095, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (11, 1096, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (12, 1097, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (13, 1098, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (14, 1099, 5, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (15, 1076, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (16, 1081, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (17, 1082, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (18, 1083, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (19, 1086, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (20, 1090, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (21, 1094, 6, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (22, 1077, 7, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (23, 1079, 7, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (24, 1087, 7, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (25, 1088, 7, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (26, 1100, 7, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (27, 1078, 9, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (28, 1080, 9, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (29, 1084, 9, '2026-06-16 09:19:16');
INSERT INTO `ot_tecnicos` VALUES (30, 1093, 9, '2026-06-16 09:19:16');

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
) ENGINE = InnoDB AUTO_INCREMENT = 447 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `productos` VALUES (22, 'CSA25', 'CARCASA SAMSUNG A25', '', 23, 'GENERICO', 'A25', '', '', 6.00, 20.00, 6.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-14 19:08:58', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (23, 'CSA26360', 'CARCASA SAMSUNG A26 360', '', 23, 'GENERICO', 'A26 360', '', '', 8.00, 30.00, 12.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (24, 'CSA06', 'CARCASA SAMSUNG A06', '', 23, 'GENERICO', 'A06', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (25, 'CMG10', 'CARCASA MOTO G10/G20/G30', '', 23, 'GENERICO', 'G10', '', '', 8.00, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (26, 'CSA02R', 'CARCASA SAMSUNG A02 ROBOT', '', 23, 'GENERICO', '02 R', '', '', 10.00, 25.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (27, 'CSA02S', 'CARCASA SAMSUNG A02S', '', 23, 'GENERICO', 'A02S', '', '', 9.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (28, 'CSA03S', 'CARCASA SAMSUNG A03S', '', 23, 'GENERICO', 'A03S', '', '', 6.00, 20.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (29, 'CSA03', 'CARCASA SAMSUNG A03', '', 23, 'GENERICO', 'A03', '', '', 8.00, 20.00, 5.00, 1.00, 100.00, 'unidad', 1, '2026-06-07 16:56:22', '2026-06-13 18:37:59', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (51, 'ABFXU', 'AUDIFONO BFXU CABLE BUDS 2 PLUS', '', 65, 'BFXU', 'AUDIFONO', '', '', 3.00, 9.99, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-13 13:47:59', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (52, 'ASR31', 'AUDIFONO CON CABLE SMARTEL R31', '', 65, 'SMARTEL', 'AUDIFONO', '', '', 5.00, 11.80, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-13 13:48:52', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (82, 'L17760', 'PANTALLA REDMI NOTE 10 /10S INCELL', '', 74, 'TIPO', 'NOTE 10', '', '', 37.00, 47.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-14 17:48:13', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (83, 'L18356', 'PANTALLA HUAWEI Y9 PRIME / Y9S', '', 74, 'TIPO', 'Y9 PRIME', '', '', 37.00, 47.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (84, 'L25188', 'PANTALLA HONOR X7 - Original Self Welded', '', 74, 'TIPO', 'X7', '', '', 38.00, 48.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (85, 'L25189', 'PANTALLA HONOR X8 - Original Self Welded', '', 74, 'TIPO', 'X8', '', '', 42.00, 52.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (86, 'L31758', 'PANTALLA SAMSUNG A53 CON MARCO - INCELL', '', 74, 'TIPO', 'A53', '', '', 80.00, 90.00, 7.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (87, 'L37739', 'PANTALLA HUAWEI P40 LITE', '', 74, 'TIPO', 'P40LITE', '', '', 40.00, 50.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-12 11:37:27', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (88, 'L38241', 'PANTALLA SAMSUNG A02S/A03/A03S', '', 74, 'TIPO', 'A02S', '', '', 37.00, 47.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-14 12:36:53', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (89, 'L39124', 'PANTALLA SAMSUNG A13/A23 4G', '', 74, 'TIPO', 'A13', '', '', 45.00, 50.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-13 19:38:20', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (158, 'MCIP16PM', 'MICA COMPLETA IPHONE 16 PRO MAX', '', 76, 'GENERICO', 'I16PM', '', '', 0.90, 10.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-14 12:16:08', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (246, 'MSHX6A', 'MICA SIMPLE HONOR X6A', '', 77, 'GENERICO', 'X6A', '', '', 0.80, 5.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:27', '2026-06-14 19:35:45', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (368, 'TCC0541', 'CARGADOR ROMAX 6.2A 60W USB A TC', 'CARGADOR ROMAX TIPO C 6.2A 60W X MAYOR', 69, 'ROMAX', 'USB A TC', '', '', 10.00, 20.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-16 12:28:21', 1, 12.50, 'CARGADOR TURBO POWER ROMAX TIPO C DE 6.2A 60W', '[\"img_6a2ee270a6ef71.27187167.png\"]', 0);
INSERT INTO `productos` VALUES (369, 'TCC0543', 'CARGADOR ROMAX 6.2A 60W USB A IPHONE', 'CARGADOR ROMAX 6.2A 60W USB A IPHONE X MAYOR', 81, 'ROMAX', 'USB A IPHONE', '', '', 10.50, 20.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-14 15:52:15', 1, 12.50, '', '[\"img_6a2f147f6b2072.01486326.jpeg\"]', 0);
INSERT INTO `productos` VALUES (370, 'TCD0050', 'CABLE ROMAX 5.5A TV8', '', 71, 'ROMAX', 'TV8', '', '', 4.50, 15.00, 2.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (371, 'TCD0240', 'CABLE ROMAX 6A TV8', '', 71, 'ROMAX', 'TV8', '', '', 5.00, 10.00, 4.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (372, 'TCD0558', 'CABLE ROMAX 6A 66W USB A IPHONE', '', 72, 'ROMAX', 'USB A IPHONE', '', '', 5.00, 15.00, 3.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (373, 'TCD0562', 'CABLE ROMAX 6A 100W TC A TC', '', 83, 'ROMAX', 'TC A TC', '', '', 12.00, 20.00, 9.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-12 11:37:28', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (374, 'TCD0609', 'OTG ROMAX C A USB', '', 64, 'ROMAX', 'C A USB', '', '', 4.80, 10.00, 1.00, 1.00, 100.00, 'unidad', 1, '2026-06-12 11:37:28', '2026-06-13 18:35:31', 0, NULL, NULL, NULL, 0);
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
INSERT INTO `productos` VALUES (429, 'POA77', 'PANTALLA OPPO A77', 'PANTALLA OPPO A77', 74, 'OPPO', 'A77', '', '', 40.00, 70.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-13 16:53:51', '2026-06-13 16:59:51', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (430, 'TCD0973', 'CABLE ROMAX 6A 66W TC', 'CABLE DE CARGA RAPIDA TIPO C X MAYOR', 83, 'ROMAX', 'TCD0973', '', '', 4.20, 8.00, 50.00, 1.00, 100.00, 'unidad', 1, '2026-06-13 18:26:53', '2026-06-14 14:35:12', 1, 5.20, 'CABLE ROMAX TIPO C 6.0A 66W', '[\"img_6a2eff93cc6d73.46427769.png\"]', 0);
INSERT INTO `productos` VALUES (431, 'RD6146C', 'CARGADOR REDD 7.8A 85W TIPO C', 'CARGADOR REDD 7.8A 85W TIPO C X MAYOR', 69, 'REDD', 'RD6146C', '', '', 9.50, 25.00, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-13 19:22:36', '2026-06-14 17:14:28', 1, 12.50, '', '[\"img_6a2f277bbc4b27.50264077.jpeg\"]', 0);
INSERT INTO `productos` VALUES (432, 'RD32L', 'CABLE REDD USB A IPHONE', 'CABLE DE CARGA Y DATOS REDD DE 33W X MAYOR', 81, 'REDD', '32L', '', '', 2.00, 8.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 10:37:30', '2026-06-14 17:33:15', 1, 3.00, '', '[\"img_6a2f2b965d0fa2.09420269.jpeg\"]', 0);
INSERT INTO `productos` VALUES (433, 'SMV', 'SERVICIO DE MANTENIMIENTO VARIOS', 'SERVICIO DE MANTENIMIENTO DE EQUIPOS', 15, 'VARIOS', '', '', '', 1.00, 11.80, 0.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 11:01:30', '2026-06-14 11:04:48', 0, NULL, NULL, NULL, 0);
INSERT INTO `productos` VALUES (434, 'TCD0814', 'CABLE ROMAX 6A 60W TV8', 'CABLE DE CARGA RAPIDA TIPO V8 MARCA ROMAX X MAYOR', 71, 'ROMAX', 'TCD0814', '', '', 3.90, 8.00, 50.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 14:40:11', '2026-06-14 14:43:02', 1, 5.00, '', '[\"img_6a2f0446ed3af9.75708750.jpeg\"]', 0);
INSERT INTO `productos` VALUES (435, 'TCD0948', 'CABLE ROMAX TC A TC 6A 100W', 'CABLE ROMAX TC A TC 6A 100W X MAYOR', 87, 'ROMAX', 'TCD0948', '', '', 4.20, 10.01, 99.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 15:27:32', '2026-06-15 11:19:17', 1, 5.50, '', '[\"img_6a2f10abef94f0.87024189.jpeg\"]', 0);
INSERT INTO `productos` VALUES (437, 'TCC0521', 'CARGADOR ROMAX TC A TC 6.2A 66W', 'CARGADOR ROMAX TC A TC 6.2A 66W X MAYOR', 88, 'ROMAX', 'TCC0521', '', '', 14.50, 25.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 15:44:32', '2026-06-14 15:49:06', 1, 17.00, '', '[\"img_6a2f1314460b62.29068138.jpeg\",\"img_6a2f13c25856c9.64032759.jpeg\"]', 0);
INSERT INTO `productos` VALUES (438, 'TCC0542', 'CARGADOR ROMAX TV8 6.2A 60W', 'CARGADOR ROMAX TIPO V8 6.2A 60W X MAYOR', 70, 'ROMAX', 'TCC0542', '', '', 9.50, 20.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 16:08:03', '2026-06-14 16:09:10', 1, 12.50, '', '[\"img_6a2f187613f0b1.48984666.jpeg\"]', 0);
INSERT INTO `productos` VALUES (439, 'TCA0338', 'AUDIFONO ROMAX EXTRA BASS JACK 3.5', 'AUDIFONO ROMAX EXTRA BASS JACK 3.5 X MAYOR', 65, 'ROMAX', 'TCA0338', '', '', 5.00, 10.01, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 16:15:19', '2026-06-14 16:16:12', 1, 6.00, '', '[\"img_6a2f1a1c7ae647.01067165.jpeg\"]', 0);
INSERT INTO `productos` VALUES (440, 'TCC0660', 'CARGADOR DW TC 6A 55W', 'CARGADOR DW TC 6A 55W X MAYOR', 69, 'DW', 'TCC0660', '', '', 6.20, 15.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 16:30:59', '2026-06-14 16:31:42', 1, 8.00, '', '[\"img_6a2f1dbe820190.87655373.jpeg\"]', 0);
INSERT INTO `productos` VALUES (441, 'TCD182', 'CABLE DW 5.5A 30W USB A IPHONE', 'CABLE DW 5.5A 30W USB A IPHONE X MAYOR', 82, 'DW', 'TCD182', '', '', 2.50, 8.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 16:52:25', '2026-06-14 16:54:06', 1, 4.00, '', '[\"img_6a2f22fee9ea09.47700872.jpeg\"]', 0);
INSERT INTO `productos` VALUES (442, 'TCD0702', 'CABLE DW 5.5A 60W USB A TIPO C', 'CABLE DW 5.5A 60W USB A TIPO C X MAYOR', 83, 'DW', 'TCD0702', '', '', 2.60, 8.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 17:05:16', '2026-06-14 17:06:22', 1, 3.50, '', '[\"img_6a2f25de663d19.76405081.jpeg\"]', 0);
INSERT INTO `productos` VALUES (443, 'RD03L', 'CARGADOR REDD 3.8A USB A IPHONE', 'CARGADOR REDD 3.8A USB A IPHONE X MAYOR', 81, 'REDD', 'RD03L', '', '', 5.00, 15.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 17:21:11', '2026-06-14 17:25:05', 1, 8.50, '', '[\"img_6a2f2a413ad7d8.36889803.jpeg\"]', 0);
INSERT INTO `productos` VALUES (444, 'RD19T', 'CABLE REDD 6A TIPO C ECONOMICO', 'CABLE REDD 6A TIPO C ECONOMICO X MAYOR', 69, 'REDD', 'RD19T', '', '', 1.65, 7.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 17:39:25', '2026-06-14 17:41:04', 1, 2.50, '', '[\"img_6a2f2e00615814.64271727.jpeg\"]', 0);
INSERT INTO `productos` VALUES (445, 'ABF9', 'AUDIFONOS BLUETOOTH F9 5.0', 'AUDIFONOS BLUETOOTH F9 5.0 X MAYOR', 89, 'TWE', 'F9-5', '', '', 7.20, 20.00, 100.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 17:48:29', '2026-06-14 17:49:41', 1, 10.00, '', '[\"img_6a2f2fedec3a96.58790541.jpeg\"]', 0);
INSERT INTO `productos` VALUES (446, 'PRV', 'PRODUCTOS VARIADOS', 'PRODUCTO DE PROVEEDOR', 21, 'VARIOS', '', '', '', 0.00, 0.00, 95.00, 1.00, 100.00, 'unidad', 1, '2026-06-14 19:19:34', '2026-06-14 20:05:28', 0, NULL, NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicio_repuestos
-- ----------------------------
INSERT INTO `servicio_repuestos` VALUES (3, 13, 34, 1.00, 30.00);

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
INSERT INTO `servicios` VALUES (7, 'MANO DE OBRA 5', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'instalacion', 5.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:33:12', '2026-06-14 16:59:31');
INSERT INTO `servicios` VALUES (8, 'MANO DE OBRA 10', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'mantenimiento', 10.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:33:57', '2026-06-14 16:57:37');
INSERT INTO `servicios` VALUES (9, 'MANO DE OBRA 15', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'instalacion', 15.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:34:47', '2026-06-14 16:58:36');
INSERT INTO `servicios` VALUES (10, 'MANO DE OBRA 20', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'instalacion', 20.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:34:47', '2026-06-14 16:58:54');
INSERT INTO `servicios` VALUES (11, 'MANO DE OBRA 25', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'instalacion', 25.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:36:06', '2026-06-14 16:59:06');
INSERT INTO `servicios` VALUES (12, 'MANO DE OBRA 30', 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', 'instalacion', 30.00, NULL, NULL, 0, 0, 1, '', '2026-06-07 17:37:02', '2026-06-14 16:59:17');
INSERT INTO `servicios` VALUES (13, 'MANO DE OBRA Y/O SERVICIO DE MANTENIMIENTO', '', 'diagnostico', 0.00, NULL, NULL, 30, 0, 1, '', '2026-06-07 17:54:52', '2026-06-14 17:01:38');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2979 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `stock_almacen` VALUES (43, 1, 22, 6.00, '2026-06-14 19:08:58');
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
INSERT INTO `stock_almacen` VALUES (57, 1, 29, 5.00, '2026-06-13 18:38:00');
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
INSERT INTO `stock_almacen` VALUES (163, 1, 82, 0.00, '2026-06-14 17:48:13');
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
INSERT INTO `stock_almacen` VALUES (175, 1, 88, 0.00, '2026-06-14 12:36:53');
INSERT INTO `stock_almacen` VALUES (176, 2, 88, 0.00, '2026-06-12 11:37:27');
INSERT INTO `stock_almacen` VALUES (177, 1, 89, 0.00, '2026-06-13 19:38:20');
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
INSERT INTO `stock_almacen` VALUES (315, 1, 158, 2.00, '2026-06-14 12:16:08');
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
INSERT INTO `stock_almacen` VALUES (491, 1, 246, 0.00, '2026-06-14 19:35:45');
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
INSERT INTO `stock_almacen` VALUES (735, 1, 368, 1.00, '2026-06-16 12:28:21');
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
INSERT INTO `stock_almacen` VALUES (747, 1, 374, 1.00, '2026-06-13 18:35:31');
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
INSERT INTO `stock_almacen` VALUES (857, 1, 429, 0.00, '2026-06-13 16:59:51');
INSERT INTO `stock_almacen` VALUES (858, 2, 429, 0.00, '2026-06-13 16:53:51');
INSERT INTO `stock_almacen` VALUES (859, 1, 430, 0.00, '2026-06-13 18:37:16');
INSERT INTO `stock_almacen` VALUES (860, 2, 430, 0.00, '2026-06-13 18:26:53');
INSERT INTO `stock_almacen` VALUES (861, 1, 431, 0.00, '2026-06-13 19:24:05');
INSERT INTO `stock_almacen` VALUES (862, 2, 431, 0.00, '2026-06-13 19:22:36');
INSERT INTO `stock_almacen` VALUES (863, 1, 432, 0.00, '2026-06-14 10:41:59');
INSERT INTO `stock_almacen` VALUES (864, 2, 432, 0.00, '2026-06-14 10:37:30');
INSERT INTO `stock_almacen` VALUES (865, 1, 433, 0.00, '2026-06-14 11:04:48');
INSERT INTO `stock_almacen` VALUES (866, 2, 433, 0.00, '2026-06-14 11:01:30');
INSERT INTO `stock_almacen` VALUES (867, 1, 434, 50.00, '2026-06-14 14:40:11');
INSERT INTO `stock_almacen` VALUES (868, 2, 434, 0.00, '2026-06-14 14:40:11');
INSERT INTO `stock_almacen` VALUES (869, 3, 433, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (870, 3, 7, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (871, 3, 8, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (872, 3, 9, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (873, 3, 46, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (874, 3, 47, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (875, 3, 10, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (876, 3, 11, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (877, 3, 12, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (878, 3, 13, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (879, 3, 14, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (880, 3, 15, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (881, 3, 16, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (882, 3, 17, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (883, 3, 18, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (884, 3, 19, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (885, 3, 20, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (886, 3, 21, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (887, 3, 22, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (888, 3, 23, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (889, 3, 24, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (890, 3, 25, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (891, 3, 26, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (892, 3, 27, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (893, 3, 28, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (894, 3, 29, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (895, 3, 30, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (896, 3, 31, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (897, 3, 32, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (898, 3, 33, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (899, 3, 34, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (900, 3, 35, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (901, 3, 36, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (902, 3, 37, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (903, 3, 38, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (904, 3, 39, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (905, 3, 40, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (906, 3, 41, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (907, 3, 42, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (908, 3, 43, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (909, 3, 44, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (910, 3, 45, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (911, 3, 48, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (912, 3, 49, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (913, 3, 50, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (914, 3, 374, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (915, 3, 51, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (916, 3, 52, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (917, 3, 53, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (918, 3, 54, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (919, 3, 56, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (920, 3, 55, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (921, 3, 57, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (922, 3, 66, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (923, 3, 58, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (924, 3, 359, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (925, 3, 362, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (926, 3, 364, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (927, 3, 365, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (928, 3, 368, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (929, 3, 431, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (930, 3, 59, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (931, 3, 60, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (932, 3, 62, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (933, 3, 357, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (934, 3, 358, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (935, 3, 366, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (936, 3, 367, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (937, 3, 376, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (938, 3, 423, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (939, 3, 61, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (940, 3, 64, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (941, 3, 370, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (942, 3, 371, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (943, 3, 434, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (944, 3, 63, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (945, 3, 65, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (946, 3, 372, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (947, 3, 67, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (948, 3, 68, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (949, 3, 69, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (950, 3, 70, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (951, 3, 71, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (952, 3, 72, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (953, 3, 73, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (954, 3, 74, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (955, 3, 75, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (956, 3, 76, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (957, 3, 77, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (958, 3, 78, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (959, 3, 79, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (960, 3, 80, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (961, 3, 81, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (962, 3, 82, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (963, 3, 83, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (964, 3, 84, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (965, 3, 85, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (966, 3, 86, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (967, 3, 87, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (968, 3, 88, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (969, 3, 89, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (970, 3, 90, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (971, 3, 91, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (972, 3, 92, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (973, 3, 93, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (974, 3, 324, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (975, 3, 325, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (976, 3, 326, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (977, 3, 327, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (978, 3, 328, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (979, 3, 329, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (980, 3, 330, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (981, 3, 331, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (982, 3, 332, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (983, 3, 333, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (984, 3, 334, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (985, 3, 335, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (986, 3, 336, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (987, 3, 337, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (988, 3, 338, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (989, 3, 339, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (990, 3, 340, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (991, 3, 341, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (992, 3, 342, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (993, 3, 343, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (994, 3, 344, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (995, 3, 345, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (996, 3, 346, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (997, 3, 347, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (998, 3, 348, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (999, 3, 349, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1000, 3, 350, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1001, 3, 352, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1002, 3, 353, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1003, 3, 354, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1004, 3, 355, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1005, 3, 356, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1006, 3, 429, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1007, 3, 94, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1008, 3, 95, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1009, 3, 96, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1010, 3, 97, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1011, 3, 98, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1012, 3, 99, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1013, 3, 100, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1014, 3, 101, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1015, 3, 102, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1016, 3, 103, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1017, 3, 104, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1018, 3, 105, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1019, 3, 106, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1020, 3, 107, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1021, 3, 108, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1022, 3, 109, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1023, 3, 110, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1024, 3, 111, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1025, 3, 112, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1026, 3, 113, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1027, 3, 114, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1028, 3, 115, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1029, 3, 116, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1030, 3, 117, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1031, 3, 118, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1032, 3, 119, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1033, 3, 120, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1034, 3, 121, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1035, 3, 122, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1036, 3, 123, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1037, 3, 124, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1038, 3, 125, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1039, 3, 126, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1040, 3, 127, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1041, 3, 128, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1042, 3, 129, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1043, 3, 130, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1044, 3, 131, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1045, 3, 132, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1046, 3, 133, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1047, 3, 134, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1048, 3, 135, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1049, 3, 136, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1050, 3, 137, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1051, 3, 138, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1052, 3, 139, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1053, 3, 140, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1054, 3, 141, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1055, 3, 142, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1056, 3, 143, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1057, 3, 144, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1058, 3, 145, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1059, 3, 146, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1060, 3, 147, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1061, 3, 148, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1062, 3, 149, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1063, 3, 150, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1064, 3, 151, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1065, 3, 152, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1066, 3, 153, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1067, 3, 154, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1068, 3, 155, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1069, 3, 156, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1070, 3, 157, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1071, 3, 158, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1072, 3, 159, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1073, 3, 160, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1074, 3, 161, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1075, 3, 162, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1076, 3, 163, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1077, 3, 164, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1078, 3, 165, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1079, 3, 166, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1080, 3, 167, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1081, 3, 168, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1082, 3, 169, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1083, 3, 170, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1084, 3, 171, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1085, 3, 172, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1086, 3, 173, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1087, 3, 174, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1088, 3, 175, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1089, 3, 176, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1090, 3, 177, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1091, 3, 178, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1092, 3, 179, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1093, 3, 180, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1094, 3, 181, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1095, 3, 182, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1096, 3, 183, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1097, 3, 184, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1098, 3, 185, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1099, 3, 186, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1100, 3, 187, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1101, 3, 188, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1102, 3, 189, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1103, 3, 190, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1104, 3, 191, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1105, 3, 192, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1106, 3, 193, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1107, 3, 194, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1108, 3, 195, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1109, 3, 196, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1110, 3, 197, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1111, 3, 198, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1112, 3, 199, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1113, 3, 200, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1114, 3, 201, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1115, 3, 202, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1116, 3, 203, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1117, 3, 204, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1118, 3, 205, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1119, 3, 206, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1120, 3, 207, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1121, 3, 208, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1122, 3, 209, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1123, 3, 210, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1124, 3, 211, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1125, 3, 212, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1126, 3, 213, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1127, 3, 214, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1128, 3, 215, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1129, 3, 216, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1130, 3, 217, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1131, 3, 218, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1132, 3, 219, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1133, 3, 220, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1134, 3, 221, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1135, 3, 222, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1136, 3, 223, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1137, 3, 224, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1138, 3, 225, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1139, 3, 226, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1140, 3, 227, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1141, 3, 228, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1142, 3, 229, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1143, 3, 230, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1144, 3, 231, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1145, 3, 232, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1146, 3, 233, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1147, 3, 234, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1148, 3, 235, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1149, 3, 236, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1150, 3, 237, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1151, 3, 238, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1152, 3, 239, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1153, 3, 240, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1154, 3, 241, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1155, 3, 242, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1156, 3, 243, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1157, 3, 244, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1158, 3, 245, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1159, 3, 246, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1160, 3, 247, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1161, 3, 248, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1162, 3, 249, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1163, 3, 250, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1164, 3, 251, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1165, 3, 252, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1166, 3, 253, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1167, 3, 254, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1168, 3, 255, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1169, 3, 256, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1170, 3, 257, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1171, 3, 258, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1172, 3, 259, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1173, 3, 260, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1174, 3, 261, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1175, 3, 262, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1176, 3, 263, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1177, 3, 264, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1178, 3, 265, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1179, 3, 266, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1180, 3, 267, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1181, 3, 268, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1182, 3, 269, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1183, 3, 270, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1184, 3, 271, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1185, 3, 272, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1186, 3, 273, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1187, 3, 274, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1188, 3, 275, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1189, 3, 276, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1190, 3, 277, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1191, 3, 278, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1192, 3, 279, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1193, 3, 280, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1194, 3, 281, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1195, 3, 282, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1196, 3, 283, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1197, 3, 284, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1198, 3, 285, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1199, 3, 286, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1200, 3, 287, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1201, 3, 288, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1202, 3, 289, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1203, 3, 290, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1204, 3, 291, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1205, 3, 292, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1206, 3, 293, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1207, 3, 294, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1208, 3, 295, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1209, 3, 296, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1210, 3, 297, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1211, 3, 298, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1212, 3, 299, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1213, 3, 300, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1214, 3, 301, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1215, 3, 302, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1216, 3, 303, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1217, 3, 304, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1218, 3, 305, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1219, 3, 306, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1220, 3, 307, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1221, 3, 308, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1222, 3, 309, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1223, 3, 310, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1224, 3, 311, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1225, 3, 312, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1226, 3, 313, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1227, 3, 314, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1228, 3, 315, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1229, 3, 316, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1230, 3, 317, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1231, 3, 318, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1232, 3, 319, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1233, 3, 320, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1234, 3, 321, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1235, 3, 322, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1236, 3, 323, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1237, 3, 351, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1238, 3, 360, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1239, 3, 361, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1240, 3, 363, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1241, 3, 369, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1242, 3, 432, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1243, 3, 373, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1244, 3, 375, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1245, 3, 430, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1246, 3, 377, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1247, 3, 386, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1248, 3, 406, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1249, 3, 408, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1250, 3, 409, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1251, 3, 410, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1252, 3, 411, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1253, 3, 412, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1254, 3, 413, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1255, 3, 414, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1256, 3, 415, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1257, 3, 416, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1258, 3, 417, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1259, 3, 418, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1260, 3, 419, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1261, 3, 420, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1262, 3, 421, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1263, 3, 422, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1264, 3, 424, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1265, 3, 425, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1266, 3, 426, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1267, 3, 427, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1268, 3, 428, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1269, 3, 378, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1270, 3, 379, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1271, 3, 380, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1272, 3, 381, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1273, 3, 382, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1274, 3, 383, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1275, 3, 384, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1276, 3, 385, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1277, 3, 387, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1278, 3, 388, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1279, 3, 389, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1280, 3, 390, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1281, 3, 391, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1282, 3, 392, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1283, 3, 393, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1284, 3, 394, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1285, 3, 395, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1286, 3, 396, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1287, 3, 397, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1288, 3, 398, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1289, 3, 399, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1290, 3, 400, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1291, 3, 401, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1292, 3, 402, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1293, 3, 403, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1294, 3, 404, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1295, 3, 405, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1296, 3, 407, 0.00, '2026-06-14 15:05:58');
INSERT INTO `stock_almacen` VALUES (1380, 4, 433, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1381, 4, 7, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1382, 4, 8, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1383, 4, 9, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1384, 4, 46, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1385, 4, 47, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1386, 4, 10, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1387, 4, 11, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1388, 4, 12, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1389, 4, 13, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1390, 4, 14, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1391, 4, 15, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1392, 4, 16, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1393, 4, 17, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1394, 4, 18, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1395, 4, 19, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1396, 4, 20, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1397, 4, 21, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1398, 4, 22, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1399, 4, 23, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1400, 4, 24, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1401, 4, 25, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1402, 4, 26, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1403, 4, 27, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1404, 4, 28, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1405, 4, 29, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1406, 4, 30, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1407, 4, 31, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1408, 4, 32, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1409, 4, 33, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1410, 4, 34, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1411, 4, 35, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1412, 4, 36, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1413, 4, 37, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1414, 4, 38, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1415, 4, 39, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1416, 4, 40, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1417, 4, 41, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1418, 4, 42, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1419, 4, 43, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1420, 4, 44, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1421, 4, 45, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1422, 4, 48, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1423, 4, 49, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1424, 4, 50, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1425, 4, 374, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1426, 4, 51, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1427, 4, 52, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1428, 4, 53, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1429, 4, 54, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1430, 4, 56, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1431, 4, 55, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1432, 4, 57, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1433, 4, 66, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1434, 4, 58, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1435, 4, 359, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1436, 4, 362, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1437, 4, 364, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1438, 4, 365, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1439, 4, 368, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1440, 4, 431, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1441, 4, 59, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1442, 4, 60, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1443, 4, 62, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1444, 4, 357, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1445, 4, 358, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1446, 4, 366, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1447, 4, 367, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1448, 4, 376, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1449, 4, 423, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1450, 4, 61, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1451, 4, 64, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1452, 4, 370, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1453, 4, 371, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1454, 4, 434, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1455, 4, 63, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1456, 4, 65, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1457, 4, 372, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1458, 4, 67, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1459, 4, 68, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1460, 4, 69, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1461, 4, 70, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1462, 4, 71, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1463, 4, 72, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1464, 4, 73, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1465, 4, 74, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1466, 4, 75, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1467, 4, 76, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1468, 4, 77, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1469, 4, 78, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1470, 4, 79, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1471, 4, 80, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1472, 4, 81, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1473, 4, 82, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1474, 4, 83, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1475, 4, 84, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1476, 4, 85, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1477, 4, 86, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1478, 4, 87, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1479, 4, 88, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1480, 4, 89, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1481, 4, 90, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1482, 4, 91, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1483, 4, 92, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1484, 4, 93, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1485, 4, 324, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1486, 4, 325, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1487, 4, 326, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1488, 4, 327, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1489, 4, 328, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1490, 4, 329, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1491, 4, 330, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1492, 4, 331, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1493, 4, 332, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1494, 4, 333, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1495, 4, 334, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1496, 4, 335, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1497, 4, 336, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1498, 4, 337, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1499, 4, 338, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1500, 4, 339, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1501, 4, 340, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1502, 4, 341, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1503, 4, 342, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1504, 4, 343, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1505, 4, 344, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1506, 4, 345, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1507, 4, 346, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1508, 4, 347, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1509, 4, 348, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1510, 4, 349, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1511, 4, 350, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1512, 4, 352, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1513, 4, 353, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1514, 4, 354, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1515, 4, 355, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1516, 4, 356, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1517, 4, 429, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1518, 4, 94, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1519, 4, 95, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1520, 4, 96, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1521, 4, 97, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1522, 4, 98, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1523, 4, 99, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1524, 4, 100, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1525, 4, 101, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1526, 4, 102, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1527, 4, 103, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1528, 4, 104, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1529, 4, 105, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1530, 4, 106, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1531, 4, 107, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1532, 4, 108, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1533, 4, 109, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1534, 4, 110, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1535, 4, 111, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1536, 4, 112, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1537, 4, 113, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1538, 4, 114, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1539, 4, 115, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1540, 4, 116, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1541, 4, 117, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1542, 4, 118, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1543, 4, 119, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1544, 4, 120, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1545, 4, 121, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1546, 4, 122, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1547, 4, 123, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1548, 4, 124, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1549, 4, 125, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1550, 4, 126, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1551, 4, 127, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1552, 4, 128, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1553, 4, 129, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1554, 4, 130, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1555, 4, 131, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1556, 4, 132, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1557, 4, 133, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1558, 4, 134, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1559, 4, 135, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1560, 4, 136, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1561, 4, 137, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1562, 4, 138, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1563, 4, 139, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1564, 4, 140, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1565, 4, 141, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1566, 4, 142, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1567, 4, 143, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1568, 4, 144, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1569, 4, 145, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1570, 4, 146, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1571, 4, 147, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1572, 4, 148, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1573, 4, 149, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1574, 4, 150, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1575, 4, 151, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1576, 4, 152, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1577, 4, 153, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1578, 4, 154, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1579, 4, 155, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1580, 4, 156, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1581, 4, 157, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1582, 4, 158, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1583, 4, 159, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1584, 4, 160, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1585, 4, 161, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1586, 4, 162, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1587, 4, 163, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1588, 4, 164, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1589, 4, 165, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1590, 4, 166, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1591, 4, 167, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1592, 4, 168, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1593, 4, 169, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1594, 4, 170, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1595, 4, 171, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1596, 4, 172, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1597, 4, 173, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1598, 4, 174, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1599, 4, 175, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1600, 4, 176, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1601, 4, 177, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1602, 4, 178, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1603, 4, 179, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1604, 4, 180, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1605, 4, 181, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1606, 4, 182, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1607, 4, 183, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1608, 4, 184, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1609, 4, 185, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1610, 4, 186, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1611, 4, 187, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1612, 4, 188, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1613, 4, 189, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1614, 4, 190, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1615, 4, 191, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1616, 4, 192, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1617, 4, 193, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1618, 4, 194, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1619, 4, 195, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1620, 4, 196, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1621, 4, 197, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1622, 4, 198, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1623, 4, 199, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1624, 4, 200, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1625, 4, 201, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1626, 4, 202, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1627, 4, 203, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1628, 4, 204, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1629, 4, 205, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1630, 4, 206, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1631, 4, 207, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1632, 4, 208, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1633, 4, 209, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1634, 4, 210, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1635, 4, 211, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1636, 4, 212, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1637, 4, 213, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1638, 4, 214, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1639, 4, 215, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1640, 4, 216, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1641, 4, 217, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1642, 4, 218, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1643, 4, 219, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1644, 4, 220, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1645, 4, 221, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1646, 4, 222, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1647, 4, 223, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1648, 4, 224, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1649, 4, 225, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1650, 4, 226, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1651, 4, 227, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1652, 4, 228, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1653, 4, 229, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1654, 4, 230, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1655, 4, 231, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1656, 4, 232, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1657, 4, 233, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1658, 4, 234, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1659, 4, 235, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1660, 4, 236, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1661, 4, 237, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1662, 4, 238, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1663, 4, 239, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1664, 4, 240, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1665, 4, 241, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1666, 4, 242, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1667, 4, 243, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1668, 4, 244, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1669, 4, 245, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1670, 4, 246, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1671, 4, 247, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1672, 4, 248, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1673, 4, 249, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1674, 4, 250, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1675, 4, 251, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1676, 4, 252, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1677, 4, 253, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1678, 4, 254, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1679, 4, 255, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1680, 4, 256, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1681, 4, 257, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1682, 4, 258, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1683, 4, 259, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1684, 4, 260, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1685, 4, 261, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1686, 4, 262, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1687, 4, 263, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1688, 4, 264, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1689, 4, 265, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1690, 4, 266, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1691, 4, 267, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1692, 4, 268, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1693, 4, 269, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1694, 4, 270, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1695, 4, 271, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1696, 4, 272, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1697, 4, 273, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1698, 4, 274, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1699, 4, 275, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1700, 4, 276, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1701, 4, 277, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1702, 4, 278, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1703, 4, 279, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1704, 4, 280, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1705, 4, 281, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1706, 4, 282, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1707, 4, 283, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1708, 4, 284, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1709, 4, 285, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1710, 4, 286, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1711, 4, 287, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1712, 4, 288, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1713, 4, 289, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1714, 4, 290, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1715, 4, 291, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1716, 4, 292, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1717, 4, 293, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1718, 4, 294, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1719, 4, 295, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1720, 4, 296, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1721, 4, 297, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1722, 4, 298, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1723, 4, 299, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1724, 4, 300, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1725, 4, 301, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1726, 4, 302, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1727, 4, 303, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1728, 4, 304, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1729, 4, 305, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1730, 4, 306, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1731, 4, 307, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1732, 4, 308, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1733, 4, 309, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1734, 4, 310, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1735, 4, 311, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1736, 4, 312, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1737, 4, 313, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1738, 4, 314, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1739, 4, 315, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1740, 4, 316, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1741, 4, 317, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1742, 4, 318, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1743, 4, 319, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1744, 4, 320, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1745, 4, 321, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1746, 4, 322, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1747, 4, 323, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1748, 4, 351, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1749, 4, 360, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1750, 4, 361, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1751, 4, 363, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1752, 4, 369, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1753, 4, 432, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1754, 4, 373, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1755, 4, 375, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1756, 4, 430, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1757, 4, 377, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1758, 4, 386, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1759, 4, 406, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1760, 4, 408, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1761, 4, 409, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1762, 4, 410, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1763, 4, 411, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1764, 4, 412, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1765, 4, 413, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1766, 4, 414, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1767, 4, 415, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1768, 4, 416, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1769, 4, 417, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1770, 4, 418, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1771, 4, 419, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1772, 4, 420, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1773, 4, 421, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1774, 4, 422, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1775, 4, 424, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1776, 4, 425, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1777, 4, 426, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1778, 4, 427, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1779, 4, 428, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1780, 4, 378, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1781, 4, 379, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1782, 4, 380, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1783, 4, 381, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1784, 4, 382, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1785, 4, 383, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1786, 4, 384, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1787, 4, 385, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1788, 4, 387, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1789, 4, 388, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1790, 4, 389, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1791, 4, 390, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1792, 4, 391, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1793, 4, 392, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1794, 4, 393, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1795, 4, 394, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1796, 4, 395, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1797, 4, 396, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1798, 4, 397, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1799, 4, 398, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1800, 4, 399, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1801, 4, 400, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1802, 4, 401, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1803, 4, 402, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1804, 4, 403, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1805, 4, 404, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1806, 4, 405, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1807, 4, 407, 0.00, '2026-06-14 15:06:29');
INSERT INTO `stock_almacen` VALUES (1891, 5, 433, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1892, 5, 7, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1893, 5, 8, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1894, 5, 9, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1895, 5, 46, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1896, 5, 47, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1897, 5, 10, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1898, 5, 11, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1899, 5, 12, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1900, 5, 13, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1901, 5, 14, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1902, 5, 15, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1903, 5, 16, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1904, 5, 17, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1905, 5, 18, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1906, 5, 19, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1907, 5, 20, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1908, 5, 21, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1909, 5, 22, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1910, 5, 23, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1911, 5, 24, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1912, 5, 25, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1913, 5, 26, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1914, 5, 27, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1915, 5, 28, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1916, 5, 29, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1917, 5, 30, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1918, 5, 31, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1919, 5, 32, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1920, 5, 33, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1921, 5, 34, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1922, 5, 35, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1923, 5, 36, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1924, 5, 37, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1925, 5, 38, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1926, 5, 39, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1927, 5, 40, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1928, 5, 41, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1929, 5, 42, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1930, 5, 43, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1931, 5, 44, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1932, 5, 45, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1933, 5, 48, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1934, 5, 49, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1935, 5, 50, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1936, 5, 374, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1937, 5, 51, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1938, 5, 52, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1939, 5, 53, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1940, 5, 54, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1941, 5, 56, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1942, 5, 55, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1943, 5, 57, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1944, 5, 66, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1945, 5, 58, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1946, 5, 359, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1947, 5, 362, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1948, 5, 364, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1949, 5, 365, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1950, 5, 368, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1951, 5, 431, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1952, 5, 59, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1953, 5, 60, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1954, 5, 62, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1955, 5, 357, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1956, 5, 358, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1957, 5, 366, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1958, 5, 367, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1959, 5, 376, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1960, 5, 423, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1961, 5, 61, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1962, 5, 64, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1963, 5, 370, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1964, 5, 371, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1965, 5, 434, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1966, 5, 63, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1967, 5, 65, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1968, 5, 372, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1969, 5, 67, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1970, 5, 68, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1971, 5, 69, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1972, 5, 70, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1973, 5, 71, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1974, 5, 72, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1975, 5, 73, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1976, 5, 74, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1977, 5, 75, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1978, 5, 76, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1979, 5, 77, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1980, 5, 78, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1981, 5, 79, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1982, 5, 80, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1983, 5, 81, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1984, 5, 82, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1985, 5, 83, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1986, 5, 84, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1987, 5, 85, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1988, 5, 86, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1989, 5, 87, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1990, 5, 88, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1991, 5, 89, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1992, 5, 90, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1993, 5, 91, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1994, 5, 92, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1995, 5, 93, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1996, 5, 324, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1997, 5, 325, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1998, 5, 326, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (1999, 5, 327, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2000, 5, 328, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2001, 5, 329, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2002, 5, 330, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2003, 5, 331, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2004, 5, 332, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2005, 5, 333, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2006, 5, 334, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2007, 5, 335, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2008, 5, 336, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2009, 5, 337, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2010, 5, 338, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2011, 5, 339, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2012, 5, 340, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2013, 5, 341, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2014, 5, 342, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2015, 5, 343, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2016, 5, 344, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2017, 5, 345, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2018, 5, 346, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2019, 5, 347, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2020, 5, 348, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2021, 5, 349, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2022, 5, 350, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2023, 5, 352, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2024, 5, 353, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2025, 5, 354, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2026, 5, 355, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2027, 5, 356, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2028, 5, 429, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2029, 5, 94, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2030, 5, 95, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2031, 5, 96, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2032, 5, 97, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2033, 5, 98, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2034, 5, 99, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2035, 5, 100, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2036, 5, 101, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2037, 5, 102, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2038, 5, 103, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2039, 5, 104, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2040, 5, 105, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2041, 5, 106, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2042, 5, 107, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2043, 5, 108, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2044, 5, 109, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2045, 5, 110, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2046, 5, 111, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2047, 5, 112, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2048, 5, 113, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2049, 5, 114, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2050, 5, 115, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2051, 5, 116, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2052, 5, 117, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2053, 5, 118, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2054, 5, 119, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2055, 5, 120, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2056, 5, 121, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2057, 5, 122, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2058, 5, 123, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2059, 5, 124, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2060, 5, 125, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2061, 5, 126, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2062, 5, 127, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2063, 5, 128, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2064, 5, 129, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2065, 5, 130, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2066, 5, 131, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2067, 5, 132, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2068, 5, 133, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2069, 5, 134, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2070, 5, 135, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2071, 5, 136, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2072, 5, 137, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2073, 5, 138, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2074, 5, 139, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2075, 5, 140, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2076, 5, 141, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2077, 5, 142, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2078, 5, 143, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2079, 5, 144, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2080, 5, 145, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2081, 5, 146, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2082, 5, 147, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2083, 5, 148, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2084, 5, 149, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2085, 5, 150, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2086, 5, 151, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2087, 5, 152, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2088, 5, 153, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2089, 5, 154, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2090, 5, 155, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2091, 5, 156, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2092, 5, 157, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2093, 5, 158, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2094, 5, 159, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2095, 5, 160, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2096, 5, 161, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2097, 5, 162, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2098, 5, 163, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2099, 5, 164, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2100, 5, 165, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2101, 5, 166, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2102, 5, 167, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2103, 5, 168, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2104, 5, 169, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2105, 5, 170, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2106, 5, 171, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2107, 5, 172, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2108, 5, 173, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2109, 5, 174, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2110, 5, 175, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2111, 5, 176, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2112, 5, 177, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2113, 5, 178, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2114, 5, 179, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2115, 5, 180, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2116, 5, 181, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2117, 5, 182, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2118, 5, 183, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2119, 5, 184, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2120, 5, 185, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2121, 5, 186, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2122, 5, 187, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2123, 5, 188, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2124, 5, 189, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2125, 5, 190, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2126, 5, 191, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2127, 5, 192, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2128, 5, 193, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2129, 5, 194, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2130, 5, 195, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2131, 5, 196, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2132, 5, 197, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2133, 5, 198, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2134, 5, 199, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2135, 5, 200, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2136, 5, 201, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2137, 5, 202, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2138, 5, 203, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2139, 5, 204, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2140, 5, 205, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2141, 5, 206, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2142, 5, 207, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2143, 5, 208, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2144, 5, 209, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2145, 5, 210, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2146, 5, 211, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2147, 5, 212, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2148, 5, 213, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2149, 5, 214, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2150, 5, 215, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2151, 5, 216, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2152, 5, 217, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2153, 5, 218, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2154, 5, 219, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2155, 5, 220, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2156, 5, 221, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2157, 5, 222, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2158, 5, 223, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2159, 5, 224, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2160, 5, 225, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2161, 5, 226, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2162, 5, 227, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2163, 5, 228, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2164, 5, 229, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2165, 5, 230, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2166, 5, 231, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2167, 5, 232, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2168, 5, 233, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2169, 5, 234, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2170, 5, 235, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2171, 5, 236, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2172, 5, 237, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2173, 5, 238, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2174, 5, 239, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2175, 5, 240, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2176, 5, 241, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2177, 5, 242, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2178, 5, 243, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2179, 5, 244, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2180, 5, 245, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2181, 5, 246, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2182, 5, 247, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2183, 5, 248, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2184, 5, 249, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2185, 5, 250, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2186, 5, 251, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2187, 5, 252, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2188, 5, 253, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2189, 5, 254, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2190, 5, 255, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2191, 5, 256, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2192, 5, 257, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2193, 5, 258, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2194, 5, 259, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2195, 5, 260, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2196, 5, 261, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2197, 5, 262, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2198, 5, 263, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2199, 5, 264, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2200, 5, 265, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2201, 5, 266, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2202, 5, 267, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2203, 5, 268, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2204, 5, 269, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2205, 5, 270, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2206, 5, 271, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2207, 5, 272, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2208, 5, 273, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2209, 5, 274, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2210, 5, 275, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2211, 5, 276, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2212, 5, 277, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2213, 5, 278, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2214, 5, 279, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2215, 5, 280, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2216, 5, 281, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2217, 5, 282, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2218, 5, 283, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2219, 5, 284, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2220, 5, 285, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2221, 5, 286, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2222, 5, 287, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2223, 5, 288, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2224, 5, 289, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2225, 5, 290, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2226, 5, 291, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2227, 5, 292, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2228, 5, 293, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2229, 5, 294, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2230, 5, 295, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2231, 5, 296, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2232, 5, 297, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2233, 5, 298, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2234, 5, 299, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2235, 5, 300, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2236, 5, 301, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2237, 5, 302, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2238, 5, 303, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2239, 5, 304, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2240, 5, 305, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2241, 5, 306, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2242, 5, 307, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2243, 5, 308, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2244, 5, 309, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2245, 5, 310, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2246, 5, 311, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2247, 5, 312, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2248, 5, 313, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2249, 5, 314, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2250, 5, 315, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2251, 5, 316, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2252, 5, 317, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2253, 5, 318, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2254, 5, 319, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2255, 5, 320, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2256, 5, 321, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2257, 5, 322, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2258, 5, 323, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2259, 5, 351, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2260, 5, 360, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2261, 5, 361, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2262, 5, 363, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2263, 5, 369, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2264, 5, 432, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2265, 5, 373, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2266, 5, 375, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2267, 5, 430, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2268, 5, 377, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2269, 5, 386, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2270, 5, 406, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2271, 5, 408, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2272, 5, 409, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2273, 5, 410, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2274, 5, 411, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2275, 5, 412, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2276, 5, 413, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2277, 5, 414, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2278, 5, 415, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2279, 5, 416, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2280, 5, 417, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2281, 5, 418, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2282, 5, 419, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2283, 5, 420, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2284, 5, 421, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2285, 5, 422, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2286, 5, 424, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2287, 5, 425, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2288, 5, 426, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2289, 5, 427, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2290, 5, 428, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2291, 5, 378, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2292, 5, 379, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2293, 5, 380, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2294, 5, 381, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2295, 5, 382, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2296, 5, 383, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2297, 5, 384, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2298, 5, 385, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2299, 5, 387, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2300, 5, 388, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2301, 5, 389, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2302, 5, 390, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2303, 5, 391, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2304, 5, 392, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2305, 5, 393, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2306, 5, 394, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2307, 5, 395, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2308, 5, 396, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2309, 5, 397, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2310, 5, 398, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2311, 5, 399, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2312, 5, 400, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2313, 5, 401, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2314, 5, 402, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2315, 5, 403, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2316, 5, 404, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2317, 5, 405, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2318, 5, 407, 0.00, '2026-06-14 15:06:48');
INSERT INTO `stock_almacen` VALUES (2402, 7, 433, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2403, 7, 7, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2404, 7, 8, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2405, 7, 9, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2406, 7, 46, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2407, 7, 47, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2408, 7, 10, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2409, 7, 11, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2410, 7, 12, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2411, 7, 13, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2412, 7, 14, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2413, 7, 15, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2414, 7, 16, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2415, 7, 17, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2416, 7, 18, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2417, 7, 19, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2418, 7, 20, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2419, 7, 21, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2420, 7, 22, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2421, 7, 23, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2422, 7, 24, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2423, 7, 25, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2424, 7, 26, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2425, 7, 27, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2426, 7, 28, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2427, 7, 29, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2428, 7, 30, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2429, 7, 31, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2430, 7, 32, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2431, 7, 33, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2432, 7, 34, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2433, 7, 35, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2434, 7, 36, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2435, 7, 37, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2436, 7, 38, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2437, 7, 39, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2438, 7, 40, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2439, 7, 41, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2440, 7, 42, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2441, 7, 43, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2442, 7, 44, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2443, 7, 45, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2444, 7, 48, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2445, 7, 49, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2446, 7, 50, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2447, 7, 374, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2448, 7, 51, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2449, 7, 52, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2450, 7, 53, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2451, 7, 54, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2452, 7, 56, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2453, 7, 55, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2454, 7, 57, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2455, 7, 66, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2456, 7, 58, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2457, 7, 359, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2458, 7, 362, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2459, 7, 364, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2460, 7, 365, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2461, 7, 368, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2462, 7, 431, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2463, 7, 59, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2464, 7, 60, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2465, 7, 62, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2466, 7, 357, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2467, 7, 358, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2468, 7, 366, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2469, 7, 367, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2470, 7, 376, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2471, 7, 423, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2472, 7, 61, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2473, 7, 64, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2474, 7, 370, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2475, 7, 371, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2476, 7, 434, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2477, 7, 63, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2478, 7, 65, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2479, 7, 372, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2480, 7, 67, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2481, 7, 68, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2482, 7, 69, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2483, 7, 70, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2484, 7, 71, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2485, 7, 72, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2486, 7, 73, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2487, 7, 74, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2488, 7, 75, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2489, 7, 76, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2490, 7, 77, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2491, 7, 78, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2492, 7, 79, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2493, 7, 80, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2494, 7, 81, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2495, 7, 82, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2496, 7, 83, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2497, 7, 84, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2498, 7, 85, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2499, 7, 86, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2500, 7, 87, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2501, 7, 88, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2502, 7, 89, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2503, 7, 90, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2504, 7, 91, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2505, 7, 92, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2506, 7, 93, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2507, 7, 324, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2508, 7, 325, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2509, 7, 326, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2510, 7, 327, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2511, 7, 328, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2512, 7, 329, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2513, 7, 330, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2514, 7, 331, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2515, 7, 332, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2516, 7, 333, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2517, 7, 334, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2518, 7, 335, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2519, 7, 336, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2520, 7, 337, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2521, 7, 338, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2522, 7, 339, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2523, 7, 340, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2524, 7, 341, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2525, 7, 342, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2526, 7, 343, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2527, 7, 344, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2528, 7, 345, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2529, 7, 346, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2530, 7, 347, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2531, 7, 348, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2532, 7, 349, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2533, 7, 350, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2534, 7, 352, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2535, 7, 353, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2536, 7, 354, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2537, 7, 355, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2538, 7, 356, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2539, 7, 429, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2540, 7, 94, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2541, 7, 95, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2542, 7, 96, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2543, 7, 97, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2544, 7, 98, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2545, 7, 99, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2546, 7, 100, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2547, 7, 101, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2548, 7, 102, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2549, 7, 103, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2550, 7, 104, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2551, 7, 105, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2552, 7, 106, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2553, 7, 107, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2554, 7, 108, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2555, 7, 109, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2556, 7, 110, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2557, 7, 111, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2558, 7, 112, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2559, 7, 113, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2560, 7, 114, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2561, 7, 115, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2562, 7, 116, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2563, 7, 117, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2564, 7, 118, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2565, 7, 119, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2566, 7, 120, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2567, 7, 121, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2568, 7, 122, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2569, 7, 123, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2570, 7, 124, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2571, 7, 125, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2572, 7, 126, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2573, 7, 127, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2574, 7, 128, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2575, 7, 129, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2576, 7, 130, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2577, 7, 131, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2578, 7, 132, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2579, 7, 133, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2580, 7, 134, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2581, 7, 135, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2582, 7, 136, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2583, 7, 137, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2584, 7, 138, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2585, 7, 139, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2586, 7, 140, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2587, 7, 141, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2588, 7, 142, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2589, 7, 143, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2590, 7, 144, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2591, 7, 145, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2592, 7, 146, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2593, 7, 147, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2594, 7, 148, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2595, 7, 149, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2596, 7, 150, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2597, 7, 151, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2598, 7, 152, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2599, 7, 153, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2600, 7, 154, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2601, 7, 155, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2602, 7, 156, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2603, 7, 157, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2604, 7, 158, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2605, 7, 159, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2606, 7, 160, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2607, 7, 161, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2608, 7, 162, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2609, 7, 163, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2610, 7, 164, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2611, 7, 165, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2612, 7, 166, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2613, 7, 167, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2614, 7, 168, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2615, 7, 169, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2616, 7, 170, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2617, 7, 171, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2618, 7, 172, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2619, 7, 173, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2620, 7, 174, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2621, 7, 175, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2622, 7, 176, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2623, 7, 177, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2624, 7, 178, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2625, 7, 179, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2626, 7, 180, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2627, 7, 181, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2628, 7, 182, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2629, 7, 183, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2630, 7, 184, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2631, 7, 185, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2632, 7, 186, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2633, 7, 187, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2634, 7, 188, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2635, 7, 189, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2636, 7, 190, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2637, 7, 191, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2638, 7, 192, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2639, 7, 193, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2640, 7, 194, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2641, 7, 195, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2642, 7, 196, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2643, 7, 197, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2644, 7, 198, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2645, 7, 199, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2646, 7, 200, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2647, 7, 201, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2648, 7, 202, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2649, 7, 203, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2650, 7, 204, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2651, 7, 205, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2652, 7, 206, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2653, 7, 207, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2654, 7, 208, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2655, 7, 209, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2656, 7, 210, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2657, 7, 211, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2658, 7, 212, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2659, 7, 213, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2660, 7, 214, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2661, 7, 215, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2662, 7, 216, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2663, 7, 217, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2664, 7, 218, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2665, 7, 219, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2666, 7, 220, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2667, 7, 221, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2668, 7, 222, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2669, 7, 223, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2670, 7, 224, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2671, 7, 225, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2672, 7, 226, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2673, 7, 227, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2674, 7, 228, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2675, 7, 229, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2676, 7, 230, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2677, 7, 231, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2678, 7, 232, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2679, 7, 233, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2680, 7, 234, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2681, 7, 235, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2682, 7, 236, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2683, 7, 237, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2684, 7, 238, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2685, 7, 239, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2686, 7, 240, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2687, 7, 241, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2688, 7, 242, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2689, 7, 243, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2690, 7, 244, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2691, 7, 245, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2692, 7, 246, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2693, 7, 247, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2694, 7, 248, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2695, 7, 249, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2696, 7, 250, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2697, 7, 251, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2698, 7, 252, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2699, 7, 253, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2700, 7, 254, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2701, 7, 255, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2702, 7, 256, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2703, 7, 257, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2704, 7, 258, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2705, 7, 259, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2706, 7, 260, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2707, 7, 261, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2708, 7, 262, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2709, 7, 263, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2710, 7, 264, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2711, 7, 265, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2712, 7, 266, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2713, 7, 267, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2714, 7, 268, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2715, 7, 269, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2716, 7, 270, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2717, 7, 271, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2718, 7, 272, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2719, 7, 273, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2720, 7, 274, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2721, 7, 275, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2722, 7, 276, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2723, 7, 277, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2724, 7, 278, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2725, 7, 279, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2726, 7, 280, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2727, 7, 281, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2728, 7, 282, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2729, 7, 283, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2730, 7, 284, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2731, 7, 285, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2732, 7, 286, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2733, 7, 287, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2734, 7, 288, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2735, 7, 289, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2736, 7, 290, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2737, 7, 291, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2738, 7, 292, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2739, 7, 293, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2740, 7, 294, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2741, 7, 295, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2742, 7, 296, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2743, 7, 297, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2744, 7, 298, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2745, 7, 299, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2746, 7, 300, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2747, 7, 301, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2748, 7, 302, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2749, 7, 303, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2750, 7, 304, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2751, 7, 305, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2752, 7, 306, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2753, 7, 307, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2754, 7, 308, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2755, 7, 309, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2756, 7, 310, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2757, 7, 311, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2758, 7, 312, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2759, 7, 313, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2760, 7, 314, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2761, 7, 315, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2762, 7, 316, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2763, 7, 317, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2764, 7, 318, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2765, 7, 319, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2766, 7, 320, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2767, 7, 321, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2768, 7, 322, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2769, 7, 323, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2770, 7, 351, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2771, 7, 360, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2772, 7, 361, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2773, 7, 363, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2774, 7, 369, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2775, 7, 432, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2776, 7, 373, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2777, 7, 375, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2778, 7, 430, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2779, 7, 377, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2780, 7, 386, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2781, 7, 406, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2782, 7, 408, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2783, 7, 409, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2784, 7, 410, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2785, 7, 411, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2786, 7, 412, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2787, 7, 413, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2788, 7, 414, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2789, 7, 415, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2790, 7, 416, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2791, 7, 417, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2792, 7, 418, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2793, 7, 419, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2794, 7, 420, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2795, 7, 421, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2796, 7, 422, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2797, 7, 424, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2798, 7, 425, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2799, 7, 426, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2800, 7, 427, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2801, 7, 428, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2802, 7, 378, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2803, 7, 379, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2804, 7, 380, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2805, 7, 381, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2806, 7, 382, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2807, 7, 383, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2808, 7, 384, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2809, 7, 385, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2810, 7, 387, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2811, 7, 388, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2812, 7, 389, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2813, 7, 390, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2814, 7, 391, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2815, 7, 392, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2816, 7, 393, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2817, 7, 394, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2818, 7, 395, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2819, 7, 396, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2820, 7, 397, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2821, 7, 398, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2822, 7, 399, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2823, 7, 400, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2824, 7, 401, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2825, 7, 402, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2826, 7, 403, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2827, 7, 404, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2828, 7, 405, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2829, 7, 407, 0.00, '2026-06-14 15:07:55');
INSERT INTO `stock_almacen` VALUES (2913, 1, 435, 99.00, '2026-06-15 11:19:17');
INSERT INTO `stock_almacen` VALUES (2914, 2, 435, 0.00, '2026-06-14 15:27:32');
INSERT INTO `stock_almacen` VALUES (2915, 3, 435, 0.00, '2026-06-14 15:27:32');
INSERT INTO `stock_almacen` VALUES (2916, 4, 435, 0.00, '2026-06-14 15:27:32');
INSERT INTO `stock_almacen` VALUES (2917, 5, 435, 0.00, '2026-06-14 15:27:32');
INSERT INTO `stock_almacen` VALUES (2918, 7, 435, 0.00, '2026-06-14 15:27:32');
INSERT INTO `stock_almacen` VALUES (2919, 1, 437, 100.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2920, 2, 437, 0.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2921, 3, 437, 0.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2922, 4, 437, 0.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2923, 5, 437, 0.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2924, 7, 437, 0.00, '2026-06-14 15:44:32');
INSERT INTO `stock_almacen` VALUES (2925, 1, 438, 100.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2926, 2, 438, 0.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2927, 3, 438, 0.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2928, 4, 438, 0.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2929, 5, 438, 0.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2930, 7, 438, 0.00, '2026-06-14 16:08:03');
INSERT INTO `stock_almacen` VALUES (2931, 1, 439, 100.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2932, 2, 439, 0.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2933, 3, 439, 0.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2934, 4, 439, 0.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2935, 5, 439, 0.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2936, 7, 439, 0.00, '2026-06-14 16:15:19');
INSERT INTO `stock_almacen` VALUES (2937, 1, 440, 100.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2938, 2, 440, 0.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2939, 3, 440, 0.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2940, 4, 440, 0.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2941, 5, 440, 0.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2942, 7, 440, 0.00, '2026-06-14 16:30:59');
INSERT INTO `stock_almacen` VALUES (2943, 1, 441, 100.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2944, 2, 441, 0.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2945, 3, 441, 0.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2946, 4, 441, 0.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2947, 5, 441, 0.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2948, 7, 441, 0.00, '2026-06-14 16:52:25');
INSERT INTO `stock_almacen` VALUES (2949, 1, 442, 100.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2950, 2, 442, 0.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2951, 3, 442, 0.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2952, 4, 442, 0.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2953, 5, 442, 0.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2954, 7, 442, 0.00, '2026-06-14 17:05:16');
INSERT INTO `stock_almacen` VALUES (2955, 1, 443, 100.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2956, 2, 443, 0.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2957, 3, 443, 0.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2958, 4, 443, 0.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2959, 5, 443, 0.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2960, 7, 443, 0.00, '2026-06-14 17:21:11');
INSERT INTO `stock_almacen` VALUES (2961, 1, 444, 100.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2962, 2, 444, 0.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2963, 3, 444, 0.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2964, 4, 444, 0.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2965, 5, 444, 0.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2966, 7, 444, 0.00, '2026-06-14 17:39:25');
INSERT INTO `stock_almacen` VALUES (2967, 1, 445, 100.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2968, 2, 445, 0.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2969, 3, 445, 0.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2970, 4, 445, 0.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2971, 5, 445, 0.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2972, 7, 445, 0.00, '2026-06-14 17:48:29');
INSERT INTO `stock_almacen` VALUES (2973, 1, 446, 95.00, '2026-06-14 20:05:28');
INSERT INTO `stock_almacen` VALUES (2974, 2, 446, 0.00, '2026-06-14 19:19:34');
INSERT INTO `stock_almacen` VALUES (2975, 3, 446, 0.00, '2026-06-14 19:19:34');
INSERT INTO `stock_almacen` VALUES (2976, 4, 446, 0.00, '2026-06-14 19:19:34');
INSERT INTO `stock_almacen` VALUES (2977, 5, 446, 0.00, '2026-06-14 19:19:34');
INSERT INTO `stock_almacen` VALUES (2978, 7, 446, 0.00, '2026-06-14 19:19:34');

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tipos_equipo
-- ----------------------------
INSERT INTO `tipos_equipo` VALUES (1, 'Laptop', 'laptop', 1);
INSERT INTO `tipos_equipo` VALUES (7, 'Smartphone', 'smartphone', 1);
INSERT INTO `tipos_equipo` VALUES (8, 'Impresora', 'printer', 1);
INSERT INTO `tipos_equipo` VALUES (14, 'Ps5 Slim', 'package', 1);
INSERT INTO `tipos_equipo` VALUES (15, 'parlante', 'package', 1);
INSERT INTO `tipos_equipo` VALUES (16, 'aro de luz', 'package', 1);
INSERT INTO `tipos_equipo` VALUES (17, 'placa', 'package', 1);
INSERT INTO `tipos_equipo` VALUES (18, 'ps3 super slim', 'package', 1);
INSERT INTO `tipos_equipo` VALUES (19, 'carcasa', 'package', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuarios
-- ----------------------------
INSERT INTO `usuarios` VALUES (1, 'Administrador', 'Sistema', 'admin@mrtech.com', '$2y$10$pZEk0vSEGqKzCYlzddismeHer0lfzXHj2UWq0N65NBCrtUo4lnmdq', 'admin', NULL, NULL, 1, '2026-06-16 15:05:24', '2026-04-13 08:46:29', '2026-06-16 15:05:24');
INSERT INTO `usuarios` VALUES (4, 'Valentina', 'Teran Orellana', 'caja@mrtech.com', '$2y$10$ofEJjyXEve4A.oFzasF2PO6w.MTrJ0C50A/jdf5HKrexsRGAXTdIu', 'vendedor', '934420779', NULL, 1, '2026-06-16 18:10:45', '2026-06-07 09:30:09', '2026-06-16 18:10:45');
INSERT INTO `usuarios` VALUES (5, 'MIGUEL', 'RODRIGUEZ LUGO', 'tecmiguel@mrtech.com', '$2y$10$956d3/iQsKbqq4e/Kl/bme9kMQU5rIPIr7abvqQOsKnBZZQ1eZX9y', 'tecnico', '934701423', NULL, 1, '2026-06-14 11:19:39', '2026-06-07 17:05:06', '2026-06-14 11:19:39');
INSERT INTO `usuarios` VALUES (6, 'ANDRIWS', 'FLORES RODRIGUEZ', 'tecandriws@mrtech.com', '$2y$10$vijhMOINZ7Zpv27QNa8k3.jat9Y9PvniZLRAnLYB1zxkAtQBCjINi', 'tecnico', '922097542', NULL, 1, '2026-06-14 20:16:34', '2026-06-07 17:07:09', '2026-06-14 20:16:34');
INSERT INTO `usuarios` VALUES (7, 'FRANKLIN', 'MONTIEL PADRON', 'tecfrankin@mrtech.com', '$2y$10$B5q7MzC2iDl7Uz/goJRlH.L0GCivH0/t.WHrB1E9cs3sSKJnsKPTa', 'tecnico', '924413438', NULL, 1, NULL, '2026-06-07 17:09:59', '2026-06-07 17:09:59');
INSERT INTO `usuarios` VALUES (8, 'Manu', 'demo', 'manu@gmail.com', '$2y$10$XST.zhIS5/jn0Y8naFCf9.RCx38IwDt0mNaR/Hp9o4WqqiS41tpXW', 'vendedor', '', NULL, 1, '2026-06-11 07:54:00', '2026-06-11 07:53:41', '2026-06-11 07:54:00');
INSERT INTO `usuarios` VALUES (9, 'JAMESSON', 'SAENZ', 'tecjamesson@mrtech.com', '$2y$10$Ya1DzRUCk0T0hl80xYhf.eFGL86dCND2K1aQZ75E.eYy8sM9DqhLe', 'tecnico', '957357537', NULL, 1, NULL, '2026-06-14 13:22:25', '2026-06-14 13:22:25');

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
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of venta_detalle
-- ----------------------------
INSERT INTO `venta_detalle` VALUES (8, 8, 7, 1.00, 5.00, 0.00, 5.00);
INSERT INTO `venta_detalle` VALUES (9, 9, 7, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (10, 10, 7, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (11, 11, 29, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (12, 11, 368, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (13, 12, 374, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (14, 13, 430, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (15, 14, 430, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (16, 15, 29, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (17, 15, 368, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (18, 18, 430, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (19, 19, 368, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (20, 20, 431, 1.00, 25.00, 0.00, 25.00);
INSERT INTO `venta_detalle` VALUES (21, 21, 432, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (22, 22, 433, 1.00, 100.00, 0.00, 100.00);
INSERT INTO `venta_detalle` VALUES (23, 23, 158, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (24, 24, 368, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (25, 25, 22, 1.00, 20.00, 0.00, 20.00);
INSERT INTO `venta_detalle` VALUES (26, 26, 446, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (27, 27, 246, 1.00, 5.00, 0.00, 5.00);
INSERT INTO `venta_detalle` VALUES (28, 28, 435, 1.00, 10.00, 0.00, 10.00);
INSERT INTO `venta_detalle` VALUES (29, 29, 368, 1.00, 20.00, 0.00, 20.00);

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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of venta_pagos
-- ----------------------------
INSERT INTO `venta_pagos` VALUES (8, 8, 'efectivo', 5.00, NULL, '2026-06-07 10:36:49');
INSERT INTO `venta_pagos` VALUES (9, 9, 'efectivo', 20.00, NULL, '2026-06-07 10:40:29');
INSERT INTO `venta_pagos` VALUES (10, 10, 'efectivo', 10.01, NULL, '2026-06-07 10:42:47');
INSERT INTO `venta_pagos` VALUES (11, 11, 'yape', 40.00, NULL, '2026-06-13 15:37:08');
INSERT INTO `venta_pagos` VALUES (12, 12, 'yape', 10.00, NULL, '2026-06-13 17:11:51');
INSERT INTO `venta_pagos` VALUES (13, 13, 'efectivo', 10.00, NULL, '2026-06-13 18:30:40');
INSERT INTO `venta_pagos` VALUES (14, 14, 'efectivo', 10.00, NULL, '2026-06-13 18:37:16');
INSERT INTO `venta_pagos` VALUES (15, 15, 'yape', 40.00, NULL, '2026-06-13 18:38:00');
INSERT INTO `venta_pagos` VALUES (16, 18, 'yape', 10.00, NULL, '2026-06-13 18:41:10');
INSERT INTO `venta_pagos` VALUES (17, 19, 'efectivo', 20.00, NULL, '2026-06-13 19:22:00');
INSERT INTO `venta_pagos` VALUES (18, 20, 'yape', 25.00, NULL, '2026-06-13 19:24:05');
INSERT INTO `venta_pagos` VALUES (19, 21, 'efectivo', 10.00, NULL, '2026-06-14 10:41:59');
INSERT INTO `venta_pagos` VALUES (20, 22, 'yape', 100.00, NULL, '2026-06-14 11:04:48');
INSERT INTO `venta_pagos` VALUES (21, 23, 'yape', 10.00, NULL, '2026-06-14 12:16:08');
INSERT INTO `venta_pagos` VALUES (22, 24, 'efectivo', 20.00, NULL, '2026-06-14 14:12:50');
INSERT INTO `venta_pagos` VALUES (23, 25, 'yape', 20.00, NULL, '2026-06-14 19:08:58');
INSERT INTO `venta_pagos` VALUES (24, 26, 'yape', 10.00, NULL, '2026-06-14 19:32:00');
INSERT INTO `venta_pagos` VALUES (25, 27, 'yape', 5.00, NULL, '2026-06-14 19:35:45');
INSERT INTO `venta_pagos` VALUES (26, 28, 'efectivo', 10.00, NULL, '2026-06-15 11:19:17');
INSERT INTO `venta_pagos` VALUES (27, 29, 'efectivo', 20.00, NULL, '2026-06-16 12:28:21');

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
  `sunat_estado` enum('pendiente','aceptado','rechazado') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sunat_xml` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `sunat_cdr` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `sunat_hash` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sunat_qr` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `sunat_mensaje` varchar(1000) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `sunat_fecha` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `codigo`(`codigo` ASC) USING BTREE,
  INDEX `cliente_id`(`cliente_id` ASC) USING BTREE,
  INDEX `usuario_id`(`usuario_id` ASC) USING BTREE,
  INDEX `idx_fecha`(`created_at` ASC) USING BTREE,
  INDEX `idx_estado`(`estado` ASC) USING BTREE,
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ventas
-- ----------------------------
INSERT INTO `ventas` VALUES (8, 'VTA-2026-0001', NULL, 4, 4, 'ticket', NULL, NULL, 4.24, 0.76, 0.76, NULL, 5.00, 'efectivo', 5.00, 0.00, 'completada', NULL, '2026-06-07 10:36:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (9, 'VTA-2026-0002', NULL, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 3.05, NULL, 20.00, 'efectivo', 20.00, 0.00, 'completada', NULL, '2026-06-07 10:40:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (10, 'VTA-2026-0003', NULL, 4, 4, 'ticket', NULL, NULL, 8.48, 1.53, 1.52, NULL, 10.01, 'efectivo', 10.01, 0.00, 'completada', NULL, '2026-06-07 10:42:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (11, 'VTA-2026-0004', NULL, 4, 4, 'ticket', NULL, NULL, 33.90, 6.10, 0.00, NULL, 40.00, 'yape', 40.00, 0.00, 'anulada', NULL, '2026-06-13 15:37:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (12, 'VTA-2026-0005', NULL, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'yape', 10.00, 0.00, 'anulada', NULL, '2026-06-13 17:11:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (13, 'VTA-2026-0006', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'efectivo', 10.00, 0.00, 'anulada', NULL, '2026-06-13 18:30:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (14, 'VTA-2026-0007', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'efectivo', 10.00, 0.00, 'completada', NULL, '2026-06-13 18:37:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (15, 'VTA-2026-0008', 598, 4, 4, 'ticket', NULL, NULL, 33.90, 6.10, 0.00, NULL, 40.00, 'yape', 40.00, 0.00, 'completada', NULL, '2026-06-13 18:37:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (18, 'VTA-2026-0009', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'yape', 10.00, 0.00, 'completada', NULL, '2026-06-13 18:41:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (19, 'VTA-2026-0010', 598, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 0.00, NULL, 20.00, 'efectivo', 20.00, 0.00, 'completada', NULL, '2026-06-13 19:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (20, 'VTA-2026-0011', 598, 4, 4, 'ticket', NULL, NULL, 21.19, 3.81, 0.00, NULL, 25.00, 'yape', 25.00, 0.00, 'completada', NULL, '2026-06-13 19:24:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (21, 'VTA-2026-0012', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'efectivo', 10.00, 0.00, 'completada', NULL, '2026-06-14 10:41:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (22, 'VTA-2026-0013', 604, 1, 1, 'factura', 'F001', '1', 84.75, 15.25, 0.00, NULL, 100.00, 'yape', 100.00, 0.00, 'completada', NULL, '2026-06-14 11:04:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (23, 'VTA-2026-0014', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'yape', 10.00, 0.00, 'completada', NULL, '2026-06-14 12:16:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (24, 'VTA-2026-0015', 598, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 0.00, NULL, 20.00, 'efectivo', 20.00, 0.00, 'completada', NULL, '2026-06-14 14:12:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (25, 'VTA-2026-0016', 609, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 0.00, NULL, 20.00, 'yape', 20.00, 0.00, 'completada', NULL, '2026-06-14 19:08:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (26, 'VTA-2026-0017', NULL, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'yape', 10.00, 0.00, 'completada', NULL, '2026-06-14 19:32:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (27, 'VTA-2026-0018', 598, 4, 4, 'ticket', NULL, NULL, 4.24, 0.76, 0.00, NULL, 5.00, 'yape', 5.00, 0.00, 'completada', NULL, '2026-06-14 19:35:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (28, 'VTA-2026-0019', 598, 4, 4, 'ticket', NULL, NULL, 8.47, 1.53, 0.00, NULL, 10.00, 'efectivo', 10.00, 0.00, 'completada', NULL, '2026-06-15 11:19:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ventas` VALUES (29, 'VTA-2026-0020', NULL, 4, 4, 'ticket', NULL, NULL, 16.95, 3.05, 0.00, NULL, 20.00, 'efectivo', 20.00, 0.00, 'completada', NULL, '2026-06-16 12:28:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
