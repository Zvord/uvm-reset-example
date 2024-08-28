class my_env_cfg extends uvm_object;
    `uvm_object_utils(my_env_cfg)

    virtual harness vif;

    my_config    reg_cfg;
    reset_config rst_cfg;

    function new(string name = "env_cfg");
        super.new(name);
        reg_cfg = new("reg_cfg");
        rst_cfg = new("rst_cfg");
    endfunction : new

    virtual function void propagate();
        reg_cfg.vif = vif.u_my_if;
        rst_cfg.vif = vif.u_reset_if;
    endfunction

endclass