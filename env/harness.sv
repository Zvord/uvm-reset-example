interface harness();

    wire reset;
    bit clk;
    always #1ns clk = !clk;
    assign dut.clk = clk;
    assign dut.rst_n = reset;

    my_if u_my_if (
        .clk    (clk        ),
        .rst_n  (reset      ),
        .addr_i (dut.addr_i ),
        .data_i (dut.data_i ),
        .data_o (dut.data_o ),
        .ready_o(dut.ready_o),
        .valid_i(dut.valid_i),
        .wr_n   (dut.wr_n   )
    );

    reset_if u_reset_if(
        .clk  (clk  ),
        .reset(reset)
    );

endinterface