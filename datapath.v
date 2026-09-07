module datapath (
    input clk,
    input rst,
    input [1:0] mem_addr,
    input load_init,
    input pu_en,
    input reg_load,
    input [31:0] epsilon_neg,
    output converged,
    output [1:0] winner_idx,
    output valid_winner
);

    wire [31:0] mem_out;

    wire [31:0] a [1:4];
    wire [31:0] next_a [1:4];
    wire [31:0] mux_in [1:4];

    wire ready1;
    wire ready2;
    wire ready3;
    wire ready4;

    memory mem_unit (
        .clk(clk),
        .wr_en(1'b0),
        .addr({2'b00, mem_addr}),
        .din(32'b0),
        .dout(mem_out)
    );

    genvar i;

    generate
        for (i = 1; i <= 4; i = i + 1) begin : gen_regs

            assign mux_in[i] = (load_init && (mem_addr == (i - 1))) ? mem_out : next_a[i];

            register status_reg (
                .clk(clk),
                .rst(rst),
                .load((load_init && (mem_addr == (i - 1))) || (reg_load && !load_init)),
                .d(mux_in[i]),
                .q(a[i])
            );

        end
    endgenerate

    PU pu1 (
        .clk(clk),
        .rst(rst),
        .en(pu_en),

        .in1(a[2]),
        .in2(a[3]),
        .in3(a[4]),
        .in4(32'b0),

        .w1(epsilon_neg),
        .w2(epsilon_neg),
        .w3(epsilon_neg),
        .w4(32'b0),

        .self_val(a[1]),
        .out(next_a[1]),
        .ready(ready1)
    );

    PU pu2 (
        .clk(clk),
        .rst(rst),
        .en(pu_en),

        .in1(a[1]),
        .in2(a[3]),
        .in3(a[4]),
        .in4(32'b0),

        .w1(epsilon_neg),
        .w2(epsilon_neg),
        .w3(epsilon_neg),
        .w4(32'b0),

        .self_val(a[2]),
        .out(next_a[2]),
        .ready(ready2)
    );

    PU pu3 (
        .clk(clk),
        .rst(rst),
        .en(pu_en),

        .in1(a[1]),
        .in2(a[2]),
        .in3(a[4]),
        .in4(32'b0),

        .w1(epsilon_neg),
        .w2(epsilon_neg),
        .w3(epsilon_neg),
        .w4(32'b0),

        .self_val(a[3]),
        .out(next_a[3]),
        .ready(ready3)
    );

    PU pu4 (
        .clk(clk),
        .rst(rst),
        .en(pu_en),

        .in1(a[1]),
        .in2(a[2]),
        .in3(a[3]),
        .in4(32'b0),

        .w1(epsilon_neg),
        .w2(epsilon_neg),
        .w3(epsilon_neg),
        .w4(32'b0),

        .self_val(a[4]),
        .out(next_a[4]),
        .ready(ready4)
    );

    check check_unit (
        .a1(a[1]),
        .a2(a[2]),
        .a3(a[3]),
        .a4(a[4]),
        .converged(converged)
    );

    encoder4to2 winner_unit (
        .a1(a[1]),
        .a2(a[2]),
        .a3(a[3]),
        .a4(a[4]),
        .winner_idx(winner_idx),
        .valid(valid_winner)
    );

endmodule

