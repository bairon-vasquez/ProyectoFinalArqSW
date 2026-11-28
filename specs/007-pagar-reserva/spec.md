# Spec CU-07: Pagar reserva

Autor: Bairon Vásquez · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión · Iteración 1

Fuentes: [drivers.md](../../docs/drivers.md) (CU-07, RN-05, RN-06, RN-11, EAC-01, EAC-04, EAC-05, PA-03), [vista lógica](../../docs/vistas/01-logica.md), [ADR-005](../../docs/adr/ADR-005-integracion-pasarelas-mensajeria.md), [ADR-006](../../docs/adr/ADR-006-persistencia.md) y [vision.md](../../docs/vision.md). Los escenarios de esta spec tienen ID propio `CU07-Enn` y son los criterios de aceptación del issue de CU-07.

## 1. Objetivo

Como comprador (que usa la pasarela de pago) quiero pagar mi reserva, para completar la compra con un resultado aprobado, rechazado o pendiente.

## 2. Actores y precondiciones

| Elemento | Valor |
|---|---|
| Actor | Comprador |
| Sistema externo | Pasarela de pago (simulada A o B, elegida por `PASARELA_PAGO`) |
| Precondición | Existe una reserva en estado vigente, creada con CU-06, de un evento con la venta abierta |
| Entrada | La reserva que se paga. El monto es el de la reserva, ya calculado en CU-06 con su tarifa |
| Dependencias | CU-06 (la reserva), TEC-02 (configuración de adaptadores), TEC-03 (Reloj) y TEC-04 (persistencia) |

## 3. Reglas de negocio que aplica

| RN | Regla | Cómo se aplica aquí |
|---|---|---|
| RN-05 | La reserva dura 10 minutos aunque el pago esté pendiente | Solo se paga una reserva vigente según la hora del Reloj; el plazo sigue corriendo con un pago pendiente |
| RN-06 | El pago es aprobado, rechazado o pendiente. Rechazado: la reserva sigue vigente y se puede reintentar. Pendiente: no se puede pagar de nuevo la misma reserva hasta la respuesta | Se guarda cada intento con su resultado; un nuevo intento se rechaza si hay un pago activo (iniciado, pendiente o aprobado) |
| RN-11 | Desde la hora de inicio no se aceptan pagos | Se rechaza el pago si la venta del evento está cerrada, aunque la reserva siga vigente |
| RN-04 | Sin contraseña | El comprador no se autentica para pagar |

## 4. Flujo principal y resultados

1. El comprador pide pagar una reserva.
2. El sistema comprueba que la reserva existe, está vigente, el evento tiene la venta abierta y no hay un pago activo. Registra el intento de pago antes de llamar a la pasarela ([ADR-006](../../docs/adr/ADR-006-persistencia.md)).
3. El sistema pide el cobro a la pasarela activa por su puerto.
4. Según el resultado:

| Resultado de la pasarela | Qué hace el sistema | Qué ve el comprador |
|---|---|---|
| **Aprobado** | Guarda el pago aprobado con su referencia y confirma la reserva | Pago aprobado |
| **Rechazado** | Guarda el pago rechazado con su motivo; la reserva sigue vigente | Pago rechazado y que puede intentar de nuevo dentro del plazo |
| **Pendiente** | Guarda el pago pendiente; la reserva sigue vigente y su plazo sigue corriendo | Pago pendiente: debe esperar la respuesta de la pasarela antes de pagar de nuevo |

La resolución posterior de un pago pendiente (aprobación o rechazo después, incluida la confirmación tardía) es CU-10 y no se construye en esta spec.

## 5. Escenarios

La pasarela simulada responde según el documento del comprador de prueba, con un archivo de respuestas por pasarela ([ADR-005](../../docs/adr/ADR-005-integracion-pasarelas-mensajeria.md)). Los compradores de prueba del script de demostración permiten obtener los tres resultados.

| ID | Escenario | Dado | Cuando | Entonces | Trazas |
|---|---|---|---|---|---|
| CU07-E01 | Pago aprobado | Una reserva vigente de un comprador de prueba cuya respuesta es "aprobado" | Paga la reserva | El pago queda aprobado con su referencia, la reserva queda confirmada y el monto cobrado es el de la reserva | RN-06 |
| CU07-E02 | Pago rechazado | Una reserva vigente de un comprador cuya respuesta es "rechazado" | Paga la reserva | El pago queda rechazado con su motivo y la reserva sigue vigente | RN-06 |
| CU07-E03 | Reintento tras un rechazo | Una reserva vigente con un pago rechazado | El comprador intenta pagar de nuevo dentro del plazo | Se acepta el nuevo intento y se guarda como un pago nuevo | RN-06 |
| CU07-E04 | Pago pendiente | Una reserva vigente de un comprador cuya respuesta es "pendiente" | Paga la reserva | El pago queda pendiente y la reserva sigue vigente con su plazo corriendo | RN-06, RN-05 |
| CU07-E05 | Nuevo intento con un pago pendiente | Una reserva con un pago pendiente | El comprador intenta pagar de nuevo | Se rechaza con el aviso de que debe esperar la respuesta; no se llama a la pasarela | RN-06, EAC-05 |
| CU07-E06 | Reserva vencida | Una reserva vigente y el reloj controlable activo | Se adelanta el reloj 10 minutos y se intenta pagar | Se rechaza porque la reserva venció; no se llama a la pasarela | RN-05, EAC-04 |
| CU07-E07 | Límite del plazo | Una reserva creada en t0 | Se intenta pagar en t0 + 9:59 y en t0 + 10:00 | A los 9:59 se acepta; a los 10:00 se rechaza (límite propuesto en EAC-04) | RN-05, EAC-04 |
| CU07-E08 | Cierre de la venta | Una reserva creada 5 minutos antes de la hora de inicio del evento | Se adelanta el reloj hasta la hora de inicio y se intenta pagar | Se rechaza por venta cerrada aunque la reserva siga dentro de sus 10 minutos; no se llama a la pasarela | RN-11, EAC-04 |
| CU07-E09 | Dos pagos simultáneos | Una reserva vigente sin pagos | Llegan dos solicitudes de pago al mismo tiempo | Solo un pago queda activo; la otra solicitud se rechaza | RN-06, EAC-05 |
| CU07-E10 | Reserva ya pagada | Una reserva confirmada por un pago aprobado | El comprador intenta pagar de nuevo | Se rechaza: la reserva ya está pagada | RN-06 |
| CU07-E11 | Reserva inexistente | Un identificador de reserva que no existe | El comprador intenta pagar | Se rechaza con un error de reserva no encontrada | — |
| CU07-E12 | Cambio de pasarela por configuración | El sistema con `PASARELA_PAGO=simulada_a` | Se ejecuta CU07-E01, se cambia el `.env` a `simulada_b`, se reinicia y se repite | Con A la referencia del pago empieza por `A-` y con B por `B-`; el resultado funcional es el mismo y `git diff --name-only HEAD` queda vacío | EAC-01, OB-03, RT-05 |

## 6. Fuera de alcance

- Resolver un pago pendiente, la confirmación tardía y el reembolso automático: CU-10.
- Consultar el estado de la reserva y del pago: CU-11. En esta spec la pantalla solo informa el resultado del intento.
- Los datos del medio de pago (por ejemplo, tarjeta): con las pasarelas simuladas no se capturan; la respuesta depende del documento del comprador de prueba [NECESITA ACLARACIÓN: ¿la pantalla de pago pide algún dato del medio de pago? El enunciado no lo define].
- Diseño visual: no se evalúa.

## 7. Supuestos y preguntas abiertas

| ID | Tema | Decisión provisional |
|---|---|---|
| P-01 | Boletas al aprobar el pago | Emitirlas es CU-08, que la [priorización](../../docs/priorizacion.md) deja para la iteración 2. En la iteración 1 el pago aprobado confirma la reserva, y las boletas se emiten cuando exista CU-08 [NECESITA ACLARACIÓN: ¿CU-07 queda sin emitir boletas en la iteración 1, o CU-08 entra en la iteración 1? El [ADR-006](../../docs/adr/ADR-006-persistencia.md) pide confirmar la reserva y emitir las boletas en la misma transacción] |
| P-02 | Error técnico de la pasarela | El enunciado no dice qué hacer si la pasarela no responde o falla. Con las simuladas no ocurre [NECESITA ACLARACIÓN: ¿qué debe hacer el sistema ante un error técnico de la pasarela?] |
| P-03 | Pago `INICIADO` sin resultado | Un fallo del proceso entre registrar el intento y guardar el resultado deja el pago `INICIADO`. Es la duda del ADR-006, pendiente de decidir y candidata a deuda técnica |
| P-04 | Estado `INICIADO` | Lo propone el [ADR-006](../../docs/adr/ADR-006-persistencia.md) y está pendiente de confirmar. Esta spec lo usa |
