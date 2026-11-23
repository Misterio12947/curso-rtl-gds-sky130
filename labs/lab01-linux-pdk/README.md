# Lab 01 · PDKs y Linux para VLSI

Al salir, sabes **dónde vive cada vista del PDK** y te mueves en Linux y git **sin rutas absolutas**.
Todo se hace dentro del contenedor `iic-osic-tools`. Cada parte se autocomprueba con `make`.

| Parte | Tiempo | Qué haces | Cómo sabes que quedó |
| --- | --- | --- | --- |
| 1 · Arranque | 10 min | Contenedor, carpeta compartida, tu copia del repo | `make check` |
| 2 · Linux y rutas | 15 min | 8 retos en `respuestas_rutas.txt` | `make rutas` |
| 3 · Git | 15 min | Tu rama, tu primer commit, push a tu fork | `make git-check` |
| 4 · PDK | 20 min | Bajar el PDK, explorarlo, completar `pdk_info.sh`, ver una celda | `make celda`, `make entrega` |

**Entregable:** commit en tu rama `alumno/<tu-nombre>` con `notas_pdk.md` lleno
(área y tamaño de 3 celdas, corners disponibles), `pdk_info.sh` completo y `respuestas_rutas.txt`.

---

## Parte 1 · Arranque (10 min)

1. Levanta el contenedor desde la carpeta de `iic-osic-tools` en tu máquina:

   ```bash
   ./start_vnc.sh        # Windows/Mac: luego abre http://localhost  (contraseña: abc123)
   ./start_x.sh          # Linux o WSL2
   ```

2. Abre una terminal **dentro** del contenedor y ve a la carpeta compartida:

   ```bash
   cd /foss/designs
   echo "hola desde el contenedor" > hola.txt
   ```

   Busca `hola.txt` en tu máquina, en la carpeta que el contenedor monta como `/foss/designs`
   (por defecto `~/eda/designs`). **Si no lo ves ahí, tu trabajo se perderá al borrar el contenedor.** Avisa.

3. Haz **fork** del repo del curso en GitHub (botón *Fork* en
   `github.com/Misterio12947/curso-rtl-gds-sky130`) y clona **tu** fork:

   ```bash
   cd /foss/designs
   git clone https://github.com/<tu-usuario>/curso-rtl-gds-sky130.git
   cd curso-rtl-gds-sky130/labs/lab01-linux-pdk
   make check
   ```

   En la parte 3 vemos qué acabas de hacer. Por ahora basta con que `make check` diga `LISTO`
   en las herramientas (el PDK puede fallar todavía: lo resolvemos en la parte 4).

---

## Parte 2 · Linux y rutas relativas (15 min)

Los comandos que vas a usar:

| Comando | Para qué | Ejemplo |
| --- | --- | --- |
| `pwd` | ¿dónde estoy? | `pwd` |
| `ls -la` | ¿qué hay aquí? (con ocultos) | `ls -la ../..` |
| `cd` | moverse | `cd ../../common` · `cd -` regresa |
| `mkdir -p` | crear carpetas (y sus padres) | `mkdir -p prueba/a/b` |
| `cp` / `mv` / `rm` | copiar / mover / borrar | `cp a.txt b.txt` |
| `less` | leer un archivo largo (`q` para salir) | `less ../../README.md` |
| `find` | buscar archivos por nombre | `find ../.. -name "*.v"` |
| `grep` | buscar texto dentro de archivos | `grep -n module ../../common -r` |
| `wc -l` | contar líneas | `wc -l archivo` |
| `which` | ¿dónde está un programa? | `which klayout` |
| `echo $VAR` / `export` | ver / fijar variables | `echo $PDK_ROOT` |

`.` es "aquí", `..` es "un nivel arriba" y `~` es tu home. Una ruta **absoluta** empieza en `/`
(`/foss/designs/...`); una **relativa** empieza desde donde estás (`../../common/...`).

**Retos:** abre `respuestas_rutas.txt`, responde los 8 retos (cada respuesta en una sola línea) y revisa:

```bash
make rutas
```

> **Para discutir:** todos los Makefiles del curso usan `../../common/...` y nunca `/foss/designs/...`.
> ¿Qué pasaría si tu compañero clonó el repo en otra carpeta?

---

## Parte 3 · Git, la bitácora del chip (15 min)

En la parte 1 hiciste dos cosas: un **fork** (tu copia del repo en GitHub, donde sí puedes escribir)
y un **clone** (la copia de tu fork en el contenedor). Ahora:

```bash
# 1) Quién eres (una sola vez por contenedor)
git config --global user.name  "Tu Nombre"
git config --global user.email "tu@correo.com"

# 2) De dónde viene el material del curso (para traer los labs nuevos)
git remote add upstream https://github.com/Misterio12947/curso-rtl-gds-sky130.git

# 3) Tu rama de trabajo: aquí van todos tus labs
git switch -c alumno/<tu-nombre>

# 4) Edita notas_pdk.md (pon tu nombre arriba), y luego:
git status                  # ¿qué cambió?
git diff                    # ¿qué cambió exactamente?
git add notas_pdk.md
git commit -m "lab01: empiezo mis notas del PDK"
git log --oneline -5

# 5) Súbelo a TU fork
git push -u origin alumno/<tu-nombre>
```

Para el `push`, GitHub pide tu usuario y, como contraseña, un **token** (*Settings → Developer settings →
Personal access tokens*), no tu contraseña normal.

```bash
make git-check
```

**Qué NO se sube nunca:** el PDK, nada bajo NDA, ni resultados que se regeneran (`.gds`, `.vcd`, `runs/`...).
Revisa el `.gitignore` de la raíz: ya los excluye.

---

## Parte 4 · El PDK por dentro (20 min)

### 4.1 Bajar el PDK

**Opción A, con `ciel`** (lo que haría un Flow Engineer). Lo guardamos en `/foss/designs/pdks`
para que sobreviva aunque borres el contenedor (ocupa varios GB):

```bash
ciel ls-remote --pdk-family sky130 | head            # versiones disponibles
ciel enable --pdk-family sky130 --pdk-root /foss/designs/pdks <HASH>   # el hash que indique el instructor
```

**Opción B, si la red está saturada** o sale un error de *rate limit*: usa el PDK que ya trae el contenedor.
No tienes que hacer nada: `env.sh` lo encuentra solo.

En cualquiera de los dos casos:

```bash
source ../../scripts/env.sh          # dice qué PDK encontró
echo $PDK_ROOT $PDK
ENV_VERBOSE=1 source ../../scripts/env.sh   # y todas las rutas que fijó
```

### 4.2 Explorar

Responde con `ls`, `find`, `grep` y `less` (las respuestas van a `notas_pdk.md`):

```bash
ls $PDK_ROOT/$PDK                        # libs.ref  vs  libs.tech
ls $SCL_DIR                              # las vistas de la librería de celdas
ls $SCL_DIR/lib                          # un .lib por corner
grep -c "cell (" $LIB_TT                 # ¿cuántas celdas hay?
grep -A3 'cell ("sky130_fd_sc_hd__nand2_1")' $LIB_TT | less
grep -A8 "MACRO sky130_fd_sc_hd__nand2_1" $CELLLEF
```

- ¿Qué diferencia hay entre `libs.ref/` y `libs.tech/`?
- ¿Qué vista usa síntesis? ¿Cuál usa PnR? ¿Cuál termina en el GDS final?

Compara con la radiografía: `make pdk`.

### 4.3 Tu script: `pdk_info.sh`

`pdk_info.sh` imprime la ficha de una celda: **área** (del `.lib`), **tamaño** y **pines** (del `.lef`).
El reporte ya está hecho; tú completas los **3 TODO**, uno por dato: en cada uno quitas los `#`
de las líneas de `awk` y llenas los huecos `____`.

```bash
make celda CELDA=nand2_1
make celda CELDA=dfrtp_1        # el flip-flop que usará el semáforo
```

Con `pdk_info.sh` llena la tabla de `notas_pdk.md` (la tercera celda la eliges tú).

### 4.4 Ver la celda

```bash
make klayout CELDA=nand2_1
```

Saca la celda del GDS de la librería y la abre en KLayout con los colores de SKY130.
Busca: los rieles de alimentación arriba y abajo (`met1`), el polisilicio de las compuertas
y los pines `A`, `B`, `Y`. ¿Coincide el ancho con lo que dijo `pdk_info.sh`?

---

## Final

```bash
make entrega
git add notas_pdk.md pdk_info.sh respuestas_rutas.txt
git commit -m "lab01: notas del PDK y pdk_info.sh"
git push
```

## ¿Te atoraste?

Las soluciones están en la rama `soluciones` del repo del curso. Úsalas para **comparar**, no para copiar:

```bash
git fetch upstream
git diff alumno/<tu-nombre> upstream/soluciones -- pdk_info.sh
```

## Origen

Lab nuevo del curso. La estructura del repo y el `.gitignore` vienen de `galletas-y-postres-chips`.
