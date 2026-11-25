//------------------------------------------------------------------------------
// churros_monitor.sv · Monitor: OBSERVA los pines y publica una transacción por ciclo
//   No sabe si el diseño está bien o mal: eso lo decide el scoreboard.
//------------------------------------------------------------------------------
class churros_monitor extends uvm_monitor;
    `uvm_component_utils(churros_monitor)
    virtual churros_if vif;
    uvm_analysis_port #(churros_item) ap;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual churros_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "no encuentro la interface churros_if")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            churros_item t;
            @(vif.mon_cb);
            t = churros_item::type_id::create("t");
            t.rst_n    = vif.mon_cb.rst_n;
            t.pedido   = vif.mon_cb.pedido;
            t.listo    = vif.mon_cb.listo;
            t.freidora = vif.mon_cb.freidora;
            t.azucar   = vif.mon_cb.azucar;
            ap.write(t);                           // a quien esté escuchando
        end
    endtask
endclass
