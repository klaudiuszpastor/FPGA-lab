// toggle the state of an LED each time a switch is released
// if the led was off before the switch is released
// i should turn on, and if the led was on, it should turn off
// looking for falling edge of switch 

module LED_Toggle (
    input i_Clk,
    input i_Switch_1,
    output o_LED_1);

reg r_LED_1    =  1'b0;     // reg - register
reg r_Switch_1 =  1'b0;     // reg signals registered as flip-flops (latches)

always @(posedge i_Clk)     // this block is triggered by changes in one
// or more signals, as specified by the code block's sensitivity list, which
// is given in parentheses - in this case block is sensitive to the clock signal
// using clock to trigger logic - using the clock's rising edges
// posedge - positive edge (rising edge)
begin                         
    r_Switch_1 <= i_Switch_1;// generating a flip-flop with i_Switch_1 on the D
// input, r_Switch_1 on the Q output, and i_Clk going into the clock input
// the output of this flip-flop will generate a one-clock-cycle delay of any changes 
// to the input

    if (i_Switch_1 == 1'b0 && r_Switch_1 == 1'b1) // check if the switch released
// if the current state is 0 and the previous state is 1 then detected falling edge
    begin
        r_LED_1 <= ~r_LED_1; // toggle the state of the led
    end
end

assign o_LED_1 = r_LED_1;
endmodule

/* blinking led code

module blink_led(
    input wire clk,  // Clock input
    output reg led   // LED output
);

// Counter for controlling blinking frequency
reg [23:0] counter = 0;

always @(posedge clk) 
begin
    // Increment the counter
    counter <= counter + 1;

    // Toggle the LED every half-second (adjust as needed)
    if (counter == 25000000) 
    begin
        led <= ~led;
        counter <= 0;
    end
end

endmodule
*/