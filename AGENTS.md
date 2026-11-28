# AGENTS.md: sistema de boletería para los eventos culturales de la universidad

Instrucciones para el agente de IA. Se cargan a mano al iniciar cada sesión (RT-08). Mantenedor: Sergio Velásquez (gerente de desarrollo). Las decisiones de arquitectura no se delegan al agente: si algo no está aquí ni en `docs/`, se pregunta.

## 1. Fuentes de verdad

| Qué | Dónde |
|---|---|
| Arquitectura, decisiones y glosario | [docs/arquitectura.md](docs/arquitectura.md) (enlaza visión, drivers, ADR y vistas) |
| Estructura de carpetas, puertos y adaptadores | [docs/vistas/03-desarrollo.md](docs/vistas/03-desarrollo.md) |
| Modelo de dominio y reglas por entidad | [docs/vistas/01-logica.md](docs/vistas/01-logica.md) |
| Qué construir | `specs/NNN-nombre/`, con el número del catálogo de [drivers.md](docs/drivers.md): CU-06 → `specs/006-reservar-boletas/` |
| Estándares de código y revisión | [docs/equipo/estandares.md](docs/equipo/estandares.md), [docs/equipo/checklist-revision.md](docs/equipo/checklist-revision.md) |

- Si el código contradice la spec, **gana la spec**.
- Si la spec parece incorrecta, incompleta o contradice un ADR, **detente y pregunta**. No la corrijas por tu cuenta.

## 2. Arquitectura

Hexagonal ([ADR-001](docs/adr/ADR-001-estilo-arquitectonico.md)).

- **Núcleo:** `src/backend/nucleo/`, con `dominio/` (entidades y reglas), `casos_uso/` (un archivo por caso de uso: son los puertos de entrada) y `puertos/` (puertos de salida).
- **Adaptadores:** `src/backend/adaptadores/entrada/` (API FastAPI) y `src/backend/adaptadores/salida/` (persistencia, pasarelas, mensajería, SIA, reloj, QR).
- **Regla de dependencia:** nada en `nucleo/` importa adaptadores, `fastapi`, `pydantic`, `sqlalchemy`, `datetime.now` ni librerías de proveedores. Verifícalo con los comandos de la [sección 4 de la vista de desarrollo](docs/vistas/03-desarrollo.md#4-regla-de-dependencia-verificable) antes de terminar.
- **Puertos:** clases abstractas (`abc.ABC`) o `typing.Protocol` [NECESITA ACLARACIÓN: el equipo no ha elegido; los ADR-005 y ADR-006 recomiendan `abc.ABC`. Hasta que se decida, usa `abc.ABC`].
- **Persistencia:** PostgreSQL con SQLAlchemy y Alembic, solo en `adaptadores/salida/persistencia/` ([ADR-006](docs/adr/ADR-006-persistencia.md)). Las entidades del dominio no heredan del ORM.
- **Tiempo:** siempre por el puerto `Reloj` ([ADR-007](docs/adr/ADR-007-reloj-como-puerto.md)). Nunca leas la hora del sistema en el núcleo.
- **Configuración:** los adaptadores se conectan en `src/backend/arranque.py` según el `.env` ([ADR-005](docs/adr/ADR-005-integracion-pasarelas-mensajeria.md), [.env.example](.env.example)).
- **Frontend:** Angular en `src/frontend/`. Solo consume la API y no contiene reglas de negocio ([ADR-003](docs/adr/ADR-003-frontend.md)).
- No crees puertos, adaptadores ni carpetas que no estén en la vista de desarrollo o en el `plan.md` de la tarea.

## 3. Convenciones

- **Python 3.12** con anotaciones de tipo en todas las funciones y clases.
- **Nombres en español** según el glosario de [arquitectura.md, sección 10](docs/arquitectura.md#10-glosario), sin tildes ni `ñ` en los identificadores.
- **DTO de entrada y salida** en cada caso de uso: clases simples del núcleo (por ejemplo, `dataclass`), no modelos de Pydantic. La API traduce entre sus esquemas y esos DTO ([ADR-002](docs/adr/ADR-002-backend.md)).
- **Errores:** el núcleo lanza excepciones de dominio; solo `adaptadores/entrada/api/errores.py` las traduce a HTTP ([estandares.md, sección 5](docs/equipo/estandares.md#5-manejo-de-errores)).
- **Clean Code y SOLID** (RT-11): funciones cortas, una responsabilidad por clase, dependencias por constructor.
- **Formateo y lint de Python:** Ruff [NECESITA ACLARACIÓN: `estandares.md` propone Ruff en lugar de Black; falta que el equipo lo confirme].
- **Angular** `<versión>` [NECESITA ACLARACIÓN: ¿qué versión de Angular se fija? Es la pregunta abierta del ADR-003], con un componente por caso de uso dentro de `admin/` o `comprador/`.

## 4. Forma de trabajar

1. **Una tarea de `tasks.md` por sesión.** Lee antes su `spec.md` y su `plan.md`.
2. Implementa solo lo que pide la tarea. **No inventes requisitos**: si falta algo, pregunta.
3. Si el comportamiento cambia, actualiza `spec.md` en el mismo commit.
4. Al terminar:
   - marca la tarea como hecha en `tasks.md`;
   - lista los archivos que cambiaste;
   - **detente** y espera la revisión humana.
5. Mensaje de commit: `T-CC-NN: descripción en presente`, donde `CC` es el número del caso de uso (por ejemplo, `T-06-04: Agrega el caso de uso ReservarBoletas`).
