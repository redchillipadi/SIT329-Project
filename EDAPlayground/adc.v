	`timescale 1ps/1ps
	// From the DE10 Nano User Manual
	// The ADC (LTC2308) has 8 channels and takes inputs from 0 to 4.096 V
	// We could run them from a 5V source as even when my whole body was near the sensor
	// it only reached about 2.5V when testing with the Arduino.
	//
	// If measuring closer to the supply voltage is required we could look into using a 25MOhm and 100 MOhm resistor
	// divider, or provide power to our circuit from a 3.3V source (which would reduce the granularity by about 20%)
	//
	// The maximum rating for the input voltage is Vdd+0.3V, so there is no risk of damaging the FPGA 
	// with our circuit.
	//
	// It provides a 12 bit output, so the LSB represents 1 mV. Accuracy should be within 6 mV.
	// It reads at 500Ksps when clocked at 40 MHz, 
	//
	// Inputs come from ADC_IN0 through ADC_IN7 which are on the 2x5 Header.
	// The first 6 of these are also shared with the Arduino's A0 through A5 header pins.
	//
	// Communication with the ADC is performed using the ADC pins, using
	// ADC_CONVST (Pin_U9) to start conversion
	// ADC_SCK (Pin_V10) for the Serial Data Clock (operates up to 40 MHz)
	// ADC_SDI (Pin_AC4) for serial data input (FPGA to ADC)
	// ADC_SDO (Pin_AD4) for Serial Data Output (ADC to FPGA)
	//
	// A rising edge on ADC_CONVST starts conversion. It should be held high for at least 20 ns.
	// It should return low within 40 ns of starting conversion, or when the conversion ends
	// It needs to be pulled low to enable serial output. Keeping it high causes the ADC to enter NAP or SLEEP modes
	//
	// During conversion a 6 bit word is read from ADC_SDI
	// S/D - Single Ended / Differential
	// O/S - Odd/Sign bit
	// S1 - Address select bit 1
	// S0 - Address select bit 0
	// UNI - Unipolar/Bipolar bit
	// SLP - Sleep mode bit (0 = NAP, 1 = SLEEP)
	//
	// For our set up where all the resistors are connected to common ground, we want S/D to always be 1,
	// and use OS / S1 / S0 in binary to select channels 0, 2, 4, 6, 1, 3, 5, 7 respectively
	// As the voltages are all positive, we need unipolar mode, signified by setting the bit to LOW
	// In unipolar mode the output data is in binary, MSB first.
	// Sleep will not be used by this code as we don't hold the conversion start register high for a long period
	// (more than 1.3 ms)

	// ADC - Read 8 channels from the ADC
	// Params - start - Pull high to begin measurement.
	//                  Measurements cannot be interrupted, so the reading will only begin if ready is high.
	//                  If it is held high permanently, readings will be taken continuously.
	//        - ready - Will be set to high if the data is ready for reading, or low when taking a measurement.
	//        - data - Stores the readings for channels 0-7 as 12 bit MSB first format
	//
	// Takes readings from the 8 ADC channels.
	//
	// Measurement is started by setting start to high. However the measurements will only start on a negative
	// clock edge when start and ready are high. Once they start, ready will be set to low until the reading
	// is complete, and further manipulation of start will be ignored until the measurement is completed.
	//
	// Once the measurement for all channels is complete, data[95:0] will contain the readings for all the channels
	// and ready will be set to high. It is only guaranteed to be safe to read the data on the positive edge of the
	// clock when ready is high.
	module ADC(input wire clk, input wire start, input sdo, output wire ready, output reg[95:0] data, output reg convst, output reg sck, output reg sdi);
      reg[10:0] state = 1279;
      integer s160;
      integer s80;
      
      assign ready = (state == 1279);

      // Initialise the data to null and set the ready bit
	  initial begin
			data = 96'd0;
	   end
      
      always @(posedge clk) begin
        if (state == 1279)
          state = (start) ? 11'd0 : 11'd1279;
        else
          state = state + 11'd1;
        
        s160 = (state % 160);
        s80 = s160 >> 1;
        
        convst = (s80 == 0);
        sck = (s80 >= 64 && s80 < 76 && (s160 & 1));
        
        case (state)
          // Read channel 0: 100000
          128: sdi = 1;
          129: sdi = 1;
          
          // Read channel 1: 110000
          288: sdi = 1;
          289: sdi = 1;
          290: sdi = 1;
          291: sdi = 1;
          
          // Read channel 2: 100100
          448: sdi = 1;
          449: sdi = 1;
          454: sdi = 1;
          455: sdi = 1;
          
          // Read channel 3: 110100
          608: sdi = 1;
          609: sdi = 1;
          610: sdi = 1;
          611: sdi = 1;
          614: sdi = 1;
          615: sdi = 1;
          
          // Read channel 4: 101000
          768: sdi = 1;
          769: sdi = 1;
          772: sdi = 1;
          773: sdi = 1;
          
          // Read channel 5: 111000
          928: sdi = 1;
          929: sdi = 1;
          930: sdi = 1;
          931: sdi = 1;
          932: sdi = 1;
          933: sdi = 1;
          
          // Read channel 6: 101100
          1088: sdi = 1;
          1089: sdi = 1;
          1092: sdi = 1;
          1093: sdi = 1;
          1094: sdi = 1;
          1095: sdi = 1;
          
          // Read channel 7: 111100
          1248: sdi = 1;
          1249: sdi = 1;
          1250: sdi = 1;
          1251: sdi = 1;
          1252: sdi = 1;
          1253: sdi = 1;
          1254: sdi = 1;
          1255: sdi = 1;
          
          default: sdi = 0;
        endcase
        
        case (state)
          129: data[0] = sdo;
          131: data[1] = sdo;
          133: data[2] = sdo;
          135: data[3] = sdo;
          137: data[4] = sdo;
          139: data[5] = sdo;
          141: data[6] = sdo;
          143: data[7] = sdo;
          145: data[8] = sdo;
          147: data[9] = sdo;
          149: data[10] = sdo;
          151: data[11] = sdo;
          
          289: data[12] = sdo;
          291: data[13] = sdo;
          293: data[14] = sdo;
          295: data[15] = sdo;
          297: data[16] = sdo;
          299: data[17] = sdo;
          301: data[18] = sdo;
          303: data[19] = sdo;
          305: data[20] = sdo;
          307: data[21] = sdo;
          309: data[22] = sdo;
          311: data[23] = sdo;
          
          449: data[24] = sdo;
          451: data[25] = sdo;
          453: data[26] = sdo;
          455: data[27] = sdo;
          457: data[28] = sdo;
          459: data[29] = sdo;
          461: data[30] = sdo;
          463: data[31] = sdo;
          465: data[32] = sdo;
          467: data[33] = sdo;
          469: data[34] = sdo;
          471: data[35] = sdo;
          
          609: data[36] = sdo;
          611: data[37] = sdo;
          613: data[38] = sdo;
          615: data[39] = sdo;
          617: data[40] = sdo;
          619: data[41] = sdo;
          621: data[42] = sdo;
          623: data[43] = sdo;
          625: data[44] = sdo;
          627: data[45] = sdo;
          629: data[46] = sdo;
          631: data[47] = sdo;
          
          769: data[48] = sdo;
          771: data[49] = sdo;
          773: data[50] = sdo;
          775: data[51] = sdo;
          777: data[52] = sdo;
          779: data[53] = sdo;
          781: data[54] = sdo;
          783: data[55] = sdo;
          785: data[56] = sdo;
          787: data[57] = sdo;
          789: data[58] = sdo;
          791: data[59] = sdo;
          
          929: data[60] = sdo;
          931: data[61] = sdo;
          933: data[62] = sdo;
          935: data[63] = sdo;
          937: data[64] = sdo;
          939: data[65] = sdo;
          941: data[66] = sdo;
          943: data[67] = sdo;
          945: data[68] = sdo;
          947: data[69] = sdo;
          949: data[70] = sdo;
          951: data[71] = sdo;
          
          1089: data[72] = sdo;
          1091: data[73] = sdo;
          1093: data[74] = sdo;
          1095: data[75] = sdo;
          1097: data[76] = sdo;
          1099: data[77] = sdo;
          1101: data[78] = sdo;
          1103: data[79] = sdo;
          1105: data[80] = sdo;
          1107: data[81] = sdo;
          1109: data[82] = sdo;
          1111: data[83] = sdo;
          
          1249: data[84] = sdo;
          1251: data[85] = sdo;
          1253: data[86] = sdo;
          1255: data[87] = sdo;
          1257: data[88] = sdo;
          1259: data[89] = sdo;
          1261: data[90] = sdo;
          1263: data[91] = sdo;
          1265: data[92] = sdo;
          1267: data[93] = sdo;
          1269: data[94] = sdo;
          1271: data[95] = sdo;          
        endcase
        
        //$display("State: %d, S160: %d, S80: %d, Ready: %d, CONVST: %d, SCK: %d, SDI: %d, SDO: %d, Data: %x", state, s160, s80, ready, convst, sck, sdi, sdo, data);
      end
	endmodule