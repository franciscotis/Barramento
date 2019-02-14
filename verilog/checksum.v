/*
 * Calcula o CRC de data, compara com o crc recebido 
 * e coloca a resultado da comparação em result
*/

module checksum #(parameter [7:0] key) (
	input  [7:0] data, //Dado recebido
	input  [7:0] crc,  //CRC recebido

	output result      //Resultado
);

assign result = (data ^ key) == crc;	//Calcula o CRC e compara com o recebido

endmodule