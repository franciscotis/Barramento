/*
 * 
*/

module fsm (
	input clock,
	input reset,
	input data_rx,
	input active_tx,
	input done_tx,
	input result_crc,
	input  entry,			// Será utilizado para a mudança de estados
	output reg enable_tx,
	output reg [7:0] sensor,
	output result,

	//Entradas e saídas do uart RS232
	input  rx,	//Pino externo de entrada
	output tx	//Pino externo de saída
);
reg ddr_clk;
reg [2] cnt;
//Declaração do módulo emissor UART
wire [7:0] i_data_tx;	//Número do sensor
wire i_enable_tx;	//Habilita o envio do byte
wire o_active_tx;	//Habilitado enquanto o byte está sendo enviado
wire o_done_tx;		//Habilitado quando o byte foi enviado

//Declaração do módulodo receptor UART
wire [15:0] o_data_rx;	//2 bytes recebidos
wire o_done_rx;		//Habilitado quando os 2 bytes são recebidos

//Declaração do módulo de vericação do CRC
wire o_result_crc;	//Resultado da verficação

uart_tx UART_TX (.clock(clock), .reset(~reset), .data(i_data_tx), .enable(i_enable_tx), 
		.active(o_active_tx), .done(o_done_tx), .tx(tx));


uart_rx UART_RX (.clock(clock), .reset(~reset), .rx(rx), .data(o_data_rx), .done(o_done_rx));

	
checksum CHECKSUM (.data(o_data_rx[7:0]), .crc(o_data_rx[15:8]), .result(o_result_crc));

parameter [2:0] A = 3'b000, //Nomes dos estados 
		B = 3'b001,
		C = 3'b010,
		D = 3'b011,
		E = 3'b100,
		F = 3'b101,
		G = 3'b111;

reg [1:0] state,next;

localparam 	STATE_1 = 3'b000, //Parâmetros locais utilizados para a comparação com a entrada
		STATE_2 = 3'b001,
		STATE_3 = 3'b010,
		STATE_4 = 3'b011,
		STATE_5 = 3'b100,
		STATE_6 = 3'b101,
		STATE_7 = 3'b111;

always @(posedge clock or negedge reset)
	if (!reset) state <= A;
	else 	    state <= next;


always @(state) begin
	next = 3'bx;

case(state)
	A: 
	if(entry == STATE_1) next = A;
	else if(entry == STATE_2) next = B;
	else if(entry == STATE_3) next = C;
	else if(entry == STATE_4) next = D;
	else if(entry == STATE_5) next = E;
	else if(entry == STATE_6) next = F;
	B:
	if(entry == STATE_1) next = A;
	else 
begin
		sensor = i_data_tx;
		begin
	if(!reset)
		begin
			cnt <= 3'b0;
			ddr_clk <= 1'b0;
		end
	else
		begin
			cnt <= cnt+1'b1;
			if(cnt==3'b111)
			ddr_clk <= 1'b1;
			else
			ddr_clk <= 1'b0;
		end
end	
			if(!o_done_tx && o_active_tx)
			begin
			enable_tx = i_enable_tx;
			end	
begin
		sensor = i_data_tx;
		begin
	if(!reset)
		begin
			cnt <= 3'b0;
			ddr_clk <= 1'b0;
		end
	else
		begin
			cnt <= cnt+1'b1;
			if(cnt==3'b111)
			ddr_clk <= 1'b1;
			else
			ddr_clk <= 1'b0;
		end
end	
		if(o_done_rx)
			data_rx  =  o_data_rx;
		result = o_result_crc;
end
end
	C:
	if(entry == STATE_1) next = A;
	//else 
	D:
	if(entry == STATE_1) next = A;
	//else 
		
		
	E:
	if(entry == STATE_1) next = A;
	//else 
		
	F:
	if(entry == STATE_1) next = A;
	//else 
		

endcase
end


endmodule	