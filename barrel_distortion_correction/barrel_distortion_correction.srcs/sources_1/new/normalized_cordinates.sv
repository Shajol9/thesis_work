`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.11.2023 10:12:19
// Design Name: normalized_cordinates
// Module Name: normalized_cordinates
// Project Name: Barrel Distortion Correction
// Target Devices: 
// Tool Versions: 
// Description: This module should take in pixel cordinates and normalize 
//              thouse cordinates for further operation on them by subtracting
//              central pixel cordinates and tehn deviding the result by 
//              central pixel cordinates. Normalizing the pixlec cordinate 
//              along the center pixel.  
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module normalized_cordinates(
    input logic clk, reset, nc_start,
    input logic signed [31:0] x, y,                               // pixel cordiantes
    input logic signed [31:0] height , width,                     // image dimension, used to find central pixel cordinates 
    output logic signed [31:0] x_normalized, y_normalized,         // normalized pixel cordinates
    output logic nc_done                                       
    );
    // Fixed point arithmetic is implied with s21.10 so the scaling factor is 1024
    // s21.10 - 1 signed bit, 21 bits for representing hole number, 10 bits for representing fractional number
    //logic valid_pxl;
    logic signed [31:0] center_x, center_y;    // center coordinates calcualtion
    logic signed [31:0] temp_x, temp_y;         // variable for scaled calculation
    logic signed [31:0] prev_x, prev_y;
    logic signed [31:0] prev_x_norm, prev_y_norm;
    logic nc_active;
    

    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            nc_active <= 0;
            center_x <= 0;
            center_y <= 0;
            prev_x <= 0;
            prev_y <= 0;
            temp_x <= 0;
            temp_y <= 0;
            x_normalized <= 0;
            y_normalized <= 0;
            nc_done <= 0;  
        end else begin
            if (nc_start || x != prev_x || y != prev_y) begin //&& !nc_active && 
                //nc_active = 1;
                nc_done = 0;  
                prev_x = x;
                prev_y = y;
                prev_x_norm = x_normalized;
                prev_y_norm = y_normalized;
                center_x = (width * 1024)/2 ;      // scalling by 1024 with 10 left shifts, right shift for deviding by 2
                center_y = (height * 1024)/2 ;
                //(x << 10), (y << 10) are done for scaling to represent x and y cordinates in fixed point format 
                // Question: x and y are integer values - do I need to represent them in fixed point format?
                temp_x = (x * 1024);        
                temp_y = (y * 1024);
        
                x_normalized = ((temp_x - center_x)*1024/center_x) ; // >> 10;         // do I need to scale down for s21.10 format ?? is the corrent format s11.20??
                y_normalized = ((temp_y - center_y)*1024/center_y) ; // >> 10;         // write the bit distrtibution in fixed point representation - s21.10        
                if (!nc_done && (prev_x_norm != x_normalized || prev_y_norm != y_normalized)) 
                    nc_done = 1;
            end else if (nc_done || (x != prev_x || y != prev_y)) begin               //nc_done &&(prev_x_norm != x_normalized || prev_y_norm != y_normalized)||
                nc_done = 0;
            end
        end
    end    

endmodule
