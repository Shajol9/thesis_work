`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazzad Hossain
// 
// Create Date: 04.12.2023 12:39:27
// Design Name: 
// Module Name: barrel_distortion_correction_top_tb
// Project Name: Barrel DIstortion COrrection 
// Target Devices: 
// Tool Versions: 
// Description: Test bench for barrel_distotion_correction_top module  
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module barrel_distortion_correction_top_tb(    
    );
    // test signals to be applied and observed
    reg clk, reset ;
    reg signed [31:0]  height, width, x, y, k_1, k_2;
    wire signed [31:0]  out_x, out_y;
    wire done; 
    
    initial begin
        clk = 0;
        forever #5 clk <= ~clk;
    end

    // istanciating barrel distortion correction top module as unit under test 
    barrel_distortion_correction_top  bdct_uut (
        .clk(clk), .reset(reset),
        .height(height), .width(width), .x(x), .y(y), .k_1_bdc(k_1), .k_2_pdc(k_2),
        .x_out(out_x), .y_out(out_y),
        .done(done)
    );
    
    // giving test cordinates of distorted pictures  
    initial begin
        #0; 
        reset = 0;
        height = 0; 
        width = 0;
        x = 0;
        y = 0;
        k_1 = 0;
        k_2 = 0;
        #1; reset = 1;
        #2
        height = 845; 
        width = 1127;
        x = 11;
        y = 20;
        k_1 = 0.2011 * 1024;
        k_2 = -0.02687 * 1024;
        #10;
        x = 300; y = 200;
        #10;
        x = 155; y= 128;
        #10;
        x= 232; y= 711;
        #10;
        x= 331; y= 412;
        #10;
        x = 869; y= 676;
        #10;
        x= 421; y= 555;
        #10;
        x = 587; y = 239;
        #10;
        x = 771; y = 328;
        #10;
        x = 1127; y = 845;
        #10;
        x = 445; y = 399;
        #10;
        x = 347; y = 322;
        #10;
        x= 05; y = 03;
        #10; reset = 0;
        #500 $finish; 
    end
    // for monitoring output
    always @(posedge clk) begin
        $display ("Time: %d ,x: %d, out_x: %d, y: %d, out_y: %d", $time , x, out_x, y, out_y);
    end
endmodule
