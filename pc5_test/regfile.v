module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

	//using wire type to create 32 registers
	wire [31:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					din22, din23, din24, din25, din26, din27, din28, din29, din30, din31; //32 32-bit register

	write_32 write_321(data_writeReg, ctrl_writeReg, ctrl_writeEnable, clock, ctrl_reset, din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					 din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					 din22, din23, din24, din25, din26, din27, din28, din29, din30, din31);

	read_32 readA(ctrl_readRegA, data_readRegA, din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11, 
					 din12, din13, din14, din15, din16, din17, din18, din19, din20, din21, din22, din23, din24, din25, din26, 
					 din27, din28, din29, din30, din31);//read data from registerA
					 
	read_32 readB(ctrl_readRegB, data_readRegB, din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					 din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					 din22, din23, din24, din25, din26, din27, din28, din29, din30, din31);	//read data from registerB

	
endmodule

module decoder_32(address,out);//5:32 decoder

	input [4:0] address;
	output [31:0] out;
	wire [4:0] xnot;
	
	//using truth table to get the logic circuit
	not n1(xnot[0], address[0]);
	not n2(xnot[1], address[1]);
	not n3(xnot[2], address[2]);
	not n4(xnot[3], address[3]);
	not n5(xnot[4], address[4]);

	and and0(out[0], xnot[4], xnot[3], xnot[2], xnot[1], xnot[0]);
	and and1(out[1], xnot[4], xnot[3], xnot[2], xnot[1], address[0]);
	and and2(out[2], xnot[4], xnot[3], xnot[2], address[1], xnot[0]);	
	and and3(out[3], xnot[4], xnot[3], xnot[2], address[1], address[0]);	
	and and4(out[4], xnot[4], xnot[3], address[2], xnot[1], xnot[0]);
	and and5(out[5], xnot[4], xnot[3], address[2], xnot[1], address[0]);
	and and6(out[6], xnot[4], xnot[3], address[2], address[1], xnot[0]);	
	and and7(out[7], xnot[4], xnot[3], address[2], address[1], address[0]);	
	and and8(out[8], xnot[4], address[3], xnot[2], xnot[1], xnot[0]);
	and and9(out[9], xnot[4], address[3], xnot[2], xnot[1], address[0]);
	and and10(out[10], xnot[4], address[3], xnot[2], address[1], xnot[0]);
	and and11(out[11], xnot[4], address[3], xnot[2], address[1], address[0]);
	and and12(out[12], xnot[4], address[3], address[2], xnot[1], xnot[0]);
	and and13(out[13], xnot[4], address[3], address[2], xnot[1], address[0]);
	and and14(out[14], xnot[4], address[3], address[2], address[1], xnot[0]);
	and and15(out[15], xnot[4], address[3], address[2], address[1], address[0]);
	and and16(out[16], address[4], xnot[3], xnot[2], xnot[1], xnot[0]);
	and and17(out[17], address[4], xnot[3], xnot[2], xnot[1], address[0]);
	and and18(out[18], address[4], xnot[3], xnot[2], address[1], xnot[0]);
	and and19(out[19], address[4], xnot[3], xnot[2], address[1], address[0]);
	and and20(out[20], address[4], xnot[3], address[2], xnot[1], xnot[0]);
	and and21(out[21], address[4], xnot[3], address[2], xnot[1], address[0]);
	and and22(out[22], address[4], xnot[3], address[2], address[1], xnot[0]);
	and and23(out[23], address[4], xnot[3], address[2], address[1], address[0]);
	and and24(out[24], address[4], address[3], xnot[2], xnot[1], xnot[0]);
	and and25(out[25], address[4], address[3], xnot[2], xnot[1], address[0]);
	and and26(out[26], address[4], address[3], xnot[2], address[1], xnot[0]);
	and and27(out[27], address[4], address[3], xnot[2], address[1], address[0]);
	and and28(out[28], address[4], address[3], address[2], xnot[1], xnot[0]);	
	and and29(out[29], address[4], address[3], address[2], xnot[1], address[0]);	
	and and30(out[30], address[4], address[3], address[2], address[1], xnot[0]);
	and and31(out[31], address[4], address[3], address[2], address[1], address[0]);

endmodule

module dffe_ref(q, d, clk, en, clr);
   
   //Inputs
   input d, clk, en, clr;
   
   //Internal wire
   wire clr;

   //Output
   output q;
   
   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule

module read_32(address, dout, din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					 din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					 din22, din23, din24, din25, din26, din27, din28, din29, din30, din31);
	
	input [4:0] address;
	input [31:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					 din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					 din22, din23, din24, din25, din26, din27, din28, din29, din30, din31;//32 32-bit register
					 
	output [31:0] dout;
	wire [31:0] decoder_out;//output of decoder
	
	decoder_32 dread(address, decoder_out);//using decoder to select output register
	//using Active “HIGH” Tri-state Buffer to select the output value
	assign dout = decoder_out[0] ? din0 : 32'bz;//Z means Hi-Z
	assign dout = decoder_out[1] ? din1 : 32'bz; 
	assign dout = decoder_out[2] ? din2 : 32'bz; 
	assign dout = decoder_out[3] ? din3 : 32'bz; 
	assign dout = decoder_out[4] ? din4 : 32'bz; 
	assign dout = decoder_out[5] ? din5 : 32'bz; 
	assign dout = decoder_out[6] ? din6 : 32'bz; 
	assign dout = decoder_out[7] ? din7 : 32'bz; 
	assign dout = decoder_out[8] ? din8 : 32'bz; 
	assign dout = decoder_out[9] ? din9 : 32'bz; 
	assign dout = decoder_out[10] ? din10 : 32'bz; 
	assign dout = decoder_out[11] ? din11 : 32'bz; 
	assign dout = decoder_out[12] ? din12 : 32'bz; 
	assign dout = decoder_out[13] ? din13 : 32'bz; 
	assign dout = decoder_out[14] ? din14 : 32'bz; 
	assign dout = decoder_out[15] ? din15 : 32'bz; 
	assign dout = decoder_out[16] ? din16 : 32'bz; 
	assign dout = decoder_out[17] ? din17 : 32'bz; 
	assign dout = decoder_out[18] ? din18 : 32'bz;	
	assign dout = decoder_out[19] ? din19 : 32'bz;
	assign dout = decoder_out[20] ? din20 : 32'bz;
	assign dout = decoder_out[21] ? din21 : 32'bz;
	assign dout = decoder_out[22] ? din22 : 32'bz;
	assign dout = decoder_out[23] ? din23 : 32'bz;
	assign dout = decoder_out[24] ? din24 : 32'bz;
	assign dout = decoder_out[25] ? din25 : 32'bz;
	assign dout = decoder_out[26] ? din26 : 32'bz;
	assign dout = decoder_out[27] ? din27 : 32'bz;
	assign dout = decoder_out[28] ? din28 : 32'bz;
	assign dout = decoder_out[29] ? din29 : 32'bz;
	assign dout = decoder_out[30] ? din30 : 32'bz;
	assign dout = decoder_out[31] ? din31 : 32'bz;

endmodule	

module register_32(datain, dataout, clock, enable, reset);//32-bit register

	input [31:0] datain;//input data
	input clock, enable, reset;
	output [31:0] dataout;//output data
	genvar x;//using generate for to create 32-bit register
		generate
		for (x = 0; x < 32; x = x + 1) 
		begin: l
		dffe_ref dffe1(dataout[x], datain[x], clock, enable, reset);//32 deff to create one 32-bit register
		end
		endgenerate
		
endmodule 

module write_32(datain, address_w, enable, clk, reset, din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					  din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					  din22, din23, din24, din25, din26, din27, din28, din29, din30, din31);//write port for 32 register
	
	input enable;
	input [4:0] address_w;
	wire [31:0] out;
	wire [31:0] deco_in;//decoder result input
			
	input clk, reset;//clock and reset
	input [31:0] datain;// data input
	output [31:0] din0, din1, din2, din3, din4, din5, din6, din7, din8, din9, din10, din11,
					  din12, din13, din14, din15, din16, din17, din18, din19, din20, din21,
					  din22, din23, din24, din25, din26, din27, din28, din29, din30, din31;//32 32-bit register
										
	decoder_32 dwrite(address_w,out);//using decoder to select register
	genvar y;//generate for to do and gate for enable and decoder output
		generate
		for (y = 0; y < 32; y = y + 1) 
		begin: loop
		and and1(deco_in[y], out[y], enable);
		end
		endgenerate
					
	register_32 r0(32'b0, din0, clk, 1'b0, 1'b1);//register 0 always be zero
	register_32 r1(datain, din1, clk, deco_in[1], reset);//other register for datain
	register_32 r2(datain, din2, clk, deco_in[2], reset);
	register_32 r3(datain, din3, clk, deco_in[3], reset);
	register_32 r4(datain, din4, clk, deco_in[4], reset);
	register_32 r5(datain, din5, clk, deco_in[5], reset);
	register_32 r6(datain, din6, clk, deco_in[6], reset);
	register_32 r7(datain, din7, clk, deco_in[7], reset);
	register_32 r8(datain, din8, clk, deco_in[8], reset);
	register_32 r9(datain, din9, clk, deco_in[9], reset);
	register_32 r10(datain, din10, clk, deco_in[10], reset);
	register_32 r11(datain, din11, clk, deco_in[11], reset);
	register_32 r12(datain, din12, clk, deco_in[12], reset);
	register_32 r13(datain, din13, clk, deco_in[13], reset);
	register_32 r14(datain, din14, clk, deco_in[14], reset);
	register_32 r15(datain, din15, clk, deco_in[15], reset);
	register_32 r16(datain, din16, clk, deco_in[16], reset);
	register_32 r17(datain, din17, clk, deco_in[17], reset);
	register_32 r18(datain, din18, clk, deco_in[18], reset);
	register_32 r19(datain, din19, clk, deco_in[19], reset);
	register_32 r20(datain, din20, clk, deco_in[20], reset);
	register_32 r21(datain, din21, clk, deco_in[21], reset);
	register_32 r22(datain, din22, clk, deco_in[22], reset);
	register_32 r23(datain, din23, clk, deco_in[23], reset);
	register_32 r24(datain, din24, clk, deco_in[24], reset);
	register_32 r25(datain, din25, clk, deco_in[25], reset);
	register_32 r26(datain, din26, clk, deco_in[26], reset);
	register_32 r27(datain, din27, clk, deco_in[27], reset);
	register_32 r28(datain, din28, clk, deco_in[28], reset);
	register_32 r29(datain, din29, clk, deco_in[29], reset);
	register_32 r30(datain, din30, clk, deco_in[30], reset);
	register_32 r31(datain, din31, clk, deco_in[31], reset);
		
endmodule
