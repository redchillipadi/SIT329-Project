`timescale 1ps/1ps

module adc_tb();
  reg tb_start;
  reg tb_ready;
  reg tb_clk;
  reg tb_sck;
  reg tb_sdi;
  reg tb_sdo;
  reg tb_convst;
  reg[95:0] tb_data;
  integer i;
  
  ADC adc(.clk(tb_clk), .start(tb_start), .sdo(tb_sdo), .ready(tb_ready), .data(tb_data), .convst(tb_convst), .sck(tb_sck), .sdi(tb_sdi));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, adc_tb);
    tb_clk = 0;
    
    tb_start = 1;
    tb_sdo = 1;
    for (i = 0; i<1300; i=i+1) begin
      #12500
      
      $display("%d: clk = %d, start = %d, ready = %d, data = %x, convst = %d, sck = %d, sdi = %d, sdo = %d", i, tb_clk, tb_start, tb_ready, tb_data, tb_convst, tb_sck, tb_sdi, tb_sdo);
     
      // Check CONVST is only 1 when starting measurement for each channel
      if ((i % 160) < 2 && i < 1280 && tb_convst == 0) begin
        $display("assert(convst==1) at tick %d failed", i);
        $finish;
      end
      if (((i % 160) >= 2 || i>=1280) && tb_convst == 1) begin
        $display("assert(convst==0) at tick %d failed", i);
        $finish;
      end
      
      // Check SCK is only 1 during odd ticks between 129 and 141 inclusive (mod 160)
      if ((i % 160) >= 129 && ((i % 160) < 142) && (i < 1280) && (tb_sck != (i % 2))) begin
        $display("assert(sck==%d) at tick %d failed", i % 2, i);
        $finish;
      end
      
      // TODO: Check SDI contains the appropriate bits for reading each channel
      // and 0 at other times
      
      
      // In reality SDO would be changed by the capacitive sensor, but for
      // this testbed just ensure that SDO is 1 so that the value of data can be
      // correctly predicted
      if (sdo != 1) begin
        $display("assert(sdo==1) failed, tests on data will be incorrect");
        $finish;
      end
      
      // TODO: Check Data
      
      if (!tb_ready)
           tb_start = 0;
    end
    $finish;
  end
  
  always #6250 tb_clk = ~tb_clk;
endmodule