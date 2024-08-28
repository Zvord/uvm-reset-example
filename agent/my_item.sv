class my_item extends uvm_sequence_item;

    rand int       delay;
    rand bit[31:0] data;
    rand bit[1:0]  addr;
    rand op_t      op;

    constraint c_delay {
        soft delay inside {[0:0]};
    }

    `uvm_object_utils_begin(my_item)
        `uvm_field_int (delay,     UVM_DEFAULT)
        `uvm_field_int (data,      UVM_DEFAULT)
        `uvm_field_int (addr,      UVM_DEFAULT)
        `uvm_field_enum(op_t,  op, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "my_item");
        super.new(name);
    endfunction : new

endclass : my_item