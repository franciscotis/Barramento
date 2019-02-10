/*
 * Arbitro de barramento
 * Implementa as entradas e sa�das para a interface avalon mm slave e uart RS232
*/

module arbitro (
	//Entradas e sa�das da interface avalon mm
	input  clock,
	input  resetn,			//Reset em 0
	input  write, 			//(Sem uso) Habilitado para escrita
	input  read, 			//(Sem uso) Habilitado para leitura
	input  chipselect,		//(Sem uso) Habilitado para escrita ou leitura
	input  [3:0]  byteenable,	//(Sem uso) Posicao do byte escrito em writedata
	input  [31:0] writedata,	//(Sem uso) Palavra(4 bytes) de escrita
	output [31:0] readdata,		//([10:0] em uso) N�mero do sensor (000 para erro de colis�o) e byte recebido
	
	//Entradas e sa�das do uart RS232
	input  rx,	//Pino externo de entrada
	output tx	//Pino externo de sa�da
);

//Declara��o do m�dulodo receptor UART
wire [15:0] o_data_rx;	//2 bytes recebidos
wire o_done_rx;		//Habilitado quando os 2 bytes s�o recebidos
uart_rx UART_RX (.clock(clock), .reset(~reset), .rx(rx), .data(o_data_rx), .done(o_done_rx));


//Declara��o do m�dulo emissor UART
wire [7:0] i_data_tx;	//N�mero do sensor
wire i_enable_tx;	//Habilita o envio do byte
wire o_active_tx;	//Habilitado enquanto o byte est� sendo enviado
wire o_done_tx;		//Habilitado quando o byte foi enviado
uart_tx UART_TX (.clock(clock), .reset(~reset), .data(i_data_tx), .enable(i_enable_tx), 
		.active(o_active_tx), .done(o_done_tx), .tx(tx));


//Declara��o do m�dulo de verica��o do CRC
wire o_result_crc;	//Resultado da verfica��o
checksum CHECKSUM (.data(o_data_rx[7:0]), .crc(o_data_rx[15:8]), .result(o_result_crc));


//Declara��o da FSM de controle do �rbitro
wire [7:0] o_sensor_fsm; //N�mero do sensor
fsm FSM (.clock(clock), .reset(~reset), .done_rx(o_done_rx), .active_tx(o_active_tx), .done_tx(o_done_tx),
	.result_crc(o_result_crc), .enable_tx(i_enable_tx), .sensor(o_sensor_fsm));


//Atribui��es cont�nuas
assign i_data_tx = o_sensor_fsm;	//N�mero do sensor a ser enviado por tx

assign readdata[31:11] = 0; 		//Completa a palavra com zeros
assign readdata[7:0]   = o_data_rx[7:0];	//Dado recebido
assign readdata[10:8]  = o_sensor_fsm;	//N�mero do sensor que enviou o dado, em caso de colis�o a fsm coloca 000

endmodule