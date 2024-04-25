`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazzad Hossain 
// 
// Create Date: 08.12.2023 09:12:28
// Design Name: 
// Module Name: undistroted_normalized_cordinates_tb
// Project Name: barrel_distortion_correction
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


module undistorted_normalized_cordinate_tb();
    // Testbench signals
    reg clk, reset, unc_start;
    reg signed [31:0] x_normalized, y_normalized, k_1_b, k_2_p;
    wire signed [31:0] x_undistorted, y_undistorted;
    wire unc_done;
    // cloclk initialization 
    initial begin 
        clk = 0;
        forever #5 clk <= ~clk;
    end

    // Instantiate the module under test
    undistorted_normalized_cordinate uut (
        .clk(clk), .reset(reset), .unc_start(unc_start), 
        .x_normalized(x_normalized), .y_normalized(y_normalized),
        .k_1(k_1_b), .k_2(k_2_p),
        .x_undistorted(x_undistorted), .y_undistorted(y_undistorted),
        .unc_done (unc_done)
    );
    
    task assert_unc_start (input logic signed [31:0] x_new, input logic signed [31:0] y_new);
        begin 
            x_normalized = x_new ;
            y_normalized = y_new ;
            unc_start = 1;
        end    
    endtask
    
    
    
    initial begin
        // Initialize inputs
        x_normalized = 0; y_normalized = 0; reset = 0; unc_start = 0;
        
        k_1_b = 0.2011 * 1024  ; k_2_p = -0.02687 * 1024;           // Set distortion coefficients
        #1; reset = 1; unc_start = 1; 
        // Applying test stimulus
        #2;                                    // Wait for 10 time units
        assert_unc_start (-478,-539);   //x_normalized = -478; y_normalized = -539; unc_start = 1; // Set normalized pixel coordinates           
        #10;
        assert_unc_start (-742,-713);   //x_normalized = -742; y_normalized = -713; unc_start = 1;
        #10;
        assert_unc_start (-602,699);    //x_normalized = -602; y_normalized = 699; unc_start = 1;
        #10;
        assert_unc_start (-422,-25);    //x_normalized = -422; y_normalized = -25; unc_start = 1;
        #10;
        assert_unc_start (555,614);     //x_normalized = 555; y_normalized = 614; unc_start = 1;
        #10;
        assert_unc_start (-258,321);    //x_normalized = -258; y_normalized = 321; unc_start = 1;
        #10;
        assert_unc_start (42,-444);     //x_normalized = 42; y_normalized = -444; unc_start = 1;
        #10;
        assert_unc_start (377,-229);    //x_normalized = 377; y_normalized = -229; unc_start = 1;
        #10;
        assert_unc_start (-478,-539);   //x_normalized = 1024; y_normalized = 1024; unc_start = 1;
        #40; 
        reset = 0;
        

        #200 $finish; // Finish the simulation after some time
    end
    
    always  @(posedge clk) begin
        $display ("Time: %t, x_normalized: %d, x_undistorted: %d, y_normalized: %d, y_undistorted: %d", $time, x_normalized, x_undistorted, y_normalized, y_undistorted);
    end
endmodule
