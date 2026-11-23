# Lab 05 · Place and Route

> **Estado: esqueleto.** Se construye en la conversación de la sesión 5; la solución irá en la rama `soluciones`.

Al salir, el alumno ha visto cada etapa física en la GUI y tiene el GDS del semáforo hecho a mano y con LibreLane.

## Antes de empezar

```bash
cd labs/lab05-pnr
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Parte A · OpenROAD por etapas (un `.odb` por etapa): floorplan, PDN con `pdngen`, tapcells + placement, CTS, routing
2. Experimento en parejas: utilización 35 % → 60 % → 85 %
3. Parte B · LibreLane con un `config.json` mínimo y el GDS en KLayout

## Entregable

GDS manual + GDS de LibreLane, capturas por etapa y tabla utilización vs resultado.

## Origen

Basado en galletas-y-postres-chips: `flows/opensource/07-pnr` (`pnr.tcl`, `run_pnr.sh`, `def2gds.tcl`).
