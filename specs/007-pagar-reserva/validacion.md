# Validación CU-07: Pagar reserva

Revisa: Mariana García (gerente de calidad y proceso) · Estado: pendiente, se llena al implementar

Spec: [spec.md](spec.md). Formato según la sección 7 de [estandares.md](../../docs/equipo/estandares.md): un escenario por fila, sin omitir ninguno. Un escenario sin evidencia cuenta como no validado.

**Datos de demostración:** los carga el script de TEC-07 (compradores de prueba con respuesta aprobado, rechazado y pendiente, y reservas vigentes creadas con CU-06). Los escenarios con reloj controlable (CU07-E06, E07 y E08) indican la hora simulada usada y se ejecutan con `RELOJ=controlable`. CU07-E12 se ejecuta con `PASARELA_PAGO=simulada_a` y luego `simulada_b`.

| Escenario | Resultado (cumple / no cumple, obtenido frente a esperado) | Evidencia (captura, consola o registro, con fecha) |
|---|---|---|
| CU07-E01 Pago aprobado | Pendiente | Pendiente |
| CU07-E02 Pago rechazado | Pendiente | Pendiente |
| CU07-E03 Reintento tras un rechazo | Pendiente | Pendiente |
| CU07-E04 Pago pendiente | Pendiente | Pendiente |
| CU07-E05 Nuevo intento con un pago pendiente | Pendiente | Pendiente |
| CU07-E06 Reserva vencida (hora simulada: pendiente) | Pendiente | Pendiente |
| CU07-E07 Límite del plazo, a los 9:59 y a los 10:00 (hora simulada: pendiente) | Pendiente | Pendiente |
| CU07-E08 Cierre de la venta (hora simulada: pendiente) | Pendiente | Pendiente |
| CU07-E09 Dos pagos simultáneos | Pendiente | Pendiente |
| CU07-E10 Reserva ya pagada | Pendiente | Pendiente |
| CU07-E11 Reserva inexistente | Pendiente | Pendiente |
| CU07-E12 Cambio de pasarela por configuración | Pendiente | Pendiente |

**Regla de dependencia:** los comandos de la sección 4 de la [vista de desarrollo](../../docs/vistas/03-desarrollo.md) devuelven vacío: pendiente.
