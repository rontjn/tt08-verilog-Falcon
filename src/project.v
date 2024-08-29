/*
 * Copyright (c) 2024 
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_control_unit (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Internal signals
    wire [15:0] adc_data;
    wire data_ready;
    wire filter_done;
    wire compare_done;
    wire filter_enable;
    wire compare_enable;
    wire clk_out;
    wire [15:0] filter_data_in;
    wire comparison_result;
    
    // Instantiate SPI module
    spi spi_inst (
        .clk(clk),
        .reset(~rst_n),               // Active-low reset
        .start_conversion(ui_in[0]),  // Using ui_in[0] to start conversion
        .miso(uio_in[0]),             // Assuming MISO comes from uio_in[0]
        .cs_n(uo_out[0]),             // Chip select as part of uo_out[0]
        .sck(uio_out[1]),             // SPI clock assigned to uio_out[1]
        .adc_data(adc_data),
        .data_ready(data_ready)
    );

    // Instantiate clock divider module
    clock_divider clock_divider_inst (
        .clk_in(clk),
        .reset(~rst_n),   // Active-low reset
        .clk_out(clk_out)
    );

    // Instantiate filter module
    filter filter_inst (
        .clk_out(clk_out),
        .reset(~rst_n),             // Active-low reset
        .filter_enable(filter_enable),
        .filter_data_in(filter_data_in),
        .filter_data_out(adc_data),
        .filter_done(filter_done)
    );

    // Instantiate comparator module
    comparator comparator_inst (
        .clk(clk),
        .reset(~rst_n),             // Active-low reset
        .compare_enable(compare_enable),
        .compare_data_out(filter_data_in),
        .comparison_result(comparison_result),
        .compare_done(compare_done)
    );

    // Instantiate control FSM module
    control_fsm control_fsm_inst (
        .clk(clk),
        .reset(~rst_n),            // Active-low reset
        .data_ready(data_ready),
        .filter_done(filter_done),
        .compare_done(compare_done),
        .filter_enable(filter_enable),
        .compare_enable(compare_enable)
    );

    // Assign outputs
    assign uo_out[1]  = comparison_result; // Assign comparison result to uo_out[1]
    assign uo_out[7:2] = 0;                // Assign remaining uo_out pins to 0
    assign uio_out[7:2] = 0;               // Assign remaining uio_out pins to 0
    assign uio_oe       = 8'b00000010;     // Enable uio_out[1] as output

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, 1'b0};

endmodule
