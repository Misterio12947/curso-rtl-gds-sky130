# Notas del PDK · Lab01 · SOLUCIÓN

**Nombre:** Solución del instructor
**PDK_ROOT que usé:** /foss/designs/pdks (o el del contenedor: lo que imprima `source ../../scripts/env.sh`)
**¿Lo bajé con ciel o usé el del contenedor?:** ciel

> POR VALIDAR contra el PDK real de la imagen del curso: los números salen de `pdk_info.sh`.

## 1. Tres celdas por dentro

| Celda | Área (µm²) | Ancho × Alto (µm) | Sitios unithd | Pines de señal |
| --- | --- | --- | --- | --- |
| sky130_fd_sc_hd__nand2_1 | 3.7536 | 1.38 × 2.72 | 3 | A, B → Y |
| sky130_fd_sc_hd__dfrtp_1 | 25.024 | 9.2 × 2.72 | 20 | CLK, D, RESET_B → Q |
| sky130_fd_sc_hd__inv_1 | 3.7536 | 1.38 × 2.72 | 3 | A → Y |

Además, toda celda tiene 4 pines de alimentación: VPWR y VGND (rieles) y VPB y VNB (pozo y sustrato).
Área = ancho × alto: 1.38 × 2.72 = 3.7536. El ancho siempre es un múltiplo del sitio (0.46 µm).

## 2. Corners disponibles

Los que liste `ls $SCL_DIR/lib`. Al menos estos tres son los que usa el curso:

- tt_025C_1v80
- ss_100C_1v60
- ff_n40C_1v95

## 3. Preguntas

1. ¿Por qué todas las celdas tienen el mismo alto?
   - Para acomodarse en filas: todas miden 2.72 µm (una fila de sitios `unithd`), y así comparten los rieles VPWR arriba y VGND abajo con sus vecinas. Lo que cambia es el ancho, en múltiplos de 0.46 µm.
2. Para revisar **setup** (que el reloj alcance), ¿qué corner usarías? ¿Y para **hold**? ¿Por qué?
   - Setup en `ss_100C_1v60`: proceso lento, caliente y voltaje bajo, donde el dato tarda más en llegar. Hold en `ff_n40C_1v95`: proceso rápido, frío y voltaje alto, donde el dato puede llegar demasiado pronto.
3. El `dfrtp_1` es el flip-flop que usará el semáforo. ¿Cuántas `nand2_1` caben en su área?
   - 25.024 / 3.7536 ≈ 6.7, o sea 6 (20 sitios contra 3). Por eso los registros dominan el área del semáforo en la sesión 4.
