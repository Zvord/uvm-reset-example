class reset_item extends uvm_sequence_item;

    `uvm_object_utils(reset_item)

    // Reset pattern type
    smd_reset_pattern pattern;

    // Delay before the reset is asserted
    rand int unsigned pre_delay_cycles;
    constraint c_pre_delay_cycles {
        soft pre_delay_cycles inside {[8:31]};
    }

    // Duration for which the reset is asserted (meaningful for ASSERT_DEASSERT)
    rand int unsigned length_cycles;
    constraint c_length_cycles {
        soft length_cycles inside {[1:3]};
    }

    // Default Constructor
    function new(string name = "smd_reset_drv_item");
        super.new(name);
        pattern = ASSERT_DEASSERT;
    endfunction

endclass : reset_item
