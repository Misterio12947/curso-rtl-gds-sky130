#!/usr/bin/env python3
"""run_churros.py · Corre test_churros.py con Icarus (cocotb 2.x). Desde esta carpeta."""
from pathlib import Path

from cocotb_tools.runner import get_runner

aqui = Path(__file__).resolve().parent
sim = get_runner("icarus")
sim.build(sources=[aqui / "maquina_churros.v"], hdl_toplevel="maquina_churros",
          build_dir=aqui / "build", always=True, waves=True, timescale=("1ns", "1ps"))
sim.test(test_module="test_churros", hdl_toplevel="maquina_churros",
         test_dir=aqui, build_dir=aqui / "build", waves=True)
