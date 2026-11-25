`timescale 1ns / 1ps
// =====================================================================
//  maquina_churros_bug.v  ·  La máquina de churros CON UN BUG (demo UVM, sesión 3)
//  Si llega 'listo' mientras alguien sigue pidiendo, no pasa al azúcar.
//  El test dirigido NO lo ve; el aleatorio sí.
//  Una FSM Moore con las mismas 4 piezas que el semáforo, pero con
//  entradas que deciden a qué estado se sigue.
//
//  Lint y esquemático, desde esta carpeta:
//    $ verilator --lint-only -Wall maquina_churros.v
//    $ yosys -p "read_verilog maquina_churros.v; proc; opt; show -width"
// =====================================================================
module maquina_churros (
    input  wire clk,
    input  wire rst_n,      // reset asíncrono, activo en bajo
    input  wire pedido,     // alguien pidió churros
    input  wire listo,      // ya están dorados
    output wire freidora,   // prende la freidora
    output wire azucar      // espolvorea azúcar
);

    // ---- A · Codificación de estados ----------------------------------
    localparam [1:0] ESPERA = 2'd0,
                     FREIR  = 2'd1,
                     AZUCAR = 2'd2;

    reg [1:0] estado, siguiente;

    // ---- B · Siguiente estado (combinacional) -------------------------
    always @(*) begin
        siguiente = estado;                    // por defecto: me quedo
        case (estado)
            ESPERA:  if (pedido) siguiente = FREIR;
            FREIR:   if (listo && !pedido) siguiente = AZUCAR;   // BUG: si siguen pidiendo, ignora listo
            AZUCAR:              siguiente = ESPERA;
            default:             siguiente = ESPERA;
        endcase
    end

    // ---- C · Registro de estado (secuencial) --------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) estado <= ESPERA;
        else        estado <= siguiente;
    end

    // ---- D · Salidas (Moore: solo dependen del estado) ----------------
    assign freidora = (estado == FREIR);
    assign azucar   = (estado == AZUCAR);

endmodule
