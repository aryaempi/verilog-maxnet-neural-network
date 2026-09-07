module encoder4to2 (
    input  [31:0] a1, a2, a3, a4,
    output reg [1:0] winner_idx,
    output reg valid
);

    function [31:0] abs_fp;
        input [31:0] x;
        begin
            abs_fp = {1'b0, x[30:0]};
        end
    endfunction

    wire nz1 = |a1[30:0];
    wire nz2 = |a2[30:0];
    wire nz3 = |a3[30:0];
    wire nz4 = |a4[30:0];

    reg [31:0] m1, m2, m3, m4;
    reg [31:0] max12, max34, maxall;

    always @(*) begin
        valid = (nz1 | nz2 | nz3 | nz4);

        m1 = abs_fp(a1);
        m2 = abs_fp(a2);
        m3 = abs_fp(a3);
        m4 = abs_fp(a4);

        max12 = (m1 >= m2) ? m1 : m2;
        max34 = (m3 >= m4) ? m3 : m4;
        maxall = (max12 >= max34) ? max12 : max34;

        if (!valid) begin
            winner_idx = 2'b00;
        end else if (m1 == maxall) begin
            winner_idx = 2'b00;
        end else if (m2 == maxall) begin
            winner_idx = 2'b01;
        end else if (m3 == maxall) begin
            winner_idx = 2'b10;
        end else begin
            winner_idx = 2'b11;
        end
    end

endmodule

