# Tareas CU-06: Reservar boletas

Autor: Sergio Velásquez · Revisa: Mariana García ([roles.md](../../docs/equipo/roles.md)) · Estado: borrador para revisión

Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md). Cada tarea es un sub-issue de máximo 4 horas y termina en un commit con su ID.

**ID de tarea:** se usa `T-06-NN`, donde `06` es el número del caso de uso, igual que en CU-05 y CU-07 [NECESITA ACLARACIÓN: ¿qué significa `CC` en `T-CC-NN`? Es la pregunta abierta de `estandares.md`].

**Estimaciones:** propuesta del autor, que Mariana ajusta en M8. Horas de la fila CU-06 en `drivers.md` 5.4: 10 h con spec, plan, tareas, implementación y validación incluidas.

| ID | Tarea | Responsable propuesto | Estimación | Iteración | Depende de | Escenarios |
|---|---|---|---|---|---|---|
| T-06-01 | Dominio: `Comprador`, `TipoPublico`, `Localidad.cupo_disponible`, `Evento.venta_abierta` y estado `PUBLICADO` | Sergio Velásquez | 2 h | 1 | TEC-01 | CU06-E12, E15, E16 |
| T-06-02 | Dominio: `Reserva` (cantidad de 1 a 4, `vence_en`, `esta_vigente`, `con_descuento`, monto con redondeo al peso) y excepciones de dominio de la reserva | Sergio Velásquez | 3 h | 1 | T-06-01 | CU06-E01 a E05, E08, E17, E18 |
| T-06-03 | Puerto `ConsultaSIA` y métodos de repositorio de la reserva en `repositorios.py` | Sergio Velásquez | 1 h | 1 | TEC-01 | — |
| T-06-04 | Caso de uso `ReservarBoletas`: SIA fuera de la transacción, bloqueos en orden, máximo de 4, cupo y aviso de tarifa general | Sergio Velásquez | 3 h | 1 | T-06-02, T-06-03, TEC-03 | CU06-E01 a E17 |
| T-06-05 | Persistencia de comprador y reserva: modelos, mapeo, migración con el `CHECK` de 1 a 4 y repositorios con bloqueo y conteos con `ahora` | Mariana García | 4 h | 1 | TEC-04, T-06-03 | CU06-E09 a E14, E17 |
| T-06-06 | Adaptador `SIASimulado`: lectura de `SIA_DATOS`, documento no encontrado, documento "sin respuesta" y línea de registro | Bairon Vásquez | 2 h | 1 | TEC-02, T-06-03 | CU06-E02 a E07 |
| T-06-07 | Endpoint de reserva, esquemas y traducción de errores a HTTP | [NECESITA ACLARACIÓN: ¿quién construye la API del comprador? `roles.md` solo asigna la de administración] | 2 h | 1 | TEC-05, T-06-04 | CU06-E01 a E20 |
| T-06-08 | Formulario de reserva en `comprador/` con el cliente de la API | Bairon Vásquez | 3 h | 1 | TEC-06, T-06-07 | CU06-E01, E06, E08, E12, E19 |
| T-06-09 | Archivo del SIA simulado y compradores de prueba en el script de datos | Bairon Vásquez | 1 h | 1 | TEC-07, T-06-06 | CU06-E02 a E07 |
| T-06-10 | Validar los escenarios, incluida la concurrencia, y llenar `validacion.md` | Sergio Velásquez | 3 h | 1 | T-06-01 a T-06-09 | CU06-E01 a E20 |

**Total propuesto: 24 h**, frente a 10 h en `drivers.md`. La diferencia alimenta la reestimación de DP-03 y DP-07 de [priorizacion.md](../../docs/priorizacion.md). Por persona: Sergio 12 h, Bairon 6 h, Mariana 4 h y 2 h sin responsable (T-06-07).
