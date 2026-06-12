<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();

echo "<pre style='font-family:monospace;font-size:12px'>";
echo "=== DIAGNÓSTICO SUBIDA DE ARCHIVOS ===\n\n";

// PHP config
echo "PHP Version: " . PHP_VERSION . "\n";
echo "upload_max_filesize: " . ini_get('upload_max_filesize') . "\n";
echo "post_max_size: " . ini_get('post_max_size') . "\n";
echo "max_execution_time: " . ini_get('max_execution_time') . "\n";
echo "memory_limit: " . ini_get('memory_limit') . "\n\n";

// ffmpeg
$ffmpeg = '/usr/bin/ffmpeg';
echo "ffmpeg existe: " . (file_exists($ffmpeg) ? 'SI' : 'NO') . "\n";
echo "ffmpeg ejecutable: " . (is_executable($ffmpeg) ? 'SI' : 'NO') . "\n";
echo "ffmpeg version: " . trim(shell_exec($ffmpeg . ' -version 2>&1 | head -1')) . "\n\n";

// DB columns
$db = getDB();
echo "=== COLUMNAS fotos_ot ===\n";
$cols = $db->query("SHOW COLUMNS FROM fotos_ot")->fetchAll();
foreach ($cols as $col) {
    echo "  " . $col['Field'] . " — " . $col['Type'] . "\n";
}
echo "\n";

// Upload dir
$uploadDir = UPLOAD_PATH . 'ot/';
echo "UPLOAD_PATH: " . UPLOAD_PATH . "\n";
echo "Dir ot/ existe: " . (is_dir($uploadDir) ? 'SI' : 'NO') . "\n";
echo "Dir ot/ escribible: " . (is_writable($uploadDir) || is_writable(UPLOAD_PATH) ? 'SI' : 'NO') . "\n\n";

// Test upload if POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    echo "=== TEST POST ===\n";
    echo "FILES recibidos:\n";
    foreach ($_FILES as $key => $file) {
        if (is_array($file['name'])) {
            foreach ($file['name'] as $i => $name) {
                if (!$name) continue;
                echo "  [$key][$i]: $name — " . round($file['size'][$i]/1024/1024, 2) . "MB — error:" . $file['error'][$i] . "\n";
            }
        } else {
            echo "  [$key]: " . $file['name'] . " — " . round($file['size']/1024/1024,2) . "MB — error:" . $file['error'] . "\n";
        }
    }
    echo "\n";

    // Test video upload
    if (!empty($_FILES['video_test']['name']) && $_FILES['video_test']['error'] === 0) {
        echo "Probando uploadVideo()...\n";
        $result = uploadVideo($_FILES['video_test'], 'test', 10);
        echo "Resultado: " . print_r($result, true) . "\n";
        // Cleanup
        if ($result && file_exists(UPLOAD_PATH . $result['ruta'])) {
            unlink(UPLOAD_PATH . $result['ruta']);
        }
    }
}
echo "</pre>";

if ($_SERVER['REQUEST_METHOD'] !== 'POST'):
?>
<form method="POST" enctype="multipart/form-data">
  <p>Subir video de prueba (máx 200MB):</p>
  <input type="file" name="video_test" accept="video/*"/>
  <button type="submit">Probar</button>
</form>
<?php endif; ?>
