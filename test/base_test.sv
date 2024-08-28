class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    my_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        my_env_cfg cfg;
        super.build_phase(phase);
        cfg = new("env_cfg");
        env = my_env::type_id::create("env", this);
        if (!uvm_config_db#(virtual harness)::get(this, "", "vif", cfg.vif))
            `uvm_fatal("NO_VIF", "Harness is not set to the base test")
        env.cfg = cfg;
        cfg.propagate();
    endfunction : build_phase

    virtual task reset_phase(uvm_phase phase);
        reset_agent_pkg::reset_simple_sequence rst_seq;
        rst_seq = new("rst_seq");
        rst_seq.start(env.rst_agt.sqr);
    endtask : reset_phase

    virtual task main_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        repeat (5) begin
            fork
                begin
                    my_pkg::my_sequence seq = new("my_seq");
                    seq.start(env.reg_agt.sqr);
                end
                begin
                    reset_agent_pkg::reset_simple_sequence rst_seq;
                    rst_seq = new("rst_seq");
                    rst_seq.start(env.rst_agt.sqr);
                end
            join
        end
        begin
            my_pkg::my_sequence seq = new("my_seq");
            seq.start(env.reg_agt.sqr);
        end
        `uvm_info("END", "END", UVM_NONE)
        phase.drop_objection(this);
    endtask : main_phase


endclass