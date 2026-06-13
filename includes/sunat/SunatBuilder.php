<?php
/**
 * SunatBuilder — Construye el payload JSON que la API Laravel espera.
 *
 * Convierte los datos del dominio mrtech (venta, cliente, venta_detalle + productos)
 * al formato GenerarComprobanteRequest. No habla con red ni BD.
 */
class SunatBuilder
{
    /**
     * @param array $venta   Fila de `ventas` (tipo_doc, serie_doc, num_doc, igv, fecha_venta…)
     * @param array $cliente Fila de `clientes` (ruc_dni, nombre, direccion, tipo)
     * @param array $items   Filas de `venta_detalle JOIN productos` (prod_nombre, prod_codigo, cantidad, precio_unit)
     */
    public static function buildComprobante(array $venta, array $cliente, array $items): array
    {
        $tipo       = $venta['tipo_doc'];               // 'factura' | 'boleta'
        $aplica_igv = ($venta['igv'] ?? 0) > 0;

        return [
            'endpoint'      => SUNAT_ENDPOINT,
            'documento'     => $tipo,
            'empresa'       => self::empresa(),
            'cliente'       => self::cliente($cliente, $tipo),
            'serie'         => $venta['serie_doc'],
            'numero'        => (string) $venta['num_doc'],
            'fecha_emision' => $venta['created_at'] ?? date('Y-m-d H:i:s'),
            'moneda'        => 'PEN',
            'forma_pago'    => 'contado',
            'detalles'      => self::detalles($items, $aplica_igv),
            'aplica_igv'    => $aplica_igv,
        ];
    }

    /**
     * @param array $nota    Row from `notas_credito`
     * @param array $venta   Row from `ventas` (the affected document)
     * @param array $cliente Row from `clientes`
     * @param array $items   Rows from `venta_detalle JOIN productos`
     */
    public static function buildNota(array $nota, array $venta, array $cliente, array $items): array
    {
        $tipoDocAfectado  = $venta['tipo_doc'] === 'factura' ? '01' : '03';
        $serieNumAfectado = $venta['serie_doc'] . '-' . str_pad((string) $venta['num_doc'], 8, '0', STR_PAD_LEFT);
        $aplica_igv       = ($venta['igv'] ?? 0) > 0;

        return [
            'endpoint'              => SUNAT_ENDPOINT,
            'documento'             => $nota['tipo_nota'],
            'empresa'               => self::empresa(),
            'cliente'               => self::cliente($cliente, $venta['tipo_doc']),
            'serie'                 => $nota['serie'],
            'numero'                => (string) $nota['numero'],
            'fecha_emision'         => date('Y-m-d H:i:s'),
            'moneda'                => 'PEN',
            'serie_numero_afectado' => $serieNumAfectado,
            'cod_motivo'            => $nota['cod_motivo'],
            'des_motivo'            => $nota['des_motivo'],
            'doc_afectado'          => $venta['tipo_doc'],
            'tipo_doc_afectado'     => $tipoDocAfectado,
            'detalles'              => self::detalles($items, $aplica_igv),
        ];
    }

    private static function empresa(): array
    {
        return [
            'ruc'             => SUNAT_RUC,
            'usuario'         => SUNAT_USUARIO_SOL,
            'clave'           => SUNAT_CLAVE_SOL,
            'razon_social'    => SUNAT_RAZON_SOCIAL,
            'nombreComercial' => SUNAT_NOMBRE_COMERCIAL,
            'direccion'       => SUNAT_DIRECCION,
            'ubigueo'         => SUNAT_UBIGEO,
            'distrito'        => SUNAT_DISTRITO,
            'provincia'       => SUNAT_PROVINCIA,
            'departamento'    => SUNAT_DEPARTAMENTO,
        ];
    }

    /**
     * mrtech: `clientes.ruc_dni` es un solo campo.
     * 11 dígitos → RUC (tipo_doc 6). 8 dígitos → DNI (tipo_doc 1).
     * Facturas requieren RUC obligatoriamente.
     */
    private static function cliente(array $c, string $tipo): array
    {
        $rucDni = preg_replace('/\D/', '', trim($c['ruc_dni'] ?? ''));
        $nom    = trim($c['nombre'] ?? 'CLIENTE') ?: 'CLIENTE';
        $dir    = trim($c['direccion'] ?? '-') ?: '-';
        $len    = strlen($rucDni);

        if ($tipo === 'factura') {
            if ($len !== 11) {
                throw new RuntimeException("El cliente '$nom' no tiene RUC válido (11 dígitos). Las facturas requieren RUC.");
            }
            return ['tipo_doc' => '6', 'num_doc' => $rucDni, 'rzn_social' => $nom, 'direccion' => $dir];
        }

        // Boleta
        if ($len === 8) {
            return ['tipo_doc' => '1', 'num_doc' => $rucDni, 'rzn_social' => $nom, 'direccion' => $dir];
        }
        if ($len === 11) {
            return ['tipo_doc' => '6', 'num_doc' => $rucDni, 'rzn_social' => $nom, 'direccion' => $dir];
        }
        return ['tipo_doc' => '0', 'num_doc' => '00000000', 'rzn_social' => $nom, 'direccion' => $dir];
    }

    /**
     * `venta_detalle.precio_unit` se asume CON IGV incluido cuando aplica_igv=true.
     * Items vienen de JOIN con `productos` (prod_nombre, prod_codigo).
     */
    /**
     * precio_unit in mrtech is stored WITHOUT IGV (POS adds 18% on top).
     * The API expects precio WITH IGV included — Greenter divides by 1.18 internally.
     * So we multiply by 1.18 for gravado items before sending.
     */
    private static function detalles(array $items, bool $aplica_igv = true): array
    {
        $out = [];
        foreach ($items as $i => $it) {
            $base   = (float) ($it['precio_unit'] ?? 0);
            $precio = $aplica_igv ? round($base * 1.18, 2) : $base;
            $out[] = [
                'cod_producto' => (string) ($it['prod_codigo'] ?? ($it['producto_id'] ?? ($i + 1))),
                'unidad'       => 'NIU',
                'descripcion'  => $it['prod_nombre'] ?? 'Producto',
                'cantidad'     => (float) ($it['cantidad'] ?? 1),
                'precio'       => $precio,
                'tipo_igv'     => $aplica_igv ? 'gravado' : 'exonerado',
            ];
        }
        return $out;
    }
}
