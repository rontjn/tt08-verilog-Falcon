`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:52 08/27/2024 
// Design Name: 
// Module Name:    spi 
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

module spi (
    input clk,              // Shared clock for both control unit and SPI
    input reset,
    input start_conversion, // Signal to start ADC conversion
    output reg cs_n,        // Chip select for ADC
    output reg sck,         // SPI clock
    input miso,             // SPI data input (from ADC)
    output reg [15:0] adc_data, // Captured ADC data (16-bit for AD7685)
    output reg data_ready   // Flag indicating ADC data is ready
);

    reg [3:0] bit_counter;  // Bit counter for SPI communication
    reg [15:0] temp_data;   // Temporary register for capturing SPI data

    // State machine states
    parameter IDLE = 2'b00,
              START = 2'b01,
              RECEIVE = 2'b10,
              DONE = 2'b11;
   
    reg [1:0] state;
   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all state and output registers
            state <= IDLE;
            cs_n <= 1;
            sck <= 0;
            bit_counter <= 4'b0000;
            adc_data <= 16'b0;
            data_ready <= 0;
            temp_data <= 16'b0; // Initialize temp_data
        end else begin
            case (state)
                IDLE: begin
                    cs_n <= 1;  // Keep chip select high in idle state
                    sck <= 0;
                    data_ready <= 0;
                    if (start_conversion) begin
                        state <= START;
                    end
                end
                START: begin
                    cs_n <= 0;  // Start communication by pulling chip select low
                    sck <= 0;
                    bit_counter <= 4'b1111; // Start with bit counter at 15
                    state <= RECEIVE;
                end
                RECEIVE: begin
                    sck <= ~sck;  // Toggle SPI clock
                    if (sck) begin
                        // Capture data on the rising edge of SCK
                        temp_data[bit_counter] <= miso;
                        bit_counter <= bit_counter - 1; // Decrement bit counter
                        if (bit_counter == 0) begin
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    cs_n <= 1;  // End communication by pulling chip select high
                    adc_data <= temp_data;
                    data_ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
