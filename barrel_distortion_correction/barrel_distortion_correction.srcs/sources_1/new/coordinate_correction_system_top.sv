`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.12.2023 10:36:00
// Design Name: 
// Module Name: coordinate_correction_system_top
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


module coordinate_correction_system_top(
    input logic clk, reset, valid, new_frm,
    input logic signed [31:0] height, width, x, y, k_1_bdc, k_2_pdc,
    output logic signed [31:0] x_out, y_out,
    output logic frm_processing_complete
);

    logic start_processing, done_pxl_process;

    // Instantiate Control FSM
    control_fsm_ckt fsm (
        .clk(clk), .reset(reset), .valid(valid),
        .done_pixel_processing(done_pxl_process),.new_frm(new_frm),
        .start_processing(start_processing),.frm_processing_complete(frm_processing_complete)
    );

    // Instantiate Barrel Distortion Correction Top
    barrel_distortion_correction_top bdc_top (
        .clk(clk), .reset(reset), .start_prcessing(start_processing),
        .height(height), .width(width), .x(x), .y(y),
        .k_1_bdc(k_1_bdc), .k_2_pdc(k_2_pdc),
        .x_out(x_out), .y_out(y_out), .done_pxl_process(done_pxl_process)
    );


endmodule
