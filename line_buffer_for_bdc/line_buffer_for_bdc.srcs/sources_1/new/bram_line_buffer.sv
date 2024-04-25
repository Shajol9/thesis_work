`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2024 12:23:43
// Design Name: 
// Module Name: bram_line_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// line buffer for barrel distortion correction, this line buffer can be used as inpurt line buffer and also can be used as 
// output line buffer.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_line_buffer(
    input logic clk,
    input logic reset,
    input logic [23:0] ip_data, // pixel signal value in RGB, read from distort image, each channel is 8 bits. 
    input logic write_en,      // flag indicating when data writing should start
    input logic read_en,
    output logic [23:0] op_data, // pixel signal value in RGB, added to corrected image pixle data for coorecte coordinates.  
    output logic buffer_full,
    output logic buffer_empty
    );
    
    parameter DATA_SIZE = 24,
              LINE_NUMBER = 100,
              LINE_WIDTH = 1127,
              TOTAL_PIXELS = LINE_NUMBER * LINE_WIDTH,
              ADDRESS_WIDTH = 18; // for addressing the buffer memory cell 
    
    reg [DATA_SIZE-1:0] line_buffer [0: TOTAL_PIXELS-1]; // initiating the lne buffer memory
    reg [ADDRESS_WIDTH-1:0] write_pointer = 0 , read_pointer = 0;   // pointer for pointing the memory location to write to and read from  
    reg [ADDRESS_WIDTH - 1 :0] count = 0; //keep track of number of stored eliment, a counter
    
    assign buffer_full = (count >= TOTAL_PIXELS);
    assign buffer_empty = (count == 0);
    assign op_data = line_buffer [read_pointer];
    
    // writing to the line buffer memory
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            write_pointer <= 0;
            read_pointer <= 0;
            count <= 0;
        end else begin
            // write operation logic 
            if (write_en && !buffer_full) begin
                line_buffer [write_pointer] <= ip_data;
                write_pointer <= (write_pointer + 1) % TOTAL_PIXELS; // incrimenting write pointer and wraping it arround when reaching the end location 
                count <= count + 1;
            end
            // read operation logic 
            if (read_en && !buffer_empty) begin
                // output data is already assigend using continious asseigment to avoid 1 clk cycle delay while reading
                read_pointer = (read_pointer + 1) %  TOTAL_PIXELS;
                count <= count - 1;  
            end
        end
    end
endmodule    
    /*
    // reading form the line buffer memory 
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            read_pointer <= 0;
            data_out_reg <= 0;
        end else if (read_en)begin
            data_out_reg <= line_buffer [read_pointer];
            read_pointer = (read_pointer + 1) % (LINE_NUMBER * LINE_WIDTH); 
        end
    end
    
    assign data_out = data_out_reg;
    */    

