/*
 * Testbench do módulo uart_rx
 * uart_clock_bit = 50 Mhz / 9600 baud
*/

`timescale 1ns/1ps

module uart_rx_tb ();

localparam clock_half_period_ns  = 10; 
localparam [15:0] uart_clock_bit = 5208;

//Entradas
reg clock, resetn, rx;

//Saídas
wire [7:0] readdata;
wire done;

//Instância do módulo
uart_rx #(uart_clock_bit) dut (.clock(clock), .resetn(resetn), .rx(rx), .readdata(readdata), .done(done));

//Gera o clock
always begin
	clock = 0; #clock_half_period_ns;
	clock = 1; #clock_half_period_ns;
end

//Recebe 1 byte
task receive;
	input reg [7:0] data;

	integer i, d;

	begin
		d = 0; //Verifica o número de vezes que done foi ativado durante o stop bit

		rx = 0; repeat(uart_clock_bit) @(posedge clock); //Envia o start bit
		
		//Envia o byte
		for (i = 0; i < 8; i = i + 1) begin
			if (done) $error("Erro - done = 1 durante o recebimento"); //Verifica o valor de done durante o recebimento dos bits de dados

			rx = data[i]; repeat(uart_clock_bit) @(posedge clock);
		end
				
		rx = 1; //Envia o stop bit
		repeat(uart_clock_bit) begin
			@(posedge clock);
			if (done) d = d + 1; //Verifica o valor de done durante o recebimento do stop bit
		end

		if (d != 1)           $error("Erro - done foi ativado %d vezes", d);
		if (data != readdata) $error("Erro - dado recebido != dado enviado");
	end
endtask

initial begin
	$display("Início");
	
	rx     = 1;
	resetn = 0; repeat(1) @(posedge clock);
	resetn = 1; repeat(1) @(posedge clock);
	
	receive (8'hAA);
	receive (8'hAB);
	receive (8'hAC);
	receive (8'hAD);
	receive (8'hAF);
	
	$display("Fim");
	$finish;
end

endmodule