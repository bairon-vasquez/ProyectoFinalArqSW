# Spec CU-06: Reservar boletas

Autor: Sergio Velásquez · Revisa: Mariana García · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión · Iteración 1

Fuentes: [drivers.md](../../docs/drivers.md) (CU-06, RN-02, RN-03, RN-04, RN-05, RN-09, RN-11, EAC-03, EAC-04, EAC-06, PA-02, PA-05), [vista lógica](../../docs/vistas/01-logica.md), [ADR-005](../../docs/adr/ADR-005-integracion-pasarelas-mensajeria.md), [ADR-006](../../docs/adr/ADR-006-persistencia.md), [ADR-007](../../docs/adr/ADR-007-reloj-como-puerto.md) y [vision.md](../../docs/vision.md) (S-05, S-10, S-13, S-14). Los escenarios de esta spec tienen ID propio `CU06-Enn` y son los criterios de aceptación del issue de CU-06.

## 1. Objetivo

Como comprador (que usa el SIA) quiero reservar de 1 a 4 boletas de una localidad, para apartar mi cupo durante 10 minutos con la tarifa que me corresponde, sin que se supere el aforo.

## 2. Actores y precondiciones

| Elemento | Valor |
|---|---|
| Actor | Comprador (estudiante, egresado o público general) |
| Sistema externo | SIA (simulado, elegido por `SIA=simulado`, con los datos de `SIA_DATOS`) |
| Identificación | Documento, correo y celular, sin contraseña (RN-04). El documento identifica al comprador (S-10) |
| Precondición | El comprador eligió en la cartelera (CU-05) una localidad de un evento publicado con la venta abierta |
| Entrada | Localidad, cantidad de boletas (1 a 4), documento, correo y celular |
| Dependencias | CU-05 (cartelera), TEC-01 (estructura y puertos), TEC-02 (configuración del SIA), TEC-03 (Reloj), TEC-04 (persistencia), TEC-05 y TEC-06 (esqueletos de API y Angular), TEC-07 (datos de demostración y SIA simulado) |

## 3. Reglas de negocio que aplica

| RN | Regla | Cómo se aplica aquí |
|---|---|---|
| RN-02 | Solo un evento publicado admite reservas | Se rechaza la reserva si el evento está en borrador o cancelado |
| RN-03 | Cupo disponible = aforo − boletas pagadas − boletas en reservas vigentes; nunca se reserva por encima | Se calcula el cupo con la localidad bloqueada y se rechaza si la cantidad no cabe |
| RN-04 | Máximo 4 boletas por evento, sumando reservas vigentes y boletas pagadas | Se suman las boletas del comprador en todas las localidades del evento; si con la nueva reserva pasa de 4, se rechaza |
| RN-05 | Una reserva tiene de 1 a 4 boletas y dura 10 minutos | `vence_en = hora de creación + 10 minutos`, con la hora del Reloj. Una reserva vencida no cuenta para el cupo ni para el máximo |
| RN-09 | Descuento según el SIA: 50 % estudiante, 30 % egresado, 50 % si es ambos; solo a una boleta por evento, la del propio comprador | Si el comprador es estudiante o egresado y aún no tiene una boleta con descuento en el evento (en una reserva vigente o pagada), una boleta lleva descuento; las demás pagan precio completo |
| RN-11 | Desde la hora de inicio no se aceptan reservas | Se rechaza la reserva si la venta del evento está cerrada según el Reloj |

Supuestos que aplica: S-05 (SIA sin respuesta: tarifa general con aviso, provisional), S-10 (el documento identifica al comprador), S-13 (montos enteros en COP, redondeados al peso) y S-14 (hora de America/Bogota).

## 4. Flujo principal y resultados

1. El comprador elige una localidad en la cartelera, indica la cantidad de boletas y escribe su documento, su correo y su celular.
2. El sistema obtiene la hora del Reloj una sola vez.
3. El sistema consulta el SIA con el documento y obtiene el tipo de público. Si el SIA no responde o no encuentra el documento, aplica la tarifa de público general y prepara un aviso para el comprador (S-05).
4. El sistema comprueba que el evento está publicado y con la venta abierta, que el comprador no pasa de 4 boletas en el evento y que hay cupo en la localidad.
5. El sistema crea la reserva vigente con el monto calculado y su vencimiento a los 10 minutos.
6. El comprador ve la reserva: localidad, cantidad, precio unitario, boleta con descuento (si la hay), monto total, hora de vencimiento y, si aplica, el aviso de tarifa general. Desde ahí puede pagar (CU-07).

**Cálculo del monto** (vista lógica, sección 4):

| Caso | Monto |
|---|---|
| Comprador estudiante, egresado o ambos, sin boleta con descuento en el evento | `precio × (1 − descuento) + precio × (cantidad − 1)`, con descuento de 50 % (estudiante o ambos) o 30 % (egresado), redondeado al peso |
| Público general, SIA sin respuesta, documento no encontrado, o comprador que ya tiene una boleta con descuento en el evento | `precio × cantidad` |

## 5. Escenarios

Los compradores de prueba del script de demostración (TEC-07) y el archivo del SIA simulado cubren los tipos de público. En los ejemplos, la localidad tiene precio de 10.000 COP salvo que se indique otro.

| ID | Escenario | Dado | Cuando | Entonces | Trazas |
|---|---|---|---|---|---|
| CU06-E01 | Reserva de público general | Una localidad con cupo 10 y un comprador que el SIA marca como "ninguno" | Reserva 2 boletas | Se crea una reserva vigente de 2 boletas por 20.000 COP, con vencimiento 10 minutos después de su creación; el cupo de la localidad baja a 8 | RN-03, RN-05, RN-09 |
| CU06-E02 | Descuento de estudiante | Un comprador que el SIA marca como estudiante, sin boletas en el evento | Reserva 3 boletas | Monto 25.000 COP: una boleta a 5.000 y dos a 10.000 | RN-09 |
| CU06-E03 | Descuento de egresado | Un comprador que el SIA marca como egresado | Reserva 1 boleta | Monto 7.000 COP | RN-09 |
| CU06-E04 | Estudiante y egresado | Un comprador que el SIA marca como ambos | Reserva 2 boletas | Monto 15.000 COP: se aplica el mayor descuento (50 %) a una boleta | RN-09 |
| CU06-E05 | Un solo descuento por evento | Un estudiante con una reserva vigente con descuento en el evento | Reserva 1 boleta más en otra localidad del mismo evento | La nueva reserva va a precio completo | RN-09 |
| CU06-E06 | SIA sin respuesta | El SIA simulado configurado para no responder ante el documento del comprador | El comprador reserva 1 boleta | Se crea la reserva a precio completo y el comprador ve el aviso de que no se pudo verificar su tipo de público | RN-09, S-05, EAC-06 |
| CU06-E07 | Documento no encontrado en el SIA | Un documento que no está en el archivo del SIA simulado | El comprador reserva 1 boleta | Se crea la reserva a precio completo con el mismo aviso | RN-09, S-05 |
| CU06-E08 | Cantidad fuera de rango | Una localidad con cupo | Se piden 0 o 5 boletas | Se rechaza la solicitud por cantidad inválida; no se crea reserva | RN-05 |
| CU06-E09 | Máximo de 4 boletas por evento | Un comprador con 3 boletas en el evento (2 en una reserva vigente y 1 pagada) | Pide 2 boletas más; luego pide 1 | Las 2 se rechazan por superar el máximo; la de 1 se acepta | RN-04 |
| CU06-E10 | El máximo suma todas las localidades | Un comprador con una reserva vigente de 4 boletas en la localidad A | Pide 1 boleta en la localidad B del mismo evento | Se rechaza por superar el máximo de 4 por evento | RN-04 |
| CU06-E11 | Una reserva vencida no cuenta | Un comprador con una reserva de 4 boletas y el reloj controlable activo | Se adelanta el reloj 10 minutos y pide 4 boletas | Se acepta: la reserva anterior venció y ya no cuenta ni para el máximo ni para el cupo | RN-04, RN-05, EAC-04 |
| CU06-E12 | Cupo insuficiente | Una localidad con cupo 2 | El comprador pide 3 boletas | Se rechaza por cupo agotado; el cupo sigue en 2 | RN-03 |
| CU06-E13 | Último cupo con compras simultáneas | Una localidad con cupo 1 | Llegan 10 solicitudes simultáneas de 1 boleta de compradores distintos; se repite 5 veces | En cada repetición se crea exactamente 1 reserva y 9 solicitudes reciben cupo agotado; el cupo nunca es negativo | RN-03, EAC-03, OB-01 |
| CU06-E14 | Mismo comprador, dos localidades a la vez | Un comprador sin boletas en el evento | Llegan al mismo tiempo dos solicitudes suyas de 3 boletas, en dos localidades del evento | Se acepta una y se rechaza la otra por superar el máximo de 4 | RN-04, PA-05 |
| CU06-E15 | Evento no disponible | Un evento en borrador y otro cancelado | Se intenta reservar en una localidad de cada uno | Ambas se rechazan porque el evento no está disponible para reservas | RN-02, RN-10 |
| CU06-E16 | Cierre de la venta | Un evento publicado y el reloj controlable activo | Se adelanta el reloj hasta la hora de inicio y se intenta reservar | Se rechaza por venta cerrada | RN-11, EAC-04 |
| CU06-E17 | Vencimiento a los 10 minutos | Una reserva creada en t0 y el reloj controlable activo | Se consulta el cupo de la localidad en t0 + 9:59 y en t0 + 10:00 | A los 9:59 la reserva cuenta en el cupo; a los 10:00 ya no (límite propuesto en EAC-04) | RN-05, EAC-04 |
| CU06-E18 | Redondeo al peso | Una localidad con precio 15.005 COP y un egresado | Reserva 1 boleta | Monto 10.504 COP (15.005 × 0,7 = 10.503,5, redondeado al peso hacia arriba) | RN-09, S-13 |
| CU06-E19 | Datos incompletos | El comprador no escribe su correo o su celular | Envía la reserva | Se rechaza con un error de validación que indica el dato faltante | RN-04 |
| CU06-E20 | Localidad inexistente | Un identificador de localidad que no existe | Se intenta reservar | Se rechaza con un error de localidad no encontrada | — |

## 6. Fuera de alcance

- Pagar la reserva: CU-07.
- Marcar las reservas como vencidas con una tarea periódica: CU-09. Esta spec solo usa la vigencia calculada con la hora del Reloj al consultar (opción V1 del [ADR-007](../../docs/adr/ADR-007-reloj-como-puerto.md)), que basta para el cupo y el máximo.
- Consultar después el estado de la reserva: CU-11.
- Que el comprador modifique o anule su reserva: el enunciado no lo pide.
- Verificar el correo o el celular del comprador: el enunciado no lo pide.
- Diseño visual: no se evalúa.

## 7. Supuestos y preguntas abiertas

| ID | Tema | Decisión provisional |
|---|---|---|
| P-01 | Mismo documento con otro correo o celular (PA-05) | Propuesta: se guardan el correo y el celular de la última reserva, y las notificaciones van a esos datos [NECESITA ACLARACIÓN: ¿se actualizan, se conservan los primeros o se rechaza la reserva?] |
| P-02 | Aviso cuando el documento no está en el SIA | S-05 trata igual "no responde" y "no encuentra": tarifa general con aviso. Un comprador de público general que no está en el SIA verá ese aviso en cada reserva |
| P-03 | Regla de redondeo | S-13 dice "redondeado al peso" sin el método. Propuesta: medio peso hacia arriba (CU06-E18) [NECESITA ACLARACIÓN: ¿se confirma el método de redondeo?] |
| P-04 | Cómo simula el SIA la falta de respuesta | Propuesta: el archivo de `SIA_DATOS` puede marcar un documento como "sin respuesta", y el adaptador simulado responde a ese documento como si el SIA no respondiera. Así CU06-E06 se demuestra sin cambiar el `.env` |
| P-05 | Consulta al SIA en cada reserva | Propuesta: se consulta en cada reserva y no se guarda el tipo de público entre reservas, porque puede cambiar |
| P-06 | Límite de los 10 minutos | Una reserva creada en t0 está vencida en t0 + 10:00 (límite inclusivo, propuesta de EAC-04) |
| P-07 | Evento ya iniciado en la cartelera | Depende de la pregunta P-01 de la [spec de CU-05](../005-consultar-cartelera/spec.md). Esta spec rechaza la reserva en cualquier caso (RN-11) |
