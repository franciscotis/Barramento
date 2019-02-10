module lcd(
	input clk,							//Entrada do clock da fpga
	input clk_en,						//Clock enable vai ser chamado quando a função customizada for chamada
	input [31:0] dataa,				//Dataa
	input [31:0] datab,				//Datab
	
	output     rw,						//Read(1) e Write(0)
	output reg en,						//Enable 
	output reg rs,						//Seleção - Comando(0) e Dado(1)
	output reg [7:0] db
);
	
	assign rw = 1'b0;	
	reg    st = 1'b0;
	
	always @(posedge clk) begin	// A cada subida de clock
		if(clk_en) begin				// Quando a instrução customizada for chamada, o clk_en é acionado
			en <= 1'b0; 				
			st <= 1'b1;
		end else if(st) begin		// Executa ciclo de clock após a instrução ter sido chamada
			en <= 1'b1;
			st <= 1'b0;
			rs <= dataa[0];
			db <= datab[7:0];
		end
	end
	
endmodule	