#ifndef UART_H_
#define UART_H_

#define COMMAND 1
#define DATA 0

#define WIFI_MODE "AT+CWMODE=3\r\n"
#define WIFI_CONNECT "AT+CWJAP=\"@\",\"derivada\"\r\n"

#define TCP_CONNECT "AT+CIPSTART=\"TCP\",\"10.0.0.3\",1883\r\n"
#define TCP_DISCONNECT "AT+CIPCLOSE\r\n"

#define MQTT_CONNECT_SIZE "AT+CIPSEND=20\r\n"
char MQTT_CONNECT[] = {0x10, 0x12, 0x00, 0x04, 'M', 'Q', 'T', 'T', 0x04, 0x02, 0x00, 0x14, 0x00, 0x06, 'N', 'i', 'o', 's', ' ', '2' , '\n'};

#define MESSAGE_SIZE "AT+CIPSEND=21\r\n"
char MESSAGE_0[] = {0x30, 0x13, 0x00, 0x06, 'P', 'B', 'L',' ', '0', '2', 'M', 'e', 'n', 's', 'a', 'g', 'e', 'm' ,' ', '0', '1', '\n'};
char MESSAGE_1[] = {0x30, 0x13, 0x00, 0x06, 'P', 'B', 'L',' ', '0', '2', 'M', 'e', 'n', 's', 'a', 'g', 'e', 'm' ,' ', '0', '2', '\n'};
char MESSAGE_2[] = {0x30, 0x13, 0x00, 0x06, 'P', 'B', 'L',' ', '0', '2', 'M', 'e', 'n', 's', 'a', 'g', 'e', 'm' ,' ', '0', '3', '\n'};
char MESSAGE_3[] = {0x30, 0x13, 0x00, 0x06, 'P', 'B', 'L',' ', '0', '2', 'M', 'e', 'n', 's', 'a', 'g', 'e', 'm' ,' ', '0', '4', '\n'};
char MESSAGE_4[] = {0x30, 0x13, 0x00, 0x06, 'P', 'B', 'L',' ', '0', '2', 'M', 'e', 'n', 's', 'a', 'g', 'e', 'm' ,' ', '0', '5', '\n'};

#define MQTT_DISCONNECT_SIZE "AT+CIPSEND=2\r\n"
char MQTT_DISCONNECT[] = {0xe0, 0x00, '\n'};

void uart_write(char *d, int c, int t);

#endif
