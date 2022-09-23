`timescale 1ns/1ns

module ADCTest(input CLOCK_50, input[0:0] KEY, input[2:0] SW, output[7:0] LED, output ADC_SCK, output ADC_CONVST, input ADC_SDO, output ADC_SDI);
  wire[11:0] values[7:0];
  assign LED = values[SW][11:4];
  ADC adc(.CLOCK(CLOCK_50), .RESET(!KEY[0]), .ADC_SCLK(ADC_SCK), .ADC_CS_N(ADC_CONVST), .ADC_DOUT(ADC_SDO), .ADC_DIN(ADC_SDI), .CH0(values[0]), .CH1(values[1]), .CH2(values[2]), .CH3(values[3]), .CH4(values[4]), .CH5(values[5]), .CH6(values[6]), .CH7(values[7]));
endmodule