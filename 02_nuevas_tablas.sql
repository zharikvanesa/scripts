-- Tabla para historial de cambios de estado de las tarjetas
CREATE TABLE historial_estado (
    historial_estado_id SERIAL PRIMARY KEY,
    tarjeta_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL,
    fecha_cambio DATE NOT NULL,
    FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(tarjeta_id)
);

-- Tabla para promociones en recargas
CREATE TABLE promocion (
    id_promocion SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Tabla de dispositivos de validación
CREATE TABLE dispositivos (
    dispositivo_id SERIAL PRIMARY KEY,
    tipo_dispositivo VARCHAR(50) NOT NULL
);

-- Tabla para operaciones realizadas por usuarios (mejora adicional)
CREATE TABLE operaciones_realizadas (
    operaciones_id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    operacion VARCHAR(50) NOT NULL,
    detalle TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);