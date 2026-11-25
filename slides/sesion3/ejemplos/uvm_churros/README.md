# Demo UVM · máquina de churros con VCS (sesión 3, Flan)

Ambiente UVM 1.2 completo y pequeño para la demo de la teoría: el mismo DUT de los ejemplos
(`../maquina_churros.v`), con las piezas que se usan en la industria.

| Archivo | Pieza |
| --- | --- |
| `tb/churros_if.sv` | Interface con clocking block para el monitor |
| `tb/churros_item.sv` | Transacción con `rand` y `constraint` |
| `tb/churros_seqs.sv` | Secuencias: reset, aleatoria (300 ciclos) y dirigida |
| `tb/churros_driver.sv` | Driver: aplica cada item en el flanco de bajada |
| `tb/churros_monitor.sv` | Monitor: publica un item por ciclo |
| `tb/churros_scoreboard.sv` | Modelo de referencia + comparador (`uvm_error`) |
| `tb/churros_coverage.sv` | Covergroup con bins, `illegal_bins` y `cross` |
| `tb/churros_env.sv` | Agent y env |
| `tb/churros_tests.sv` | `churros_directed_test` y `churros_random_test` (PASSED/FAILED al final) |
| `tb/top.sv` | Reloj de 20 ns, DUT, `uvm_config_db` y `run_test()` |
| `rtl_bug/maquina_churros_bug.v` | El DUT con un bug: ignora `listo` si siguen pidiendo |

## Correr (máquina con licencia de VCS, no el contenedor de los alumnos)

```bash
cd slides/sesion3/ejemplos/uvm_churros/sim
make regress                                 # dirigido + 3 aleatorios + reporte URG
make sim TEST=churros_random_test SEED=7     # una corrida
make bug                                     # los mismos tests con el RTL con bug
make verdi                                   # cobertura en Verdi
make compile FSDB=1 && make sim              # con onda: verdi -ssf churros.fsdb
```

Esperado: con el RTL bueno, los 4 tests dicen `*** TEST PASSED ***`. Con `make bug`, el dirigido
pasa (nunca pide y avisa "listo" en el mismo ciclo) y el aleatorio da `UVM_ERROR ... [SCB]`.

Estado: el código elabora sin errores con slang contra UVM (accellera uvm-core); la corrida con VCS
está **POR VALIDAR**.
