/*
 * 
*/

module arbitro (
	input  clock,
	input  reset,
	input  rx,			//Pino de entrada do uart
	output tx,			//Pino de sa�da do uart
	output reg [10:0] dataread	//N�mero do sensor (000 para erro de colis�o), e byte recebido
);

wire [15:0] data;	//Dados recebidos
wire done_rx;		//Habilitado quando os dados s�o recebidos
uart_rx UART_RX (clock, reset, rx, data, done_rx);

wire result;		//Resultado do CRC
checksum CHECKSUM (data, result);

reg [7:0] sensor;	//N�mero do sensor (byte)
reg  enable;		//Habilita o envio do byte
wire active;		//Habilitado enquanto o byte est� sendo enviado
wire done_tx;		//Habilitado quando o byte foi enviado
uart_tx UART_TX (clock, reset, sensor, enable, active, done, tx);

endmodule