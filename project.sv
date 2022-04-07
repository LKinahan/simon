// project.sv - top-level module for ELEX 7660 project
// this module is designed to interface with the De0-Nano-Soc
// this module works in conjunction with decode7, kpdecode, colseq, and decodeSPKR

parameter SEED_BITS = 16;

parameter NUM_LAMPS = 4;
parameter NOTE_C = 2616;
parameter NOTE_D = 2937;
parameter NOTE_E = 3296;
parameter NOTE_F = 3492;
parameter NOTE_G = 3920;

module project ( output logic [3:0] kpc,  // column select, active-low
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
              input logic  [3:0] kpr,  // rows, active-low w/ pull-ups
              output logic [7:0] leds, // active-low LED segments 
              output logic [3:0] ct,   // " digit enables
				  output logic spkr,
              input logic  reset_n, FPGA_CLK1_50 ) ;

   logic clk ;                  		// 2kHz clock for keypad scanning
   logic kphit ;                  	// a key is pressed
	logic strt, lfsrclk, lcount, loser = 0;
   logic [3:0] num ;          	   // value of pressed key
	logic [31:0] desiredFrequency; 	// desired note frequency (e.g C = 261Hz, A = 440Hz etc.)
	logic [31:0] score, finishcount = 0;
	logic [1:0] digit;
	
	logic [3:0] displayNum;
	logic rst = 0;
	logic [31:0]count = 0; 
	reg [(SEED_BITS-1):0]out = 0;
	reg [(SEED_BITS-1):0]seed = 8'b0101_0101;
	
	enum {start, init, display, preparepoll, poll, polltodisplay, finish} state = start, statenext;
	
   // assign ct = { {3{1'b0}}, kphit } ;
   pll pll0 ( .inclk0(FPGA_CLK1_50), .c0(clk) ) ;
	
   
   // modules
	colseq colseq_0 (.*);
	kpdecode kpdecode_0 (.*);
	decode7 decode7_0 (.*);
	decode2 decode2_0(.*);
	decodeSPKR decodeSPKR_0 (.*);
	MusicBox MusicBox_0 (.*);
	StartSM StartSM_0 (.out, .clk(lfsrclk), .rst, .seed);
	decodeScore decodeScore_0 (.*) ;
	
	
	// **** SIMON SAYS ****
always_ff @(posedge clk) 
	digit <= digit + 1'b1;
		
always_ff @(posedge FPGA_CLK1_50) begin
		
	rst <= 0;
	lfsrclk <= 0;
	state <= statenext;

	case (state)
		
		start: begin
			seed <= seed + 1;
			count <= count + 1;
			if (count > 50*1000*1000 )
				count <= 0;
		end // end start:
		
		init: begin
			rst <= 1;
			lfsrclk <= 1;
			count = 0;
		end // end begin
	
		display: begin
			count <= count + 1;
			if(count < 10 * 1000 * 1000) begin
				case(out % (NUM_LAMPS))
					0: num = 'h1;
					1: num = 'h2;
					2: num = 'h3;
					3: num = 'h4;
				endcase // endcase
			end // end if
			if (count > 35 * 1000 * 1000 ) begin
				lfsrclk <= 1;
				count <= 0;
				lcount <= lcount + 1;
			end
		end // end display
	
	preparepoll: begin
		rst <= 1; // reset the LFSR
	end
	
	poll: begin
		if (lcount > 0) begin
			lcount <= lcount -1;
			case(out % (NUM_LAMPS))
				0: loser <= 1;
				1: loser <= 1;
				2: loser <= 1;
				3: loser <= 1;
			endcase // out % NUMLAMPS
			lfsrclk <= 1;
		end // end if(lcount > 0) %% PBUP
	end // end poll
	
	polltodisplay: begin
	score <= score + 1; // next level!
	rst <= 1; // reseed lfsr
	count <= 0; // reset timer
	end // endpolltodisplay

	finish: begin
		score <= 0;
		loser <= 0;
		end
		
	endcase
	
end
	
	always_comb begin

		if (state == start)
			statenext = init;
		else if (state == init)
			statenext = display;
		else if ((state == display) && (lcount > (score)))
			statenext = preparepoll;
		else if (state == preparepoll)
			statenext = poll;
		else if ((state == poll) && (loser || (lcount < 1)))
			statenext = loser ? finish : polltodisplay;
		else if (state == polltodisplay)
			statenext = display;
		else if ((state == finish) && (finishcount < 50 * 1000 * 1000 * 10))
			statenext = start;
		else
			statenext = state;
end
   
endmodule

// megafunction wizard: %ALTPLL%
// ...
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
// ...

module pll ( inclk0, c0);

        input     inclk0;
        output    c0;

        wire [0:0] sub_wire2 = 1'h0;
        wire [4:0] sub_wire3;
        wire  sub_wire0 = inclk0;
        wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
        wire [0:0] sub_wire4 = sub_wire3[0:0];
        wire  c0 = sub_wire4;

        altpll altpll_component ( .inclk (sub_wire1), .clk
          (sub_wire3), .activeclock (), .areset (1'b0), .clkbad
          (), .clkena ({6{1'b1}}), .clkloss (), .clkswitch
          (1'b0), .configupdate (1'b0), .enable0 (), .enable1 (),
          .extclk (), .extclkena ({4{1'b1}}), .fbin (1'b1),
          .fbmimicbidir (), .fbout (), .fref (), .icdrclk (),
          .locked (), .pfdena (1'b1), .phasecounterselect
          ({4{1'b1}}), .phasedone (), .phasestep (1'b1),
          .phaseupdown (1'b1), .pllena (1'b1), .scanaclr (1'b0),
          .scanclk (1'b0), .scanclkena (1'b1), .scandata (1'b0),
          .scandataout (), .scandone (), .scanread (1'b0),
          .scanwrite (1'b0), .sclkout0 (), .sclkout1 (),
          .vcooverrange (), .vcounderrange ());

        defparam
                altpll_component.bandwidth_type = "AUTO",
                altpll_component.clk0_divide_by = 25000,
                altpll_component.clk0_duty_cycle = 50,
                altpll_component.clk0_multiply_by = 1,
                altpll_component.clk0_phase_shift = "0",
                altpll_component.compensate_clock = "CLK0",
                altpll_component.inclk0_input_frequency = 20000,
                altpll_component.intended_device_family = "Cyclone IV E",
                altpll_component.lpm_hint = "CBX_MODULE_PREFIX=lab1clk",
                altpll_component.lpm_type = "altpll",
                altpll_component.operation_mode = "NORMAL",
                altpll_component.pll_type = "AUTO",
                altpll_component.port_activeclock = "PORT_UNUSED",
                altpll_component.port_areset = "PORT_UNUSED",
                altpll_component.port_clkbad0 = "PORT_UNUSED",
                altpll_component.port_clkbad1 = "PORT_UNUSED",
                altpll_component.port_clkloss = "PORT_UNUSED",
                altpll_component.port_clkswitch = "PORT_UNUSED",
                altpll_component.port_configupdate = "PORT_UNUSED",
                altpll_component.port_fbin = "PORT_UNUSED",
                altpll_component.port_inclk0 = "PORT_USED",
                altpll_component.port_inclk1 = "PORT_UNUSED",
                altpll_component.port_locked = "PORT_UNUSED",
                altpll_component.port_pfdena = "PORT_UNUSED",
                altpll_component.port_phasecounterselect = "PORT_UNUSED",
                altpll_component.port_phasedone = "PORT_UNUSED",
                altpll_component.port_phasestep = "PORT_UNUSED",
                altpll_component.port_phaseupdown = "PORT_UNUSED",
                altpll_component.port_pllena = "PORT_UNUSED",
                altpll_component.port_scanaclr = "PORT_UNUSED",
                altpll_component.port_scanclk = "PORT_UNUSED",
                altpll_component.port_scanclkena = "PORT_UNUSED",
                altpll_component.port_scandata = "PORT_UNUSED",
                altpll_component.port_scandataout = "PORT_UNUSED",
                altpll_component.port_scandone = "PORT_UNUSED",
                altpll_component.port_scanread = "PORT_UNUSED",
                altpll_component.port_scanwrite = "PORT_UNUSED",
                altpll_component.port_clk0 = "PORT_USED",
                altpll_component.port_clk1 = "PORT_UNUSED",
                altpll_component.port_clk2 = "PORT_UNUSED",
                altpll_component.port_clk3 = "PORT_UNUSED",
                altpll_component.port_clk4 = "PORT_UNUSED",
                altpll_component.port_clk5 = "PORT_UNUSED",
                altpll_component.port_clkena0 = "PORT_UNUSED",
                altpll_component.port_clkena1 = "PORT_UNUSED",
                altpll_component.port_clkena2 = "PORT_UNUSED",
                altpll_component.port_clkena3 = "PORT_UNUSED",
                altpll_component.port_clkena4 = "PORT_UNUSED",
                altpll_component.port_clkena5 = "PORT_UNUSED",
                altpll_component.port_extclk0 = "PORT_UNUSED",
                altpll_component.port_extclk1 = "PORT_UNUSED",
                altpll_component.port_extclk2 = "PORT_UNUSED",
                altpll_component.port_extclk3 = "PORT_UNUSED",
                altpll_component.width_clock = 5;


endmodule
