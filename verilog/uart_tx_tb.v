/*
 * Testbench do m�dulo uart_tx
 * uart_clock_bit = 50 Mhz / 115200 baud
*/

`timescale 1ns/1ps

module uart_tx_tb ();

parameter clock_half_period_ns = 10; 
parameter uart_clock_bit       = 434;

//Entradas
reg clock, reset, enable;
reg [7:0] readdata;

//Sa�das
wire active, done, tx;

//Instancia o m�dulo
uart_tx #(uart_clock_bit) dut (clock, reset, readdata, enable, active, done, tx);

//Envia 1 byte
task send;
	input  reg [7:0] data;
	reg [10:0] result;
	integer i;

	begin		
		$display("data (%b)", data);

		result = 0;
		readdata = data;
		enable   = 1;
		@(posedge clock);
		enable   = 0;
		
		for (i = 0; i < 11; i = i + 1) begin
			$display("tx(%b), active(%b), done(%b)", tx, active, done);
			result[i] = tx;
			repeat(uart_clock_bit) @(posedge clock);
		end

		$display("result (%b)", result);
	end
endtask

//Gera o clock
always begin
	clock = 0; #clock_half_period_ns;
	clock = 1; #clock_half_period_ns;
end

//Testes
initial begin
	reset = 1;
	repeat(2) @(posedge clock);
	reset = 0;
	repeat(2) @(posedge clock);
	
	$display("Envio 1");
	send (8'b00001111);
	$display("");

	$display("Envio 2");
	send (8'b11110000);
	$display("");

	$display("Envio 3");
	send (8'b01010101);
	$display("");

	$finish;
end

endmodule	