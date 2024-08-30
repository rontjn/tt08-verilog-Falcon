`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:38 08/27/2024 
// Design Name: 
// Module Name:    control_fsm 
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
module control_fsm(
    input clk,
    input reset,
    input data_ready,
    input filter_done,
    input compare_done,
    output reg filter_enable,
    output reg compare_enable
);

    // State encoding
    reg [2:0] filter_state, compare_state;

    // State encoding
    parameter IDLE = 3'b000,
              ACTIVE = 3'b001,
              DONE = 3'b010;

    // State update and data handling
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset states and registers
            filter_state <= IDLE;
            compare_state <= IDLE;
            filter_enable <= 0;
            compare_enable <= 0;
        end else begin
		      
            // Handle filter state
            case (filter_state) 
                IDLE: if (data_ready) begin
                    filter_state <= ACTIVE;
                    filter_enable <= 1;
                end
                ACTIVE: if (filter_done) 
		filter_state <= DONE;
						  
					 
                DONE: filter_state <= IDLE;
                default: filter_state <= IDLE;
            endcase

            // Handle compare state
            case (compare_state)
                IDLE: if (filter_state == DONE) begin
                    compare_state <= ACTIVE;
                    compare_enable <= 1;
                end
                ACTIVE: if (compare_done) 
					      compare_state <= DONE;
                DONE: compare_state <= IDLE;
                default: compare_state <= IDLE;
            endcase
        end
    end

endmodule

