# Estándares de desarrollo

Autora: Mariana García (gerente de calidad y proceso) · Equipo LasPalomas · Fecha: 27/11/2026

Aplican a todo el código del repositorio: backend Python 3.12 + FastAPI ([ADR-002](../adr/ADR-002-backend.md)), frontend Angular ([ADR-003](../adr/ADR-003-frontend.md)) y PostgreSQL con SQLAlchemy y Alembic ([ADR-004](../adr/ADR-004-base-de-datos.md)). Cada pull request se revisa con la [lista de verificación](checklist-revision.md).

## 1. Ramas y commits

| Elemento | Estándar | Ejemplo |
|---|---|---|
| Rama | `feature/T-CC-NN-descripcion`: ID de la tarea y descripción corta en minúsculas, con guiones, sin tildes | `feature/T-CC-NN-reservar-boletas` |
| Commit | `T-CC-NN: descripción en presente` | `T-CC-NN: Valida el máximo de 4 boletas por evento` |
| Granularidad | Una tarea por commit; si cambia el comportamiento, `spec.md` va en el mismo commit | |
| Integración | Todo cambio entra por pull request, con la plantilla de `.github/pull_request_template.md`, revisado por alguien distinto del autor ([normas.md](normas.md)) | |

[NECESITA ACLARACIÓN: ¿qué significa `CC` en `T-CC-NN`? El formato no está definido en el repositorio.]

## 2. Formateo y lint

| Parte | Herramienta | Regla |
|---|---|---|
| Python | Ruff (formateo y lint en una sola herramienta) [NECESITA ACLARACIÓN: ¿Ruff o Black? Propongo Ruff porque reemplaza a las dos; falta que el equipo lo confirme] | Sin avisos antes de abrir el PR |
| Tipos en Python | [NECESITA ACLARACIÓN: ¿el equipo adopta `mypy` o `pyright`? Es la pregunta abierta de C6 en el ADR-002] | |
| Angular | ESLint (lint) y Prettier (formateo) [NECESITA ACLARACIÓN: ¿ESLint y Prettier se confirman? Se tomaron de tu lista de opciones] | Sin avisos antes de abrir el PR |
| Versiones | Python 3.12; Angular `<versión>` [NECESITA ACLARACIÓN: ¿qué versión de Angular, de Node y de Angular CLI se fijan? Es la misma pregunta abierta del ADR-003] | Se fijan en el README |

## 3. Nombres

- Los nombres del dominio van **en español**, según el glosario de [arquitectura.md](../arquitectura.md): `Reserva`, `Boleta`, `Localidad`. Un mismo concepto tiene siempre el mismo nombre en código, base de datos, API y pantallas. [NECESITA ACLARACIÓN: `arquitectura.md` aún no existe; el glosario queda pendiente de Sergio.]
- Python: `snake_case` para módulos, funciones y variables; `PascalCase` para clases. Angular: convenciones de la guía oficial de estilo del framework.
- Los identificadores no llevan tildes ni `ñ`. Los textos que ve el usuario sí las llevan.
- Tablas y columnas de PostgreSQL: `snake_case`, en español, con los mismos nombres del dominio.

## 4. Estructura de carpetas

La estructura sigue el estilo hexagonal: núcleo, puertos y adaptadores en `src/backend/`, y el frontend en un proyecto aparte. El detalle vive en la vista de desarrollo: [vistas/03-desarrollo.md](../vistas/03-desarrollo.md). [NECESITA ACLARACIÓN: la vista aún no existe; ¿se confirma esa ruta?]

Reglas que no se negocian (RT-02):

- Nada en `src/backend/nucleo/` importa adaptadores, `fastapi`, `pydantic`, `sqlalchemy`, `datetime.now` ni librerías de proveedores. El tiempo se obtiene por el puerto Reloj.
- FastAPI y Pydantic solo en los adaptadores de entrada ([ADR-002](../adr/ADR-002-backend.md)). SQLAlchemy y Alembic solo en el adaptador de persistencia ([ADR-004](../adr/ADR-004-base-de-datos.md)).
- Angular no contiene reglas de negocio y solo habla con el backend por la API REST ([ADR-003](../adr/ADR-003-frontend.md)).

## 5. Manejo de errores

1. El **núcleo lanza excepciones de dominio**: clases propias, con nombres del glosario, que no importan nada de FastAPI ni de HTTP.
2. El **adaptador de la API las traduce a códigos HTTP** en un solo lugar (manejadores de excepciones de FastAPI). Ningún caso de uso conoce un código HTTP.
3. Los errores de formato de la petición (campos faltantes, tipos incorrectos) los valida el adaptador con Pydantic antes de llegar al núcleo.
4. La respuesta de error tiene siempre la misma forma y no expone trazas ni detalles internos.
5. La tabla excepción → código HTTP se define en cada `plan.md` y queda documentada en el contrato OpenAPI. [NECESITA ACLARACIÓN: ¿Sergio fija la lista de códigos en arquitectura.md o cada `plan.md` la define?]

## 6. Contrato de la API

El contrato es el documento **OpenAPI** que FastAPI genera a partir del código. Cada endpoint declara su esquema de entrada y salida y los códigos de error que puede devolver. Angular consume ese contrato. Si un endpoint cambia, el cambio en el contrato va en el mismo commit.

## 7. Contenido de `validacion.md`

Cada caso de uso tiene su `validacion.md`, revisado según [roles.md](roles.md). Debe incluir **todos los escenarios de `spec.md`**, uno por fila:

| Escenario (ID de `spec.md`) | Resultado | Evidencia |
|---|---|---|
| Nombre o ID del escenario tal como aparece en `spec.md` | Cumple / No cumple, con el resultado obtenido frente al esperado | Captura de pantalla, salida de consola o registro (log), con fecha |

- No se omite ningún escenario: uno sin evidencia cuenta como no validado.
- No se piden pruebas automatizadas; la validación se hace escenario por escenario (enunciado).
- Los escenarios con reloj controlable (vencimiento a los 10 minutos, cierre de la venta) indican la hora simulada que se usó.
