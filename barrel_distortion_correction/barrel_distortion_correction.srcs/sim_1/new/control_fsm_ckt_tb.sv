`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.12.2023 09:15:22
// Design Name: 
// Module Name: control_fsm_ckt_tb
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


module control_fsm_ckt_tb;

    // Testbench signals
    reg  clk, reset, valid, done_pixel_processing, new_frm ; 
    wire start_processing, frm_processing_complete;
    // Instantiate the FSM
    control_fsm_ckt uut (
        .clk(clk), .reset(reset), .valid(valid), .done_pixel_processing(done_pixel_processing),.new_frm(new_frm),
        .start_processing(start_processing), .frm_processing_complete(frm_processing_complete)
    );

    // Clock generation
    always begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset = 0;
        valid = 0;
        done_pixel_processing = 0;
        new_frm = 0;

        // Reset the FSM
        #10 reset = 1; new_frm = 1;
        #10 reset = 0;

        // Test case 1: Send valid pixel data
        #10 reset = 1; valid = 1; done_pixel_processing = 0; new_frm = 0;
        #10 reset = 1; valid = 1; done_pixel_processing = 1; new_frm = 0;
        #10 reset = 1; valid = 0; done_pixel_processing = 1; new_frm = 0;
        #10 reset = 1; valid = 0; done_pixel_processing = 1; new_frm = 1;
        #10 reset = 0; valid = 1; done_pixel_processing = 0; new_frm = 0;
        #10 reset = 1; valid = 0; done_pixel_processing = 0; new_frm = 0;
        #10 reset = 1; valid = 1; done_pixel_processing = 0; new_frm = 0;
        #10 reset = 1; valid = 1; done_pixel_processing = 1; new_frm = 1;
        #10 reset = 1; valid = 0; done_pixel_processing = 1; new_frm = 0;
        

        // Add more test cases as needed

        #200 $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("Time = %t, valid =%d, done_pixel_processing =%d, State =%d, start_processing =%b, frm_processing_complete =%b ", $time, valid, done_pixel_processing, uut.ps, start_processing, frm_processing_complete);
    end
endmodule


