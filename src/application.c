#include "application_api.h"
#include "application.h"

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

#include "gpio.h"

#define LED_TASK_STACK_SIZE_WORDS (128)

static uint32_t stackBufferLedTask[LED_TASK_STACK_SIZE_WORDS];
static StaticTask_t bufferLedTask;
static StaticQueue_t bufferLedQueue;
static uint8_t ledQueueElements[4];

static ApplicationQueue_t applicationQueues[] = {
	{&bufferLedQueue, 1, 4, ledQueueElements, NULL},
};

static void ledTaskFunction( void * pvParameters )
{
	(void) pvParameters;

	for (;;)
	{
		uint32_t dummyBuffer;
		if (xQueueReceive(applicationQueues[APPLICATION_TASK_LED].queueHandle, &dummyBuffer, portMAX_DELAY) == pdPASS)
		{
			gpio_toggle_pin(GPIOA, 5);
			vTaskDelay(pdMS_TO_TICKS(1000));
			gpio_toggle_pin(GPIOA, 5);
		}
	}
}

static ApplicationTask_t applicationTasks[] = {
       /*  Function     Name   StackDepth              Parameteres        Priority  StackBuffer         TaskBuffer */
	{ledTaskFunction, "LED", LED_TASK_STACK_SIZE_WORDS, (void*)1,          PRIO_LOW, stackBufferLedTask, &bufferLedTask},
};

void Application_CreateTasks()
{
	for (unsigned int i = APPLICATION_TASK_FIRST; i < APPLICATION_TASK_LAST; i++) {
		applicationQueues[i].queueHandle = 
			xQueueCreateStatic(applicationQueues[i].queueLength,
				           applicationQueues[i].queueElementSize,
				           applicationQueues[i].elementsQueue,
				           applicationQueues[i].queueBuffer);

		xTaskCreateStatic (applicationTasks[i].function,
				   applicationTasks[i].name,
				   applicationTasks[i].stackDepth,
				   applicationTasks[i].parameters,
				   applicationTasks[i].priority,
				   applicationTasks[i].stackBuffer,
				   applicationTasks[i].taskBuffer);
	}
}

void Application_SendMessageToLedTask()
{
	uint32_t dummyElement = 0xdeadbeef;
	xQueueSendFromISR(applicationQueues[APPLICATION_TASK_LED].queueHandle, &dummyElement, NULL);
}
