module write_memory(
  input logic [63:0] in,
  input	logic clk,
  input	logic reset,
  input logic adc_dout,
  output logic [63:0] ch0,
  output logic [63:0] ch1,
  output logic [63:0] ch2,
  output logic [63:0] ch3,
  output logic [63:0] ch4,
  output logic [63:0] ch5,
  output logic [63:0] ch6,
  output logic [63:0] ch7,
  output logic adc_sclk,
  output logic adc_convst,
  output logic adc_din
);

reg	[11:0]	adc_CH0;
reg	[11:0]	adc_CH1;
reg	[11:0]	adc_CH2;
reg	[11:0]	adc_CH3;
reg	[11:0]	adc_CH4;
reg	[11:0]	adc_CH5;
reg	[11:0]	adc_CH6;
reg	[11:0]	adc_CH7;

ADC adc(
	.CLOCK(clk),
	.RESET(reset),
	.CH0(adc_CH0),
	.CH1(adc_CH1),
	.CH2(adc_CH2),
	.CH3(adc_CH3),
	.CH4(adc_CH4),
	.CH5(adc_CH5),
	.CH6(adc_CH6),
	.CH7(adc_CH7),
	.ADC_SCLK(adc_sclk),
	.ADC_CS_N(adc_convst),
	.ADC_DOUT(adc_dout),
	.ADC_DIN(adc_din));	


assign ch0[63:12] = 52'd0;
assign ch1[63:12] = 52'd0;
assign ch2[63:12] = 52'd0;
assign ch3[63:12] = 52'd0;
assign ch4[63:12] = 52'd0;
assign ch5[63:12] = 52'd0;
assign ch6[63:12] = 52'd0;
assign ch7[63:12] = 52'd0;

assign ch0[11:0] = adc_CH0;
assign ch1[11:0] = adc_CH1;
assign ch2[11:0] = adc_CH2;
assign ch3[11:0] = adc_CH3;
assign ch4[11:0] = adc_CH4;
assign ch5[11:0] = adc_CH5;
assign ch6[11:0] = adc_CH6;
assign ch7[11:0] = adc_CH7;

endmodule
