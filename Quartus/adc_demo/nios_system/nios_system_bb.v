
module nios_system (
	clk_clk,
	reset_reset,
	leds_export,
	adc_sclk,
	adc_cs_n,
	adc_dout,
	adc_din);	

	input		clk_clk;
	input		reset_reset;
	output	[7:0]	leds_export;
	output		adc_sclk;
	output		adc_cs_n;
	input		adc_dout;
	output		adc_din;
endmodule
