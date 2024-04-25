`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazzad Hossain 
// 
// Create Date: 04.12.2023 10:20:02
// Design Name: 
// Module Name: barrel_distortion correction_top
// Project Name: Barrel Distrotion Correction
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


module barrel_distortion_correction_top(
        input logic clk, reset, start_prcessing,                  // valid is for indication new pixel coordinats rady for procesing or start of new process
        input logic signed [31:0] height, width,        // image dimension.
        input logic signed [31:0] x, y,                 // input distorted pixel coordinates. 
        input logic signed [31:0] k_1_bdc, k_2_pdc,     // k_1_bdc = barrel distortion coefficient, k_2_pdc = pincushion distortion coefficient.
        output logic signed [31:0] x_out, y_out,        // undistroted/corrected pixel coordinates.
        output logic done_pxl_process                               // flag for indicating completion of a pixel coordinate proccesing
    );
        // internal signals
        logic start = 0; 
        logic signed [31:0] x_normalized_intr, y_normalized_intr;
        logic signed [31:0] x_undistorted_intr, y_undistorted_intr;
        logic signed [31:0] x_undistorted_pixel_intr, y_undistorted_pixel_intr;
        logic signed [31:0] x_discard_intr, y_discard_intr;
        logic nc_done_intr, unc_done_intr, npc_done_intr, bc_done_intr;
        
//        always @(posedge clk or negedge reset or x or y)begin
//            done_pxl_process <= 0;
//        end
             
        // instantiation of submodule - normalized_cordinates.sv 
                normalized_cordinates nc (
                    .clk(clk), .reset(reset), .nc_start(start),
                    .x(x), .y(y), .height(height), .width(width),              // connecting inputs of the sub modules with necessary signals 
                    .x_normalized(x_normalized_intr),.y_normalized(y_normalized_intr),     // connecting output of the sub modules with necessary signals 
                    .nc_done(nc_done_intr)
                );
        
                // instantiation of submodule - undistorted_normalized_cordinates.sv
                undistorted_normalized_cordinate unc (
                    .clk(clk), .reset(reset), .unc_start(nc_done_intr),
                    .x_normalized(x_normalized_intr), .y_normalized(y_normalized_intr), .k_1(k_1_bdc), .k_2(k_2_pdc),     // conneting input of the submodule to apropriate signals
                    .x_undistorted(x_undistorted_intr), .y_undistorted(y_undistorted_intr),                                // conneting output of the submodule to apropriate signals
                    .unc_done(unc_done_intr)
                );
        
                // instantiation of submodule - undistorted_pixel_cordinates.sv
                undistorted_pixel_cordinates upc (
                    .clk(clk), .reset(reset), .upc_start(unc_done_intr),
                    .height(height), .width(width), .x_undistorted(x_undistorted_intr), .y_undistorted(y_undistorted_intr),   //conneting input of the submodule to apropriate signals
                    .x_undistorted_pixel(x_undistorted_pixel_intr), .y_undistorted_pixel(y_undistorted_pixel_intr),            //conneting output of the submodule to apropriate signals 
                    .upc_done(upc_done_intr)
                );
        
                boundary_check bc(
                    .clk(clk), .reset(reset), .bc_start(upc_done_intr),
                    .x_pixel(x_undistorted_pixel_intr), .y_pixel(y_undistorted_pixel_intr), .height(height), .width(width),      //conneting input of the submodule to apropriate signals
                    .pixel_output_x(x_out), .pixel_output_y(y_out), .discard_x(x_discard_intr), .discard_y(y_discard_intr),       //conneting output of the submodule to apropriate signals
                    .bc_done(bc_done_intr)
                );
       always_ff @(posedge clk or negedge reset)begin
            if (!reset) begin 
//                x_normalized_intr <= 0; 
//                y_normalized_intr <= 0;
//                x_undistorted_intr <= 0;
//                y_undistorted_intr <= 0;
//                x_undistorted_pixel_intr <= 0; 
//                y_undistorted_pixel_intr <= 0;
//                x_discard_intr <= 0; 
//                y_discard_intr <= 0;
//                nc_done_intr = 0; 
//                unc_done_intr = 0; 
//                npc_done_intr = 0; 
//                bc_done_intr = 0;
//                x_out <= 0;
//                y_out <= 0;
                done_pxl_process <= 0;
            end else begin
                if (start_prcessing) start = start_prcessing;
                if (bc_done_intr) done_pxl_process = 1;
                else done_pxl_process = 0;   
            end          
       end
endmodule
