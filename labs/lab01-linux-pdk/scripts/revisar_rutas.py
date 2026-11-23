#!/usr/bin/env python3
"""
revisar_rutas.py · Revisa respuestas_rutas.txt (lab01, parte 2)

Se corre con:  make rutas   (desde labs/lab01-linux-pdk)

Cada reto es de uno de dos tipos:
  comando -> se ejecuta en bash DESDE ESTA CARPETA y se revisa su salida
  ruta    -> se revisa que la ruta relativa llegue al archivo pedido
En los retos marcados "sin rutas absolutas" no se vale empezar con /, ~ ni $HOME.
"""
import os
import re
import subprocess
import sys
from pathlib import Path

LAB = Path(__file__).resolve().parent.parent          # labs/lab01-linux-pdk
REPO = LAB.parent.parent                              # raíz del repo
SEM = REPO / "common/rtl/semaphore/rtl/semaphore.v"

VERDE, ROJO, AMAR, NORM = "\033[32m", "\033[31m", "\033[33m", "\033[0m"
if not sys.stdout.isatty():
    VERDE = ROJO = AMAR = NORM = ""


def correr(cmd):
    r = subprocess.run(["bash", "-c", cmd], cwd=LAB, capture_output=True, text=True, timeout=20)
    return r.returncode, r.stdout, r.stderr


def absoluta(cmd):
    return re.search(r"(^|[\s=:'\"(])(/|~)", cmd) or "$HOME" in cmd or "${HOME}" in cmd


def lineas(texto):
    return [l.strip() for l in texto.strip().splitlines() if l.strip()]


# ---------------------------------------------------------------------
#  Cada revisor recibe la respuesta y regresa (ok, mensaje)
# ---------------------------------------------------------------------
def r1(resp):  # cat del README del semáforo
    if absoluta(resp):
        return False, "usa una ruta RELATIVA (sin /, ~ ni $HOME al inicio)"
    rc, out, err = correr(resp)
    esperado = (REPO / "common/rtl/semaphore/README.md").read_text()
    if rc == 0 and out.strip() == esperado.strip():
        return True, "mostraste el README completo"
    return False, f"la salida no es el README del semáforo ({err.strip()[:80] or 'revisa la ruta'})"


def ruta_desde(origen, destino):
    def rev(resp):
        if resp.startswith(("/", "~", "$HOME")):
            return False, "esa ruta es absoluta: escríbela relativa a " + origen
        p = os.path.normpath(REPO / origen / resp)
        if Path(p) == destino.resolve() and Path(p).exists():
            return True, f"desde {origen} llegas a {destino.name}"
        return False, f"desde {origen} esa ruta lleva a {os.path.relpath(p, REPO)}"
    return rev


def r3(resp):  # wc -l semaphore.v
    if absoluta(resp):
        return False, "usa una ruta relativa"
    rc, out, _ = correr(resp)
    n = len(SEM.read_text().splitlines())
    nums = re.findall(r"\d+", out)
    if rc == 0 and nums and int(nums[0]) == n:
        return True, f"{n} líneas"
    return False, "el número no coincide (¿qué comando cuenta líneas?)"


def r4(resp):  # find de Makefiles
    if absoluta(resp):
        return False, "usa una ruta relativa"
    rc, out, _ = correr(resp)
    esperado = {p.resolve() for p in REPO.rglob("Makefile") if ".git" not in p.parts}
    obtenido = {(LAB / l).resolve() for l in lineas(out)}
    if rc == 0 and obtenido == esperado:
        return True, f"encontraste los {len(esperado)} Makefile"
    falta = len(esperado - obtenido)
    return False, f"te faltan {falta} Makefile o sobran líneas (¿buscaste desde la raíz del repo?)"


def r5(resp):  # grep parameter
    if absoluta(resp):
        return False, "usa una ruta relativa"
    rc, out, _ = correr(resp)
    esperado = [l.strip() for l in SEM.read_text().splitlines() if re.search(r"\bparameter\b", l)]
    salida = lineas(out)
    if rc == 0 and esperado and all(any(e in s for s in salida) for e in esperado) and len(salida) <= len(esperado) + 2:
        return True, f"{len(esperado)} líneas con parameter"
    return False, "no salen exactamente las líneas que declaran parámetros"


def r6(resp):  # which yosys
    rc, out, _ = correr(resp)
    p = out.strip().splitlines()[0] if out.strip() else ""
    if rc == 0 and p and os.access(p, os.X_OK) and os.path.basename(p) == "yosys":
        return True, p
    if not subprocess.run(["bash", "-c", "command -v yosys"], capture_output=True).stdout:
        return None, "yosys no está en este equipo: no lo puedo comprobar aquí (en el contenedor sí)"
    return False, "eso no imprime la ruta del ejecutable de yosys"


def r7(resp):  # cuántos .lib hay, usando $SCL_DIR
    if not os.environ.get("SCL_DIR"):
        return None, "falta el PDK: corre  source ../../scripts/env.sh  y repite"
    if "SCL_DIR" not in resp:
        return False, "usa la variable $SCL_DIR (no escribas la ruta a mano)"
    rc, out, _ = correr(resp)
    n = len(list((Path(os.environ["SCL_DIR"]) / "lib").glob("*.lib")))
    nums = re.findall(r"\d+", out)
    if rc == 0 and nums and int(nums[-1]) == n:
        return True, f"{n} archivos .lib (uno por corner)"
    return False, "el número no coincide"


RETOS = {
    1: ("comando", "Muestra con cat el README del semáforo (sin rutas absolutas)", r1),
    2: ("ruta", "Ruta relativa a semaphore.v desde labs/lab03-verif",
        ruta_desde("labs/lab03-verif", SEM)),
    3: ("comando", "Cuántas líneas tiene semaphore.v (sin rutas absolutas)", r3),
    4: ("comando", "Encuentra TODOS los Makefile del repo (sin rutas absolutas)", r4),
    5: ("comando", "Las líneas de semaphore.v que declaran un parameter (sin rutas absolutas)", r5),
    6: ("comando", "¿Dónde está instalado yosys?", r6),
    7: ("comando", "Cuántos .lib (corners) hay, usando la variable $SCL_DIR", r7),
    8: ("ruta", "Ruta relativa a scripts/env.sh desde common/rtl/semaphore/tb",
        ruta_desde("common/rtl/semaphore/tb", REPO / "scripts/env.sh")),
}


def main():
    archivo = LAB / "respuestas_rutas.txt"
    resp = {}
    for l in archivo.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^R(\d+):\s*(.*?)\s*$", l)
        if m:
            resp[int(m.group(1))] = m.group(2)
    ok = 0
    print("== Retos de rutas (respuestas_rutas.txt) ==")
    for n, (tipo, desc, rev) in RETOS.items():
        r = resp.get(n, "")
        if not r:
            print(f"  {AMAR}[ -- ]{NORM} R{n} {desc}: sin responder")
            continue
        try:
            bien, msg = rev(r)
        except subprocess.TimeoutExpired:
            bien, msg = False, "el comando tardó demasiado"
        if bien is None:
            print(f"  {AMAR}[ ?? ]{NORM} R{n} {msg}")
            ok += 1
        elif bien:
            print(f"  {VERDE}[ OK ]{NORM} R{n} {msg}")
            ok += 1
        else:
            print(f"  {ROJO}[MAL ]{NORM} R{n} {desc}: {msg}")
    print(f"== {ok}/{len(RETOS)} ==")
    print("Para discutir: ¿por qué los Makefiles del curso usan ../../ y nunca /foss/designs/...?")
    sys.exit(0 if ok == len(RETOS) else 1)


if __name__ == "__main__":
    main()
