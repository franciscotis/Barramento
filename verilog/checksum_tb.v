/*
 * Testbench do módulo crc
*/

`timescale 1ns/1ps

module checksum_tb ();

//Chave para o cálculo do CRC
localparam [7:0] key = 8'b00110111;	

//Entradas
reg [7:0] data, crc;

//Saídas
wire result;

//Instância do módulo
checksum #(key) dut (data, crc, result);

//Testes
initial begin
	$display("Início");

	//CRC correto
	data = 8'hAA;
	crc  = data ^ key;
	if (~result) $error("Error no cálculo do CRC de %b", data);	

	data = 8'hAD;
	crc  = data ^ key;
	if (~result) $error("Error no cálculo do CRC de %b", data);	

	data = 8'hAF;
	crc  = data ^ key;
	if (~result) $error("Error no cálculo do CRC de %b", data);	

	//CRC incorreto
	data = 8'hAA;
	crc  = data ^ (key - 1);
	if (result) $error("Error no cálculo do CRC de %b", data);	

	data = 8'hAD;
	crc  = data ^ (key - 2);
	if (result) $error("Error no cálculo do CRC de %b", data);	

	data = 8'hAF;
	crc  = data ^ (key - key);
	if (result) $error("Error no cálculo do CRC de %b", data);

	$display("Fim");
	$finish;
end

endmodule