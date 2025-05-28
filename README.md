# Sistema de Recargas y gestion de viajes  - Base de Datos

Este repositorio contiene los scripts SQL necesarios para implementar una solución de base de datos para un sistema de recargas y gestión de viajes.

---

##  Funcionalidades implementadas

- Modificaciones a las tablas existentes para incluir nuevos campos.
- Creación de nuevas entidades relacionadas con recargas y viajes.
- Inserción de más de 100 registros para pruebas.
- Consultas SQL que permiten validar el correcto funcionamiento del sistema.

---

##  Instrucciones para ejecutar los scripts

1. Ejecutar `01_crear_tabla_historial_estado.sql` para crear una nueva tabla para registrar cada cambio de estado de una tarjeta.
2. Ejecutar `02_insertar_datos.sql' para insertar datos de prueba.
3. Ejecutar `03_consultas.sql` para verificar con las consultas desarrolladas.
4. Ejecutar `04_crear_tablas_promocion.sql` para crear las nuevas tablas para registrar y consultar descuentos o bonos aplicados en las recargas realizadas por el usuario.
5. Ejecutar `05_modificar_tabla_recargas.sql` para tener una relacion entre la tabla promocion y recargas.
6. Ejecutar `06_insertar_datos.sql` para insertar datos de prueba
7. Ejecutar `07_consultas.sql` para verificar con las consultas desarrolladas.
8. Ejecutar `08_crear_tablas_dispositivos.sql` para crear las nuevas tablas la cual permita almacenar información sobre qué dispositivo para valida cada viaje.
9. Ejecutar `09_modificar_tabla_viajes.sql` para tener una relacion entre la tabla viajes y dispositivos.
10. Ejecutar `10_insertar_datos.sql` para insertar datos de prueba
11. Ejecutar `11_consultas.sql` para verificar con las consultas desarrolladas.
12. Ejecutar `12_crear_tablas_operaciones_realizadas.sql` para poder mejorar la base de datos actual.
13. Ejecutar `13_insertar_datos.sql` para insertar datos de prueba
14. Ejecutar `14_consultas.sql` para verificar con las consultas desarrolladas.


---

##  Diagrama ER (Mermaid)

```mermaid
erDiagram
    
  Diagram
    USUARIOS {
        int usuario_id PK
        string nombre
        string apellido
        string numero_contacto
        string correo_electronico
        string genero
        date fecha_nacimiento
        string direccion_residencia
        string numero_cedula
        string ciudad_nacimiento
        date fecha_registro
    }

    LOCALIDADES {
        int localidad_id PK
        string nombre
    }

    TARJETAS {
        int tarjeta_id PK
        int usuario_id FK
        date fecha_adquisicion
        string estado
        date fecha_actualizacion
    }

    PUNTOS_RECARGA {
        int punto_recarga_id PK
        string direccion
        float latitud
        float longitud
        int localidad_id FK
    }
        TARIFAS {
        int tarifa_id PK
        float valor
        date fecha
    }

    RECARGAS {
        int recarga_id PK
        date fecha
        float monto
        int punto_recarga_id FK
        int tarjeta_id FK
    }

    ESTACIONES {
        int estacion_id PK
        string nombre
        string direccion
        int localidad_id
        float latitud
        float longitud
    }

    RUTAS {
        int ruta_id PK
        int estacion_origen_id FK
        int estacion_destino_id FK
    }

    ESTACIONES_INTERMEDIAS {
        int estacion_id PK "FK"
        int ruta_id PK "FK"
    }

VIAJES {
        int viaje_id PK
        int estacion_abordaje_id FK
        date fecha
        int tarifa_id FK
        int tarjeta_id FK
    }

historial_estado {
        int historial_estado_id PK
        string estado
        date fecha
        int tarjeta_id FK
    }

promocion {
        int id_promocion PK
        string nombre
        string descripcion
        date fecha
        int tarjeta_id FK
    }

dispositivos {
        int dispositivo_id PK
        string tipo_dispositivo
        int viaje_id FK
    }

operaciones_realizadas {
        int operaciones_id PK
        string operacion
        string detalle
        date fecha
        int usuario_id FK
    }

    USUARIOS ||--o{ TARJETAS : ""
    TARJETAS ||--o{ RECARGAS : ""
    PUNTOS_RECARGA ||--o{ RECARGAS : ""
    LOCALIDADES ||--o{ PUNTOS_RECARGA : ""
    LOCALIDADES ||--o{ ESTACIONES : ""
    ESTACIONES ||--o{ VIAJES : ""
    TARJETAS ||--o{ VIAJES : ""
    TARIFAS ||--o{ VIAJES : ""
    ESTACIONES ||--|{ RUTAS : ""
	  ESTACIONES ||--|{ RUTAS : ""
    RUTAS ||--o{ ESTACIONES_INTERMEDIAS : ""
    ESTACIONES ||--o{ ESTACIONES_INTERMEDIAS : ""
    TARJETAS ||--o{ HISTORIAL_ESTADO : ""
    PROMOCION ||--|{ TARJETAS : ""
    VIAJES ||--o{ DIPOSITIVOS : ""
    USUARIOS ||--o{ OPERACIONES_REALIZADAS : ""
##   Resumen


##   scripts
-- Crear la tabla historial_estado
CREATE TABLE historial_estado (
    historial_estado_id INT PRIMARY KEY,            -- Identificador único del historial
    tarjeta_id INT NOT NULL,                        -- ID de la tarjeta relacionada
    estado VARCHAR(20) NOT NULL,                    -- Estado asociado a la tarjeta (ej. 'activo', 'inactivo')
    fecha_cambio DATE,                              -- Fecha del cambio de estado

    -- Clave foránea que referencia a la tabla tarjetas
    FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(tarjeta_id)
);

-- Crear la tabla promocion
CREATE TABLE promocion (
    id_promocion SERIAL PRIMARY KEY,      -- Identificador único de la promoción (autoincremental)
    nombre VARCHAR(50) NOT NULL,          -- Nombre de la promoción (obligatorio)
    descripcion TEXT,                     -- Descripción detallada de la promoción (opcional)
    fecha_inicio DATE,                    -- Fecha en la que inicia la promoción
    fecha_fin DATE                        -- Fecha en la que finaliza la promoción
);
-- Agregar la columna 'tarjetas' a la tabla 'promocion'
ALTER TABLE promocion
ADD COLUMN tarjetas INT,
ADD CONSTRAINT fk_tarjetas
    FOREIGN KEY (tarjetas) REFERENCES tarjetas(tarjeta_id);

-- Crear la tabla dispositivos
CREATE TABLE dispositivos (
    dispositivo_id SERIAL PRIMARY KEY,        -- Identificador único y autoincremental del dispositivo
    tipo_dispositivo VARCHAR(50) NOT NULL     -- Tipo de dispositivo (ej: 'torniquete', 'validador', 'móvil')
);

ALTER TABLE dispositivos 
ADD COLUMN dispositivos INT REFERENCES dispositivos (dispositivo_id);

-- Crear la tabla operaciones_realizadas
CREATE TABLE operaciones_realizadas (
    operaciones_id SERIAL PRIMARY KEY,        -- ID único de cada operación (autoincremental)
    usuario_id INT NOT NULL,                  -- ID del usuario que realiza la operación
    operacion VARCHAR(50) NOT NULL,           -- Tipo de operación: 'recarga', 'viaje', 'cambio_estado_tarjeta', etc.
    detalle TEXT,                             -- Detalles adicionales de la operación
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora en que se realiza la operación (por defecto: ahora)

    -- Clave foránea que relaciona con la tabla usuarios
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

## 🔍 Consultas SQL desarrolladas

A continuación, se presenta una lista de las consultas incluidas:

1. **Cantidad de cambios de estado por mes durante el último año**
   - Muestra el número de registros de cambio de estado agrupados por mes, filtrando únicamente los últimos 12 meses. Permite observar tendencias en la modificación del estado de       tarjetas u objetos del sistema.

2. **Top 5 tarjetas con mayor número de cambios de estado**
   - Identifica las cinco tarjetas con más cambios de estado registrados, lo que puede señalar un uso intensivo o situaciones problemáticas que requieren revisión.

3. **Recargas con descripción de la promoción aplicada**
   - Devuelve un listado de recargas donde se incluye el detalle de la promoción utilizada, facilitando el análisis de la efectividad de las promociones.

4. **Monto total recargado por cada tipo de promoción en los últimos 3 meses**
   - Resume el total recargado agrupado por tipo de promoción, limitado a los últimos tres meses. Esta información permite evaluar qué promociones están generando mayor impacto económico.

5. **Promociones cuyo nombre contenga la palabra "bonus"**
   - Filtra las promociones que en su nombre incluyen la palabra clave “bonus”, útil para identificar campañas específicas y su uso en el sistema.

6. **Viajes sin registro de validación**
   -Lista los viajes que no tienen una validación asociada, lo cual puede representar inconsistencias operativas o fallos en el sistema de control de acceso.

7. **Validaciones realizadas por dispositivos de tipo móvil en abril de 2025**
   -Extrae todas las validaciones hechas desde dispositivos móviles durante abril de 2025. Permite analizar el uso de tecnología móvil para el control de acceso en un periodo específico.

8. **Dispositivo con mayor cantidad de validaciones**
   -Identifica cuál fue el dispositivo (por su ID o nombre) que realizó la mayor cantidad de validaciones, útil para monitoreo de carga de trabajo o fallos potenciales.

9. **DOperaciones realizadas por usuario en la última semana**
   -Muestra las operaciones realizadas por los usuarios durante los últimos 7 días, ordenadas de forma descendente por fecha. Es útil para revisar actividad reciente.

##  Resumen

Tabla                            	Propósito	                                                                                  Campos clave
usuarios	              Almacena la información básica de los usuarios del sistema.                                      	usuario_id, nombre, apellido
recargas	              Registra las recargas de saldo realizadas por los usuarios.                                      	recarga_id, usuario_id, monto, fecha, promocion_id
promociones	            Contiene información sobre promociones disponibles para aplicar en recargas.	                    promocion_id, nombre, tipo_promocion
viajes	                Guarda los viajes realizados por los usuarios.	                                                  viaje_id, usuario_id, fecha
validaciones	          Registra las validaciones que permiten acceso al sistema (por viaje/dispositivo).	                validacion_id, viaje_id, dispositivo_id, fecha
cambios_estado	        Lleva un historial de los cambios de estado realizados en tarjetas u objetos.                    	id, tarjeta_id, fecha_cambio, estado_anterior, estado_nuevo
dispositivos	          Contiene los dispositivos usados para validaciones (torniquetes, móviles, etc.).	                dispositivo_id, tipo, ubicacion
operaciones_realizadas	Registra operaciones realizadas por usuarios dentro del sistema (acciones, logs).	                id, usuario_id, operacion, detalle, fecha





