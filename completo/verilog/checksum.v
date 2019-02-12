/*
 * Calcula o CRC de data, compara com o crc recebido 
 * e coloca a resultado da compara��o em result
*/

module checksum (
	input  [7:0] data,	//Dado recebido
	input  [7:0] crc,	//CRC recebido

	output result		//Resultado
);

parameter [7:0] key = 8'b00110111;	//Chave para o c�lculo do CRC

assign result = (data ^ key) == crc;	//Calcula o CRC e compara com o recebido

endmodule