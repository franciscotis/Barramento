
module control_tb();

parameter uart_clock_bit = 5208;

parameter clock_half_period_ns = 10; 
reg clock, reset, enable, done_rx, active_tx, done_tx, result_checksum;
reg [7:0] data_rx;

wire[7:0]data, crc;
wire[1:0] status;
wire enable_tx;
control cont(clock,reset,enable,data_rx, done_rx,active_tx, done_tx,result_checksum,data,crc,status,enable_tx);

always begin
	clock <= 0; #clock_half_period_ns;
	clock <= 1; #clock_half_period_ns;
end

task fsm;
input reg[7:0] data;
integer i;
begin
	enable = 1;
	active_tx = 1;
	done_tx =1;
	repeat(uart_clock_bit) @(posedge clock);
	if(status!= 0)  $error("O status deveria ser Aguardando Transmiss�o- C�digo 0 ------ %d",status); 
	active_tx =0;
	done_tx = 0;
	repeat(uart_clock_bit) @(posedge clock);
	done_tx = 1;
	repeat(uart_clock_bit) @(posedge clock);
	if(status!= 1)  $error("O status deveria ser Aguardando Recebimento - C�digo 1 ------ %d",status);
	done_rx =1;	
	data_rx = data;
	enable = 0;
	done_rx =1;
	result_checksum = 1;
	if(status==3) $error("Erro de CRC --- $d",status);
	$display("%d",status);


	
end


endtask

initial begin
$display("Testes do Controle");
reset =1;
repeat(2) @(posedge clock);
reset = 0;
repeat(2) @(posedge clock);
fsm(8'hAA);


$finish;
end

endmodule