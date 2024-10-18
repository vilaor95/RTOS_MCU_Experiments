#ifndef APPLICATION_H
#define APPLICATION_H

#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

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

typedef struct {
	StaticQueue_t*	        queueBuffer;
	size_t                  queueLength;
	size_t                  queueElementSize;
	uint8_t*		elementsQueue; 
	QueueHandle_t		queueHandle;
} ApplicationQueue_t;

enum {
	APPLICATION_TASK_FIRST = 0,
	APPLICATION_TASK_LED = APPLICATION_TASK_FIRST,
	APPLICATION_TASK_LAST
};

#endif /* APPLICATION_H */
