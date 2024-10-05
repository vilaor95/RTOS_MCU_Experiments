#include "stm32f4xx.h"

#include "FreeRTOS.h"
#include "task.h"

#include "application.h"
#include "utils.h"
#include "watchdog.h"


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
	set_bits((uint32_t*)&GPIOA->OSPEEDR, 10, 2, 0x3); // Set PA5 in output mode

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
