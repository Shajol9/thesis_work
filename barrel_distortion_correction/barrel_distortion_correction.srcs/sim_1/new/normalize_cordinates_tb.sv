`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2023 16:30:12
// Design Name: 
// Module Name: normalize_cordinates_tb
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


module normalize_cordinates_tb(
    );
    
    // Testbench signals
    reg clk, reset, nc_start;
    reg signed [31:0] x, y, height, width;
    wire signed [31:0] x_normalized, y_normalized;
    wire nc_done;
    
    initial begin
        clk = 0;
        forever #5 clk <= ~clk;
    end
    
    // Instantiate the module under test
    normalized_cordinates uut (
        .clk(clk), .reset(reset),.nc_start(nc_start),
        .x(x), .y(y),
        .height(height), .width(width),
        .x_normalized(x_normalized), .y_normalized(y_normalized),
        .nc_done(nc_done)
    );
    
    task assert_nc_start (input logic signed [31:0] x_new, input logic signed [31:0] y_new);
        begin 
            x = x_new ;
            y = y_new ;
            nc_start = 1;
        end    
    endtask
    
    always @(posedge clk)begin
        if (nc_start) nc_start = 0;
    end

    initial begin
        // Initialize inputs
        #0; x = 0; y = 0; height = 845; width = 1127; reset = 0; nc_start =0;
        #02; reset = 1;    
        // Apply test stimulus
//        #7; // Wait for 10 time units
//        height = 845; width = 1127; // Set image dimensions
        #02; assert_nc_start(300,200); //x = 300; y = 200; nc_start = 1;          // Set a pixel coordinate
        #10 assert_nc_start(300,200); 
        #10; assert_nc_start(155,128); //x = 155; y = 128; nc_start = 1;
        #10; assert_nc_start(232,711); //x = 232; y = 711; nc_start = 1;
        #10; assert_nc_start(331,412); //x = 331; y = 412; nc_start = 1;
        #10; assert_nc_start(869,676); //x = 869; y = 676; nc_start = 1;
        #10; assert_nc_start(421,555); //x = 421; y = 555; nc_start = 1;
        #10; assert_nc_start(587,239); //x = 587; y = 239; nc_start = 1;
        #10; assert_nc_start(771,328); //x = 771; y = 328; nc_start = 1;
        #10; assert_nc_start(1127,845); //x = 1127; y = 845; nc_start = 1;
        #40; reset = 0;
        #200 $finish; // Finish the simulation after some time
    end
    
    always @(posedge clk)begin
        $display("Time: %t, x_coordinate: %d, x_normalized: %f, y_coordinate: %d,  y_normalized: %f nc_done = %d", $time, x, x_normalized, y, y_normalized, nc_done);
    end
endmodule
