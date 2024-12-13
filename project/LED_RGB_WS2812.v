module LED_RGB_WS2812(
    input clk,       
    input rst_n,     
    input button1,   
    output reg WS2812_IO 
);

    parameter CLK_FREQ = 10000000;				// zegar 10 MHz
    parameter T0H = 4;    							// 0,4 μs
    parameter T1H = 7;    							// 0,7 μs
    parameter T0L = 8;    							// 0,8 μs
    parameter T1L = 6;    							// 0,6 μs
    parameter RES = 500;  							// 50 μs
    parameter COLOR_CYCLE_PERIOD = CLK_FREQ; // okres cyklu kolorów (co 1 sekunde)

    // definicje kolorów (GRB) 
    parameter [23:0] RED 	 = 24'hFF0000;
    parameter [23:0] YELLOW = 24'hFFFF00;
    parameter [23:0] GREEN	 = 24'h00FF00;
    parameter [23:0] BLUE	 = 24'h0000FF;

    reg [23:0] color1, color2; 					// aktualne kolory dla dwóch diod LED
    reg [31:0] color_cycle_counter; 			// licznik cyklu zmiany kolorów
    reg [1:0] color_index; 						// przełączanie między kolorami
    reg [9:0] licznik; 								// licznik czasu dla generowania sygnałów T0H, T1H, T0L, T1L
    reg [5:0] bit_counter; 						// licznik bitów do wysyłania danych do LED
    reg [47:0] color_data; 						// przechowywanie bitów danych dla dwóch LED

    reg state, next_state;							// aktualny i następny stan maszyny stanów
    reg rst_sync1, rst_sync2;						// synchronizacja sygnału resetu

    parameter IDLE = 1'b0, SEND = 1'b1;		// definicje stanów

    // synchronizacja sygnału resetu z domeną zegara
    always @(posedge clk or negedge rst_n) 
	 begin
        if (!rst_n) 
		  begin
            rst_sync1 <= 1'b0;
            rst_sync2 <= 1'b0;
        end 
		  else 
				begin
					rst_sync1 <= 1'b1;
					rst_sync2 <= rst_sync1;
				end
    end

    wire rst = ~rst_sync2; 						// zsynchronizowany sygnał resetu
    wire btn1 = ~button1; 							// odwócona logika przycisku

    // maszyna stanów
    always @(*) 
	 begin
        case(state)
            IDLE: 
                if (licznik >= RES) 
                    next_state = SEND; 		// przejście do SEND gdy licznik przekroczy czas resetu
                else 
                    next_state = IDLE; 		
            SEND: 
                if (bit_counter >= 48) 
                    next_state = IDLE; 		// przejście do IDLE gdy wszystkie bity zostaną wysłane
                else 
                    next_state = SEND; 		
            default: 
                next_state = IDLE; 				
        endcase
    end

    // aktualizacja stanu maszyny stanów
    always @(posedge clk or posedge rst) 
	 begin
        if (rst) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // logika wyboru koloru i cyklu zmiany kolorów
    always @(posedge clk or posedge rst) 
	 begin
        if (rst) 
		  begin
            color_index <= 0; 
            color_cycle_counter <= 0; 
        end 
		  else if (color_cycle_counter >= COLOR_CYCLE_PERIOD) 
			  begin
					color_cycle_counter <= 0; 
					if (btn1) 
					begin
						 // wciśnięty przycisk
						 case (color_index)
							  2'd0: {color1, color2} <= {RED, RED};
							  2'd1: {color1, color2} <= {YELLOW, YELLOW};
							  2'd2: {color1, color2} <= {GREEN, GREEN};
							  2'd3: {color1, color2} <= {BLUE, BLUE};
							  default: {color1, color2} <= {RED, RED};
						 endcase
					end 
					else 
						begin
							 // przełączanie z daną sekwencją (przycisk nie wciśnięty)
							 case (color_index)
								  2'd0: {color1, color2} <= {RED, YELLOW};
								  2'd1: {color1, color2} <= {YELLOW, BLUE};
								  2'd2: {color1, color2} <= {BLUE, GREEN};
								  2'd3: {color1, color2} <= {GREEN, RED};
								  default: {color1, color2} <= {RED, YELLOW};
							 endcase
						end
					color_index <= color_index + 1; 
			  end 
		  else 
			  begin
					// inkrementacja licznika cyklu kolorów
					color_cycle_counter <= color_cycle_counter + 1; 
			  end
    end

    // logika sterowania LED dla WS2812
    always @(posedge clk or posedge rst) 
	 begin
        if (rst) 
		  begin
            licznik <= 0; 
            bit_counter <= 0; 
            color_data <= {color1, color2}; 							// załaduj następny kolor dla dwóch LED
            WS2812_IO <= 1'b1; 											// ustawienie wyjścia WS2812 na 1
        end 
		  else if (state == SEND) 
			  begin
					if (bit_counter < 48) 
					begin
						 // wysyłanie '1' lub '0' na podstawie aktualnego bitu
						 if (color_data[47 - bit_counter]) 
						 begin
							  WS2812_IO <= (licznik < T1H);
						 end 
						 else 
							 begin
								  WS2812_IO <= (licznik < T0H);
							 end
						 
						 licznik <= licznik + 1; 							// inkrementacja licznika czasu
						 
						 if (color_data[47 - bit_counter]) 
						 begin
							  if (licznik >= (T1H + T1L)) 
							  begin
									licznik <= 0; 								// reset licznika czasu po wysłaniu bitu
									bit_counter <= bit_counter + 1; 		// inkrementacja licznika bitów
							  end
						 end 
						 else 
							 begin
								  if (licznik >= (T0H + T0L)) 
								  begin
										licznik <= 0; 							// reset licznika czasu po wysłaniu bitu
										bit_counter <= bit_counter + 1; 	// inkrementacja licznika bitów
								  end
							 end
					end 
					else 
						begin
							 licznik <= 0; 									// reset licznika czasu
							 bit_counter <= 0; 								// reset licznika bitów
							 color_data <= {color1, color2}; 			// załaduj następny kolor dla dwóch LED
						end
			  end 
		  else if (state == IDLE) 
			  begin
					licznik <= licznik + 1; 								// inkrementacja licznika czasu w stanie IDLE
					if (licznik >= RES) 
					begin
						 licznik <= 0; 							
						 color_data <= {color1, color2}; 	
						 bit_counter <= 0; 						
					end
			  end 
		  else 
			  begin
					licznik <= 0; 												// licznik jest zresetowany gdy nie jest w stanie IDLE
			  end
    end
endmodule
