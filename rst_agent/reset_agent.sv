class reset_agent extends uvm_agent;

    `uvm_component_utils(reset_agent)

    reset_config cfg;
    reset_driver drv;
    reset_sequencer sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (cfg == null) begin
            `uvm_info(get_type_name(), "No CFG is set. Creating a default one", UVM_MEDIUM)
            cfg = reset_config::type_id::create("reset_cfg", this);
        end

        // Because UVM-SV's agent wants to get it through the db and shows a warning otherwise
        uvm_config_db#(uvm_active_passive_enum)::set(this, "", "is_active", cfg.is_active);

        if (cfg.vif == null) begin
            if (!uvm_config_db#(virtual reset_if)::get(this, "", "vif", cfg.vif)) begin
                `uvm_fatal("NOVIF", {"No vif in ", get_full_name()})
            end
        end

        if (cfg.is_active == UVM_ACTIVE) begin
            drv = reset_driver::type_id::create("reset_driver", this);
            sqr = reset_sequencer::type_id::create("reset_sequencer", this);
            drv.cfg = cfg;
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass : reset_agent
