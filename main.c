#include <stdint.h>

volatile unsigned int counter;
volatile unsigned int main_canary;
volatile unsigned int systeminit_canary;

void main(void) {

	main_canary = 0xdeafbeef;

	for (;;) {
		counter++;
	}
}

void SystemInit(void) {
	systeminit_canary = 0xcafebabe;
}
