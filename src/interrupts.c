#include "interrupts.h"

#include "utils.h"
#include "application_api.h"

void ButtonIRQHandler()
{
	if (EXTI->PR & (1<<13)) {
		EXTI->PR |= (1<<13);
	}
}

void enable_external_interrupts()
{
	set_bit((uint32_t*)&RCC->APB2ENR, 14); // Set SYSCFG EN bit
	set_bits((uint32_t*)&SYSCFG->EXTICR[3], 4, 4, 0x2); // Set EXTI13 to GPIOC pin
	set_bit((uint32_t*)&EXTI->IMR, 13); // Set interrupt mask register
	set_bit((uint32_t*)&EXTI->RTSR, 13); // Set rising trigger
	clear_bit((uint32_t*)&EXTI->FTSR, 13); // Clear falling trigger
	NVIC_SetPriority(EXTI15_10_IRQn, 14);
	NVIC_EnableIRQ(EXTI15_10_IRQn);
}
