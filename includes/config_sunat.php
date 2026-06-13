<?php
/**
 * mrtech — Configuración SUNAT
 * Lee credenciales desde la tabla `configuracion` (clave/valor).
 * LOCAL: fuerza beta + credenciales MODDATOS.
 */

$__host    = $_SERVER['HTTP_HOST'] ?? gethostname();
$__isLocal = (
    str_contains($__host, 'localhost') ||
    str_contains($__host, '127.0.0.1') ||
    str_contains($__host, '.test')      ||
    str_contains($__host, '.local')
);

if ($__isLocal) {
    define('SUNAT_API_URL', 'http://api-sunat-laravel.test/api/v1');
} else {
    define('SUNAT_API_URL', 'https://magus-qa.com/api-sunat-laravel/api/v1');
}

define('SUNAT_API_TIMEOUT', 60);

// ─── Leer configuracion desde BD ────────────────────────────────────
function loadSunatConfigMrtech(): array {
    if (!isset($GLOBALS['__sunat_cfg_loaded_mrtech'])) {
        $GLOBALS['__sunat_cfg_loaded_mrtech'] = true;
        try {
            $rows = getDB()->query("SELECT clave, valor FROM configuracion")->fetchAll(PDO::FETCH_KEY_PAIR);
            $GLOBALS['__sunat_cfg_mrtech'] = $rows ?: [];
        } catch (Exception $e) {
            $GLOBALS['__sunat_cfg_mrtech'] = [];
        }
    }
    return $GLOBALS['__sunat_cfg_mrtech'] ?? [];
}

$__cfg = loadSunatConfigMrtech();

// ─── Modo y credenciales SOL ─────────────────────────────────────────
if ($__isLocal) {
    define('SUNAT_ENDPOINT',    'beta');
    define('SUNAT_RUC',         '20000000001');
    define('SUNAT_USUARIO_SOL', 'MODDATOS');
    define('SUNAT_CLAVE_SOL',   'MODDATOS');
} else {
    define('SUNAT_ENDPOINT',    $__cfg['sunat_modo']         ?? 'produccion');
    define('SUNAT_RUC',         $__cfg['empresa_ruc']        ?? '20000000001');
    define('SUNAT_USUARIO_SOL', $__cfg['sunat_usuario_sol']  ?? 'MODDATOS');
    define('SUNAT_CLAVE_SOL',   $__cfg['sunat_clave_sol']    ?? 'MODDATOS');
}

// ─── Datos del emisor ────────────────────────────────────────────────
define('SUNAT_RAZON_SOCIAL',     $__cfg['empresa_nombre']    ?? 'EMPRESA DE PRUEBAS S.A.C.');
define('SUNAT_NOMBRE_COMERCIAL', $__cfg['empresa_nombre']    ?? 'MrTech');
define('SUNAT_DIRECCION',        $__cfg['empresa_direccion'] ?? 'AV. PRUEBA 123');
define('SUNAT_UBIGEO',           $__cfg['sunat_ubigeo']      ?? '150101');
define('SUNAT_DISTRITO',         $__cfg['sunat_distrito']    ?? 'LIMA');
define('SUNAT_PROVINCIA',        $__cfg['sunat_provincia']   ?? 'LIMA');
define('SUNAT_DEPARTAMENTO',     $__cfg['sunat_departamento'] ?? 'LIMA');

// ─── Series ──────────────────────────────────────────────────────────
define('SUNAT_SERIE_FACTURA', $__cfg['serie_factura'] ?? 'F001');
define('SUNAT_SERIE_BOLETA',  $__cfg['serie_boleta']  ?? 'B001');

define('SUNAT_SERIE_NC_FACTURA', 'FC01');
define('SUNAT_SERIE_NC_BOLETA',  'BC01');
define('SUNAT_SERIE_ND_FACTURA', 'FD01');
define('SUNAT_SERIE_ND_BOLETA',  'BD01');
