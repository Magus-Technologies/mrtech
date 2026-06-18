<?php
/**
 * api_productos.php — API independiente para buscar productos en POS
 * Separada de pos.php para evitar redirects del servidor
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-cache');

if (!isLoggedIn()) {
    echo json_encode(['error' => 'No autorizado', 'data' => []]);
    exit;
}

$accion = $_GET['accion'] ?? $_GET['api'] ?? 'buscar';

if ($accion === 'buscar') {
    $db   = getDB();
    $user = currentUser();
    $q    = '%' . trim($_GET['q'] ?? '') . '%';

    // Resolver almacén del usuario: su asignado, o el principal como fallback
    $almacenId = null;
    $esPrincipal = false;
    try {
        if (!empty($user['almacen_id'])) {
            $almacenId = (int)$user['almacen_id'];
        }
        if (!$almacenId) {
            $almacenId = (int)$db->query("SELECT id FROM almacenes WHERE principal=1 LIMIT 1")->fetchColumn() ?: null;
        }
        if ($almacenId) {
            $esPrincipal = (int)$db->query("SELECT principal FROM almacenes WHERE id=$almacenId")->fetchColumn() === 1;
        }
    } catch (\Throwable $e) { /* módulo no instalado */ }

    if ($almacenId && !$esPrincipal) {
        // Almacén secundario: leer stock de stock_almacen
        $r = $db->prepare("
            SELECT p.id, p.codigo, p.nombre, p.precio_venta,
                   COALESCE(sa.cantidad, 0) as stock_actual, p.unidad
            FROM productos p
            LEFT JOIN stock_almacen sa ON sa.producto_id = p.id AND sa.almacen_id = ?
            WHERE p.activo = 1
              AND (p.nombre LIKE ? OR p.codigo LIKE ?)
            ORDER BY p.nombre
            LIMIT 20
        ");
        $r->execute([$almacenId, $q, $q]);
    } else {
        // Almacén principal o sin módulo: leer de productos.stock_actual
        $r = $db->prepare("
            SELECT id, codigo, nombre, precio_venta, stock_actual, unidad
            FROM productos
            WHERE activo = 1
              AND (nombre LIKE ? OR codigo LIKE ?)
            ORDER BY nombre
            LIMIT 20
        ");
        $r->execute([$q, $q]);
    }
    $data = $r->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(['ok' => true, 'data' => $data, 'total' => count($data)]);
    exit;
}

echo json_encode(['error' => 'Acción desconocida', 'data' => []]);
