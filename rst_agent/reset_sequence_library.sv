class reset_simple_sequence extends uvm_sequence #(reset_item);

    `uvm_object_utils(reset_simple_sequence)

    // Constructor
    function new(string name = "smd_reset_simple_seq");
        super.new(name);
    endfunction

    // Body task to define the sequence behavior
    virtual task body();
        reset_item item = reset_item::type_id::create("item");

        // Set the reset pattern
        item.pattern = ASSERT_DEASSERT;

        // Start and finish the item
        start_item(item);
        if (!item.randomize()) `uvm_fatal("BAD_RND", "Can't randomize reset item")
        finish_item(item);
    endtask

endclass : reset_simple_sequence


class smd_reset_custom_seq extends uvm_sequence #(reset_item);

    `uvm_object_utils(smd_reset_custom_seq)

    // Item to be set manually by the user
    reset_item item;

    function new(string name = "smd_reset_custom_seq");
        super.new(name);
    endfunction

    virtual task body();
        if (item == null) begin
            `uvm_fatal("NULLPTR", "When using custom_seq you have to set the item manually")
        end

        start_item(item);
        finish_item(item);
    endtask

endclass : smd_reset_custom_seq
