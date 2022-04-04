
`timescale 1 ns / 100 ps
module tb_min_max_finder;

reg [2:0] xin,yin,zin;
reg clk, reset, start, ack;

wire Done_tb_moore;
wire [2:0] max_moore,min_moore;
wire Qi_moore, Qc1_moore, Qc2_moore, Qc3_moore, Qc4_moore, Qc5_moore, Qc6_moore, Qd_moore ;
integer cycles_moore;
//////////////////////////////////////////////////////
wire Done_tb_mealy;
wire [2:0] max_mealy,min_mealy;
wire Cd_tb, C3_tb ,C2_tb,C1_tb,Im_tb;
integer cycles_mealy;

parameter HALF_PERIOD = 20;


//instantiation of min-max module
min_max_finder_moore moore_UT (.reset(reset),.clk(clk),.start(start),.ack(ack),.xin(xin),.yin(yin),.zin(zin),.max(max_moore),.min(min_moore),.Done(Done_tb_moore),.Qi(Qi_moore),.Qc1(Qc1_moore),.Qc2(Qc2_moore),.Qc3(Qc3_moore),.Qc4(Qc4_moore),.Qc5(Qc5_moore),.Qc6(Qc6_moore),.Qd(Qd_moore));

min_max_finder_mealy mealy(reset,clk,start,ack,Done_tb_mealy,xin,yin,zin,max_mealy,min_mealy,Cd_tb, C3_tb ,C2_tb,C1_tb,Im_tb);
//clock Generation
always @ (posedge clk)
	begin
	
	if(Im_tb)
	cycles_mealy <=0;
	else if (C3_tb |C2_tb|C1_tb)
	cycles_mealy <= cycles_mealy + 1;
	
	if(Qi_moore)
	cycles_moore <= 0;
	else if (Qc1_moore | Qc2_moore | Qc3_moore | Qc4_moore  | Qc5_moore  | Qc6_moore)
	cycles_moore <= cycles_moore + 1;
	end

//combination applied
initial
  begin  : CLK_GENERATOR
    clk = 0;
    forever
       begin
	  #HALF_PERIOD clk = ~clk;
       end 
  end

initial
  begin  : RESET_GENERATOR
    reset = 1;
    #(4 * HALF_PERIOD) reset = 0;
  end

task TEST_COMPARATOR;
 input [2:0] X_value, Y_value, Z_value;
   begin    
	@(posedge clk);
	 #2;
	   xin = X_value;
	   yin = Y_value;
	   zin = Z_value;
	   start = 1;
	@(posedge clk);
	 #5;
	   start = 0;

	wait (Done_tb_moore & Done_tb_mealy);

	$display ("Inputs:   Xin = %d and Yin = %d and Zin = %d", xin, yin, zin);
	$display ("Moore Results:  Max = %d and Min = %d and Cyles = %d", 
					max_moore, min_moore, cycles_moore);
	$display ("Mealy Results:  Max = %d and Min = %d and Cyles = %d", 
					max_mealy, min_mealy, cycles_mealy);					
	 #4; 
	   ack = 1;
	@(posedge clk); // Wait for a clock
	 #1;
	   ack = 0;	// Remove ACK
	 // Line B
   end
 endtask

initial
  begin  : STIMULUS
	   xin = 0;		// initial values
	   yin = 3'b000;
	   zin = 0;    // these are not important
	   start = 0;		// except for avoiding red color
	   ack = 0;          // in the initial portion of the waveform.

	wait (~reset);    // wait until reset is over
	@(posedge clk);    // wait for a clock



TEST_COMPARATOR (1, 2, 3);

TEST_COMPARATOR (1, 3, 2);

TEST_COMPARATOR (3, 1, 2);

TEST_COMPARATOR (3, 2, 1);
// test #3 end
TEST_COMPARATOR (2, 1, 3);
TEST_COMPARATOR (2, 3, 1);
	// $finish;  This will try to close the ModelSim
  end // STIMULUS

endmodule


	

