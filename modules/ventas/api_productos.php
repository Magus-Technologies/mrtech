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
    $db = getDB();
    $q  = '%' . trim($_GET['q'] ?? '') . '%';
    $r  = $db->prepare("
        SELECT id, codigo, nombre, precio_venta, stock_actual, unidad
        FROM productos
        WHERE activo = 1
          AND (nombre LIKE ? OR codigo LIKE ?)
        ORDER BY nombre
        LIMIT 20
    ");
    $r->execute([$q, $q]);
    $data = $r->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(['ok' => true, 'data' => $data, 'total' => count($data)]);
    exit;
}

echo json_encode(['error' => 'Acción desconocida', 'data' => []]);
