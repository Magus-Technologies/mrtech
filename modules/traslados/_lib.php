<?php
/**
 * modules/traslados/_lib.php
 * -----------------------------------------------------------------------------
 * Funciones compartidas del módulo de Traslados / Almacenes.
 *
 * Regla de oro:
 *   El almacén "principal" (almacenes.principal = 1) está SIEMPRE sincronizado
 *   con productos.stock_actual. Es el stock que usan POS, ventas, OT y compras.
 *   Por eso, cuando movemos stock que entra o sale del almacén principal,
 *   actualizamos también productos.stock_actual para no romper el resto del sistema.
 * -----------------------------------------------------------------------------
 */

if (!function_exists('getDB')) {
    require_once __DIR__ . '/../../config/database.php';
    require_once __DIR__ . '/../../config/app.php';
}

/** Devuelve el id del almacén principal (Tienda). */
function almacenPrincipalId(PDO $db): int {
    static $id = null;
    if ($id === null) {
        $id = (int)($db->query("SELECT id FROM almacenes WHERE principal=1 LIMIT 1")->fetchColumn() ?: 0);
    }
    return $id;
}

/** Lista de almacenes activos. */
function listarAlmacenes(PDO $db, bool $soloActivos = true): array {
    $sql = "SELECT * FROM almacenes" . ($soloActivos ? " WHERE activo=1" : "") . " ORDER BY principal DESC, nombre";
    return $db->query($sql)->fetchAll();
}

/** Datos de un almacén. */
function getAlmacen(PDO $db, int $id): ?array {
    $st = $db->prepare("SELECT * FROM almacenes WHERE id=?");
    $st->execute([$id]);
    return $st->fetch() ?: null;
}

/**
 * Stock de un producto en un almacén concreto.
 * Garantiza la fila (la crea en 0 si no existe).
 */
function stockEnAlmacen(PDO $db, int $almacenId, int $productoId): float {
    $st = $db->prepare("SELECT cantidad FROM stock_almacen WHERE almacen_id=? AND producto_id=?");
    $st->execute([$almacenId, $productoId]);
    $val = $st->fetchColumn();
    if ($val === false) {
        $db->prepare("INSERT IGNORE INTO stock_almacen (almacen_id,producto_id,cantidad) VALUES (?,?,0)")
           ->execute([$almacenId, $productoId]);
        return 0.0;
    }
    return (float)$val;
}

/**
 * Ajusta el stock de un producto en un almacén sumando $delta (puede ser negativo).
 * Si el almacén es el principal, sincroniza también productos.stock_actual.
 * Registra una línea en el kardex.
 *
 * NO abre transacción: debe llamarse dentro de una transacción del caller.
 */
function moverStock(
    PDO $db, int $almacenId, int $productoId, float $delta,
    string $tipoKardex, string $motivo, string $referencia, int $usuarioId
): array {
    // Bloqueo de fila para evitar condiciones de carrera
    $st = $db->prepare("SELECT cantidad FROM stock_almacen WHERE almacen_id=? AND producto_id=? FOR UPDATE");
    $st->execute([$almacenId, $productoId]);
    $antes = $st->fetchColumn();
    if ($antes === false) {
        $db->prepare("INSERT INTO stock_almacen (almacen_id,producto_id,cantidad) VALUES (?,?,0)")
           ->execute([$almacenId, $productoId]);
        $antes = 0.0;
    }
    $antes   = (float)$antes;
    $despues = $antes + $delta;

    if ($despues < 0) {
        throw new RuntimeException("Stock insuficiente en el almacén origen (disponible: {$antes}).");
    }

    // Actualizar stock por almacén
    $db->prepare("UPDATE stock_almacen SET cantidad=? WHERE almacen_id=? AND producto_id=?")
       ->execute([$despues, $almacenId, $productoId]);

    // Sincronizar stock global si es el almacén principal
    if ($almacenId === almacenPrincipalId($db)) {
        $db->prepare("UPDATE productos SET stock_actual=? WHERE id=?")
           ->execute([$despues, $productoId]);
    }

    // Registrar en kardex (cantidad siempre positiva; el tipo indica el sentido)
    $db->prepare(
        "INSERT INTO kardex (producto_id,almacen_id,tipo,cantidad,stock_antes,stock_despues,precio_unit,motivo,referencia,usuario_id)
         VALUES (?,?,?,?,?,?,?,?,?,?)"
    )->execute([
        $productoId, $almacenId, $tipoKardex, abs($delta),
        $antes, $despues, 0, $motivo, $referencia, $usuarioId
    ]);

    return ['antes' => $antes, 'despues' => $despues];
}

/** Genera un código correlativo de traslado: TRA-2026-0001 */
function generarCodigoTraslado(PDO $db): string {
    $anio = date('Y');
    $st = $db->prepare("SELECT COUNT(*) FROM traslados WHERE YEAR(created_at)=?");
    $st->execute([$anio]);
    $n = (int)$st->fetchColumn() + 1;
    return 'TRA-' . $anio . '-' . str_pad($n, 4, '0', STR_PAD_LEFT);
}

/**
 * Ejecuta el traslado completo (origen -> destino) de forma atómica.
 *
 * @param array $items  [ ['producto_id'=>int, 'cantidad'=>float], ... ]
 * @param bool  $enTransito  true = solo descuenta origen y deja "en_transito"
 *                           false = descuenta origen y suma destino (inmediato)
 * @return int  id del traslado creado
 * @throws RuntimeException con mensaje claro si algo falla (rollback automático)
 */
function ejecutarTraslado(
    PDO $db, int $origenId, int $destinoId, array $items,
    string $observacion, int $usuarioId, bool $enTransito = false
): int {
    if ($origenId === $destinoId) {
        throw new RuntimeException('El almacén de origen y destino no pueden ser el mismo.');
    }
    if (!getAlmacen($db, $origenId) || !getAlmacen($db, $destinoId)) {
        throw new RuntimeException('Almacén de origen o destino no válido.');
    }

    // Normalizar y validar items
    $limpios = [];
    foreach ($items as $it) {
        $pid  = (int)($it['producto_id'] ?? 0);
        $cant = (float)($it['cantidad'] ?? 0);
        if ($pid > 0 && $cant > 0) {
            // Si el producto se repite, acumular
            $limpios[$pid] = ($limpios[$pid] ?? 0) + $cant;
        }
    }
    if (!$limpios) {
        throw new RuntimeException('Debe agregar al menos un producto con cantidad mayor a 0.');
    }

    $db->beginTransaction();
    try {
        // Validar disponibilidad ANTES de mover nada
        foreach ($limpios as $pid => $cant) {
            $disp = stockEnAlmacen($db, $origenId, $pid);
            if ($cant > $disp) {
                $nombre = (function() use ($db, $pid) {
                    $s = $db->prepare("SELECT nombre FROM productos WHERE id=?");
                    $s->execute([$pid]); return $s->fetchColumn() ?: "ID $pid";
                })();
                throw new RuntimeException("Stock insuficiente de «{$nombre}» en origen. Disponible: {$disp}, solicitado: {$cant}.");
            }
        }

        $estado     = $enTransito ? 'en_transito' : 'recibido';
        $codigo     = generarCodigoTraslado($db);
        $totalItems = count($limpios);
        $totalUnid  = array_sum($limpios);

        $db->prepare(
            "INSERT INTO traslados
               (codigo,almacen_origen,almacen_destino,estado,observacion,usuario_id,usuario_recibe,total_items,total_unidades,recibido_at)
             VALUES (?,?,?,?,?,?,?,?,?,?)"
        )->execute([
            $codigo, $origenId, $destinoId, $estado, $observacion, $usuarioId,
            $enTransito ? null : $usuarioId,
            $totalItems, $totalUnid,
            $enTransito ? null : date('Y-m-d H:i:s'),
        ]);
        $trasladoId = (int)$db->lastInsertId();

        foreach ($limpios as $pid => $cant) {
            $db->prepare("INSERT INTO traslado_detalle (traslado_id,producto_id,cantidad) VALUES (?,?,?)")
               ->execute([$trasladoId, $pid, $cant]);

            // Salida de origen (siempre)
            moverStock($db, $origenId, $pid, -$cant,
                'traslado_salida', "Traslado $codigo (salida a destino)", $codigo, $usuarioId);

            // Entrada a destino (solo si NO es en tránsito)
            if (!$enTransito) {
                moverStock($db, $destinoId, $pid, +$cant,
                    'traslado_entrada', "Traslado $codigo (entrada desde origen)", $codigo, $usuarioId);
            }
        }

        $db->commit();
        return $trasladoId;
    } catch (\Throwable $e) {
        $db->rollBack();
        throw new RuntimeException($e->getMessage());
    }
}

/**
 * Confirma la recepción de un traslado que estaba "en_transito":
 * suma el stock al destino y lo marca "recibido".
 */
function recibirTraslado(PDO $db, int $trasladoId, int $usuarioId): void {
    $st = $db->prepare("SELECT * FROM traslados WHERE id=?");
    $st->execute([$trasladoId]);
    $tr = $st->fetch();
    if (!$tr)                          throw new RuntimeException('Traslado no encontrado.');
    if ($tr['estado'] !== 'en_transito') throw new RuntimeException('Este traslado no está en tránsito.');

    $det = $db->prepare("SELECT * FROM traslado_detalle WHERE traslado_id=?");
    $det->execute([$trasladoId]);
    $lineas = $det->fetchAll();

    $db->beginTransaction();
    try {
        foreach ($lineas as $l) {
            moverStock($db, (int)$tr['almacen_destino'], (int)$l['producto_id'], +(float)$l['cantidad'],
                'traslado_entrada', "Recepción traslado {$tr['codigo']}", $tr['codigo'], $usuarioId);
        }
        $db->prepare("UPDATE traslados SET estado='recibido', usuario_recibe=?, recibido_at=? WHERE id=?")
           ->execute([$usuarioId, date('Y-m-d H:i:s'), $trasladoId]);
        $db->commit();
    } catch (\Throwable $e) {
        $db->rollBack();
        throw new RuntimeException($e->getMessage());
    }
}
