module FA(a,b,cin,sum,cout);//fall adder
	input a,b,cin;
	output sum,cout;
	wire s1,s2,c1;
	xor xor1(s1,a,b);
	xor xor2(sum,s1,cin);
	and and1(s2,s1,cin);
	and and2(c1,a,b);
	or or1(cout,c1,s2);
endmodule

module RCA(a,b,cin,r);//RCA for 16bit
	input [11:0] a,b;
	input cin;
	output [11:0] r;
	wire C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12;
	FA FA0 (a[0],b[0],cin,r[0],C1);
	FA FA1 (a[1],b[1],C1,r[1],C2);
	FA FA2 (a[2],b[2],C2,r[2],C3);
	FA FA3 (a[3],b[3],C3,r[3],C4);
	FA FA4 (a[4],b[4],C4,r[4],C5);
	FA FA5 (a[5],b[5],C5,r[5],C6);
	FA FA6 (a[6],b[6],C6,r[6],C7);
	FA FA7 (a[7],b[7],C7,r[7],C8);
	FA FA8 (a[8],b[8],C8,r[8],C9);
	FA FA9 (a[9],b[9],C9,r[9],C10);
	FA FA10 (a[10],b[10],C10,r[10],C11);
	FA FA11 (a[11],b[11],C11,r[11],C12);
endmodule