"""
test_semaforo.py · Tus tests del semáforo en cocotb (lab03, parte 3)
ESTE es el archivo que editas. Lo corre:  make cocotb

Herramientas que te da el banco (cocotb/semaforo_tb.py, no se toca):
    tb = Banco(dut)
    await tb.arranca()          reloj de 20 ns + checker de una sola luz + reset
    await tb.arranca(modelo=True)   lo mismo + modelo de referencia + cobertura
    tb.luz()                    "verde", "amarillo", "rojo", "ninguna" o "varias"
    tb.T["verde"]               cuántos ticks dura el verde (también "amarillo", "rojo")
    await tb.ticks(n)           espera n ticks
    await tb.pulso(n)           ped_req = 1 durante n ticks
    await tb.reset(n)           rst_n = 0 durante n ticks
    tb.cierra()                 resumen (y revisa la cobertura si hay modelo)

Para que un test falle cuando el diseño está mal: assert condicion, "mensaje".
"""
import random

import cocotb

from semaforo_tb import Banco


@cocotb.test()
async def test_dirigido(dut):
    """Dirigido: verde -> amarillo -> rojo, con la duración de cada estado (2 vueltas)."""
    tb = Banco(dut)
    await tb.arranca()          # sin modelo: aquí el que revisa eres tú

    # Cada color debe salir en orden y quedarse tb.T[color] ticks, 2 vueltas.
    for vuelta in range(1, 3):
        for color in ("verde", "amarillo", "rojo"):
            for tick in range(1, tb.T[color] + 1):
                assert tb.luz() == color, (
                    f"vuelta {vuelta}, tick {tick} del {color}: está {tb.luz()}")
                await tb.ticks(1)
            tb.log.info("vuelta %d: %-8s %d ticks  ok", vuelta, color, tb.T[color])
    # Tras 2 vueltas debe empezar la tercera: así se revisa que el último rojo no dure de más.
    assert tb.luz() == "verde", f"después de 2 vueltas debía estar verde y está {tb.luz()}"

    tb.cierra()


@cocotb.test()
async def test_aleatorio(dut):
    """Aleatorio: pulsos de ped_req y resets al azar; checker y modelo siempre activos."""
    tb = Banco(dut)
    await tb.arranca(modelo=True)   # el comparador revisa cada tick contra el modelo

    # 300 pasos; en cada uno se elige al azar qué hacer.
    for _ in range(300):
        dado = random.random()
        if dado < 0.30:
            await tb.pulso(random.randint(1, 3))     # botón de 1 a 3 ticks
        elif dado < 0.35:
            await tb.reset(random.randint(1, 3))     # reset de 1 a 3 ticks
        else:
            await tb.ticks(random.randint(1, 6))     # solo esperar

    tb.cierra()
