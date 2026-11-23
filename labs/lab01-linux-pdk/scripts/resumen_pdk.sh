#!/usr/bin/env bash
# =====================================================================
#  resumen_pdk.sh · Radiografía rápida del PDK (lab01, parte 4)
#  Se corre con:  make pdk
#  Primero explóralo tú con ls / find / grep; luego compara con esto.
# =====================================================================
if [ -z "${SCL_DIR:-}" ]; then
  echo "ERROR: primero fija el PDK:  source ../../scripts/env.sh" >&2; exit 1
fi
P="$PDK_ROOT/$PDK"

echo "== PDK: $P"
echo
echo "-- libs.ref/$STD_CELL_LIBRARY  (vistas de las celdas: lo que usan las herramientas)"
for d in "$SCL_DIR"/*/; do
  printf '   %-10s %4d archivos\n' "$(basename "$d")" "$(find "$d" -maxdepth 1 -type f | wc -l)"
done
echo
echo "-- libs.tech  (archivos por herramienta: reglas, colores, setups)"
for d in "$P"/libs.tech/*/; do printf '   %s\n' "$(basename "$d")"; done
echo
ncel=$(grep -cE '^[[:space:]]*cell[[:space:]]*\(' "$LIB_TT")
echo "-- Celdas en el .lib típico: $ncel"
echo
echo "-- Corners (un .lib por corner: proceso_temperatura_voltaje)"
for f in "$SCL_DIR"/lib/*.lib; do
  b=$(basename "$f" .lib); printf '   %s\n' "${b#"${STD_CELL_LIBRARY}"__}"
done
