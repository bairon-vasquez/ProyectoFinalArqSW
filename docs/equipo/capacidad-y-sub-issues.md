# Capacidad y sub-issues de la iteración 1

Autora: Mariana García (gerente de planeación; tarea M8) · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión

Fuentes: los `tasks.md` de [CU-01](../../specs/001-registrar-evento/tasks.md), [CU-03](../../specs/003-publicar-evento/tasks.md), [CU-05](../../specs/005-consultar-cartelera/tasks.md), [CU-06](../../specs/006-reservar-boletas/tasks.md) y [CU-07](../../specs/007-pagar-reserva/tasks.md); [drivers.md](../drivers.md) (sección 5.4) y [priorizacion.md](../priorizacion.md) (DP-01, DP-04, DP-07). Las estimaciones son las propuestas por cada autor; este documento no las cambia.

## 1. Capacidad

Horas disponibles esta semana: **7 h por persona** (21 h el equipo), dato dado por el equipo. Fórmula: (horas disponibles − 3 h de reuniones) × (1 − 20 % de imprevistos). Los imprevistos se calculan sobre lo que queda después de las reuniones.

| Persona | Disponibles | − Reuniones | Subtotal | − 20 % imprevistos | **Capacidad** |
|---|---|---|---|---|---|
| Bairon Vásquez | 7 h | 3 h | 4 h | 0,8 h | **3,2 h** |
| Sergio Velásquez | 7 h | 3 h | 4 h | 0,8 h | **3,2 h** |
| Mariana García | 7 h | 3 h | 4 h | 0,8 h | **3,2 h** |
| **Equipo** | 21 h | 9 h | 12 h | 2,4 h | **9,6 h** |

[NECESITA ACLARACIÓN: `normas.md` fija tres reuniones semanales (lunes, miércoles y viernes) de 7:00 pm a 9:00 pm, es decir 6 h, no 3 h. ¿Cuántas horas de reunión se descuentan? Con 6 h, la capacidad con 7 h disponibles sería de 0,8 h por persona.]

## 2. Sub-issues

Todos pertenecen a la iteración 1. **Ninguna tarea supera 4 h**, así que no hubo que dividir ninguna. T-06-05 está justo en el máximo; si se quiere margen, se propone dividirla en dos de 2 h (modelos y migración; repositorios con bloqueo y conteos), **marcada para revisión** de Sergio y Mariana.

Las tres tareas de la API del comprador (T-05-03, T-06-07 y T-07-06) no tenían responsable en los `tasks.md`, porque `roles.md` solo asigna la API de administración. Propongo a Mariana, que lleva la API, **marcado para revisión**.

| ID | Título | Issue padre | Estimación | Responsable | Iteración |
|---|---|---|---|---|---|
| T-01-01 | Dominio `Evento` y `Localidad`, excepción de validación y caso de uso `RegistrarEvento` | CU-01 | 1,5 h | Sergio Velásquez | 1 |
| T-01-02 | Persistencia de evento y localidad, con migración y unidad de trabajo | CU-01 | 2 h | Mariana García | 1 |
| T-01-03 | Endpoint de registro, esquemas y traducción de errores a HTTP | CU-01 | 1,5 h | Mariana García | 1 |
| T-01-04 | Formulario de registro en `admin/` con localidades dinámicas | CU-01 | 2 h | Bairon Vásquez | 1 |
| T-01-05 | Validar los escenarios de CU-01 | CU-01 | 1 h | Mariana García | 1 |
| T-03-01 | `Evento.publicar()`, excepciones y caso de uso `PublicarEvento` | CU-03 | 1 h | Sergio Velásquez | 1 |
| T-03-02 | Repositorio: obtener, guardar estado y listar borradores | CU-03 | 1 h | Mariana García | 1 |
| T-03-03 | Endpoints de publicación y de borradores, y errores a HTTP | CU-03 | 1 h | Mariana García | 1 |
| T-03-04 | Pantalla de borradores con la acción de publicar en `admin/` | CU-03 | 1,5 h | Bairon Vásquez | 1 |
| T-03-05 | Validar los escenarios de CU-03 | CU-03 | 1 h | Mariana García | 1 |
| T-05-01 | Caso de uso `ConsultarCartelera` con las reglas del dominio | CU-05 | 1,5 h | Sergio Velásquez | 1 |
| T-05-02 | Repositorios: eventos publicados y conteo de boletas por localidad | CU-05 | 2 h | Mariana García | 1 |
| T-05-03 | Endpoint de cartelera y esquemas de respuesta | CU-05 | 1 h | Mariana García (propuesta, para revisión) | 1 |
| T-05-04 | Pantalla de cartelera en `comprador/` | CU-05 | 2 h | Bairon Vásquez | 1 |
| T-05-05 | Validar los escenarios de CU-05 | CU-05 | 1 h | Bairon Vásquez | 1 |
| T-06-01 | Dominio: `Comprador`, `TipoPublico`, cupo disponible y venta abierta | CU-06 | 2 h | Sergio Velásquez | 1 |
| T-06-02 | Dominio: `Reserva` con cantidad, vencimiento, descuento y monto | CU-06 | 3 h | Sergio Velásquez | 1 |
| T-06-03 | Puerto `ConsultaSIA` y métodos de repositorio de la reserva | CU-06 | 1 h | Sergio Velásquez | 1 |
| T-06-04 | Caso de uso `ReservarBoletas` con bloqueos, máximo de 4 y cupo | CU-06 | 3 h | Sergio Velásquez | 1 |
| T-06-05 | Persistencia de comprador y reserva, con bloqueo y conteos | CU-06 | 4 h | Mariana García | 1 |
| T-06-06 | Adaptador `SIASimulado` | CU-06 | 2 h | Bairon Vásquez | 1 |
| T-06-07 | Endpoint de reserva y errores a HTTP | CU-06 | 2 h | Mariana García (propuesta, para revisión) | 1 |
| T-06-08 | Formulario de reserva en `comprador/` | CU-06 | 3 h | Bairon Vásquez | 1 |
| T-06-09 | Archivo del SIA simulado y compradores de prueba | CU-06 | 1 h | Bairon Vásquez | 1 |
| T-06-10 | Validar los escenarios de CU-06, incluida la concurrencia | CU-06 | 3 h | Sergio Velásquez | 1 |
| T-07-01 | Dominio: `Pago`, sus estados y `esta_activo()` | CU-07 | 1,5 h | Sergio Velásquez | 1 |
| T-07-02 | Caso de uso `PagarReserva` con dos transacciones | CU-07 | 3 h | Sergio Velásquez | 1 |
| T-07-03 | Persistencia del pago con el índice único parcial | CU-07 | 3 h | Mariana García | 1 |
| T-07-04 | Adaptador `PasarelaSimuladaA` | CU-07 | 2 h | Bairon Vásquez | 1 |
| T-07-05 | Adaptador `PasarelaSimuladaB` | CU-07 | 1,5 h | Bairon Vásquez | 1 |
| T-07-06 | Endpoint de pago y errores a HTTP | CU-07 | 2 h | Mariana García (propuesta, para revisión) | 1 |
| T-07-07 | Pantalla de pago en `comprador/` | CU-07 | 3 h | Bairon Vásquez | 1 |
| T-07-08 | Compradores de prueba y respuestas de A y B en el script de datos | CU-07 | 1 h | Bairon Vásquez | 1 |
| T-07-09 | Validar los escenarios de CU-07 | CU-07 | 2 h | Bairon Vásquez | 1 |

**34 sub-issues, 64 h.** Por caso de uso: CU-01 8 h, CU-03 5,5 h, CU-05 7,5 h, CU-06 24 h y CU-07 19 h.

Los siete issues técnicos TEC-01 a TEC-07 no tienen `tasks.md` y **no están incluidos**: `drivers.md` los agrupa en una base de 4 h que DP-07 considera corta. Con esas 4 h, la carga sube a 68 h.

## 3. Carga frente a la capacidad

| Persona | Carga (h) | Capacidad (h) | Diferencia (h) | Veces la capacidad |
|---|---|---|---|---|
| Sergio Velásquez | 20,5 | 3,2 | −17,3 | 6,4 |
| Bairon Vásquez | 22 | 3,2 | −18,8 | 6,9 |
| Mariana García (incluye 5 h de API del comprador) | 21,5 | 3,2 | −18,3 | 6,7 |
| **Equipo** | **64** | **9,6** | **−54,4** | **6,7** |

**La carga supera la capacidad en las tres personas y en el total.**

## 4. Qué ítem sale

Con las reglas dadas (nunca el núcleo, CU-06 ni CU-07), **no hay recorte que sea suficiente**:

- CU-06 y CU-07 suman 43 h, 4,5 veces la capacidad del equipo (9,6 h). Con esas dos intocables, ya se supera.
- CU-01, CU-03 y CU-05 son los únicos ítems que podrían salir, y por el orden del backlog saldría primero CU-05, luego CU-03 y luego CU-01. Pero CU-06 depende de CU-05, CU-05 de CU-03 y CU-03 de CU-01 ([drivers.md](../drivers.md), sección 5.4). Quitarlos deja sin evento publicado ni cartelera a CU-06 y CU-07.
- Aun quitando CU-01, CU-03 y CU-05 completos (21 h), quedan 43 h contra 9,6 h.
- Ni siquiera CU-01 solo cabe por persona: Mariana tiene 4,5 h en CU-01 y su capacidad es 3,2 h.

Por eso **no propongo sacar ningún ítem**: el problema es la capacidad, no el alcance. Las opciones son:

| Opción | Efecto |
|---|---|
| **A. Confirmar las horas disponibles.** Con 33 h por persona (el escenario alto de DP-01), la capacidad es (33 − 3) × 0,8 = 24 h por persona, 72 h el equipo. Las cargas caben: Sergio 20,5 h, Bairon 22 h, Mariana 21,5 h; el total queda en 64 h de 72 h, y en 68 h con la base de 4 h | Cabe, con 4 h de holgura en total y de 2 a 3,5 h por persona |
| **B. Horas necesarias con 3 h de reuniones.** Cada persona necesita disponibles: carga ÷ 0,8 + 3 h | Sergio 28,6 h, Bairon 30,5 h y Mariana 29,9 h |
| **C. Mantener 7 h por persona** | La iteración 1 no puede entregar el flujo completo. Hay que llevarlo al docente: es la pregunta 2 de [priorizacion.md](../priorizacion.md), sobre aceptar casos de uso sin construir y registrarlos como deuda técnica |
| **D. Reducir las estimaciones** | Los autores suman 64 h frente a las 29 h de CU-01, 03, 05, 06 y 07 en `drivers.md` (6 + 2 + 3 + 10 + 8). Aun llevándolas a las de `drivers.md`, 29 h siguen siendo 3 veces la capacidad |

## 5. Pendientes

1. [NECESITA ACLARACIÓN: ¿qué horas disponibles tiene cada persona? Se usaron 7 h por persona; si son otras, solo hay que reemplazar el dato de la sección 1.]
2. [NECESITA ACLARACIÓN: ¿se descuentan 3 h o 6 h de reuniones? Ver la sección 1.]
3. [NECESITA ACLARACIÓN: ¿quién construye la API del comprador? Se propuso a Mariana.]
4. Las horas de los siete issues técnicos (TEC-01 a TEC-07) aún no están estimadas.
