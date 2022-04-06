// decodeScore.sv

module decodeScore (input logic [1:0] digit,
						input logic [31:0] score,
						output logic [3:0] displayNum);
						logic [3:0] three = 4'd0;
						logic [3:0] two = 4'd0;
						logic [3:0] one = 4'd0;
						logic [19:0] level;
						integer i;
						
		always@(digit) begin
			level[19:8] = 0;
			level[7:0] = score[7:0];
			
			for (i=0; i<8; i+=1) begin
				if (level[11:8] >= 5)
					level[11:8] = level[11:8]+3;
				
				if (level[15:12] >= 5)
					level[15:12] = level[15:12]+3;
				
				if (level[19:16] >= 5)
					level[19:16] = level[19:16]+3;
					
				level = level << 1;
			end
			
			three = level[19:16];
			two = level[15:12];
			one = level[11:8];
		
		
		unique case (digit)
			0: displayNum = one;
			1: displayNum = two;
			default displayNum = 4'd0;
		endcase
		
		end
		
endmodule