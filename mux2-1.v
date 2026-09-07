module mux2_1 (
    input [31:0] i0,
    input [31:0] i1,
    input sel,
    output [31:0] out
);
    assign out = sel ? i1 : i0;
endmodule

