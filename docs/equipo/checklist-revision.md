# Lista de verificación de revisión de pull requests

Autora: Mariana García (gerente de calidad y proceso) · Equipo LasPalomas · Fecha: 27/11/2026

Esta lista se usa en **cada pull request**, como piden las normas del equipo ([normas.md](normas.md)) y la regla de revisión cruzada de [roles.md](roles.md). El revisor responde cada ítem con **Sí** o **No**; un **No** se explica en un comentario del PR. Los grupos van en orden: si el grupo 1 falla, no se sigue con los demás hasta corregirlo.

## 1. Regla de dependencia (primero)

El núcleo (dominio y casos de uso) no depende de adaptadores, frameworks, base de datos ni proveedores (RT-02, RT-04, RT-05).

| # | Ítem | Sí | No |
|---|---|---|---|
| 1.1 | Ningún archivo de `src/backend/nucleo/` importa adaptadores | ☐ | ☐ |
| 1.2 | Ningún archivo de `src/backend/nucleo/` importa `fastapi`, `pydantic` ni `sqlalchemy` | ☐ | ☐ |
| 1.3 | Ningún archivo de `src/backend/nucleo/` llama a `datetime.now`: el tiempo se obtiene por el puerto Reloj | ☐ | ☐ |
| 1.4 | Ningún archivo de `src/backend/nucleo/` importa librerías de proveedores (pasarela, mensajería, SIA) | ☐ | ☐ |
| 1.5 | El comando de verificación devuelve vacío | ☐ | ☐ |

Comando de verificación (debe devolver vacío):

```bash
grep -rnE "import (fastapi|sqlalchemy|pydantic)|from (fastapi|sqlalchemy|pydantic|adaptadores)|datetime.now" src/backend/nucleo
```

El comando no detecta las librerías de proveedores (ítem 1.4): esa parte se revisa leyendo los imports del PR.

## 2. Trazabilidad

| # | Ítem | Sí | No |
|---|---|---|---|
| 2.1 | La descripción del PR tiene `Closes #` con el número del issue | ☐ | ☐ |
| 2.2 | Cada commit lleva el ID de la tarea (`T-CC-NN`, con `CC` el número del caso de uso: [AGENTS.md](../../AGENTS.md)) | ☐ | ☐ |
| 2.3 | Hay una tarea por commit | ☐ | ☐ |
| 2.4 | Si cambia el comportamiento, `spec.md` está actualizado en el mismo commit | ☐ | ☐ |

## 3. Arquitectura

| # | Ítem | Sí | No |
|---|---|---|---|
| 3.1 | El cambio respeta los ADR vigentes (`docs/adr/`) | ☐ | ☐ |
| 3.2 | El cambio respeta la vista de desarrollo (`docs/vistas/`): núcleo, puertos y adaptadores en su lugar | ☐ | ☐ |
| 3.3 | No inventa componentes, puertos ni adaptadores que no estén en los ADR o en las vistas; si hace falta uno nuevo, hay ADR o cambio de la vista en el mismo PR | ☐ | ☐ |
| 3.4 | Angular no contiene reglas de negocio: las reglas viven en el núcleo y el frontend solo las consume por la API | ☐ | ☐ |

## 4. Clean Code y SOLID (RT-11)

| # | Ítem | Sí | No |
|---|---|---|---|
| 4.1 | Los nombres siguen el glosario de [arquitectura.md](../arquitectura.md) [NECESITA ACLARACIÓN: `arquitectura.md` aún no existe; el glosario queda pendiente de Sergio] | ☐ | ☐ |
| 4.2 | Las funciones son cortas | ☐ | ☐ |
| 4.3 | Cada clase y función tiene una sola responsabilidad | ☐ | ☐ |
| 4.4 | No hay código muerto ni comentado | ☐ | ☐ |
| 4.5 | No hay secretos en el código ni en el commit: claves y credenciales van en el `.env`, no en el repositorio | ☐ | ☐ |

## 5. Revisión

| # | Ítem | Sí | No |
|---|---|---|---|
| 5.1 | El revisor es distinto del autor | ☐ | ☐ |
| 5.2 | Lo generado por el agente de IA fue leído y entendido por quien lo integra (RT-08) | ☐ | ☐ |
| 5.3 | Si el agente generó código que rompe la regla de dependencia o contradice un ADR, se corrigió el código o se escribió un ADR nuevo; no se dejó la contradicción | ☐ | ☐ |
