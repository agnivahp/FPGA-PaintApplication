module Mouse (input CLOCK_50,
					input RESET,
					input KEY,
					inout PS2_CLK, PS2_DAT,
					output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
					output leftButton, middleButton, rightButton,
					output [9:0] cursorX, cursorY
					);


logic			[7:0]	ps2_data;
logic					ps2_data_available;

logic			[7:0]	byte1, byte2, byte3;
logic			[1:0] counter;

logic [9:0] curX, curY;
logic [7:0] lastb2, lastb3;
logic [8:0] magX, magY;
logic sX, sY;

always @(posedge CLOCK_50)
begin
	if (KEY == 1'b0)
	begin
		byte1 <= 8'h00;
		counter <= 2'b00;
	end
	// new packet available to read
	else if (ps2_data_available == 1'b1)
	begin
		// Byte 3 for X Movement
		if (counter == 0)
		begin
			byte3 <= ps2_data;
			counter <= 2'b01;
		end
		// Byte 2 for Y Movement
		else if (counter == 1)
		begin
			curX <= (sX ? (curX-5>magX ? curX - magX : 5) 
			  : (curX < 635 - magX ? curX+magX : 635));
			byte2 <= ps2_data;
			counter <= 2'b10;
		end
		// Byte 1 for Button presses and sign bits
		else
		begin
			curY <= (sY ? (curY < 475 - magY ? curY+magY : 475)
			  : (curY-5>magY ? curY - magY : 5));
			byte1 <= ps2_data;
			counter <= 2'b00;
		end
	end
end


assign cursorX = curX;
assign cursorY = curY;
assign sX = byte1[4];
assign sY = byte1[5];
assign magX = sX ? {1'b0,~byte3[7:0]}+'b1 : {1'b0,byte3[7:0]};
assign magY = sY ? {1'b0,~byte2[7:0]}+'b1 : {1'b0,byte2[7:0]};
assign leftButton = byte1[0];
assign middleButton = byte1[2];
assign rightButton = byte1[1];

PS2_Controller PS2 (
	.CLOCK_50			(CLOCK_50),
	.reset				(RESET),
	.PS2_CLK				(PS2_CLK),
 	.PS2_DAT				(PS2_DAT),
	.received_data		(ps2_data),
	.received_data_en	(ps2_data_available)
);

endmodule