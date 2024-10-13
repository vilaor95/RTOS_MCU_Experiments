#include "stm32f4xx.h"

#include "FreeRTOS.h"
#include "task.h"

#include "application.h"
#include "utils.h"
#include "watchdog.h"

// debug variables
GPIO_TypeDef *gpioa = GPIOA;
GPIO_TypeDef *gpioc = GPIOC;
SYSCFG_TypeDef *syscfg = SYSCFG;
RCC_TypeDef *rcc = RCC;
EXTI_TypeDef *exti = EXTI;

void SystemInit(void)
{
	// GPIO configuration
	set_bit((uint32_t*)&RCC->AHB1ENR, 0); //Enable GPIOA
	set_bit((uint32_t*)&RCC->AHB1ENR, 2); //Enable GPIOC
	
	set_bits((uint32_t*)&GPIOA->MODER, 16, 2, 0x2); // Set PA8 in AF
	set_bits((uint32_t*)&GPIOC->MODER, 18, 2, 0x2); // Set PC9 in AF

	clear_bits((uint32_t*)&GPIOA->AFR[1], 0, 4); // Select AF0 (system)
	clear_bits((uint32_t*)&GPIOC->AFR[1], 4, 4); // Select AF0 (system)
					  
	// Clock configuration
	set_bits((uint32_t*)&RCC->CFGR, 24, 3, 0x6); //Set MC01 prescaler to /4
	set_bits((uint32_t*)&RCC->CFGR, 27, 3, 0x6); //Set MC02 prescaler to /4
	set_bits((uint32_t*)&RCC->CFGR, 4,  4, 0x8); //Set AHB prescaler to /2
	
	set_bits((uint32_t*)&GPIOA->MODER, 10, 2, 0x1); // Set PA5 in output mode
	set_bits((uint32_t*)&GPIOA->OSPEEDR, 10, 2, 0x3); // Set PA5 speed to high
	
	set_bits((uint32_t*)&GPIOC->MODER, 26, 2, 0x0); // Set PC13 in input mode
	set_bits((uint32_t*)&GPIOC->OSPEEDR, 26, 2, 0x3); // Set PC13 speed high
	set_bits((uint32_t*)&GPIOC->PUPDR, 26, 2, 0x1); // Set PC13 to pull up
		
	set_bit((uint32_t*)&RCC->APB2ENR, 14); // Set SYSCFG EN bit
	set_bits((uint32_t*)&SYSCFG->EXTICR[3], 4, 4, 0x2); // Set EXTI13 to GPIOC pin
	set_bit((uint32_t*)&EXTI->IMR, 13); // Set interrupt mask register
	set_bit((uint32_t*)&EXTI->RTSR, 13); // Set rising trigger
	clear_bit((uint32_t*)&EXTI->FTSR, 13); // Clear falling trigger
	NVIC_SetPriority(EXTI15_10_IRQn, 15);
	NVIC_EnableIRQ(EXTI15_10_IRQn);

	watchdog_start();
}

int main(void)
{
	ApplicationCreateTasks();

	vTaskStartScheduler();

	for (;;);
}

void vApplicationIdleHook( void )
{
	watchdog_reload();
}

void ButtonIRQHandler()
{
	if (EXTI->PR & (1<<13)) {
		//send event to queue
		EXTI->PR |= (1<<13);
	}
}
