module score4 (
	input  logic clk,
	input  logic rst,
	
//----------------------------------------------------------------------------------------------------------------------------
	/*
	input  logic kClk,
	input  logic kData,
	*/
	
	input  logic left,
	input  logic right,
	input  logic put,
//----------------------------------------------------------------------------------------------------------------------------
	
	output logic player,
	output logic invalid_move,
	output logic win_a,
	output logic win_b,
	output logic full_panel,

	output logic hsync,
	output logic vsync,
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue	
);

// YOUR IMPLEMENTATION HERE

logic edge_reg_left;
logic edge_reg_right;
logic edge_reg_put;
logic rising_edge_left;
logic rising_edge_right;
logic rising_edge_put;

always_ff @(posedge clk, posedge rst) begin
 if (rst) begin
 edge_reg_left  <= 1'b0;
 edge_reg_right <= 1'b0;
 edge_reg_put   <= 1'b0;
 end else begin
 edge_reg_left  <= left;
 edge_reg_right <= right;
 edge_reg_put   <= put; 
 end
end
assign rising_edge_left = (~edge_reg_left) & left;
assign rising_edge_right = (~edge_reg_right) & right;
assign rising_edge_put = (~edge_reg_put) & put;


//----------------------------------------------------------------------------------------------------------------------------
/*
logic [10:0] keyboardOut;
logic        falling_edge_detection;
logic        rising_edge_detection;
logic        synced_keyboard_data;
*/
//----------------------------------------------------------------------------------------------------------------------------

//______________________________________________________KEYBOARD______________________________________________________________
//----------------------------------------------------------------------------------------------------------------------------
/*
keyboard key1(
.clk   (kClk),
.kData (kData),
.out   (keyboardOut) //[10:0]
);
*/
//----------------------------------------------------------------------------------------------------------------------------

//______________________________________________________SYNCRONIZER___________________________________________________________
//----------------------------------------------------------------------------------------------------------------------------
/*
syncronizer sync1(
.kClock                 (kClk),
.kData                  (keyboardOut),
.falling_edge_detection (falling_edge_detection),
.rising_edge_detection  (rising_edge_detection),
.dataOut                (synced_keyboard_data)
);
*/
//----------------------------------------------------------------------------------------------------------------------------


//_________________________________________________________THE_GAME___________________________________________________________

logic[5:0][6:0][1:0] panel;
logic[6:0]           play;
logic                on_the_same_row;
logic                on_the_same_column;
logic                diagonal_l_to_r;
logic                diagonal_r_to_l;
logic[2:0]           i_win;
logic[2:0]           j_win;
logic[5:0]           row_out;
logic[6:0]           col_out;
logic[3:0]           node_disp;

rom romm(.clk (clk),
							.node_disp (node_disp),
							.row_out (row_out),
							.col_out (col_out),
							.column (column),
							.red (red),
							.green (green),
							.blue (blue)
	);
	
FSM fsm(.clk (clk),
			.rst (rst),
			.left (rising_edge_left),
			.right (rising_edge_right),
			.put (rising_edge_put),
			.win_a (win_a),
			.win_b (win_b),
			.on_the_same_row (on_the_same_row),
			.on_the_same_column (on_the_same_column),
			.diagonal_l_to_r (diagonal_l_to_r),
			.diagonal_r_to_l (diagonal_r_to_l),
			.i_win (i_win),
			.j_win (j_win),
			.panel (panel),
			.play (play),
			.player (player),
			.full_panel (full_panel),
			.invalid_move (invalid_move));

VGA_DISPLAY vga_disp(.clk (clk),
							.rst (rst),
							.panel (panel),
							.play (play),
							.player (player),
							.win_a (win_a),
							.win_b (win_b),
							.hsync (hsync),
							.vsync (vsync),
							.row_out (row_out),
							.col_out (col_out),
							.node_disp (node_disp),
							.column (column));

Check_for_winner winner_check(.rst (rst),
										.panel (panel),
										.win_a (win_a),
										.win_b (win_b),
										.on_the_same_row (on_the_same_row),
										.on_the_same_column (on_the_same_column),
										.diagonal_l_to_r (diagonal_l_to_r),
										.diagonal_r_to_l (diagonal_r_to_l),
										.i_win (i_win),
										.j_win (j_win));


//State state();

//VGA_DISPLAY vga_display(clk,rst,panel,play,player,win_a,win_b,hsync,vsync,red,green,blue);

//__________________________________________________just__the__colours________________________________________________________
/*
always_comb begin
	//when left shift(12) is pressed make everything white
	if((synced_keyboard_data == 11'b00100100011))begin
		red   = 4'b1111;
		green = 4'b1111;
		blue  = 4'b1111;
	end
	else begin
		//panw aristera kokkinh
		if ((row <= 239 && column <= 319) || (row <= 479 && row >= 239 && column >= 319 && column <= 639))
			red = 4'b1111;
		else
			red = 4'b0000;
		//panw de3ia prassinh
		if ((row <= 239 && column >= 319 && column <= 639) || (row <= 479 && row >= 239 && column >= 319 && column <= 639))
			green = 4'b1111;
		else
			green = 4'b0000;
		//katw aristera mple
		if ((row <= 479 && row >= 239 && column <= 319 && column <= 639) || (row <= 479 && row >= 239 && column >= 319 && column <= 639))
			blue = 4'b1111;
		else
			blue = 4'b0000;
		//katw de3ia asprh bl or
	end
end
*/	


endmodule
