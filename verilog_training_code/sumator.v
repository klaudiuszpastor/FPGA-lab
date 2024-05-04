module sum(input A,B, Cin, output Y, Cout);
wire g1_o, g2_o,g3_o, g4_o;

and g1(g1_o,a,b);  // funkcja instancji bramka g1(nazwa własna), które będzie typu and (nazwa własna, funkcja logiczna) 
xor g4(g4_o,a,b);
and g2(g2_o,cin,g4_o);
or g3(Cout, g1_o,g2_o);
xor g5 g5(Y,Cin,g4_o);
endmodule
