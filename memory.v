module memory (
    input clk,
    input wr_en,         
    input [3:0] addr,      
    input [31:0] din,
    output [31:0] dout
);
    reg [31:0] mem [0:15];

    assign dout = mem[addr];

    always @(posedge clk) begin
        if (wr_en)
            mem[addr] <= din;
    end
endmodule

