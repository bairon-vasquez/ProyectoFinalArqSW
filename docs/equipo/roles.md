# Roles del equipo LasPalomas (modelo TSPi)

**Integrantes:** Bairon Vásquez, Sergio Velásquez, Mariana García

## 1. Asignación actual

| Rol | Responsable | Fecha de rotación |
|---|---|---|
| Líder de equipo | Bairon Vásquez | Sin rotación prevista |
| Gerente de soporte | Bairon Vásquez | Sin rotación prevista |
| Gerente de desarrollo | Sergio Velásquez | Sin rotación prevista |
| Gerente de planeación | Mariana García | Sin rotación prevista |
| Gerente de calidad y proceso | Mariana García | Sin rotación prevista |

## 2. Justificación de la doble asignación

- El enunciado prevé equipos de 5 personas, con un rol TSPi por integrante. En equipos de menos de 5, una persona asume el rol que elija y, además, el de gerente de soporte, y `roles.md` debe dejar explícita la doble asignación.
- Con 3 personas hay 5 roles por cubrir, así que hay **dos dobles**:
  - Bairon: Líder de equipo + Gerente de soporte (la doble que prevé el enunciado).
  - Mariana: Gerente de planeación + Gerente de calidad y proceso.
- Sergio queda **solo como Gerente de desarrollo**. Así, quien custodia la arquitectura no concentra otros roles, y sus planes y documentos los revisa otra persona (sección 4).
- La doble de Mariana va más allá de lo que dice el enunciado literalmente; el equipo la confirmó con el docente el **[NECESITA ACLARACIÓN: ¿qué fecha se confirmó con el docente?]**.

## 3. Responsabilidades por rol y evidencia en el repositorio

Las responsabilidades y evidencias son las que fija el enunciado.

| Rol | Responsable | Responsabilidad | Evidencia en el repositorio |
|---|---|---|---|
| Líder de equipo | Bairon Vásquez | Convoca las ceremonias; es el interlocutor ante el docente | Actas de planeación y de revisión en `docs/ceremonias/iteracion-01/` y `docs/ceremonias/iteracion-02/` |
| Gerente de desarrollo | Sergio Velásquez | Custodia visión, drivers, ADR, vistas y arquitectura; aprueba cada `plan.md` frente a la arquitectura | `vision.md`, `drivers.md`, `docs/adr/`, `docs/vistas/`, `arquitectura.md`; aprobación de los `plan.md` en los pull requests |
| Gerente de planeación | Mariana García | Administra el tablero, la capacidad y la selección de ítems; compara lo planeado con lo real en cada revisión | Tablero de GitHub Projects al día; capacidad y comparación planeado vs. real en las actas de revisión |
| Gerente de calidad y proceso | Mariana García | Mantiene la lista de verificación de revisión de código; vigila la regla de dependencia en cada pull request; revisa los `validacion.md`; modera las retrospectivas | Lista de verificación de revisión; revisiones de pull requests; revisión de los `validacion.md`; actas de retrospectiva |
| Gerente de soporte | Bairon Vásquez | Administra el repositorio, las ramas y los permisos; mantiene el README, la configuración de adaptadores y el script de datos de demostración | `README.md`, ramas y permisos del repositorio, archivo de configuración de adaptadores (`.env`), script de datos de demostración |

## 4. Revisión cruzada

| Artefacto | Autor | Revisor o aprobador |
|---|---|---|
| `plan.md` (cada uno, frente a la arquitectura) | Todos | Sergio aprueba |
| `spec.md`, `tasks.md`, `validacion.md` y `plan.md` | Sergio | Mariana revisa |
| `spec.md` y `validacion.md` | Mariana | Sergio revisa |
| `tasks.md` | Mariana | Bairon revisa |
| `spec.md`, `tasks.md` y `validacion.md` | Bairon | [NECESITA ACLARACIÓN: ¿quién revisa los `spec.md` y `tasks.md` de Bairon? Por el rol de calidad, Mariana revisa sus `validacion.md`] |

- Ninguna persona aprueba su propio `plan.md`: los de Sergio los revisa Mariana.
- Todo cambio llega por pull request y lo revisa alguien distinto del autor, como dicen las normas del equipo ([normas.md](normas.md)).

## 5. Áreas de desarrollo

| Responsable | Área |
|---|---|
| Bairon Vásquez | Frontend Angular; adaptadores de pasarela de pago, mensajería, SIA y reloj |
| Sergio Velásquez | Núcleo (dominio y casos de uso) y reglas de tiempo |
| Mariana García | Persistencia en PostgreSQL y API de administración |

## 6. Historial de rotaciones

| Fecha | Rol | De | A | Motivo |
|---|---|---|---|---|
| | | | | |

*(Vacío: no hay rotaciones.)*
