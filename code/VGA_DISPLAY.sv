module VGA_DISPLAY(
	input  logic clk,
	input  logic rst,
	input  logic[5:0][6:0][1:0] panel,
	input  logic[6:0] play,
	input  logic player,
	input  logic win_a,
	input  logic win_b,

	output logic hsync,
	output logic vsync,
	output logic[5:0] row_out,
	output logic[6:0] col_out,
	output logic[3:0] node_disp,
	output logic[9:0] column
);

logic [9:0]  row;
logic        clk2;

//______________________________________________________2nd CLK_______________________________________________________________
//----------------------------------------------------------------------------------------------------------------------------
always_ff @(posedge clk, posedge rst) begin
  if(rst) clk2 <= 0;
  else     clk2 <= ~clk2;
end
//----------------------------------------------------------------------------------------------------------------------------

//________________________________________________CHANGE_ROW--------COLUMN____________________________________________________

always_ff @ (posedge clk or posedge rst) begin
	if (rst) begin 
	  column <= 0;
	  row    <= 0;
	end
	else begin
//----------------------------------------------------------------------------------------------------------------------------
	 if (clk2) begin //instead of clk2 I have the falling edge of the keyboard clk (if keyboard is used)
//----------------------------------------------------------------------------------------------------------------------------
	 //480+11+2+31=524
	  if(row >= 523)
		row  <= 0;
	  //640+16+96+48=800
	  else if(column >= 799) begin
		column <= 0;
		row    <= row + 1;
	  end
	  else
		column <= column + 1;
   end
	end
	
end	

//____________________________________________________HSYNC-----VSYNC_________________________________________________________		

always_comb begin
		//640+16+96+48=800
		if (column >= 656 && column <= 751)
			hsync = 1'b0;
		else
			hsync = 1'b1;
		//480+11+2+31=524
		if (row >= 491 && row <= 492)
			vsync = 1'b0;
		else
			vsync = 1'b1;
end

//_______________________________________________________GAME_DISPLAY_________________________________________________________	

always_comb begin
		for(int k=0; k<7; k=k+1)begin
			for(int l=0; l<6; l=l+1)begin
				if(column>(k*90) && column<((k+1)*90) && row<((l+1)*70) && row>(l*70))begin
					case(panel[l][k])
						2'b00: begin
								col_out = column-k*90;
								row_out = row-l*70;
								node_disp = 3'b000;
								//red   = 4'b0000;
								//green = 4'b0000;
								//blue  = 4'b1111;
								end
						2'b01: begin
								col_out = column-k*90;
								row_out = row-l*70;
								node_disp = 3'b001;
								//red   = 4'b1111;
								//green = 4'b0000;
								//blue  = 4'b0000;
								end
						2'b10: begin
								col_out = column-k*90;
								row_out = row-l*70;
								node_disp = 3'b010;
								//red   = 4'b1111;
								//green = 4'b1111;
								//blue  = 4'b0000;
								end
						2'b11: begin
								col_out = column-k*90;
								row_out = row-l*70;
								node_disp = 3'b011;
								//red   = 4'b0000;
								//green = 4'b1111;
								//blue  = 4'b0000;
								end
					endcase
				end
			end
			if((column>(k*90+4))&&(column<((k+1)*90+6))&&(row>420)&&(row<481)) begin
				if((play[k]==1)&&(player==0)) begin 
					col_out = column-k*90;
					row_out = row-420;
					node_disp = 3'b101;
					//red   = 4'b1111;
					//green = 4'b0000;
					//blue  = 4'b0000;
				end
				else if((play[k]==1)&&(player==1)) begin 
					col_out = column-k*90;
					row_out = row-420;
					node_disp = 3'b110;
					//red   = 4'b1111;
					//green = 4'b1111;
					//blue = 4'b0000;
				end
				else if((play[k]==1)&& win_a) begin 
					col_out = column-k*90;
					row_out = row-420;
					node_disp = 3'b101;
					//red   = 4'b1111;
					//green = 4'b0000;
					//blue  = 4'b0000;
				end
				else if((play[k]==1)&& win_b) begin
					col_out = column-k*90;
					row_out = row-420;
					node_disp = 3'b110;
					//red   = 4'b1111;
					//green = 4'b1111;
					//blue  = 4'b0000;
				end
				else begin
					col_out = column-k*90;
					row_out = row-420;
					node_disp = 3'b100;
					//red   = 4'b0000;
					//green = 4'b0000;
					//blue  = 4'b1111;
				end
			end
		end
end
endmodule
