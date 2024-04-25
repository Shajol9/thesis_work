`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 17:40:04
// Design Name: 
// Module Name: undistroted_pixel_coordinates_tb
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


module undistroted_pixel_coordinates_tb( );
       reg clk, reset, upc_start;
       reg signed [31:0] height, width;
       reg signed [31:0] x_undistorted, y_undistorted;
       wire signed [31:0] x_undistorted_pixel, y_undistorted_pixel;
       wire upc_done;

       
       // instantiation of undistorted_pixel_cordinates as upc, dut
       undistorted_pixel_cordinates upc (
            //.*    
            .clk(clk), .reset(reset), .upc_start(upc_start), .height(height), .width(width), 
            .x_undistorted(x_undistorted), .y_undistorted(y_undistorted), 
            .x_undistorted_pixel(x_undistorted_pixel), .y_undistorted_pixel(y_undistorted_pixel),
            .upc_done(upc_done)   
       );
       //clock initialization
       initial begin
            clk = 0;
            forever #5 clk <= ~clk;
       end
       // test stimulas 
       initial begin 
            #0; reset =0; height = 845; width=1127;
            x_undistorted = 0; y_undistorted = 0; 
            #1; reset =1; upc_start =1;
            #2;  x_undistorted = -437; y_undistorted = -493; upc_start =1;
            #10; x_undistorted = -631; y_undistorted = -606; upc_start =1;
            #10; x_undistorted = -525; y_undistorted = 610; upc_start =1;
            #10; x_undistorted = -408; y_undistorted = -24; upc_start =1;
            #10; x_undistorted = 495; y_undistorted = 548; upc_start =1;
            #10; x_undistorted = -250; y_undistorted = 311; upc_start =1;
            #10; x_undistorted = 40; y_undistorted = -428; upc_start =1;
            #10; x_undistorted = 363; y_undistorted = -221; upc_start =1;
            #10; x_undistorted = 791; y_undistorted = 791; upc_start =1;
            #10; reset = 0;
            #200 $finish;
       end 
       
       always @(posedge clk) begin
            $display (" Time: %t, x_undistorted:%d, x_undistorted_pixel:%d, y_undistorted:%d, y_undistorted_pixel:%d ", $time, x_undistorted, x_undistorted_pixel, y_undistorted, y_undistorted_pixel);
       end     
endmodule
