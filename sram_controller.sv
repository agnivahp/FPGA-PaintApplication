module SRAM_controller ( input clk, reset,
								 input [15:0]  color,
								 input [9:0] DrawX, DrawY, currX, currY, 
								 input WE, OE, KEY1, VGA_VS, VGA_HS,
								 input logic [15:0] Data_from_CPU, Data_from_SRAM,
								 output logic [15:0] Data_to_CPU, Data_to_SRAM,
								 output logic [19:0] SRAM_ADDR   // SRAM Address 20 Bits
);

logic [17:0]add_reg;
logic [15:0] data_reg, color_reg;
logic we_reg;

assign SRAM_ADDR = add_reg;
assign Data_to_SRAM = we_reg ? 16'hzzzz : data_reg;
assign Data_to_CPU = WE ? color_reg : 16'b0;

always_ff @ (posedge clk)
begin

	if(~KEY1)
	begin
		add_reg <= {DrawX[9:1],DrawY[8:0]};
		we_reg <= 1'b0;
		data_reg <= 16'hFFFF; 
	end
	
	if(WE) //read
	begin
		if(~VGA_HS | ~VGA_VS)
		begin 
			add_reg <= {currX[9:1], currY[8:0]};
			we_reg <= 1'b1;
			color_reg <= Data_from_SRAM;	
		end
		else
		begin
			add_reg <= {DrawX[9:1],DrawY[8:0]};
		   we_reg <= 1'b1;
		end
	end
	else //write
	begin
		if(~VGA_HS | ~VGA_VS)
		begin 
			add_reg <= {currX[9:1], currY[8:0]};
			we_reg <= 1'b0;
			data_reg <= Data_from_CPU;	
		end
		else
		begin
			add_reg <= {DrawX[9:1],DrawY[8:0]};
		   we_reg <= 1'b1;
		end
	end
end

endmodule

