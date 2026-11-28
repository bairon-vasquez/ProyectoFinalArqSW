# Documento de arquitectura: sistema de boletería para los eventos culturales de la universidad

- Versión: 0.1 | Estado: en construcción | Fecha: 27/11/2026 | Autor: Sergio Velásquez (gerente de desarrollo)

Adaptación de arc42. Este documento **enlaza** los artefactos de arquitectura y no copia su contenido: si algo cambia, se cambia en su documento de origen. Lo que vive solo aquí es la estrategia de solución (sección 4), los conceptos transversales (6), la deuda técnica (9) y el glosario (10).

## 1. Introducción y objetivos

La universidad vende hoy las boletas de sus conciertos, obras de teatro y conferencias en efectivo, en taquilla y con listas impresas, lo que produce filas y sobreventa. El sistema vende en línea, cobra por medios electrónicos y controla el cupo. La pasarela de pago y el servicio de mensajería pueden cambiar sin modificar el dominio ni los casos de uso.

- Problema, objetivos de negocio (OB-01 a OB-05), alcance y stakeholders: [vision.md](vision.md).
- Casos de uso y reglas de negocio: [drivers.md, sección 1](drivers.md#1-casos-de-uso).
- Objetivos de calidad: sección 8 de este documento.

## 2. Restricciones

Las restricciones RT-01 a RT-11 son de origen docente y no se negocian. Están con su tipo e impacto en [drivers.md, sección 3](drivers.md#3-restricciones) y con su texto original en [vision.md, sección 5](vision.md#5-restricciones).

## 3. Contexto

Comprador, organizador, pasarela de pago, SIA y servicio de mensajería, con lo que se intercambia con cada uno: [contexto.md](contexto.md).

## 4. Estrategia de solución

| Driver | Enfoque | ADR |
|---|---|---|
| OB-03, RT-01, RT-02, PA-01 | Arquitectura hexagonal: núcleo (dominio, casos de uso, puertos) rodeado de adaptadores de entrada y de salida, con una sola frontera verificable | [ADR-001](adr/ADR-001-estilo-arquitectonico.md) |
| RT-02, RT-06, RT-07 | Backend en Python 3.12 + FastAPI como API REST con OpenAPI; FastAPI y Pydantic solo en el adaptador de entrada | [ADR-002](adr/ADR-002-backend.md) |
| RT-06, RT-02 | Frontend Angular como SPA aparte, con `admin/` y `comprador/`; sin reglas de negocio | [ADR-003](adr/ADR-003-frontend.md) |
| RT-03, OB-01, EAC-03 | PostgreSQL con docker-compose; SQLAlchemy y Alembic solo en el adaptador de persistencia, detrás de repositorios | [ADR-004](adr/ADR-004-base-de-datos.md), [ADR-006](adr/ADR-006-persistencia.md) |
| OB-03, RT-05, EAC-01, EAC-02, PA-03, PA-04 | Un puerto por sistema externo (`PasarelaPago`, `ServicioMensajeria`, `ConsultaSIA`) con un adaptador por proveedor, elegido por el `.env` en `arranque.py` | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md) |
| RT-04, OB-04, EAC-04 | Puerto `Reloj` con `RelojSistema` y `RelojControlable`, elegido por la variable `RELOJ` | [ADR-007](adr/ADR-007-reloj-como-puerto.md) |

## 5. Vistas

Vistas 4+1:

| Vista | Documento | Estado |
|---|---|---|
| Lógica | [vistas/01-logica.md](vistas/01-logica.md): modelo de dominio, estados y reglas por entidad | Disponible |
| Procesos | `vistas/02-procesos.md` | Pendiente Iteración 1 |
| Desarrollo | [vistas/03-desarrollo.md](vistas/03-desarrollo.md): árbol de `src/`, componentes, puertos, adaptadores y regla de dependencia | Disponible |
| Física | `vistas/04-fisica.md` | Pendiente Iteración 1 |
| Escenarios (+1) | Casos de uso en [drivers.md, sección 1](drivers.md#1-casos-de-uso); diagramas de secuencia de los casos de uso primarios | Secuencias pendientes Iteración 1 |

## 6. Conceptos transversales

| Concepto | Cómo se resuelve | Dónde se ve |
|---|---|---|
| Configuración de adaptadores | `arranque.py` lee `PASARELA_PAGO`, `MENSAJERIA`, `SIA`, `RELOJ` y `DATABASE_URL` del `.env` y conecta cada puerto con su adaptador. Si una variable falta o tiene un valor inválido, el backend no arranca. Cambiar de adaptador no edita código | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md), [ADR-007](adr/ADR-007-reloj-como-puerto.md), [.env.example](../.env.example), [README](../README.md#configuración-de-adaptadores), [vista de desarrollo, sección 3](vistas/03-desarrollo.md#3-catálogo-de-elementos) |
| Manejo de errores de integración | `ResultadoPago` con estados aprobado, rechazado y pendiente. La confirmación posterior llega por un endpoint de notificación y es idempotente. El reembolso se pide sobre la referencia del pago. Sin respuesta del SIA se aplica la tarifa general con aviso (S-05). El núcleo lanza excepciones de dominio y la API las traduce a HTTP en un solo lugar | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md), [ADR-006](adr/ADR-006-persistencia.md) (doble pago), [estandares.md, sección 5](equipo/estandares.md#5-manejo-de-errores) |
| Concurrencia del cupo | Transacción corta: se bloquea la fila de la localidad (`SELECT ... FOR UPDATE`) y luego se calcula el cupo. Orden fijo de bloqueos: comprador → localidad → reserva → pago. La base respalda con `CHECK` y con índices únicos | [ADR-006](adr/ADR-006-persistencia.md), [vista lógica, sección 4](vistas/01-logica.md#4-reglas-de-negocio-por-entidad), EAC-03 |
| Tiempo | Toda regla que depende de la hora (vencimiento, cierre de la venta, confirmación tardía) la recibe del puerto `Reloj`, en America/Bogota. El núcleo nunca lee la hora del sistema y la base nunca decide vigencias | [ADR-007](adr/ADR-007-reloj-como-puerto.md), [vista de desarrollo, regla D2](vistas/03-desarrollo.md#4-regla-de-dependencia-verificable), EAC-04 |

## 7. Decisiones

| ADR | Decisión | Estado | Drivers |
|---|---|---|---|
| [ADR-001](adr/ADR-001-estilo-arquitectonico.md) | Arquitectura hexagonal | Propuesto (se acepta tras la clase de arquitectura hexagonal) | OB-03, RT-01, RT-02, RT-10, RT-08, EAC-01, EAC-02 |
| [ADR-002](adr/ADR-002-backend.md) | Python 3.12 + FastAPI | Aceptado | RT-02, RT-05, RT-06, RT-07, OB-01 |
| [ADR-003](adr/ADR-003-frontend.md) | Angular como SPA | Aceptado | RT-02, RT-06, RT-11 |
| [ADR-004](adr/ADR-004-base-de-datos.md) | PostgreSQL con docker-compose | Aceptado | RT-03, OB-01, RT-11 |
| [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md) | Puertos con un adaptador por proveedor, elegido por el `.env` | Aceptado | OB-03, RT-05, EAC-01, EAC-02, EAC-05, EAC-06 |
| [ADR-006](adr/ADR-006-persistencia.md) | SQLAlchemy 2 + Alembic detrás de repositorios; bloqueo de la localidad para el cupo | Aceptado | OB-01, RT-02, RT-03, EAC-03, EAC-05 |
| [ADR-007](adr/ADR-007-reloj-como-puerto.md) | Puerto Reloj con reloj del sistema y reloj controlable | Aceptado | RT-04, OB-04, EAC-04 |

[NECESITA ACLARACIÓN: ADR-002, ADR-004, ADR-006 y ADR-007 piden confirmar que Sergio aprobó su estado Aceptado, como exige `normas.md` para decisiones de arquitectura.]

## 8. Requisitos de calidad

Los escenarios completos, con sus seis partes y su medida, están en [drivers.md, sección 2](drivers.md#2-escenarios-de-atributos-de-calidad). La prioridad es una propuesta del equipo, a confirmar con el docente, y sigue los cuadrantes de [drivers.md, sección 5](drivers.md#5-matriz-de-priorización).

| EAC | Atributo (ISO/IEC 25010) | Prioridad | ADR | Se verifica en |
|---|---|---|---|---|
| EAC-01 | Mantenibilidad: modificabilidad (cambiar pasarela) | Alta | ADR-001, ADR-005 | `specs/007-pagar-reserva/validacion.md` |
| EAC-02 | Mantenibilidad: modificabilidad (cambiar mensajería) | Alta | ADR-001, ADR-005 | `specs/008-emitir-boletas/validacion.md` |
| EAC-03 | Adecuación funcional: corrección (integridad del cupo) | Alta | ADR-004, ADR-006 | `specs/006-reservar-boletas/validacion.md` |
| EAC-04 | Mantenibilidad: capacidad de ser probado (reloj controlable) | Alta | ADR-007 | `specs/009-vencer-reservas/validacion.md` y `specs/006-reservar-boletas/validacion.md` (cierre de la venta) |
| EAC-05 | Fiabilidad: tolerancia a fallos (pago pendiente, confirmación tardía) | Alta | ADR-005, ADR-006 | `specs/007-pagar-reserva/validacion.md` y `specs/010-procesar-confirmacion-pago/validacion.md` |
| EAC-06 | Compatibilidad: interoperabilidad (SIA no disponible) | Media | ADR-005 | `specs/006-reservar-boletas/validacion.md` |
| EAC-07 | Seguridad: integridad (códigos de boleta) | Media | ADR-006 | `specs/008-emitir-boletas/validacion.md` |

Ninguna carpeta de `specs/` existe todavía. Las de CU-06 y CU-07 se crean en la semana 0; las de CU-08, CU-09 y CU-10 aún no tienen especificación ([drivers.md, sección 1.2](drivers.md#12-catálogo)).

## 9. Riesgos y deuda técnica

Los riesgos de proyecto R-01 a R-09 están en [vision.md, sección 6](vision.md#riesgos). Aquí se registran los riesgos técnicos que surgen de los ADR y la deuda técnica aceptada.

| ID | Riesgo o deuda | Origen | Impacto | Respuesta |
|---|---|---|---|---|
| R-10 | Riesgo: lógica de negocio que se filtra a los adaptadores, por haber menos capas que en Clean Architecture | [ADR-001](adr/ADR-001-estilo-arquitectonico.md) | Una regla fuera del núcleo no se puede probar con el reloj controlable y rompe la coherencia de la documentación con el código | Toda regla vive en el núcleo; el revisor lo comprueba en cada pull request ([checklist](equipo/checklist-revision.md)) |
| R-11 | Riesgo: interbloqueo entre casos de uso que bloquean filas en distinto orden | [ADR-006](adr/ADR-006-persistencia.md) | La base aborta una transacción y el usuario recibe un error; nunca hay sobreventa | Orden fijo de bloqueos: comprador → localidad → reserva → pago |
| R-12 | Riesgo: `RelojControlable` activo por error fuera de la demostración | [ADR-007](adr/ADR-007-reloj-como-puerto.md) | Cualquiera podría adelantar el tiempo y vencer reservas o cerrar la venta | El control solo existe con `RELOJ=controlable`; el README lo documenta como exclusivo de la demostración |
| R-13 | Riesgo: el endpoint de notificaciones de pago no valida el origen | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md) | Una notificación falsa podría confirmar un pago | Aceptado con los simulados (S-06); con una pasarela real, la validación iría en su adaptador |
| DT-01 | Deuda: no está definido qué hacer si la pasarela rechaza un reembolso | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md) | El comprador no recibe su dinero y el sistema no lo detecta | Los simulados siempre aprueban el reembolso. [NECESITA ACLARACIÓN: ¿qué debe pasar si la pasarela rechaza un reembolso?] |
| DT-02 | Deuda: un pago queda `INICIADO` sin resultado si el proceso cae entre las dos transacciones | [ADR-006](adr/ADR-006-persistencia.md) | La reserva no puede volver a pagarse; no hay cobro doble | Se registra y no se resuelve automáticamente. [NECESITA ACLARACIÓN: ¿qué pasa con un pago `INICIADO` sin resultado cuando la reserva vence?] |
| DT-03 | Deuda: integrar un proveedor nuevo edita una línea de `arranque.py` | [ADR-005](adr/ADR-005-integracion-pasarelas-mensajeria.md) | No es configuración pura, aunque no toca el núcleo | Aceptado: el enunciado permite agregar adaptadores; alternativa de carga por nombre en el punto 4 de "Qué confirmar" del ADR-005 |
| DT-04 | Deuda: las reservas de una misma localidad se procesan una tras otra por el bloqueo, sin prueba con volumen real | [ADR-006](adr/ADR-006-persistencia.md), S-01, S-02 | Con mucha demanda en una sola localidad, las reservas esperan | Aceptado para el volumen de demostración |
| DT-05 | Deuda: casos de uso que no se construyan en las dos iteraciones | [priorizacion.md](priorizacion.md) (DP-05) | Reglas del enunciado sin implementar | Se listan aquí al cierre de la iteración 2, con su issue en el tablero |

## 10. Glosario

Un mismo concepto tiene el mismo nombre en documentación, código, base de datos, API y pantallas ([estandares.md, sección 3](equipo/estandares.md#3-nombres)). Los nombres en el código vienen de la [vista lógica](vistas/01-logica.md) y la [vista de desarrollo](vistas/03-desarrollo.md).

| Término | Definición | Nombre en el código |
|---|---|---|
| Evento | Concierto, obra de teatro o conferencia, con nombre, fecha, hora de inicio, lugar y localidades | `Evento` |
| Borrador / publicado / cancelado | Estados del evento; solo el publicado aparece en la cartelera | `EstadoEvento.BORRADOR`, `PUBLICADO`, `CANCELADO` |
| Localidad | Zona del escenario con aforo y precio propios en COP | `Localidad` |
| Aforo | Número máximo de boletas de una localidad | `Localidad.aforo` |
| Cupo disponible | Aforo menos boletas pagadas menos boletas en reservas vigentes | `Localidad.cupo_disponible()` |
| Cartelera | Lista de eventos publicados con su cupo | `ConsultarCartelera` |
| Comprador | Persona que compra; se identifica con documento, correo y celular, sin contraseña | `Comprador` |
| Tipo de público | Estudiante, egresado, ambos o ninguno, según el SIA | `TipoPublico` |
| Organizador | Persona que registra, publica y cancela eventos | Rol de la parte `admin/`; acceso por `AccederAdministracion` |
| Reserva | Apartado de 1 a 4 boletas de una localidad durante 10 minutos | `Reserva` |
| Reserva vigente | Reserva sin pago confirmado cuyo plazo no ha vencido según el Reloj | `Reserva.esta_vigente(ahora)` |
| Vencimiento | Fin del plazo de 10 minutos; libera el cupo | `Reserva.vence_en`, `VencerReservas` |
| Pago | Intento de pago de una reserva en la pasarela, con su resultado | `Pago`, `ResultadoPago` |
| Pago pendiente | La pasarela aún no responde si aprueba o rechaza; bloquea un nuevo intento | `EstadoPago.PENDIENTE` |
| Pago activo | Pago iniciado, pendiente o aprobado; impide otro pago de la misma reserva | `Pago.esta_activo()` |
| Confirmación tardía | Confirmación de un pago que llega con la reserva ya vencida | `ProcesarConfirmacionPago` |
| Reembolso | Devolución por el mismo medio de pago | `PasarelaPago.reembolsar()`, `EstadoPago.REEMBOLSADO` |
| Boleta | Comprobante de un cupo pagado, con código y QR | `Boleta` |
| Código de boleta | Identificador único, aleatorio y no consecutivo | `Boleta.codigo` |
| Imagen QR | Imagen generada a partir del código de la boleta | `GeneradorQR` |
| Cierre de la venta | Desde la hora de inicio no se aceptan reservas ni pagos | `Evento.venta_abierta(ahora)` |
| Notificación | Mensaje al comprador: boletas con QR, aviso de reembolso o de cancelación | `Notificacion`, `ServicioMensajeria` |
| Núcleo | Dominio y casos de uso, con sus puertos | `src/backend/nucleo/` |
| Puerto | Interfaz del núcleo con lo que ofrece (casos de uso) o lo que necesita del exterior | `src/backend/nucleo/puertos/`, `src/backend/nucleo/casos_uso/` |
| Adaptador | Componente fuera del núcleo que implementa o usa un puerto | `src/backend/adaptadores/` |
| Simulado | Adaptador que imita un sistema externo sin conectarse a él | `PasarelaSimuladaA`, `PasarelaSimuladaB`, `MensajeriaConsola`, `MensajeriaArchivo`, `SIASimulado` |
| Configuración | Variables del `.env` que eligen los adaptadores al arrancar | `.env`, `arranque.py` |
| Raíz de composición | Punto que conecta cada puerto con su adaptador | `src/backend/arranque.py` |
| Reloj controlable | Adaptador del Reloj que se puede adelantar en la demostración | `RelojControlable` |
| Unidad de trabajo | Frontera de una transacción en la base de datos | `UnidadDeTrabajo` |
