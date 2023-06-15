/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile

);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 //module for PC
	 wire [11:0] curr, next, prev;//declare instructions for PC,curr is current pc,
											//next is the next pc, prev is the previous pc
	 wire [11:0] prev_1, prev_2, prev_3;
	 dffe_ref1 dffe1(curr, prev, clock, reset);
	 RCA rca1(12'b1,curr,0,next);//PC=PC+1
	 assign address_imem = curr;//address of imem is current pc
	
	 //decode instructions
	 wire [4:0] opcode;
	 wire [4:0] ALU_op;
	 wire [4:0] ALU_code;
	 wire Rwe, Rdst, ALUinB, DMwe, Rwd;
	 //output Rwe, Rdst, ALUinB, DMwe, Rwd;
	 assign ALU_code = q_imem[6:2];//ALU opcode generated directly from imem
	 assign opcode = q_imem[31:27];//opcode generated directly from imem
	 wire [4:0] opcode_bar;
	 assign opcode_bar =~ opcode;
	 wire [4:0] ALU_op_bar;
	 assign ALU_op_bar = ~ALU_op;
	 
	 //new control signal by opcode
	 wire j, bne, jal, jr, blt, bex, setx;
	 assign j = (opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode_bar[1] & opcode[0]);
	 assign bne = (opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode[1] & opcode_bar[0]);
	 assign jal = (opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode[1] & opcode[0]);
	 assign jr = (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode_bar[1] & opcode_bar[0]);
	 assign blt = (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode[1] & opcode_bar[0]);
	 assign bex = (opcode[4] & opcode_bar[3] & opcode[2] & opcode[1] & opcode_bar[0]);
	 assign setx = (opcode[4] & opcode_bar[3] & opcode[2] & opcode_bar[1] & opcode[0]);
	 
	 //control signal generated by truth table
	 assign Rwe = (opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0]) | 
					  (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode_bar[1] & opcode[0]) | 
					  (opcode_bar[4] & opcode[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0]);
	 assign Rdst = (opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0]);
	 assign ALUinB = (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode[1] & opcode[0]) | 
						  (opcode_bar[4] & opcode[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0])| 
						  (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode_bar[1] & opcode[0]);
	 assign DMwe = (opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode[1] & opcode[0]);
	 assign Rwd = (opcode_bar[4] & opcode[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0]);
	 assign ALU_op = ALUinB ? 5'b0 : ALU_code;//True ALU opcode
	 
	 //module of register file
	 wire [4:0] Rd, Rs, Rt;//register rd rs rt
	 wire [4 :0] shamt;//shift amount
	 wire [16:0] imm;//imm number
	 wire [26:0] target;//target T
	 
	 //generate register address and shift amount from imem
	 assign Rd = q_imem[26:22];
	 assign Rs = q_imem[21:17];
	 assign Rt = q_imem[16:12];
	 assign imm = q_imem[16:0];
	 assign shamt = q_imem[11:7];
	 assign target = q_imem[26:0];
	 
	 
	 //module of SX
	 wire [31:0] imm_sx; 
	 genvar i;
	 generate
		 for (i = 1; i < 16; i = i + 1) begin : loop1
			assign imm_sx[i + 16] = imm[16];
		 end
	 endgenerate
	 assign imm_sx[16:0] = imm[16:0];

	 //module of USX
	 wire [31:0] next_32; 
	 genvar l;
	 generate
		 for (l = 1; l < 21; l = l + 1) begin : loop2
			assign next_32[l + 11] = 0;
		 end
	 endgenerate
	 assign next_32[11:0] = next[11:0];
	 
	 //module of USX target
	 wire [31:0] target_32; 
	 genvar k;
	 generate
		 for (k = 1; k < 6; k = k + 1) begin : loop3
			assign target_32[k + 26] = 0;
		 end
	 endgenerate
	 assign target_32[26:0] = target[26:0];
	 
	 //module for alu
	 wire [31:0] ALU_r1;//ALU data in 1
    wire [31:0] ALU_r2;//ALU data in 2
	 assign ALU_r1 = data_readRegA;
	 assign ALU_r2 = ALUinB ? imm_sx: data_readRegB;
	
	 wire isNotEqual;
	 wire isLessThan;
	 wire overflow;//overflow of ALU
	 wire over;//the real overflow
	 //output over;
	 wire [31:0] data_result;//data result from ALU
	 
	 alu alu1(ALU_r1, ALU_r2, ALU_op, shamt, data_result, isNotEqual, isLessThan, overflow);

	 //jump and bne module of pc_netx
	 wire [11:0] next_N;
	 RCA rca2(imm,next,0,next_N);//PC=PC+1+N
	 assign prev_1 = (j | jal | (bex & isNotEqual)) ? target : next;// if j jal, pc=traget. if bex isnotequal, pc=target
	 assign prev_2 = (bne & isNotEqual) | (blt & isNotEqual & (~isLessThan)) ? next_N : prev_1;// if bne notequal, pc=pc+1+N
	 assign prev_3 = jr ? data_readRegB : prev_2;//if jr, PC=$rd
	 assign prev = prev_3;
	 
	 //module of overflow
	 wire o1;
	 wire o2;
	 wire o3;	
	 wire [31:0] data_res1;

	 //distinguish the category of overflow(add addi sub) from truth table
	 assign o1 = overflow & opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0] 
					& ALU_op_bar[4] & ALU_op_bar[3] & ALU_op_bar[2] & ALU_op_bar[1] & ALU_op_bar[0];
	 assign o2 = overflow & opcode_bar[4] & opcode_bar[3] & opcode[2] & opcode_bar[1] & opcode[0] 
					& ALU_op_bar[4] & ALU_op_bar[3] & ALU_op_bar[2] & ALU_op_bar[1] & ALU_op_bar[0];
	 assign o3 = overflow & opcode_bar[4] & opcode_bar[3] & opcode_bar[2] & opcode_bar[1] & opcode_bar[0] 
					& ALU_op_bar[4] & ALU_op_bar[3] & ALU_op_bar[2] & ALU_op_bar[1] & ALU_op[0];		
					
	 assign data_res1 = o1 ? 32'b01 : (o2 ? 32'b10 : (o3 ? 32'b11 : data_result));
	 assign over = o1 ? overflow : (o2 ? overflow : (o3 ? overflow : 0));
	 
	 //module for dmem
	 assign data = data_readRegB;
	 assign address_dmem = data_result[11:0];
	 assign wren = DMwe;
	 
	 //input of register file
	 wire [31:0] data_writeReg1, data_writeReg2;//middle value for data to write in	 
	 wire [31:0] ctrl_writeReg1;//middle value for address to write in
	 wire [4:0] ctrl_readRegB1;//middle value for address to read
	 
	 assign ctrl_writeEnable = (Rwe | jal | setx);
	 assign ctrl_readRegA = bex ? 5'b11110 : Rs;//if bex, $r30
	 assign ctrl_readRegB1 = (Rdst)? Rt : Rd;
	 assign ctrl_readRegB = bex ? 5'b00000 : ctrl_readRegB1;//if bex, $r0
	 assign ctrl_writeReg1 = (over | setx) ? 5'b11110 : Rd;//if overflow, write data to r30
	 assign ctrl_writeReg = jal ? 5'b11111 : ctrl_writeReg1;// if jal, write pc+1 32bits to r31
	 assign data_writeReg1 = Rwd ? q_dmem : data_res1;//select data to write
	 assign data_writeReg2 = jal ? next_32 : data_writeReg1;//select data to write if jal, write next_32
	 assign data_writeReg = setx ? target_32 : data_writeReg2;//select data to write if setx, write target_32

endmodule
