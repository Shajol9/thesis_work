`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazad Hossain
// 
// Create Date: 29.11.2023 12:06:02
// Design Name: 
// Module Name: undistorted_normalized_cordinate
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


module undistorted_normalized_cordinate(
        input logic clk, reset, unc_start, 
        input logic signed [31:0] x_normalized, y_normalized, //s21.10, scaled, from normalized_cordinates module
        input logic signed [31:0] k_1, k_2,
        output logic signed [31:0]  x_undistorted , y_undistorted,
        output logic unc_done
    );
     
    //logic signed [31:0] temp_k_1, temp_k_2;
    //logic [15:0] r;
    // if i don't perform any shiftinh then the bit width will be-
    logic signed [63:0] r_sq, x_normalized_sq, y_normalized_sq; //as they are product of two s21.10 number 
    logic signed [63:0] r_quad; // 
    logic signed [63:0] k_1_r_sq, k_2_r_quad ,denominator; 
    logic unc_active;
    
    logic signed [31:0] prev_x_undis, prev_y_undis;
    
//    always @(posedge clk or negedge reset or x_normalized or y_normalized or unc_start)begin
//        unc_done = 0;
//    end   


    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            unc_active <= 0;
            x_normalized_sq <= 0; 
            y_normalized_sq <= 0; 
            r_sq <= 0; 
            r_quad <= 0; 
            k_1_r_sq <= 0; 
            k_2_r_quad <= 0; 
            denominator <= 0;
            prev_x_undis <= 0;
            prev_y_undis <= 0; 
            x_undistorted <= 0; 
            y_undistorted <= 0; 
        end else begin
            if (unc_start) begin                            //!unc_active
                //unc_active = 1;
                // scalig the value of k_1 and k_2
                //temp_k_1 = (k_1 );// * 1024;
                //temp_k_2 = (k_2 );// * 1024;
                prev_x_undis = x_undistorted ;
                prev_y_undis = y_undistorted ;
                // descale from s43.20 to s21.10 format by >>31?
                x_normalized_sq = (x_normalized * x_normalized); //>> 31;  
                y_normalized_sq = (y_normalized * y_normalized); //>> 31;  
     
                r_sq = x_normalized_sq + y_normalized_sq;
                r_quad = r_sq * r_sq;//s23.40
    
                //sqrt_lut sqrt_cal (.in_val(r_sq), .sqrt_val(r));
                //always_comb begin
                k_1_r_sq = k_1 * r_sq ;  //s33.30
                k_2_r_quad = k_2 * r_quad; //s13.50
                denominator = (1 * 1073741824  + k_1_r_sq + k_2_r_quad/1048576);// s33.30
                //after dividing two same scalled value if the fimal result becomes a ratio then all formating gets lost.
                //scalling down denominator by 2^30 and scallig up the result of the complete division by 2^10 as it is a ratio
                //to get a final representaiton of s21.10
                x_undistorted = x_normalized * 1024 /( denominator /1048576 );   
                y_undistorted = y_normalized * 1024 /( denominator/1048576) ;
            
                if (!unc_done && (prev_x_undis != x_undistorted || prev_y_undis != y_undistorted ) ) unc_done = 1;
            end else if (unc_done) begin
                //unc_active = 0;
                unc_done = 0;
            end
        end        
    end    
    
endmodule
