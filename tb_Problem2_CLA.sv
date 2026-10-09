`timescale 1ns/1ps

module tb_CLA;
    reg  [31:0] A, B;
    reg         Cin;
    wire [31:0] S;
    wire        Cout;

    CLA uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_CLA);

        // Case 1: Unsigned Addition
        A = 32'd100; B = 32'd250; Cin = 1'b0; #10;

        // Case 2: Signed Addition with Negative Operand
        A = 32'd500; B = -32'd200; Cin = 1'b0; #10;

        // Case 3: Carry-out generation at MSB
        A = 32'hFFFF_FFFF; B = 32'h0000_0001; Cin = 1'b0; #10;

        // Case 4: Multi-block Carry Propagation (bits 0 to 15)
        A = 32'h0000_FFFF; B = 32'h0000_0000; Cin = 1'b1; #10;

        // Case 5: Propagation across all 8 blocks
        A = 32'hFFFF_FFFF; B = 32'h0000_0000; Cin = 1'b1; #10;

        $finish;
    end
endmodule
