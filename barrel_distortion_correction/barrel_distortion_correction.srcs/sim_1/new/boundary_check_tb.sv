`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2023 15:21:24
// Design Name: 
// Module Name: boundary_check_tb
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


module boundary_check_tb();
    // Testbench signals
    reg clk, reset, bc_start;
    reg signed [31:0] x_pixel, y_pixel;
    reg signed [31:0] height, width;
    wire signed [31:0] pixel_output_x, pixel_output_y;
    wire signed [31:0] discard_x, discard_y;
    wire bc_done;

    // Instantiate the module under test
    boundary_check uut(
        .clk(clk), .reset(reset), .bc_start(bc_start),
        .x_pixel(x_pixel), .y_pixel(y_pixel),
        .height(height), .width(width),
        .pixel_output_x(pixel_output_x), .pixel_output_y(pixel_output_y),
        .discard_x(discard_x), .discard_y(discard_y),
        .bc_done(bc_done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        height = 845; width = 1127; // Set image dimensions
        x_pixel = 0; y_pixel = 0;    // Initialize pixel coordinates
        reset = 0; bc_start = 0;
        #6; reset = 1; bc_start = 1;
        // Test Case 1: Pixel within bounds, x_undistorted_pixel and y_undistorted_pixel 
        #10; x_pixel = 323; y_pixel = 219; bc_start = 1;
        #10; x_pixel = 216; y_pixel = 172; bc_start = 1;
        #10; x_pixel = 274; y_pixel = 674; bc_start = 1;
        #10; x_pixel = 338; y_pixel = 412; bc_start = 1;
        #10; x_pixel = 835; y_pixel = 648; bc_start = 1;
        #10; x_pixel = 425; y_pixel = 550; bc_start = 1;
        #10; x_pixel = 585; y_pixel = 245; bc_start = 1;
        #10; x_pixel = 763; y_pixel = 331; bc_start = 1;
        #10; x_pixel = 998; y_pixel = 748; bc_start = 1;
        #3; reset = 0;
        // Test Case 2: Pixel outside bounds - Negative Coordinates
        #7; x_pixel = -10; y_pixel = -10; bc_start = 0;
        #10; reset = 1;    
        // Test Case 3: Pixel outside bounds - Exceeds Width
        #10; x_pixel = 1300; y_pixel = 500; bc_start = 0;

        // Test Case 4: Pixel outside bounds - Exceeds Height
        #10; x_pixel = 500; y_pixel = 1050; bc_start = 1;

        #200 $finish; // End simulation after some time
    end

    // Monitoring
    always @(posedge clk) begin
        $display("Time: %t, x_pixel: %d, y_pixel: %d, Output X: %d, Output Y: %d, Discard X: %d, Discard Y: %d",
                  $time, x_pixel, y_pixel, pixel_output_x, pixel_output_y, discard_x, discard_y);
    end
endmodule

