module check (
    input [31:0] a1, a2, a3, a4, 
    output converged             
);
    wire nz1, nz2, nz3, nz4;

    assign nz1 = |a1[30:0];
    assign nz2 = |a2[30:0];
    assign nz3 = |a3[30:0];
    assign nz4 = |a4[30:0];

    assign converged = ( (nz1 + nz2 + nz3 + nz4) <= 1 );
endmodule

