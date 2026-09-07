module controller (
    input clk,
    input rst,
    input start,
    input converged,
    output reg mem_rd_en,
    output reg reg_load,
    output reg pu_en,
    output reg done,
    output reg [1:0] mem_addr,
    output reg load_init,
    output [1:0] state_out
);

    parameter IDLE    = 2'b00;
    parameter INIT    = 2'b01;
    parameter COMPUTE = 2'b10;
    parameter DONE    = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [2:0] counter;

    assign state_out = state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = IDLE;
            end

            INIT: begin
                if (counter == 3'd3)
                    next_state = COMPUTE;
                else
                    next_state = INIT;
            end

            COMPUTE: begin
                if (converged && counter == 3'd4)
                    next_state = DONE;
                else
                    next_state = COMPUTE;
            end

            DONE: begin
                if (start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter   <= 3'd0;
            done      <= 1'b0;
            pu_en     <= 1'b0;
            mem_rd_en <= 1'b0;
            reg_load  <= 1'b0;
            mem_addr  <= 2'd0;
            load_init <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    counter   <= 3'd0;
                    done      <= 1'b0;
                    pu_en     <= 1'b0;
                    mem_rd_en <= 1'b0;
                    reg_load  <= 1'b0;
                    mem_addr  <= 2'd0;
                    load_init <= 1'b0;
                end

                INIT: begin
                    mem_rd_en <= 1'b1;
                    reg_load  <= 1'b1;
                    load_init <= 1'b1;
                    pu_en     <= 1'b0;
                    done      <= 1'b0;

                    mem_addr <= counter[1:0];

                    if (counter < 3'd3)
                        counter <= counter + 3'd1;
                    else
                        counter <= 3'd0;
                end

                COMPUTE: begin
                    load_init <= 1'b0;
                    mem_rd_en <= 1'b0;
                    pu_en     <= 1'b1;
                    done      <= 1'b0;

                    if (counter < 3'd4) begin
                        counter  <= counter + 3'd1;
                        reg_load <= 1'b0;
                    end else begin
                        reg_load <= 1'b1;

                        if (!converged)
                            counter <= 3'd0;
                    end
                end

                DONE: begin
                    done      <= 1'b1;
                    pu_en     <= 1'b0;
                    reg_load  <= 1'b0;
                    mem_rd_en <= 1'b0;
                    load_init <= 1'b0;
                end

                default: begin
                    counter   <= 3'd0;
                    done      <= 1'b0;
                    pu_en     <= 1'b0;
                    mem_rd_en <= 1'b0;
                    reg_load  <= 1'b0;
                    mem_addr  <= 2'd0;
                    load_init <= 1'b0;
                end
            endcase
        end
    end

endmodule


