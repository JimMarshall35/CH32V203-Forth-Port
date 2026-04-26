#define RAM_END 0x20002800
#define UART_BASE_CDEF 0x40004400

title_string: .ascii "RISC-V Forth CH32V203\n\r\0"

.global main
.text
# asm volatile (
#         "li sp, %0\n\t"
#         "li a1, %1\n\t"
#         "mv a0, %2\n\t"
#         "call puts\n\t"
#         "call vm_run\n\t"
#         "1:\n\t"
#         "j 1b\n\t"
#         :
#         : "i"(RAM_END), "i"(UART_BASE_CDEF), "r"(gTitleString)
#     );
main:
    call init_uart
    li sp, RAM_END
    li a1, UART_BASE_CDEF
    la a0, title_string
    call puts
1:
    j 1b