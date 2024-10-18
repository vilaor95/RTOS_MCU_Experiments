#ifndef APPLICATION_API_H
#define APPLICATION_API_H

#include "FreeRTOS.h"

// Public functions
void Application_CreateTasks(void);

void Application_SendMessageToLedTask(void);

#endif /* APPLICATION_API_H */
