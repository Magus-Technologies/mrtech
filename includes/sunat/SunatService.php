<?php
/**
 * SunatService — Orquesta el flujo de facturación electrónica en DOS pasos.
 *
 *   1) generarXml($ventaId)  → llama /generar/comprobante, guarda XML+hash+qr,
 *                              deja sunat_estado = 'pendiente'.
 *   2) enviarSunat($ventaId) → toma el XML guardado, llama /enviar/documento/electronico,
 *                              guarda CDR, deja sunat_estado = 'aceptado' | 'rechazado'.
 */
require_once __DIR__ . '/SunatClient.php';
require_once __DIR__ . '/SunatBuilder.php';

class SunatService
{
    private PDO         $db;
    private SunatClient $client;

    public function __construct(PDO $db, ?SunatClient $client = null)
    {
        $this->db     = $db;
        $this->client = $client ?? new SunatClient();
    }

    // ─── PASO 1: GENERAR XML ──────────────────────────────────────────
    public function generarXml(int $ventaId): array
    {
        $venta = $this->fetchVenta($ventaId);
        if (!$venta) {
            return ['ok' => false, 'mensaje' => "Venta #$ventaId no encontrada."];
        }
        if (!in_array($venta['tipo_doc'], ['factura', 'boleta'], true)) {
            return ['ok' => false, 'mensaje' => "Tipo '{$venta['tipo_doc']}' no se emite a SUNAT."];
        }
        if (empty($venta['serie_doc']) || empty($venta['num_doc'])) {
            return ['ok' => false, 'mensaje' => 'La venta no tiene serie/número asignados.'];
        }

        $cliente = $this->fetchCliente((int) $venta['cliente_id']);
        $items   = $this->fetchItems($ventaId);

        try {
            $payload = SunatBuilder::buildComprobante($venta, $cliente, $items);
        } catch (Throwable $e) {
            $this->marcarRechazada($ventaId, $e->getMessage());
            return ['ok' => false, 'mensaje' => $e->getMessage()];
        }

        $gen = $this->client->generarComprobante($payload);
        if (empty($gen['estado'])) {
            $msg = $gen['mensaje'] ?? 'Error al generar XML.';
            $this->marcarRechazada($ventaId, $msg);
            return ['ok' => false, 'mensaje' => $msg, 'detalle' => $gen];
        }

        $hash   = $gen['data']['hash']          ?? '';
        $qrInfo = $gen['data']['qr_info']       ?? '';
        $xml    = $gen['data']['contenido_xml'] ?? '';

        $this->marcarPendiente($ventaId, $hash, $qrInfo, $xml);

        return [
            'ok'      => true,
            'mensaje' => 'XML generado correctamente. Listo para enviar a SUNAT.',
            'hash'    => $hash,
            'qr'      => $qrInfo,
        ];
    }

    // ─── PASO 2: ENVIAR A SUNAT ───────────────────────────────────────
    public function enviarSunat(int $ventaId): array
    {
        $venta = $this->fetchVenta($ventaId);
        if (!$venta) {
            return ['ok' => false, 'mensaje' => "Venta #$ventaId no encontrada."];
        }
        if (empty($venta['sunat_xml'])) {
            return ['ok' => false, 'mensaje' => 'Esta venta no tiene XML generado todavía.'];
        }
        if ($venta['sunat_estado'] === 'aceptado') {
            return ['ok' => false, 'mensaje' => 'Este comprobante ya fue aceptado por SUNAT.'];
        }

        $nombreArchivo = self::nombreArchivo($venta);

        $env = $this->client->enviarDocumento([
            'ruc'                 => SUNAT_RUC,
            'usuario'             => SUNAT_USUARIO_SOL,
            'clave'               => SUNAT_CLAVE_SOL,
            'endpoint'            => SUNAT_ENDPOINT,
            'nombre_documento'    => $nombreArchivo,
            'contenido_documento' => $venta['sunat_xml'],
        ]);

        if (empty($env['estado'])) {
            $msg = $env['mensaje'] ?? 'Error al enviar a SUNAT.';
            $this->marcarRechazada(
                $ventaId, $msg,
                $venta['sunat_hash'] ?? '',
                $venta['sunat_qr']   ?? '',
                $venta['sunat_xml']  ?? ''
            );
            return ['ok' => false, 'mensaje' => $msg, 'detalle' => $env];
        }

        $this->marcarAceptada(
            $ventaId,
            $venta['sunat_hash'] ?? '',
            $venta['sunat_qr']   ?? '',
            $venta['sunat_xml']  ?? '',
            $env['cdr']     ?? '',
            $env['mensaje'] ?? 'ACEPTADO'
        );

        return [
            'ok'      => true,
            'mensaje' => 'Comprobante aceptado por SUNAT.',
            'cdr'     => $env['cdr'] ?? '',
        ];
    }

    // ─── NOTAS DE CRÉDITO / DÉBITO ────────────────────────────────────

    public function generarXmlNota(int $notaId): array
    {
        $nota = $this->fetchNota($notaId);
        if (!$nota) return ['ok' => false, 'mensaje' => "Nota #$notaId no encontrada."];

        $venta   = $this->fetchVenta((int) $nota['venta_id']);
        $cliente = $this->fetchCliente((int) $venta['cliente_id']);
        $items   = $this->fetchItems((int) $nota['venta_id']);

        try {
            $payload = SunatBuilder::buildNota($nota, $venta, $cliente, $items);
        } catch (Throwable $e) {
            $this->marcarNotaEstado($notaId, 'rechazado', $e->getMessage());
            return ['ok' => false, 'mensaje' => $e->getMessage()];
        }

        $gen = $this->client->generarNota($payload);
        if (empty($gen['estado'])) {
            $msg = $gen['mensaje'] ?? 'Error al generar XML de nota.';
            $this->marcarNotaEstado($notaId, 'rechazado', $msg);
            return ['ok' => false, 'mensaje' => $msg, 'detalle' => $gen];
        }

        $hash   = $gen['data']['hash']          ?? '';
        $qrInfo = $gen['data']['qr_info']       ?? '';
        $xml    = $gen['data']['contenido_xml'] ?? '';

        $this->db->prepare("
            UPDATE notas_credito SET
                sunat_estado='pendiente', sunat_hash=?, sunat_qr=?, sunat_xml=?,
                sunat_cdr=NULL, sunat_mensaje='XML generado, pendiente de envío.', sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$hash, $qrInfo, $xml, $notaId]);

        return ['ok' => true, 'mensaje' => 'XML de nota generado. Listo para enviar.', 'hash' => $hash, 'qr' => $qrInfo];
    }

    public function enviarSunatNota(int $notaId): array
    {
        $nota = $this->fetchNota($notaId);
        if (!$nota) return ['ok' => false, 'mensaje' => "Nota #$notaId no encontrada."];
        if (empty($nota['sunat_xml'])) return ['ok' => false, 'mensaje' => 'Esta nota no tiene XML generado.'];
        if ($nota['sunat_estado'] === 'aceptado') return ['ok' => false, 'mensaje' => 'Esta nota ya fue aceptada por SUNAT.'];

        $tipoNota = $nota['tipo_nota'] === 'credito' ? '07' : '08';
        $num      = str_pad((string) $nota['numero'], 8, '0', STR_PAD_LEFT);
        $nombre   = SUNAT_RUC . '-' . $tipoNota . '-' . $nota['serie'] . '-' . $num;

        $env = $this->client->enviarDocumento([
            'ruc'                 => SUNAT_RUC,
            'usuario'             => SUNAT_USUARIO_SOL,
            'clave'               => SUNAT_CLAVE_SOL,
            'endpoint'            => SUNAT_ENDPOINT,
            'nombre_documento'    => $nombre,
            'contenido_documento' => $nota['sunat_xml'],
        ]);

        if (empty($env['estado'])) {
            $msg = $env['mensaje'] ?? 'Error al enviar nota a SUNAT.';
            $this->marcarNotaEstado($notaId, 'rechazado', $msg, $nota['sunat_xml'], $nota['sunat_hash'] ?? '', $nota['sunat_qr'] ?? '');
            return ['ok' => false, 'mensaje' => $msg, 'detalle' => $env];
        }

        $this->db->prepare("
            UPDATE notas_credito SET
                sunat_estado='aceptado', sunat_hash=?, sunat_qr=?, sunat_xml=?,
                sunat_cdr=?, sunat_mensaje=?, sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$nota['sunat_hash'] ?? '', $nota['sunat_qr'] ?? '', $nota['sunat_xml'], $env['cdr'] ?? '', $env['mensaje'] ?? 'ACEPTADO', $notaId]);

        if ($nota['tipo_nota'] === 'credito') {
            $this->db->prepare("UPDATE ventas SET estado='anulada' WHERE id=?")
                     ->execute([$nota['venta_id']]);
        }

        return ['ok' => true, 'mensaje' => 'Nota aceptada por SUNAT.', 'cdr' => $env['cdr'] ?? ''];
    }

    public function darDeBajaNota(int $notaId, string $motivo = 'ERROR EN EMISION DE COMPROBANTE'): array
    {
        $nota = $this->fetchNota($notaId);
        if (!$nota) return ['ok' => false, 'mensaje' => "Nota #$notaId no encontrada."];
        if ($nota['sunat_estado'] !== 'aceptado') return ['ok' => false, 'mensaje' => 'Solo se puede dar de baja una nota aceptada por SUNAT.'];
        if ($nota['estado'] === 'anulada') return ['ok' => false, 'mensaje' => 'Esta nota ya fue dada de baja.'];

        $tipoDoc = $nota['tipo_nota'] === 'credito' ? '07' : '08';
        $hoy     = date('Y-m-d');

        $corrSt = $this->db->prepare("SELECT COUNT(*)+1 FROM notas_credito WHERE DATE(sunat_fecha)=? AND estado='anulada'");
        $corrSt->execute([$hoy]);
        $correlativo = (string)(int)$corrSt->fetchColumn();

        $payload = [
            'endpoint'            => SUNAT_ENDPOINT,
            'empresa'             => [
                'ruc'          => SUNAT_RUC,
                'usuario'      => SUNAT_USUARIO_SOL,
                'clave'        => SUNAT_CLAVE_SOL,
                'razon_social' => SUNAT_RAZON_SOCIAL,
                'direccion'    => SUNAT_DIRECCION,
                'ubigeo'       => SUNAT_UBIGEO,
                'distrito'     => SUNAT_DISTRITO,
                'provincia'    => SUNAT_PROVINCIA,
                'departamento' => SUNAT_DEPARTAMENTO,
            ],
            'correlativo'         => $correlativo,
            'fecha_generacion'    => $hoy,
            'fecha_comunicacion'  => $hoy,
            'detalles'            => [[
                'tipo_doc'    => $tipoDoc,
                'serie'       => $nota['serie'],
                'correlativo' => (string)$nota['numero'],
                'motivo'      => mb_strtoupper(mb_substr($motivo, 0, 100)),
            ]],
        ];

        $res = $this->client->enviarBaja($payload);

        if (empty($res['estado'])) {
            if (!empty($res['pendiente']) && !empty($res['ticket'])) {
                $ticket = $res['ticket'];
                $this->db->prepare("UPDATE notas_credito SET sunat_mensaje=?, sunat_fecha=NOW() WHERE id=?")
                         ->execute([mb_substr('BAJA_PENDIENTE:' . $ticket, 0, 1000), $notaId]);
                return [
                    'ok'      => false,
                    'pending' => true,
                    'ticket'  => $ticket,
                    'mensaje' => 'La baja fue enviada a SUNAT pero el procesamiento todavía no terminó. '
                               . 'Verificá el estado en el portal de SUNAT (Consulta de Validez). Ticket: ' . $ticket,
                ];
            }
            $msg = $res['mensaje'] ?? 'Error al enviar baja a SUNAT.';
            return ['ok' => false, 'mensaje' => $msg, 'detalle' => $res];
        }

        $this->db->prepare("
            UPDATE notas_credito SET estado='anulada', sunat_cdr=?, sunat_mensaje=?, sunat_fecha=NOW() WHERE id=?
        ")->execute([$res['cdr'] ?? null, mb_substr('BAJA: ' . ($res['mensaje'] ?? 'Aceptada'), 0, 1000), $notaId]);

        if ($nota['tipo_nota'] === 'credito') {
            $this->db->prepare("UPDATE ventas SET estado='aceptado' WHERE id=? AND estado='anulada'")
                     ->execute([$nota['venta_id']]);
        }

        return ['ok' => true, 'mensaje' => 'Baja enviada y aceptada por SUNAT. La venta original quedó reactivada.'];
    }

    public static function siguienteNumeroNota(PDO $db, string $serie): int
    {
        $st = $db->prepare("SELECT COALESCE(MAX(numero),0) FROM notas_credito WHERE serie=?");
        $st->execute([$serie]);
        $ultDb = (int)$st->fetchColumn();

        // Mapa serie -> config key
        $cfgKeys = [
            'FC01' => 'sunat_ultimo_nc_factura',
            'BC01' => 'sunat_ultimo_nc_boleta',
            'FD01' => 'sunat_ultimo_nd_factura',
            'BD01' => 'sunat_ultimo_nd_boleta',
        ];
        $ultCfg = 0;
        if (isset($cfgKeys[$serie])) {
            $st = $db->query("SELECT valor FROM configuracion WHERE clave='{$cfgKeys[$serie]}'");
            $ultCfg = (int)($st->fetchColumn() ?: 0);
        }

        return max($ultCfg, $ultDb) + 1;
    }

    // ─── Helpers ──────────────────────────────────────────────────────

    public static function nombreArchivo(array $venta): string
    {
        $tipo = $venta['tipo_doc'] === 'factura' ? '01' : '03';
        $num  = str_pad((string) $venta['num_doc'], 8, '0', STR_PAD_LEFT);
        return SUNAT_RUC . '-' . $tipo . '-' . $venta['serie_doc'] . '-' . $num;
    }

    public static function siguienteNumero(PDO $db, string $serie): int
    {
        $ultDb  = (int)$db->query("SELECT COALESCE(MAX(CAST(num_doc AS UNSIGNED)),0) FROM ventas WHERE serie_doc='$serie'")->fetchColumn();

        $cfgKey = str_starts_with($serie, 'F') ? 'sunat_ultimo_factura' : 'sunat_ultimo_boleta';
        $ultCfg = (int)($db->query("SELECT valor FROM configuracion WHERE clave='$cfgKey'")->fetchColumn() ?: 0);

        return max($ultCfg, $ultDb) + 1;
    }

    // ─── Persistencia ─────────────────────────────────────────────────

    private function marcarPendiente(int $id, string $hash, string $qr, string $xml): void
    {
        $this->db->prepare("
            UPDATE ventas SET
                sunat_estado='pendiente', sunat_hash=?, sunat_qr=?, sunat_xml=?,
                sunat_cdr=NULL, sunat_mensaje='XML generado, pendiente de envío.', sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$hash, $qr, $xml, $id]);
    }

    private function marcarAceptada(int $id, string $hash, string $qr, string $xml, string $cdr, string $msg): void
    {
        $this->db->prepare("
            UPDATE ventas SET
                sunat_estado='aceptado', sunat_hash=?, sunat_qr=?, sunat_xml=?,
                sunat_cdr=?, sunat_mensaje=?, sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$hash, $qr, $xml, $cdr, $msg, $id]);
    }

    private function marcarRechazada(int $id, string $msg, string $hash = '', string $qr = '', string $xml = ''): void
    {
        $this->db->prepare("
            UPDATE ventas SET
                sunat_estado='rechazado', sunat_hash=?, sunat_qr=?, sunat_xml=?,
                sunat_mensaje=?, sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$hash, $qr, $xml, mb_substr($msg, 0, 1000), $id]);
    }

    // ─── Lecturas ──────────────────────────────────────────────────────

    private function fetchVenta(int $id): ?array
    {
        $st = $this->db->prepare("SELECT * FROM ventas WHERE id=?");
        $st->execute([$id]);
        return $st->fetch() ?: null;
    }

    private function fetchCliente(int $id): array
    {
        $st = $this->db->prepare("SELECT * FROM clientes WHERE id=?");
        $st->execute([$id]);
        return $st->fetch() ?: [];
    }

    private function fetchItems(int $ventaId): array
    {
        $st = $this->db->prepare("
            SELECT vd.*, p.nombre as prod_nombre, p.codigo as prod_codigo
            FROM venta_detalle vd
            JOIN productos p ON p.id = vd.producto_id
            WHERE vd.venta_id = ? ORDER BY vd.id
        ");
        $st->execute([$ventaId]);
        return $st->fetchAll();
    }

    private function fetchNota(int $id): ?array
    {
        $st = $this->db->prepare("SELECT * FROM notas_credito WHERE id=?");
        $st->execute([$id]);
        return $st->fetch() ?: null;
    }

    private function marcarNotaEstado(int $id, string $estado, string $mensaje = '', string $xml = '', string $hash = '', string $qr = ''): void
    {
        $this->db->prepare("
            UPDATE notas_credito SET sunat_estado=?, sunat_mensaje=?, sunat_xml=?, sunat_hash=?, sunat_qr=?, sunat_fecha=NOW()
            WHERE id=?
        ")->execute([$estado, mb_substr($mensaje, 0, 1000), $xml, $hash, $qr, $id]);
    }
}
