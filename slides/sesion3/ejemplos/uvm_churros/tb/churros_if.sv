//------------------------------------------------------------------------------
// churros_if.sv · Interface entre el ambiente UVM y la máquina de churros
//   El driver mueve las entradas en el flanco de BAJADA (como en cocotb).
//   El monitor muestrea con un clocking block justo antes del flanco de subida.
//------------------------------------------------------------------------------
interface churros_if (input logic clk);
    logic rst_n;
    logic pedido;
    logic listo;
    logic freidora;
    logic azucar;

    clocking mon_cb @(posedge clk);
        default input #1step;          // el valor de justo antes del flanco
        input rst_n, pedido, listo, freidora, azucar;
    endclocking
endinterface
