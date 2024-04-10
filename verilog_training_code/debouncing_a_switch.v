module Debounce
(input i_CLK,
 input i_Switch_1,
 output o_LED_1);

wire w_Debounced_Switch;

Debounce_Filter #(.DEBOUNCE_LIMIT(250000)) Debounce_Inst
(.i_CLK(i_CLK),
.i_Bouncy(i_Switch_1),
.o_Debounce(w_Debounced_Switch));

LED_Toggle_Project LED_Toggle_Inst
(.i_CLK(i_CLK),
.i_Switch_1(w_Debounced_Switch),
.o_LED_1(o_LED_1));
endmodule