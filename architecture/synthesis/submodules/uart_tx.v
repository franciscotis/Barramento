/*
 * Implementa a parte de emissor, do protocolo rs232
*/

module uart_tx #(parameter [15:0] clock_bit) (
	input        clock,
	input        resetn,
	input  [7:0] writedata,	//Byte a ser enviado
	input        enable,	//Habilitado para iniciar envio

	output reg   done,	//Habilitado quando o envio � conclu�do
	output reg   tx		//Pino externo de sa�da do uart
);

localparam idle = 2'b00, start = 2'b01, data = 2'b10, stop = 2'b11;  //Estados

reg [1:0]  state;   //Estado atual
reg [7:0]  send;    //Byte a ser enviado
reg [2:0]  index;   //Bit a ser enviado
reg [15:0] counter; //Usado para aguardar clock_bit ciclos

always @(posedge clock) begin
	if (!resetn) begin
		done    <= 0;
		tx      <= 1; 
		send    <= 0;
		index   <= 0;
		counter <= 0;
		state   <= idle;
	end else begin
		case (state)
			//Estado inicial
			idle: begin
				done    <= 0;
				tx      <= 1;
				index   <= 0;
				counter <= 0;
				
				//Verifica se a trasmiss�o deve ser iniciada
				if (enable) begin
					send  <= writedata;
					state <= start;
				end else
					state <= idle;
			end
			
			//Envia o start bit (0)
			start: begin
				tx <= 0;
				
				//Aguarda clock_bit ciclos
				if (counter < clock_bit) begin
					counter <= counter + 1;
					state   <= start;
				end else begin
					counter <= 0;
					state   <= data;
				end
			end
			
			//Envia 8 bits em sequ�ncia
			data: begin
				tx <= send[index]; //Envia um bit
				
				//Aguarda clock_bit ciclos
				if (counter < clock_bit) begin
					counter <= counter + 1;
					state   <= data;
				end else begin
					counter <= 0;
					
					//Verifica se todos o bits foram enviados
					if (index < 7) begin
						index <= index + 1;
						state <= data;
					end else
						state <= stop;
				end
			end
			
			//Envia o stop bit (1)
			stop: begin
				tx <= 1;

				//Aguarda clock_bit ciclos
				if (counter < clock_bit) begin
					counter <= counter + 1;
					state   <= stop;
				end else begin
					done    <= 1;
					state   <= idle;
				end
			end
	
			default: state <= idle;
		endcase
	end
end

endmodule