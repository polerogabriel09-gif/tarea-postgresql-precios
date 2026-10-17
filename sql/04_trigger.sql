-- Graba cambios de precio independientemente de si provienen de CALL o UPDATE.
CREATE OR REPLACE FUNCTION practica_precios.registrar_cambio_precio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO practica_precios.auditoria_precios (
        id_producto, precio_anterior, precio_nuevo, fecha_hora, usuario_bd
    )
    VALUES (
        OLD.id_producto, OLD.precio, NEW.precio,
        clock_timestamp(), current_user
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_auditoria_precios ON practica_precios.productos;
CREATE TRIGGER trg_auditoria_precios
AFTER UPDATE OF precio ON practica_precios.productos
FOR EACH ROW
WHEN (OLD.precio IS DISTINCT FROM NEW.precio)
EXECUTE FUNCTION practica_precios.registrar_cambio_precio();

SELECT trigger_name, event_manipulation, action_timing
FROM information_schema.triggers
WHERE event_object_schema = 'practica_precios'
  AND event_object_table = 'productos';
