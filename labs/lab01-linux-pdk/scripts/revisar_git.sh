#!/usr/bin/env bash
# =====================================================================
#  revisar_git.sh · ¿Quedó bien tu git? (lab01, parte 3)
#  Se corre con:  make git-check
# =====================================================================
cd "$(dirname "$0")/.." || exit 1

ok=0; mal=0
if [ -t 1 ]; then V=$'\033[32m' R=$'\033[31m' A=$'\033[33m' N=$'\033[0m'; else V= R= A= N=; fi
bien()  { printf '  %s[ OK ]%s %s\n' "$V" "$N" "$1"; ok=$((ok+1)); }
falla() { printf '  %s[MAL ]%s %s\n         -> %s\n' "$R" "$N" "$1" "$2"; mal=$((mal+1)); }
aviso() { printf '  %s[ ?? ]%s %s\n' "$A" "$N" "$1"; }

echo "== Git =="
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  falla "Esto no es un repo de git" "clona tu fork:  git clone https://github.com/<tu-usuario>/curso-rtl-gds-sky130.git"
  exit 1
fi

n=$(git config user.name); e=$(git config user.email)
[ -n "$n" ] && bien "user.name = $n" || falla "Falta tu nombre" 'git config --global user.name "Tu Nombre"'
[ -n "$e" ] && bien "user.email = $e" || falla "Falta tu correo" 'git config --global user.email "tu@correo.com"'

rama=$(git branch --show-current)
case "$rama" in
  alumno/?*) bien "Estás en tu rama: $rama" ;;
  *) falla "Estás en la rama '$rama'" "crea la tuya:  git switch -c alumno/<tu-nombre>" ;;
esac

base=origin/main; git rev-parse -q --verify "$base" >/dev/null || base=main
propios=$(git rev-list --count "$base"..HEAD 2>/dev/null || echo 0)
[ "$propios" -ge 1 ] && bien "Tienes $propios commit(s) propios sobre $base" \
                     || falla "Aún no tienes commits propios" "git add notas_pdk.md && git commit -m \"lab01: notas del PDK\""

url=$(git remote get-url origin 2>/dev/null)
case "$url" in
  *Misterio12947/curso-rtl-gds-sky130*)
    falla "origin apunta al repo del curso (ahí no puedes hacer push)" "haz fork en GitHub y:  git remote set-url origin <url-de-tu-fork>" ;;
  "") falla "No hay remoto origin" "git remote add origin <url-de-tu-fork>" ;;
  *) bien "origin = $url (tu fork)" ;;
esac
git remote get-url upstream >/dev/null 2>&1 \
  && bien "upstream = $(git remote get-url upstream)" \
  || aviso "Opcional: git remote add upstream https://github.com/Misterio12947/curso-rtl-gds-sky130.git"

if git rev-parse -q --verify '@{u}' >/dev/null 2>&1; then
  pend=$(git rev-list --count '@{u}'..HEAD)
  [ "$pend" -eq 0 ] && bien "Todo está subido a $(git rev-parse --abbrev-ref '@{u}')" \
                    || falla "Tienes $pend commit(s) sin subir" "git push"
else
  falla "Tu rama no está en GitHub todavía" "git push -u origin $rama"
fi

sucios=$(git status --porcelain | grep -v '^??' | wc -l)
[ "$sucios" -eq 0 ] || aviso "Tienes $sucios archivo(s) modificados sin commit (git status)"

echo "== $ok OK, $mal por corregir =="
exit "$mal"
