`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2023 14:06:00
// Design Name: 
// Module Name: control_fsm_ckt
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


module control_fsm_ckt(
    input logic clk, reset, valid, done_pixel_processing, new_frm, 
    output logic start_processing, frm_processing_complete
    );
    // states defination - idel/initial, normalize, correct_distortion, pixel_conversion, boundary_check, output
    typedef enum logic [1:0]{
        IDLE,
        PROCESSING,
        DONE
    } states;
    
    // state variabes
    states ps, ns;
    
    // state assigning logic 
    always_ff @(posedge clk or negedge reset) begin
        if (!reset)begin 
            ps <= IDLE;
        end else
            ps <= ns;    
    end
    // state transition logic 
    always_comb begin
        start_processing = 0;
        frm_processing_complete = 0;
        case (ps)
           IDLE: begin
                if (valid) ns = PROCESSING;
                else if (done_pixel_processing && !valid && !new_frm) ns = DONE;
                else ns = IDLE;
           end
           PROCESSING: begin
                start_processing = 1;
                if (done_pixel_processing && !valid && !new_frm) ns = DONE; 
                else if (done_pixel_processing && valid && !new_frm) ns = PROCESSING;
                else ns = IDLE;
           end
           DONE: begin
                frm_processing_complete = 1;
                if (new_frm) ns = IDLE;
                else ns = DONE;
           end
           default: ns = IDLE;
        endcase
    end
endmodule
