# Tareas CU-01: Registrar evento en borrador con sus localidades

Autora: Mariana García · Revisa: Bairon Vásquez · Estado: borrador para revisión

Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md). Cada tarea es un sub-issue de máximo 4 horas y termina en un commit con su ID.

**ID de tarea:** `T-01-NN`, donde `01` es el número del caso de uso, como define [AGENTS.md](../../AGENTS.md) (sección 4).

**Estimaciones:** propuesta de la autora, que se ajusta en M8. Horas de la fila CU-01 en `drivers.md` 5.4: 6 h con spec, plan, tareas, implementación y validación incluidas.

| ID | Tarea | Responsable propuesto | Estimación | Iteración | Depende de | Escenarios |
|---|---|---|---|---|---|---|
| T-01-01 | Dominio `Evento` y `Localidad` con sus invariantes, excepción de validación y caso de uso `RegistrarEvento` | Sergio Velásquez | 1,5 h | 1 | TEC-01 | CU01-E01, E02, E04 a E08 |
| T-01-02 | Persistencia: modelos, mapeadores, repositorio y migración de evento y localidad, con guardado en una unidad de trabajo | Mariana García | 2 h | 1 | TEC-04, T-01-01 | CU01-E01, E06, E09 |
| T-01-03 | Endpoint de registro, esquemas de entrada y salida, y traducción del error de validación a HTTP | Mariana García | 1,5 h | 1 | TEC-05, T-01-01 | CU01-E01, E04 a E08 |
| T-01-04 | Formulario de registro en `admin/` con localidades dinámicas y cliente de la API | Bairon Vásquez | 2 h | 1 | TEC-06, T-01-03 | CU01-E01, E02, E04 |
| T-01-05 | Validar los escenarios y llenar `validacion.md` | Mariana García | 1 h | 1 | T-01-01 a T-01-04, TEC-07 | CU01-E01 a E09 |

**Total propuesto: 8 h**, frente a 6 h en `drivers.md`. La diferencia alimenta la reestimación de DP-03 y DP-07 de [priorizacion.md](../../docs/priorizacion.md).

[NECESITA ACLARACIÓN: ¿Sergio hace T-01-01? `roles.md` le asigna el núcleo; el resto de tareas sigue las áreas de `roles.md` (persistencia y API de administración: Mariana; frontend: Bairon).]
