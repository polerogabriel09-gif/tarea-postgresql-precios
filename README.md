# Control de precios y auditoria en PostgreSQL

**Estudiante:** Gabriel Polero  
**Carne:** 2890-24-8909

## Objetivo

Desarrollar una funcion escalar que calcule aumentos y descuentos, un procedimiento almacenado para actualizar los precios y un trigger que guarde la trazabilidad de cambios. Se incluyen pruebas de validacion, actualizacion directa y `ROLLBACK`.

## Entorno

PostgreSQL, DataGrip y Docker Desktop. Se utilizo la base `chinook_serial`, agregando un esquema independiente `practica_precios` para no modificar las tablas originales de Chinook.

## Archivos y orden de uso

1. `sql/01_preparacion.sql`: esquema, tablas y datos de ejemplo.
2. `sql/02_funcion.sql`: funcion escalar y dos ejemplos.
3. `sql/03_procedimiento.sql`: procedimiento almacenado de actualizacion.
4. `sql/04_trigger.sql`: funcion de auditoria y trigger `AFTER UPDATE`.
5. `sql/05_pruebas.sql`: consultas, transaccion y verificacion final (ejecutar por secciones).
6. `sql/06_errores.sql`: validaciones que intencionalmente generan errores; ejecutar una por una.

**Importante:** `01_preparacion.sql` vuelve a crear las tablas `practica_precios.productos` y `practica_precios.auditoria_precios` desde cero. Usarlo solamente al reproducir la practica en una base de PRUEBAS. No volver a ejecutar estos scripts en la base de datos que contiene las evidencias, porque reiniciaria los resultados.

**Importante:** Repetir un `CALL` de ajuste aplica otra vez el porcentaje sobre el precio que ya se cambio. El procedimiento no es idempotente. Durante las pruebas interactivas se aplicaron ajustes repetidos; por eso el estado final documentado no coincide con ejecutar una sola vez los ejemplos de `05_pruebas.sql`.

## Validaciones

- `p_precio_actual` y `p_porcentaje` no admiten `NULL`.
- Precio inicial estrictamente positivo.
- Porcentaje permitido entre -50 y 100 inclusive.
- Precio redondeado final estrictamente positivo.
- Producto inexistente produce una excepcion.
- `ROLLBACK` revierte el precio y tambien el registro creado por el trigger en la misma transaccion.

## Evidencias obtenidas en DataGrip

- Funcion: `calcular_precio_ajustado(10,10) = 11` y `(10,-50) = 5`.
- Procedimiento `actualizar_precio` aparece como `PROCEDURE`.
- Trigger `trg_auditoria_precios` aparece como `UPDATE / AFTER`.
- El historial registro aumentos y descuentos del teclado y del mouse.
- Validacion de producto inexistente y de 150 %: errores controlados.
- Antes de `ROLLBACK`: monitor 165.00 y 1 registro temporal; despues: 150.00 y 0.
- Un `UPDATE` directo registro 150.00 -> 160.00 para el monitor.
- Resumen final observado en la sesion de pruebas: teclado 12.10 (2 cambios), mouse 8.19 (4 cambios), monitor 160.00 (1 cambio).

Las capturas originales se incorporan al informe PDF entregado por separado.
