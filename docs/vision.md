# Visión: sistema de boletería para los eventos culturales de la universidad

Autor: Bairon Vásquez · Custodio: Sergio Velásquez (gerente de desarrollo) · Equipo LasPalomas · Fecha: 27/11/2026 (cierre de la semana 0)

Fuente única de requisitos: el enunciado oficial del proyecto final. Lo que el enunciado no dice se registra como supuesto (S-xx) en la sección 6.

## 1. Problema u oportunidad

La universidad organiza conciertos, obras de teatro y conferencias abiertos a estudiantes, egresados y público general. Hoy las boletas se venden **en efectivo en una taquilla** y se controlan con **listas impresas**: hay filas largas, no hay una fuente única del cupo y se venden más boletas que cupos.

**Oportunidad:** vender en línea y cobrar por medios electrónicos, con el cupo controlado por el sistema. La pasarela de pago y el servicio de mensajería los elige el equipo y pueden cambiar en el futuro, por lo que deben poder cambiarse o integrarse sin modificar el dominio ni los casos de uso.

## 2. Objetivos de negocio

| ID | Objetivo medible | Atributo de calidad |
|---|---|---|
| OB-01 | **Cero sobreventa, también con compras simultáneas:** ninguna reserva ni venta supera el cupo disponible (aforo menos boletas pagadas y reservas vigentes), aunque varios compradores compitan por el último cupo. Concurrencia por definir (S-02). Verificado en v1.0 (11/12/2026) | Consistencia; rendimiento |
| OB-02 | **Venta en línea de punta a punta:** consultar la cartelera, reservar de 1 a 4 boletas, pagar y recibir las boletas con QR por notificación. Demostrado en v1.0 | Exactitud funcional; usabilidad |
| OB-03 | **Proveedores intercambiables:** cambiar de pasarela o de mensajería modifica **0 archivos** del dominio y de los casos de uso. Demostrado con dos pasarelas en v0.1 (04/12/2026) | Modificabilidad; interoperabilidad |
| OB-04 | **Cupo liberado a tiempo:** una reserva sin pago confirmado vence a los **10 minutos** y libera su cupo; desde la hora de inicio no se aceptan reservas ni pagos. Demostrado con reloj controlable | Corrección temporal; testabilidad |
| OB-05 | **Tarifas correctas:** el 100 % de las compras aplica el descuento del SIA (50 % estudiante, 30 % egresado, el mayor si es ambos) a una sola boleta por evento; las demás pagan precio completo | Exactitud funcional |

## 3. Alcance

| Parte | Qué SÍ incluye | Qué NO incluye |
|---|---|---|
| **Administración (organizador)** | Registrar un evento en borrador (nombre, fecha, hora de inicio, lugar, localidades con aforo y precio en COP). Publicarlo en la cartelera. Cancelarlo: sale de la cartelera, se anulan las reservas vigentes, se reembolsan las boletas pagadas y se notifica a los compradores | Modificar localidades de un evento publicado. Reportes de ventas. Varios organizadores con permisos (S-03) |
| **Usuario (comprador)** | Consultar la cartelera. Reservar de 1 a 4 boletas de una localidad (máximo 4 por evento). Vencimiento de la reserva a los 10 minutos. Cierre de la venta a la hora de inicio. Pago aprobado, rechazado o pendiente; confirmación tardía con reembolso automático. Descuento según el SIA. Boletas con código único, aleatorio y no consecutivo, y QR por notificación | Cuentas con contraseña. Venta en taquilla. Lectura de QR en la entrada. Reembolsos a solicitud del comprador |
| **Transversal** | Interfaz web para ambas partes sobre el mismo núcleo. Persistencia relacional. Script de datos de demostración. README | Diseño visual. Pruebas automatizadas. Integración con sistemas reales (S-06) |

## 4. Stakeholders

Poder e interés: estimación del equipo, pendiente de validar.

| Nombre / rol | Tipo | Preocupaciones y atributo de calidad | Poder / interés |
|---|---|---|---|
| Comprador (estudiante, egresado, público general) | Negocio | Comprar sin contraseña, con el descuento correcto, y recibir su QR. Usabilidad; exactitud funcional | Bajo / Alto |
| Organizador de eventos | Negocio | Registrar, publicar y cancelar eventos sin sobreventa. Consistencia | Medio / Alto |
| Universidad | Negocio | Cobro electrónico, sin filas ni sobreventa, proveedores intercambiables. Modificabilidad | Alto / Alto |
| Docente (Johnny Alexander Salazar Cardona) | Técnico | Exigencias arquitectónicas cumplidas; documentación coherente con el código. Trazabilidad | Alto / Alto |
| Equipo LasPalomas (Bairon Vásquez, Sergio Velásquez, Mariana García) | Técnico | Alcance viable con 3 personas; código que cada uno pueda explicar. Modificabilidad | Alto / Alto |
| SIA (sistema externo) | Técnico | Supuesto: consulta solo por documento (S-04, S-05). Interoperabilidad | Medio / Bajo |
| Pasarela de pago (sistema externo) | Técnico | Supuesto: maneja pagos pendientes y reembolsos (S-09). Interoperabilidad | Medio / Bajo |
| Servicio de mensajería (sistema externo) | Técnico | Supuesto: entrega boletas con QR por su canal (S-07). Interoperabilidad | Medio / Bajo |

## 5. Restricciones

Todas las impone el docente y no se negocian. Las tecnologías concretas **no** son restricciones: son decisiones del equipo justificadas en ADR.

| ID | Restricción |
|---|---|
| RT-01 | Estilo hexagonal o Clean Architecture, justificado en un ADR que compara ambos frente a los drivers; propuesto en la semana 0 y aceptado en la iteración 1. *Nota: el equipo propone arquitectura hexagonal en [ADR-001](adr/ADR-001-estilo-arquitectonico.md); las tecnologías se justifican en los ADR siguientes* |
| RT-02 | El núcleo (dominio y casos de uso) no depende de frameworks, base de datos, web ni proveedores y se comunica solo por puertos: ningún archivo del núcleo importa un adaptador |
| RT-03 | Persistencia en base de datos relacional, justificada en el ADR de persistencia |
| RT-04 | El tiempo es un puerto, con reloj del sistema y reloj controlable |
| RT-05 | La pasarela de pago y el servicio de mensajería se cambian por configuración, sin editar código y sin que ningún archivo del núcleo cambie en el historial de Git |
| RT-06 | Interfaz web con pantallas de administración y de usuario sobre el mismo núcleo; una API sola no basta |
| RT-07 | Cada elección tecnológica (backend, frontend, base de datos, integración con pasarelas, persistencia) se justifica en un ADR frente a los drivers |
| RT-08 | SDD con agente de IA, cuatro archivos por caso de uso y revisión humana (ver `AGENTS.md`) |
| RT-09 | Roles TSPi, tablero en GitHub Projects, pull requests revisados por alguien distinto del autor y actas de ceremonias |
| RT-10 | Semana 0 hasta el 27/11/2026; iteración 1 del 28/11 al 04/12 (v0.1); iteración 2 del 05/12 al 11/12 (v1.0); la v1.0 debe existir un día antes de la sustentación |
| RT-11 | Clean Code y SOLID, script de datos de demostración y README para instalar y ejecutar desde cero |

## 6. Supuestos y riesgos

### Supuestos

Todos se validan con el docente. Los marcados *provisional* son decisiones del equipo mientras tanto: **validar con el docente**.

| ID | Lo que el enunciado no dice | Supuesto |
|---|---|---|
| S-01 | Volumen | Se dimensiona para volumen de demostración |
| S-02 | Concurrencia | Varios compradores compiten por el último cupo y nunca se supera (OB-01); el número de compradores simultáneos está por definir |
| S-03 | Acceso del organizador | Al menos un organizador, cargado por el script de demostración; el mecanismo de acceso se decide en un ADR |
| S-04 | Datos del SIA | Dado un documento, el SIA indica estudiante, egresado, ambos o ninguno; no entrega más datos |
| S-05 | SIA sin respuesta o documento no encontrado | *Provisional:* se cobra la tarifa de público general y se avisa al comprador antes de pagar |
| S-06 | Sistemas externos | Se aceptan adaptadores simulados, como los define el enunciado |
| S-07 | Canal de notificación | El adaptador de mensajería define si se usa el correo o el celular |
| S-08 | Edición en borrador | El organizador puede editar un evento mientras está en borrador |
| S-09 | Reembolso | La pasarela ofrece reembolso sobre un pago aprobado |
| S-10 | Identidad del comprador | El número de documento identifica al comprador para el máximo de 4 boletas y el descuento |
| S-11 | Pago pendiente de un evento cancelado | *Provisional:* si la confirmación llega después de la cancelación, se reembolsa automáticamente y se notifica |
| S-12 | Confirmación tardía que supera 4 boletas | *Provisional:* si confirmar deja al comprador con más de 4 boletas en el evento, se reembolsa automáticamente y se notifica |
| S-13 | Redondeo | Los montos en COP son enteros, redondeados al peso |
| S-14 | Zona horaria | Vencimiento y cierre de la venta en hora de America/Bogota, obtenida del puerto Reloj |

### Riesgos

| ID | Riesgo | Objetivo | Mitigación |
|---|---|---|---|
| R-01 | **Capacidad y plazo:** 3 personas para cinco roles, v0.1 al 04/12 y v1.0 al 11/12; cada uno debe explicar su código | OB-02 | Matriz de priorización; tareas de 4 horas como máximo; áreas asignadas ([roles.md](equipo/roles.md)) |
| R-02 | Código (también del agente) que rompe la regla de dependencia o contradice un ADR | OB-03 | Lista de verificación; PR revisado por otro integrante; `AGENTS.md` en cada sesión |
| R-03 | Sobreventa por compras simultáneas | OB-01 | Escenario de concurrencia en `validacion.md`; integridad en el ADR de persistencia |
| R-04 | Errores con pagos pendientes, doble pago o confirmaciones tardías | OB-01, OB-04 | Escenarios por regla con reloj controlable |
| R-05 | Sistemas externos con un contrato distinto al supuesto | OB-03, OB-05 | Acceso solo por puertos; simulados (S-06) |
| R-07 | Documentación que no coincide con el código | OB-03 | Custodia de Sergio; revisión cruzada; `arquitectura.md` actualizado en la iteración 2 |
| R-09 | El ADR del estilo cambia tras la clase de hexagonal | OB-03 | La vista de desarrollo se ajusta si cambia |

*R-06 (plazo) y R-08 (autoría) se fusionaron en R-01; sus ID no se reutilizan.*
