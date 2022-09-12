module adc_demo(input CLOCK_50, input[0:0] KEY, output[7:0] LED, output ADC_SCLK, output ADC_CONVST, input ADC_SDO, output ADC_SDI);
    nios_system NIOS(.clk_clk(CLOCK_50), .reset_reset(!KEY[0]), .leds_export(LED), .adc_sclk(ADC_SCLK), .adc_cs_n(ADC_CONVST), .adc_dout(ADC_SDO), .adc_din(ADC_SDI));
endmodule
