# Priorización del backlog

Responsable: Bairon Vásquez (líder) · Equipo LasPalomas · Fecha: 27/11/2026 · Estado: propuesta, pendiente de la capacidad por iteración

Entrada: la matriz y el orden del backlog de [drivers.md](drivers.md) (sección 5), propuestos por Sergio Velásquez. Este documento no los reemplaza: registra las decisiones del líder sobre ellos. Los ID (CU, RN, OB, RT, R, S, PA, EAC) son los de [vision.md](vision.md) y `drivers.md`.

## 1. Punto de partida

| Concepto | Valor propuesto en `drivers.md` |
|---|---|
| Casos de uso primarios | CU-04, CU-06, CU-07, CU-08, CU-09, CU-10 |
| Casos de uso imprescindibles, no primarios | CU-01, CU-03, CU-05 |
| Si sobra tiempo | CU-12, CU-11, CU-02 |
| Cuestionar (fuera de alcance) | Sistemas reales de pago, mensajería y SIA (S-06); prueba de carga con un número real de compradores (S-02) |
| Horas propuestas (2 iteraciones) | 69 h: base 4, CU-01 6, CU-03 2, CU-05 3, CU-06 10, CU-07 8, CU-08 6, CU-09 4, CU-10 8, CU-04 8, CU-12 4, CU-11 3, CU-02 3 |

La importancia es una propuesta del equipo, a confirmar con el docente. Las horas son una propuesta que la gerente de planeación ajusta.

## 2. Decisiones del líder

| ID | Decisión | Estado |
|---|---|---|
| DP-01 | **Capacidad por iteración.** Se fija antes de cortar el backlog. El enunciado sugiere para la iteración 1 evento, cartelera, reserva y pago con las dos pasarelas; con las horas propuestas eso son 33 h, lo que apunta a esa capacidad sin confirmarla. La cierra Mariana García (capacidad y sub-issues) | **Pendiente** [NECESITA ACLARACIÓN: ¿la capacidad es de 21 h o de 33 h por iteración, y del equipo completo o por persona?] |
| DP-02 | **Orden de construcción.** Se mantiene el orden de `drivers.md` 5.3: base, CU-01, CU-03, CU-05, CU-06, CU-07, CU-08, CU-09, CU-10, CU-04, CU-12, CU-11, CU-02 | Propuesto |
| DP-03 | **CU-08 frente a CU-09.** Juntos suman 43 h frente a 42 h de capacidad con 21 h por iteración. La diferencia de 1 h está dentro del margen de error de las estimaciones, así que no se decide por ella: Mariana reestima ambos. CU-08 es lo que recibe el comprador (OB-02); CU-09 demuestra el reloj como puerto (RT-04, EAC-04) | Propuesto |
| DP-04 | **Orden de recorte si la capacidad es insuficiente.** Primero CU-04 (8 h; toca pasarela y mensajería), luego CU-10 y luego CU-09. Es un orden de recorte, no una renuncia: RN-07 (confirmación tardía) y RN-10 (cancelación) son reglas del enunciado y cuentan en el criterio de producto funcionando | Propuesto |
| DP-05 | **Todo lo recortado se registra.** Los casos de uso que no se construyan quedan como issues en el tablero (RT-09) y como deuda técnica aceptada en `arquitectura.md` (sección 9) | Propuesto |
| DP-06 | **CU-12 (acceso del organizador).** Se mantiene en "si sobra tiempo". Sin él cualquiera puede publicar o cancelar eventos (PA-08); si no se construye, se registra como deuda técnica (S-03) | Propuesto |
| DP-07 | **Base transversal de 4 h.** Incluye estructura, puertos, reloj, `.env`, docker y script de demostración. Parece corta frente a las 6 h de CU-01. Mariana la reestima | Pendiente |

## 3. Escenarios de capacidad

Con las horas propuestas de `drivers.md` 5.3 (acumulado: base 4, CU-01 10, CU-03 12, CU-05 15, CU-06 25, CU-07 33, CU-08 39, CU-09 43, CU-10 51, CU-04 59, CU-12 63, CU-11 66, CU-02 69).

| Escenario | Horas totales | Iteración 1 llega hasta | No alcanzan |
|---|---|---|---|
| 21 h por iteración, equipo completo | 42 | CU-05 (15 h); CU-06 ya no cabe | CU-09, CU-10, CU-04, CU-12, CU-11, CU-02: **quedan fuera tres casos de uso primarios** y no se cumplen OB-04, RN-07 ni RN-10 |
| 33 h por iteración, equipo completo | 66 | CU-07 (33 h), como sugiere el enunciado | CU-02, sin holgura para imprevistos |
| 21 o 33 h por persona | 126 o 198 | Todo el orden hasta CU-07 | Ninguno |

Con 21 h por iteración del equipo no caben los casos de uso primarios: hay que revisar las estimaciones o la capacidad antes de la planeación de la iteración 1.

## 4. Preguntas para el docente

El líder es el interlocutor ante el docente. Se le llevan:

1. ¿Se confirma la importancia de los casos de uso primarios propuesta en `drivers.md` (secciones 1.3 y 5)?
2. Si la capacidad no alcanza, ¿se acepta dejar sin construir algún caso de uso, registrado como deuda técnica?

## 5. Pendientes que bloquean la priorización

| Pendiente | Responsable |
|---|---|
| Capacidad por iteración (DP-01) | Mariana García |
| Reestimar CU-08, CU-09 y la base transversal (DP-03, DP-07) | Mariana García |
| Ajustar la matriz de `drivers.md` con estas decisiones | Sergio Velásquez |
| Crear en el tablero un issue por cada caso de uso, también los recortados | Mariana García |
| Respuesta del docente a las preguntas de la sección 4 | Bairon Vásquez |
