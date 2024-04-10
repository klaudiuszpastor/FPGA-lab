***Section for preparation exercises***


***LED Control Using Buttons:***
To control LEDs with buttons, you typically implement a simple debouncing 
mechanism to avoid multiple toggles due to mechanical bouncing. Here's an 
outline of how you can achieve this:

1. Connect buttons to the FPGA input pins.
2. Read the state of the buttons using Verilog.
3. Implement a debouncing mechanism to ensure reliable button presses.
4. Use the button states to control the LEDs.

***Basic Asynchronous Logic:***
You can implement basic asynchronous logic gates such as AND, OR, NAND, NOR, XOR, and XNOR 
using Verilog. These gates are the fundamental building blocks of digital circuits.

***Multiplexers and Demultiplexers:***
Multiplexers and demultiplexers are combinational logic circuits. A multiplexer selects 
one of many input signals and directs it to a single output, while a demultiplexer takes 
a single input and directs it to one of many outputs.

***Basic Synchronous Logic:***
Synchronous logic circuits are designed to perform operations synchronized to a clock 
signal. They often use flip-flops to store state information and operate based on clock edges.

***Using Processes and Variables:***
Processes and variables are commonly used in Verilog to describe behavior and store 
temporary data within modules. They are essential for implementing various functionalities 
such as frequency dividers, counters, and state machines.

- Frequency Dividers: Dividers are used to divide the frequency of a clock signal. They can 
  be implemented using counters to count a certain number of clock cycles before toggling an output.

- Counters: Counters are used to count events or clock cycles. They can be implemented 
  using registers and incremented at each clock cycle.
  
- State Machines: State machines are used to model sequential logic circuits. They consist 
  of a set of states and transitions between states based on inputs and current states. 
  Processes and variables are used to describe state transitions and state storage within state machines.