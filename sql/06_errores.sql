-- Ejecutar CADA consulta por separado. Debe producir un ERROR CONTROLADO.
-- No ejecutar este archivo completo como un solo bloque.

-- Producto inexistente.
CALL practica_precios.actualizar_precio(999999, 10);

-- Porcentaje mayor al limite (150 %).
CALL practica_precios.actualizar_precio(3, 150);

-- Funcion: precio NULL.
SELECT practica_precios.calcular_precio_ajustado(NULL, 10);

-- Funcion: porcentaje NULL.
SELECT practica_precios.calcular_precio_ajustado(10, NULL);

-- Funcion: precio cero.
SELECT practica_precios.calcular_precio_ajustado(0, 10);

-- Funcion: precio negativo.
SELECT practica_precios.calcular_precio_ajustado(-2, 10);

-- Funcion: porcentaje bajo minimo.
SELECT practica_precios.calcular_precio_ajustado(10, -51);

-- Funcion: resultado redondeado a cero.
SELECT practica_precios.calcular_precio_ajustado(0.001, -50);
