# Sistema de boletería para los eventos culturales de la universidad

Sistema web para vender en línea boletas de conciertos, teatro y conferencias de la universidad, con cobro electrónico y control del cupo para evitar la sobreventa.
La pasarela de pago y el servicio de mensajería se cambian por configuración, sin modificar el dominio ni los casos de uso.

Proyecto final de Arquitectura de Soluciones de Software. Arquitectura hexagonal: backend en Python 3.12 + FastAPI, frontend en Angular y base de datos PostgreSQL.

## Integrantes y roles

Equipo **LasPalomas**. El detalle de las responsabilidades y la revisión cruzada está en [docs/equipo/roles.md](docs/equipo/roles.md).

| Integrante | Rol |
|---|---|
| Bairon Vásquez | Líder de equipo + Gerente de soporte |
| Sergio Velásquez | Gerente de desarrollo |
| Mariana García | Gerente de planeación + Gerente de calidad y proceso |

## Mapa de la documentación

| Documento | Contenido | Estado |
|---|---|---|
| [docs/vision.md](docs/vision.md) | Objetivos de negocio, alcance, stakeholders, restricciones, supuestos y riesgos | Disponible |
| [docs/drivers.md](docs/drivers.md) | Casos de uso, escenarios de calidad, restricciones, preocupaciones arquitectónicas y matriz de priorización | Disponible |
| [docs/priorizacion.md](docs/priorizacion.md) | Decisiones sobre el orden del backlog | Disponible |
| `docs/arquitectura.md` | Documento de arquitectura completo, con la deuda técnica aceptada | Pendiente |
| [docs/adr/](docs/adr/) | Decisiones de arquitectura (ADR) | En construcción |
| `docs/vistas/` | Vistas 4+1 (lógica, procesos, desarrollo, física) | Pendiente |
| `specs/` | Una carpeta por caso de uso: `spec.md`, `plan.md`, `tasks.md` y `validacion.md` | Pendiente |
| [docs/equipo/](docs/equipo/) | Normas, roles, estándares, lista de verificación de revisión y backlog | Disponible |

## Requisitos previos

| Herramienta | Versión |
|---|---|
| Python | 3.12 |
| Node.js | `<versión>` [NECESITA ACLARACIÓN: ¿qué versión de Node se fija? Es la misma pregunta abierta del ADR-003] |
| Angular CLI | `<versión>` [NECESITA ACLARACIÓN: ¿qué versión de Angular CLI se fija? Ver ADR-003] |
| Docker (con Docker Compose) | Versión reciente |
| Git | Versión reciente |

## Instalación desde cero

Los comandos que dependen de archivos que aún no existen están marcados con *(Se completa en la Iteración 1)*. No se inventan nombres de módulos ni de archivos hasta que existan.

### 1. Clonar el repositorio

```bash
git clone https://github.com/bairon-vasquez/ProyectoFinalArqSW.git
cd ProyectoFinalArqSW
```

### 2. Copiar `.env.example` a `.env`

PowerShell:

```powershell
Copy-Item .env.example .env
```

Bash:

```bash
cp .env.example .env
```

Edite `.env` y reemplace los marcadores `<usuario>`, `<clave>` y `<bd>` en `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` y `DATABASE_URL`. La URL de la base debe usar los mismos valores. El `.env` no se versiona. Cada variable se explica en [.env.example](.env.example).

### 3. Levantar PostgreSQL con Docker Compose

```bash
docker compose up -d
```

La base queda en `localhost:5432` con un volumen persistente. [NECESITA ACLARACIÓN: ¿qué versión de PostgreSQL se fija? `docker-compose.yml` tiene `postgres:<versión>` y no arranca hasta fijarla. Ver ADR-004.]

### 4. Crear el entorno virtual e instalar las dependencias del backend

PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Bash (Linux o macOS):

```bash
python -m venv .venv
source .venv/bin/activate
```

Luego, instale las dependencias con `pip install -r <archivo de dependencias>`. *(Se completa en la Iteración 1: el archivo de dependencias aún no existe.)*

### 5. Aplicar las migraciones con Alembic

`alembic upgrade head`, ejecutado desde la carpeta que contenga la configuración de Alembic. *(Se completa en la Iteración 1: la configuración y las migraciones aún no existen.)*

### 6. Cargar los datos de demostración

`<comando del script de datos de demostración>`: carga un organizador, eventos con localidades, compradores de prueba y, en el SIA simulado, estudiantes y egresados. *(Se completa en la Iteración 1: el script va en `src/backend/scripts/` y aún no existe.)*

### 7. Ejecutar el backend (FastAPI con uvicorn)

`uvicorn <módulo:aplicación> --reload`. *(Se completa en la Iteración 1: la aplicación aún no existe.)*

La documentación interactiva de la API (OpenAPI) queda disponible mientras corre el backend.

### 8. Instalar y ejecutar el frontend (Angular)

Desde la carpeta del proyecto Angular:

```bash
npm install
ng serve
```

*(Se completa en la Iteración 1: el proyecto Angular, en `src/frontend/`, aún no existe.)*

El frontend se sirve en `http://localhost:4200`, el origen que permite `CORS_ORIGEN` en `.env`.

## Configuración de adaptadores

La pasarela de pago, el servicio de mensajería, el SIA y el reloj se eligen con variables del archivo `.env`. Cambiar de adaptador es editar una variable y reiniciar el backend: no se edita código y ningún archivo del núcleo (dominio y casos de uso) cambia.

| Variable | Valores válidos | Activa |
|---|---|---|
| `PASARELA_PAGO` | `simulada_a`, `simulada_b` | Adaptador de pasarela de pago |
| `MENSAJERIA` | `consola`, `archivo` | Adaptador de mensajería |
| `SIA` | `simulado` | Adaptador del SIA |
| `SIA_DATOS` | Ruta de un archivo JSON | Datos del SIA simulado |
| `RELOJ` | `sistema`, `controlable` | Adaptador del reloj |
| `DATABASE_URL` | URL de PostgreSQL | Adaptador de persistencia |
| `CORS_ORIGEN` | Origen del frontend | Regla CORS de la API |

### Demostración: cambiar la pasarela de pago sin tocar el código

Requisitos: instalación completa (secciones 1 a 8).

1. Confirme que el repositorio está limpio:

   ```bash
   git status
   ```

   Debe decir `nothing to commit, working tree clean`. El `.env` no aparece porque `.gitignore` lo excluye.

2. En `.env` deje `PASARELA_PAGO=simulada_a` y ejecute el backend (paso 7 de la instalación).

3. Haga un pago de demostración desde la interfaz y anote la pasarela que lo procesó [NECESITA ACLARACIÓN: ¿cómo se ve qué pasarela está activa? Por ejemplo, una línea en el registro al arrancar o un dato en la respuesta del pago. Lo debe definir el adaptador de pasarela].

4. Detenga el backend, edite `.env` y cambie la línea:

   ```
   PASARELA_PAGO=simulada_b
   ```

5. Reinicie el backend con el mismo comando y repita el pago. Ahora lo procesa la otra pasarela.

6. Verifique que no cambió ningún archivo de código:

   ```bash
   git status
   git diff --stat
   ```

   `git status` debe decir de nuevo `nothing to commit, working tree clean` y `git diff --stat` no debe mostrar nada. Para comprobar el núcleo en particular:

   ```bash
   git diff --name-only HEAD -- src/backend/nucleo
   ```

   El resultado debe estar vacío.

El mismo procedimiento sirve para `MENSAJERIA` (`consola` o `archivo`) y para `RELOJ` (`sistema` o `controlable`).

## Cómo contribuir

1. **Rama:** cree una rama por tarea a partir de `main` con el formato `feature/T-CC-NN-descripcion` (ID de la tarea y descripción corta en minúsculas, con guiones y sin tildes).
2. **Commit:** un commit por tarea, con el ID de la tarea al inicio del mensaje. Si cambia el comportamiento, actualice `spec.md` en el mismo commit.
3. **Pull request:** todo cambio entra por pull request, con la plantilla de [.github/pull_request_template.md](.github/pull_request_template.md) y con `Closes #` seguido del número del issue que resuelve.
4. **Revisión:** el pull request lo revisa una persona distinta del autor con la [lista de verificación de revisión](docs/equipo/checklist-revision.md). Ningún archivo del núcleo importa un adaptador.
5. **Reglas del equipo:** [docs/equipo/normas.md](docs/equipo/normas.md).

Formato de ramas y commits, formateo, nombres, estructura de carpetas, manejo de errores y contenido de `validacion.md`: [docs/equipo/estandares.md](docs/equipo/estandares.md).
