package my_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    typedef enum bit {
        OP_WR,
        OP_RD
    } op_t;

    `include "my_config.sv"
    `include "my_item.sv"
    typedef uvm_sequencer#(my_item) my_sequencer;
    `include "my_monitor.sv"
    `include "my_driver.sv"
    `include "my_driver_simple.sv"
    `include "my_driver_pipeline.sv"
    `include "my_agent.sv"
    `include "my_sequence.sv"

endpackage : my_pkg