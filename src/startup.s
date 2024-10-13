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
                .word    vPortSVCHandler                    /*  -5 SVC Handler */
                .word    DebugMon_Handler                   /*  -4 Debug Monitor Handler */
                .word    0                                  /*     Reserved */
                .word    xPortPendSVHandler                 /*  -2 PendSV Handler */
                .word    xPortSysTickHandler                /*  -1 SysTick Handler */

                /* Interrupts */
                .word    Default_Handler                 /*   0 Interrupt 0 */
                .word    Default_Handler                 /*   1 Interrupt 1 */
                .word    Default_Handler                 /*   2 Interrupt 2 */
                .word    Default_Handler                 /*   3 Interrupt 3 */
                .word    Default_Handler                 /*   4 Interrupt 4 */
                .word    Default_Handler                 /*   5 Interrupt 5 */
                .word    Default_Handler                 /*   6 Interrupt 6 */
                .word    Default_Handler                 /*   7 Interrupt 7 */
                .word    Default_Handler                 /*   8 Interrupt 8 */
                .word    Default_Handler                 /*   9 Interrupt 9 */
                .word    Default_Handler                 /*   10 Interrupt 10 */
                .word    Default_Handler                 /*   11 Interrupt 11 */
                .word    Default_Handler                 /*   12 Interrupt 12 */
                .word    Default_Handler                 /*   13 Interrupt 13 */
                .word    Default_Handler                 /*   14 Interrupt 14 */
                .word    Default_Handler                 /*   15 Interrupt 15 */
                .word    Default_Handler                 /*   16 Interrupt 16 */
                .word    Default_Handler                 /*   17 Interrupt 17 */
                .word    Default_Handler                 /*   18 Interrupt 18 */
                .word    Default_Handler                 /*   19 Interrupt 19 */
                .word    Default_Handler                 /*   20 Interrupt 20 */
                .word    Default_Handler                 /*   21 Interrupt 21 */
                .word    Default_Handler                 /*   22 Interrupt 22 */
                .word    Default_Handler                 /*   23 Interrupt 23 */
                .word    Default_Handler                 /*   24 Interrupt 24 */
                .word    Default_Handler                 /*   25 Interrupt 25 */
                .word    Default_Handler                 /*   26 Interrupt 26 */
                .word    Default_Handler                 /*   27 Interrupt 27 */
                .word    Default_Handler                 /*   28 Interrupt 28 */
                .word    Default_Handler                 /*   29 Interrupt 29 */
                .word    Default_Handler                 /*   30 Interrupt 30 */
                .word    Default_Handler                 /*   31 Interrupt 31 */
                .word    Default_Handler                 /*   32 Interrupt 32 */
                .word    Default_Handler                 /*   33 Interrupt 33 */
                .word    Default_Handler                 /*   34 Interrupt 34 */
                .word    Default_Handler                 /*   35 Interrupt 35 */
                .word    Default_Handler                 /*   36 Interrupt 36 */
                .word    Default_Handler                 /*   37 Interrupt 37 */
                .word    Default_Handler                 /*   38 Interrupt 38 */
                .word    Default_Handler                 /*   39 Interrupt 39 */
                .word    ButtonIRQHandler                /*   40 Interrupt 40 */
                .word    Default_Handler                 /*   41 Interrupt 41 */
                .word    Default_Handler                 /*   42 Interrupt 42 */
                .word    Default_Handler                 /*   43 Interrupt 43 */
                .word    Default_Handler                 /*   44 Interrupt 44 */
                .word    Default_Handler                 /*   45 Interrupt 45 */
                .word    Default_Handler                 /*   46 Interrupt 46 */
                .word    Default_Handler                 /*   47 Interrupt 47 */
                .word    Default_Handler                 /*   48 Interrupt 48 */
                .word    Default_Handler                 /*   49 Interrupt 49 */

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

		Set_Default_Handler  Interrupt0_Handler
                Set_Default_Handler  Interrupt1_Handler
                Set_Default_Handler  Interrupt2_Handler
                Set_Default_Handler  Interrupt3_Handler
                Set_Default_Handler  Interrupt4_Handler
                Set_Default_Handler  Interrupt5_Handler
                Set_Default_Handler  Interrupt6_Handler
                Set_Default_Handler  Interrupt7_Handler
                Set_Default_Handler  Interrupt8_Handler
                Set_Default_Handler  Interrupt9_Handler

                .end
