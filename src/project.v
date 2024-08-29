/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_Falcon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
 
wire _unused = &{ena, 1'b0};  
assign uo_out[4:0] = 0;
    
control_unit control_unit(
    .clk(clk),
    .reset(rst_n),
    .start_conversion(ui_in[7]), // Signal to start ADC conversion
    .miso(ui_in[6]), // SPI data input (from ADC)
    .cs_n(uo_out[7]),            // Chip select for ADC
    .sck(uo_out[6]),             // SPI clock
    .comparison_result(uo_out[5]), // Final comparison result
);
endmodule
