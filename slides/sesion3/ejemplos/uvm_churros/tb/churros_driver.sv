//------------------------------------------------------------------------------
// churros_driver.sv · Driver: CÓMO se aplica cada transacción a los pines
//------------------------------------------------------------------------------
class churros_driver extends uvm_driver #(churros_item);
    `uvm_component_utils(churros_driver)
    virtual churros_if vif;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual churros_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "no encuentro la interface churros_if")
    endfunction

    task run_phase(uvm_phase phase);
        vif.rst_n <= 0; vif.pedido <= 0; vif.listo <= 0;
        forever begin
            seq_item_port.get_next_item(req);
            @(negedge vif.clk);                    // en la bajada: nada choca
            vif.rst_n  <= req.rst_n;
            vif.pedido <= req.pedido;
            vif.listo  <= req.listo;
            seq_item_port.item_done();
        end
    endtask
endclass
