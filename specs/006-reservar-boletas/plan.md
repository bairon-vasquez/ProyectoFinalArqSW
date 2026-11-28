# Plan CU-06: Reservar boletas

Autor: Sergio Velásquez · Revisa y aprueba frente a la arquitectura: Mariana García (nadie aprueba su propio `plan.md`, [roles.md](../../docs/equipo/roles.md)) · Estado: borrador para revisión

Spec: [spec.md](spec.md). Este plan solo usa los ADR, puertos, adaptadores y archivos que ya fijan los ADR y la [vista de desarrollo](../../docs/vistas/03-desarrollo.md). Lo marcado *propuesta* se confirma al aprobar el plan.

## 1. ADR que aplica

| ADR | Qué aplica a este caso de uso |
|---|---|
| [ADR-001](../../docs/adr/ADR-001-estilo-arquitectonico.md) | `ReservarBoletas` es el puerto de entrada; el núcleo no importa adaptadores |
| [ADR-002](../../docs/adr/ADR-002-backend.md) | FastAPI y Pydantic solo en `rutas_comprador` y `esquemas`; la validación de formato (campos faltantes) la hace Pydantic; las excepciones de dominio se traducen a HTTP en `errores.py` |
| [ADR-003](../../docs/adr/ADR-003-frontend.md) | La pantalla en `comprador/` muestra el monto y los errores que devuelve la API; no calcula descuentos ni valida el cupo |
| [ADR-005](../../docs/adr/ADR-005-integracion-pasarelas-mensajeria.md) | Puerto `ConsultaSIA` con `consultar_tipo_publico(documento)`; adaptador `SIASimulado` elegido por `SIA`; si el SIA no responde, el adaptador lanza una excepción de dominio y el caso de uso aplica S-05 |
| [ADR-006](../../docs/adr/ADR-006-persistencia.md) | Consulta al SIA antes de la transacción; una transacción corta con bloqueo del comprador y luego de la localidad; cupo calculado después del bloqueo con `ahora` como parámetro; `CHECK` de 1 a 4 boletas |
| [ADR-007](../../docs/adr/ADR-007-reloj-como-puerto.md) | La hora sale del puerto Reloj, una vez por operación; la vigencia de las reservas se evalúa al consultar (V1) |

## 2. Puertos y adaptadores que toca

| Componente | Archivo | Papel |
|---|---|---|
| Caso de uso `ReservarBoletas` | `nucleo/casos_uso/reservar_boletas.py` | Orquesta la reserva |
| Dominio `Evento`, `Localidad` | `nucleo/dominio/evento.py` | `Evento.venta_abierta(ahora)`, estado `PUBLICADO`, `Localidad.cupo_disponible(...)` |
| Dominio `Comprador`, `TipoPublico` | `nucleo/dominio/comprador.py` | Datos del comprador y tipo de público |
| Dominio `Reserva` | `nucleo/dominio/reserva.py` | Creación con `cantidad` de 1 a 4, `vence_en`, `con_descuento`, cálculo del `monto` y `esta_vigente(ahora)` |
| Excepciones de dominio | `nucleo/dominio/excepciones.py` | Errores de la sección 4 |
| Puerto `ConsultaSIA` | `nucleo/puertos/consulta_sia.py` | `consultar_tipo_publico(documento) -> TipoPublico` |
| Puerto `Reloj` | `nucleo/puertos/reloj.py` | Hora actual |
| Puertos `RepositorioEventos`, `RepositorioCompradores`, `RepositorioReservas`, `UnidadDeTrabajo` | `nucleo/puertos/repositorios.py` | Bloquear comprador y localidad, contar boletas, guardar la reserva |
| Adaptador del SIA | `adaptadores/salida/sia/` | `SIASimulado`, que lee `datos/sia.json` (ruta en `SIA_DATOS`) |
| Adaptador de persistencia | `adaptadores/salida/persistencia/` | Modelos, mapeo y repositorios de comprador y reserva; migración con el `CHECK` de 1 a 4 |
| Raíz de composición | `src/backend/arranque.py` | Conecta `ConsultaSIA` con el adaptador de `SIA` |
| Adaptador de entrada | `adaptadores/entrada/api/rutas_comprador.py`, `esquemas.py`, `errores.py` | Endpoint de reserva |
| Frontend | `src/frontend/src/app/comprador/` y `api/` | Formulario de reserva |

No se crean puertos ni adaptadores nuevos. `PasarelaPago`, `ServicioMensajeria` y `GeneradorQR` no se usan en este caso de uso.

**Métodos de repositorio** (*propuesta*; el ADR-006 deja los nombres de los métodos para los planes):

| Puerto | Método | Qué hace |
|---|---|---|
| `RepositorioCompradores` | `obtener_o_crear_bloqueado(documento, correo, celular)` | Crea el comprador si no existe o actualiza su correo y celular (P-01 de la spec) y bloquea su fila |
| `RepositorioEventos` | `obtener_localidad_bloqueada(localidad_id)` | Devuelve la localidad con su evento y bloquea la fila de la localidad |
| `RepositorioReservas` | `contar_boletas_ocupadas(localidad_id, ahora)` | Boletas pagadas y boletas en reservas vigentes de la localidad |
| `RepositorioReservas` | `contar_boletas_del_comprador(documento, evento_id, ahora)` | Boletas del comprador en el evento, en reservas vigentes y pagadas |
| `RepositorioReservas` | `tiene_descuento_en_evento(documento, evento_id, ahora)` | Si el comprador ya tiene una reserva vigente o pagada con descuento en el evento |
| `RepositorioReservas` | `agregar(reserva)` | Guarda la reserva |

## 3. Diseño

Pasos de `ReservarBoletas`:

1. **Hora:** `ahora` del Reloj, una sola vez.
2. **Sin transacción:** `ConsultaSIA.consultar_tipo_publico(documento)`. Si lanza la excepción de SIA no disponible o de documento no encontrado, se usa `NINGUNO` y se marca el aviso de tarifa general (S-05). No se sostiene ningún bloqueo mientras se espera al SIA ([ADR-006](../../docs/adr/ADR-006-persistencia.md)).
3. **Transacción** (orden de bloqueos del ADR-006: comprador → localidad):
   1. Obtener o crear el comprador y bloquear su fila.
   2. Obtener la localidad con su evento y bloquear su fila.
   3. Comprobar que el evento está `PUBLICADO` y que `venta_abierta(ahora)`.
   4. Contar las boletas del comprador en el evento con `ahora`; si con `cantidad` pasa de 4, lanzar la excepción de límite.
   5. Contar las boletas ocupadas de la localidad con `ahora` y calcular `cupo_disponible`; si `cantidad` no cabe, lanzar la excepción de cupo agotado.
   6. Consultar si el comprador ya tiene descuento en el evento.
   7. Crear la `Reserva` con `vence_en = ahora + 10 minutos`; el dominio calcula `con_descuento` y `monto`.
   8. Guardar y confirmar.
4. Devolver la reserva y el aviso, si lo hay.

Los pasos 3.4 y 3.5 van **después** de los bloqueos: así la segunda solicitud simultánea ve la reserva de la primera (READ COMMITTED, [ADR-006](../../docs/adr/ADR-006-persistencia.md)). El bloqueo del comprador resuelve CU06-E14 y el de la localidad, CU06-E13.

```mermaid
sequenceDiagram
    actor C as Comprador
    participant A as Angular (comprador/)
    participant API as rutas_comprador
    participant CU as ReservarBoletas
    participant R as Reloj
    participant S as ConsultaSIA (SIASimulado)
    participant BD as Repositorios + UnidadDeTrabajo
    C->>A: localidad, cantidad, documento, correo, celular
    A->>API: solicitud de reserva
    API->>CU: reservar(datos)
    CU->>R: hora actual
    CU->>S: consultar_tipo_publico(documento)
    S-->>CU: TipoPublico (o excepción: tarifa general con aviso)
    CU->>BD: bloquear comprador, bloquear localidad
    CU->>BD: contar boletas del comprador y ocupadas (con ahora)
    CU->>CU: validar máximo 4, cupo y venta abierta; crear Reserva
    CU->>BD: guardar reserva y confirmar
    CU-->>API: reserva (monto, vence_en, aviso)
    API-->>A: respuesta
    A-->>C: resumen de la reserva
```

## 4. Errores de negocio y respuesta HTTP

Las excepciones viven en el dominio y las traduce `errores.py` ([estandares.md](../../docs/equipo/estandares.md)). Nombres y códigos son *propuesta* y deben coincidir con los del [plan de CU-07](../007-pagar-reserva/plan.md) cuando se repiten (`VentaCerrada`).

| Situación | Excepción de dominio (*propuesta*) | HTTP (*propuesta*) | Escenario |
|---|---|---|---|
| La localidad no existe | `LocalidadNoEncontrada` | 404 | CU06-E20 |
| El evento está en borrador o cancelado | `EventoNoDisponible` | 409 | CU06-E15 |
| La venta del evento está cerrada | `VentaCerrada` | 409 | CU06-E16 |
| La cantidad no está entre 1 y 4 | `CantidadInvalida` | 422 | CU06-E08 |
| El comprador pasaría de 4 boletas en el evento | `LimiteBoletasExcedido` | 409 | CU06-E09, E10, E14 |
| No hay cupo suficiente | `CupoAgotado` | 409 | CU06-E12, E13 |
| Falta el documento, el correo o el celular | Validación de Pydantic en el adaptador | 422 | CU06-E19 |

Que el SIA no responda **no es un error**: la reserva se crea con tarifa general y la respuesta incluye el aviso (CU06-E06, E07).

Defensa en la base: el `CHECK` de 1 a 4 boletas rechaza una reserva inválida aunque el código fallara ([ADR-006](../../docs/adr/ADR-006-persistencia.md)).

## 5. Adaptador del SIA

`SIASimulado` lee el archivo de `SIA_DATOS` al arrancar. Cada entrada tiene un documento y su tipo de público (estudiante, egresado o ambos). Un documento que no está en el archivo produce la excepción de documento no encontrado. Un documento marcado "sin respuesta" (*propuesta*, P-04 de la spec) produce la excepción de SIA no disponible. Al arrancar escribe en el registro `SIA activo: simulado`.

El script de datos (TEC-07) debe incluir compradores de prueba con los mismos documentos que el archivo del SIA: un estudiante, un egresado, uno que es ambos, uno de público general y uno marcado "sin respuesta".

## 6. Frontend

Formulario de reserva en `comprador/`, al que se llega desde una localidad de la cartelera: cantidad (de 1 a 4), documento, correo y celular. Al reservar muestra localidad, cantidad, precio unitario, si una boleta lleva descuento, monto total, hora de vencimiento y el aviso de tarifa general cuando lo hay, con el acceso al pago (CU-07). Muestra los errores de la sección 4 con el mensaje que devuelve la API. No calcula el monto ni valida el cupo (checklist 3.4).

## 7. Dependencias

| Depende de | Motivo |
|---|---|
| CU-05 | El comprador elige la localidad en la cartelera; comparten el cálculo del cupo |
| TEC-01 | Estructura y puertos base |
| TEC-02 | Selección del SIA por `.env` |
| TEC-03 | Puerto Reloj y reloj controlable para CU06-E11, E16 y E17 |
| TEC-04 | Persistencia, transacciones y bloqueos |
| TEC-05, TEC-06 | Esqueletos de la API y de Angular |
| TEC-07 | Compradores de prueba y archivo del SIA simulado |

CU-07 depende de este caso de uso: el pago parte de una reserva vigente con su monto.

## 8. Verificación

- Regla de dependencia: los comandos de la sección 4 de la [vista de desarrollo](../../docs/vistas/03-desarrollo.md) devuelven vacío.
- EAC-03: CU06-E13 se ejecuta con 10 solicitudes en paralelo contra la API, repetido 5 veces, con el comando que indica [validacion.md](validacion.md).
- Los escenarios de [spec.md](spec.md) se validan en [validacion.md](validacion.md). CU06-E11, E16 y E17 usan el reloj controlable.
