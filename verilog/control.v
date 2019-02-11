/*
 * Módulo de controle do barramento
 * Status: 0 (Aguardando transmissão), 1 (Aguardado recebimento), 2 (OK), 3 (Erro de CRC)
*/

module control (
	input clock,
	input reset,
	input enable,			//Inicia a solicitação dos dados
	input [7:0] data_rx,
	input done_rx,
	input active_tx,
	input done_tx,
	input result_checksum,

	output reg [7:0] data,		//Dado recebido
	output reg [7:0] crc,		//CRC recebido
	output reg [1:0] status,	//Status
	output reg enable_tx		//Iniciar transmissão
);

//Estados de controle
parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7;

reg [3:0] state;	//Estado atual

always @(posedge clock, posedge reset) begin
	if (reset) begin
		data      <= 0;
		crc       <= 0;
		status    <= 2; //Status - OK
		enable_tx <= 0;
		state     <= S0;
	end else begin
		case(state)
			//Estado de espera
			S0: begin
				//Verifica se um novo valor foi escrito pelo software
				if (enable) state <= S1;
				else state <= S0;
			end
			
			//Aguarda para transmitir
			S1: begin
				status <= 0; //Status - Aguardando transmissão

				if (active_tx | done_tx) state <= S1;
				else state <= S2;
			end
			
			//Habilita a trasmissão
			S2: begin
				enable_tx <= 1;
				state <= S3;
			end
			
			//Desabilita a trasmissão
			S3: begin
				enable_tx <= 0;
				state <= S4;
			end
			
			//Aguarda o fim da trasmissão
			S4: begin
				if (done_tx) state <= S5;
				else state <= S4;
			end
			
			//Aguarda o recebimento do dado
			S5: begin
				status <= 1; //Status - Aguardado recebimento
				
				//Verifica se um novo valor foi escrito pelo software 
				if (enable) 
					state <= S1;
				else begin
					//Verifica se o dado foi recebido
					if (done_rx) begin
						data  <= data_rx;
						state <= S6;
					end else 
						state <= S5;
				end
			end
			
			//Aguarda o recebimento do crc
			S6: begin
				//Verifica se um novo valor foi escrito pelo software 
				if (enable)
					state <= S1;
				else begin
					//Verifica se o crc foi recebido
					if (done_rx) begin
						crc   <= data_rx;
						state <= S7;
					end else 
						state <= S6;
				end
			end
			
			S7: begin
				//Verifica a integridade do dado recebido
				if (result_checksum) status <= 2; //Status - OK
				else status <= 3;		  //Status - Erro corrompido	

				state <= S0;
			end

			default: state <= S0;
		endcase
	end
end

endmodule