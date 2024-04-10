/*
Cominational logic is logic for which the outputs are determined by the present inputs
with no memory of the previous state.
Sequential logic is logic for which the outputs are determined both by present inputs
and previous outputs - sequential logic is achieved with flip-flips, since flip-flops
don't immediately register changes on their inputs to their outputs, but rather wait
until the rising edge of the clock to act on the new input data
*/

always @(input_1 or input_2)
begin
    and_gate <= input_1 & input_2;
end
// generating LUTS not flip-flops
// flip-flops require a clock input
// and there is no clock



always @(posedge i_Clk)
begin
    and_gate <= input_1 & input_2;
end
// always sensitive to clock is now 
// consired as sequential logic
// still require LUT to perform the AND
// operation but in addition to that the 
// output will utilize a flip-flop