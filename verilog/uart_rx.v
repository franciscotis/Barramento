/*
 * Implementa a parte de receptor, do protocolo RS232
*/

module uart_rx (
	input  clock,
	input  reset,
	input  rx,		//Entrada do uart
	output reg [15:0] data,	//Bytes recebido
	output reg done		//Habilitado quando dois bytes s�o recebidos
);

endmodule