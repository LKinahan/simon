// decodeSPKR.sv - converts # bit number into the signals necessary to output desired tone on speaker of DEO-Nano-SoC
// ELEX 7660 Group Project

module decodeSPKR (input logic [3:0] num, 
		 output logic [31:0] desiredFrequency );

  always_comb begin
		case(num)	//cases for the input 'num'
		// button 1	
		'h1 : desiredFrequency = 'd262; // C=261.63Hz
		// button 2
		'h2 : desiredFrequency = 'd294; // D=293.66Hz
		// button 3
		'h3 : desiredFrequency = 'd330; // E=329.63Hz
		// button 4
		'h4 : desiredFrequency = 'd350; // F=349.23Hz
		// button 5
		'h5 : desiredFrequency = 'd392; // G=392.00Hz
		// button 6
		'h6 : desiredFrequency = 'd440; // A=440.00Hz
		// button 7
		'h7 : desiredFrequency = 'd494; // B=493.88Hz
		// button 8
		'h8 : desiredFrequency = 'd523; // C=523.25Hz
		// button 9
		'h9 : desiredFrequency = 'd587; // D=587.33Hz	

		// don't care about the rest
		default: desiredFrequency = 'd0;		
		endcase			
	end
endmodule