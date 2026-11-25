//------------------------------------------------------------------------------
// churros_tests.sv · Tests: qué secuencias se corren (se eligen con +UVM_TESTNAME)
//------------------------------------------------------------------------------
class churros_base_test extends uvm_test;
    `uvm_component_utils(churros_base_test)
    churros_env env;

    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = churros_env::type_id::create("env", this);
    endfunction

    // PASS/FAIL leído del contador de UVM_ERROR (como los TB de la industria)
    function void report_phase(uvm_phase phase);
        uvm_report_server rs = uvm_report_server::get_server();
        if (rs.get_severity_count(UVM_ERROR) + rs.get_severity_count(UVM_FATAL) == 0)
            `uvm_info("TEST", "*** TEST PASSED ***", UVM_NONE)
        else
            `uvm_info("TEST", "*** TEST FAILED ***", UVM_NONE)
    endfunction
endclass

class churros_directed_test extends churros_base_test;
    `uvm_component_utils(churros_directed_test)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    task run_phase(uvm_phase phase);
        churros_reset_seq    rst = churros_reset_seq::type_id::create("rst");
        churros_directed_seq dir = churros_directed_seq::type_id::create("dir");
        phase.raise_objection(this);
        rst.start(env.agt.sqr);
        dir.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass

class churros_random_test extends churros_base_test;
    `uvm_component_utils(churros_random_test)
    function new(string name, uvm_component parent); super.new(name, parent); endfunction

    task run_phase(uvm_phase phase);
        churros_reset_seq rst = churros_reset_seq::type_id::create("rst");
        churros_rand_seq  rnd = churros_rand_seq::type_id::create("rnd");
        phase.raise_objection(this);
        rst.start(env.agt.sqr);
        rnd.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass
