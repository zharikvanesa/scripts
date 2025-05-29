-- Insertar dispositivos
INSERT INTO dispositivos (tipo_dispositivo) VALUES
('torniquete'),
('validador móvil'),
('lector fijo'),
('validador bus');

-- Insertar promociones
INSERT INTO promocion (nombre, descripcion, fecha_inicio, fecha_fin) VALUES
('Bonus Abril', 'Recarga con 10% extra en abril', '2025-04-01', '2025-04-30'),
('Recarga Feliz', 'Descuento para usuarios frecuentes', '2025-03-01', '2025-06-30');

-- Insertar historial de estados
INSERT INTO historial_estado (tarjeta_id, estado, fecha_cambio) VALUES
(1, 'activa', '2024-05-01'),
(1, 'bloqueada', '2024-06-10'),
(2, 'activa', '2024-07-05');

-- Insertar operaciones realizadas
INSERT INTO operaciones_realizadas (usuario_id, operacion, detalle) VALUES
(1, 'Recarga', 'Recargó $5000 con promoción Bonus Abril'),
(2, 'Viaje', 'Viaje validado en estación A');
