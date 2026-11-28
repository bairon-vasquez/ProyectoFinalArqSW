# Validación CU-03: Publicar evento

Autora: Mariana García · Revisa: Sergio Velásquez · Estado: pendiente, se llena al implementar

Spec: [spec.md](spec.md). Formato según la sección 7 de [estandares.md](../../docs/equipo/estandares.md): un escenario por fila, sin omitir ninguno. Un escenario sin evidencia cuenta como no validado.

**Datos de demostración:** los carga el script de TEC-07 (organizador y eventos en borrador). CU03-E02 y CU03-E03 necesitan CU-05 y CU-06 construidos; CU03-E06 necesita CU-04 (si no se construye, queda como no validado, spec P-06); CU03-E04 se comprueba como dice la spec P-05. Para CU03-E08 se reinicia el backend y se consulta la base de datos; la evidencia es la salida de la consulta.

| Escenario | Resultado (cumple / no cumple, obtenido frente a esperado) | Evidencia (captura, consola o registro, con fecha) |
|---|---|---|
| CU03-E01 Publicar un borrador | Pendiente | Pendiente |
| CU03-E02 El evento publicado aparece en la cartelera | Pendiente | Pendiente |
| CU03-E03 El evento publicado admite reservas | Pendiente | Pendiente |
| CU03-E04 Las localidades no se modifican tras publicar | Pendiente | Pendiente |
| CU03-E05 Publicar un evento ya publicado | Pendiente | Pendiente |
| CU03-E06 Un evento cancelado no se publica | Pendiente | Pendiente |
| CU03-E07 Evento inexistente | Pendiente | Pendiente |
| CU03-E08 El estado se guarda | Pendiente | Pendiente |
| CU03-E09 El organizador elige entre sus borradores | Pendiente | Pendiente |

**Regla de dependencia:** los comandos de la sección 4 de la [vista de desarrollo](../../docs/vistas/03-desarrollo.md) devuelven vacío: pendiente.
