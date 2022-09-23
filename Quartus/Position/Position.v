`timescale 1ps/1ps

// Use the ADC module to obtain data
// Set the LED pins based on the lower 8 bits in channel 0 (in data[3:11])

module Position(input wire clk_50, input adc_sdo, output adc_convst, output adc_sck, output adc_sdi, output reg[7:0] led);
  wire start;
  wire ready;
  wire[95:0] data;
  integer i;
  
  ADC adc(.clk(clk_50), .start(start), .ready(ready), .data(data), .convst(adc_convst), .sck(adc_sck), .sdi(adc_sdi), .sdo(adc_sdo));

  // Read continually - set start as soon as ADC is ready
  assign start = ready;
  
  // When data is ready, set the LEDS
  always @(posedge ready) begin
    for (i=0; i<8; i=i+1)
      led[i] = data[11-i];
  end
endmodule
