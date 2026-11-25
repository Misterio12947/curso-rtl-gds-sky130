// =====================================================================
//  formal_churros.v  ·  La propiedad de la máquina de churros (sesión 3, Gelatina)
//  pedido y listo son entradas LIBRES: el solver las mueve como quiera.
//    $ sby -f churros.sby
// =====================================================================
module formal_churros (input wire clk, input wire rst_n, input wire pedido, input wire listo);
    wire freidora, azucar;
    maquina_churros dut (.clk(clk), .rst_n(rst_n), .pedido(pedido), .listo(listo),
                         .freidora(freidora), .azucar(azucar));

    reg f_started = 1'b0;                 // arranca con un reset
    always @(posedge clk) f_started <= 1'b1;
    always @(posedge clk) begin
        if (!f_started) assume (!rst_n);
        else            assume ( rst_n);
    end

    always @(posedge clk)                 // NUNCA freír y espolvorear a la vez
        if (f_started && rst_n)
            assert (!(freidora && azucar));
endmodule
