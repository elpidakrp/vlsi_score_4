module Check_for_winner(
input  logic rst,
input  logic [5:0][6:0][1:0] panel,
output logic win_a,
output logic win_b,
output logic on_the_same_row,
output logic on_the_same_column,
output logic diagonal_l_to_r,
output logic diagonal_r_to_l,
output logic[2:0] i_win,
output logic[2:0] j_win
);

always_comb begin
	if(rst) begin
		win_a = 0;
		win_b = 0;
	end
	for(int i=0; i<6; i=i+1) begin
		for(int j=0; j<4; j=j+1) begin
			if((panel[i][j]==panel[i][j+1])&&(panel[i][j]==panel[i][j+2])&&(panel[i][j]==panel[i][j+3])&&(panel[i][j]>0)) begin
				if(panel[i][j] == 1)
					win_a <= 1;
				else 
					win_b <= 1;
				i_win <= i;
				j_win <= j;
				on_the_same_row <= 1;
			end
		end
	end
	//4 on the same column
	for(int j=0; j<7; j=j+1) begin
		for(int i=0; i<3; i=i+1) begin
			if((panel[i][j]==panel[i+1][j])&&(panel[i][j]==panel[i+2][j])&&(panel[i][j]==panel[i+3][j])&&(panel[i][j]>0)) begin
				if(panel[i][j] == 1)
					win_a <= 1;
				else 
					win_b <= 1;
				i_win <= i;
				j_win <= j;
				on_the_same_column <= 1;
			end
		end
	end
	//diagonal_l_to_r
	for(int i=0; i<3; i=i+1) begin
		for(int j=0; j<4; j=j+1) begin
			if((panel[i][j]==panel[i+1][j+1])&&(panel[i][j]==panel[i+2][j+2])&&(panel[i][j]==panel[i+3][j+3])&&(panel[i][j]>0)) begin
				if(panel[i][j] == 1)
					win_a <= 1;
				else 
					win_b <= 1;
				i_win <= i;
				j_win <= j;
				diagonal_l_to_r <= 1;
			end
		end
	end
	//diagonal_r_to_l
	for(int i=0; i<3; i=i+1) begin
		for(int j=3; j<7; j=j+1) begin
			if((panel[i][j]==panel[i+1][j-1])&&(panel[i][j]==panel[i+2][j-2])&&(panel[i][j]==panel[i+3][j-3])&&(panel[i][j]>0)) begin
				if(panel[i][j] == 1)
					win_a <= 1;
				else 
					win_b <= 1;
				i_win <= i;
				j_win <= j;
				$display(i_win);
				diagonal_r_to_l <= 1;
			end
		end
	end
end
endmodule
