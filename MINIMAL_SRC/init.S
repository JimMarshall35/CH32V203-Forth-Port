
.text
.global SystemInit
.global init_uart

#define R32_RCC_CTLR 0x40021000      // Clock control register 0x0000xx83
#define R32_RCC_CFGR0 0x40021004     // Clock configuration register 0 0x00000000
#define R32_RCC_INTR 0x40021008      // Clock interrupt register 0x00000000
#define R32_RCC_APB2PRSTR 0x4002100C // PB2 peripheral reset register 0x00000000
#define R32_RCC_APB1PRSTR 0x40021010 // PB1 peripheral reset register 0x00000000
#define R32_RCC_AHBPCENR 0x40021014  // HB peripheral clock enable register 0x00000014
#define R32_RCC_APB2PCENR 0x40021018 // PB2 peripheral clock enable register 0x00000000
#define R32_RCC_APB1PCENR 0x4002101C // PB1 peripheral clock enable register 0x00000000
#define R32_RCC_BDCTLR 0x40021020    // Backup domain control register 0x00000000
#define R32_RCC_RSTSCKR 0x40021024   // Control/status register 0x0C000000
#define R32_RCC_AHBRSTR 0x40021028   // HB peripheral reset register 0x00000000
#define R32_RCC_CFGR2 0x4002102C

.equ PERIPH_BASE,                             0x40000000 /* Peripheral base address in the alias region */
.equ AHBPERIPH_BASE, (PERIPH_BASE + 0x20000)
.equ APB1PERIPH_BASE, (PERIPH_BASE)

.equ APB2PERIPH_BASE,                         (PERIPH_BASE + 0x10000)


.equ EXTEN_BASE, (AHBPERIPH_BASE + 0x3800)
.equ EXTEND_CTR, EXTEN_BASE
#define EXTEN_PLL_HSI_PRE                       0x00000010 /* Bit 4 */
#define RCC_HPRE_DIV1                           0x00000000 /* SYSCLK not divided */
#define RCC_PPRE2_DIV1                          0x00000000 /* PPRE2 not divided */
#define RCC_PPRE1_DIV2                          0x00000400 /* PPRE1 divided by 2 */
#define RCC_PLLSRC                              0x00010000 /* PLL entry clock source */
#define RCC_PLLXTPRE                            0x00020000 /* HSE divider for PLL entry */
#define RCC_PLLMULL                             0x003C0000 /* PLLMUL[3:0] bits (PLL multiplication factor) */
#define RCC_PLLSRC_HSI_Div2                     0x00000000 /* HSI clock divided by 2 selected as PLL entry clock source */
#define RCC_PLLMULL12                           0x00280000 /* PLL input clock*12 */

#define RCC_PLLON                               0x01000000 /* PLL enable */
#define RCC_PLLRDY                              0x02000000 /* PLL clock ready flag */
#define RCC_SW                                  0x00000003 /* SW[1:0] bits (System clock Switch) */
#define RCC_SW_PLL                              0x00000002 /* PLL selected as system clock */
#define RCC_SWS                                 0x0000000C /* SWS[1:0] bits (System Clock Switch Status) */

#define NVIC_PriorityGroup_1           0x01 /* interrupt nesting enable(CSR-0x804 bit1 = 1) */

#define RCC_APB1Periph_USART2          0x00020000
#define RCC_APB2Periph_GPIOA           0x00000004

#define GPIO_Mode_AF_PP 0x18

#define GPIO_Speed_50MHz 3
#define GPIO_Pin_2                      0x0004 /* Pin 2 selected */
.equ GPIOA_BASE, (APB2PERIPH_BASE + 0x0800)

#define GPIOA_CFGLR_OFFSET 0
#define GPIOA_CFGHR_OFFSET 4
#define GPIOA_INDR_OFFSET 8
#define GPIOA_OUTDR_OFFSET 12
#define GPIOA_BSHR_OFFSET 16
#define GPIOA_BCR_OFFSET 20
#define GPIOA_LCKR_OFFSET 24

#define USART2_BASE                             (APB1PERIPH_BASE + 0x4400)
    # uint16_t      RESERVED3;
    # __IO uint16_t CTLR2;
    # uint16_t      RESERVED4;
    # __IO uint16_t CTLR3;
    # uint16_t      RESERVED5;
    # __IO uint16_t GPR;
    # uint16_t      RESERVED6;                  (APB1PERIPH_BASE + 0x4400)
    # __IO uint16_t STATR;
    # uint16_t      RESERVED0;
    # __IO uint16_t DATAR;
    # uint16_t      RESERVED1;
    # __IO uint16_t BRR;
    # uint16_t      RESERVED2;
    # __IO uint16_t CTLR1;
    # uint16_t      RESERVED3;
    # __IO uint16_t CTLR2;
    # uint16_t      RESERVED4;
    # __IO uint16_t CTLR3;
    # uint16_t      RESERVED5;
    # __IO uint16_t GPR;
    # uint16_t      RESERVED6;
#define USART_STATR_OFFSET 0
#define USART_DATAR_OFFSET 4
#define USART_BRR_OFFSET   8
#define USART_CTLR1_OFFSET 12
#define USART_CTLR2_OFFSET 16
#define USART_CTLR3_OFFSET 20
#define USART_GPR_OFFSET   24

#define BAUDRATE 115200
#define USART_StopBits_1                     0x0000
#define USART_WordLength_8b                  0x0000
#define USART_Parity_No                      0x0000
#define USART_HardwareFlowControl_None       0x0000
#define USART_Mode_Rx                        0x0004
#define USART_Mode_Tx                        0x0008


#define CTLR2_STOP_CLEAR_Mask     0xCFFF /* USART CTLR2 STOP Bits Mask */
#define CTLR1_CLEAR_Mask          0xE9F3 /* USART CTLR1 Mask */
#define CTLR3_CLEAR_Mask          0xFCFF /* USART CTLR3 Mask */
#define CFGR0_SWS_Mask            0x0000000C
#define CFGR0_PLLMull_Mask        0x003C0000
#define CFGR0_PLLSRC_Mask         0x00010000
#define HSI_VALUE                 8000000 /* Value of the Internal oscillator in Hz */
#define HSE_VALUE                 8000000 /* Value of the External oscillator in Hz */
#define CFGR0_PLLXTPRE_Mask       0x00020000

#define RESET 0
#define SET 0xffffffff

#define CFGR0_HPRE_Set_Mask         0x000000F0
#define CFGR0_PPRE1_Set_Mask        0x00000700
#define CFGR0_PPRE2_Set_Mask        0x00003800
#define CFGR0_ADCPRE_Set_Mask       0x0000C000


#define CTLR1_UE_Set              0x2000 /* USART Enable Mask */

#define OR_REG(val, reg) li t2, reg; \
lw t0, 0(t2);\
li t1, val;\
or t0, t0, t1; \
sw t0, 0(t2);

#define AND_REG(val, reg) li t2, reg; \
lw t0, 0(t2); \
li t1, val; \
and t0, t0, t1; \
sw t0, 0(t2);
APBAHBPrescTable:
    .byte 0, 0, 0, 0, 1, 2, 3, 4, 1, 2, 3, 4, 6, 7, 8, 9

SystemInit:
    # RCC->CTLR |= (uint32_t)0x00000001;
    # li t2, R32_RCC_CTLR
    # lw t0, 0(t2)
    # li t1, 0x00000001
    # or t0, t0, t1
    # sw t0, 0(t2)
    OR_REG(0x00000001, R32_RCC_CTLR)

    # RCC->CFGR0 &= (uint32_t)0xF0FF0000;
    # li t2, R32_RCC_CFGR0
    # lw t0, 0(t2)
    # li t1, 0xF0FF0000
    # and t0, t0, t1
    # sw t0, 0(t2)
    AND_REG(0xF0FF0000, R32_RCC_CFGR0)

    # RCC->CTLR &= (uint32_t)0xFEF6FFFF;
    # li t2, R32_RCC_CTLR
    # lw t0, 0(t2)
    # li t1, 0xFEF6FFFF
    # and t0, t0, t1
    # sw t0, 0(t2)
    AND_REG(0xFEF6FFFF, R32_RCC_CTLR)

    # RCC->CTLR &= (uint32_t)0xFFFBFFFF;
    # li t2, R32_RCC_CTLR
    # lw t0, 0(t2)
    # li t1, 0xFFFBFFFF
    # and t0, t0, t1
    # sw t0, 0(t2)
    AND_REG(0xFFFBFFFF, R32_RCC_CTLR)

    # RCC->CFGR0 &= (uint32_t)0xFF00FFFF;
    # li t2, R32_RCC_CFGR0
    # lw t0, 0(t2)
    # li t1, 0xFF00FFFF
    # and t0, t0, t1
    # sw t0, 0(t2)
    AND_REG(0xFF00FFFF, R32_RCC_CFGR0)
    
    # RCC->INTR = 0x009F0000;   
    li t2, R32_RCC_INTR
    li t0, 0x009f0000
    sw t0, 0(t2)

    # SetSysClockTo96_HSI

    # EXTEN->EXTEN_CTR |= EXTEN_PLL_HSI_PRE;
    OR_REG(EXTEN_PLL_HSI_PRE, EXTEND_CTR)


    # RCC->CFGR0 |= (uint32_t)RCC_HPRE_DIV1;
    OR_REG(RCC_HPRE_DIV1, R32_RCC_CFGR0)

    # /* PCLK2 = HCLK */
    # RCC->CFGR0 |= (uint32_t)RCC_PPRE2_DIV1;
    OR_REG(RCC_PPRE2_DIV1, R32_RCC_CFGR0)

    # /* PCLK1 = HCLK */
    # RCC->CFGR0 |= (uint32_t)RCC_PPRE1_DIV2;
    OR_REG(RCC_PPRE1_DIV2, R32_RCC_CFGR0)

    # /*  PLL configuration: PLLCLK = HSI * 12 = 96 MHz */
    # RCC->CFGR0 &= (uint32_t)((uint32_t)~(RCC_PLLSRC | RCC_PLLXTPRE | RCC_PLLMULL));
    AND_REG(~(RCC_PLLSRC | RCC_PLLXTPRE | RCC_PLLMULL), R32_RCC_CFGR0)

    # RCC->CFGR0 |= (uint32_t)(RCC_PLLSRC_HSI_Div2 | RCC_PLLMULL12);
    OR_REG((RCC_PLLSRC_HSI_Div2 | RCC_PLLMULL12), R32_RCC_CFGR0)

    # Enable PLL
    # RCC->CTLR |= RCC_PLLON;
    OR_REG(RCC_PLLON, R32_RCC_CTLR)


    # /* Wait till PLL is ready */
    # while((RCC->CTLR & RCC_PLLRDY) == 0)
1:
    li t0, R32_RCC_CTLR
    lw t1, 0(t0)
    li t0, RCC_PLLRDY
    and t0, t0, t1
    beq t0, zero, 1b; # if t0 == t1 then target

    # /* Select PLL as system clock source */
    # RCC->CFGR0 &= (uint32_t)((uint32_t)~(RCC_SW));
    AND_REG(~(RCC_SW), R32_RCC_CFGR0)

    # RCC->CFGR0 |= (uint32_t)RCC_SW_PLL;
    OR_REG(RCC_SW_PLL, R32_RCC_CFGR0)

    # /* Wait till PLL is used as system clock source */
    # while ((RCC->CFGR0 & (uint32_t)RCC_SWS) != (uint32_t)0x08)
1:
    li t0, R32_RCC_CFGR0
    lw t1, 0(t0)
    li t0, RCC_SWS
    and t0, t1, t0
    li t1, 0x08
    bne t0, t1, 1b # if t0 != t1 then target
    ret

init_uart:
    #RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
    AND_REG(~RCC_APB1Periph_USART2, R32_RCC_APB1PCENR)
    #RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    AND_REG(~RCC_APB2Periph_GPIOA, R32_RCC_APB2PCENR)

    # GPIO init
    mv t0, zero # t0 = currentMode
    li t1, GPIO_Mode_AF_PP
    li t2, 0x0f
    and t0, t1, t2

    
    # currentmode |= (uint32_t)GPIO_InitStruct->GPIO_Speed;
    li t1, GPIO_Speed_50MHz
    and t0, t0, t1

    li t1, GPIOA_BASE
    lw t1, GPIOA_CFGLR_OFFSET(t1) # t1 = tempreg

.equ POS, (2 << 2)
.equ PINMASK, (0x0f << POS)
.equ NOT_PINMASK, ~PINMASK
    li t3, NOT_PINMASK
    and t1, t1, t3
    slli t2, t0, POS
    or t1, t1, t2

    li t2, GPIOA_BASE
    sw t1, GPIOA_CFGLR_OFFSET(t2)

    lw t1, GPIOA_CFGHR_OFFSET(t2) # t1 = tempreg
    and t1, t1, t3
    slli t2, t0, POS
    or t1, t1, t2

    li t2, GPIOA_BASE
    sw t1, GPIOA_CFGLR_OFFSET(t2)

    # USART_Init
    # USART_InitStructure.USART_BaudRate = baudrate;
    # USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    # USART_InitStructure.USART_StopBits = USART_StopBits_1;
    # USART_InitStructure.USART_Parity = USART_Parity_No;
    # USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
    # USART_InitStructure.USART_Mode = USART_Mode_Tx | USART_Mode_Rx;
    # USART_Init(USART2, &USART_InitStructure);
    li t0, USART2_BASE
    lh t1, USART_CTLR2_OFFSET(t0) # t1 = tempreg
    li t2, CTLR2_STOP_CLEAR_Mask
    and t1, t1, t2
    li t2, USART_StopBits_1
    or t1, t1, t2
    sh t1, USART_CTLR2_OFFSET(t0)

.equ UART_SETTINGS_CTRL1, (USART_WordLength_8b | USART_Parity_No | USART_Mode_Tx | USART_Mode_Rx)
    lh t1, USART_CTLR1_OFFSET(t0) # t1 = tempreg
    li t2, CTLR1_CLEAR_Mask
    and t1, t1, t2
    li t2, UART_SETTINGS_CTRL1
    or t1, t1, t2
    sh t1, USART_CTLR1_OFFSET(t0)

    lh t1, USART_CTLR3_OFFSET(t0)
    li t2, USART_HardwareFlowControl_None
    and t1, t1, t2
    li t2, UART_SETTINGS_CTRL1
    or t1, t1, t2
    sh t1, USART_CTLR3_OFFSET(t0)


    # RCC_GetClocksFreq - returns
    # a0 - SYSCLK_Frequency
    # a1 - HCLK_Frequency
    # a2 - PCLK1_Frequency
    # a3 - PCLK2_Frequency
    # a4 - ADCCLK_Frequency
    li t0, R32_RCC_CFGR0
    lw t1, 0(t0)
    li t0, CFGR0_SWS_Mask

    and t0, t1, t0
    beq t0, zero, 1f # if t0 =zero then target
    li t1, 0x04
    beq t0, t1, 2f
    li t1, 0x08
    beq t0, t1, 3f
    j 4f
1: # tmp == 0
    li a0, HSI_VALUE
    j 5f
2: # tmp == 4
    li a0, HSE_VALUE
    j 5f
3: # tmp == 8
    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_PLLMull_Mask
    li t2, CFGR0_PLLSRC_Mask

    and t1, t0, t1 # t1 = pllmull
    and t2, t0, t2 # t2 = pllsource

    srli t1, t1, 18
    addi t1, t1, 2
    li t0, 17
    beq t1, t0, 1f
    j 2f
1:
    li t1, 18
2:
    mv t3, t1 # t3 = pllmull
    mv t4, t2 # t4 = pllsource


    beq t2, zero, 1f
    j 2f
1:
    # pllsource == 0x00
    li t0, EXTEND_CTR
    lw t0, 0(t0)
    # EXTEN->EXTEN_CTR & EXTEN_PLL_HSI_PRE
    li t1, EXTEN_PLL_HSI_PRE
    and t0, t0, t1
    beq t0, zero, 10f
    j 11f

10:
    # (EXTEN->EXTEN_CTR & EXTEN_PLL_HSI_PRE) == 0
    li t0, HSI_VALUE
    srli t0, t0, 1
    mul a0, t0, t3
    j 12f
11:
    # (EXTEN->EXTEN_CTR & EXTEN_PLL_HSI_PRE) != 0
    li t0, HSI_VALUE
    mul a0, t0, t3
12:
    j 3f
2:
    # eLse
    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_PLLXTPRE_Mask
    and t0, t0, t1
    li t1, RESET
    bne t0, t1, 10f
    j 11f
10:
    # (RCC->CFGR0 & CFGR0_PLLXTPRE_Mask) != (uint32_t)RESET
    li t0, HSE_VALUE
    srli t0, t0, 1
    mul a0, t0, t3
    j 12f
11:
    # eLse
    li t0, HSE_VALUE
    mul a0, t0, t3
12:
3:
    j 5f
4: # default
    li a0, HSI_VALUE
5:
    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_HPRE_Set_Mask
    and t0, t0, t1
    srli t0, t0, 4 # t0 = temp
    la t1, APBAHBPrescTable # Get presc value
    add t1, t1, t0
    lb a1, 0(t1)   # lookup table val
    srl a1, a0, a1 # HCLK_Frequency

    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_PPRE1_Set_Mask
    and t0, t0, t1
    srli t0, t0, 8
    la t1, APBAHBPrescTable
    add t1, t1, t0
    lb a2, 0(t1)
    srl a2, a0, a2 # PCLK1_Frequency


    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_PPRE2_Set_Mask
    and t0, t0, t1
    srli t0, t0, 11
    la t1, APBAHBPrescTable
    add t1, t1, t0
    lb a3, 0(t1)
    srl a3, a0, a3 # PCLK2_Frequency


    li t0, R32_RCC_CFGR0
    lw t0, 0(t0)
    li t1, CFGR0_ADCPRE_Set_Mask
    and t0, t0, t1
    srli t0, t0, 14
    la t1, APBAHBPrescTable
    add t1, t1, t0
    lb a4, 0(t1)
    div a4, a3, a4
    # END OF RCC_GetClocksFreq

    # apbclock = RCC_ClocksStatus.PCLK1_Frequency;
    # apbclock = a2


    #    integerdivider = ((25 * apbclock) / (4 * (USART_InitStruct->USART_BaudRate)));

    li t0, 25
    mul t0, t0, a2
    li t1, BAUDRATE
    li t2, 4
    mul t1, t1, t2
    div t0, t0, t1 # t0 = integerdivider
    li t1, 100
    div t1, t0, t1
    slli t1, t1, 4 # t1 = tmpreg

    srli t2, t1, 4
    li t3, 100
    mul t2, t3, t2
    sub t2, t0, t2 # t2 = fractionaldivider
    li t3, 16
    mul t2, t2, t3
    li t3, 50
    add t2, t2, t3
    li t3, 100
    div t2, t2, t3
    bgt t2, zero, 1f
    j 2f
1:
    # fractionaldivider > 0xf
    li t0, (1 << 4)
    add t1, t1, t0
    j 3f
2:
    # eLse
    li t0, 0x0f
    # it's clobberin' time
    and t2, t2, a0
    or t1, t1, t2
3:
    li t0, USART2_BASE
    sh t1, USART_BRR_OFFSET(t0)

    #USARTx->BRR = (uint16_t)tmpreg; 
    # end of USART_Init
    #USARTx->CTLR1 &= CTLR1_UE_Set;

    li t0, USART2_BASE 
    lh t1, USART_CTLR1_OFFSET(t0)
    li t0, CTLR1_UE_Set
    or t1, t1, t0
    sh t1, USART_CTLR1_OFFSET(t0)

    ret