interface my_if(
        input              rst_n,
        input              clk,
        output logic [1:0] addr_i,
        output logic       valid_i,
        output logic [7:0] data_i,
        input  logic [7:0] data_o,
        input  logic       ready_o,
        output logic       wr_n
    );


endinterface