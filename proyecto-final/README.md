# Proyecto final (opcional, evaluable)

> **Estado: esqueleto.** La plantilla del repo de alumnos, el flujo de entrega y la fecha se
> construyen en la conversación 7.

Quien quiera ser evaluado lleva un diseño propio del RTL al GDSII con el flujo del curso
y lo entrega en un repo de GitHub.

**Restricciones comunes:** SKY130 `sky130_fd_sc_hd`, reloj de **20 ns (50 MHz)** y menos de ~500 celdas.

## Menú de diseños

1. Contador up/down de 8 bits con enable y carga paralela.
2. Generador PWM de 8 bits con ciclo de trabajo programable.
3. Transmisor UART 8N1 con divisor de baud parametrizable.
4. Debouncer + contador de pulsos con salida a display de 7 segmentos.
5. ALU registrada de 4 bits (suma, resta, AND, OR, XOR, corrimiento).
6. Libre, aprobado antes por el instructor.

## Rúbrica (100 pts)

| Criterio | Evidencia | Pts |
| --- | --- | --- |
| Especificación y README | Spec clara, pasos reproducibles con rutas relativas | 10 |
| RTL | Sintetizable, lint sin warnings, sin latches | 15 |
| Verificación | TB autocomprobante en PASS + 1 test aleatorio | 20 |
| Síntesis | Reporte de área/celdas + GLS en PASS | 15 |
| Place and Route | GDS + capturas, DRC limpio | 20 |
| STA y LVS | Sin violaciones setup/hold en tt, reporte ss/ff, LVS match | 15 |
| Git | Historia de commits con sentido y `.gitignore` correcto | 5 |

Pendiente: fecha de entrega y si la revisión es por Pull Request o por enlace al repo.
