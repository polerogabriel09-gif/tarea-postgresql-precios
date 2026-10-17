-- Gabriel Polero | Carne 2890-24-8909
-- Practica: funciones, procedimientos, triggers y auditoria en PostgreSQL.
-- EJECUTAR SOLO UNA VEZ EN UNA BASE DE PRUEBAS LIMPIA.
-- ATENCION: elimina y recrea exclusivamente las tablas del esquema practica_precios.
CREATE SCHEMA IF NOT EXISTS practica_precios;
DROP TABLE IF EXISTS practica_precios.auditoria_precios;
DROP TABLE IF EXISTS practica_precios.productos;

CREATE TABLE practica_precios.productos (
    id_producto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(12,2) NOT NULL CHECK (precio > 0)
);

CREATE TABLE practica_precios.auditoria_precios (
    id_auditoria BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_producto INTEGER NOT NULL REFERENCES practica_precios.productos(id_producto),
    precio_anterior NUMERIC(12,2) NOT NULL,
    precio_nuevo NUMERIC(12,2) NOT NULL,
    fecha_hora TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    usuario_bd TEXT NOT NULL DEFAULT current_user
);

INSERT INTO practica_precios.productos (nombre, precio)
VALUES ('Teclado mecanico', 10.00),
       ('Mouse inalambrico', 20.00),
       ('Monitor LED', 150.00);

SELECT * FROM practica_precios.productos ORDER BY id_producto;
