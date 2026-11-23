"""
extraer_celda.py · Saca UNA celda del GDS de la librería a su propio archivo
(lab01, parte 4). El GDS completo trae ~400 celdas; así KLayout abre solo la tuya.

Lo llama el Makefile (make klayout CELDA=nand2_1):
    klayout -b -r scripts/extraer_celda.py -rd gds=<lib.gds> -rd celda=<nombre> -rd salida=<celda.gds>

POR VALIDAR en la imagen del curso (probado con el módulo klayout de pip).
"""
try:
    import pya as db            # dentro de KLayout
except ImportError:
    import klayout.db as db     # pip install klayout

ly = db.Layout()
ly.read(gds)                    # noqa: F821  (variables que pasa -rd)
cel = ly.cell(celda)            # noqa: F821
if cel is None:
    raise SystemExit(f"ERROR: la celda {celda} no está en {gds}")   # noqa: F821

opt = db.SaveLayoutOptions()
opt.add_cell(cel.cell_index())  # la celda y todo lo que cuelga de ella
ly.write(salida, opt)           # noqa: F821
print(f"OK: {celda} -> {salida}")  # noqa: F821
