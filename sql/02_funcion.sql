-- Calcula aumentos y descuentos sin cambiar el catalogo.
-- Rango valido: de -50 a 100 por ciento.
CREATE OR REPLACE FUNCTION practica_precios.calcular_precio_ajustado(
    p_precio_actual NUMERIC,
    p_porcentaje NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_resultado NUMERIC;
BEGIN
    IF p_precio_actual IS NULL OR p_porcentaje IS NULL THEN
        RAISE EXCEPTION 'El precio y el porcentaje no pueden ser NULL';
    END IF;

    IF p_precio_actual <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor que cero';
    END IF;

    IF p_porcentaje < -50 OR p_porcentaje > 100 THEN
        RAISE EXCEPTION 'El porcentaje debe estar entre -50 y 100';
    END IF;

    v_resultado := ROUND(p_precio_actual * (1 + p_porcentaje / 100), 2);

    IF v_resultado <= 0 THEN
        RAISE EXCEPTION 'El precio ajustado debe ser mayor que cero';
    END IF;

    RETURN v_resultado;
END;
$$;

SELECT practica_precios.calcular_precio_ajustado(10, 10) AS aumento,
       practica_precios.calcular_precio_ajustado(10, -50) AS descuento;
