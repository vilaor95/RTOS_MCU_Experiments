#ifndef APPLICATION_H
#define APPLICATION_H

#include "FreeRTOS.h"

void ApplicationCreateTasks(void);

typedef enum {
	PRIO_IDLE = 0,
	PRIO_LOW  = 1,
	PRIO_MID  = 2,
	PRIO_HIGH = 3,
} ApplicationPriority_t;

typedef struct {
	TaskFunction_t		function;
	const char * const	name;
	const size_t		stackDepth;
	void * const		parameters;
	UBaseType_t		priority;
	StackType_t * const	stackBuffer;
	StaticTask_t *const     taskBuffer;
} ApplicationTask_t;

#endif /* APPLICATION_H */
