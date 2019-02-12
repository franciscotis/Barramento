/*
 * Arbitro de barramento
 * Implementa as entradas e saídas para a interface avalon mm slave e uart rs232
*/

module arbitro (
	//Entradas e saídas da interface avalon mm
	input  clock,
	input  resetn,				//Reset em 0
	input  write, 				//(Sem uso) Habilitado para escrita
	input  read, 				//(Sem uso) Habilitado para leitura
	input  chipselect,			//(Sem uso) Habilitado para escrita ou leitura
	input  [3:0]  byteenable,	//(Sem uso) Posicao do byte escrito em writedata
	input  [31:0] writedata,	//(Sem uso) Palavra(4 bytes) de escrita
	output [31:0] readdata,		//([10:0] em uso) Número do sensor (000 para erro de colisão) e byte recebido
	
	//Entradas e saídas do uart RS232
	input  rx,	//Pino externo de entrada
	output tx	//Pino externo de saída
);

//uart_clock_bit = 50 Mhz / 9600 baud
parameter uart_clock_bit = 5208;
parameter key = 8'b00110111;

//Declaração do módulodo receptor UART
wire [7:0] data_rx;	//Byte recebido
wire done_rx;		//Habilitado quando o byte é recebido
uart_rx #(uart_clock_bit) UART_RX (.clock(clock), .reset(~resetn), .rx(rx), .readdata(data_rx), .done(done_rx));

//Declaração do módulo emissor UART
wire [7:0] data_tx;	//Byte a ser enviado
wire enable_tx;		//Habilita o envio do byte
wire active_tx;		//Habilitado enquanto o byte está sendo enviado
wire done_tx;		//Habilitado quando o byte foi enviado
uart_tx #(uart_clock_bit) UART_TX (.clock(clock), .reset(~resetn), .writedata(data_tx), .enable(enable_tx), 
		.active(active_tx), .done(done_tx), .tx(tx));

//Declaração do módulo de vericação do CRC
wire [7:0] data_checksum;	//Dado recebido
wire [7:0] crc_checksum;	//CRC recebido
wire result_checksum;		//Resultado da verficação
checksum #(key) CHECKSUM (.data(data_checksum), .crc(crc_checksum), .result(result_checksum));

//Declaração do módulo de controle
wire [7:0] data_control;	//Dado recebido
wire [7:0] crc_control;		//CRC recebido
wire [1:0] status_control;	//Status do dado
control CONTROL (.clock(clock), .reset(~resetn), .enable(chipselect & write), .data_rx(data_rx), .done_rx(done_rx),
		.active_tx(active_tx), .done_tx(done_tx), .result_checksum(result_checksum), .data(data_control),
		.crc(crc_control), .status(status_control), .enable_tx(enable_tx));

//Controle de escrita em writedata
reg [31:0] writedata_reg; //Armazena o dado escrito pelo software

always @(posedge clock, negedge resetn) begin
	if (~resetn) begin
		writedata_reg <= 0;
	end else if (chipselect & write) begin
		writedata_reg <= writedata;
	end
end

//Atribuições contínuas
assign data_tx         = writedata_reg[7:0];	//Byte a ser enviado
assign data_checksum   = data_control;			//Dado recebido
assign crc_checksum    = crc_control;			//CRC recebido
assign readdata[7:0]   = data_control;			//Dado a ser lido
assign readdata[9:8]   = status_control;		//Status do dado
assign readdata[31:10] = 0; 					//Completa readdata com zeros

endmodule