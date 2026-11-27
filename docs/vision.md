# Visión: sistema de boletería para los eventos culturales de la universidad

Responsable: Bairon Vásquez · Equipo LasPalomas · Fecha: 27/11/2026 (cierre de la semana 0)

Fuente única de requisitos: el enunciado oficial del proyecto final. Lo que el enunciado no dice se registra como supuesto (S-xx) en la sección 6.

## 1. Problema u oportunidad

La universidad organiza conciertos, obras de teatro y conferencias abiertos a estudiantes, egresados y público general. Hoy las boletas se venden **en efectivo en una taquilla** y se controlan con **listas impresas**.

| Situación actual | Por qué es insatisfactoria |
|---|---|
| Venta solo presencial, en efectivo | Obliga al comprador a desplazarse; la universidad no puede cobrar por medios electrónicos |
| Filas largas en la taquilla | Mala experiencia para el comprador y carga operativa para la universidad |
| Control con listas impresas | No hay una fuente única del cupo disponible |
| Se venden más boletas que cupos (sobreventa) | Compradores con boleta que no pueden entrar; conflicto con el organizador |

**Oportunidad:** vender en línea y cobrar por medios electrónicos, con el cupo controlado por el sistema. La universidad deja libre la elección de la pasarela de pago y del servicio de mensajería, y ambos pueden cambiar en el futuro. Por eso el sistema debe estar estructurado para cambiarlos o integrarlos fácilmente, sin modificar el dominio ni los casos de uso.

## 2. Objetivos de negocio

| ID | Objetivo medible | Atributo de calidad que implica |
|---|---|---|
| OB-01 | **Cero sobreventa:** ninguna reserva ni venta supera el cupo disponible de una localidad (aforo menos boletas pagadas y reservas vigentes), incluso con compras simultáneas. Verificado al cierre de la iteración 2 (11/12/2026) | Consistencia (integridad de datos) |
| OB-02 | **Venta en línea de punta a punta:** el comprador consulta la cartelera, reserva (1 a 4 boletas), paga y recibe sus boletas con QR por notificación, sin pasar por taquilla. Flujo demostrable de principio a fin en la etiqueta v1.0 (11/12/2026) | Exactitud funcional; usabilidad |
| OB-03 | **Proveedores intercambiables:** cambiar de pasarela de pago o de servicio de mensajería modificando **0 archivos** del dominio y de los casos de uso (solo adaptadores y configuración). Demostrado con dos pasarelas en la etiqueta v0.1 (04/12/2026) | Modificabilidad; interoperabilidad |
| OB-04 | **Cupo liberado a tiempo:** toda reserva sin pago confirmado vence a los **10 minutos** y libera su cupo; desde la hora de inicio del evento no se aceptan reservas ni pagos. Demostrable sin esperar, con un reloj controlable | Corrección temporal; testabilidad |
| OB-05 | **Tarifas correctas:** 100 % de las compras aplican el descuento según el SIA (50 % estudiante, 30 % egresado, el mayor si es ambos) a una sola boleta por evento; las demás pagan precio completo | Exactitud funcional |
| OB-06 | **Soporte del pico de apertura de ventas:** atender **N compradores concurrentes** sin perder el cupo ni dejar reservas inconsistentes. La cifra N no está en el enunciado: **supuesto a validar (S-02)** | Rendimiento; consistencia |

## 3. Alcance

| Parte | Qué SÍ incluye | Qué NO incluye |
|---|---|---|
| **Administración (organizador)** | Registrar un evento en borrador con nombre, fecha, hora de inicio, lugar y una o varias localidades (aforo y precio en pesos colombianos). Publicarlo para que aparezca en la cartelera. Cancelarlo: sale de la cartelera, anula reservas vigentes, reembolsa boletas pagadas y notifica a cada comprador | Modificar las localidades de un evento ya publicado. Reportes o paneles de ventas (el enunciado no los pide). Gestión de varios organizadores con permisos distintos (S-03) |
| **Usuario (comprador)** | Consultar la cartelera. Reservar de 1 a 4 boletas de una localidad (máximo 4 por evento, sumando reservas vigentes y pagadas). Pagar con resultado aprobado, rechazado o pendiente. Confirmación tardía con reembolso automático cuando corresponda. Descuento por tipo de público consultado en el SIA. Recibir boletas con código único, aleatorio y no consecutivo, y QR por notificación | Cuentas con contraseña (el comprador se identifica con documento, correo y celular). Venta en efectivo o en taquilla. Control de acceso o lectura de QR en la entrada del evento (el enunciado no lo pide). Reembolsos a solicitud del comprador (solo los automáticos que fija el enunciado) |
| **Transversal** | Interfaz web con pantallas para ambas partes, conectadas al mismo núcleo. Persistencia relacional. Script de datos de demostración (organizador, eventos con localidades, compradores de prueba, estudiantes y egresados en el SIA simulado). README de instalación | Diseño visual (no se evalúa). Pruebas automatizadas (no se piden; la validación es escenario por escenario). Integración con sistemas reales de pago, mensajería o SIA, salvo decisión posterior del equipo (S-06) |

## 4. Stakeholders

Poder e interés son una estimación del equipo, a validar.

| Nombre / rol | Tipo | Preocupaciones y atributo de calidad | Poder / interés |
|---|---|---|---|
| Comprador estudiante | Negocio | Comprar sin contraseña y con descuento del 50 % correcto, recibir su QR. Usabilidad; exactitud funcional | Bajo / Alto |
| Comprador egresado | Negocio | Descuento del 30 % correcto, comprar sin contraseña. Usabilidad; exactitud funcional | Bajo / Alto |
| Comprador público general | Negocio | Pagar precio completo, comprar sin ser parte de la universidad ni tener cuenta. Usabilidad | Bajo / Alto |
| Organizador de eventos | Negocio | Registrar, publicar y cancelar eventos; que no haya sobreventa. Consistencia; usabilidad | Medio / Alto |
| Universidad | Negocio | Cobrar por medios electrónicos, eliminar filas y sobreventa, poder cambiar de proveedores. Modificabilidad; consistencia | Alto / Alto |
| Docente (Johnny Alexander Salazar Cardona) | Técnico | Cumplimiento de las exigencias arquitectónicas, documentación coherente con el código, sustentación. Modificabilidad; trazabilidad | Alto / Alto |
| Administrador del SIA | Técnico | Consultas controladas por documento y protección de datos de estudiantes y egresados. Interoperabilidad; seguridad | Medio / Bajo |
| Proveedor de pasarela de pago | Técnico | Integración conforme a su contrato; manejo de pagos pendientes y reembolsos. Interoperabilidad | Medio / Bajo |
| Proveedor de mensajería | Técnico | Envío de notificaciones con boletas y QR conforme a su contrato. Interoperabilidad | Medio / Bajo |
| Equipo de desarrollo LasPalomas (Bairon Vásquez, Sergio Velásquez, Mariana García) | Técnico | Capacidad de 3 personas en dos iteraciones, código que cada integrante pueda explicar y modificar. Modificabilidad; testabilidad | Alto / Alto |

## 5. Restricciones

Las exigencias arquitectónicas del enunciado no se negocian. Las tecnologías concretas (lenguaje, framework, base de datos) **no** son restricciones: son decisiones del equipo y se justifican en ADR.

| ID | Restricción | Quién la impone | Por qué |
|---|---|---|---|
| RT-01 | El estilo arquitectónico es hexagonal o Clean Architecture, elegido con criterio y justificado en un ADR que compara ambas frente a los drivers | Docente | Evidenciar la decisión de arquitectura. El ADR se escribe como propuesto en la semana 0 y se acepta en la iteración 1 |
| RT-02 | El núcleo (dominio y casos de uso) no depende de frameworks, base de datos, web ni proveedores, y se comunica con el exterior solo por puertos | Docente | Regla de dependencia: ningún archivo del núcleo importa un adaptador |
| RT-03 | Los datos se guardan en una base de datos relacional, elegida y justificada en el ADR de persistencia | Docente | Persistencia relacional del sistema |
| RT-04 | El tiempo es un puerto, con un reloj del sistema y un reloj controlable | Docente | Demostrar el vencimiento de reservas y el cierre de la venta sin esperar |
| RT-05 | Cambiar de adaptador (pasarela, mensajería, SIA) se hace por configuración, sin editar código y sin que ningún archivo del núcleo cambie en el historial de Git | Docente | Cumplir el objetivo de intercambiabilidad (OB-03) |
| RT-06 | Interfaz web con pantallas para la parte de administración y la de usuario, ambas conectadas al mismo núcleo; una API sola no basta | Docente | Producto funcional de principio a fin |
| RT-07 | Cada elección tecnológica (backend, frontend, base de datos, integración con pasarelas, persistencia) queda justificada en un ADR frente a los drivers | Docente | No basta con "el equipo ya la conoce" |
| RT-08 | Desarrollo con SDD y un agente de IA: una carpeta `specs/NNN-nombre/` por caso de uso con `spec.md`, `plan.md`, `tasks.md` y `validacion.md`; revisión humana de todo lo que produce el agente; las decisiones de arquitectura no se delegan al agente | Docente | Trazabilidad y responsabilidad del equipo sobre cada línea |
| RT-09 | Proceso de equipo con roles TSPi, tablero en GitHub Projects, pull requests revisados por alguien distinto del autor y ceremonias con actas | Docente | Evidenciar el proceso de equipo |
| RT-10 | Plazos: semana 0 (hasta el 27/11/2026), iteración 1 (28/11 al 04/12, etiqueta v0.1) e iteración 2 (05/12 al 11/12, etiqueta v1.0) | Docente | Calendario del curso |
| RT-11 | Clean Code y SOLID, script de datos de demostración y README que permita instalar y ejecutar desde cero | Docente | Calidad del código entregado |

## 6. Supuestos y riesgos

### Supuestos

| ID | Lo que el enunciado no dice | Supuesto | Validar con |
|---|---|---|---|
| S-01 | Volumen de eventos y de compradores | El MVP se dimensiona para volumen de demostración (el script de datos carga pocos eventos y compradores de prueba). No se fija una cifra de producción | Docente; universidad |
| S-02 | Concurrencia en la apertura de ventas | Varios compradores pueden competir por el último cupo y el sistema debe garantizar que nunca se supera (OB-01). El número N de compradores simultáneos queda por definir (OB-06) | Docente |
| S-03 | Autenticación del organizador | Existe al menos un organizador, cargado por el script de datos de demostración. El mecanismo de acceso a la parte de administración se decide en un ADR; para el MVP se asume uno mínimo | Docente |
| S-04 | Datos que devuelve el SIA | Dado un documento, el SIA indica si corresponde a estudiante, egresado, ambos o ninguno (público general); no se piden más datos personales | Administrador del SIA; docente |
| S-05 | Qué ocurre si el SIA no responde o no encuentra el documento | [NECESITA ACLARACIÓN: ¿se cobra precio completo, se rechaza la compra o se reintenta cuando el SIA no responde?] | Docente |
| S-06 | Si la pasarela, la mensajería y el SIA pueden ser simulados | Se aceptan adaptadores simulados, como define el enunciado (sus datos y respuestas viven en el adaptador o en un archivo, y los mensajes salen por consola o registro) | Docente |
| S-07 | Canal de notificación | El comprador deja correo y celular; el canal efectivo lo determina el adaptador de mensajería elegido | Docente |
| S-08 | Edición de un evento en borrador | El organizador puede ajustar un evento mientras esté en borrador; solo tras publicarlo se bloquean sus localidades | Docente |
| S-09 | Reembolso por el mismo medio de pago | La pasarela elegida ofrece una operación de reembolso sobre un pago aprobado | Proveedor de pasarela; docente |

### Riesgos

| ID | Riesgo | Objetivo afectado | Mitigación |
|---|---|---|---|
| R-01 | **Capacidad de un equipo de 3 personas:** cinco roles TSPi repartidos en tres (dos dobles) y el backlog completo en dos iteraciones de una semana | OB-02 | Priorizar con la matriz de importancia y dificultad; tareas de máximo 4 horas; capacidad registrada en las actas de planeación; ítems no construidos quedan en el tablero |
| R-02 | Código (incluido el del agente de IA) que rompe la regla de dependencia o contradice un ADR | OB-03 | Lista de verificación de revisión con la regla de dependencia; pull request revisado por alguien distinto del autor; `AGENTS.md` cargado en cada sesión |
| R-03 | Sobreventa por compras simultáneas del mismo cupo | OB-01, OB-06 | Escenario de calidad de concurrencia validado en `validacion.md`; garantía de integridad decidida en el ADR de persistencia |
| R-04 | Manejo erróneo de pagos pendientes, doble pago o confirmaciones tardías | OB-01, OB-04 | Escenarios explícitos por regla en `validacion.md`; reloj controlable para reproducirlos sin esperar |
| R-05 | SIA, pasarela o mensajería no disponibles o con contrato distinto al supuesto | OB-03, OB-05 | Acceso solo por puertos; adaptadores simulados como respaldo (S-06); supuestos S-04 y S-05 validados |
| R-06 | Plazo corto: v0.1 al 04/12 y v1.0 al 11/12 | OB-02 | Núcleo y primeros ítems en la iteración 1; retrospectiva con acciones verificadas en la iteración 2 |
| R-07 | Documentación que no coincide con el código | OB-03 | Sergio custodia los documentos de arquitectura; revisión cruzada ([roles.md](equipo/roles.md)); `arquitectura.md` se actualiza en la iteración 2 |
| R-08 | Un integrante no puede explicar o modificar el código que aparece a su nombre | OB-02 | Áreas de desarrollo asignadas; revisión humana de lo que produce el agente; revisión cruzada de artefactos |
| R-09 | El ADR del estilo cambia después de la clase de arquitectura hexagonal | OB-03 | ADR propuesto en la semana 0 y aceptado en la iteración 1; la vista de desarrollo se ajusta si la decisión cambia |
