# Acta de planeación de la iteración 1

Registra: Bairon Vásquez (líder) · Equipo LasPalomas · Estado: **borrador**. Los datos de la reunión que no estaban definidos están marcados y las decisiones están como propuesta hasta que el equipo las apruebe.

Fuentes: [priorizacion.md](../../priorizacion.md), [backlog-issues.md](../../equipo/backlog-issues.md) y los `tasks.md` de los cinco casos de uso de la iteración 1 (CU-01, CU-03, CU-05, CU-06 y CU-07, en [specs/](../../../specs/)).

## Verificación del acta

| Comprobación | Resultado |
|---|---|
| El total de horas no supera la capacidad | **No se puede confirmar.** La capacidad no está definida. Las tareas suman **64 h** y superan tres de las cuatro capacidades de referencia (sección 3) |
| Cada persona tiene tareas de código | **Sí.** Sergio (núcleo), Mariana (persistencia y API) y Bairon (adaptadores y Angular), sección 5 |
| Todas las tareas tienen responsable | **No.** 3 tareas (5 h) de la API del comprador no tienen responsable |
| El total incluye toda la base técnica | **No.** Los issues TEC-01 a TEC-07 no tienen tareas ni horas estimadas |

## 1. Datos de la reunión

| Dato | Valor |
|---|---|
| Fecha | [NECESITA ACLARACIÓN: ¿qué día y a qué hora se hizo la reunión? La semana 0 cierra el viernes 27/11/2026 y [normas.md](../../equipo/normas.md) fija las reuniones de 7:00 pm a 9:00 pm] |
| Asistentes | Bairon Vásquez, Sergio Velásquez, Mariana García |
| Iteración | 1: del 28/11 al 04/12/2026 (etiqueta v0.1) |

## 2. Objetivo

Propuesto a partir del enunciado: implementar y validar el núcleo y los primeros ítems (evento, cartelera, reserva y pago con las dos pasarelas), y dejar listos para la revisión en clase la demostración, la retrospectiva, el acta de planeación de la iteración 2 y la etiqueta v0.1. En la iteración 1 se acepta además el ADR-001 y se completan las vistas y las secuencias. [NECESITA ACLARACIÓN: ¿el equipo confirma este objetivo o lo redacta distinto?]

## 3. Capacidad

Cálculo de Mariana García (gerente de planeación; tarea M8): [NECESITA ACLARACIÓN: ¿cuántas horas tiene el equipo en la iteración 1 y cómo se calculó? `drivers.md` solo plantea 21 h o 33 h por iteración, sin decir si son del equipo o por persona].

| Persona | Disponibilidad en la iteración 1 | Detalle del cálculo |
|---|---|---|
| Bairon Vásquez | Pendiente | Pendiente |
| Sergio Velásquez | Pendiente | Pendiente |
| Mariana García | Pendiente | Pendiente |
| **Total** | **Pendiente** | |

Referencia, no capacidad confirmada: las tareas propuestas suman 64 h.

| Hipótesis de `drivers.md` | Capacidad | Holgura (capacidad − 64 h) | ¿Alcanza? |
|---|---|---|---|
| 21 h por iteración, equipo completo | 21 h | −43 h | No |
| 33 h por iteración, equipo completo | 33 h | −31 h | No |
| 21 h por persona | 63 h | −1 h | No, por 1 h |
| 33 h por persona | 99 h | +35 h | Sí, sin contar TEC-01 a TEC-07 |

## 4. Ítems seleccionados

Selección propuesta: los de la iteración 1 en el orden de [backlog-issues.md](../../equipo/backlog-issues.md) y de [priorizacion.md](../../priorizacion.md) (DP-02). Los issues aún no se crearon en GitHub [NECESITA ACLARACIÓN: ¿cuáles son los números de los issues? Mariana los crea en el tablero].

| Ítem | Caso de uso | Horas de las tareas | Horas en `drivers.md` | Issue | Especificación |
|---|---|---|---|---|---|
| CU-01 | Registrar evento en borrador con sus localidades | 8 h | 6 h | Pendiente | [specs/001-registrar-evento](../../../specs/001-registrar-evento/) |
| CU-03 | Publicar evento | 5,5 h | 2 h | Pendiente | [specs/003-publicar-evento](../../../specs/003-publicar-evento/) |
| CU-05 | Consultar cartelera | 7,5 h | 3 h | Pendiente | [specs/005-consultar-cartelera](../../../specs/005-consultar-cartelera/) |
| CU-06 | Reservar boletas | 24 h | 10 h | Pendiente | [specs/006-reservar-boletas](../../../specs/006-reservar-boletas/) |
| CU-07 | Pagar reserva (dos pasarelas) | 19 h | 8 h | Pendiente | [specs/007-pagar-reserva](../../../specs/007-pagar-reserva/) |
| **Total CU** | | **64 h** | **29 h** | | |

Además, los issues técnicos TEC-01 a TEC-07 (estructura, `.env` y raíz de composición, puerto Reloj, persistencia, API, Angular y script de datos) están en la iteración 1 del backlog y todos los casos de uso dependen de ellos. No tienen especificación ni horas estimadas: `drivers.md` los cuenta como una base de 4 h, que [priorizacion.md](../../priorizacion.md) (DP-07) considera corta. [NECESITA ACLARACIÓN: ¿los TEC llevan carpeta `specs/` con los cuatro archivos o solo tareas? Es la pregunta 2 de `backlog-issues.md`.]

## 5. Tareas por persona

Todas las tareas son de máximo 4 horas y salen de los `tasks.md`. Las horas son una propuesta de cada autor, que Mariana ajusta.

### Sergio Velásquez: 20,5 h

| Tarea | Descripción | Horas |
|---|---|---|
| T-01-01 | Dominio `Evento` y `Localidad` y caso de uso `RegistrarEvento` | 1,5 |
| T-03-01 | `Evento.publicar()` y caso de uso `PublicarEvento` | 1 |
| T-05-01 | Caso de uso `ConsultarCartelera` | 1,5 |
| T-06-01 | Dominio: `Comprador`, `TipoPublico`, cupo y venta abierta | 2 |
| T-06-02 | Dominio: `Reserva` con monto y vigencia | 3 |
| T-06-03 | Puerto `ConsultaSIA` y métodos de repositorio de la reserva | 1 |
| T-06-04 | Caso de uso `ReservarBoletas` | 3 |
| T-06-10 | Validar los escenarios de CU-06, con la concurrencia | 3 |
| T-07-01 | Dominio `Pago` y excepciones de pago | 1,5 |
| T-07-02 | Caso de uso `PagarReserva` | 3 |

### Mariana García: 16,5 h

| Tarea | Descripción | Horas |
|---|---|---|
| T-01-02 | Persistencia de evento y localidad | 2 |
| T-01-03 | Endpoint de registro de eventos | 1,5 |
| T-01-05 | Validar CU-01 | 1 |
| T-03-02 | Repositorio de publicación y lista de borradores | 1 |
| T-03-03 | Endpoints de publicación y de borradores | 1 |
| T-03-05 | Validar CU-03 | 1 |
| T-05-02 | Repositorios: eventos publicados y conteos de cupo | 2 |
| T-06-05 | Persistencia de comprador y reserva, con bloqueos | 4 |
| T-07-03 | Persistencia del pago con el índice único parcial | 3 |

### Bairon Vásquez: 22 h

| Tarea | Descripción | Horas |
|---|---|---|
| T-01-04 | Formulario de registro de eventos en `admin/` | 2 |
| T-03-04 | Pantalla de borradores y publicar en `admin/` | 1,5 |
| T-05-04 | Pantalla de cartelera en `comprador/` | 2 |
| T-05-05 | Validar CU-05 | 1 |
| T-06-06 | Adaptador `SIASimulado` | 2 |
| T-06-08 | Formulario de reserva en `comprador/` | 3 |
| T-06-09 | SIA simulado y compradores de prueba en el script de datos | 1 |
| T-07-04 | Adaptador `PasarelaSimuladaA` | 2 |
| T-07-05 | Adaptador `PasarelaSimuladaB` | 1,5 |
| T-07-07 | Pantalla de pago en `comprador/` | 3 |
| T-07-08 | Compradores de prueba y respuestas de las pasarelas en el script | 1 |
| T-07-09 | Validar CU-07 | 2 |

### Sin responsable: 5 h

| Tarea | Descripción | Horas |
|---|---|---|
| T-05-03 | Endpoint de cartelera | 1 |
| T-06-07 | Endpoint de reserva | 2 |
| T-07-06 | Endpoint de pago | 2 |

[NECESITA ACLARACIÓN: ¿quién construye la API del comprador? `roles.md` solo asigna la de administración.]

### Resumen

| Persona | Horas | Tareas de código |
|---|---|---|
| Sergio Velásquez | 20,5 | Sí: núcleo |
| Mariana García | 16,5 | Sí: persistencia y API de administración |
| Bairon Vásquez | 22 | Sí: adaptadores y Angular |
| Sin responsable | 5 | Sí: API del comprador |
| **Total** | **64** | |

## 6. Riesgos

| ID | Riesgo | Mitigación propuesta |
|---|---|---|
| R-01 | **Capacidad y plazo** (`vision.md`): las tareas suman 64 h, más de lo que cabe en tres de las cuatro hipótesis de capacidad, sin contar los TEC | Fijar la capacidad real, reestimar y aplicar el orden de recorte de DP-04; los ítems recortados quedan en el tablero |
| R-09 | El ADR-001 puede cambiar tras la clase de arquitectura hexagonal (`vision.md`) | La vista de desarrollo se ajusta si cambia |
| Nuevo | **TEC-01 a TEC-07 sin estimar**: todos los casos de uso dependen de ellos | Estimarlos antes de cerrar la selección de ítems |
| Nuevo | **Carga desbalanceada**: Bairon concentra 22 h, y los TEC de adaptadores, `.env`, Angular y script de datos le corresponden por `roles.md` | Repartir en M8; con 21 h por persona Bairon ya se pasa |
| Nuevo | **5 h sin responsable** en la API del comprador | Asignarlas antes de empezar |
| Nuevo | **CU-07 sin emitir boletas**: CU-08 está en la iteración 2 y el ADR-006 pide confirmar la reserva y emitir las boletas en la misma transacción | Decidir si CU-08 entra en la iteración 1 (pregunta P-01 de la spec de CU-07) |

Los riesgos "Nuevo" no tienen ID en `vision.md` todavía.

## 7. Acuerdos

Propuestos, por aprobar en la reunión. Este borrador no registra acuerdos tomados, porque no se informaron.

| # | Acuerdo propuesto | Responsable |
|---|---|---|
| 1 | Fijar la capacidad por iteración y su cálculo, y reestimar las tareas antes de aprobar la selección | Mariana García |
| 2 | Estimar TEC-01 a TEC-07 y sumarlos a la capacidad | Mariana García |
| 3 | Asignar la API del comprador (T-05-03, T-06-07 y T-07-06) | Bairon Vásquez, como líder |
| 4 | Crear en GitHub Projects un issue por caso de uso y un sub-issue por tarea, con "Closes #" en los pull requests | Mariana García |
| 5 | Decidir si CU-08 entra en la iteración 1 | Equipo |
| 6 | Aceptar el ADR-001 en esta iteración, después de la clase de arquitectura hexagonal | Sergio Velásquez |
| 7 | Revisar los `plan.md` de la iteración 1 frente a la arquitectura | Sergio Velásquez |

## Marcas [NECESITA ACLARACIÓN] de esta acta

1. Fecha y hora de la reunión.
2. Confirmación del objetivo propuesto.
3. Capacidad del equipo y su cálculo.
4. Números de los issues de GitHub.
5. Si los TEC llevan carpeta `specs/`.
6. Quién construye la API del comprador.
