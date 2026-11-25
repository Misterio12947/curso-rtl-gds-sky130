//------------------------------------------------------------------------------
// churros_env.sv · Agent (sequencer + driver + monitor) y env (agent + scb + cov)
//------------------------------------------------------------------------------
class churros_agent extends uvm_agent;
    `uvm_component_utils(churros_agent)
    uvm_sequencer #(churros_item) sqr;
    churros_driver                drv;
    churros_monitor               mon;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(churros_item)::type_id::create("sqr", this);
        drv = churros_driver::type_id::create("drv", this);
        mon = churros_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

class churros_env extends uvm_env;
    `uvm_component_utils(churros_env)
    churros_agent      agt;
    churros_scoreboard scb;
    churros_coverage   cov;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = churros_agent::type_id::create("agt", this);
        scb = churros_scoreboard::type_id::create("scb", this);
        cov = churros_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(scb.imp);              // el monitor publica,
        agt.mon.ap.connect(cov.analysis_export);  // scoreboard y cobertura escuchan
    endfunction
endclass
