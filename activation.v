module activation (
    input  [31:0] in,
    output [31:0] out
);
    assign out = in[31] ? 32'b0 : in;
endmodule

