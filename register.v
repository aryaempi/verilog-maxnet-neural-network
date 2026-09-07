module register (
    input clk,
    input rst,
    input load,          
    input [31:0] d,      
    output reg [31:0] q  
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 32'b0;
        else if (load)
            q <= d;
    end
endmodule

