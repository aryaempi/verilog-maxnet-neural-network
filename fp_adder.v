module fp_adder (
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] y
);

    wire s_a = a[31];
    wire s_b = b[31];
    wire [7:0] e_a = a[30:23];
    wire [7:0] e_b = b[30:23];
    wire [23:0] m_a = (e_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] m_b = (e_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    reg [7:0]  e_diff;
    reg [23:0] m_a_aligned, m_b_aligned;
    reg [24:0] sum_mant;
    reg [7:0]  exp_out;

    always @(*) begin

        if (e_a == 255 || e_b == 255) y = 32'h7F800000;
        else if (a[30:0] == 0) y = b;
        else if (b[30:0] == 0) y = a;
        else begin

            if (e_a > e_b) begin
                e_diff = e_a - e_b;
                m_a_aligned = m_a;
                m_b_aligned = m_b >> e_diff;
                exp_out = e_a;
            end else begin
                e_diff = e_b - e_a;
                m_a_aligned = m_a >> e_diff;
                m_b_aligned = m_b;
                exp_out = e_b;
            end

            if (s_a == s_b) begin
                sum_mant = m_a_aligned + m_b_aligned;
                if (sum_mant[24]) begin 
                    sum_mant = sum_mant >> 1;
                    exp_out = exp_out + 1;
                end
                y = {s_a, exp_out, sum_mant[22:0]};
            end else begin
                if (m_a_aligned >= m_b_aligned)
                    sum_mant = m_a_aligned - m_b_aligned;
                else
                    sum_mant = m_b_aligned - m_a_aligned;

                if (sum_mant != 0) begin
                    while (sum_mant[23] == 0 && exp_out > 0) begin
                        sum_mant = sum_mant << 1;
                        exp_out = exp_out - 1;
                    end
                end
                y = { (m_a_aligned >= m_b_aligned ? s_a : s_b), exp_out, sum_mant[22:0]};
            end
        end
    end
endmodule

