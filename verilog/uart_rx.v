/*
 * Implementa a parte de receptor, do protocolo RS232
*/

module uart_rx #(parameter clock_bit) (
	input  clock,
	input  reset,
	input  rx,			//Entrada do uart

	output reg [7:0] readdata,	//Byte recebido
	output reg done			//Habilitado quando o byte é recebido
);

//Estados de recebimento
parameter idle = 2'd0, start = 2'd1, data = 2'd2, stop = 2'd3; 

reg [1:0]  state;	//Estado atual
reg [2:0]  index;	//Bit recebido
reg [15:0] counter;	//Usado para aguardar clock_bit ciclos

reg rx_temp, rx_bit; 	//Armazena o valor de rx para evitar metaestabilidade

always @(posedge clock) begin
	rx_temp <= rx;
	rx_bit  <= rx_temp;
end

always @(posedge clock, posedge reset) begin
	if (reset) begin
		readdata <= 0;
		done     <= 0;
		index    <= 0;
		counter  <= 0;
		rx_temp  <= 1;
		rx_bit   <= 1;
		state    <= idle;
	end else begin
		case (state)
			//Estado inicial
			idle: begin
				done <= 0;
				
				//Verifica se recebeu o start bit
				if (~rx_bit) begin
					index   <= 0;
					counter <= 0;
					state   <= start;
				end else
					state   <= idle;
			end
			
			//Recebe o start bit (0)
			start: begin
				//Aguarda clock_bit/2 ciclos
				if (counter < clock_bit/2) begin
					counter <= counter + 1;
					state   <= start;
				end else begin
					//Verifica novamente o start bit
					if (~rx_bit) begin
						counter <= 0;
						state   <= data;
					end else
						state   <= idle;
				end
			end
			
			//Recebe 8 bits em sequência
			data: begin
				//Aguarda clock_bit ciclos
				if (counter < clock_bit) begin
					counter <= counter + 1;
					state   <= data;
				end else begin
					readdata[index] <= rx_bit;	//Armazena o bit
					counter <= 0;
					
					//Verifica se todos os bit foram recebidos
					if (index < 7) begin
						index <= index + 1;
						state <= data;
					end else
						state <= stop;
				end
			end
			
			//Recebe o stop bit (1)
			stop: begin
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