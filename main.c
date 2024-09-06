#include <stdint.h>

volatile unsigned int main_canary;
volatile unsigned int systeminit_canary = 0xcafebabe;

void main(void) {
	main_canary = 0xdeafbeef;

	unsigned int counter = 0;
	for (;;) {
		counter++;
	}
}

void SystemInit(void) {
	main_canary = 0xcafebabe;
}
