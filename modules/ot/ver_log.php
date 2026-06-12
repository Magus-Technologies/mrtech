<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
$log = UPLOAD_PATH . 'chunk_debug.log';
echo "<pre style='font-size:11px;font-family:monospace'>";
echo "Log: $log\n\n";
if (file_exists($log)) {
    echo htmlspecialchars(file_get_contents($log));
} else {
    echo "Sin log todavía — sube un video primero";
}
echo "</pre>";
echo "<a href='?limpiar=1'>Limpiar log</a>";
if (isset($_GET['limpiar'])) { file_put_contents($log, ''); echo " — limpiado"; }
