                .syntax  unified
		.arch    armv7e-m
		.cpu     cortex-m4

                .section .vectors
                .globl   __Vectors
                .globl   __Vectors_End
                .globl   __Vectors_Size
__Vectors:
                .word    __StackTop                         /*     Top of Stack */
                .word    Reset_Handler                      /*     Reset Handler */
                .word    NMI_Handler                        /* -14 NMI Handler */
                .word    HardFault_Handler                  /* -13 Hard Fault Handler */
                .word    MemManage_Handler                  /* -12 MPU Fault Handler */
                .word    BusFault_Handler                   /* -11 Bus Fault Handler */
                .word    UsageFault_Handler                 /* -10 Usage Fault Handler */
                .word    0                                  /*     Reserved */
                .word    0                                  /*     Reserved */
                .word    0                                  /*     Reserved */
                .word    0                                  /*     Reserved */
                .word    SVC_Handler                        /*  -5 SVC Handler */
                .word    DebugMon_Handler                   /*  -4 Debug Monitor Handler */
                .word    0                                  /*     Reserved */
                .word    PendSV_Handler                     /*  -2 PendSV Handler */
                .word    SysTick_Handler                    /*  -1 SysTick Handler */

		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler
		.word    Default_Handler

__Vectors_End:
		.equ	 __Vectors_Size, __Vectors_End - __Vectors
		.size	 __Vectors, . - __Vectors

                .section .text

                .type    Reset_Handler, %function
                .globl   Reset_Handler
Reset_Handler:
		ldr      sp, =__StackTop      /* set stack pointer */

		ldr	 r4, =__copy_table_start__
		ldr	 r5, =__copy_table_end__
.L_loop0:
		cmp      r4, r5
		bge      .L_loop0_done
		ldr	 r1, [r4]	/* source address */
		ldr	 r2, [r4, #4]   /* destination address */
		ldr	 r3, [r4, #8]   /* number of words */
		lsls	 r3, r3, #2     /* *4 -> number of bytes */

.L_loop0_0:
		subs	 r3, #4
		ittt	 ge
		ldrge    r0, [r1, r3]
		strge	 r0, [r2, r3]
		bge	 .L_loop0_0

		adds	 r4, #12
		b	 .L_loop0
.L_loop0_done:

		ldr	 r3, =__zero_table_start__
		ldr	 r4, =__zero_table_end__
.L_loop2:
		cmp	 r3, r4
		bge	 .L_loop2_done
		ldr	 r1, [r3]	/* destination address */
		ldr	 r2, [r3, #4]    /* word count */
		lsls     r2, r2, #2	/* *2 -> byte count */
		movs	 r0, 0

.L_loop2_0:
		subs	 r2, #4
		itt	 ge
		strge    r0, [r1, r2]
		bge	 .L_loop2_0

		adds	 r3, #8
		b	 .L_loop2
.L_loop2_done:

                bl       SystemInit

                bl       main
		bx	 lr

                .size    Reset_Handler, . - Reset_Handler

/* The default macro is not used for HardFault_Handler
 * because this results in a poor debug illusion.
 */
                .type    HardFault_Handler, %function
                .weak    HardFault_Handler
HardFault_Handler:
                b        .
                .size    HardFault_Handler, . - HardFault_Handler

                .type    Default_Handler, %function
                .weak    Default_Handler
Default_Handler:
                b        .
                .size    Default_Handler, . - Default_Handler

/* Macro to define default exception/interrupt handlers.
 * Default handler are weak symbols with an endless loop.
 * They can be overwritten by real handlers.
 */
                .macro   Set_Default_Handler  Handler_Name
                .weak    \Handler_Name
                .set     \Handler_Name, Default_Handler
                .endm


/* Default exception/interrupt handler */

                Set_Default_Handler  NMI_Handler
                Set_Default_Handler  MemManage_Handler
                Set_Default_Handler  BusFault_Handler
                Set_Default_Handler  UsageFault_Handler
                Set_Default_Handler  SVC_Handler
                Set_Default_Handler  DebugMon_Handler
                Set_Default_Handler  PendSV_Handler
                Set_Default_Handler  SysTick_Handler

                .end
