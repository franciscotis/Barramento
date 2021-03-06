/*
 * M�dulo de controle do barramento
 * Status: 0 (Aguardando transmiss�o), 1 (Aguardado recebimento), 2 (OK), 3 (Erro de CRC)
*/

module control (
	//Entradas de controle
	input clock,
	input resetn,
	input enable,           //Inicia a solicita��o dos dados
	
	//Entradas de dados
	input [7:0] data_rx,
	input done_rx,
	input done_tx,
	
	//Sa�das de controle
	output reg resetn_rx,   //Reseta a recep��o
	output reg resetn_tx,   //Reseta a transmiss�o
	output reg enable_tx,   //Inicia a transmiss�o
	
	//Sa�das de dados
	output reg [7:0] data,  //Dado recebido
	output reg [1:0] status //Status
);

localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101; //Estados

reg [3:0] state; //Estado atual
reg [7:0] crc;   //CRC recebido

//M�dulos internos
localparam key = 8'b00110111;
wire result;
checksum #(key) CHECKSUM (.data(data), .crc(crc), .result(result));

//C�digo de controle
always @(posedge clock) begin
	if (!resetn) begin
		resetn_rx <= 1;
		resetn_tx <= 1;
		enable_tx <= 0;
		data      <= 0;
		crc       <= 0;
		status    <= 2; //Status - OK
		state     <= S0;
	end else begin
		case(state)
			//Estado de espera
			S0: begin
				resetn_rx <= 1;
				resetn_tx <= 1;
				enable_tx <= 0;
				
				//Verifica se um novo dado foi escrito pelo software
				if (enable) begin
					status    <= 0; //Status - Aguardando transmiss�o
					resetn_tx <= 0;
					state     <= S1;
				end else 
					state     <= S0;
			end
			
			//Habilita a transmiss�o
			S1: begin
				resetn_tx <= 1;
				enable_tx <= 1;
				state     <= S2;
			end
			
			//Aguarda o fim da transmiss�o
			S2: begin
				enable_tx <= 0;

				if (done_tx) begin 
					status    <= 1; //Status - Aguardado recebimento
					resetn_rx <= 0;
					state     <= S3;
				end else
					state     <= S2;
			end
			
			//Aguarda o recebimento do dado
			S3: begin
				resetn_rx <= 1;

				//Verifica se o dado foi recebido
				if (done_rx) begin
					data      <= data_rx;
					resetn_rx <= 0;
					state     <= S4;
				end else 
					state     <= S3;
			end
			
			//Aguarda o recebimento do crc
			S4: begin
				resetn_rx <= 1;

				//Verifica se o crc foi recebido
				if (done_rx) begin
					crc       <= data_rx;
					resetn_rx <= 0;
					state     <= S5;
				end else 
					state     <= S4;
			end
			
			S5: begin
				//Verifica a integridade do dado recebido
				if (result) status <= 2; //Status - OK
				else        status <= 3; //Status - Erro de CRC

				state <= S0;
			end

			default: state <= S0;
		endcase
	end
end

endmodule