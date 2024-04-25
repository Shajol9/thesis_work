`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazzad Hossain 
// 
// Create Date: 29.11.2023 13:01:17
// Design Name: 
// Module Name: undistroted_pixel_cordinates
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


module undistorted_pixel_cordinates(
        input logic clk, reset, upc_start,
        input logic signed [31:0] height, width,
        input logic signed [31:0] x_undistorted, y_undistorted,
        output logic signed [31:0] x_undistorted_pixel, y_undistorted_pixel,
        output logic upc_done
    );
    logic signed [31:0] center_x, center_y;
//    logic upc_active; 
//    always @(posedge clk or negedge reset or x_undistorted or y_undistorted or upc_start) begin
//        upc_done = 0;
//    end 
    always @(posedge clk or negedge reset)  begin
        if (!reset) begin
//            upc_active <= 0;
            center_x <= 0;
            center_x <= 0;
            x_undistorted_pixel <= 0;
            y_undistorted_pixel <= 0;
        end else begin
            if (upc_start ) begin
                center_x = width * 1024 / 2;   // s21.10 format
                center_y = height * 1024 / 2; // s21.10 format
                x_undistorted_pixel =  (((center_x * x_undistorted)/1024) + center_x)/1024;// s21.10 format
                y_undistorted_pixel =  (((center_y * y_undistorted)/1024) + center_y)/1024;
            
                upc_done = 1;            
//                if (upc_done && upc_active) upc_active = 0;
            end else if (upc_done) begin
                upc_done = 0;
            end     
        end    
    end
endmodule

    /* this is not required, if required later put it inside the module.
    // Function to round to the nearest integer
    function signed [31:0] round (input signed [31:0] value);
        if (value >= 0) begin
            round = (value + 32768) >> 16; // For positive values
        end else begin
            round = (value - 32768) >> 16; // For negative values
        end
    endfunction 
    */

