class my_agent extends uvm_agent;

    my_config    cfg;
    my_driver_simple    drv;
    my_sequencer sqr;
    my_monitor   mon;

    `uvm_component_utils(my_agent)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = my_sequencer::type_id::create("sqr", this);
        mon = my_monitor::type_id::create("mon", this);
        drv = my_driver_simple::type_id::create("drv", this);

        drv.vif = cfg.vif;
        mon.vif = cfg.vif;
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(drv.rst_done);
            sqr.stop_sequences();
        end
    endtask : run_phase


endclass : my_agent