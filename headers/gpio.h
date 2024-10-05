#ifndef GPIO_H
#define GPIO_H

#include "stm32f4xx.h"

#include "utils.h"

static inline void gpio_toggle_pin(GPIO_TypeDef *port, unsigned int pinNumber)
{
	if (port->ODR & (1<<pinNumber)) {
		set_bit((uint32_t*)&port->BSRR, pinNumber + 16);
	} else {
		set_bit((uint32_t*)&port->BSRR, pinNumber);
	}
}

#endif /* GPIO_H */
