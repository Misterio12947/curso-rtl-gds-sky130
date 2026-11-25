//------------------------------------------------------------------------------
// churros_pkg.sv · Todo el ambiente UVM en un paquete
//------------------------------------------------------------------------------
package churros_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "churros_item.sv"
    `include "churros_seqs.sv"
    `include "churros_driver.sv"
    `include "churros_monitor.sv"
    `include "churros_scoreboard.sv"
    `include "churros_coverage.sv"
    `include "churros_env.sv"
    `include "churros_tests.sv"
endpackage
