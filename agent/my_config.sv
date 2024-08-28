class my_config extends uvm_object;
    `uvm_object_utils(my_config)

    virtual my_if vif;

    function new(string name = "my_config");
        super.new(name);
    endfunction: new

endclass : my_config
