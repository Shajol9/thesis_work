`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2023 10:47:50
// Design Name: 
// Module Name: coordinate_correction_system_top_tb
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


module coordinate_correction_system_top_tb();
    
    reg clk, reset, valid, new_frm;
    reg signed [31:0] height, width, x, y, k_1_bdc, k_2_pdc;
    wire signed [31:0] x_out, y_out;
    wire frm_processing_complete;

    // Instantiate the system_top
    coordinate_correction_system_top uut(
        .clk(clk), .reset(reset), .valid(valid), .new_frm(new_frm),
        .height(height), .width(width), .x(x), .y(y),
        .k_1_bdc(k_1_bdc), .k_2_pdc(k_2_pdc),
        .x_out(x_out), .y_out(y_out),
        .frm_processing_complete(frm_processing_complete)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    task new_coordinates(input logic signed [31:0] new_x, input logic signed [31:0] new_y);
        begin
            x = new_x;
            y = new_y;
            valid = 1;
        end
    endtask
    
    always @(posedge clk) begin
        if (valid) valid <= 0;
    end

    // Test Sequence
    initial begin
        // Initialize Inputs
        reset = 0; valid = 0; new_frm = 0;
        height = 845; width = 1127;
        k_1_bdc = 0.2011 * 1024; k_2_pdc = -0.02687 * 1024;  
        x = 0; y = 0;

        // Reset Pulse
        #10 reset = 1;

        // Start processing a new frame
        new_frm = 1;
        #10 new_frm = 0;  new_coordinates (100,150); //x = 100; y = 150; expected x_out = , y_out =  
        #10  new_coordinates (200,250); //x = 200; y = 250; expected x_out = , y_out =  
        #10  new_coordinates (11,20); //x = 300; y = 350; expected x_out = 132, y_out = 108
        #10  new_coordinates (300,200); //x = 300; y = 200; expected x_out = 323, y_out = 219  
        #10  new_coordinates (155,128); //x = 155; y= 128; expected x_out = 216, y_out = 172 
        #10  new_coordinates (232,711); //x = 232; y= 711; expected x_out = 274, y_out = 674 
        #10  new_coordinates (331,412); //x = 331; y= 412; expected x_out = 338, y_out = 412 
        #10  new_coordinates (869,676); //x = 869; y= 676; expected x_out = 835, y_out = 648 
        #10  new_coordinates (421,555); //x= 421; y= 555; expected x_out = 425, y_out = 550 
        #10  new_coordinates (587,239); //x = 587; y = 239; expected x_out = 585, y_out = 245 
        #10  new_coordinates (771,328); //x = 771; y = 328; expected x_out = 763, y_out = 331 
        #10  new_coordinates (1127,845); //x = 1127; y = 845; expected x_out = 998, y_out = 748 
        #10  new_coordinates (445,399); //x = 445; y = 399; expected x_out = 446, y_out = 399 
        #10  new_coordinates (347,322); //x = 347; y = 322; expected x_out = 355, y_out = 326 
        #10  new_coordinates (05,03); //x= 05; y = 03; expected x_out = 130, y_out = 97 

        // End of processing
        #40 reset = 0;

        // Finish Simulation after some time
        #200 $finish;
    end

    // Monitoring
    always @(posedge clk) begin
        $display("Time: %0t, x: %d, x_out: %0d, y: %d, y_out: %0d, frm_processing_complete: %0b",
                 $time, x, x_out, y, y_out, frm_processing_complete);
    end
endmodule

