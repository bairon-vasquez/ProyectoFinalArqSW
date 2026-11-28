# Validación CU-05: Consultar cartelera

Revisa: Mariana García (gerente de calidad y proceso) · Estado: pendiente, se llena al implementar

Spec: [spec.md](spec.md). Formato según la sección 7 de [estandares.md](../../docs/equipo/estandares.md): un escenario por fila, sin omitir ninguno. Un escenario sin evidencia cuenta como no validado.

**Datos de demostración:** los carga el script de TEC-07 (organizador, eventos con localidades y reservas de prueba). Los escenarios con reloj controlable (CU05-E05, CU05-E08) indican la hora simulada usada; para ellos, `RELOJ=controlable` en el `.env`.

| Escenario | Resultado (cumple / no cumple, obtenido frente a esperado) | Evidencia (captura, consola o registro, con fecha) |
|---|---|---|
| CU05-E01 Eventos publicados en la cartelera | Pendiente | Pendiente |
| CU05-E02 Un borrador no aparece | Pendiente | Pendiente |
| CU05-E03 Un evento cancelado no aparece | Pendiente | Pendiente |
| CU05-E04 El cupo descuenta pagadas y reservas vigentes | Pendiente | Pendiente |
| CU05-E05 El vencimiento libera el cupo (hora simulada: pendiente) | Pendiente | Pendiente |
| CU05-E06 Localidad agotada | Pendiente | Pendiente |
| CU05-E07 Cartelera vacía | Pendiente | Pendiente |
| CU05-E08 Evento ya iniciado (hora simulada: pendiente) | Pendiente | Pendiente |
| CU05-E09 Consulta sin identificarse | Pendiente | Pendiente |

**Regla de dependencia:** los comandos de la sección 4 de la [vista de desarrollo](../../docs/vistas/03-desarrollo.md) devuelven vacío: pendiente.
