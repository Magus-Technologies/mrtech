<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../config/app.php';
requireLogin();
requireRole([ROL_ADMIN, ROL_TECNICO]);

$db   = getDB();
$user = currentUser();
$resultados = null;

// ¿Está instalado el módulo de almacenes?
$almacenes = [];
$almPrincipalId = null;
try {
    $almacenes = $db->query("SELECT id,nombre,principal FROM almacenes WHERE activo=1 ORDER BY principal DESC, nombre")->fetchAll();
    foreach ($almacenes as $a) { if ($a['principal']) $almPrincipalId = (int)$a['id']; }
} catch (\Throwable $e) { /* módulo no instalado */ }

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['archivo'])) {
    $almacenInicial = (int)($_POST['almacen_inicial'] ?? 0) ?: $almPrincipalId;
    $f = $_FILES['archivo'];

    if ($f['error'] !== UPLOAD_ERR_OK) {
        setFlash('danger', 'Error al subir el archivo.');
        redirect(BASE_URL . 'modules/inventario/importar.php');
    }
    $ext = strtolower(pathinfo($f['name'], PATHINFO_EXTENSION));
    if (!in_array($ext, ['csv','xls','tsv','txt'])) {
        setFlash('danger', 'El archivo debe ser la plantilla (.xls) o un .csv.');
        redirect(BASE_URL . 'modules/inventario/importar.php');
    }

    $contenido = file_get_contents($f['tmp_name']);
    if ($contenido === false) {
        setFlash('danger', 'No se pudo leer el archivo.');
        redirect(BASE_URL . 'modules/inventario/importar.php');
    }
    // Quitar BOM UTF-8 si existe
    $contenido = preg_replace('/^\xEF\xBB\xBF/', '', $contenido);

    // Convertir el archivo (XML SpreadsheetML o CSV/TSV) a un array de filas.
    $filas = [];
    if (stripos($contenido, '<Worksheet') !== false || stripos($contenido, 'spreadsheet') !== false) {
        // Formato XML SpreadsheetML (la plantilla .xls que genera el sistema)
        $xml = @simplexml_load_string($contenido);
        if ($xml === false) {
            setFlash('danger', 'El archivo Excel parece dañado. Descarga la plantilla nuevamente.');
            redirect(BASE_URL . 'modules/inventario/importar.php');
        }
        $ns = $xml->getNamespaces(true);
        $ssNs = $ns['ss'] ?? 'urn:schemas-microsoft-com:office:spreadsheet';
        foreach ($xml->Worksheet->Table->Row as $rowXml) {
            $celdas = [];
            $col = 0; // posición 0-based de la siguiente celda
            foreach ($rowXml->Cell as $cell) {
                // Excel OMITE las celdas vacías y usa ss:Index para indicar el
                // número de columna (1-based) de la siguiente celda con dato.
                // Hay que respetarlo o todo se corre cuando una celda va vacía.
                $attrs = $cell->attributes($ssNs);
                if (isset($attrs['Index'])) {
                    $col = ((int)$attrs['Index']) - 1;
                }
                // Rellenar con vacíos las columnas saltadas
                while (count($celdas) < $col) {
                    $celdas[] = '';
                }
                $celdas[$col] = (string)$cell->Data;
                $col++;
            }
            $filas[] = $celdas;
        }
    } else {
        // Formato CSV/TSV: detectar separador (TAB, ; o ,)
        $primeraLinea = strtok($contenido, "\r\n");
        $nTab = substr_count($primeraLinea, "\t");
        $nPyc = substr_count($primeraLinea, ';');
        $nCom = substr_count($primeraLinea, ',');
        if ($nTab >= $nPyc && $nTab >= $nCom && $nTab > 0) { $sep = "\t"; }
        elseif ($nPyc > $nCom)                             { $sep = ';'; }
        else                                               { $sep = ','; }
        $fh = fopen('php://temp', 'r+');
        fwrite($fh, $contenido);
        rewind($fh);
        while (($row = fgetcsv($fh, 0, $sep)) !== false) {
            $filas[] = $row;
        }
        fclose($fh);
    }

    if (count($filas) < 1) {
        setFlash('danger', 'El archivo está vacío o no se pudo leer.');
        redirect(BASE_URL . 'modules/inventario/importar.php');
    }

    // Cabecera = primera fila
    $cabecera = array_map(fn($c) => strtolower(trim($c)), array_shift($filas));
    $idx = array_flip($cabecera);

    if (!isset($idx['nombre'])) {
        setFlash('danger', 'La columna "nombre" es obligatoria. Descarga la plantilla para ver el formato.');
        redirect(BASE_URL . 'modules/inventario/importar.php');
    }

    // Cache de categorías (nombre normalizado => id)
    $catCache = [];
    foreach ($db->query("SELECT id, nombre FROM categorias")->fetchAll() as $c) {
        $catCache[strtolower(trim($c['nombre']))] = (int)$c['id'];
    }

    $creados = 0; $actualizados = 0; $errores = [];
    $fila = 1; // ya quitamos la cabecera
    $numCols = count($cabecera);

    foreach ($filas as $rowRaw) {
        $fila++;
        // Ignorar filas totalmente vacías
        if (count(array_filter($rowRaw, fn($v) => trim((string)$v) !== '')) === 0) continue;

        // Emparejar la fila con la cabecera POR NOMBRE de columna.
        // Si la fila trae menos celdas, las faltantes quedan vacías; si trae más,
        // se ignoran. Así nunca se corren los valores de columna.
        $asoc = [];
        foreach ($cabecera as $pos => $nombreCol) {
            $asoc[$nombreCol] = isset($rowRaw[$pos]) ? trim((string)$rowRaw[$pos]) : '';
        }
        $val = fn($key, $def = '') => array_key_exists($key, $asoc) && $asoc[$key] !== '' ? $asoc[$key] : $def;

        $nombre = $val('nombre');
        if ($nombre === '') { $errores[] = "Fila $fila: nombre vacío (omitida)."; continue; }

        $codigo     = $val('codigo');
        $catNombre  = $val('categoria', 'Otro') ?: 'Otro';
        $catKey     = strtolower($catNombre);

        try {
            $db->beginTransaction();

            // Resolver/crear categoría
            if (!isset($catCache[$catKey])) {
                $db->prepare("INSERT INTO categorias (nombre, tipo) VALUES (?, 'repuesto')")->execute([$catNombre]);
                $catCache[$catKey] = (int)$db->lastInsertId();
            }
            $catId = $catCache[$catKey];

            $precioCosto = (float)str_replace(',', '.', $val('precio_costo', '0'));
            $precioVenta = (float)str_replace(',', '.', $val('precio_venta', '0'));
            $stockIni    = (float)str_replace(',', '.', $val('stock_actual', '0'));
            $stockMin    = (float)str_replace(',', '.', $val('stock_minimo', '1'));
            $stockMax    = (float)str_replace(',', '.', $val('stock_maximo', '100'));
            $unidad      = $val('unidad', 'unidad') ?: 'unidad';
            $activo      = ($val('activo', '1') === '0') ? 0 : 1;
            $descripcion = $val('descripcion');
            $marca       = $val('marca');
            $modelo      = $val('modelo');
            $serial      = $val('serial');
            $ubicacion   = $val('ubicacion');

            // Si el stock inicial NO entra al almacén principal, el stock global (Tienda) queda en 0
            $stockGlobal = ($almPrincipalId !== null && $almacenInicial !== $almPrincipalId) ? 0 : $stockIni;

            // ¿Existe por código?
            $existe = null;
            if ($codigo !== '') {
                $q = $db->prepare("SELECT id FROM productos WHERE codigo = ?");
                $q->execute([$codigo]);
                $existe = $q->fetchColumn();
            }

            if ($existe) {
                // Actualizar (sin tocar el stock; eso se ajusta por movimientos/traslados)
                $db->prepare("UPDATE productos SET nombre=?, descripcion=?, categoria_id=?, marca=?, modelo=?, serial=?, ubicacion=?, precio_costo=?, precio_venta=?, stock_minimo=?, stock_maximo=?, unidad=?, activo=? WHERE id=?")
                   ->execute([$nombre,$descripcion,$catId,$marca,$modelo,$serial,$ubicacion,$precioCosto,$precioVenta,$stockMin,$stockMax,$unidad,$activo,$existe]);
                $actualizados++;
            } else {
                // Generar código si vino vacío
                if ($codigo === '') {
                    $n = $db->query("SELECT COUNT(*)+1 FROM productos")->fetchColumn();
                    $codigo = 'PRD-' . str_pad($n, 5, '0', STR_PAD_LEFT);
                }
                $db->prepare("INSERT INTO productos (codigo,nombre,descripcion,categoria_id,marca,modelo,serial,ubicacion,precio_costo,precio_venta,stock_actual,stock_minimo,stock_maximo,unidad,activo) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
                   ->execute([$codigo,$nombre,$descripcion,$catId,$marca,$modelo,$serial,$ubicacion,$precioCosto,$precioVenta,$stockGlobal,$stockMin,$stockMax,$unidad,$activo]);
                $prodId = (int)$db->lastInsertId();

                // Registrar en todos los almacenes (stock inicial al elegido)
                if ($almacenes) {
                    foreach ($almacenes as $a) {
                        $cant = ((int)$a['id'] === $almacenInicial) ? $stockIni : 0;
                        $db->prepare("INSERT INTO stock_almacen (almacen_id,producto_id,cantidad) VALUES (?,?,?) ON DUPLICATE KEY UPDATE cantidad=VALUES(cantidad)")
                           ->execute([(int)$a['id'], $prodId, $cant]);
                    }
                }
                // Kardex de entrada inicial
                if ($stockIni > 0) {
                    $db->prepare("INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id) VALUES (?,?,?,?,?,?,?,?,?,?)")
                       ->execute([$prodId, $almacenInicial, 'entrada', $stockIni, 0, $stockIni, $precioCosto, 'Importación masiva', 'IMPORT', $user['id']]);
                }
                $creados++;
            }

            $db->commit();
        } catch (\Throwable $e) {
            if ($db->inTransaction()) $db->rollBack();
            $errores[] = "Fila $fila ($nombre): " . $e->getMessage();
        }
    }

    $resultados = ['creados' => $creados, 'actualizados' => $actualizados, 'errores' => $errores];
}

$pageTitle  = 'Importar productos — ' . APP_NAME;
$breadcrumb = [['label'=>'Inventario','url'=>BASE_URL.'modules/inventario/index.php'],['label'=>'Importar','url'=>null]];
require_once __DIR__ . '/../../includes/header.php';
?>

<h5 class="fw-bold mb-3">Importar productos masivamente</h5>

<?php if ($resultados !== null): ?>
<div class="tr-card mb-3">
  <div class="tr-card-body">
    <h6 class="fw-bold mb-3">Resultado de la importación</h6>
    <div class="row g-2 mb-3">
      <div class="col-4"><div class="p-2 bg-light rounded text-center">
        <div class="fw-bold fs-4 text-success"><?= $resultados['creados'] ?></div><div class="small text-muted">Creados</div>
      </div></div>
      <div class="col-4"><div class="p-2 bg-light rounded text-center">
        <div class="fw-bold fs-4 text-primary"><?= $resultados['actualizados'] ?></div><div class="small text-muted">Actualizados</div>
      </div></div>
      <div class="col-4"><div class="p-2 bg-light rounded text-center">
        <div class="fw-bold fs-4 <?= $resultados['errores']?'text-danger':'text-muted' ?>"><?= count($resultados['errores']) ?></div><div class="small text-muted">Con error</div>
      </div></div>
    </div>
    <?php if ($resultados['errores']): ?>
    <div class="alert alert-warning mb-0">
      <div class="fw-semibold mb-1">Filas no importadas:</div>
      <ul class="mb-0 small">
        <?php foreach ($resultados['errores'] as $e): ?><li><?= sanitize($e) ?></li><?php endforeach; ?>
      </ul>
    </div>
    <?php endif; ?>
    <div class="mt-3">
      <a href="<?= BASE_URL ?>modules/inventario/index.php" class="btn btn-primary btn-sm">Ver inventario</a>
      <a href="<?= BASE_URL ?>modules/inventario/importar.php" class="btn btn-outline-secondary btn-sm">Importar otro archivo</a>
    </div>
  </div>
</div>
<?php else: ?>

<div class="row g-3">
  <div class="col-lg-7">
    <div class="tr-card">
      <div class="tr-card-body">
        <form method="POST" enctype="multipart/form-data">
          <div class="mb-3">
            <label class="tr-form-label">Archivo de la plantilla (.xls) o CSV *</label>
            <input type="file" name="archivo" accept=".xls,.csv,.tsv,.txt" class="form-control" required>
            <div class="form-text">Descarga la plantilla, llénala en Excel y vuelve a subirla.</div>
          </div>
          <?php if (!empty($almacenes)): ?>
          <div class="mb-3">
            <label class="tr-form-label">Almacén del stock inicial (para productos nuevos)</label>
            <select name="almacen_inicial" class="form-select">
              <?php foreach ($almacenes as $a): ?>
              <option value="<?= $a['id'] ?>" <?= $a['principal']?'selected':'' ?>>
                <?= sanitize($a['nombre']) ?><?= $a['principal']?' (Tienda)':'' ?>
              </option>
              <?php endforeach; ?>
            </select>
          </div>
          <?php endif; ?>
          <button type="submit" class="btn btn-primary">
            <i data-feather="upload" style="width:15px;height:15px"></i> Importar
          </button>
          <a href="<?= BASE_URL ?>modules/inventario/plantilla.php" class="btn btn-outline-secondary">
            <i data-feather="download" style="width:15px;height:15px"></i> Descargar plantilla
          </a>
        </form>
      </div>
    </div>
  </div>

  <div class="col-lg-5">
    <div class="tr-card">
      <div class="tr-card-header"><h6 class="mb-0 small fw-semibold">CÓMO FUNCIONA</h6></div>
      <div class="tr-card-body small">
        <ul class="mb-2 ps-3">
          <li>Descarga la <strong>plantilla</strong> y llénala en Excel.</li>
          <li>La columna <strong>nombre</strong> es obligatoria.</li>
          <li>Si el <strong>código</strong> ya existe, se <strong>actualizan</strong> los datos (sin tocar el stock).</li>
          <li>Si el código está vacío o es nuevo, se <strong>crea</strong> el producto.</li>
          <li>Las <strong>categorías</strong> que no existan se crean automáticamente.</li>
        </ul>
        <div class="text-muted">La plantilla se abre y guarda directo en Excel, en columnas.</div>
      </div>
    </div>
  </div>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
