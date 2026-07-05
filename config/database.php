<?php
// config/database.php — Conexión PDO con detección local/producción

// ── Log de errores dedicado del proyecto (se escribe en /logs del propio proyecto) ──
(function () {
    $dir = __DIR__ . '/../logs';
    if (!is_dir($dir)) { @mkdir($dir, 0775, true); }
    ini_set('log_errors',   '1');
    ini_set('error_log',    $dir . '/php-error.log');
    ini_set('display_errors','1'); // TEMPORAL: mostrar error en pantalla para diagnóstico — revertir a '0'
    error_reporting(E_ALL);
})();

function isLocal(): bool {
    $host = $_SERVER['HTTP_HOST'] ?? gethostname();
    return str_contains($host, 'localhost')
        || str_contains($host, '127.0.0.1')
        || str_ends_with($host, '.test')
        || str_ends_with($host, '.local');
}

if (isLocal()) {
    define('DB_HOST', 'localhost');
    define('DB_NAME', 'r_mrtech');
    define('DB_USER', 'root');
    define('DB_PASS', '');
    define('APP_ENV', 'development');
} else {
    define('DB_HOST', 'localhost');           // production host
    define('DB_NAME', 'r_mrtech');            // production db name
    define('DB_USER', 'root');                // production db user
    define('DB_PASS', 'c4p1cu4$$');            // production db password
    define('APP_ENV', 'production');
}

define('DB_CHARSET', 'utf8mb4');

// Auto-detectar dominio y protocolo (funciona en localhost Y en servidor real)
$_protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$_host     = $_SERVER['HTTP_HOST'] ?? 'localhost';
$_script   = $_SERVER['SCRIPT_NAME'] ?? '/mrtech/index.php';

// Obtener la carpeta raíz del proyecto (primer segmento del path, ej: "techrepair")
$_parts = explode('/', trim($_script, '/'));
$_root  = $_parts[0] ?? 'techrepair';

define('BASE_URL',    $_protocol . '://' . $_host . '/' . $_root . '/');
define('BASE_PATH',   dirname(__DIR__) . '/');
define('UPLOAD_PATH', BASE_PATH . 'assets/img/uploads/');
define('UPLOAD_URL',  BASE_URL  . 'assets/img/uploads/');

function getDB(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            die(json_encode(['error' => 'Error de conexión a la base de datos: ' . $e->getMessage()]));
        }
    }
    return $pdo;
}
