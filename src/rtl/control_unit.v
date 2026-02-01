module control_unit (
    input clk,
    input reset,
    input start,
    input [1:0] op_code,
    output reg alu_enable,
    output reg [1:0] reg_write_sel,
    output reg display_enable,
    output reg done
);

// States
localparam IDLE      = 2'b00;
localparam DECODE    = 2'b01;
localparam EXECUTE   = 2'b10;
localparam DISPLAY   = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset) current_state <= IDLE;
    else current_state <= next_state;
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:    next_state = start ? DECODE : IDLE;
        DECODE:  next_state = EXECUTE;
        EXECUTE: next_state = DISPLAY;
        DISPLAY: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(*) begin
    // Default values
    alu_enable = 1'b0;
    reg_write_sel = 2'b00;
    display_enable = 1'b0;
    done = 1'b0;
    
    case (current_state)
        DECODE: begin
            // Prepare for execution
            reg_write_sel = op_code;
        end
        EXECUTE: begin
            alu_enable = 1'b1;
        end
        DISPLAY: begin
            display_enable = 1'b1;
            done = 1'b1;
        end
        IDLE: begin
            done = 1'b1;
        end
    endcase
end

endmodule
