//------------------------------------------------------------------------------
// churros_scoreboard.sv · Scoreboard: modelo de referencia + comparador
//   En cada ciclo: ¿las salidas del DUT son las que el modelo predice?
//------------------------------------------------------------------------------
class churros_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(churros_scoreboard)
    uvm_analysis_imp #(churros_item, churros_scoreboard) imp;

    typedef enum {ESPERA, FREIR, AZUCAR} estado_t;
    estado_t modelo = ESPERA;
    int unsigned revisados, errores;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    // Llega una transacción del monitor (valores de justo antes del flanco)
    function void write(churros_item t);
        if (!t.rst_n) begin                       // reset asíncrono
            modelo = ESPERA;
            return;
        end
        revisados++;
        if (t.freidora !== (modelo == FREIR) || t.azucar !== (modelo == AZUCAR)) begin
            errores++;
            `uvm_error("SCB", $sformatf("en %s: freidora=%0b azucar=%0b (esperaba %0b %0b)",
                       modelo.name(), t.freidora, t.azucar, modelo == FREIR, modelo == AZUCAR))
        end
        case (modelo)                             // el modelo avanza con las entradas
            ESPERA: if (t.pedido) modelo = FREIR;
            FREIR:  if (t.listo)  modelo = AZUCAR;
            AZUCAR:               modelo = ESPERA;
        endcase
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCB", $sformatf("%0d ciclos revisados, %0d errores", revisados, errores), UVM_NONE)
    endfunction
endclass
