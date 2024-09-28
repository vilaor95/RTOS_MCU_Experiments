#include "application.h"

#include "task.h"

#define TASK1_STACK_SIZE_WORDS (128)
#define TASK2_STACK_SIZE_WORDS (128)

static uint32_t stackBufferTask1[TASK1_STACK_SIZE_WORDS];
static StaticTask_t bufferTask1;

static uint32_t stackBufferTask2[TASK2_STACK_SIZE_WORDS];
static StaticTask_t bufferTask2;

TaskHandle_t task2Handle;

static void taskFunction1( void * pvParameters )
{
	(void) pvParameters;

	unsigned int counter = 0;

	for (;;) {
		if (pvParameters == (void*)1)
			counter++;
		else
			counter--;
	}
}

static ApplicationTask_t applicationTasks[] = {
       /*  Function     Name     StackDepth              Parameteres Priority  StackBuffer       TaskBuffer */
	{taskFunction1, "Task1", TASK1_STACK_SIZE_WORDS, (void*)1,          PRIO_LOW, stackBufferTask1, &bufferTask1},
	{taskFunction1, "Task2", TASK2_STACK_SIZE_WORDS, (void*)2,          PRIO_LOW, stackBufferTask2, &bufferTask2},
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
