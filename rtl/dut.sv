`define FF(r, en, i) \
always @(posedge clk or negedge rst_n) begin \
    if (!rst_n) \
        r <= 0; \
    else if (en) begin\
        r <= i;\
    end\
end

`define FF_SLICE(r, en, i) \
always @(posedge clk or negedge rst_n) begin \
    if (!rst_n) \
        r <= 0; \
    else if (en) begin\
        r[cnt_wr*8 +: 8] <= i;\
    end\
end

module dut(
    input  wire logic       clk,
    input  wire logic       rst_n,
    input  wire logic [1:0] addr_i,
    input  wire logic       valid_i,
    input  wire logic [7:0] data_i,
    output wire logic [7:0] data_o,
    output wire logic       ready_o,
    input  wire logic       wr_n
);

wire        ready_exp;
logic [7:0] data_r;
`FF(data_r, 1'b1, data_i)

// Registers
logic [31:0] reg_a;
logic [31:0] reg_b;
logic [31:0] reg_c;
logic [31:0] reg_d;

// Readability signals
wire op_rd = wr_n;
wire op_wr = !wr_n;

// Handshake
logic ready_r;
wire  hs      = valid_i && ready_r;
wire  hs_rd   = hs && op_rd;
wire  hs_wr   = hs && op_wr;

// Keep address during a burst
logic [1:0] addr_rd;
logic [1:0] addr_wr;

`FF(addr_rd, hs_rd, addr_i)
`FF(addr_wr, hs_wr, addr_i)

// Select a byte in a word
logic [1:0] cnt_wr;
logic [1:0] cnt_rd;

// Indicate  a burst in progress
logic rd_on;
logic wr_on;
wire  rd_on_exp = hs_rd || (cnt_rd != 0);
wire  wr_on_exp = hs_wr || (cnt_wr != 0);

// `FF(rd_on, 1'b1, rd_on_exp)
// `FF(wr_on, 1'b1, wr_on_exp)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_on <= 0;
        rd_on <= 0;
    end else begin
        if (hs_wr) wr_on       <= 1'b1;
        if (hs_rd) rd_on       <= 1'b1;
        if (cnt_wr == 3) wr_on <= 1'b0;
        if (cnt_rd == 3) rd_on <= 1'b0;
    end
end

// logic rd_on;
// logic wr_on;
// `FF(rd_on, 1'b1, hs_rd || (cnt_rd != 0))
// `FF(wr_on, 1'b1, hs_wr || (cnt_wr != 0))

`FF(cnt_rd, rd_on, cnt_rd+1)
`FF(cnt_wr, wr_on, cnt_wr+1)

// Write enable for each register
wire wr_a = wr_on && (addr_wr == 2'd0);
wire wr_b = wr_on && (addr_wr == 2'd1);
wire wr_c = wr_on && (addr_wr == 2'd2);
wire wr_d = wr_on && (addr_wr == 2'd3);

// Write to registers
`FF_SLICE(reg_a, wr_a, data_r)
`FF_SLICE(reg_b, wr_b, data_r)
`FF_SLICE(reg_c, wr_c, data_r)
`FF_SLICE(reg_d, wr_d, data_r)

// Read
wire rd_a = rd_on && (addr_rd == 2'd0);
wire rd_b = rd_on && (addr_rd == 2'd1);
wire rd_c = rd_on && (addr_rd == 2'd2);
wire rd_d = rd_on && (addr_rd == 2'd3);

wire [31:0] selected_reg = rd_a ? reg_a :
rd_b ? reg_b :
rd_c ? reg_c :
rd_d ? reg_d :
'0 ;

assign data_o = selected_reg[cnt_rd*8 +: 8];

// Ready logic
assign ready_exp = valid_i && ((op_rd ^ rd_on_exp) || (op_wr ^ wr_on_exp)) && !ready_r;
`FF(ready_r, 1'b1, ready_exp)
assign ready_o = ready_r;
endmodule