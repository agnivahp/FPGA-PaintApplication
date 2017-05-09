//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,     //SDRAM Clock
                    
				// SRAM 
    			 output logic [19:0] SRAM_ADDR,    // SRAM Address 20 Bits
             inout  wire  [15:0] SRAM_DQ,      // SRAM Data 16 Bits
             output logic 			SRAM_CE_N,    // SRAM Chip enable
											SRAM_OE_N,    // SRAM Output enable
                                 SRAM_WE_N,    // SRAM Write Enable
											SRAM_UB_N,	  // Upper bit mask
											SRAM_LB_N,     // Lower bit mask
											
				 inout wire          PS2_DAT,
											PS2_CLK
             		  
						  );
    
    logic Reset_h, Clk;
    logic [9:0] px, py , currX, currY;
	 logic [7:0] button;
	 logic [15:0] color_from_NIOS, color_to_NIOS;
	 logic command;
	 logic VS, HS;
	 logic [2:0] press;
	 logic [9:0] Xval, Yval;
	 
	 logic start;
	 logic [10:0] x0, y0, x1, y1;
	 logic plot;
	 logic [10:0] x, y;
	 logic done;
	 
	 assign VGA_VS = VS;
	 assign VGA_HS = HS;
    
    assign Clk = CLOCK_50;
    assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w,hpi_cs;
    
	 logic[9:0] DrawX, DrawY, BallX, BallY, BallS;
	 logic [7:0] mVGA_R, mVGA_G, mVGA_B;
	 
	 logic [15:0] Data_from_SRAM, Data_to_SRAM;
	 
	 assign mVGA_R = ( ~SRAM_OE_N) ? {(DrawX[0]? Data_from_SRAM[7:5]: Data_from_SRAM[15:13]) , 5'b0}: 8'b0;
    assign mVGA_G = ( ~SRAM_OE_N) ? {(DrawX[0]? Data_from_SRAM[4:2]: Data_from_SRAM[12:10]), 5'b0}: 8'b0;
	 assign mVGA_B = ( ~SRAM_OE_N) ? {(DrawX[0]? Data_from_SRAM[1:0]: Data_from_SRAM[9:8]), 6'b0}: 8'b0;
	 
	 assign SRAM_OE_N = command;
	 assign MIO_EN = ~SRAM_OE_N;
	 assign SRAM_WE_N = ~command;
	 assign SRAM_CE_N = 1'b0;
	 assign SRAM_UB_N = 1'b0;
	 assign SRAM_LB_N = 1'b0;
	 
	 assign SRAM_ADDR = (SRAM_WE_N & VS & HS) ? {DrawX[9:1],DrawY[8:0]}: {currX[9:1],currY[8:0]};
	 // Our SRAM and I/O controller
Mem2IO memory_subsystem(
	.*, .CE(SRAM_CE_N),.OE(SRAM_OE_N),.WE(SRAM_WE_N),.UB(SRAM_UB_N),.LB(SRAM_LB_N), .VS(VGA_VS), .HS(VGA_HS), .Reset(Reset_h), .ADDR(ADDR),
	.Data_from_CPU(color_from_NIOS), .Data_to_CPU(color_to_NIOS),
	.Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
	.Clk(VGA_CLK), .tristate_output_enable(~SRAM_WE_N), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(SRAM_DQ)
);
	 
//	 SRAM_controller sram (
//									.clk(VGA_CLK),
//									.reset(Reset_h),
//									.KEY1(KEY[1]),
//									.DrawX(DrawX),
//									.DrawY(DrawY),
//									.currX(currX),
//									.currY(currY),
//									.WE(SRAM_WE_N),
//									.OE(SRAM_OE_N),
//									.VGA_VS(VS),
//									.VGA_HS(HS),
//									.Data_from_CPU(color_from_NIOS),
//									.Data_from_SRAM(Data_from_SRAM),
//									.Data_to_CPU(color_to_NIOS),
//									.Data_to_SRAM(Data_to_SRAM),
//									.SRAM_ADDR(SRAM_ADDR)
//	 
//	 );

	 // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );

	 Mouse cursor_0 (.CLOCK_50(Clk), .RESET(Reset_h), .KEY(KEY[2]), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), 
							.cursorX(px), .cursorY(py), 
							.leftButton(button), .middleButton(press[1]), .rightButton(press[0]));
							
		bresenham line(.*, .clk(VGA_CLK), .reset(Reset_h));
							
     //The connections for nios_system might be named different depending on how you set up Qsys
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(KEY[0]),   
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .px_export(px),
									  .py_export(py),
							        .button_export(button),		
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
									  .color_from_export(color_from_NIOS),
									  .color_to_export(color_to_NIOS),
									  .command_export(command),
									  .currx_export(currX),
									  .curry_export(currY)			 
    );
    
    //Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk),
														 .Reset(Reset_h),
														 .VGA_HS(HS),
														 .VGA_VS(VS),
														 .VGA_CLK(VGA_CLK),
														 .VGA_BLANK_N(VGA_BLANK_N),
														 .VGA_SYNC_N(VGA_SYNC_N),
														 .DrawX(DrawX),
														 .DrawY(DrawY));
   
    ball ball_instance(.Reset(Reset_h),
							  .frame_clk(VGA_CLK),
							  .px(px),
							  .py(py),
							  .button(button),
							  .BallX(BallX),
							  .BallY(BallY),
							  .BallS(BallS));
    
    color_mapper color_instance(.Clk(Clk),
										  .Reset(Reset_h),
										  .BallX(px),
										  .BallY(py),
										  .BallS(10'd2),
										  .DrawX(DrawX),
										  .DrawY(DrawY),
										  .iR(mVGA_R),
										  .iG(mVGA_G),
										  .iB(mVGA_B),
										  .VSync(VGA_VS),
										  .HSync(VGA_HS),
										  .VGA_R(VGA_R),
										  .VGA_G(VGA_G),
										  .VGA_B(VGA_B));
    
    HexDriver hex_inst_0(Xval[3:0], HEX0);
    HexDriver hex_inst_1(Xval[7:4], HEX1);
	 HexDriver hex_inst_2(Yval[3:0], HEX2);
	 HexDriver hex_inst_3(Yval[7:4], HEX3);
	 HexDriver hex_inst_4({1'b1,press[2:0]}, HEX4);
	 HexDriver hex_inst_5(color_to_NIOS[7:4], HEX5);
    HexDriver hex_inst_6(color_to_NIOS[11:8], HEX6);
	 HexDriver hex_inst_7(color_to_NIOS[15:12], HEX7);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
