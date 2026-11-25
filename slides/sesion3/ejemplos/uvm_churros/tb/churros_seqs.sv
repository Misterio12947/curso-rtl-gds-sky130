//------------------------------------------------------------------------------
// churros_seqs.sv · Secuencias: QUÉ estímulo se genera (no CÓMO se maneja)
//------------------------------------------------------------------------------
// Reset de 3 ciclos al arrancar
class churros_reset_seq extends uvm_sequence #(churros_item);
    `uvm_object_utils(churros_reset_seq)
    function new(string name = "churros_reset_seq"); super.new(name); endfunction

    task body();
        repeat (3) `uvm_do_with(req, { rst_n == 0; pedido == 0; listo == 0; })
    endtask
endclass

// N ciclos constrained-random
class churros_rand_seq extends uvm_sequence #(churros_item);
    `uvm_object_utils(churros_rand_seq)
    int unsigned n = 300;
    function new(string name = "churros_rand_seq"); super.new(name); endfunction

    task body();
        repeat (n) `uvm_do(req)
    endtask
endclass

// Dirigida: un pedido completo, paso a paso
class churros_directed_seq extends uvm_sequence #(churros_item);
    `uvm_object_utils(churros_directed_seq)
    function new(string name = "churros_directed_seq"); super.new(name); endfunction

    task body();
        `uvm_do_with(req, { rst_n == 1; pedido == 1; listo == 0; })   // pido
        repeat (3)
        `uvm_do_with(req, { rst_n == 1; pedido == 0; listo == 0; })   // se fríen
        `uvm_do_with(req, { rst_n == 1; pedido == 0; listo == 1; })   // ya están
        `uvm_do_with(req, { rst_n == 1; pedido == 0; listo == 0; })   // azúcar
        `uvm_do_with(req, { rst_n == 1; pedido == 0; listo == 0; })   // espera
    endtask
endclass
