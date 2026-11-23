#!/usr/bin/env bash
# =====================================================================
#  pdk_info.sh · Ficha técnica de una celda estándar de SKY130
#
#  Uso:   ./pdk_info.sh <celda> [corner]
#         ./pdk_info.sh nand2_1
#         ./pdk_info.sh sky130_fd_sc_hd__dfrtp_1 ss_100C_1v60
#
#  Lee dos vistas del PDK:
#    .lib  (libs.ref/sky130_fd_sc_hd/lib/)  -> área      (la usa síntesis)
#    .lef  (libs.ref/sky130_fd_sc_hd/lef/)  -> tamaño y pines (los usa PnR)
#
#  Requiere haber hecho:  source ../../scripts/env.sh
#
#  TU TAREA: completar los 3 TODO (uno por dato). Pruébalo con:
#     make celda CELDA=nand2_1
# =====================================================================
set -u

if [ $# -lt 1 ]; then
  echo "Uso: $0 <celda> [corner]      p.ej.  $0 nand2_1" >&2
  exit 1
fi
if [ -z "${SCL_DIR:-}" ]; then
  echo "ERROR: primero fija el PDK:  source ../../scripts/env.sh" >&2
  exit 1
fi

LIBNAME=sky130_fd_sc_hd
CELDA=$1
case "$CELDA" in
  ${LIBNAME}__*) ;;                       # ya viene con el prefijo
  *) CELDA="${LIBNAME}__${CELDA}" ;;      # nand2_1 -> sky130_fd_sc_hd__nand2_1
esac
CORNER=${2:-tt_025C_1v80}

LIB="$SCL_DIR/lib/${LIBNAME}__${CORNER}.lib"
LEF="$SCL_DIR/lef/${LIBNAME}.lef"
for f in "$LIB" "$LEF"; do
  [ -f "$f" ] || { echo "ERROR: no existe $f" >&2; exit 1; }
done

# ---------------------------------------------------------------------
# 1) ÁREA (.lib)
#    En el .lib cada celda empieza con:   cell ("sky130_fd_sc_hd__nand2_1") {
#    y más abajo tiene una línea:          area : 3.7536000000;
#    Busca la primera línea "area" DESPUÉS de que aparece tu celda.
# ---------------------------------------------------------------------
#  TODO 1: quita los "#" de las 4 líneas de abajo y llena el hueco ____
#          (pista: ¿qué palabra está en el campo $1 de la línea del área?)
AREA=""
# AREA=$(awk -v c="$CELDA" '
#   index($0, "cell (\"" c "\")") { dentro = 1 }
#   dentro && $1 == "____" { gsub(/;/, "", $3); print $3 + 0; exit }
# ' "$LIB")

# ---------------------------------------------------------------------
# 2) TAMAÑO (.lef)
#    En el LEF cada celda es un bloque  MACRO <celda> ... END <celda>
#    y adentro tiene:                   SIZE  1.380000 BY  2.720000 ;
#    Imprime el ancho y el alto (campos 2 y 4 de esa línea).
# ---------------------------------------------------------------------
#  TODO 2: quita los "#" y llena los huecos.
#          (pista: ¿en qué campos $N quedan "1.380000" y "2.720000"?)
ANCHO=""; ALTO=""
# read -r ANCHO ALTO < <(awk -v c="$CELDA" '
#   $1 == "MACRO" && $2 == c { dentro = 1 }
#   dentro && $1 == "____"   { print $__ + 0, $__ + 0; exit }
# ' "$LEF")

# ---------------------------------------------------------------------
# 3) PINES (.lef)
#    Dentro del MACRO, cada pin es:     PIN A
#                                         DIRECTION INPUT ;
#    Imprime una línea por pin:  "<nombre> <dirección>"
# ---------------------------------------------------------------------
#  TODO 3: quita los "#" y llena los huecos.
#          (pista: hay que recordar el nombre del pin hasta ver su DIRECTION,
#           y dejar de leer cuando llega el END de la celda)
PINES=""
# PINES=$(awk -v c="$CELDA" '
#   $1 == "MACRO" && $2 == c                  { dentro = 1 }
#   dentro && $1 == "END" && $2 == c          { ____ }
#   dentro && $1 == "PIN"                     { pin = $__ }
#   dentro && $1 == "____" && pin != ""       { print pin, $2; pin = "" }
# ' "$LEF")

# ---------------------------------------------------------------------
#  Reporte (ya está hecho: no hay que tocarlo)
# ---------------------------------------------------------------------
if ! grep -qE "^MACRO[[:space:]]+${CELDA}[[:space:]]*$" "$LEF"; then
  echo "No encontré la celda '$CELDA'. Prueba:  grep -o '${LIBNAME}__[a-z0-9_]*' \"$LEF\" | sort -u | less" >&2
  exit 2
fi

SITIO=0.46   # ancho del sitio unithd en µm (techlef)
SITIOS=$(awk -v w="${ANCHO:-0}" -v s="$SITIO" 'BEGIN { printf "%d", w / s + 0.5 }')

echo "Celda   : $CELDA"
echo "Corner  : $CORNER"
echo "Área    : ${AREA:-TODO} µm²            (.lib)"
echo "Tamaño  : ${ANCHO:-TODO} x ${ALTO:-TODO} µm  = $SITIOS sitios unithd   (.lef)"
echo "Pines   :"
if [ -n "$PINES" ]; then
  echo "$PINES" | awk '{ printf "  %-8s %s\n", $1, tolower($2) }'
else
  echo "  TODO"
fi
