/*
 * O árbitro lê os 8 bits menos significativos do 32 bits passados a ele.
 *
 * Os 10 bits menos significativos da reposta do árbitro de 32 bits, contém:
 * 		Dados  (8 bits menos significativos)
 * 		Status (2 bits mais significativos)
 */

#include <stdio.h>
#include "system.h"
#include "io.h"

#define status_mask 0x300 //Máscara de status
#define data_mask   0x0FF //Máscara de dado

int main() {
	int offset   = 0;
	int sensor   = 1; //Número do sensor
	int response = 0; //Resposta do árbitro
	int status   = 0; //Status

	while (1) {
		IOWR(ARBITRO_BASE, offset, sensor); //Solicita o dado do sensor

		do {
			response = IORD(ARBITRO_BASE, offset);
			status   = (status_mask & response) >> 8; //Calcula o status
		} while (status < 2);

		printf("Sensor: %d - Status: %d - Dado: %d\n",
				sensor, status, (data_mask & response));

		if (sensor < 4) sensor++;
		else sensor = 1;
	}

	/*
	while (1) {
		if (sensor < 5) {
			IOWR(ARBITRO_BASE, offset, sensor); //Solicita o dado do sensor

			do {
				response = IORD(ARBITRO_BASE, offset);	  //Lê a resposta
				status   = (status_mask & response) >> 8; //Calcula o status
				printf("Status: %d\n", status);  		  //Exibe o status
			} while (status < 2);

			printf("Status: %d\n", status);					//Exibe o status
			printf("Dado:   %d\n", (data_mask & response));	//Exibe o dado recebido
			sensor++;
		} else
			sensor = 0;
	}
	*/
	return 0;
}
