class my_sequence extends uvm_sequence#(my_item);
    `uvm_object_utils(my_sequence)

    bit complete;
    int req_cnt;
    int rsp_cnt;

    function new(string name = "my_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        use_response_handler(1);
        repeat(16) begin
            my_item item = new();
            req_cnt++;
            start_item(item);
            if (!item.randomize()) `uvm_fatal("BAD_RND", "Can't randomize item")
            finish_item(item);
        end
        wait(req_cnt == rsp_cnt);
        complete = 1;
    endtask : body

	virtual function void response_handler(uvm_sequence_item response);
		super.response_handler(response);
        rsp_cnt++;
	endfunction : response_handler


endclass