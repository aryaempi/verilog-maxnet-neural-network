module PU (
    input clk,
    input rst,
    input en,                  
    input [31:0] in1, in2, in3, in4, 
    input [31:0] w1, w2, w3, w4,     
    input [31:0] self_val,          
    output reg [31:0] out,          
    output reg ready               
);

    wire [31:0] prod1, prod2, prod3, prod4;
    reg  [31:0] reg_prod1, reg_prod2, reg_prod3, reg_prod4;
    reg  [31:0] reg_self_stage2;

    fp_multiplier mult1 (.a(in1), .b(w1), .y(prod1));
    fp_multiplier mult2 (.a(in2), .b(w2), .y(prod2));
    fp_multiplier mult3 (.a(in3), .b(w3), .y(prod3));
    fp_multiplier mult4 (.a(in4), .b(w4), .y(prod4));

    wire [31:0] sum12, sum34, sum_all, final_sum_val;
    reg  [31:0] reg_sum12, reg_sum34;
    reg  [31:0] reg_self_stage3;

    fp_adder adder1 (.a(reg_prod1), .b(reg_prod2), .y(sum12));
    fp_adder adder2 (.a(reg_prod3), .b(reg_prod4), .y(sum34));
    
    wire [31:0] sum_prods;
    fp_adder adder_mid (.a(reg_sum12), .b(reg_sum34), .y(sum_prods));

    fp_adder adder_final (.a(sum_prods), .b(reg_self_stage3), .y(final_sum_val));

    wire [31:0] activated_val;
    activation act_unit (.in(final_sum_val), .out(activated_val));

    reg [2:0] stage_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage_count <= 0;
            ready <= 0;
            out <= 0;
        end else if (en) begin

            reg_prod1 <= prod1;
            reg_prod2 <= prod2;
            reg_prod3 <= prod3;
            reg_prod4 <= prod4;
            reg_self_stage2 <= self_val;

            reg_sum12 <= sum12;
            reg_sum34 <= sum34;
            reg_self_stage3 <= reg_self_stage2;

            out <= activated_val;

            if (stage_count < 3'd4) begin
                stage_count <= stage_count + 1;
                ready <= 0;
            end else begin
                ready <= 1;
            end
        end else begin
            stage_count <= 0;
            ready <= 0;
        end
    end

endmodule

