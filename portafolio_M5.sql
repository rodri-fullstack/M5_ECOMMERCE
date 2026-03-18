-- =========================================
-- PORTAFOLIO MÓDULO 5
-- Base de datos ecommerce
-- =========================================

DROP TABLE IF EXISTS detalle_compra;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE compras (
    id_compra SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_compra DATE NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    iva NUMERIC(10,2) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_compras_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE detalle_compra (
    id_detalle SERIAL PRIMARY KEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL,
    total_linea NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_detalle_compra
        FOREIGN KEY (id_compra) REFERENCES compras(id_compra),
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO usuarios (nombre, apellido, correo, contrasena, fecha_registro) VALUES
('Rodrigo', 'Valderrama', 'rodrigo@email.com', 'clave123', '2025-01-10'),
('Camila', 'Soto', 'camila@email.com', 'clave123', '2025-02-15'),
('Matias', 'Rojas', 'matias@email.com', 'clave123', '2025-03-20'),
('Fernanda', 'Perez', 'fernanda@email.com', 'clave123', '2025-04-05'),
('Diego', 'Munoz', 'diego@email.com', 'clave123', '2025-05-12');

INSERT INTO productos (nombre_producto, descripcion, precio, stock) VALUES
('Polera Negra', 'Polera de algodon talla M', 15000, 10),
('Jeans Azul', 'Jeans slim fit', 25000, 4),
('Zapatillas Urbanas', 'Zapatillas blancas unisex', 45000, 3),
('Chaqueta Denim', 'Chaqueta mezclilla clasica', 35000, 8),
('Mochila Escolar', 'Mochila con 3 compartimentos', 20000, 5);

INSERT INTO compras (id_usuario, fecha_compra, subtotal, iva, total) VALUES
(1, '2025-11-05', 85000, 16150, 101150),
(2, '2025-11-10', 25000, 4750, 29750),
(1, '2025-08-18', 15000, 2850, 17850),
(3, '2025-11-15', 45000, 8550, 53550),
(1, '2025-12-01', 35000, 6650, 41650);

INSERT INTO detalle_compra (id_compra, id_producto, cantidad, precio_unitario, total_linea) VALUES
(1, 1, 1, 15000, 15000),
(1, 3, 1, 45000, 45000),
(1, 5, 1, 20000, 20000),
(2, 2, 1, 25000, 25000),
(3, 1, 1, 15000, 15000),
(4, 3, 1, 45000, 45000),
(5, 4, 1, 35000, 35000);

-- 1) Actualizar precio con 20% de descuento
UPDATE productos
SET precio = precio * 0.80;

-- 2) Productos con stock critico
SELECT *
FROM productos
WHERE stock <= 5;

-- 3) Simular compra de 3 productos
SELECT
    SUM(total_linea) AS subtotal,
    ROUND(SUM(total_linea) * 0.19, 2) AS iva,
    ROUND(SUM(total_linea) * 1.19, 2) AS total
FROM (
    SELECT 2 * 15000 AS total_linea
    UNION ALL
    SELECT 1 * 25000
    UNION ALL
    SELECT 1 * 20000
) AS compra_simulada;

-- 4) Total ventas noviembre 2025
SELECT
    SUM(total) AS total_ventas_noviembre_2025
FROM compras
WHERE fecha_compra >= '2025-11-01'
  AND fecha_compra < '2025-12-01';

-- 5) Usuario que mas compras hizo en 2025 y su comportamiento
SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    c.id_compra,
    c.fecha_compra,
    c.subtotal,
    c.iva,
    c.total
FROM usuarios u
JOIN compras c ON u.id_usuario = c.id_usuario
WHERE c.id_usuario = (
    SELECT id_usuario
    FROM compras
    WHERE fecha_compra >= '2025-01-01'
      AND fecha_compra < '2026-01-01'
    GROUP BY id_usuario
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
AND c.fecha_compra >= '2025-01-01'
AND c.fecha_compra < '2026-01-01'
ORDER BY c.fecha_compra;
