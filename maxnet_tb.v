`timescale 1ns/1ps

module maxnet_tb();

    reg clk;
    reg rst;
    reg start;
    reg [31:0] epsilon_neg;

    wire [1:0] winner_id;
    wire found;
    wire done;

    parameter CLK_PERIOD = 10;

    maxnet uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .epsilon_neg(epsilon_neg),
        .winner_id(winner_id),
        .found(found),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin

        rst = 1;
        start = 0;

        epsilon_neg = 32'hBE4CCCCD; 

        // Neuron 0: 0.8  (32'h3F4CCCCD)
        // Neuron 1: 0.4  (32'h3EDCCCCD)
        // Neuron 2: 0.6  (32'h3F19999A)
        // Neuron 3: 0.2  (32'h3E4CCCCD)
        
        uut.dp_inst.mem_unit.mem[0] = 32'h3F4CCCCD;
        uut.dp_inst.mem_unit.mem[1] = 32'h3EDCCCCD;
        uut.dp_inst.mem_unit.mem[2] = 32'h3F19999A;
        uut.dp_inst.mem_unit.mem[3] = 32'h3E4CCCCD;

        #(3 * CLK_PERIOD);
        rst = 0;         
        #(2 * CLK_PERIOD);
        
        $display("Time: %0t | Starting Maxnet Calculation...", $time);
        start = 1;       
        #(CLK_PERIOD);
        start = 0;

        wait(done); 
        
        #(5 * CLK_PERIOD); 
        
        $display("---------------------------------------");
        $display("Computation Finished at Time: %0t", $time);
        if (found) begin
            $display("SUCCESS: Winner Detected!");
            $display("Winner Neuron Index: %d", winner_id);
        end else begin
            $display("ERROR: No valid winner found.");
        end
        $display("---------------------------------------");

        #(20 * CLK_PERIOD);
        $stop; 
    end

    initial begin
        $display("Time\t\t N0\t\t N1\t\t N2\t\t N3");
        forever begin
            @(uut.dp_inst.a[1] or uut.dp_inst.a[2] or uut.dp_inst.a[3] or uut.dp_inst.a[4]);
            $display("%0t\t %h\t %h\t %h\t %h", 
                     $time, uut.dp_inst.a[1], uut.dp_inst.a[2], uut.dp_inst.a[3], uut.dp_inst.a[4]);
        end
    end

endmodule


