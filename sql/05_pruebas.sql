-- Ejecutar por secciones y SOLO UNA VEZ despues de 01 a 04.
-- Un segundo CALL vuelve a aplicar el porcentaje (efecto acumulativo).

-- Prueba 1: aumento 10 % sin modificar tabla y descuento 50 %.
SELECT practica_precios.calcular_precio_ajustado(10, 10) AS aumento,
       practica_precios.calcular_precio_ajustado(10, -50) AS descuento;

-- Prueba 2: procedimiento para aumentar teclado 10 % (10 -> 11).
CALL practica_precios.actualizar_precio(1, 10);
SELECT * FROM practica_precios.productos WHERE id_producto = 1;

-- Prueba 3: descuento 20 % de mouse (20 -> 16).
CALL practica_precios.actualizar_precio(2, -20);
SELECT * FROM practica_precios.productos WHERE id_producto = 2;

-- Prueba 4: comprobar auditoria de los cambios confirmados.
SELECT p.nombre, a.precio_anterior, a.precio_nuevo, a.fecha_hora, a.usuario_bd
FROM practica_precios.auditoria_precios a
JOIN practica_precios.productos p ON p.id_producto = a.id_producto
ORDER BY a.id_auditoria;

-- Prueba 5: transaccion / ROLLBACK. Ejecutar estas cinco sentencias juntas
-- en la MISMA conexion. Antes 165 y 1 auditoria temporal, despues 150 y 0.
BEGIN;
CALL practica_precios.actualizar_precio(3, 10);
SELECT 'ANTES DEL ROLLBACK' AS estado, precio,
       (SELECT COUNT(*) FROM practica_precios.auditoria_precios WHERE id_producto = 3)
           AS registros_auditoria
FROM practica_precios.productos WHERE id_producto = 3;
ROLLBACK;
SELECT 'DESPUES DEL ROLLBACK' AS estado, precio,
       (SELECT COUNT(*) FROM practica_precios.auditoria_precios WHERE id_producto = 3)
           AS registros_auditoria
FROM practica_precios.productos WHERE id_producto = 3;

-- Prueba 6: actualizacion directa; trigger debe auditar 150 -> 160.
UPDATE practica_precios.productos
SET precio = 160.00
WHERE id_producto = 3 AND precio = 150.00
RETURNING id_producto, nombre, precio;
SELECT p.nombre, a.precio_anterior, a.precio_nuevo, a.fecha_hora, a.usuario_bd
FROM practica_precios.auditoria_precios a
JOIN practica_precios.productos p ON p.id_producto = a.id_producto
WHERE p.id_producto = 3 ORDER BY a.id_auditoria DESC;

-- Prueba 7: resumen final.
SELECT p.id_producto, p.nombre, p.precio AS precio_actual,
       COUNT(a.id_auditoria) AS cambios_registrados
FROM practica_precios.productos p
LEFT JOIN practica_precios.auditoria_precios a ON p.id_producto = a.id_producto
GROUP BY p.id_producto, p.nombre, p.precio
ORDER BY p.id_producto;

-- Prueba 8: casos de error se ejecutan INDIVIDUALMENTE en 06_errores.sql.
