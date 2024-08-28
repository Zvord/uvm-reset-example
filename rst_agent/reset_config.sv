class reset_config extends uvm_object;
    `uvm_object_utils(reset_config)

    virtual reset_if vif;

    // Configuration variables
    reset_level active_level;
    uvm_active_passive_enum is_active;

    // Constructor
    function new(string name = "smd_reset_cfg");
        super.new(name);
        active_level = LOW;
        is_active = UVM_ACTIVE;
    endfunction

endclass : reset_config
