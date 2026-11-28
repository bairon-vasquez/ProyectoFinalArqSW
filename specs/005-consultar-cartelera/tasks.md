# Tareas CU-05: Consultar cartelera

Autor: Bairon Vásquez · Revisa: [NECESITA ACLARACIÓN: ¿quién revisa los `tasks.md` de Bairon? Es la duda abierta de `roles.md`] · Estado: borrador para revisión

Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md). Cada tarea es un sub-issue de máximo 4 horas y termina en un commit con su ID.

**ID de tarea:** se usa `T-05-NN`, donde `05` es el número del caso de uso [NECESITA ACLARACIÓN: ¿qué significa `CC` en `T-CC-NN`? Es la pregunta abierta de `estandares.md`; aquí se asume el número del caso de uso].

**Estimaciones:** propuesta del autor, que Mariana ajusta en M8. Horas de la fila CU-05 en `drivers.md` 5.3: 3 h con spec, plan, tareas, implementación y validación incluidas.

| ID | Tarea | Responsable propuesto | Estimación | Iteración | Depende de | Escenarios |
|---|---|---|---|---|---|---|
| T-05-01 | Caso de uso `ConsultarCartelera` con las reglas del dominio (cupo, evento publicado y venta abierta) | Sergio Velásquez | 1,5 h | 1 | TEC-01, TEC-03, CU-03 | CU05-E01 a E04, E06, E08 |
| T-05-02 | Repositorios: leer eventos publicados y contar boletas pagadas y en reservas vigentes por localidad, con la hora recibida | Mariana García | 2 h | 1 | TEC-04, T-05-01 | CU05-E04, E05 |
| T-05-03 | Endpoint de cartelera y esquemas de respuesta en `rutas_comprador` | [NECESITA ACLARACIÓN: ¿quién construye la API del comprador? `roles.md` solo asigna la de administración] | 1 h | 1 | TEC-05, T-05-01 | CU05-E01, E07, E09 |
| T-05-04 | Pantalla de cartelera en `comprador/` con el cliente de la API | Bairon Vásquez | 2 h | 1 | TEC-06, T-05-03 | CU05-E01, E06, E07 |
| T-05-05 | Validar los escenarios y llenar `validacion.md` | Bairon Vásquez | 1 h | 1 | T-05-01 a T-05-04, TEC-07 | CU05-E01 a E09 |

**Total propuesto: 7,5 h**, frente a 3 h en `drivers.md`. La diferencia alimenta la reestimación de DP-03 y DP-07 de [priorizacion.md](../../docs/priorizacion.md).
