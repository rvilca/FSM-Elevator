module Elevator(

input wire R0, R1,reset,clk,
output reg [1:0] currentFloor,
output reg Door
);

	initial Door=1;
  
	reg [1:0] prev_state, state, next_state;
	reg Change;

	parameter [1:0] FLR1 = 2'b00;
	parameter [1:0] FLR2 = 2'b01;
	parameter [1:0] FLR2NS = 2'b10;
	parameter [1:0] FLR3 = 2'b11;

always@(posedge clk)
begin

		prev_state<=state;

		
		if(reset)
		state <= FLR1;
		else
		state <= next_state;
		
		
		if(Change | reset)
		Door=1;
		
		else
		Door=0;
end

always@(state)
begin

		next_state=state;

case(state)


FLR1:
	begin
		
		if((!R1 & !R0) || (!R1&R0))
		begin
		next_state=FLR1;
		Change=0;
		end

		else if (R1&!R0)
		begin
		next_state=FLR2;
		Change=1;
		end

		else if (R1&R0)
		begin
		next_state=FLR2NS;
		Change=0;
		end

		
		currentFloor<=1;
		
	end

FLR2:
	begin 

		if((!R1&!R0) || (R1&!R0))
		begin
		next_state=FLR2;
		Change=0;
		end

		else if (!R1&R0)
		begin
		next_state=FLR1;
		Change=1;
		end

		else if (R1&R0)
		begin
		next_state=FLR3;
		Change=1;
		end

		
		currentFloor<=2;
	
	end

FLR3:
	begin
	
		if((!R1&!R0) || (R1&R0))
			begin
			next_state=FLR3;
			Change=0;
			end
		
		else if (!R1&R0)
			begin
			next_state=FLR2NS;
			Change=0;
			end
			
		else if (R1&!R0)
			begin
			next_state=FLR2;
			Change=1;
			end
			
			
		currentFloor<=3;
	
	end

FLR2NS:
	begin
	
		if(prev_state==0)
			begin
			next_state=FLR3;
			Change=1;
			end
		
		else if(prev_state==3)
			begin
			next_state=FLR1;
			Change=1;
			end
			
			
		currentFloor<=2;
		
	end

endcase

end


endmodule
