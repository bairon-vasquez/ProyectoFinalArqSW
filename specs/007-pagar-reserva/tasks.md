# Tareas CU-07: Pagar reserva

Autor: Bairon Vásquez · Revisa: [NECESITA ACLARACIÓN: ¿quién revisa los `tasks.md` de Bairon? Es la duda abierta de `roles.md`] · Estado: borrador para revisión

Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md). Cada tarea es un sub-issue de máximo 4 horas y termina en un commit con su ID.

**ID de tarea:** se usa `T-07-NN`, donde `07` es el número del caso de uso [NECESITA ACLARACIÓN: ¿qué significa `CC` en `T-CC-NN`? Es la pregunta abierta de `estandares.md`; aquí se asume el número del caso de uso].

**Estimaciones:** propuesta del autor, que Mariana ajusta en M8. Horas de la fila CU-07 en `drivers.md` 5.3: 8 h con spec, plan, tareas, implementación y validación incluidas.

| ID | Tarea | Responsable propuesto | Estimación | Iteración | Depende de | Escenarios |
|---|---|---|---|---|---|---|
| T-07-01 | Dominio: `Pago` con sus estados y `esta_activo()`, y las excepciones de dominio de pago | Sergio Velásquez | 1,5 h | 1 | TEC-01 | CU07-E05, E10, E11 |
| T-07-02 | Caso de uso `PagarReserva`: validaciones, dos transacciones y resultado | Sergio Velásquez | 3 h | 1 | T-07-01, TEC-03, CU-06 | CU07-E01 a E08, E10, E11 |
| T-07-03 | Persistencia del pago: `RepositorioPagos`, modelo, mapeo y migración con el índice único parcial | Mariana García | 3 h | 1 | TEC-04, T-07-01 | CU07-E05, E09, E10 |
| T-07-04 | Adaptador `PasarelaSimuladaA`: respuestas por documento, referencia `A-` y línea de registro | Bairon Vásquez | 2 h | 1 | TEC-01, TEC-02 | CU07-E01, E02, E04, E12 |
| T-07-05 | Adaptador `PasarelaSimuladaB`: igual que A, con referencia `B-` y su archivo de respuestas | Bairon Vásquez | 1,5 h | 1 | T-07-04 | CU07-E12 |
| T-07-06 | Endpoint de pago, esquemas y traducción de errores a HTTP | [NECESITA ACLARACIÓN: ¿quién construye la API del comprador? `roles.md` solo asigna la de administración] | 2 h | 1 | TEC-05, T-07-02 | CU07-E01 a E11 |
| T-07-07 | Pantalla de pago en `comprador/` con el cliente de la API | Bairon Vásquez | 3 h | 1 | TEC-06, T-07-06 | CU07-E01, E02, E04, E05 |
| T-07-08 | Compradores de prueba y archivos de respuestas de A y B en el script de datos | Bairon Vásquez | 1 h | 1 | TEC-07, T-07-04, T-07-05 | CU07-E01, E02, E04 |
| T-07-09 | Validar los escenarios y llenar `validacion.md` | Bairon Vásquez | 2 h | 1 | T-07-01 a T-07-08 | CU07-E01 a E12 |

**Total propuesto: 19 h**, frente a 8 h en `drivers.md`. La diferencia alimenta la reestimación de DP-03 y DP-07 de [priorizacion.md](../../docs/priorizacion.md). La carga de Bairon en estas tareas es de 9,5 h; el núcleo es de Sergio y la persistencia de Mariana, según [roles.md](../../docs/equipo/roles.md).
