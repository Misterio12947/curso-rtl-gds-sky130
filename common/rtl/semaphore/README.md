# Diseño guía · Semáforo (FSM Moore)

El mismo diseño recorre los 6 labs: cada sesión consume la salida de la anterior.

| Archivo | Qué es |
| --- | --- |
| `rtl/semaphore.v` | La FSM del semáforo (verde → amarillo → rojo). RTL sintetizable, módulo `semaforo`. |
| `tb/tb_semaphore.v` | Testbench autocomprobante. Checker: exactamente una luz a la vez. |

Parámetros: `T_GREEN`, `T_YELLOW`, `T_RED` (duración en *ticks*) y `CW` (ancho del contador).

Prueba rápida, desde esta carpeta:

```bash
iverilog -g2012 -o sim_sem rtl/semaphore.v tb/tb_semaphore.v && vvp sim_sem
# >>> PASS: el semaforo cumple (1 luz a la vez, secuencia OK)
```

**Origen:** copiado de `galletas-y-postres-chips/common/rtl/semaphore/`.
Único cambio: el testbench usa el reloj del curso, 20 ns (`always #10`), en lugar de 10 ns.
El RTL es idéntico al del evento y todavía da warnings con `verilator -Wall`;
dejarlo en cero es parte del lab02.
