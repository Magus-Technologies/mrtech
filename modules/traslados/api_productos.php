<?php
/**
 * modules/traslados/api_productos.php
 * Devuelve productos con su stock en el almacén indicado (?almacen=ID&q=texto).
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
require_once __DIR__ . '/_lib.php';
requireLogin();

header('Content-Type: application/json; charset=utf-8');

$db        = getDB();
$almacenId = (int)($_GET['almacen'] ?? 0);
$q         = trim($_GET['q'] ?? '');

if ($almacenId <= 0) {
    echo json_encode([]); exit;
}

$where  = ['p.activo=1'];
$params = [':alm' => $almacenId];

if ($q !== '') {
    $where[] = '(p.nombre LIKE :q OR p.codigo LIKE :q OR p.serial LIKE :q)';
    $params[':q'] = '%' . $q . '%';
}

// COALESCE para productos que aún no tienen fila en stock_almacen (= 0)
$sql = "SELECT p.id, p.codigo, p.nombre, p.marca, p.modelo, p.unidad,
               COALESCE(sa.cantidad,0) AS stock
        FROM productos p
        LEFT JOIN stock_almacen sa
               ON sa.producto_id = p.id AND sa.almacen_id = :alm
        WHERE " . implode(' AND ', $where) . "
        ORDER BY p.nombre
        LIMIT 50";

$st = $db->prepare($sql);
$st->execute($params);

echo json_encode($st->fetchAll(), JSON_UNESCAPED_UNICODE);
