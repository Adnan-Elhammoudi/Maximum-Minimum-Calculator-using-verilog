//This Verilog file include RTL design of the calculator
//system implemented as a Mealy HLSM. control unit (CU) and data path unit (DPU) implemented using a single always procedural block.
//The name of your module should be Max_Min_3_Mealy.


module min_max_finder_mealy(reset,clk,start,ack,DONE_S,xin,yin,zin,max,min,Cd, C3 ,C2,C1,Im);
input  	clk, reset, start, ack;
input  	[2:0] xin,yin,zin;
output  [2:0] max,min;
output DONE_S;
output Cd, C3 ,C2,C1,Im;
//state registers
reg [4:0] next_state;

//Local registers to store input
reg [2:0] xin_reg,yin_reg,zin_reg;

//Local registers to store output
//reg [2:0] min_reg,max_reg;
reg [2:0] max,min;
reg [8*8-1:0] mytextsignal;

//State Declaration
localparam 
            INITIAL   =   5'b00001,
		   Calculate1 = 5'b00010,
		   Calculate2 = 5'b00100,
		   Calculate3 = 5'b01000,
		         Done = 5'b10000;

assign {Cd, C3 ,C2,C1,Im} = next_state;

always @(posedge clk, posedge reset)
     begin  : CU_n_DU

	if (reset)
	     begin
	    
		next_state<= INITIAL;
	    xin_reg <= 3'bXXX;
		yin_reg <= 3'bXXX;
		zin_reg <= 3'bXXX;
 
		   max    <= 3'bXXX;
		   min    <= 3'bXXX;
          end
    else
begin
    (* full_case, parallel_case *)
    case (next_state)
	

INITIAL:
begin 
	xin_reg = xin;
	yin_reg = yin;
	zin_reg = zin;
	max= 3'b000;
	min = 3'b000;
	if(start)
	next_state<=Calculate1;
end
	
Calculate1: begin

    if ((xin_reg >= yin_reg)&(xin_reg >= zin_reg))
      begin
        max= xin_reg;
		if (yin > zin)
		min = zin;
		else 
		min = yin;
	   end  
	   
	     next_state <= Calculate2; 
end
Calculate2: begin
	if ((yin_reg >= xin_reg)&(yin_reg >= zin_reg))
	    begin
        max= yin_reg;
		if (xin > zin)
		min = zin;
		else 
		min = xin;
		end  
  
		 
	     next_state <= Calculate3;
end
	Calculate3: begin
	
 	if  ((zin_reg >= xin_reg)&(zin_reg >= yin_reg))
       begin
		max= zin_reg;
		if (xin > yin)
		min = yin;
		else 
		min = xin;
        end
  
	
    
	 next_state <= Done;
end

	Done: begin   
	if (ack)
	next_state<=INITIAL;
	
end
 endcase
  end 
  end
  always@(next_state) begin 
    case(next_state) 
        INITIAL : mytextsignal = " INITIAL";
        Calculate1 : mytextsignal =  "First Compute State";
	    Calculate2 : mytextsignal =  " Second Compute State";
		Calculate3: mytextsignal =  " Third Compute State";
        Done :  mytextsignal = "  Done";
        default: mytextsignal = " UNKNOWN";
     endcase
 end 
 assign DONE_S = (next_state == Done) ;
  
endmodule
