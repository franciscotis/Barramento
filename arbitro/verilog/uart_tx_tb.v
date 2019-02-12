/*
 * Testbench do módulo uart_tx
 * uart_clock_bit = 50 Mhz / 9600 baud
*/

`timescale 1ns/1ps

module uart_tx_tb ();

parameter clock_half_period_ns = 10; 
parameter uart_clock_bit       = 5208;

//Entradas
reg clock, reset, enable;
reg [7:0] writedata;

//Saídas
wire active, done, tx;

//Instância do módulo
uart_tx #(uart_clock_bit) dut (.clock(clock), .reset(reset), .writedata(writedata), .enable(enable), .active(active), .done(done), .tx(tx));

//Gera o clock
always begin
	clock = 0; #clock_half_period_ns;
	clock = 1; #clock_half_period_ns;
end

//Envia 1 byte
task send;
	input  reg [7:0] data;
	reg [10:0] result;
	integer i, d;

	begin		
		d = 0;				//Verifica o número de vezes que done foi ativado durante o stop bit
		result = 0;
		writedata = data;	//Passa o byte para o uart_tx
		enable   = 1;		//Habilita o envio
		@(posedge clock);
		enable   = 0;		//Desabilita o envio
		
		//Recebe o 1 idle bit, 1 start bit, 8 bits de dados e 1 stop bit
		for (i = 0; i < 11; i = i + 1) begin
			if (i != 0 & ~active) $error("Erro - active = 0 durante o envio"); //i = 0 é o idle bit
			if (done)             $error("Erro - done = 1 durante o envio");   // Verifica o valor de done até o envio do oitavo bit de dado

			result[i] = tx;
			repeat(uart_clock_bit) begin 
				if (done) d = d + 1;	//Verifica o valor de done após o envio do oitavo bit de dado
				@(posedge clock);
			end
		end

		if (d != 1) $error("Erro - done foi ativado %d vezes", d);
		if (~result[0])  $error("Erro - bit de idle = 0");
		if (result[1])   $error("Erro - start bit = 1");
		if (~result[10]) $error("Erro - stop bit = 0");
		if (result[9:2] != writedata) $error("Erro - dado recebido != enviado");
	end
endtask

//Testes
initial begin
	$display("Início");

	reset = 1;
	repeat(2) @(posedge clock);
	reset = 0;
	repeat(2) @(posedge clock);
	
	send (8'hAA);
	send (8'hAB);
	send (8'hAC);
	send (8'hAD);
	send (8'hAF);
	
	$display("Fim");
	$finish;
end

endmodule	