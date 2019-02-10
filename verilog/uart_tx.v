/*
 * Implementa a parte de envio, do protocolo RS232
*/

module uart_tx (
	input  clock,
	input  enable,		//Habilitado para iniciar envio
	input  [7:0] data,	//Byte a ser enviado
	output active,		//Habilitado durante o envio
	output reg tx,		//Pino externo de saída do uart
	output done		//Habilitado para envio concluído
);

endmodule