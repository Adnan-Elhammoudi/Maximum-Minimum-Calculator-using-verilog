module min_max_finder_moore (reset, clk, start, ack, xin, yin, zin, max, min, Done, Qi, Qc1, Qc2, Qc3, Qc4, Qc5,Qc6, Qd);

input clk, reset, start, ack;
input [2:0] xin,yin,zin;
output Done;
output [2:0] max, min;
output Qi, Qc1, Qc2, Qc3, Qc4, Qc5, Qc6, Qd;

//state registers
reg [8:0] state;

//Local registers to store input
reg [2:0] xin_reg, yin_reg, zin_reg;

//Local registers to store output
reg [2:0] max, min;

//State Declaration
localparam INITIAL = 8'b0000001,
		   Calculate1 = 8'b00000010,
		   Calculate2 = 8'b00000100,
		   Calculate3 = 8'b00001000,
		   Calculate4 = 8'b00010000,
		   Calculate5 = 8'b00100000,
		   Calculate6 = 8'b01000000,
		   Done_S = 8'b10000000;

assign {Qd,Qc6, Qc5, Qc4, Qc3, Qc2, Qc1, Qi} = state;

always @(posedge clk or posedge reset)
	begin: CU_n_DU
	if (reset)
	begin
	state <= INITIAL;
	xin_reg <= 3'bXXX;
	yin_reg <= 3'bXXX;
	zin_reg <= 3'bXXX;
	max <= 3'bXXX;
	min <= 3'bXXX;
	end
	else
	begin	
	(* full_case, parallel_case *)

	case (state)
	INITIAL: begin 
	if(start)
	state <= Calculate1;
	xin_reg = xin;
	yin_reg = yin;
	zin_reg = zin;
	max = 3'b000;
	min = 3'b000;
	end
	Calculate1: begin
	max = xin_reg;
	min = zin_reg;
	if ((xin_reg > yin_reg) && (yin_reg > zin_reg)) begin
		state <= Done_S;
		
	end
	else
	state <= Calculate2;
	end
	Calculate2: begin
	max = xin_reg;
	min = yin_reg;
	if ((xin_reg > zin_reg) && (zin_reg > yin_reg)) begin
		state <= Done_S;
		
	end
	else
	state <= Calculate3;
	end
	Calculate3: begin
	max = yin_reg;
	min = zin_reg;
	if ((yin_reg > xin_reg) && (xin_reg > zin_reg)) begin
		state <= Done_S;
		
	end
	else
	state <= Calculate4;
	end
	Calculate4: begin
	max = yin_reg;
	min = xin_reg;
	if ((yin_reg > zin_reg) && (zin_reg > xin_reg)) begin
		state <= Done_S;
		
	end
	else
	state <= Calculate5;
	end
	Calculate5: begin
	max = zin_reg;
	min = yin_reg;
	if ((zin_reg > xin_reg) && (xin_reg > yin_reg)) begin
		state <= Done_S;
		
	end
	else begin
	state <= Calculate6;
	end
	end
	Calculate6: begin
	max = zin_reg;
	min = xin_reg;
	state <= Done_S;
	end
	Done_S: begin
	state = ack ? INITIAL : Done_S;
	end
	endcase
end
end
assign Done = (state == Done_S);
endmodule