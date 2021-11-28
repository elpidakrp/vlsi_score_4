module FSM(
	input logic clk,
	input logic rst,
	input logic left,
	input logic right,
	input logic put,
	input logic win_a,
	input logic win_b,
	input logic on_the_same_row,
	input logic on_the_same_column,
	input logic diagonal_l_to_r,
	input logic diagonal_r_to_l,
	input logic[2:0] i_win,
	input logic[2:0] j_win,
	output logic[5:0][6:0][1:0] panel,
	output logic[6:0]           play,
	output logic                player,
	output logic                full_panel,
	output logic                invalid_move
);

enum logic[1:0] {MOVE_PLAY=2'b00, PUT=2'b01} state; 

always_ff @(posedge clk or posedge rst) begin
	if(rst) begin
		play          <= 1;
		player        <= 1'b0;
		full_panel    <= 1'b0;
		invalid_move  <= 1'b0;
		for(int i=0; i<6; i=i+1) begin
			for(int j=0; j<7; j=j+1)begin
				panel[i][j] <= 0;
			end
		end
		state <= MOVE_PLAY;
	end else begin
		if(win_a||win_b)
			state <= PUT;
		case (state)
			MOVE_PLAY: begin
				if(put == 1)begin
					state <= PUT;
				end else if((play==7'b0000001)&&(left==1))begin
					invalid_move <= 1;
					state <= MOVE_PLAY;
				end else if((play==7'b1000000)&&(right==1))begin
					invalid_move <= 1;
					state <= MOVE_PLAY;
				end else begin
					if(left==1)begin
						play <= play >> 1;
						state <= MOVE_PLAY;
						invalid_move <= 0;
					end else if(right==1)begin
						play <= play << 1;
						state <= MOVE_PLAY;
						invalid_move <= 0;
					end else begin
						state <= MOVE_PLAY;
					end
				end
			end
			PUT: begin
				for(int k=0; k<7; k=k+1)begin
					if((panel[0][k]>0)&&play[k]>0)begin
						invalid_move <= 1;
						state <= MOVE_PLAY;
					end else begin
						invalid_move <= 0;
						for(int l=0; l<5; l=l+1)begin
							if ((panel[l][k]==0)&&(play[k]>0)&&(panel[l+1][k])>0)begin
								panel[l][k] <= player+1;
								player      <= ~player;
							end else if ((panel[5][k]==0)&&(play[k]>0))begin
								panel[5][k] <= player+1;
								player      <= ~player;
							end else begin
								state <= MOVE_PLAY;
							end
						end
					end
				end
				if(panel[0][0]>0 && panel[0][1]>0 && panel[0][2]>0 && panel[0][3] && panel[0][4] && panel[0][5]>0 && panel[0][6]>0)begin
					full_panel <= 1;
					//state <= END_GAME;
				end
				if(on_the_same_row)begin
					panel[i_win][j_win]   <= 3;
					panel[i_win][j_win+1] <= 3;
					panel[i_win][j_win+2] <= 3;
					panel[i_win][j_win+3] <= 3;
					//state <= END_GAME;
				end else if(on_the_same_column)begin
					panel[i_win][j_win]   <= 3;
					panel[i_win+1][j_win] <= 3;
					panel[i_win+2][j_win] <= 3;
					panel[i_win+3][j_win] <= 3;
					//state <= END_GAME;
				end else if(diagonal_l_to_r)begin
					panel[i_win][j_win]     <= 3;
					panel[i_win+1][j_win+1] <= 3;
					panel[i_win+2][j_win+2] <= 3;
					panel[i_win+3][j_win+3] <= 3;
					//state <= END_GAME;
				end else if(diagonal_r_to_l)begin
					panel[i_win][j_win]     <= 3;
					panel[i_win+1][j_win-1] <= 3;
					panel[i_win+2][j_win-2] <= 3;
					panel[i_win+3][j_win-3] <= 3;
					//state <= END_GAME;
				end
			end
		endcase
	end
end
endmodule
