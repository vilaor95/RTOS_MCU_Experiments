#include "application.h"

#include "task.h"

void SystemInit(void)
{
}

int main(void)
{
	ApplicationCreateTasks();

	vTaskStartScheduler();

	for (;;);
}
