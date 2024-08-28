module filter#(  
    parameter DATA_WIDTH = 16, // Width of the input and output data
    parameter COEFF_WIDTH = 16, // Width of the filter coefficients
    parameter NUM_TAPS = 4 // Number of taps (filter order + 1)
)(
    input clk_out,
    input reset,
    input filter_enable, // Enable signal for the filter
    input [DATA_WIDTH-1:0] filter_data_out, // ADC data input
    output reg [DATA_WIDTH-1:0] filter_data_in, // Filtered data output
    output reg filter_done // Done signal to indicate processing completion
);
   
    // Filter coefficients
    reg [COEFF_WIDTH-1:0] coeffs[NUM_TAPS-1:0];

    // Shift register for input samples
    reg [DATA_WIDTH-1:0] shift_reg[NUM_TAPS-1:0];

    // Temporary variable for accumulation
    reg [2*DATA_WIDTH-1:0] accumulator;

    integer i;

    // Initialize coefficients
    initial begin
        coeffs[0] = 16'd3;
        coeffs[1] = 16'd1;
        coeffs[2] = 16'd1;
        coeffs[3] = 16'd3;
    end

    // FIR filter processing
    always @(posedge clk_out or posedge reset) begin
        if (reset) begin
            filter_data_in <= {DATA_WIDTH{1'b0}};
  accumulator = 32'b0;
            filter_done <= 1'b0; // Ensure done signal is low on reset
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                shift_reg[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (filter_enable) begin
             
// Shift in new sample
            for (i = NUM_TAPS-1; i > 0; i = i - 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= filter_data_out;

            // Compute filter output
            accumulator = 32'b0;
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                accumulator = accumulator + (shift_reg[i] * coeffs[i]);
            end

            // Assign the lower DATA_WIDTH bits of the accumulator to filter_data_in
            filter_data_in <= accumulator[DATA_WIDTH-1:0];
           
            // Set done signal
            filter_done <= 1'b1; // Indicate that filter processing is done
        end else begin
            filter_done <= 1'b0; // Done signal is low when filter_enable is not active
        end
    end

endmodule

