module dffe_ref1(q, d, clk, clr);
   
   //Inputs
   input [11:0] d;
	input	clk, clr;
   
   //Internal wire
   wire clr;

   //Output
   output [11:0] q;
   
   //Register
   reg [11:0] q;

   //Intialize q to 0
   initial
   begin
       q = 12'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 12'b0;
       end 
		 else begin
           q <= d;
       end
   end
endmodule



