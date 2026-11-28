# Spec CU-03: Publicar evento

Autora: Mariana García · Revisa: Sergio Velásquez · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión · Iteración 1

Fuentes: [drivers.md](../../docs/drivers.md) (CU-03, RN-02), [vista lógica](../../docs/vistas/01-logica.md), [ADR-006](../../docs/adr/ADR-006-persistencia.md), [vision.md](../../docs/vision.md) (S-03, S-08) y la [spec de CU-01](../001-registrar-evento/spec.md). Los ID (RN, S, EAC, OB) son los de esos documentos. Los escenarios de esta spec tienen ID propio `CU03-Enn` y son los criterios de aceptación del issue de CU-03. Ningún EAC de `drivers.md` traza a CU-03: sus escenarios se apoyan en las reglas de negocio.

## 1. Objetivo

Como organizador quiero publicar un evento en borrador, para que aparezca en la cartelera (CU-05) y admita reservas (CU-06).

## 2. Actor y precondiciones

| Elemento | Valor |
|---|---|
| Actor | Organizador de eventos |
| Precondición | Existe un evento en estado borrador, registrado con CU-01. El organizador está en la parte de administración; el mecanismo de acceso lo decide CU-12 (S-03) |
| Entrada | El evento que se publica |
| Resultado | El evento pasa de borrador a publicado, con sus localidades sin cambios |
| Dependencias | CU-01 (los borradores), TEC-01, TEC-04, TEC-05 y TEC-06 (estructura, persistencia y esqueletos), TEC-07 (datos de demostración, para validar) |

## 3. Reglas de negocio que aplica

| RN | Regla | Cómo se aplica aquí |
|---|---|---|
| RN-02 | Solo cuando el organizador lo publica el evento aparece en la cartelera y se pueden reservar boletas | La publicación es la única transición de borrador a publicado; antes de ella el evento no aparece en la cartelera ni admite reservas |
| RN-02 | Después de publicado, sus localidades no se modifican | Desde que el evento está publicado no se agregan, quitan ni cambian sus localidades: el dominio lo rechaza |
| RN-01 | Un evento tiene una o varias localidades con aforo y precio propios | Un evento sin localidades no se publica. Con CU-01 no puede existir uno así; es una comprobación defensiva del dominio |

Supuesto que aplica: S-08 (en borrador el evento se puede editar con CU-02; al publicarlo se cierra esa edición).

## 4. Flujo principal y resultados

1. El organizador elige, entre los eventos en borrador, el que quiere publicar (ver P-01).
2. El sistema comprueba que el evento existe y que está en borrador.
3. El sistema marca el evento como publicado y guarda el cambio. Sus localidades quedan como estaban.
4. El sistema responde con el evento publicado.

**Alternos:** ninguno: la publicación es una sola transición.

**Excepciones:** el evento no existe; el evento ya está publicado; el evento está cancelado. En todos se rechaza la operación con un error que dice por qué, y no se cambia nada.

Esta operación no calcula cupo ni toma bloqueos de cupo. No usa la hora del puerto Reloj (ver P-03).

## 5. Escenarios

| ID | Escenario | Dado | Cuando | Entonces | Trazas |
|---|---|---|---|---|---|
| CU03-E01 | Publicar un borrador | El evento "Concierto de gala" en borrador, con las localidades "General" (aforo 100, precio 30.000 COP) y "Preferencial" (aforo 40, precio 60.000 COP) | El organizador lo publica | El evento queda publicado y la respuesta lo muestra publicado, con las dos localidades y sus datos sin cambios | RN-02 |
| CU03-E02 | El evento publicado aparece en la cartelera | El evento de CU03-E01 recién publicado y ningún otro evento publicado | El comprador abre la cartelera (CU-05) | Ve "Concierto de gala" con "General" (precio 30.000, cupo 100) y "Preferencial" (precio 60.000, cupo 40) | RN-02, RN-03 |
| CU03-E03 | El evento publicado admite reservas | El evento de CU03-E01 recién publicado | Un comprador reserva 2 boletas de "General" (CU-06) | Se crea la reserva; antes de publicar la misma solicitud se rechazaba por evento no disponible | RN-02 |
| CU03-E04 | Las localidades no se modifican tras publicar | El evento de CU03-E01 publicado | Se intenta cambiar el aforo de "General" de 100 a 200, y luego agregar una localidad "VIP" | Ambos intentos se rechazan porque el evento ya no está en borrador; las localidades quedan como estaban | RN-02 |
| CU03-E05 | Publicar un evento ya publicado | El evento de CU03-E01 ya publicado | El organizador lo publica otra vez | Se rechaza con un error que dice que el evento no está en borrador; el evento sigue publicado y sin cambios (provisional, ver P-02) | RN-02 |
| CU03-E06 | Un evento cancelado no se publica | Un evento publicado y luego cancelado (CU-04) | El organizador intenta publicarlo | Se rechaza con un error que dice que el evento no está en borrador; sigue cancelado | RN-02, RN-10 |
| CU03-E07 | Evento inexistente | Un identificador de evento que no existe | El organizador intenta publicarlo | Se rechaza con un error de evento no encontrado; no se crea ni cambia nada | — |
| CU03-E08 | El estado se guarda | El evento de CU03-E01 publicado | Se reinicia el backend | Al consultar la base, el evento sigue publicado con sus dos localidades | RN-02 |
| CU03-E09 | El organizador elige entre sus borradores | Dos eventos en borrador y uno ya publicado | El organizador abre la lista para publicar | Ve los dos borradores y no el publicado (provisional, ver P-01) | RN-02 |

## 6. Fuera de alcance

- Registrar y editar el evento: CU-01 y CU-02.
- Cancelar el evento: CU-04.
- Despublicar un evento publicado: el enunciado no lo pide; un evento publicado solo sale de la cartelera al cancelarse.
- Notificar a alguien al publicar: el enunciado no lo pide.
- Acceso del organizador: CU-12. Mientras no exista, esta operación no está protegida (misma deuda que en [CU-01](../001-registrar-evento/spec.md), P-04).
- Diseño visual: no se evalúa.

## 7. Supuestos y preguntas abiertas

| ID | Tema | Decisión provisional |
|---|---|---|
| P-01 | Cómo elige el organizador qué borrador publicar | Ningún caso de uso del catálogo lista los eventos en borrador. Provisional: CU-03 incluye mostrar la lista de borradores para poder elegir (CU03-E09); es una lectura, sin regla de negocio nueva. Responde la pregunta P-05 de la spec de CU-01 [NECESITA ACLARACIÓN: ¿se acepta que el listado de borradores sea parte de CU-03?] |
| P-02 | Publicar un evento ya publicado | Provisional: se rechaza con un error. Otra opción sería aceptarlo sin cambios (idempotente) [NECESITA ACLARACIÓN: ¿se rechaza o se acepta sin cambios?] |
| P-03 | Publicar un evento con fecha y hora de inicio ya pasadas | Provisional: se publica sin validar la hora, igual que en CU-01 (P-02), por lo que CU-03 no usa el puerto Reloj. El evento no admitiría reservas (RN-11) y, según la spec de CU-05 (P-01), no aparecería en la cartelera [NECESITA ACLARACIÓN: ¿se rechaza publicar un evento ya iniciado?] |
| P-04 | Publicar y editar a la vez | Si CU-02 se construye, publicar y editar el mismo evento al mismo tiempo podría dejar localidades modificadas en un evento publicado, contra RN-02. Haría falta que ambas operaciones se serialicen sobre la fila del evento, y el orden de bloqueos del [ADR-006](../../docs/adr/ADR-006-persistencia.md) no incluye el evento [NECESITA ACLARACIÓN: ¿se agrega el evento al orden de bloqueos del ADR-006?]. Sin CU-02, el riesgo no existe |
| P-05 | Cómo se valida CU03-E04 sin CU-02 | CU-02 está fuera de las dos iteraciones en la matriz. Si no se construye, no hay operación que modifique localidades y el escenario se valida comprobando que el contrato OpenAPI no ofrece ninguna, y que el dominio rechaza el cambio al intentarlo directamente |
| P-06 | CU03-E06 sin CU-04 | CU-04 es el primer recorte si la capacidad no alcanza (DP-04 de [priorizacion.md](../../docs/priorizacion.md)). Sin CU-04 no existen eventos cancelados y este escenario queda sin poder ejecutarse; se registra como no validado |
