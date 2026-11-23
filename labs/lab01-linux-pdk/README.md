# Lab 01 · PDKs y Linux para VLSI

> **Estado: esqueleto.** Se construye en la conversación de la sesión 1; la solución irá en la rama `soluciones`.

Al salir, el alumno sabe dónde vive cada vista del PDK y se mueve en Linux y git sin rutas absolutas.

## Antes de empezar

```bash
cd labs/lab01-linux-pdk
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Arranque: el contenedor y la carpeta compartida `/foss/designs`
2. Linux básico y ejercicio de rutas relativas
3. Git: clonar, rama `alumno/<nombre>`, commit y push a tu fork
4. PDK: bajarlo con `ciel`, recorrer `libs.ref/sky130_fd_sc_hd/` y `pdk_info.sh <celda>`

## Entregable

Commit en tu rama con `notas_pdk.md` (área y tamaño de 3 celdas, corners disponibles).

## Origen

Basado en galletas-y-postres-chips: `.gitignore` y estructura del repo.
