module alu (
    input [7:0] operand_a,
    input [7:0] operand_b,
    input [1:0] op_code,      // 00: add, 01: sub, 10: mul, 11: div
    output reg [15:0] result, // 16-bit để chứa kết quả nhân
    output reg zero_flag,     // Cờ báo kết quả = 0
    output reg error_flag     // Cờ báo lỗi (chia cho 0)
);

// Định nghĩa mã operation
localparam OP_ADD = 2'b00;
localparam OP_SUB = 2'b01;
localparam OP_MUL = 2'b10;
localparam OP_DIV = 2'b11;

always @(*) begin
    error_flag = 1'b0;
    zero_flag = 1'b0;
    result = 16'b0;
    
    case (op_code)
        OP_ADD: result = {8'b0, operand_a} + {8'b0, operand_b};
        OP_SUB: result = {8'b0, operand_a} - {8'b0, operand_b};
        OP_MUL: result = operand_a * operand_b;
        OP_DIV: begin
            if (operand_b == 8'b0) begin
                error_flag = 1'b1;
                result = 16'b0;
            end else begin
                result = {8'b0, operand_a / operand_b};
                // Phần dư có thể lưu ở bits [7:0] nếu cần
            end
        end
        default: result = 16'b0;
    endcase
    
    // Set zero flag
    if (result == 16'b0) zero_flag = 1'b1;
end

endmodule
