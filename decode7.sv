// decode7.sv - converts any 4 bit number into the signals necessary to control the 7-segment display

module decode7 (input logic [3:0] num,
						output logic [7:0] leds);
						 					
		always_comb
			begin
				//if(kphit)
				
					case(num)	//cases for the input 'num'
						 0 : leds = 8'b10111111;	// 0 = ----
						 1 : leds = 8'b11111001;	// 1
						 2 : leds = 8'b10100100;	// 2
						 3 : leds = 8'b10110000;	// 3
						 4 : leds = 8'b10011001;	// 4
						 5 : leds = 8'b10010010;	// 5
						 6 : leds = 8'b10000010;	// 6
						 7 : leds = 8'b11111000;	// 7
						 8 : leds = 8'b10000000;	// 8
						 9 : leds = 8'b10010000;	// 9
						 10 : leds = 8'b10111111;	// STOP = end
						 11 : leds = 8'b10111111;	// GO = play
						 12 : leds = 8'b10111111;	// LOCK = ----
						 13 : leds = 8'b10111111;	// PWR = ----
						 14 : leds = 8'b10111111;	// ENT = ----
						 15 : leds = 8'b10111111;	// ESC = ----
						 default: leds = 8'b11111111; // off
					endcase			
			end
			
endmodule