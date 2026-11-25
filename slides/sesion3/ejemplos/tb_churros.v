`timescale 1ns / 1ps
// =====================================================================
//  tb_churros.v  ·  Testbench autoverificable de la máquina de churros
//  Ejemplo de la teoría de la sesión 3 (Flan). Desde esta carpeta:
//    $ iverilog -g2012 -o sim maquina_churros.v tb_churros.v && vvp -n sim
//    $ gtkwave churros.vcd &
// =====================================================================
module tb_churros;
    reg  clk = 1'b0, rst_n = 1'b0, pedido = 1'b0, listo = 1'b0;
    wire freidora, azucar;
    integer errores = 0;

    maquina_churros dut (.clk(clk), .rst_n(rst_n), .pedido(pedido), .listo(listo),
                         .freidora(freidora), .azucar(azucar));

    always #10 clk = ~clk;                       // reloj de 20 ns

    // ---- Checker: nunca freír y espolvorear a la vez ------------------
    always @(posedge clk)
        if (rst_n && freidora && azucar) begin
            $display("[%0t] FAIL: freidora y azucar al mismo tiempo", $time);
            errores = errores + 1;
        end

    // ---- Estímulo dirigido: un pedido completo -------------------------
    initial begin
        $dumpfile("churros.vcd");
        $dumpvars(0, tb_churros);
        #25 rst_n = 1'b1;
        @(negedge clk) pedido = 1'b1;            // alguien pide churros
        @(negedge clk) pedido = 1'b0;
        if (!freidora) begin $display("FAIL: no prendió la freidora"); errores = errores + 1; end
        repeat (3) @(negedge clk);               // se fríen unos ticks
        listo = 1'b1;                            // ya están dorados
        @(negedge clk) listo = 1'b0;
        if (!azucar) begin $display("FAIL: no espolvoreó azúcar"); errores = errores + 1; end
        @(negedge clk);
        if (freidora || azucar) begin $display("FAIL: no regresó a ESPERA"); errores = errores + 1; end
        if (errores == 0) $display(">>> PASS: un pedido completo");
        else              $display(">>> FAIL: %0d error(es)", errores);
        $finish;
    end
endmodule
