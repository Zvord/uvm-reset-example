package reset_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    typedef enum int {
        ASSERT_DEASSERT,
        CHANGE_LEVEL,
        ACTIVE,
        INACTIVE
    } smd_reset_pattern;

    typedef enum logic {
        LOW = 1'b0,
        HIGH = 1'b1
    } reset_level;

    `include "reset_item.sv";
    typedef uvm_sequencer#(reset_item) reset_sequencer;

    `include "reset_sequence_library.sv"
    `include "reset_config.sv"
    `include "reset_driver.sv";
    `include "reset_agent.sv";

endpackage