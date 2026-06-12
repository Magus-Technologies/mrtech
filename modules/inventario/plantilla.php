<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

// Generamos un .xls XML REAL (SpreadsheetML de Excel 2003) donde cada celda va
// en su etiqueta <Cell>. Así Excel SIEMPRE lo abre en columnas separadas, sin
// depender del separador ni de la configuración regional (que rompía el CSV/TSV).
$cols = ['codigo','nombre','descripcion','categoria','marca','modelo','serial',
         'ubicacion','precio_costo','precio_venta','stock_actual','stock_minimo',
         'stock_maximo','unidad','activo'];

$datos = [
    ['', 'Memoria RAM 8GB', 'DDR4 2666MHz', 'Hardware', 'Kingston', 'KVR26', '', 'Estante A', '120.00', '180.00', '10', '2', '50', 'unidad', '1'],
    ['PRD-00050', 'Cargador Tipo C', '', 'Accesorio', 'Genérico', '', '', '', '8.00', '20.00', '25', '5', '100', 'unidad', '1'],
];

header('Content-Type: application/vnd.ms-excel; charset=UTF-8');
header('Content-Disposition: attachment; filename="plantilla_productos.xls"');
header('Cache-Control: max-age=0');

$esc = fn($v) => htmlspecialchars((string)$v, ENT_QUOTES | ENT_XML1, 'UTF-8');

// Índices de columnas numéricas (precio_costo, precio_venta, stocks)
$numericas = [8,9,10,11,12];
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

// Cabecera
echo '<Row>';
foreach ($cols as $c) echo '<Cell><Data ss:Type="String">' . $esc($c) . '</Data></Cell>';
echo '</Row>' . "\n";

// Filas de ejemplo
foreach ($datos as $fila) {
    echo '<Row>';
    foreach ($fila as $i => $v) echo $celda($v, $i);
    echo '</Row>' . "\n";
}

echo '</Table></Worksheet></Workbook>';
exit;
