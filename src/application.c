#include "application_api.h"
#include "application.h"

#include "FreeRTOS.h"
#include "task.h"

#include "gpio.h"

#define TASK1_STACK_SIZE_WORDS (128)

static uint32_t stackBufferTask1[TASK1_STACK_SIZE_WORDS];
static StaticTask_t bufferTask1;

static void taskFunction1( void * pvParameters )
{
	(void) pvParameters;

	for (;;)
	{
		gpio_toggle_pin(GPIOA, 5);
		vTaskDelay(pdMS_TO_TICKS(1000));
	}
}

static ApplicationTask_t applicationTasks[] = {
       /*  Function     Name     StackDepth              Parameteres Priority  StackBuffer       TaskBuffer */
	{taskFunction1, "Task1", TASK1_STACK_SIZE_WORDS, (void*)1,          PRIO_LOW, stackBufferTask1, &bufferTask1},
};

void ApplicationCreateTasks()
{
	for (unsigned int i = 0; i < sizeof(applicationTasks)/sizeof(applicationTasks[0]); i++) {
		xTaskCreateStatic (applicationTasks[i].function,
				   applicationTasks[i].name,
				   applicationTasks[i].stackDepth,
				   applicationTasks[i].parameters,
				   applicationTasks[i].priority,
				   applicationTasks[i].stackBuffer,
				   applicationTasks[i].taskBuffer);
	}
}
