#include "stm32f4xx.h"

#include "FreeRTOS.h"
#include "task.h"

#include "application.h"
#include "utils.h"
#include "watchdog.h"


RCC_TypeDef* rcc = RCC;

GPIO_TypeDef* gpioa = GPIOA;
GPIO_TypeDef* gpioc = GPIOC;

void SystemInit(void)
{
	// GPIO configuration
	set_bit((uint32_t*)&rcc->AHB1ENR, 0); //Enable GPIOA
	set_bit((uint32_t*)&rcc->AHB1ENR, 2); //Enable GPIOC
	
	set_bits((uint32_t*)&gpioa->MODER, 16, 2, 0x2); // Set PA8 in AF
	set_bits((uint32_t*)&gpioc->MODER, 18, 2, 0x2); // Set PC9 in AF

	clear_bits((uint32_t*)&gpioa->AFR[1], 0, 4); // Select AF0 (system)
	clear_bits((uint32_t*)&gpioc->AFR[1], 4, 4); // Select AF0 (system)
					  
	// Clock configuration
	set_bits((uint32_t*)&rcc->CFGR, 24, 3, 0x6); //Set MC01 prescaler to /4
	set_bits((uint32_t*)&rcc->CFGR, 27, 3, 0x6); //Set MC02 prescaler to /4
	set_bits((uint32_t*)&rcc->CFGR, 4,  4, 0x8); //Set AHB prescaler to /2

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
