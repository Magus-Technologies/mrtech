<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
echo "<pre>";
echo "upload_max_filesize: " . ini_get('upload_max_filesize') . "\n";
echo "post_max_size: "       . ini_get('post_max_size')       . "\n";
echo "max_execution_time: "  . ini_get('max_execution_time')  . "\n";
echo "memory_limit: "        . ini_get('memory_limit')        . "\n";
echo "PHP-FPM/SAPI: "        . php_sapi_name()                . "\n";
echo "</pre>";
