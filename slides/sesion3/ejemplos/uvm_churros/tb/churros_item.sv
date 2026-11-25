//------------------------------------------------------------------------------
// churros_item.sv · Transacción: lo que pasa en UN ciclo de reloj
//   Las entradas son rand (las genera la secuencia); las salidas las llena el monitor.
//------------------------------------------------------------------------------
class churros_item extends uvm_sequence_item;
    rand bit rst_n;
    rand bit pedido;
    rand bit listo;
    bit      freidora;              // observadas (no rand)
    bit      azucar;

    // constrained-random: aleatorio, pero con reglas
    constraint c_reset  { rst_n  dist {1 := 19, 0 := 1}; }   // reset de vez en cuando
    constraint c_pedido { pedido dist {1 := 3,  0 := 7}; }

    `uvm_object_utils_begin(churros_item)
        `uvm_field_int(rst_n,    UVM_ALL_ON)
        `uvm_field_int(pedido,   UVM_ALL_ON)
        `uvm_field_int(listo,    UVM_ALL_ON)
        `uvm_field_int(freidora, UVM_ALL_ON)
        `uvm_field_int(azucar,   UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "churros_item");
        super.new(name);
    endfunction
endclass
