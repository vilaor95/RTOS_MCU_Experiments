#include <stdint.h>

unsigned int main_canary;

unsigned int global_canary = 0xcafebabe;
static unsigned int local_canary = 0xa5a5a5a5;

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
