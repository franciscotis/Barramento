/*
 * Testbench do m�dulo crc
*/

`timescale 1ns/1ps

module checksum_tb ();

//Chave para o c�lculo do CRC
localparam [7:0] key = 8'b00110111;	

//Entradas
reg [7:0] data, crc;

//Sa�das
wire result;

//Inst�ncia do m�dulo
checksum #(key) dut (data, crc, result);

//Testes
initial begin
	$display("In�cio");

	//CRC correto
	data = 8'hAA;
	crc  = data ^ key;
	if (~result) $error("Error no c�lculo do CRC de %b", data);	

	data = 8'hAD;
	crc  = data ^ key;
	if (~result) $error("Error no c�lculo do CRC de %b", data);	

	data = 8'hAF;
	crc  = data ^ key;
	if (~result) $error("Error no c�lculo do CRC de %b", data);	

	//CRC incorreto
	data = 8'hAA;
	crc  = data ^ (key - 1);
	if (result) $error("Error no c�lculo do CRC de %b", data);	

	data = 8'hAD;
	crc  = data ^ (key - 2);
	if (result) $error("Error no c�lculo do CRC de %b", data);	

	data = 8'hAF;
	crc  = data ^ (key - key);
	if (result) $error("Error no c�lculo do CRC de %b", data);

	$display("Fim");
	$finish;
end

endmodule