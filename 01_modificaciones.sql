
- Modificaciones a tablas existentes

-- Agregar columna para registrar el ID de promoción en recargas

ALTER TABLE recargas 
ADD COLUMN id_promocion INT REFERENCES promocion(id_promocion); 

-- Agregar columna para registrar el dispositivo que validó un viaje

ALTER TABLE viajes 
ADD COLUMN dispositivo_id INT REFERENCES dispositivos(dispositivo_id);