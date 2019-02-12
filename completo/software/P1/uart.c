#include <stdio.h>
#include "altera_avalon_uart_regs.h"
#include "system.h"

void uart_write(char *d, int c, int t) {
	char *p = d;

	while(1) {
		while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK));

		if(*p == '\n') {
			if(c) IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, *p);
			break;
		}

		IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, *p);
		p++;
	}

	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK));

	while(t--) {
		if(IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)
			printf("%c", IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE));
	}
}
