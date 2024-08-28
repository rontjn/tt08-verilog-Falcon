`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:01 08/27/2024 
// Design Name: 
// Module Name:    clock_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock_divider(
    input wire clk_in,          // Input system clock (70 MHz)
    input wire reset,           // Reset signal
    output reg clk_out          // Output divided clock (5 kHz)
);

    // Parameters
    parameter DIVISOR = 14000;  // Division factor for 5 kHz output

    // Internal signals
    reg [13:0] counter;         // 14-bit counter

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIVISOR- 1)) begin
                counter <= 0;
                clk_out <= ~clk_out;  // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
