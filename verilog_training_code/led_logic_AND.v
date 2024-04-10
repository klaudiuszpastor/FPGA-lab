module And_Gate 
(input S1,
input S2,
output L1);

assign L1 = S1 & S2;

endmodule

/*
module And_Gate (
    input wire S1,
    input wire S2,
    output reg L1
);

    always @* begin
        L1 = S1 & S2;
    end

endmodule
*/

