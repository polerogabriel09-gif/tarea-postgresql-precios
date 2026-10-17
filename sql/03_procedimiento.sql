-- Actualiza solo el precio de un producto, usando la funcion escalar.
CREATE OR REPLACE PROCEDURE practica_precios.actualizar_precio(
    IN p_id_producto INTEGER,
    IN p_porcentaje NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_precio_actual NUMERIC;
    v_precio_nuevo NUMERIC;
BEGIN
    SELECT precio INTO v_precio_actual
    FROM practica_precios.productos
    WHERE id_producto = p_id_producto
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto no existe';
    END IF;

    v_precio_nuevo := practica_precios.calcular_precio_ajustado(
        v_precio_actual, p_porcentaje
    );

    UPDATE practica_precios.productos
    SET precio = v_precio_nuevo
    WHERE id_producto = p_id_producto;
END;
$$;

SELECT routine_name, routine_type
FROM information_schema.routines
WHERE specific_schema = 'practica_precios'
  AND routine_name = 'actualizar_precio';
