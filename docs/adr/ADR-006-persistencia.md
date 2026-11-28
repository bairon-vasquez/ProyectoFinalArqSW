# ADR-006: Persistencia de los datos y protección del cupo

- Estado: Aceptado | Fecha: 27/11/2026 | Autora: Mariana García

Relacionados: [vision.md](../vision.md), [drivers.md](../drivers.md), [ADR-001](ADR-001-estilo-arquitectonico.md) (estilo hexagonal), [ADR-002](ADR-002-backend.md) (backend), [ADR-004](ADR-004-base-de-datos.md) (PostgreSQL), [ADR-005](ADR-005-integracion-pasarelas-mensajeria.md) (pago pendiente y confirmación posterior), [ADR-007](ADR-007-reloj-como-puerto.md) (el reloj como puerto) y la [vista de desarrollo](../vistas/03-desarrollo.md) (nombres de repositorios y archivos).

## Contexto

El [ADR-004](ADR-004-base-de-datos.md) eligió PostgreSQL y dejó para este ADR cómo se accede a ella y cómo se protege el cupo. El [ADR-002](ADR-002-backend.md) ya fijó SQLAlchemy y Alembic solo en adaptadores. Lo que falta decidir es la forma del acceso a datos y las garantías que el sistema exige:

- Ninguna reserva ni venta supera el cupo disponible (aforo − boletas pagadas − boletas en reservas vigentes), aunque varios compradores compitan por el último cupo (RN-03, OB-01, EAC-03, R-03).
- Una reserva con pago pendiente no se puede volver a pagar, y una reserva no se paga dos veces (RN-06, EAC-05, R-04).
- El núcleo no depende de la base de datos ni del ORM y se comunica solo por puertos (RT-02).
- El tiempo llega solo por el puerto Reloj, también cuando se consulta el cupo (RT-04).
- El script de datos de demostración carga eventos, compradores y organizador (RT-11).

Fuerzas que tensionan la decisión:

- **El cupo es una suma sobre filas que cambian al mismo tiempo.** Un `CHECK` de la base no puede expresar "aforo − pagadas − reservas vigentes"; la integridad depende de cómo se serializan las operaciones concurrentes.
- **La vigencia de una reserva depende del tiempo.** Si la consulta usara la hora de la base de datos, el reloj controlable no serviría para demostrar el vencimiento (EAC-04).
- **Un agente de IA escribe buena parte del código.** Una garantía que depende de que cada caso de uso "se acuerde" de bloquear es frágil (R-02, RT-08): conviene que la base rechace lo ilegal aunque el código falle.
- **3 personas y 2 semanas** (RT-10, R-01).

## Drivers relacionados

| ID | Por qué pesa |
|---|---|
| OB-01, RN-03, EAC-03, R-03, PA-02 | Cero sobreventa con compras simultáneas: 10 solicitudes sobre 1 cupo, exactamente una reserva (propuesta del equipo, S-02) |
| RN-06, EAC-05, R-04 | Cero reservas pagadas dos veces; confirmación tardía idempotente |
| RT-02, RT-03 | El núcleo no importa SQLAlchemy; el dominio no hereda de nada del ORM |
| RT-04, EAC-04 | La hora para decidir si una reserva está vigente viene del puerto Reloj |
| RT-11 | Script de datos de demostración y README para instalar desde cero |
| RT-08, R-02 | Garantías que no dependan de la disciplina de quien escribe el caso de uso |
| RT-10, R-01 | Plazo y capacidad del equipo |

## Alternativas consideradas

### A1. SQLAlchemy 2 (ORM) detrás de repositorios

Modelos declarativos de SQLAlchemy en el adaptador de persistencia. Los repositorios implementan los puertos del núcleo y traducen entre modelos y entidades del dominio. Alembic se apoya en los modelos para generar y aplicar las migraciones.

### A2. SQL directo con psycopg detrás de repositorios

Consultas escritas a mano y ejecutadas con el controlador `psycopg`. Cada repositorio arma las entidades del dominio a partir de las filas.

### A3. SQLModel

Clases que son a la vez modelo de Pydantic y modelo de SQLAlchemy, pensadas para usar una sola clase en la API y en la base.

## Comparación

Escala: **+** favorece el driver; **0** lo permite con trabajo adicional; **−** va en contra. Valoración del equipo para este proyecto, no una medición.

| Driver | A1. SQLAlchemy 2 | A2. psycopg directo | A3. SQLModel |
|---|---|---|---|
| RT-02: el dominio no hereda del ORM ni de Pydantic | **+** Entidades de dominio aparte, con mapeo explícito a los modelos | **+** Sin ORM: se arman entidades a partir de filas | **−** Su razón de ser es unir modelo de API, de base y de dominio en una clase; usarlo en el núcleo rompe RT-02 y la regla de Pydantic solo en entrada del ADR-002. Para evitarlo hay que mantener un mapeo adicional y se pierde su ventaja |
| EAC-03, PA-02: bloqueo de fila con `SELECT ... FOR UPDATE` | **+** `with_for_update()` sobre la sesión | **+** El `FOR UPDATE` se escribe tal cual en el SQL | **+** Es SQLAlchemy por debajo: igual que A1 |
| Transacciones para pago, boletas y reembolso | **+** Una sesión por unidad de trabajo | **0** Se gestionan la conexión y la transacción a mano | **+** Igual que A1 |
| Migraciones con Alembic | **+** Genera los cambios desde los modelos; se revisan a mano | **0** Sin modelos no hay generación automática: cada migración se escribe a mano | **+** Compatible con Alembic |
| RT-10, R-01: 3 personas, 2 semanas | **0** Hay que escribir el mapeo, pero las consultas de lectura y escritura comunes son cortas | **−** Todas las consultas, los parámetros y el armado de entidades se escriben y revisan a mano | **0** Menos mapeo, pero a costa de RT-02 |
| RT-08, R-02: revisión del código del agente | **0** Código abundante en documentación; el revisor debe vigilar que el ORM no se filtre al núcleo | **0** Más SQL en texto que revisar; las consultas deben ir siempre parametrizadas | **−** El agente tiende a usar la misma clase en todas las capas |
| Coherencia con ADR-002 y ADR-004 | **+** Es el acceso que esos ADR ya asumen | **−** Deja sin uso lo decidido en ellos | **0** Añade una dependencia más al backend |

### Argumentos por alternativa

- **A1** cumple todos los drivers con costo moderado: el mapeo explícito. Es la opción coherente con lo ya decidido.
- **A2** da control total del `FOR UPDATE` y de cada consulta, pero el costo en migraciones y en código a mano pesa con el plazo (R-01) y no ofrece nada que A1 no pueda hacer.
- **A3** pierde en el driver que más pesa en la evaluación: la regla de dependencia (RT-02). Es cómodo en una API pequeña, pero aquí el dominio no puede ser una clase del framework.

## Decisión

Se adopta **A1: SQLAlchemy 2 + Alembic, solo en `src/backend/adaptadores/salida/persistencia/`**, con repositorios como puertos y mapeo explícito entre dominio y modelos.

### Puertos y mapeo

- Las interfaces de repositorio viven en `src/backend/nucleo/puertos/repositorios.py`, como clases abstractas [NECESITA ACLARACIÓN: ¿clases abstractas o `Protocol`? Es el punto 1 pendiente del ADR-005; se recomienda `abc.ABC`]. Los nombres de los repositorios (`RepositorioEventos`, `RepositorioCompradores`, `RepositorioReservas`, `RepositorioPagos`) los fija la [vista de desarrollo](../vistas/03-desarrollo.md); los de los métodos de abajo son ilustrativos.
- Los casos de uso piden **intenciones**, no SQL: por ejemplo "obtener la localidad para reservar", que el adaptador implementa con el bloqueo. El núcleo nunca ve `FOR UPDATE`.
- La frontera de la transacción es un puerto `UnidadDeTrabajo` en el mismo archivo, como fija la vista de desarrollo: se abre con `with`, entrega los repositorios, confirma con `confirmar()` y revierte si hay una excepción.
- Las entidades del dominio son clases comunes: **no heredan de nada del ORM**. Los modelos de SQLAlchemy viven solo en el adaptador, y funciones de mapeo explícitas traducen en ambos sentidos. Una entidad del dominio nunca sale del adaptador como un modelo ni al revés.

```text
src/backend/
├── nucleo/puertos/repositorios.py     # interfaces: puertos de salida
└── adaptadores/salida/persistencia/
    ├── modelos.py                     # modelos de SQLAlchemy
    ├── mapeadores.py                  # dominio <-> modelos, explícito
    ├── repositorios_sql.py            # implementan los puertos
    ├── unidad_trabajo.py              # sesión y transacción
    └── migraciones/                   # Alembic: configuración y versiones
```

### Cómo se garantiza que nunca se supere el cupo

Cada reserva (CU-06) ocurre en **una transacción corta** con este orden:

1. **Antes de abrir la transacción:** el caso de uso consulta el SIA (tarifa, RN-09) y lee la hora del puerto Reloj. Ninguna llamada a un sistema externo ocurre mientras se sostiene un bloqueo.
2. **Se bloquea la localidad:** `SELECT ... FOR UPDATE` sobre la fila de la localidad. Las demás reservas de **esa localidad** esperan aquí; las de otras localidades no.
3. **Con el bloqueo ya tomado**, se calcula el cupo: aforo − boletas pagadas − boletas de reservas vigentes. Una reserva está vigente si su vencimiento es posterior a la `ahora` que recibe la consulta **como parámetro**, nunca con la hora de la base de datos (RT-04).
4. Si la cantidad pedida cabe, se inserta la reserva; si no, se lanza una excepción de dominio de cupo agotado, que la API traduce a HTTP ([estandares.md](../equipo/estandares.md)).
5. Se confirma la transacción y se libera el bloqueo.

El paso 3 debe ir después del 2. Con el nivel de aislamiento por defecto de PostgreSQL (READ COMMITTED), cada instrucción ve lo confirmado hasta ese momento: la segunda reserva, al obtener el bloqueo, ya ve la primera. Sin ese orden, ambas calcularían el mismo cupo.

Se compararon tres mecanismos:

| Mecanismo | A favor | En contra |
|---|---|---|
| **Bloqueo de la fila de la localidad y suma de lo existente** (elegido) | Es la forma directa de expresar RN-03; no duplica datos: el cupo se deduce de reservas y boletas | Depende de que toda operación que cambia el cupo tome el bloqueo (ver "Qué respalda la base") |
| Contador de cupo en la localidad con `UPDATE ... WHERE reservadas + n <= aforo` y un `CHECK` | La base lo garantiza sola | El contador duplica datos y debe decrementarse al vencer cada reserva, lo que obliga a una tarea periódica y complica el vencimiento por reloj (PA-07, EAC-04) |
| Nivel de aislamiento SERIALIZABLE con reintentos | No necesita bloqueos explícitos | La base aborta transacciones y el caso de uso debe reintentarlas; más difícil de razonar y de demostrar |

**Qué respalda la base.** Las restricciones que sí se pueden expresar no se dejan al código:

- `CHECK` de que una reserva tiene entre 1 y 4 boletas (RN-05).
- Código de boleta `UNIQUE` (RN-08, EAC-07).
- Referencia del pago en la pasarela `UNIQUE`.
- Montos en COP enteros (S-13).

**Límite de 4 boletas por evento (RN-04).** Dos reservas simultáneas del mismo comprador en localidades distintas de un mismo evento no se serializan por el bloqueo de la localidad. Para cubrirlo, el adaptador también bloquea la fila del comprador (identificado por su documento, S-10) antes de contar sus boletas. El comprador es una entidad con fila propia, con su `RepositorioCompradores` ([vista de desarrollo](../vistas/03-desarrollo.md)).

**Orden fijo de bloqueos.** Para evitar interbloqueos entre casos de uso (CU-06, CU-07, CU-10, CU-04), quien necesite varios bloqueos los toma siempre en este orden: **comprador → localidad → reserva → pago**, y varias filas del mismo tipo en orden de identificador. Si la base detecta un interbloqueo, aborta una de las transacciones y la API responde con un error; no se pierde integridad.

### Cómo se evita el doble pago

La reserva pasa por dos transacciones cortas alrededor de la llamada a la pasarela, porque no se puede sostener un bloqueo mientras se espera a un sistema externo:

1. **Transacción 1 (CU-07).** Se bloquea la fila de la reserva, se comprueba que sigue vigente (con la hora del Reloj) y que **no tiene un pago activo**, y se inserta un intento de pago en estado `INICIADO`. Se confirma.
2. **Sin transacción:** se llama a `PasarelaPago.iniciar_pago` ([ADR-005](ADR-005-integracion-pasarelas-mensajeria.md)).
3. **Transacción 2.** Se bloquea el pago, se guarda su resultado (`APROBADO`, `RECHAZADO` o `PENDIENTE`) y su referencia. Si es `APROBADO`, **en esta misma transacción** se confirma la reserva y se emiten las boletas, para que no exista una boleta sin pago confirmado ni un pago confirmado sin boletas (ACID, ADR-004).

El estado `INICIADO` es nuevo respecto a los tres estados del ADR-005 [NECESITA ACLARACIÓN: ¿se acepta `INICIADO`? Sin un estado previo a la llamada, dos solicitudes simultáneas llamarían las dos a la pasarela antes de que ninguna guarde su resultado].

Un pago está **activo** si su estado es `INICIADO`, `PENDIENTE` o `APROBADO`. Un `RECHAZADO` no lo está: la reserva sigue vigente y el comprador puede reintentar (RN-06). Dos defensas, de distinto nivel:

- **En el código:** el bloqueo de la reserva y la comprobación de "no tiene pago activo" dan al comprador el mensaje correcto (RN-06, "pago pendiente").
- **En la base:** un **índice único parcial** sobre el pago por reserva, solo para los estados activos (`UNIQUE (reserva_id) WHERE estado IN ('INICIADO', 'PENDIENTE', 'APROBADO')`). Si por un error del caso de uso dos intentos llegaran a insertarse, la base rechaza el segundo; el adaptador traduce ese error a una excepción de dominio. Esta defensa no depende de que el código se acuerde del bloqueo (R-02).

**Confirmación tardía (CU-10).** Es idempotente, como exige el ADR-005. Se localiza el pago por su referencia (`UNIQUE`), se toman los bloqueos en el orden fijo (localidad antes que reserva y pago, porque la confirmación tardía puede necesitar el cupo, RN-07) y se **relee el estado**: si el pago ya no está `PENDIENTE`, no se hace nada.

### Migraciones

- Alembic se ejecuta con `alembic upgrade head` ([README](../../README.md), paso 5) y su configuración y versiones viven en `persistencia/migraciones/`.
- Las migraciones se generan con la opción automática de Alembic a partir de los modelos y **una persona las lee antes del commit**: la generación automática no crea índices parciales ni `CHECK` con intención, y el código del agente se revisa (RT-08).
- Una migración ya integrada no se edita: un cambio nuevo es una migración nueva.
- PostgreSQL ejecuta el DDL dentro de una transacción ([ADR-004](ADR-004-base-de-datos.md)): una migración que falla se revierte entera.
- La URL de conexión sale de `DATABASE_URL` del `.env`, leída por la raíz de composición (`arranque.py`, [ADR-005](ADR-005-integracion-pasarelas-mensajeria.md)).

### Script de datos de demostración

El script (`src/backend/scripts/`) usa **los mismos repositorios y la misma `UnidadDeTrabajo`** que la API: la raíz de composición los ensambla igual y el script construye entidades del dominio y las guarda por los puertos, sin SQL propio.

- Los datos de demostración cumplen las mismas reglas que los reales: un evento con una localidad inválida no se carga.
- El script no conoce las tablas: un cambio de esquema solo se refleja en los modelos y las migraciones.
- Se ejecuta sobre una base ya migrada (`alembic upgrade head`) y obtiene las fechas del puerto Reloj.
- El estudiante y el egresado del SIA simulado no van a la base: están en el archivo de `SIA_DATOS` ([ADR-005](ADR-005-integracion-pasarelas-mensajeria.md)); el script debe usar los mismos documentos para los compradores de prueba. Lo mismo para las respuestas de la pasarela simulada por documento.
- [NECESITA ACLARACIÓN: ¿qué hace el script si se ejecuta dos veces sobre la misma base (falla, borra y recarga, o ignora lo ya cargado)? El enunciado no lo dice.]

## Consecuencias

**Positivas**
- La sobreventa se impide con un bloqueo por fila: las compras de otras localidades no esperan (EAC-03).
- El núcleo no conoce SQLAlchemy, `FOR UPDATE` ni PostgreSQL; la regla de dependencia sigue verificándose con una búsqueda de imports (RT-02).
- La base rechaza por sí misma un segundo pago activo, un código de boleta repetido y una reserva de más de 4 boletas.
- El reloj controlable sirve para demostrar el vencimiento porque la base nunca decide la hora.
- Los datos de demostración no pueden saltarse las reglas del dominio.

**Negativas**
- El mapeo entre dominio y modelos duplica estructuras y hay que mantenerlas alineadas. Es el costo de RT-02 y se acepta.
- Una operación que cambie el cupo y olvide el bloqueo rompe la garantía. Mitigación: el orden de bloqueos y el paso 2-3 están en este ADR; el revisor lo comprueba en cada pull request ([checklist](../equipo/checklist-revision.md)); el escenario de concurrencia está en `validacion.md`.
- Con el bloqueo por localidad, un evento con una sola localidad muy pedida procesa sus reservas una tras otra. Para el volumen de demostración (S-01) se acepta.
- Si el proceso se cae entre la transacción 1 y la 2, el pago queda `INICIADO` sin resultado. No se cobra dos veces, porque el índice bloquea un segundo intento, pero el estado no se resuelve solo [NECESITA ACLARACIÓN: ¿qué debe pasar con un pago `INICIADO` sin resultado cuando la reserva vence? El enunciado no lo dice; se propone registrarlo como deuda técnica en `arquitectura.md`].
- Los nombres de los métodos de los repositorios son ilustrativos hasta que se escriban los `plan.md`; los de los repositorios y los archivos de `persistencia/` están en la vista de desarrollo.

**Riesgos aceptados**
- Que dos casos de uso toquen filas en distinto orden y la base aborte una de las transacciones. Se mitiga con el orden fijo y se acepta como error visible, nunca como sobreventa.
- Que el volumen real supere al de demostración. No hay cifra en el enunciado (S-01, S-02).

## Verificación

- **EAC-03:** diez solicitudes simultáneas sobre una localidad con un cupo, repetido cinco veces (propuesta del equipo, [drivers.md](../drivers.md)): exactamente una reserva y nueve respuestas de cupo agotado, y la base nunca muestra un cupo negativo. Se registra en `validacion.md` de CU-06 con salida de consola como evidencia.
- **EAC-05:** dos intentos simultáneos de pagar la misma reserva producen un solo pago activo; el segundo recibe el rechazo de RN-06.
- **Regla de dependencia:** la búsqueda de imports del [checklist](../equipo/checklist-revision.md) devuelve vacío para `sqlalchemy` en `src/backend/nucleo/`.

## Qué debe confirmarse tras la clase de arquitectura hexagonal

| # | Qué confirmar | Opción propuesta |
|---|---|---|
| 1 | Puertos como clase abstracta o `Protocol` (punto 1 del ADR-005) | Clase abstracta (`abc.ABC`) |
| 2 | Dónde vive el puerto `UnidadDeTrabajo` | En `repositorios.py`: resuelto en la vista de desarrollo |
| 3 | Estado `INICIADO` del pago, previo a la llamada a la pasarela | Aceptarlo; es lo que hace posible impedir el doble pago antes de cobrar |
| 4 | Bloqueo por comprador para el límite de 4 boletas (RN-04) | Sí: el comprador tiene fila propia (resuelto en la vista de desarrollo) |
| 5 | Aprobación de Sergio Velásquez como gerente de desarrollo (`normas.md`, sección 3) | Pendiente: este ADR se marcó Aceptado según lo pedido por el equipo |
| 6 | Si este ADR sigue válido en caso de que ADR-001 cambie a Clean Architecture | Sí: los repositorios pasan a ser gateways y el resto se mantiene |
