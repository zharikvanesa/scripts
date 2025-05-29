#  Taller Final - Programación de Bases de Datos
##  Descripción general

Este proyecto consiste en la mejora e implementación de nuevas funcionalidades en un sistema de viajes y recargas de tarjetas de transporte. Las mejoras tienen como objetivo optimizar la trazabilidad, auditoría, análisis comercial y el control de operaciones del sistema. Las funcionalidades implementadas son:

1. **Auditoría del estado de las tarjetas**: se registra cada cambio de estado (por ejemplo: activa, bloqueada, cancelada) para controlar la vida útil de las tarjetas y detectar modificaciones indebidas.
2. **Promociones aplicadas en recargas**: permite almacenar y consultar promociones (bonos o descuentos) asociadas a recargas.
3. **Registro de dispositivos de validación**: cada viaje puede ahora registrar el dispositivo que validó el acceso (torniquete, móvil, etc.).
4. **Mejora adicional – Registro de operaciones del sistema**: se documentan acciones relevantes realizadas por los usuarios, como cambios de información personal o movimientos anómalos.

---

## ⚙️ Instrucciones para ejecutar los scripts

Todos los scripts se encuentran en la carpeta `scripts/`, y deben ejecutarse en el siguiente orden:

1. `01_modificaciones.sql`  
   ➤ Contiene alteraciones a las tablas ya existentes (ej. recargas y viajes).

2. `02_nuevas_tablas.sql`  
   ➤ Crea las nuevas tablas necesarias: `historial_estado`, `promocion`, `dispositivos`, `operaciones_realizadas`.

3. `03_datos.sql`  
   ➤ Inserta datos de ejemplo para permitir validaciones (mínimo 100 registros).

4. `04_consultas.sql`  
   ➤ Incluye todas las consultas solicitadas por el taller.

---
## Resumen de tablas nuevas y modificadas

| Tabla                    | Propósito                                                      | Campos clave                       |
| ------------------------ | -------------------------------------------------------------- | ---------------------------------- |
| `historial_estado`       | Registrar el historial de estados de cada tarjeta              | historial\_estado\_id, tarjeta\_id |
| `promocion`              | Contiene promociones aplicadas a recargas                      | id\_promocion                      |
| `dispositivos`           | Registra los dispositivos utilizados para validar viajes       | dispositivo\_id                    |
| `operaciones_realizadas` | Guarda eventos importantes ejecutados por usuarios del sistema | operaciones\_id, usuario\_id       |
| `recargas` (modificada)  | Se añadió `id_promocion` como FK hacia `promocion`             | recarga\_id                        |
| `viajes` (modificada)    | Se añadió `dispositivo_id` como FK hacia `dispositivos`        | viaje\_id                          |

---
## Consultas desarrolladas

1.Cantidad de cambios de estado por mes en el último año

2.Top 5 tarjetas con mayor número de cambios de estado

3.Recargas con descripción de la promoción aplicada

4.Monto total recargado por tipo de promoción en los últimos 3 meses

5.Promociones cuyo nombre contenga la palabra “bonus”

6.Viajes sin registro de validación

7.Validaciones realizadas por dispositivos móviles en abril de 2025

8.Dispositivo con mayor número de validaciones

9.[Mejora adicional] Operaciones realizadas por cada usuario

10.[Mejora adicional] Número de operaciones del tipo "bloqueo" por día

11.[Mejora adicional] Usuarios que realizaron más de 3 operaciones en una semana

---

## Tipo de datos insertados
-Se generaron más de 100 registros de prueba distribuidos entre las siguientes entidades:

-Cambios de estado (activa, bloqueada, suspendida, cancelada) en distintas fechas.

-Recargas con y sin promociones aplicadas (bonos y descuentos).

-Promociones con distintos periodos de validez y nombres variados (incluyendo "bonus").

-Dispositivos de validación (torniquetes, móviles, etc.).

-Viajes realizados, algunos sin validación de dispositivo.

-Registros de operaciones realizadas por usuarios del sistema (auditoría interna).

---

## Diagrama relacional

```mermaid
erDiagram
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
        int id_promocion FK
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
        int dispositivo_id FK
    }

    HISTORIAL_ESTADO {
        int historial_estado_id PK
        int tarjeta_id FK
        string estado
        date fecha_cambio
    }

    PROMOCION {
        int id_promocion PK
        string nombre
        text descripcion
        date fecha_inicio
        date fecha_fin
        int tarjetas FK
    }

    DISPOSITIVOS {
        int dispositivo_id PK
        string tipo_dispositivo
        int dispositivos FK
    }

    OPERACIONES_REALIZADAS {
        int operaciones_id PK
        int usuario_id FK
        string operacion
        text detalle
        timestamp fecha
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
    PROMOCION ||--o{ RECARGAS : ""
    TARJETAS ||--o{ PROMOCION : ""
    DISPOSITIVOS ||--o{ VIAJES : ""
    DISPOSITIVOS ||--o{ DISPOSITIVOS : ""
    USUARIOS ||--o{ OPERACIONES_REALIZADAS : ""



