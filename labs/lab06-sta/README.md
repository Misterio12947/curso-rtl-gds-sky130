# Lab 06 · STA y signoff

> **Estado: esqueleto.** Se construye en la conversación de la sesión 6; la solución irá en la rama `soluciones`.

Al salir, el alumno lee una ruta crítica, encuentra la fmax de su diseño y decide si su GDS está listo para fabricar.

## Antes de empezar

```bash
cd labs/lab06-sta
source ../../scripts/env.sh   # fija PDK_ROOT y las rutas del PDK
make help
```

## Pasos

1. Leer un reporte de `report_checks` y cambiar a SPEF real
2. Romper el timing: periodo de 20 → 10 → 2 → 1 ns y encontrar la fmax
3. Multi-corner: ss (setup) y ff (hold)
4. Signoff: STA por corner, DRC y LVS del run de LibreLane

## Entregable

Tabla fmax y slack por corner + checklist de signoff llena.

## Origen

Basado en galletas-y-postres-chips: `flows/opensource/08-sta` (`sta.tcl`, `run_sta.sh`), `11-layout`.
