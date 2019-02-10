/*
 * 
*/

module arbitro (
	input  clock,
	input  reset,
	input  write,			//Habilitado quando ocorre uma escrita
	input  [7:0] writedata,		//Byte escrito
	output reg [7:0] readdata,	//Byte a ser lido
	output reg done,		//Habilitado quando um novo byte deve ser lido
	output reg con_error,		//Indica erro de conex�o
	output reg crc_error,		//Indica erro de colis�o

	input  rx,			//Pino de entrada do uart
	output tx			//Pino de sa�da do uart
);

reg [7:0] data, crc;	//Dado e CRC recebidos
reg result_crc;		//Resultado do CRC
checksum CHECKSUM (.data(data), .crc(crc), .result(crc_result));

reg done_rx;		//Habilitado quando o byte � recebido
reg [7:0] data_rx; 	//Byte recebido
uart_rx UART_RX (.clock(clock), .rx(rx), .done(done_rx), .data(data_rx));

reg  enable_tx;	//Habilita o envio do byte
wire active_tx;	//Habilitado enquanto o byte est� sendo enviado
wire done_tx;	//Habilitado quando o byte foi enviado
uart_tx UART_TX (.clock(clock), .enable(enable_tx), .data(writedata), .active(active_tx), .tx(tx), .done(done_tx));

endmodule