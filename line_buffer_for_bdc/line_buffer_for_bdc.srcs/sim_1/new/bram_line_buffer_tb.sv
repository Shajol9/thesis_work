`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2024 09:53:00
// Design Name: 
// Module Name: bram_line_buffer_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_line_buffer_tb();

    // Parameters of the DUT
    localparam SIGNAL_SIZE = 24;
    localparam LINE_NUMBER = 100;
    localparam LINE_WIDTH = 1127;
    localparam ADDRESS_WIDTH = 17;

    // Testbench signals
    logic clk;
    logic reset;
    logic [23:0] ip_signal_data;
    logic ip_data_valid;
    logic [23:0] op_signal_data;
    logic start_read;
    logic op_data_valid;

    // Instantiate the unit under test (UUT)
    bram_line_buffer #(
        .SIGNAL_SIZE(SIGNAL_SIZE),
        .LINE_NUMBER(LINE_NUMBER),
        .LINE_WIDTH(LINE_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) bram_lbuff_uut (
        .clk(clk),
        .reset(reset),
        .ip_signal_data(ip_signal_data),
        .ip_data_valid(ip_data_valid),
        .op_signal_data(op_signal_data),
        .start_read(start_read),
        .op_data_valid(op_data_valid)
    );

    // Clock generation
    always #5 clk = ~clk; // Generate a clock with a period of 10ns

    // Test sequence
    initial begin
        // Initialize testbench signals
        clk = 0;
        reset = 1;
        ip_signal_data = 0;
        ip_data_valid = 0;
        start_read = 0;

        // Apply reset
        #20;
        reset = 0;
        #20;

        // Begin test sequence
        // Writing to the buffer
        for (int i = 0; i < 255; i++) begin
            ip_signal_data = i;
            ip_data_valid = 1;
            #10; // Wait for one clock cycle
        end
        ip_data_valid = 0;

        // Reading from the buffer
        #100; 
        for (int j = 0; j < 255; j++) begin
            start_read = 1;
            #10; // Wait for one clock cycle to read data
            if (op_data_valid) begin
                $display("Time: %0t, Read Data: %0d", $time, op_signal_data);
            end
        end
        start_read = 0;

        $finish;
    end

endmodule



