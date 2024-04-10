module Switches_To_LEDs //encapsulated inside one or more modules
(input S1,              //define the interface to a block of code
input S2,               //inside the module declaring all the inputs and outputs
input S3,
input S4,
output L1,
output L2,
output L3,
output L4);

assign L1 = S1;         //defining the logic of the design 
assign L2 = S2;
assign L3 = S3;
assign L4 = S4;

endmodule

/*
module Switches_To_LEDs (
    input wire [3:0] switches,
    output reg [3:0] leds
);

always @* begin
    leds = switches;
end

endmodule
*/