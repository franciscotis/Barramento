#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "lcd.h"
#include "uart.h"

char opt[5][8]  = {"Menu 01\n", "Menu 02\n", "Menu 03\n", "Menu 04\n", "Menu 05\n"};
char msg[5][12] = {"Mensagem 01\n", "Mensagem 02\n", "Mensagem 03\n", "Mensagem 04\n", "Mensagem 05\n"};

int main() {
	lcd_init();
	uart_write(WIFI_MODE, COMMAND, 1000);
	uart_write(WIFI_CONNECT, COMMAND, 6000000);

	int btn;
	int menu  = 1;
	int in    = 1;
	int index = 0;

	while(1){
		btn = IORD(PI_BASE, 0);
		usleep(100000);

		if(menu) {
			if(btn == 13) {
				if(index < 4) index++;
				else 		  index = 0;
				in = 1;
			} else if(btn == 14) {
				if(index > 0) index--;
				else 		  index = 4;
				in = 1;
			} else if(btn == 11) {
				menu = 0;
				in   = 1;
			}

			if(menu && in) {
				lcd_print(opt[index]);
				IOWR(PO_BASE, 0, 15);
				in = 0;
			}
		} else {
			if(btn == 7) {
				menu = 1;
				in   = 1;
			} else if(in) {
				lcd_print(msg[index]);
				IOWR(PO_BASE, 0, ~(index + 1));
				in = 0;

				uart_write(TCP_CONNECT, COMMAND, 2000000);

				uart_write(MQTT_CONNECT_SIZE, COMMAND, 2000000);
				uart_write(MQTT_CONNECT, DATA, 2000000);

				if(index == 0) {
					uart_write(MESSAGE_SIZE, COMMAND, 2000000);
					uart_write(MESSAGE_0, DATA, 2000000);
				} else if(index == 1) {
					uart_write(MESSAGE_SIZE, COMMAND, 2000000);
					uart_write(MESSAGE_1, DATA, 2000000);
				} else if(index == 2) {
					uart_write(MESSAGE_SIZE, COMMAND, 2000000);
					uart_write(MESSAGE_2, DATA, 2000000);
				} else if(index == 3) {
					uart_write(MESSAGE_SIZE, COMMAND, 2000000);
					uart_write(MESSAGE_3, DATA, 2000000);
				} else if(index == 4) {
					uart_write(MESSAGE_SIZE, COMMAND, 2000000);
					uart_write(MESSAGE_4, DATA, 2000000);
				}

				uart_write(MQTT_DISCONNECT_SIZE, COMMAND, 2000000);
				uart_write(MQTT_DISCONNECT, DATA, 2000000);

				uart_write(TCP_DISCONNECT, COMMAND, 2000000);
			}
		}
	}

	return 0;
}
