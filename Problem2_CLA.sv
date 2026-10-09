`timescale 1ns/1ps

module four_bit_adder (
    input  wire [3:0] A, B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout
);
    wire c1, c2, c3;
    one_bit_full_adder fa0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(c1));
    one_bit_full_adder fa1 (.A(A[1]), .B(B[1]), .Cin(c1),  .S(S[1]), .Cout(c2));
    one_bit_full_adder fa2 (.A(A[2]), .B(B[2]), .Cin(c2),  .S(S[2]), .Cout(c3));
    one_bit_full_adder fa3 (.A(A[3]), .B(B[3]), .Cin(c3),  .S(S[3]), .Cout(Cout));
endmodule

module cla_4bit_lookahead (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire       Cout
);
    wire [3:0] G;
    wire [3:0] P;

    and g0 (G[0], A[0], B[0]);
    and g1 (G[1], A[1], B[1]);
    and g2 (G[2], A[2], B[2]);
    and g3 (G[3], A[3], B[3]);

    xor p0 (P[0], A[0], B[0]);
    xor p1 (P[1], A[1], B[1]);
    xor p2 (P[2], A[2], B[2]);
    xor p3 (P[3], A[3], B[3]);

    wire t1, t2, t3, t4, t5, G_3_0;
    and a1 (t1, P[1], G[0]);
    or  o1 (t2, G[1], t1);
    and a2 (t3, P[2], t2);
    or  o2 (t4, G[2], t3);
    and a3 (t5, P[3], t4);
    or  o3 (G_3_0, G[3], t5);

    wire p_01, p_23, P_3_0;
    and a_p1 (p_01, P[0], P[1]);
    and a_p2 (p_23, P[2], P[3]);
    and a_p3 (P_3_0, p_01, p_23);

    wire t_prop;
    and a_cout (t_prop, P_3_0, Cin);
    or  o_cout (Cout, G_3_0, t_prop);
endmodule

module CLA (A, B, Cin, S, Cout);
    input  wire [31:0] A, B;
    input  wire        Cin;
    output wire [31:0] S;
    output wire        Cout;

    wire [8:0] C;
    assign C[0] = Cin;
    assign Cout = C[8];

    wire [7:0] unused_cout;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_blocks
            four_bit_adder rca_inst (
                .A(A[i*4 + 3 : i*4]),
                .B(B[i*4 + 3 : i*4]),
                .Cin(C[i]),
                .S(S[i*4 + 3 : i*4]),
                .Cout(unused_cout[i])
            );

            cla_4bit_lookahead lcu_inst (
                .A(A[i*4 + 3 : i*4]),
                .B(B[i*4 + 3 : i*4]),
                .Cin(C[i]),
                .Cout(C[i+1])
            );
        end
    endgenerate
endmodule
