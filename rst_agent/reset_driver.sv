class reset_driver extends uvm_driver #(reset_item);

    `uvm_component_utils(reset_driver)

    virtual reset_if vif;
    reset_config cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        vif = cfg.vif;
        if (vif == null) begin
            if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", vif)) begin
                `uvm_fatal(get_type_name(), "Cannot get the reset interface from the config db")
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            reset_item req;
            seq_item_port.get_next_item(req);

            // Pre-delay before applying the reset pattern
            repeat (req.pre_delay_cycles) @(posedge vif.clk);

            // Handle different reset patterns
            case (req.pattern)
                ASSERT_DEASSERT: begin
                    vif.reset <= cfg.active_level;
                    repeat (req.length_cycles) @(posedge vif.clk);
                    vif.reset <= ~cfg.active_level;
                end
                CHANGE_LEVEL: begin
                    vif.reset <= ~vif.reset;
                end
                ACTIVE: begin
                    vif.reset <= cfg.active_level;
                end
                INACTIVE: begin
                    vif.reset <= ~cfg.active_level;
                end
                default: begin
                    `uvm_fatal("NOT_IMPLEMENTED", {"Received an unexpected pattern in ", get_name()})
                end
            endcase

            seq_item_port.item_done();
        end

        // Wait 10 cycles to release the reset at the start of the simulation
        repeat (10) @(posedge vif.clk);
        vif.reset <= 1'b1;
    endtask

endclass : reset_driver
