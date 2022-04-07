// kpdecode.sv - combination module that determines if any button is pressed based on kpr and kpc signals

module kpdecode 
		(input logic [3:0] kpr,	// keypad rows, active-low w/ pull-ups
		input logic [3:0] kpc, 	// keypad column select, active-low
		output logic [3:0] num, // decode7 7-segment display
		output logic kphit,strt); 	// a key is pressed
		
	always_comb begin
		case ({kpr, kpc}) // keypad row, column
			8'b01110111 : begin kphit = 1; num = 4'h1; strt = 0; end // 1
			8'b01111011 : begin kphit = 1; num = 4'h2; strt = 0; end // 2
			8'b01111101 : begin kphit = 1; num = 4'h3; strt = 0; end // 3
			8'b01111110 : begin kphit = 1; num = 4'hA; strt = 0; end // STOP
			8'b10110111 : begin kphit = 1; num = 4'h4; strt = 0; end // 4
			8'b10111011 : begin kphit = 1; num = 4'h5; strt = 0; end // 5
			8'b10111101 : begin kphit = 1; num = 4'h6; strt = 0; end // 6
			8'b10111110 : begin kphit = 1; num = 4'hb; strt = 1; end // GO
			8'b11010111 : begin kphit = 1; num = 4'h7; strt = 0; end // 7
			8'b11011011 : begin kphit = 1; num = 4'h8; strt = 0; end // 8
			8'b11011101 : begin kphit = 1; num = 4'h9; strt = 0; end // 9
			8'b11011110 : begin kphit = 1; num = 4'hC; strt = 0; end // LOCK
			8'b11100111 : begin kphit = 1; num = 4'hE; strt = 0; end // ENT
			8'b11101011 : begin kphit = 1; num = 4'h0; strt = 0; end // 0
			8'b11101101 : begin kphit = 1; num = 4'hF; strt = 0; end // ESC
			8'b11101110 : begin kphit = 1; num = 4'hd; strt = 0; end // PWR
		// default kphit output logic low, decode 7 logic for 0
		default : begin kphit = 0; num = 4'h0; strt = 0; end 
		
		endcase
	end
	
endmodule
