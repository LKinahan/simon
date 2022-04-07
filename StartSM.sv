// StartSM.sv
// state machine to start game

module StartSM (output reg [(SEED_BITS-1):0]out, input clk, input rst, input [(SEED_BITS - 1):0]seed);

	logic feedback;
	
	always @(posedge clk, posedge rst) begin
	if (rst)
	out = seed;
	else
	out = {out[(SEED_BITS-2):0],feedback};
	end
	
endmodule
