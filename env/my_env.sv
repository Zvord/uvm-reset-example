class my_env extends uvm_env;

    my_env_cfg  cfg;
    my_agent    reg_agt;
    reset_agent rst_agt;

    `uvm_component_utils(my_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (cfg == null) `uvm_fatal("NO_CFG", "Config object is not set for the environment")
        reg_agt = my_agent::type_id::create("reg_agt", this);
        rst_agt = reset_agent::type_id::create("reset_agent", this);
        reg_agt.cfg = cfg.reg_cfg;
        rst_agt.cfg = cfg.rst_cfg;
    endfunction : build_phase

endclass : my_env
