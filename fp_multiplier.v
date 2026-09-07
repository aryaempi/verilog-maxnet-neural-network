module fp_multiplier (
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] y
);

    wire s_a = a[31];
    wire s_b = b[31];
    wire [7:0] e_a = a[30:23];
    wire [7:0] e_b = b[30:23];
    wire [22:0] m_a = a[22:0];
    wire [22:0] m_b = b[22:0];

    wire [23:0] mant_a = (e_a == 0) ? {1'b0, m_a} : {1'b1, m_a};
    wire [23:0] mant_b = (e_b == 0) ? {1'b0, m_b} : {1'b1, m_b};

    reg [47:0] prod_mant;
    reg [8:0]  prod_exp;
    reg        prod_sign;

    always @(*) begin

        if ((e_a == 255) || (e_b == 255)) begin
            y = {s_a ^ s_b, 8'hFF, 23'h0};
        end 

        else if ((a[30:0] == 0) || (b[30:0] == 0)) begin
            y = 32'b0;
        end
        else begin

            prod_sign = s_a ^ s_b;
            prod_exp  = e_a + e_b - 127;
            prod_mant = mant_a * mant_b;

            if (prod_mant[47]) begin
                prod_mant = prod_mant >> 1;
                prod_exp  = prod_exp + 1;
            end

            if (prod_exp >= 255)
                y = {prod_sign, 8'hFF, 23'h0};
            else if (prod_exp <= 0) 
                y = 32'b0;
            else
                y = {prod_sign, prod_exp[7:0], prod_mant[45:23]};
        end
    end
endmodule

