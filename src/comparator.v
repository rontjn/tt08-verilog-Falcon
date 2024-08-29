`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:34:20 08/27/2024 
// Design Name: 
// Module Name:    comparator 
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
module comparator #(
    parameter data_width = 16  // Parameter defining the bit-width for data and threshold
)(
    input clk,
    input reset,
    input compare_enable,                     // Enable signal for the comparison
    input [data_width-1:0] compare_data_out, // Input data to be compared
    output reg comparison_result,             // 1 if data_in > threshold, else 0
    output reg compare_done                   // Signal to indicate the comparison is complete
);
    // Threshold value for comparison
    reg [data_width-1:0] threshold = 16'b1000; // Initialize to 0, will update in procedural block
    reg [data_width-1:0] compare_data_out_1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            comparison_result <= 0;
            compare_done <= 0;
            compare_data_out_1 <= {data_width{1'b0}};
            // Initialize threshold to 0
        end else if (compare_enable) begin
            compare_data_out_1 <= compare_data_out; 
            compare_done <= 0; // Reset the done signal at the start of comparison

            // Update the threshold value (for this example, you can set it here or as a parameter)
            threshold <= {data_width{1'b0}} + 16'd8; // Example threshold assignment (8 for 16-bit)

            if (compare_data_out_1 > threshold) begin
                comparison_result <= 1'b1;
            end else begin
                comparison_result <= 1'b0;
            end
            compare_done <= 1; // Set the done signal to indicate the comparison is complete
        end else begin
            compare_done <= 0;
        end
    end

endmodule
