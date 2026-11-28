# Spec CU-01: Registrar evento en borrador con sus localidades

Autora: Mariana García · Revisa: Sergio Velásquez · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: borrador para revisión · Iteración 1

Fuentes: [drivers.md](../../docs/drivers.md) (CU-01, RN-01, RN-02), [vista lógica](../../docs/vistas/01-logica.md), [ADR-006](../../docs/adr/ADR-006-persistencia.md) y [vision.md](../../docs/vision.md) (S-03, S-08, S-13, S-14). Los ID (RN, S, EAC, OB) son los de esos documentos. Los escenarios de esta spec tienen ID propio `CU01-Enn` y son los criterios de aceptación del issue de CU-01. Ningún EAC de `drivers.md` traza a CU-01: sus escenarios se apoyan en las reglas de negocio.

## 1. Objetivo

Como organizador quiero registrar un evento en borrador con sus localidades (aforo y precio en COP), para tener los eventos sobre los que luego se publica (CU-03), se reserva (CU-06) y se paga (CU-07).

## 2. Actor y precondiciones

| Elemento | Valor |
|---|---|
| Actor | Organizador de eventos |
| Precondición | El organizador está en la parte de administración. Hay al menos un organizador cargado por el script de demostración (S-03). El mecanismo de acceso lo decide CU-12 (ver P-04) |
| Entrada | Nombre, fecha, hora de inicio y lugar del evento; una o varias localidades, cada una con nombre, aforo y precio en COP |
| Resultado | Un evento en estado borrador, con sus localidades y un identificador, guardado en la base de datos |
| Dependencias | TEC-01 (estructura y puertos), TEC-02 (configuración), TEC-04 (persistencia), TEC-05 y TEC-06 (esqueletos de la API y de Angular), TEC-07 (datos de demostración, para validar) |

## 3. Reglas de negocio que aplica

| RN | Regla | Cómo se aplica aquí |
|---|---|---|
| RN-01 | Un evento tiene nombre, fecha, hora de inicio, lugar y una o varias localidades; cada localidad tiene aforo y precio propios en COP | Se exigen los cuatro datos del evento y al menos una localidad; cada localidad lleva su nombre, su aforo y su precio |
| RN-02 | El evento se registra en borrador; solo publicado aparece en la cartelera y admite reservas | El evento se crea siempre en borrador: no aparece en la cartelera (CU-05) ni admite reservas (CU-06) hasta que CU-03 lo publique |

Supuestos que aplica: S-08 (en borrador el evento se puede editar: lo hace CU-02, no esta spec), S-13 (los montos son enteros en COP) y S-14 (la fecha y la hora de inicio se interpretan en hora de America/Bogota).

## 4. Flujo principal y resultados

1. El organizador escribe el nombre, la fecha, la hora de inicio y el lugar del evento, y agrega una o varias localidades con su nombre, su aforo y su precio en COP.
2. El sistema comprueba los datos (sección 5, escenarios CU01-E04 a E08).
3. El sistema crea el evento en estado borrador con **todas** sus localidades, o no crea nada: si una localidad es inválida, no queda guardado ni el evento ni las localidades que sí eran válidas.
4. El sistema responde con el evento registrado: su identificador, sus datos y sus localidades, en estado borrador.

**Alternos:**

- Una sola localidad: es válido (CU01-E02).
- Varias localidades con aforos y precios distintos: es el caso habitual (CU01-E01).

**Excepciones:** no hay localidades, falta un dato del evento, el aforo o el precio no son válidos, o hay nombres de localidad repetidos. En todos se rechaza el registro con un error de validación que indica qué dato falla, y no se guarda nada.

Esta operación no calcula cupo ni toma bloqueos: crea filas nuevas y no compite con otras operaciones sobre el cupo ([ADR-006](../../docs/adr/ADR-006-persistencia.md)). No usa la hora del puerto Reloj (ver P-02).

## 5. Escenarios

| ID | Escenario | Dado | Cuando | Entonces | Trazas |
|---|---|---|---|---|---|
| CU01-E01 | Registro con dos localidades | Un organizador en administración | Registra "Concierto de gala", fecha 15/12/2026, hora de inicio 19:00, lugar "Auditorio Principal", con las localidades "General" (aforo 100, precio 30.000 COP) y "Preferencial" (aforo 40, precio 60.000 COP) | Se crea el evento con identificador, en estado borrador, con las dos localidades y sus datos exactos | RN-01, RN-02 |
| CU01-E02 | Registro con una sola localidad | Un organizador en administración | Registra "Charla de ciencia", fecha 16/12/2026, hora 10:00, lugar "Sala 2", con la localidad "General" (aforo 50, precio 20.000 COP) | Se crea el evento en borrador con esa única localidad | RN-01 |
| CU01-E03 | El borrador no aparece en la cartelera | El evento de CU01-E01 registrado y ningún otro evento publicado | El comprador abre la cartelera (CU-05) | La cartelera está vacía: el evento no aparece | RN-02 |
| CU01-E04 | Evento sin localidades | Un organizador en administración | Registra un evento con nombre, fecha, hora y lugar, pero sin ninguna localidad | Se rechaza con un error que indica que se necesita al menos una localidad; no se crea el evento | RN-01 |
| CU01-E05 | Datos del evento incompletos | Un organizador en administración | Envía un registro sin lugar y, en otro intento, uno sin hora de inicio, ambos con una localidad válida | Cada intento se rechaza con un error que nombra el dato faltante; no se crea nada | RN-01 |
| CU01-E06 | Aforo inválido y registro atómico | Un registro con dos localidades: "General" válida (aforo 100, precio 30.000) y "Preferencial" con aforo 0 | El organizador lo envía; luego repite con aforo −5 | Se rechaza por aforo inválido en ambos intentos; no queda guardado el evento ni la localidad "General" | RN-01 |
| CU01-E07 | Precio inválido | Un registro con una localidad de precio −1.000 COP | El organizador lo envía; luego repite con precio 12.500,5 | Ambos intentos se rechazan por precio inválido (debe ser un entero positivo en COP); no se crea nada | RN-01, S-13 |
| CU01-E08 | Nombres de localidad repetidos | Un registro con dos localidades llamadas "General" | El organizador lo envía | Se rechaza por localidad repetida (provisional, ver P-03); no se crea nada | RN-01 |
| CU01-E09 | El evento se guarda | El evento de CU01-E01 registrado | Se reinicia el backend | Al consultar la base, el evento sigue ahí con sus dos localidades, sus datos exactos y estado borrador | RN-01, RN-02 |

## 6. Fuera de alcance

- Editar el evento en borrador: CU-02 (S-08).
- Publicar el evento: CU-03. Publicado, sus localidades no se modifican (RN-02).
- Cancelar el evento: CU-04.
- Acceso del organizador: CU-12. Mientras no exista, esta operación no está protegida (P-04).
- Listar los eventos en borrador: el catálogo de `drivers.md` no lo incluye como caso de uso (P-05).
- Reportes de ventas y varios organizadores con permisos: fuera del alcance de la visión.
- Diseño visual: no se evalúa.

## 7. Supuestos y preguntas abiertas

| ID | Tema | Decisión provisional |
|---|---|---|
| P-01 | Qué es un aforo y un precio válidos | El enunciado no los acota. Propuesta: aforo entero mayor que 0 y precio entero mayor que 0 (S-13). Un precio 0 haría pagos de 0 COP y un descuento sin efecto [NECESITA ACLARACIÓN: ¿se permiten eventos gratuitos, es decir, precio 0?] |
| P-02 | Evento con fecha y hora de inicio ya pasadas | Provisional: no se valida contra la hora, de modo que CU-01 no usa el puerto Reloj (así lo declara la [vista de desarrollo](../../docs/vistas/03-desarrollo.md)). Un evento así no admite reservas (RN-11) [NECESITA ACLARACIÓN: ¿se rechaza registrar un evento con fecha y hora de inicio pasadas? Si sí, CU-01 usaría el Reloj] |
| P-03 | Nombres de localidad repetidos dentro de un evento | Provisional: se rechazan, para que la cartelera no muestre dos localidades indistinguibles [NECESITA ACLARACIÓN: ¿se confirma?] |
| P-04 | Acceso del organizador (S-03, PA-08) | CU-01 se construye antes que CU-12 y no queda protegido hasta entonces. Se registra como deuda técnica si CU-12 no se construye (DP-06 de [priorizacion.md](../../docs/priorizacion.md)) [NECESITA ACLARACIÓN: ¿en qué ADR se decide el acceso del organizador?] |
| P-05 | Cómo encuentra el organizador un borrador para editarlo o publicarlo | Ningún caso de uso del catálogo lista los eventos en borrador, y CU-02 y CU-03 necesitan elegir uno. Provisional: la respuesta del registro devuelve el identificador y la pantalla lo muestra [NECESITA ACLARACIÓN: ¿se agrega un listado de eventos del organizador a CU-03 u otro caso de uso?] |
| P-06 | Eventos con el mismo nombre y fecha | Provisional: se permiten. El enunciado no exige unicidad |
| P-07 | Fecha y hora | Se guardan como fecha y hora de inicio separadas (como en la [vista lógica](../../docs/vistas/01-logica.md)) y se interpretan en America/Bogota (S-14) |
