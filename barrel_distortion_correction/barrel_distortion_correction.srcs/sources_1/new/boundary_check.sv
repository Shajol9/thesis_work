`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.11.2023 14:29:05
// Design Name: 
// Module Name: boundary_check
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


module boundary_check(
    input logic clk, reset, bc_start,
    input logic signed [31:0] x_pixel, y_pixel, // Undistorted pixel coordinates
    input logic signed [31:0] height, width,           // Image dimensions
    output logic signed [31:0] pixel_output_x,pixel_output_y, // output pixel coordinae
    output logic signed [31:0] discard_x,discard_y,
    output logic bc_done              // flag for indicating the end of operation
);
    logic is_within_bounds; // Boolean output indicating if the coordinates are within bounds
    logic bc_active;
    // this block resets the flag at each positive clock edge and if reset is issued.
//    always @(posedge clk or negedge reset ) begin
//            bc_done <= 0; 
//    end
    // Check if the undistorted coordinates are within bounds
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            bc_active <= 0;
            bc_done <= 0;
            pixel_output_x <= 0;
            pixel_output_y <= 0;
            discard_x <= 0;
            discard_y <= 0;
        end else begin
            if (bc_start && !bc_active) begin
                bc_active = 1;
                is_within_bounds = (x_pixel >= 0) && (x_pixel < width) && (y_pixel >= 0) && (y_pixel < height);
                if (is_within_bounds == 1) begin
                    pixel_output_x <= x_pixel;
                    pixel_output_y <= y_pixel;
                    
                end else begin
                    discard_x <= x_pixel;
                    discard_y <= y_pixel;
                end
                bc_done = 1;
            end else if (bc_done && bc_active)begin
                bc_active <= 0;
                bc_done <= 0;
            end
        end
    end
endmodule
