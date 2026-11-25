//------------------------------------------------------------------------------
// churros_coverage.sv · Cobertura funcional: ¿qué situaciones alcanzamos?
//------------------------------------------------------------------------------
class churros_coverage extends uvm_subscriber #(churros_item);
    `uvm_component_utils(churros_coverage)
    churros_item t;

    covergroup cg;
        cp_salida : coverpoint {t.freidora, t.azucar} iff (t.rst_n) {
            bins espera = {2'b00};
            bins freir  = {2'b10};
            bins azucar = {2'b01};
            illegal_bins dos = {2'b11};           // freír y azúcar a la vez: imposible
        }
        cp_pedido : coverpoint t.pedido iff (t.rst_n);
        cp_reset  : coverpoint t.rst_n { bins reset = {0}; }
        x_pedido  : cross cp_salida, cp_pedido;   // ¿pidieron churros en cada estado?
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction

    function void write(churros_item t);
        this.t = t;
        cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("COV", $sformatf("cobertura funcional: %0.1f %%", cg.get_coverage()), UVM_NONE)
    endfunction
endclass
