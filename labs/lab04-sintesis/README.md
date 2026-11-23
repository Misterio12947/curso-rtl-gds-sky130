# Lab 04 · Síntesis, `.lib` y SDC

> **Estado: esqueleto.** Se construye en la conversación de la sesión 4; la solución irá en la rama `soluciones`.

Al salir, el alumno tiene un netlist SKY130 que simula igual que su RTL y sabe leer un reporte de área.

## Antes de empezar

```bash
cd labs/lab04-sintesis
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Sintetizar con Yosys y leer `stat`
2. Escribir el netlist y encontrar los `dfrtp`
3. Tabla de área y celdas para `CW=8/16/32` y con las `.lib` ss/ff
4. Simulación gate-level con el mismo testbench (y `eqy` opcional)

## Entregable

Tabla área vs `CW` y GLS en PASS.

## Origen

Basado en galletas-y-postres-chips: `flows/opensource/06-sintesis/Makefile`.
