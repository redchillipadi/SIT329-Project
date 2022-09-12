
module nios_system (
	reset_reset,
	clk_clk,
	leds_export,
	adc_sclk,
	adc_cs_n,
	adc_dout,
	adc_din);	

	input		reset_reset;
	input		clk_clk;
	output	[7:0]	leds_export;
	output		adc_sclk;
	output		adc_cs_n;
	input		adc_dout;
	output		adc_din;
endmodule
