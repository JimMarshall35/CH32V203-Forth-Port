/********************************** (C) COPYRIGHT *******************************
 * File Name          : main.c
 * Author             : WCH
 * Version            : V1.0.0
 * Date               : 2021/06/06
 * Description        : Main program body.
 *********************************************************************************
 * Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
 * Attention: This software (modified or not) and binary are used for 
 * microcontroller manufactured by Nanjing Qinheng Microelectronics.
 *******************************************************************************/

/*
 *@Note
 *USART Print debugging routine:
 *USART1_Tx(PA9).
 *This example demonstrates using USART1(PA9) as a print debug port output.
 *
 */

#include "debug.h"

/* Global typedef */

/* Global define */
#define RAM_END 0x20002000
#define UART_BASE_CDEF 0x40004400

/* Global Variable */
const char* gTitleString = "RISC-V Forth CH32V203\n\r";

/*********************************************************************
 * @fn      main
 *
 * @brief   Main program.
 *
 * @return  none
 */
int main(void)
{
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
    SystemCoreClockUpdate();
    Delay_Init();
    USART_Printf_Init(115200);
    // printf("SystemClk:%d\r\n", SystemCoreClock);
    // printf( "ChipID:%08x\r\n", DBGMCU_GetCHIPID() );
    // printf("This is printf example\r\n");
    /*
        getc_block:
    # Args:
    # a0 - UART base address
    # Returns:
    # a0 - char from uart

    putc:
    # Args:
    # a0 - character to output
    # a1 - UART base address



    */
    asm volatile (
        "li sp, %0\n\t"
        "li a1, %1\n\t"
        "mv a0, %2\n\t"
        "call puts\n\t"
        "call vm_run\n\t"
        "1:\n\t"
        "j 1b\n\t"
        :
        : "i"(RAM_END), "i"(UART_BASE_CDEF), "r"(gTitleString)
    );

    while(1)
    {
    }
}
