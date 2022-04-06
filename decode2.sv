// decode2.sv

module decode2 (input logic [1:0] digit, 
					output logic [3:0] ct);
					
		always_comb 
			case (digit)
				0: ct = 'b0001;
				1: ct = 'b0010;
				2: ct = 'b0100;
				3: ct = 'b1000;
			endcase

endmodule
					