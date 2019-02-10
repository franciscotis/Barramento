/*
 * Implementa a parte de receber, do protocolo RS232
*/

module uart_rx (
	input  clock,
	input  rx,		//Pino externo de entrada do uart
	output done,		//Habilitado quando um novo byte é recebido
	output reg [7:0] data	//Byte recebido
);

endmodule