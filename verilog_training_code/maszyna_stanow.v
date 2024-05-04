module maszyna_stanow (input button, clk, rst, output reg led);

reg [1:0] stan = 0, nastepny_stan = 0;
parameter [1:0] idle = 0, wcisniety = 1, wyswietlanie = 2;
parameter swiec = 0, nie_swiec = 1;

reg [24:0] licznik = 0;
reg zeruj = 0;
/*
	Proces zmiany stanu (bieżący stan)
*/
always@(posedge clk)
	if(~rst) 
		stan <= idle;
	else	
		begin
			stan <= nastepny_stan;
			if (zeruj == 1)
				licznik = 0;
			else
				licznik = licznik + 1;
		end

/*
	Proces kombinacyjny warunków i kontroli zmiany stanu (logika stanu następnego)
*/
always@(*)
begin
	nastepny_stan = stan;
	zeruj = 1;
	case(stan)
		idle: 
			if (button == 0) 
				nastepny_stan = wcisniety;
			else 
				nastepny_stan = idle;
		wcisniety:
			// dla symulacji licznik < 100, dla implementacji licznik < 2000000
			if(licznik < 100 && button == 0) 
				begin
					nastepny_stan = wcisniety;
					zeruj = 0;
				end
			else 
				if	(button == 0)
					nastepny_stan = wyswietlanie;
				else
					nastepny_stan = idle;
		wyswietlanie:
		// dla symulacji licznik < 1000, dla implementacji licznik < 10000000
			if (licznik < 1000)
				begin
					nastepny_stan = wyswietlanie;
					zeruj = 0;
				end
			else
				nastepny_stan = idle;
	endcase
end


/*
	Proces logiki wyjściowej (kombinacyjny)
*/

always@(*)
	begin
	if (stan == wyswietlanie)
		led = swiec;
	else
		led = nie_swiec;
end

endmodule







/*

	TU ZACZYNA SIĘ SYMULACJA

*/
module tb_maszyna_stanow();
	reg clk, rst, btn;
	wire led;
// nazwa_modulu instancja(porty); notacja pozycyjna - nie ma .button(btn), .clk(clk), .rst(rst), .led(led)
	maszyna_stanow test(btn, clk,rst, led);
// nazwa procesu testowego	
	initial begin: testy
// początkowe wymuszenia	
	clk = 0; rst = 0;
// po 50 nanosekundach rst = 1
	#50 rst = 1;
// po 100 nanosekundach btn = 0 (wcisniety)
	#100 btn = 0;
// po 600 nanosekundach btn = 0 (wcisniety)
	#600 btn = 1;
	end
// zegar co 5 ns zmienia swoj stan initial informuje, ze tu zaczynamy czas symulacji dla procesu zegara
	initial
	forever
		#5 clk=~clk;
	//end
endmodule


/*
Przyporządkowanie pinów

rst		B16
button	B15
clk		L3
led		M16


*/