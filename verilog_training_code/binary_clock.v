module binary_clock(
    input wire clk,
    output reg [3:0] LED
);

reg [3:0] licznik = 0;

always @(posedge clk)
begin
    licznik <= licznik + 1;

    // Przypisanie wartości licznika do LED
    LED <= licznik[0] ? 1 : 0;
    LED[1] <= licznik[1] ? 1 : 0;
    LED[2] <= licznik[2] ? 1 : 0;
    LED[3] <= licznik[3] ? 1 : 0;
end

endmodule
