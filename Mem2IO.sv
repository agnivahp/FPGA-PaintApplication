//-------------------------------------------------------------------------
//      Mem2IO.vhd                                                       --
//      Stephen Kempf                                                    --
//                                                                       --
//      Revised 03-15-2006                                               --
//              03-22-2007                                               --
//              07-26-2013                                               --
//              03-04-2014                                               --
//              02-13-2017                                               --
//                                                                       --
//      For use with ECE 385 Experiment 6                                --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  Mem2IO ( 	input logic Clk, Reset,
					input logic [19:0]  ADDR, 
					input logic CE, UB, LB, OE, WE, VS, HS,
					input logic [15:0] Data_from_CPU, Data_from_SRAM,
					output logic [15:0] Data_to_CPU, Data_to_SRAM
					 );

	logic [15:0] hex_data;
   
	// Load data from switches when address is xFFFF, and from SRAM otherwise.
	always_comb
    begin 
//		  if(~HS | ~VS)
		  
				Data_to_CPU = 16'd0;
				if (WE && ~OE) 
					Data_to_CPU = Data_from_SRAM;
		  
   end
    // Pass data from CPU to SRAM
//	 if(~HS | ~VS)
	assign Data_to_SRAM = Data_from_CPU;
//	 else
//			Data_to_SRAM = 16'd0;
//	 end

	
       
	

endmodule
