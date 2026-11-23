# Lab 02 · RTL sintetizable y FSM

> **Estado: esqueleto.** Se construye en la conversación de la sesión 2; la solución irá en la rama `soluciones`.

Al salir, el alumno escribe una FSM sintetizable sin latches y la pasa por lint.

## Antes de empezar

```bash
cd labs/lab02-rtl
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Leer: ubicar las 4 piezas en `semaphore.v`
2. Lint con Verilator y esquemático con Yosys `show`
3. Agregar la entrada `ped_req` (botón peatonal) y provocar un latch a propósito
4. Compilar con Icarus, lint en cero warnings y commit

## Entregable

`semaforo` con `ped_req`, lint limpio, en tu rama.

## Origen

Basado en galletas-y-postres-chips: `common/rtl/semaphore`, `flows/opensource/02-rtl`.
