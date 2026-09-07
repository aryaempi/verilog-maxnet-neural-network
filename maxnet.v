module maxnet (
    input clk,
    input rst,
    input start,
    input [31:0] epsilon_neg,
    output [1:0] winner_id,
    output found,
    output done
);

    wire converged;
    wire load_init;
    wire pu_en;
    wire reg_load;
    wire mem_rd_en;
    wire [1:0] mem_addr;
    wire [1:0] state_out;

    datapath dp_inst (
        .clk(clk),
        .rst(rst),
        .mem_addr(mem_addr),
        .load_init(load_init),
        .pu_en(pu_en),
        .reg_load(reg_load),
        .epsilon_neg(epsilon_neg),
        .converged(converged),
        .winner_idx(winner_id),
        .valid_winner(found)
    );

    controller ctrl_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .converged(converged),
        .mem_rd_en(mem_rd_en),
        .reg_load(reg_load),
        .pu_en(pu_en),
        .done(done),
        .mem_addr(mem_addr),
        .load_init(load_init),
        .state_out(state_out)
    );

endmodule

