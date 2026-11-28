# Tareas CU-03: Publicar evento

Autora: Mariana García · Revisa: Bairon Vásquez · Estado: borrador para revisión

Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md). Cada tarea es un sub-issue de máximo 4 horas y termina en un commit con su ID.

**ID de tarea:** `T-03-NN`, donde `03` es el número del caso de uso, como define [AGENTS.md](../../AGENTS.md) (sección 4).

**Estimaciones:** propuesta de la autora, que se ajusta en M8. Horas de la fila CU-03 en `drivers.md` 5.4: 2 h con spec, plan, tareas, implementación y validación incluidas.

| ID | Tarea | Responsable propuesto | Estimación | Iteración | Depende de | Escenarios |
|---|---|---|---|---|---|---|
| T-03-01 | `Evento.publicar()` con sus comprobaciones, las excepciones de dominio y el caso de uso `PublicarEvento` (publicar y listar borradores) | Sergio Velásquez | 1 h | 1 | TEC-01, T-01-01 | CU03-E01, E04 a E07, E09 |
| T-03-02 | Repositorio: obtener un evento por identificador, guardar su estado y listar los borradores | Mariana García | 1 h | 1 | TEC-04, T-01-02, T-03-01 | CU03-E01, E08, E09 |
| T-03-03 | Endpoints de publicación y de la lista de borradores, esquemas y traducción de errores a HTTP | Mariana García | 1 h | 1 | TEC-05, T-03-01 | CU03-E01, E05 a E07, E09 |
| T-03-04 | Pantalla de borradores con la acción de publicar en `admin/` y cliente de la API | Bairon Vásquez | 1,5 h | 1 | TEC-06, T-03-03 | CU03-E01, E05, E09 |
| T-03-05 | Validar los escenarios y llenar `validacion.md` | Mariana García | 1 h | 1 | T-03-01 a T-03-04, TEC-07; CU-05 y CU-06 para E02 y E03 | CU03-E01 a E09 |

**Total propuesto: 5,5 h**, frente a 2 h en `drivers.md`. La diferencia alimenta la reestimación de DP-03 y DP-07 de [priorizacion.md](../../docs/priorizacion.md).

[NECESITA ACLARACIÓN: ¿Sergio hace T-03-01? `roles.md` le asigna el núcleo; el resto de tareas sigue las áreas de `roles.md` (persistencia y API de administración: Mariana; frontend: Bairon).]
