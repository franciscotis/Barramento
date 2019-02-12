#include <unistd.h>
#include "system.h"

void lcd_init() {
	ALT_CI_LCD(0,0x38);
	usleep(15000);

	ALT_CI_LCD(0,0x38);
	usleep(4100);

	ALT_CI_LCD(0,0x38);
	usleep(100);

	ALT_CI_LCD(0,0x38);
	usleep(5000);

	ALT_CI_LCD(0,0x08);
	usleep(100);

	ALT_CI_LCD(0,0x0C);
	usleep(100);

	ALT_CI_LCD(0,0x06);
	usleep(100);

	ALT_CI_LCD(0,0x02);
	usleep(100);

	ALT_CI_LCD(0,0x01);
	usleep(2000);
}

void lcd_print(char *m) {
	char *p = m;

	ALT_CI_LCD(0,0x02);
	usleep(2000);

	ALT_CI_LCD(0,0x01);
	usleep(2000);

	while(*p != '\n') {
		ALT_CI_LCD(1, *p);
		p++;
		usleep(2000);
	}

	ALT_CI_LCD(0,0x00);
	usleep(2000);
}
