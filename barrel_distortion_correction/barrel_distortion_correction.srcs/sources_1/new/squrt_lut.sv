`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohammad Shazzad Hossain.
// 
// Create Date: 29.11.2023 11:43:52
// Design Name: look up table for square root
// Module Name: squrt_lut
// Project Name: barrel distortion correction
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


module sqrt_lut(
        input logic [31:0] in_val,
        output logic [15:0] sqrt_val
    );
    //defining the lookup table, size has not been calculated yet
      
    logic [7:0] lut_sqrt [0:5120];
    
    initial begin 
        // need to list down all the posible vlue of r_sqar 
        // and it's square root 
        lut_sqrt[0]= 0;
        lut_sqrt[1]= 1;
        // need to fill in other entries in the table 
        lut_sqrt[5120]= 71.55414;      
    end
    
    always_comb begin
        sqrt_val =  lut_sqrt[in_val];
    end
endmodule
