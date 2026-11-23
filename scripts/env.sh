# shellcheck shell=bash
# =====================================================================
#  env.sh  ·  Localiza el PDK SKY130 y exporta las variables del curso
#
#  Uso (desde la raíz del repo o desde un lab):
#     source scripts/env.sh          # o:  source ../../scripts/env.sh
#     ./scripts/env.sh               # solo imprime lo que encontró
#
#  Por qué existe: en el contenedor PDK_ROOT puede apuntar a un lugar que
#  no tiene sky130A (p.ej. /headless/pdk). Aquí se prueba una lista de
#  candidatos y se usa el PRIMERO que tenga la librería sky130_fd_sc_hd.
#  Para forzar uno:  PDK_ROOT=/mi/ruta source scripts/env.sh
#
#  POR VALIDAR: rutas exactas dentro de la etiqueta de iic-osic-tools del curso.
# =====================================================================

_sourced=0
(return 0 2>/dev/null) && _sourced=1

export PDK=sky130A
export STD_CELL_LIBRARY=sky130_fd_sc_hd
_TTLIB="libs.ref/$STD_CELL_LIBRARY/lib/${STD_CELL_LIBRARY}__tt_025C_1v80.lib"

# ¿Este directorio contiene un sky130A utilizable?
_pdk_ok() { [ -n "$1" ] && [ -f "$1/$PDK/$_TTLIB" ]; }

_pdk_root=""
for _c in \
    "$PDK_ROOT" \
    /foss/designs/pdks \
    "$HOME/pdks" \
    /foss/pdks \
    /foss/pdks/ciel/sky130/versions/* \
    "$HOME"/.ciel/sky130/versions/* \
    "$HOME"/.volare/sky130/versions/* \
    "$HOME/.volare" \
    "$HOME/pdk"; do
  if _pdk_ok "$_c"; then _pdk_root="$_c"; break; fi
done

if [ -z "$_pdk_root" ]; then
  echo "ERROR(env.sh): no encontré $PDK con la librería $STD_CELL_LIBRARY." >&2
  echo "  Bájalo con ciel (lab01) o indica dónde está:" >&2
  echo "     PDK_ROOT=/ruta/que/contiene/sky130A source scripts/env.sh" >&2
  # shellcheck disable=SC2317
  if [ "$_sourced" = 1 ]; then return 1; else exit 1; fi
fi

export PDK_ROOT="$_pdk_root"
_P="$PDK_ROOT/$PDK"
_SCL="$_P/libs.ref/$STD_CELL_LIBRARY"

# ---- Vistas de la librería de celdas (libs.ref) ----------------------
export SCL_DIR="$_SCL"
export LIB_TT="$_SCL/lib/${STD_CELL_LIBRARY}__tt_025C_1v80.lib"
export LIB_SS="$_SCL/lib/${STD_CELL_LIBRARY}__ss_100C_1v60.lib"
export LIB_FF="$_SCL/lib/${STD_CELL_LIBRARY}__ff_n40C_1v95.lib"
export TECHLEF="$_SCL/techlef/${STD_CELL_LIBRARY}__nom.tlef"
export CELLLEF="$_SCL/lef/${STD_CELL_LIBRARY}.lef"
export CELLGDS="$_SCL/gds/${STD_CELL_LIBRARY}.gds"
export CELL_VERILOG="$_SCL/verilog/${STD_CELL_LIBRARY}.v"
export CELL_PRIMITIVES="$_SCL/verilog/primitives.v"

# ---- Archivos por herramienta (libs.tech) ----------------------------
export MAGICRC="$_P/libs.tech/magic/$PDK.magicrc"
export KLAYOUT_LYP="$_P/libs.tech/klayout/tech/$PDK.lyp"
export NETGEN_SETUP="$_P/libs.tech/netgen/${PDK}_setup.tcl"

# ---- Reporte ----------------------------------------------------------
_show() { if [ -e "$2" ]; then printf '  %-16s %s\n' "$1" "$2"; else printf '  %-16s %s   <-- NO EXISTE\n' "$1" "$2"; fi; }
echo ">> PDK_ROOT = $PDK_ROOT   (PDK=$PDK, librería=$STD_CELL_LIBRARY)"
if [ "$_sourced" = 0 ] || [ -n "$ENV_VERBOSE" ]; then
  for _v in LIB_TT LIB_SS LIB_FF TECHLEF CELLLEF CELLGDS CELL_VERILOG CELL_PRIMITIVES MAGICRC KLAYOUT_LYP NETGEN_SETUP; do
    _show "$_v" "${!_v}"
  done
  [ "$_sourced" = 0 ] && echo ">> Ojo: ejecutado, no 'source'. Las variables no quedan en tu terminal."
fi

unset _c _P _SCL _TTLIB _pdk_root _v
unset -f _pdk_ok _show
unset _sourced
