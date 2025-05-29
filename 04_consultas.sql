-- Auditoría del estado de tarjetas

-- 1. Cantidad de cambios de estado por mes durante el último año
SELECT DATE_TRUNC('month', fecha_cambio) AS mes, COUNT(*) AS cambios
FROM historial_estado
WHERE fecha_cambio >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY mes
ORDER BY mes;

-- 2. Las 5 tarjetas con más cambios de estado
SELECT tarjeta_id, COUNT(*) AS total_cambios
FROM historial_estado
GROUP BY tarjeta_id
ORDER BY total_cambios DESC
LIMIT 5;

-- Promociones

-- 3. Recargas con descripción de la promoción aplicada
SELECT r.recarga_id, r.fecha, r.monto, p.nombre, p.descripcion
FROM recargas r
JOIN promocion p ON r.id_promocion = p.id_promocion;

-- 4. Monto total recargado por tipo de promoción en últimos 3 meses
SELECT p.nombre, SUM(r.monto) AS total_monto
FROM recargas r
JOIN promocion p ON r.id_promocion = p.id_promocion
WHERE r.fecha >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY p.nombre;

-- 5. Promociones con "bonus" en el nombre
SELECT * FROM promocion WHERE LOWER(nombre) LIKE '%bonus%';

-- Validación de dispositivos

-- 6. Viajes sin registro de validación
SELECT * FROM viajes WHERE dispositivo_id IS NULL;

-- 7. Validaciones realizadas por dispositivos móviles en abril 2025
SELECT v.*
FROM viajes v
JOIN dispositivos d ON v.dispositivo_id = d.dispositivo_id
WHERE d.tipo_dispositivo ILIKE '%móvil%'
AND DATE_TRUNC('month', v.fecha) = '2025-04-01';

-- 8. Dispositivo con mayor número de validaciones
SELECT d.dispositivo_id, d.tipo_dispositivo, COUNT(*) AS total
FROM viajes v
JOIN dispositivos d ON v.dispositivo_id = d.dispositivo_id
GROUP BY d.dispositivo_id
ORDER BY total DESC
LIMIT 1;

-- Mejora adicional: Operaciones realizadas

-- 9. Operaciones por tipo
SELECT operacion, COUNT(*) AS total FROM operaciones_realizadas GROUP BY operacion;

-- 10. Usuarios con más operaciones (JOIN)
SELECT u.usuario_id, u.nombre, COUNT(o.operaciones_id) AS total_operaciones
FROM usuarios u
JOIN operaciones_realizadas o ON u.usuario_id = o.usuario_id
GROUP BY u.usuario_id, u.nombre
ORDER BY total_operaciones DESC;

-- 11. Últimas 5 operaciones registradas (JOIN)
SELECT u.nombre, o.operacion, o.detalle, o.fecha
FROM operaciones_realizadas o
JOIN usuarios u ON o.usuario_id = u.usuario_id
ORDER BY o.fecha DESC
LIMIT 5;
