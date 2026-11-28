# Spec CU-05: Consultar cartelera

Autor: Bairon Vásquez · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión · Iteración 1

Fuentes: [drivers.md](../../docs/drivers.md) (CU-05, RN-02, RN-03), [vista lógica](../../docs/vistas/01-logica.md) y [vision.md](../../docs/vision.md). Los ID (RN, EAC, S, OB) son los de esos documentos. Los escenarios de esta spec tienen ID propio `CU05-Enn` y son los criterios de aceptación del issue de CU-05.

## 1. Objetivo

Como comprador quiero consultar la cartelera, para elegir un evento publicado y no cancelado y ver el cupo disponible de cada localidad antes de reservar (CU-06).

## 2. Actor y precondiciones

| Elemento | Valor |
|---|---|
| Actor | Comprador (estudiante, egresado o público general) |
| Identificación | Ninguna: el comprador consulta sin contraseña y sin dar su documento (RN-04) |
| Precondición | Ninguna. Si no hay eventos publicados, la cartelera está vacía |
| Dependencias | CU-03 (los eventos se publican) y el puerto Reloj |

## 3. Reglas de negocio que aplica

| RN | Regla | Cómo se aplica aquí |
|---|---|---|
| RN-02 | Solo un evento publicado aparece en la cartelera | Los eventos en borrador no se muestran |
| RN-10 | Un evento cancelado sale de la cartelera | Los eventos cancelados no se muestran |
| RN-03 | Cupo disponible = aforo − boletas pagadas − boletas en reservas vigentes | Se muestra el cupo de cada localidad, calculado con esa fórmula |
| RN-05 | Una reserva vence a los 10 minutos y libera el cupo | Una reserva vencida no cuenta en el cupo; su vigencia se decide con la hora del puerto Reloj (RT-04) |
| RN-11 | Desde la hora de inicio no se aceptan reservas | Un evento cuya hora de inicio ya pasó no se muestra (provisional, ver sección 7) |

## 4. Qué muestra la cartelera

Por cada evento: nombre, fecha, hora de inicio y lugar (RN-01). Por cada localidad del evento: nombre, precio en pesos colombianos y cupo disponible (entero, nunca negativo).

La consulta es de solo lectura: no reserva, no bloquea cupo y no cambia ningún dato. El cupo mostrado es informativo; la reserva (CU-06) vuelve a comprobarlo al apartar las boletas.

## 5. Escenarios

| ID | Escenario | Dado | Cuando | Entonces | Trazas |
|---|---|---|---|---|---|
| CU05-E01 | Eventos publicados en la cartelera | Hay dos eventos publicados con sus localidades | El comprador abre la cartelera | Ve los dos eventos con nombre, fecha, hora de inicio y lugar, y de cada localidad su nombre, precio en COP y cupo disponible | RN-01, RN-02 |
| CU05-E02 | Un borrador no aparece | Hay un evento en borrador | El comprador abre la cartelera | El evento no aparece | RN-02 |
| CU05-E03 | Un evento cancelado no aparece | Un evento publicado fue cancelado | El comprador abre la cartelera | El evento no aparece | RN-10 |
| CU05-E04 | El cupo descuenta pagadas y reservas vigentes | Una localidad con aforo 10, 3 boletas pagadas y 2 en reservas vigentes | El comprador abre la cartelera | El cupo de esa localidad es 5 | RN-03 |
| CU05-E05 | El vencimiento libera el cupo | Una reserva vigente de 2 boletas en una localidad con aforo 10 (cupo mostrado: 8) y el reloj controlable activo | Se adelanta el reloj 10 minutos y se abre la cartelera | El cupo de esa localidad es 10 | RN-05, EAC-04 |
| CU05-E06 | Localidad agotada | Una localidad cuyo cupo disponible es 0 | El comprador abre la cartelera | Se muestra cupo 0, nunca un valor negativo | RN-03 |
| CU05-E07 | Cartelera vacía | No hay eventos publicados | El comprador abre la cartelera | Ve un mensaje de que no hay eventos disponibles | RN-02 |
| CU05-E08 | Evento ya iniciado | Un evento publicado cuya hora de inicio ya pasó según el Reloj | El comprador abre la cartelera | El evento no aparece (provisional) | RN-11 |
| CU05-E09 | Consulta sin identificarse | El comprador no ha dado documento, correo ni celular | Abre la cartelera | La ve completa | RN-04 |

## 6. Fuera de alcance

- Reservar o pagar: CU-06 y CU-07.
- Filtros, búsqueda y paginación: el enunciado no los pide.
- Detalle de un evento en pantalla aparte: la lista ya muestra todo lo que el enunciado define para el evento y sus localidades.
- Diseño visual: no se evalúa.

## 7. Supuestos y preguntas abiertas

| ID | Tema | Decisión provisional |
|---|---|---|
| P-01 | Evento cuya hora de inicio ya pasó | Provisional: no aparece, como dice la [vista lógica](../../docs/vistas/01-logica.md) ("estado PUBLICADO y venta abierta"). El enunciado solo dice que desde esa hora no se aceptan reservas ni pagos [NECESITA ACLARACIÓN: ¿un evento ya iniciado sigue en la cartelera sin poder reservarse, o desaparece?] |
| P-02 | Orden de la lista | Propuesta: por fecha y hora de inicio, el más próximo primero. El enunciado no define orden [NECESITA ACLARACIÓN: ¿se confirma ese orden?] |
