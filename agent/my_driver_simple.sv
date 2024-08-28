class my_driver_simple extends uvm_driver #(my_item);
    `uvm_component_utils(my_driver_simple)

    virtual my_if vif;
    event         rst_done;
    bit           pending;
    my_item       rd_q[$];
    my_item       wr_q[$];

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(vif == null && !uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            reset_signals();
            while(vif.rst_n !== 1) @(posedge vif.clk);
            fork
                get_and_drive();
                @(negedge vif.rst_n);
            join_any
            disable fork;
            reset_driver();
        end
    endtask : run_phase

    function void reset_driver();
        if (rsp != null) begin
            seq_item_port.item_done();
            rsp = null;
        end
        -> rst_done;
    endfunction : reset_driver

    virtual protected task reset_signals();
        vif.valid_i <= 0;
        vif.addr_i  <= 0;
        vif.data_i  <= 0;
        vif.wr_n    <= 0;
    endtask : reset_signals

    virtual task get_and_drive();
        forever begin
            seq_item_port.get_next_item(req);
            $cast(rsp, req.clone());
            rsp.set_id_info(req);
            @(posedge vif.clk);
            case (rsp.op)
                OP_RD : drive_rd(rsp);
                OP_WR : drive_wr(rsp);
                default : `uvm_fatal("INTERNAL", "Unknown operation")
            endcase
            seq_item_port.item_done(rsp);
            rsp = null;
        end
    endtask : get_and_drive

    virtual protected task drive_wr(my_item item);
        repeat(item.delay) @(posedge vif.clk);
        vif.valid_i <= 1'b1;
        vif.wr_n    <= item.op;
        vif.addr_i  <= item.addr;
        vif.data_i  <= item.data[7:0];
        while(!vif.ready_o) @(posedge vif.clk);
        vif.valid_i <= 0;
        pending = 0;
        for(int i = 1; i < 4; i++) begin
            vif.data_i <= item.data[i*8 +: 8];
            if (i < 3) @(posedge vif.clk);
        end
    endtask : drive_wr

    virtual protected task drive_rd(my_item item);
        repeat(item.delay) @(posedge vif.clk);
        vif.valid_i <= 1'b1;
        vif.wr_n    <= item.op;
        vif.addr_i  <= item.addr;
        while(!vif.ready_o) @(posedge vif.clk);
        vif.valid_i <= 0;
        pending = 0;
        for(int i = 1; i < 4; i++) begin
            item.data[i*8 +: 8] <= vif.data_o;
            if (i < 3) @(posedge vif.clk);
        end
    endtask

endclass : my_driver_simple