<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();

$db  = getDB();
$oid = (int)($_GET['ot'] ?? 0);

echo "<pre style='font-size:12px'>";
echo "=== DEBUG VIDEO OT ===\n\n";

// Últimas OTs
echo "--- ÚLTIMAS 5 OTs ---\n";
$ots = $db->query("SELECT id, codigo_ot, created_at FROM ordenes_trabajo ORDER BY id DESC LIMIT 5")->fetchAll();
foreach ($ots as $o) echo "  ID:{$o['id']} {$o['codigo_ot']} {$o['created_at']}\n";

echo "\n--- TODOS los registros fotos_ot (últimos 10) ---\n";
$all = $db->query("SELECT id, ot_id, ruta, tipo_archivo, tamano_bytes, created_at FROM fotos_ot ORDER BY id DESC LIMIT 10")->fetchAll();
foreach ($all as $r) {
    $existe = file_exists(UPLOAD_PATH . $r['ruta']) ? 'ARCHIVO_OK' : 'ARCHIVO_FALTA';
    echo "  ID:{$r['id']} ot_id:{$r['ot_id']} tipo:{$r['tipo_archivo']} {$existe} ruta:{$r['ruta']}\n";
}

if ($oid) {
    echo "\n--- REGISTROS para OT #$oid ---\n";
    $rows = $db->prepare("SELECT * FROM fotos_ot WHERE ot_id=? ORDER BY id DESC");
    $rows->execute([$oid]);
    foreach ($rows->fetchAll() as $r) {
        $existe = file_exists(UPLOAD_PATH . $r['ruta']) ? '✅ archivo OK' : '❌ NO existe';
        echo "  ID:{$r['id']} tipo:{$r['tipo_archivo']} {$existe}\n";
        echo "  URL: " . UPLOAD_URL . $r['ruta'] . "\n";
    }
    
    echo "\n--- VIDEO_CHUNK_IDS que llegarían al POST ---\n";
    $huerfanos = $db->query("SELECT id, ruta, created_at FROM fotos_ot WHERE ot_id IS NULL AND tipo_archivo='video' ORDER BY id DESC LIMIT 5")->fetchAll();
    echo "Videos huerfanos (ot_id=0):\n";
    foreach ($huerfanos as $h) {
        $existe = file_exists(UPLOAD_PATH . $h['ruta']) ? '✅' : '❌';
        echo "  ID:{$h['id']} {$existe} {$h['created_at']} ruta:{$h['ruta']}\n";
    }
}

echo "\nUPLOAD_PATH: " . UPLOAD_PATH . "\n";
echo "UPLOAD_URL: "  . UPLOAD_URL  . "\n";
echo "</pre>";
echo "<p>Uso: ?ot=ID_DE_LA_OT</p>";
