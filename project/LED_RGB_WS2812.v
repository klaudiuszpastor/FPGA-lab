module LED_RGB_WS2812 (
    input wire [23:0] rgb_data,
    input wire write,
    input wire reset,
    input wire clk,  // 10MHz

    output reg data
);
    parameter NUM_LEDS = 2;
    parameter CLK_MHZ = 10;
    localparam LED_BITS = $clog2(NUM_LEDS);

    parameter t_on = CLK_MHZ * 900 / 100 ;
    parameter t_off = CLK_MHZ * 350 / 100 ;
    parameter t_reset = CLK_MHZ * 280 / 2;
    parameter t_period = CLK_MHZ * 1250 / 100 ;

    localparam COUNT_BITS = $clog2(t_reset);

    reg [23:0] led_reg [NUM_LEDS-1:0];

    reg [LED_BITS-1:0] led_counter;
    reg [COUNT_BITS-1:0] bit_counter;
    reg [4:0] rgb_counter;

    localparam STATE_DATA  = 0;
    localparam STATE_RESET = 1;

    reg [1:0] state;

    reg [23:0] led_color;

    integer i; // Deklarujemy zmienną i na poziomie modułu

    // Obsługa zapisu nowych danych do led_reg oraz inicjalizacja w sekcji always @(posedge clk)
    always @(posedge clk) begin
        if (reset) begin
            // Zresetuj dane led_reg
            for (i = 0; i < NUM_LEDS; i = i + 1)
                led_reg[i] <= 0;
        end else begin
            // Obsługa zapisu nowych danych do led_reg
            if (write)
                led_reg[0] <= rgb_data;
        end
    end

    // Maszyna stanów do generowania danych wyjściowych
    always @(posedge clk) begin
        case (state)
            STATE_RESET: begin
                // Inicjalizacja wartości
                rgb_counter <= 5'd23;
                led_counter <= NUM_LEDS - 1;
                data <= 0;
                bit_counter <= bit_counter - 1'b1;

                if (bit_counter == 0) begin
                    state <= STATE_DATA;
                    bit_counter <= t_period;
                end
            end

            STATE_DATA: begin
                // Obsługa generowania danych
                if (led_color[rgb_counter])
                    data <= bit_counter > (t_period - t_on);
                else
                    data <= bit_counter > (t_period - t_off);

                // Licznik cykli
                bit_counter <= bit_counter - 1'b1;

                // Po każdym bicie inkrementuj rgb_counter
                if (bit_counter == 0) begin
                    bit_counter <= t_period;
                    rgb_counter <= rgb_counter - 1;

                    if (rgb_counter == 0) begin
                        led_counter <= led_counter - 1;
                        bit_counter <= t_period;
                        rgb_counter <= 23;

                        if (led_counter == 0) begin
                            state <= STATE_RESET;
                            led_counter <= NUM_LEDS - 1;
                            bit_counter <= t_reset;
                        end
                    end
                end
            end
        endcase
    end

endmodule
