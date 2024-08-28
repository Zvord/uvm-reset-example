class my_driver extends uvm_driver #(my_item);
    `uvm_component_utils(my_driver)

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

    virtual protected task reset_signals();
        vif.valid_i <= 0;
        vif.addr_i  <= 0;
        vif.data_i  <= 0;
        vif.wr_n    <= 0;
    endtask : reset_signals

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

endclass : my_driver