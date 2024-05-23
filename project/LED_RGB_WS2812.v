module LED_RGB_WS2812(
    input clk,      // 10 MHz clock input
    input rst_n,    // Active-low Reset input
    input button1,  // Button 1 input
    input button2,  // Button 2 input
    output reg WS2812_IO // WS2812 output (change to reg to improve timing)
);
    // Parameters for LED timing in terms of clock cycles
    parameter CLK_FREQ = 10000000; // 10 MHz clock
    parameter T0H = 4;     // 0.35 μs
    parameter T1H = 7;     // 0.7 μs
    parameter T0L = 8;     // 0.8 μs
    parameter T1L = 6;     // 0.6 μs
    parameter RES = 500;   // 50 μs
    parameter COLOR_CYCLE_PERIOD = CLK_FREQ; // Color cycle period (every 1 second)

    // Color definitions (GRB format)
    parameter [23:0] YELLOW = 24'hFFFF00;
    parameter [23:0] PURPLE = 24'h800080;
    parameter [23:0] ORANGE = 24'hFFA500;
    parameter [23:0] RED = 24'hFF0000;
    parameter [23:0] GREEN = 24'h00FF00;
    parameter [23:0] BLUE = 24'h0000FF;

    reg [23:0] current_color1;
    reg [23:0] current_color2;
    reg [31:0] color_cycle_counter = 0;
    reg [2:0] color_index = 0;
    reg [9:0] licznik = 0;
    reg [5:0] bit_counter = 0;
    reg [47:0] shift_register; // 48 bits for two LEDs

    reg state;
    reg next_state;
    reg rst_sync1, rst_sync2;

    // Debug signals
    reg [2:0] debug_color_index;
    reg debug_button1, debug_button2, debug_both_buttons;

    // State definitions
    parameter IDLE = 1'b0, SEND = 1'b1;

    // Synchronize the reset signal to the clock domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_sync1 <= 1'b0;
            rst_sync2 <= 1'b0;
        end else begin
            rst_sync1 <= 1'b1;
            rst_sync2 <= rst_sync1;
        end
    end

    wire rst = ~rst_sync2; // Synchronized reset signal

    // State transition logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(licznik >= RES) 
                    next_state = SEND;
            end
            SEND: begin
                if(bit_counter >= 48) 
                    next_state = IDLE;
            end
        endcase
    end

    // State update
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Color selection and cycling logic
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            color_index <= 0;
            color_cycle_counter <= 0;
            debug_color_index <= 0;
            debug_button1 <= 0;
            debug_button2 <= 0;
            debug_both_buttons <= 0;
        end else begin
            if(button1 && button2) begin
                current_color1 <= GREEN;
                current_color2 <= GREEN;
                debug_both_buttons <= 1;
            end else if(button1) begin
                current_color1 <= RED;
                current_color2 <= RED;
                debug_button1 <= 1;
            end else if(button2) begin
                current_color1 <= BLUE;
                current_color2 <= BLUE;
                debug_button2 <= 1;
            end else begin
                // Color cycling when no buttons are pressed
                if(color_cycle_counter >= COLOR_CYCLE_PERIOD) begin // Change color every 1 second
                    color_cycle_counter <= 0;
                    case (color_index)
                        3'd0: begin
                            current_color1 <= YELLOW;
                            current_color2 <= YELLOW;
                            debug_color_index <= 0;
                        end
                        3'd1: begin
                            current_color1 <= PURPLE;
                            current_color2 <= PURPLE;
                            debug_color_index <= 1;
                        end
                        3'd2: begin
                            current_color1 <= ORANGE;
                            current_color2 <= ORANGE;
                            debug_color_index <= 2;
                        end
                        3'd3: begin
                            current_color1 <= RED;
                            current_color2 <= RED;
                            debug_color_index <= 3;
                        end
                        3'd4: begin
                            current_color1 <= GREEN;
                            current_color2 <= GREEN;
                            debug_color_index <= 4;
                        end
                        3'd5: begin
                            current_color1 <= BLUE;
                            current_color2 <= BLUE;
                            debug_color_index <= 5;
                        end
                    endcase
                    color_index <= color_index + 1;
                    if (color_index == 3'd5)
                        color_index <= 0;
                end else begin
                    color_cycle_counter <= color_cycle_counter + 1;
                end
            end
        end
    end

    // LED control logic
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            licznik <= 0;
            bit_counter <= 0;
            shift_register <= {current_color1, current_color2}; // Load the next color for two LEDs
            WS2812_IO <= 1'b1;
        end else if(state == SEND) begin
            if(bit_counter < 48) begin
                if(shift_register[47]) begin
                    // Send '1'
                    WS2812_IO <= (licznik < T1H);
                end else begin
                    // Send '0'
                    WS2812_IO <= (licznik < T0H);
                end
                
                if(licznik < (shift_register[47] ? (T1H + T1L) : (T0H + T0L))) begin
                    licznik <= licznik + 1;
                end else begin
                    licznik <= 0;
                    shift_register <= {shift_register[46:0], 1'b0};
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                licznik <= 0;
                bit_counter <= 0;
                shift_register <= {current_color1, current_color2}; // Load the next color for two LEDs
            end
        end else if(state == IDLE) begin
            licznik <= licznik + 1;
            if(licznik >= RES) begin
                licznik <= 0;
                shift_register <= {current_color1, current_color2}; // Load the next color for two LEDs
                bit_counter <= 0;
            end
        end else begin
            licznik <= 0; // Ensure licznik is reset when not in IDLE state
        end
    end
endmodule