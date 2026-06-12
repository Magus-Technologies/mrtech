<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

$db = getDB();

$productos = $db->query("
    SELECT p.codigo, p.nombre, p.descripcion, c.nombre AS categoria, p.marca, p.modelo,
           p.serial, p.ubicacion, p.precio_costo, p.precio_venta,
           p.stock_actual, p.stock_minimo, p.stock_maximo, p.unidad, p.activo
    FROM productos p
    JOIN categorias c ON c.id = p.categoria_id
    ORDER BY p.nombre
")->fetchAll(PDO::FETCH_NUM);

// .xls XML REAL (SpreadsheetML): cada celda en su etiqueta <Cell>, Excel lo abre
// siempre en columnas separadas sin depender de la configuración regional.
$cols = ['codigo','nombre','descripcion','categoria','marca','modelo','serial',
         'ubicacion','precio_costo','precio_venta','stock_actual','stock_minimo',
         'stock_maximo','unidad','activo'];

header('Content-Type: application/vnd.ms-excel; charset=UTF-8');
header('Content-Disposition: attachment; filename="productos_' . date('Ymd_His') . '.xls"');
header('Cache-Control: max-age=0');

$esc = fn($v) => htmlspecialchars((string)$v, ENT_QUOTES | ENT_XML1, 'UTF-8');

$numericas = [8,9,10,11,12]; // precios y stocks
$celda = function($v, $col) use ($esc, $numericas) {
    $val = str_replace(',', '.', (string)$v);
    if (in_array($col, $numericas, true) && $v !== '' && is_numeric($val)) {
        return '<Cell><Data ss:Type="Number">' . $esc($val) . '</Data></Cell>';
    }
    return '<Cell><Data ss:Type="String">' . $esc($v) . '</Data></Cell>';
};

echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
echo '<?mso-application progid="Excel.Sheet"?>' . "\n";
echo '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'
   . ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' . "\n";
echo '<Worksheet ss:Name="Productos"><Table>' . "\n";

echo '<Row>';
foreach ($cols as $c) echo '<Cell><Data ss:Type="String">' . $esc($c) . '</Data></Cell>';
echo '</Row>' . "\n";

foreach ($productos as $fila) {
    echo '<Row>';
    foreach ($fila as $i => $v) echo $celda($v, $i);
    echo '</Row>' . "\n";
}

echo '</Table></Worksheet></Workbook>';
exit;
