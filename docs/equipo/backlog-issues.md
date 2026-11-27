# Issues del backlog

Autora: Mariana García (gerente de planeación; tarea M5) · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador, pendiente de la capacidad por iteración

Fuente: [drivers.md](../drivers.md) (catálogo, matriz y orden del backlog, secciones 1 a 5) y [priorizacion.md](../priorizacion.md). Los ID (CU, RN, OB, RT, S, PA, EAC) son los de `vision.md` y `drivers.md`. Este documento es el texto de cada issue; **aún no se crearon en GitHub**.

## 1. Qué lleva issue

A cada elemento de los drivers se le aplicaron tres preguntas: ¿es un caso de uso?, ¿lo cubre un escenario o tarea de alguna spec?, ¿exige construir algo? Si no exige construir nada, es restricción y no lleva issue.

| Elemento | ¿Es CU? | ¿Lo cubre una spec o tarea? | ¿Exige construir? | Resultado |
|---|---|---|---|---|
| CU-01 a CU-12 | Sí | Planeadas: CU-01, 03, 05, 06, 07. Las otras, sin especificar | Sí | **Un issue por CU** (sección 3) |
| RT-01, PA-01 (estilo hexagonal) | No | No | Sí: estructura y puertos | **TEC-01** |
| RT-05, PA-04 (cambio por configuración) | No | No | Sí: raíz de composición y `.env` | **TEC-02** |
| RT-04 (el tiempo es un puerto) | No | No | Sí: puerto y dos relojes | **TEC-03** |
| RT-03 (persistencia relacional) | No | No | Sí: adaptador de PostgreSQL | **TEC-04** |
| RT-06, PA-06 (interfaz web y API) | No | No | Sí: esqueleto de la API y del frontend | **TEC-05** y **TEC-06** |
| RT-11 (script de demostración) | No | No | Sí | **TEC-07** |
| RT-11 (README) y RT-07, RT-08, RT-09 (ADR, `AGENTS.md`, tablero) | No | Sí: tareas B8, ADR, S6 y tablero del plan de la semana 0 | No: son documentos y proceso | Sin issue |
| RT-02, RT-10 y Clean Code/SOLID de RT-11 | No | Los vigila la lista de verificación de PR | No | Restricción, sin issue |
| EAC-01 a EAC-07 | No | Sí: los valida la spec del CU de su traza | No por sí solos | Sin issue propio: se citan en el CU |
| PA-02, PA-03, PA-05, PA-07, PA-08, PA-09 | No | Sí: se construyen en un CU (ver cada issue) | No por sí solos | Sin issue propio |
| Cuadrante 4: sistemas reales y prueba de carga | No | No | No: fuera de alcance (S-06, S-02) | Restricción, sin issue |

## 2. Issues técnicos

Responsable propuesto: según el área técnica de [roles.md](roles.md) (sección 5). Las horas no se estiman aquí: en `drivers.md` toda la base transversal suma 4 h y la reestimación es la decisión DP-07 de `priorizacion.md`.

### TEC-01 Estructura hexagonal y puertos base

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero crear la estructura de `src/backend/` (núcleo con dominio, casos de uso y puertos; adaptadores de entrada y de salida) y el esqueleto de los puertos, para que ningún archivo del núcleo importe un adaptador y el resto de los issues tenga dónde construirse.
- **Origen:** `drivers.md`: RT-01, RT-02, PA-01; [ADR-001](../adr/ADR-001-estilo-arquitectonico.md) (pendiente).
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde la vista de desarrollo y el ADR-001; la verificación del [checklist](checklist-revision.md) (grupo 1) devuelve vacío.
- **Responsable propuesto:** Sergio Velásquez (núcleo).

### TEC-02 Configuración de adaptadores por `.env` y raíz de composición

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero una raíz de composición que lea el `.env` y construya la pasarela, la mensajería, el SIA y el reloj elegidos, para cambiar de proveedor sin editar código ni tocar el núcleo.
- **Origen:** `drivers.md`: RT-05, PA-04, EAC-01, EAC-02; OB-03.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el ADR de configuración [NECESITA ACLARACIÓN: ¿qué ADR decide los nombres de las variables del `.env`? `drivers.md` no lo asigna]. Debe fijar qué pasa si falta una variable (PA-04).
- **Responsable propuesto:** Bairon Vásquez (adaptadores y `.env`).

### TEC-03 Puerto Reloj con reloj del sistema y reloj controlable

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero el puerto Reloj con dos adaptadores (sistema y controlable) elegibles por `.env`, para que ningún caso de uso lea la hora del sistema y se pueda demostrar el vencimiento y el cierre de la venta sin esperar.
- **Origen:** `drivers.md`: RT-04, EAC-04, S-14 (hora de America/Bogota).
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el plan del puerto; punto de partida: EAC-04 (reserva vigente en t0 + 9:59, vencida en t0 + 10:00, propuesta del equipo).
- **Responsable propuesto:** Bairon Vásquez (adaptadores de reloj; el puerto lo revisa Sergio por las reglas de tiempo).

### TEC-04 Persistencia en PostgreSQL con docker-compose, SQLAlchemy y Alembic

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero el adaptador de persistencia sobre PostgreSQL, con docker-compose, migraciones de Alembic y manejo de transacciones, para guardar los datos del sistema sin que el núcleo conozca SQL.
- **Origen:** `drivers.md`: RT-03, PA-02; [ADR-004](../adr/ADR-004-base-de-datos.md) y el ADR de persistencia (pendiente).
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el ADR de persistencia [NECESITA ACLARACIÓN: ¿qué número tiene ese ADR? Ver la nota al final de la sección 4 de `drivers.md`]. SQLAlchemy y Alembic solo en este adaptador.
- **Responsable propuesto:** Mariana García (persistencia en PostgreSQL).

### TEC-05 Esqueleto de la API REST

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero el esqueleto del adaptador de entrada FastAPI, con documentación OpenAPI, traducción de excepciones de dominio a códigos HTTP y CORS por `.env`, para que Angular consuma un contrato estable y los errores del núcleo lleguen legibles.
- **Origen:** `drivers.md`: RT-06, PA-06; [ADR-002](../adr/ADR-002-backend.md); [estándares](estandares.md) (secciones 5 y 6).
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el ADR-002 y los estándares; debe definir el formato de los errores de negocio y cómo se entrega la imagen QR (PA-06).
- **Responsable propuesto:** Mariana García (API; `roles.md` solo asigna "API de administración" [NECESITA ACLARACIÓN: ¿quién construye la parte de la API del comprador?]).

### TEC-06 Esqueleto de Angular con `admin/` y `comprador/`

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero el proyecto Angular con las dos rutas raíz (`admin/` y `comprador/`) y el cliente de la API, para tener las pantallas de administración y de usuario sobre el mismo núcleo sin reglas de negocio en el frontend.
- **Origen:** `drivers.md`: RT-06, PA-06; [ADR-003](../adr/ADR-003-frontend.md).
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el ADR-003; el frontend solo habla con el backend por la API REST.
- **Responsable propuesto:** Bairon Vásquez (frontend Angular).

### TEC-07 Script de datos de demostración

- **Etiquetas:** técnico · sin cuadrante (—)
- **Cuerpo:** Como equipo de desarrollo quiero un script que cargue un organizador, eventos con localidades, compradores de prueba y, en el SIA simulado, estudiantes y egresados, para demostrar el sistema desde cero.
- **Origen:** `drivers.md`: RT-11; S-03, S-06; enunciado.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** se completan desde el enunciado; el script crece con cada caso de uso (el SIA simulado llega con CU-06).
- **Responsable propuesto:** Bairon Vásquez (gerente de soporte: script de datos de demostración).

## 3. Issues de casos de uso

Los criterios de aceptación de cada caso de uso se completan desde su `spec.md`. Cuando aún no existe, queda "pendiente: la spec no existe". La línea **Referencias** son los RN, EAC y PA de `drivers.md` que debe cubrir la spec.

### CU-01 Registrar evento en borrador con sus localidades

- **Etiquetas:** caso de uso · cuadrante 2
- **Cuerpo:** Como organizador quiero registrar un evento en borrador con sus localidades (aforo y precio en COP), para tener los eventos sobre los que luego se publica, se reserva y se paga.
- **Origen:** `drivers.md`. **Referencias:** RN-01, RN-02.
- **Especificación:** `specs/001-registrar-evento` (planeado).
- **Criterios de aceptación:** se completan desde `spec.md`.
- **Responsable propuesto:** Mariana García (persistencia y API de administración).

### CU-02 Editar evento en borrador

- **Etiquetas:** caso de uso · cuadrante 3
- **Cuerpo:** Como organizador quiero editar un evento mientras está en borrador, para corregirlo antes de publicarlo.
- **Origen:** `drivers.md`. **Referencias:** RN-02, S-08.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe.
- **Responsable propuesto:** Mariana García.

### CU-03 Publicar evento

- **Etiquetas:** caso de uso · cuadrante 2
- **Cuerpo:** Como organizador quiero publicar un evento, para que aparezca en la cartelera y admita reservas.
- **Origen:** `drivers.md`. **Referencias:** RN-02 (publicado, sus localidades no se modifican).
- **Especificación:** `specs/003-publicar-evento` (planeado).
- **Criterios de aceptación:** se completan desde `spec.md`.
- **Responsable propuesto:** Mariana García.

### CU-04 Cancelar evento

- **Etiquetas:** caso de uso · cuadrante 1 · primario
- **Cuerpo:** Como organizador quiero cancelar un evento, para proteger al comprador cuando no se realiza: sale de la cartelera, se anulan las reservas vigentes, se reembolsan las boletas pagadas y se notifica a cada comprador.
- **Origen:** `drivers.md`. **Referencias:** RN-10, S-11; EAC-01, EAC-02.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe.
- **Responsable propuesto:** Mariana García (administración; el reembolso usa los adaptadores de Bairon).

### CU-05 Consultar cartelera

- **Etiquetas:** caso de uso · cuadrante 2
- **Cuerpo:** Como comprador quiero consultar la cartelera, para elegir un evento publicado y no cancelado y ver el cupo disponible por localidad.
- **Origen:** `drivers.md`. **Referencias:** RN-02, RN-03.
- **Especificación:** `specs/005-consultar-cartelera` (planeado).
- **Criterios de aceptación:** se completan desde `spec.md`.
- **Responsable propuesto:** Bairon Vásquez (frontend).

### CU-06 Reservar boletas

- **Etiquetas:** caso de uso · cuadrante 1 · primario
- **Cuerpo:** Como comprador (que usa el SIA) quiero reservar de 1 a 4 boletas de una localidad, para apartar mi cupo con la tarifa que me corresponde sin que se supere el aforo.
- **Origen:** `drivers.md`. **Referencias:** RN-03, RN-04, RN-05, RN-09, RN-11, S-05, S-10; EAC-03, EAC-04, EAC-06; PA-02, PA-05.
- **Especificación:** `specs/006-reservar-boletas` (planeado).
- **Criterios de aceptación:** se completan desde `spec.md`.
- **Responsable propuesto:** Sergio Velásquez (núcleo y reglas de tiempo). El adaptador del SIA lo construye Bairon.

### CU-07 Pagar reserva

- **Etiquetas:** caso de uso · cuadrante 1 · primario
- **Cuerpo:** Como comprador (que usa la pasarela) quiero pagar mi reserva, para completar la compra con un resultado aprobado, rechazado o pendiente.
- **Origen:** `drivers.md`. **Referencias:** RN-06, RN-11; EAC-01, EAC-04, EAC-05; PA-03.
- **Especificación:** `specs/007-pagar-reserva` (planeado).
- **Criterios de aceptación:** se completan desde `spec.md`. La demostración de EAC-01 exige dos pasarelas implementadas (OB-03, v0.1).
- **Responsable propuesto:** Bairon Vásquez (adaptadores de pasarela).

### CU-08 Emitir y enviar boletas con QR

- **Etiquetas:** caso de uso · cuadrante 2 · primario
- **Cuerpo:** Como sistema, al confirmarse el pago (usa la mensajería), quiero emitir una boleta por cupo con código único, aleatorio y no consecutivo, y su QR, y enviarlas, para que el comprador las reciba por notificación.
- **Origen:** `drivers.md`. **Referencias:** RN-08; EAC-02, EAC-07; PA-09.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe.
- **Responsable propuesto:** Bairon Vásquez (adaptador de mensajería).

### CU-09 Vencer reservas sin pago confirmado

- **Etiquetas:** caso de uso · cuadrante 1 · primario
- **Cuerpo:** Como sistema, por el reloj, quiero vencer las reservas sin pago confirmado a los 10 minutos, para liberar el cupo a tiempo.
- **Origen:** `drivers.md`. **Referencias:** RN-03, RN-05; EAC-04; PA-07; OB-04.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe.
- **Responsable propuesto:** Sergio Velásquez (reglas de tiempo).

### CU-10 Procesar la confirmación de la pasarela

- **Etiquetas:** caso de uso · cuadrante 1 · primario
- **Cuerpo:** Como pasarela de pago quiero que se procese mi confirmación, incluida la tardía, para que el comprador reciba sus boletas o su reembolso automático.
- **Origen:** `drivers.md`. **Referencias:** RN-06, RN-07, RN-11, S-11, S-12; EAC-01, EAC-03, EAC-05; PA-03.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe. Casos de EAC-05: con cupo, sin cupo, tras la hora de inicio, evento cancelado y más de 4 boletas.
- **Responsable propuesto:** Sergio Velásquez (núcleo y reglas de tiempo).

### CU-11 Consultar el estado de la reserva y del pago

- **Etiquetas:** caso de uso · cuadrante 3
- **Cuerpo:** Como comprador quiero consultar el estado de mi reserva y de mi pago, para esperar la respuesta de un pago pendiente.
- **Origen:** `drivers.md`. **Referencias:** RN-06.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe.
- **Responsable propuesto:** Bairon Vásquez (frontend).

### CU-12 Acceder a la parte de administración

- **Etiquetas:** caso de uso · cuadrante 3
- **Cuerpo:** Como organizador quiero acceder a la parte de administración, para que no cualquiera pueda publicar o cancelar eventos.
- **Origen:** `drivers.md`. **Referencias:** S-03, PA-08.
- **Especificación:** sin especificar.
- **Criterios de aceptación:** pendiente: la spec no existe. El mecanismo se decide en un ADR [NECESITA ACLARACIÓN: ¿en qué ADR se decide el acceso del organizador (PA-08)? `drivers.md` ya lo pregunta].
- **Responsable propuesto:** Mariana García (API de administración).

## 4. Orden del backlog

Regla de orden: la de `drivers.md` 5.4 (primero las dependencias; luego lo que completa el flujo de punta a punta; luego lo más difícil). Los TEC salen de la "base transversal" y van primero. La iteración es propuesta y depende de la capacidad por iteración (DP-01, pendiente).

| Posición | ID | Cuadrante | Depende de | Iteración propuesta |
|---|---|---|---|---|
| 1 | TEC-01 Estructura hexagonal y puertos base | — | ADR-001 | 1 |
| 2 | TEC-02 Configuración por `.env` y raíz de composición | — | TEC-01 | 1 |
| 3 | TEC-03 Puerto Reloj | — | TEC-01 | 1 |
| 4 | TEC-04 Persistencia en PostgreSQL | — | TEC-01, ADR-004 | 1 |
| 5 | TEC-05 Esqueleto de la API REST | — | TEC-01, TEC-02 | 1 |
| 6 | TEC-06 Esqueleto de Angular | — | TEC-05 | 1 |
| 7 | CU-01 Registrar evento | 2 | TEC-04, TEC-05, TEC-06 | 1 |
| 8 | TEC-07 Script de datos de demostración | — | TEC-04, CU-01 | 1 |
| 9 | CU-03 Publicar evento | 2 | CU-01 | 1 |
| 10 | CU-05 Consultar cartelera | 2 | CU-03, TEC-03 | 1 |
| 11 | CU-06 Reservar boletas | 1 | CU-05 | 1 |
| 12 | CU-07 Pagar reserva (dos pasarelas) | 1 | CU-06, TEC-02 | 1 |
| 13 | CU-08 Emitir y enviar boletas | 2 | CU-07 | 2 |
| 14 | CU-09 Vencer reservas | 1 | CU-06 | 2 |
| 15 | CU-10 Procesar confirmación | 1 | CU-07, CU-09 | 2 |
| 16 | CU-04 Cancelar evento | 1 | CU-08, CU-10 | 2 |
| 17 | CU-12 Acceso del organizador | 3 | CU-01 | 2 |
| 18 | CU-11 Estado de la reserva | 3 | CU-07 | 2 |
| 19 | CU-02 Editar borrador | 3 | CU-01 | Fuera |

Notas:

- Las dependencias de los CU y las iteraciones son las de `drivers.md` 5.4. Las de los TEC son mías: salen de qué necesita cada uno y deben revisarse con Sergio.
- **TEC-07 va después de CU-01** porque el script necesita las entidades del evento. `drivers.md` lo incluye en la base; con esta ubicación no es un bloqueo para CU-01.
- **Horas:** la base transversal de 4 h queda ahora repartida en siete issues. Es la razón por la que DP-07 la considera corta. Las horas de cada TEC se estiman en la capacidad y sub-issues (M8).
- **Carga:** el responsable propuesto sale solo del área de `roles.md`; no balancea la carga. Bairon queda con la mayor parte de los TEC y de los CU de adaptadores y frontend. Se ajusta en M8.
- **CU-09 antes que CU-08** puede convenir si la iteración 1 deja horas (decisión DP-03, pendiente).
- Los issues recortados por capacidad no se borran: quedan en el tablero y como deuda técnica aceptada (DP-05).

## 5. Preguntas abiertas

1. [NECESITA ACLARACIÓN: ¿la pantalla de cada caso de uso se especifica y se construye dentro de su `spec.md`, o hay un issue de frontend por separado? Aquí se asumió lo primero, y TEC-06 solo cubre el esqueleto.]
2. [NECESITA ACLARACIÓN: ¿los issues técnicos (TEC) llevan carpeta `specs/` con los cuatro archivos de SDD, o solo tareas? RT-08 habla de cuatro archivos por caso de uso.]
