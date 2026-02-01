`timescale 1ns/1ps

module calculator_tb;
    reg clk;
    reg reset;
    reg start;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg [1:0] op_code;
    wire [15:0] result;
    wire done;
    wire error_flag;
    wire zero_flag;
    
    // Instantiate top module
    calculator_top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_code(op_code),
        .result(result),
        .done(done),
        .error_flag(error_flag),
        .zero_flag(zero_flag)
    );
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;
    
    // Test scenarios
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;
        operand_a = 0;
        operand_b = 0;
        op_code = 0;
        
        // Dump waveform file (for ModelSim/QuestaSim)
        $dumpfile("calculator_wave.vcd");
        $dumpvars(0, calculator_tb);
        
        // Apply reset
        #20 reset = 0;
        
        $display("=== Starting Calculator Testbench ===");
        $display("Time\tOP\tA\tB\tResult\tDone\tError\tZero");
        $display("------------------------------------------------");
        
        // Test 1: Addition (15 + 27 = 42)
        #10;
        operand_a = 8'd15;
        operand_b = 8'd27;
        op_code = 2'b00; // ADD
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tADD\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        // Test 2: Subtraction (50 - 23 = 27)
        #20;
        operand_a = 8'd50;
        operand_b = 8'd23;
        op_code = 2'b01; // SUB
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tSUB\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        // Test 3: Multiplication (12 * 8 = 96)
        #20;
        operand_a = 8'd12;
        operand_b = 8'd8;
        op_code = 2'b10; // MUL
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tMUL\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        // Test 4: Division (30 / 5 = 6)
        #20;
        operand_a = 8'd30;
        operand_b = 8'd5;
        op_code = 2'b11; // DIV
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tDIV\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        // Test 5: Division by zero (error case)
        #20;
        operand_a = 8'd30;
        operand_b = 8'd0;
        op_code = 2'b11; // DIV
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tDIV\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        // Test 6: Zero result case
        #20;
        operand_a = 8'd15;
        operand_b = 8'd15;
        op_code = 2'b01; // SUB
        start = 1;
        #10 start = 0;
        wait(done);
        $display("%0t\tSUB\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d", 
                 $time, operand_a, operand_b, result, done, error_flag, zero_flag);
        
        $display("=== Testbench Complete ===");
        #100 $finish;
    end
    
    // Monitor to automatically display signal changes
    always @(posedge done) begin
        if (!reset) begin
            case (op_code)
                2'b00: $display("ALU Result: %0d + %0d = %0d", operand_a, operand_b, result);
                2'b01: $display("ALU Result: %0d - %0d = %0d", operand_a, operand_b, result);
                2'b10: $display("ALU Result: %0d * %0d = %0d", operand_a, operand_b, result);
                2'b11: 
                    if (error_flag) 
                        $display("ALU Result: DIVISION BY ZERO ERROR!");
                    else
                        $display("ALU Result: %0d / %0d = %0d", operand_a, operand_b, result);
            endcase
        end
    end

endmodule
