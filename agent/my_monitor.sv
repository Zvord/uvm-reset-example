class my_monitor extends uvm_monitor;

    virtual my_if                vif;
    uvm_analysis_port #(my_item) collected_item_port;

    `uvm_component_utils(my_monitor)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(vif == null && !uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
        collected_item_port = new("ap", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            while (vif.rst_n !== 1'b1) @(posedge vif.clk);
            fork
                collect_wr();
                collect_rd();
                @(negedge vif.rst_n);
            join_any
            `uvm_info("RST_DETECTED", "Restarting monitor", UVM_MEDIUM)
            disable fork;
        end
    endtask : run_phase

    virtual protected task collect_wr();
        forever begin
            @(posedge vif.clk);
            if (vif.valid_i && vif.ready_o && vif.wr_n == OP_WR) begin
                my_item item = new();
                item.op = OP_WR;
                item.addr = vif.addr_i;
                for(int i = 0; i < 4; i++) begin
                    item.data[i*8 +: 8] = vif.data_i;
                    if (i < 3) @(posedge vif.clk);
                end
                `uvm_info(get_full_name(), $sformatf("Item collected :\n%s", item.sprint()), UVM_MEDIUM)
                collected_item_port.write(item);
            end
        end
    endtask : collect_wr

    virtual protected task collect_rd();
        forever begin
            @(posedge vif.clk);
            if (vif.valid_i && vif.ready_o && vif.wr_n == OP_RD) begin
                my_item item = new();
                item.op = OP_RD;
                item.addr = vif.addr_i;
                for(int i = 0; i < 4; i++) begin
                    @(posedge vif.clk);
                    item.data[i*8 +: 8] = vif.data_o;
                end
                `uvm_info(get_full_name(), $sformatf("Item collected :\n%s", item.sprint()), UVM_MEDIUM)
                collected_item_port.write(item);
            end
        end
    endtask : collect_rd

endclass : my_monitor