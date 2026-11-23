# Slides del curso: Markdown + Mermaid → PowerPoint

Una presentación `.pptx` por sesión, generada con la plantilla EELCCOM (la de `ParteDigital`).
La fuente editable es texto plano: un `.md` con el contenido de cada slide y un `.mmd` por diagrama.

```
slides/
  build/build.py              el generador (python-pptx + mmdc)
  build/assets/               logos, fondo de circuito, ícono de chip, viñeta
  build/mermaid-config.json   estilo de los diagramas (fuente y colores EELCCOM)
  ejemplo/ejemplo.md          referencia: una slide de cada layout
  sesionN/sesionN.md          la teoría de cada sesión
  sesionN/diagramas/*.mmd     diagramas Mermaid de esa sesión
  out/                        aquí salen los .pptx (no se versiona)
```

## Construir

```bash
make slides                 # todas las presentaciones
make slides S=sesion1       # solo una
make slides S=ejemplo       # la de referencia
make slides-forzar S=...    # además re-renderiza todos los diagramas
```

Requisitos (solo para el instructor; los alumnos no los necesitan):
`pip install -r slides/build/requirements.txt` y `npm install -g @mermaid-js/mermaid-cli`.
Los diagramas se re-renderizan solo si el `.mmd` cambió (caché en `sesionN/_render/`).

## Formato del `.md`

```markdown
---
titulo: Sesión 1 · PDKs y Linux para VLSI
autor: Cesar Otamendi
autor_corto: C. Otamendi
color: morado            # color por defecto de las barras de título
---

<!-- layout: contenido -->
<!-- color: rosa -->
# Título de la slide
## Lema / subtítulo (portada, sección y cierre)

- Viñeta con **negritas**, *cursivas* y `código`
  - Sub-viñeta (2 espacios): va dentro de la caja de su viñeta
- Otra viñeta

> Recuadro verde con la idea clave (va abajo)

![diagrama](diagramas/flujo.mmd)

<!-- notas:
Notas del orador, en varias líneas.
-->

---

(siguiente slide)
```

- **Separador de slides:** una línea con solo `---`.
- **Directivas:** comentarios HTML `<!-- clave: valor -->`. Se ven bien en cualquier visor de Markdown.
- **Colores:** `negro`, `morado`, `rosa`, `cian`, `verde`, `amarillo` o un hex (`FF6600`).
- **Bloques de código:** en la línea de apertura se pone el lenguaje y, opcionalmente, una etiqueta:
  ` ```bash Open Source — yosys `. Los comentarios (`#`, `//`, `--`) salen en naranja.
- **Tablas:** Markdown normal; el encabezado toma el color de la slide.

## Layouts

| Layout | Para qué | Qué usa del contenido |
| --- | --- | --- |
| `portada` | Primera slide de cada sesión (barra de logos a la derecha) | `##` lema, `#` título, imagen o viñetas |
| `seccion` | Divisor entre temas | `##` lema, `#` título, `>` recuadro |
| `contenido` | Viñetas en cajitas, tabla o párrafo; imagen opcional a la derecha | todo menos código |
| `diagrama` | Un diagrama grande (viñetas opcionales a la izquierda) | `![](x.mmd)` o PNG, `>` pie |
| `codigo` | Uno o varios bloques de terminal; viñetas opcionales a la derecha | ` ``` `, viñetas, `>` |
| `cierre` | Preguntas y resumen (barra de logos) | `##`, `#`, viñetas |

Si no se indica `layout`, se infiere: la primera slide es `portada`; si hay código, `codigo`;
si hay imagen, `diagrama`; si no, `contenido`.

## Diagramas Mermaid con los colores de la marca

El estilo base (fuente Comic, líneas negras) viene de `build/mermaid-config.json`. Para colorear
nodos con la paleta, copia estas clases al final del `.mmd`:

```
classDef morado fill:#9933FF,stroke:#000,color:#fff
classDef rosa   fill:#FF3399,stroke:#000,color:#fff
classDef cian   fill:#61CBF4,stroke:#000,color:#000
classDef verde  fill:#00B050,stroke:#000,color:#fff
classDef idea   fill:#C2F1C8,stroke:#000,color:#000
class A,B morado
```

## Cambiar la plantilla

Colores, fuentes y medidas están al inicio de `build/build.py` (sección `TEMA EELCCOM`).
Las fuentes son las de `ParteDigital`: Comic Sans MS (texto y títulos), Berlin Sans FB Demi
(portadas) y Consolas (código). Para revisar los renders en Linux sin esas fuentes, Comic Relief
tiene las mismas métricas que Comic Sans MS.
