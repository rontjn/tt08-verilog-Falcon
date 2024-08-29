`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:21 08/27/2024 
// Design Name: 
// Module Name:    control_unit 
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
module control_unit(
    input clk,
    input reset,
    input start_conversion, // Signal to start ADC conversion
    input miso,             // SPI data input (from ADC)
    output cs_n,            // Chip select for ADC
    output sck,             // SPI clock
    output comparison_result // Final comparison result
);

    // Internal signals
    wire data_ready;
    wire [15:0] adc_data;
    wire filter_done;
    wire compare_done;
    wire filter_enable;
    wire compare_enable;
    wire clk_out;
    wire [15:0] filter_data_in;
    
     // Example threshold value for comparison

    // Instantiate SPI module
    spi spi_inst (
        .clk(clk),
        .reset(reset),
        .start_conversion(start_conversion),
        .cs_n(cs_n),
        .sck(sck),
        .miso(miso),
        .adc_data(adc_data),
        .data_ready(data_ready)
    );

clock_divider clock_divider_inst(.clk_in(clk),
                         .reset(reset),
                         .clk_out(clk_out));
                                                           

 
 
         

    // Instantiate filter module
    filter filter_inst (
        .clk_out(clk_out),
        .reset(reset),
        .filter_enable(filter_enable),
        .filter_data_in(filter_data_in),
        .filter_data_out(adc_data),
        .filter_done(filter_done)
    );

    // Instantiate comparator module
    comparator comparator_inst (
        .clk(clk),
        .reset(reset),
        .compare_enable(compare_enable),
        .compare_data_out(filter_data_in),
       
        .comparison_result(comparison_result),
        .compare_done(compare_done)
    );

    // Instantiate control FSM
    control_fsm control_fsm_inst (
        .clk(clk),
        .reset(reset),
        .data_ready(data_ready),
        .filter_done(filter_done),
        .compare_done(compare_done),
        .filter_enable(filter_enable),
        .compare_enable(compare_enable)
		  );
        
        
        

endmodule 
