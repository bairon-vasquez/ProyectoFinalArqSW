# Validación CU-06: Reservar boletas

Autor: Sergio Velásquez · Revisa: Mariana García (gerente de calidad y proceso) · Estado: pendiente, se llena al implementar

Spec: [spec.md](spec.md). Formato según la sección 7 de [estandares.md](../../docs/equipo/estandares.md): un escenario por fila, sin omitir ninguno. Un escenario sin evidencia cuenta como no validado.

**Datos de demostración:** los carga el script de TEC-07: eventos publicados, en borrador y cancelados con sus localidades (una con precio 15.005 COP para CU06-E18), y compradores de prueba con los mismos documentos que el archivo del SIA simulado (estudiante, egresado, ambos, público general y "sin respuesta"). Los escenarios con reloj controlable (CU06-E11, E16 y E17) indican la hora simulada usada y se ejecutan con `RELOJ=controlable`.

**Concurrencia (CU06-E13):** 10 solicitudes en paralelo sobre una localidad con cupo 1, cada una con un documento distinto, repetido 5 veces. Comando de referencia (*propuesta*; la ruta y el cuerpo dependen del contrato OpenAPI que fija T-06-07):

```bash
seq 1 10 | xargs -P 10 -I{} curl -s -o /dev/null -w "%{http_code}\n" \
  -X POST "<url de la API>/<ruta de reservas>" \
  -H "Content-Type: application/json" \
  -d '{"localidad_id": "<id>", "cantidad": 1, "documento": "prueba-{}", "correo": "prueba{}@ejemplo.com", "celular": "<celular>"}' \
  | sort | uniq -c
```

Resultado esperado en cada repetición: un código de éxito y nueve de cupo agotado. Después se consulta en la cartelera que el cupo de la localidad es 0, nunca negativo. CU06-E14 usa el mismo comando con 2 solicitudes del mismo documento en dos localidades del mismo evento.

| Escenario | Resultado (cumple / no cumple, obtenido frente a esperado) | Evidencia (captura, consola o registro, con fecha) |
|---|---|---|
| CU06-E01 Reserva de público general | Pendiente | Pendiente |
| CU06-E02 Descuento de estudiante | Pendiente | Pendiente |
| CU06-E03 Descuento de egresado | Pendiente | Pendiente |
| CU06-E04 Estudiante y egresado | Pendiente | Pendiente |
| CU06-E05 Un solo descuento por evento | Pendiente | Pendiente |
| CU06-E06 SIA sin respuesta | Pendiente | Pendiente |
| CU06-E07 Documento no encontrado en el SIA | Pendiente | Pendiente |
| CU06-E08 Cantidad fuera de rango | Pendiente | Pendiente |
| CU06-E09 Máximo de 4 boletas por evento | Pendiente | Pendiente |
| CU06-E10 El máximo suma todas las localidades | Pendiente | Pendiente |
| CU06-E11 Una reserva vencida no cuenta (hora simulada: pendiente) | Pendiente | Pendiente |
| CU06-E12 Cupo insuficiente | Pendiente | Pendiente |
| CU06-E13 Último cupo con compras simultáneas (5 repeticiones) | Pendiente | Pendiente |
| CU06-E14 Mismo comprador, dos localidades a la vez | Pendiente | Pendiente |
| CU06-E15 Evento no disponible | Pendiente | Pendiente |
| CU06-E16 Cierre de la venta (hora simulada: pendiente) | Pendiente | Pendiente |
| CU06-E17 Vencimiento a los 10 minutos, a los 9:59 y a los 10:00 (hora simulada: pendiente) | Pendiente | Pendiente |
| CU06-E18 Redondeo al peso | Pendiente | Pendiente |
| CU06-E19 Datos incompletos | Pendiente | Pendiente |
| CU06-E20 Localidad inexistente | Pendiente | Pendiente |

**Regla de dependencia:** los comandos de la sección 4 de la [vista de desarrollo](../../docs/vistas/03-desarrollo.md) devuelven vacío: pendiente.
