`timescale 1ns/1ps

module tb_adder;
    reg A, B, Cin;
    wire S, Cout;

    
    one_bit_full_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder);

        A = 0; B = 0; Cin = 0; #10;
        A = 0; B = 1; Cin = 0; #10;
        A = 1; B = 1; Cin = 0; #10;
        A = 1; B = 1; Cin = 1; #10;

        $finish;
    end
endmodule
