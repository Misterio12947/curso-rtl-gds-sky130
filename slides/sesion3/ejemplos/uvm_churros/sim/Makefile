#-------------------------------------------------------------------------------
# Demo UVM de la máquina de churros con VCS (sesión 3 · Flan)
# Se corre DESDE esta carpeta:  cd slides/sesion3/ejemplos/uvm_churros/sim
#
#   make compile                      compila el ambiente con VCS
#   make sim TEST=churros_random_test SEED=7
#   make regress                      dirigido + aleatorio con 3 semillas + cobertura
#   make bug                          los mismos tests sobre el RTL con bug
#   make verdi                        cobertura en Verdi (make sim FSDB=1 para la onda)
#-------------------------------------------------------------------------------
TEST     ?= churros_random_test
SEED     ?= 1
FILELIST ?= filelist.f
SIMV     ?= simv
UVM_VERB ?= UVM_LOW

COV_FLAGS = -cm line+cond+fsm+tgl+branch
VCS_FLAGS = -full64 -sverilog -debug_access+all -kdb \
            -ntb_opts uvm-1.2 -timescale=1ns/1ps $(COV_FLAGS) \
            $(if $(FSDB),+define+FSDB)
SIM_FLAGS = +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(UVM_VERB) \
            +ntb_random_seed=$(SEED) $(COV_FLAGS) -cm_name $(TEST)_$(SEED) -cm_dir $(SIMV).vdb

.PHONY: help compile sim regress cov verdi bug clean

help:
	@sed -n '2,12p' Makefile

compile:
	vcs $(VCS_FLAGS) -f $(FILELIST) -l compile_$(SIMV).log -o $(SIMV)

sim:
	./$(SIMV) $(SIM_FLAGS) -l sim_$(TEST)_$(SEED).log
	@grep -E "SCB|COV|TEST \*\*\*|UVM_ERROR :|UVM_FATAL :" sim_$(TEST)_$(SEED).log | grep -v "^UVM_INFO @ 0" || true

regress: compile
	$(MAKE) sim TEST=churros_directed_test SEED=1
	$(MAKE) sim TEST=churros_random_test   SEED=1
	$(MAKE) sim TEST=churros_random_test   SEED=2
	$(MAKE) sim TEST=churros_random_test   SEED=3
	$(MAKE) cov

cov:
	urg -dir $(SIMV).vdb -format both -report cov_report
	@echo "=== Reporte HTML en: cov_report/dashboard.html ==="

verdi:
	verdi -cov -covdir $(SIMV).vdb &

bug:
	$(MAKE) compile FILELIST=filelist_bug.f SIMV=simv_bug
	$(MAKE) sim SIMV=simv_bug TEST=churros_directed_test SEED=1
	$(MAKE) sim SIMV=simv_bug TEST=churros_random_test   SEED=1

clean:
	rm -rf simv* csrc *.log *.key *.vdb cov_report ucli.key vc_hdrs.h verdiLog novas* *.fsdb AN.DB
