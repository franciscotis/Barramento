/*
 * Implementa as entradas e sa�das para a interface avalon mm slave e uart RS232
*/

module avalon (
	//Entradas e sa�das da interface avalon mm
	input  clock,
	input  resetn,			//Reset em 0
	input  write, 			//Habilitado para escrita
	input  read, 			//Habilitado para leitura
	input  chipselect,		//Habilitado para escrita ou leitura
	input  [3:0] byteenable,	//Posicao do byte escrito em writedata
	input  [31:0] writedata,	//Palavra(4 bytes) de escrita
	output [31:0] readdata,		//Palavra(4 bytes) de leitura
	
	//Entradas e sa�das do uart RS232
	input  rx,	//Pino externo de entrada
	output tx	//Pino externo de sa�da
);

assign readdata[31:11] = 0;

arbitro ARBITRO (clock, ~reset, rx, tx, readdata[10:0]);

endmodule