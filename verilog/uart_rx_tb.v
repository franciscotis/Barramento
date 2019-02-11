/*
 * Testbench do módulo uart_rx
 * uart_clock_bit = 50 Mhz / 115200 baud
*/

module uart_rx_tb ();

parameter clock_half_period_ns = 10; 
parameter uart_clock_bit       = 434;

//Entradas
reg clock, reset, rx;

//Saídas
wire [7:0] readdata;
wire done;

//Instância do módulo
uart_rx #(uart_clock_bit) dut (clock, reset, rx, readdata, done);

//Gera o clock
always begin
	clock = 0; #clock_half_period_ns;
	clock = 1; #clock_half_period_ns;
end

//Recebe 1 byte
task receive;
	input  reg [7:0] data;
	integer i;

	begin
		//Envia o start bit
		rx = 0;
		repeat(uart_clock_bit) @(posedge clock);
		
		//Envia o byte
		for (i = 0; i < 8; i = i + 1) begin
			if (done)  $error("Erro - done = 1 durante o recebimento");
			
			rx = data[i];
			repeat(uart_clock_bit) @(posedge clock);
		end
				
		//Envia o stop bit
		rx = 1;
		repeat(uart_clock_bit) begin
			if (done) $display("done = 1 ao receber o stop bit");
			@(posedge clock);
		end
		
		if (data != readdata) $error("Erro - dado recebido != enviado");
	end
endtask

initial begin
	$display("Início (recebendo 5 bytes)");
	
	rx = 1;
	reset = 1;
	repeat(2) @(posedge clock);
	reset = 0;
	repeat(2) @(posedge clock);
	
	receive (8'hAA);
	receive (8'hAB);
	receive (8'hAC);
	receive (8'hAD);
	receive (8'hAF);
	
	$display("Fim");
	$finish;
end

endmodule