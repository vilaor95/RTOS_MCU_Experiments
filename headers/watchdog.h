#ifndef WATCHDOG_H
#define WATCHDOG_H

#include "stm32f4xx.h"

#define WATCHDOG_START_VALUE	(0xCCCC)
#define WATCHDOG_RELOAD_VALUE	(0xAAAA)
#define WATCHDOG_ACCESS_VALUE	(0x5555)

enum {
	WATCHDOG_PREESCALER_BY_4   = 0, //Max timeout 512ms
	WATCHDOG_PREESCALER_BY_8   = 1, //Max timeout 1024ms
	WATCHDOG_PREESCALER_BY_16  = 2, //Max timeout 2048ms
	WATCHDOG_PREESCALER_BY_32  = 3, //Max timeout 4096ms
	WATCHDOG_PREESCALER_BY_64  = 4, //Max timeout 8192ms
	WATCHDOG_PREESCALER_BY_128 = 5, //Max timeout 16384ms
	WATCHDOG_PREESCALER_BY_256 = 6, //Max timeout 32768ms
};

static inline void watchdog_reload(void)
{
	IWDG->KR = WATCHDOG_RELOAD_VALUE;
}

static inline void watchdog_start(void)
{
	IWDG->PR = WATCHDOG_PREESCALER_BY_8;
	IWDG->KR = WATCHDOG_START_VALUE;
}

#endif /* WATCHDOG_H */
