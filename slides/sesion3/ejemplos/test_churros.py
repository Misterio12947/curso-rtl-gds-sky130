"""
test_churros.py · La máquina de churros en cocotb 2.x (teoría de la sesión 3)
Desde esta carpeta:   python3 run_churros.py
"""
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge


async def arranca(dut):
    dut.pedido.value = 0
    dut.listo.value = 0
    dut.rst_n.value = 0
    Clock(dut.clk, 20, unit="ns").start(start_high=False)   # reloj de 20 ns
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1


@cocotb.test()
async def test_un_pedido(dut):
    """Dirigido: pedido -> FREIR -> listo -> AZUCAR -> ESPERA."""
    await arranca(dut)
    dut.pedido.value = 1
    await FallingEdge(dut.clk)
    dut.pedido.value = 0
    assert dut.freidora.value == 1, "no prendió la freidora"
    dut.listo.value = 1
    await FallingEdge(dut.clk)
    dut.listo.value = 0
    assert dut.azucar.value == 1, "no espolvoreó azúcar"
    await FallingEdge(dut.clk)
    assert dut.freidora.value == 0 and dut.azucar.value == 0, "no regresó a ESPERA"


@cocotb.test()
async def test_al_azar(dut):
    """Aleatorio: pedido y listo al azar; el modelo dice qué debe salir."""
    await arranca(dut)
    estado = "ESPERA"                                       # modelo de referencia
    for _ in range(200):
        pedido, listo = random.random() < 0.3, random.random() < 0.3
        dut.pedido.value, dut.listo.value = int(pedido), int(listo)
        await FallingEdge(dut.clk)
        if estado == "ESPERA" and pedido:
            estado = "FREIR"
        elif estado == "FREIR" and listo:
            estado = "AZUCAR"
        elif estado == "AZUCAR":
            estado = "ESPERA"
        assert dut.freidora.value == (estado == "FREIR"), f"freidora mal en {estado}"
        assert dut.azucar.value == (estado == "AZUCAR"), f"azúcar mal en {estado}"
