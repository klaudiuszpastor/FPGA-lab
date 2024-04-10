// AND Gate: Produces a high output only when all of its inputs are high.
module and_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = a & b;
end
endmodule

// OR Gate: Produces a high output when any of its inputs are high.
module or_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = a | b;
end
endmodule

// NAND Gate: Produces a low output only when all of its inputs are high.
module nand_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = ~(a & b);
end
endmodule

// NOR Gate: Produces a low output when any of its inputs are high.
module nor_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = ~(a | b);
end
endmodule

// XOR Gate: Produces a high output when the number of high inputs is odd.
module xor_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = a ^ b;
end
endmodule

// XNOR Gate: Produces a high output when the number of high inputs is even.
module xnor_gate(
    input wire a,
    input wire b,
    output reg out
);
always @(a, b) begin
    out = ~(a ^ b);
end
endmodule

/*
In Verilog, the always keyword is used to create procedural blocks that define 
how signals are updated or actions are taken in response to certain events or 
conditions. It's commonly used in synchronous designs to describe behavior that 
should occur in response to clock edges, or in combinational logic to describe 
behavior based on changes in input signals.

Here's a breakdown of its usage:

always @(posedge clk) indicates that the block of code should execute whenever 
there is a positive edge (rising edge) on the clk signal. This is commonly used 
for synchronous logic, where operations need to be synchronized with the clock signal.

always @(a, b) indicates that the block of code should execute whenever there is a 
change in the signals a or b. This is often used for combinational logic, where 
the output depends on the current values of the inputs.

Within the always block, the behavior is defined using procedural statements like 
assignments (=), conditionals (if, else), loops (for, while), etc. These statements 
specify how signals are updated or how actions are taken based on the conditions 
specified in the sensitivity list.

In the context of the Verilog examples provided earlier, always blocks are used 
to define the behavior of logic gates based on changes in their input signals (a, b). 
This ensures that whenever there is a change in the input signals, the corresponding 
logic gate outputs are updated accordingly.
*/
