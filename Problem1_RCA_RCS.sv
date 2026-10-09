// Code your design here
module one_bit_full_adder (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    assign {Cout, S} = A + B + Cin;
endmodule
