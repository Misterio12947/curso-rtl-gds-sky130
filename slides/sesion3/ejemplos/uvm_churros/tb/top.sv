//------------------------------------------------------------------------------
// top.sv · Módulo superior: reloj, DUT, interface y arranque de UVM
//------------------------------------------------------------------------------
`timescale 1ns / 1ps
module top;
    import uvm_pkg::*;
    import churros_pkg::*;

    logic clk = 1'b0;
    always #10 clk = ~clk;                        // reloj de 20 ns

    churros_if vif (clk);

    maquina_churros dut (
        .clk(clk), .rst_n(vif.rst_n), .pedido(vif.pedido), .listo(vif.listo),
        .freidora(vif.freidora), .azucar(vif.azucar)
    );

    initial begin
        uvm_config_db#(virtual churros_if)::set(null, "*", "vif", vif);
        run_test();                               // el test sale de +UVM_TESTNAME
    end

`ifdef FSDB
    initial begin
        $fsdbDumpfile("churros.fsdb");            // onda para Verdi (make ... FSDB=1)
        $fsdbDumpvars(0, top);
    end
`endif
endmodule
