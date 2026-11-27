Closes #

**Tarea:** T-CC-NN

## Qué cambia

<!-- Describe el cambio en pocas líneas: qué se agrega, modifica o elimina. -->

## Cómo se probó

<!-- Escenario de spec.md con el que se validó el cambio (caso de uso y escenario). -->

- Escenario:
- Resultado:

## Lista de verificación

Versión resumida de [checklist-revision.md](../docs/equipo/checklist-revision.md). El revisor marca **Sí** en cada ítem; un ítem que no se cumple se explica en un comentario.

**1. Regla de dependencia**
- [ ] Nada en `src/backend/nucleo/` importa adaptadores, `fastapi`, `pydantic`, `sqlalchemy`, `datetime.now` ni librerías de proveedores
- [ ] `grep -rnE "import (fastapi|sqlalchemy|pydantic)|from (fastapi|sqlalchemy|pydantic|adaptadores)|datetime.now" src/backend/nucleo` devuelve vacío

**2. Trazabilidad**
- [ ] `Closes #` en la descripción
- [ ] ID de la tarea en el commit, y una tarea por commit
- [ ] `spec.md` actualizado en el mismo commit si cambia el comportamiento

**3. Arquitectura**
- [ ] Respeta los ADR y la vista de desarrollo, sin inventar componentes
- [ ] Angular sin reglas de negocio

**4. Clean Code y SOLID**
- [ ] Nombres del glosario, funciones cortas, una responsabilidad
- [ ] Sin código muerto ni secretos

**5. Revisión**
- [ ] Revisor distinto del autor
- [ ] Lo generado por el agente fue leído y entendido
