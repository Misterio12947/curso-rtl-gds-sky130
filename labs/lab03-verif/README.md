# Lab 03 · Verificación funcional

> **Estado: esqueleto.** Se construye en la conversación de la sesión 3; la solución irá en la rama `soluciones`.

Al salir, el alumno tiene un testbench que dice PASS/FAIL solo y un test aleatorio en cocotb.

## Antes de empezar

```bash
cd labs/lab03-verif
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Correr el TB base (PASS) y ver la onda en GTKWave
2. Inyectar un bug (dos luces) y encontrar el ciclo en la onda
3. cocotb: test dirigido y test aleatorio con `ped_req` y resets al azar
4. Opcional: 10 min de formal con SymbiYosys (contraejemplo del bug)

## Entregable

Test dirigido y aleatorio en PASS + captura de la onda.

## Origen

Basado en galletas-y-postres-chips: `flows/opensource/03-verif-funcional`, `04-verif-formal`.
