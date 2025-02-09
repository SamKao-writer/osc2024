.section ".text.boot"

.global _start

_start:
    // save arguments in registers (we will need them later for the new kernel)
    // I choosed x10-x13 because instructions generated from C by gcc does not
    // touch them. You can check that with "aarch64-elf-objdump -d kernel8.elf"
    mov     x10, x0
    mov     x11, x1
    mov     x12, x2
    mov     x13, x3

    // relocate our code from load address to link address
    ldr     x1, =0x80000
    ldr     x2, =_start
    ldr     w3, =_load_size
1:  ldr     x4, [x1], #8
    str     x4, [x2], #8
    sub     w3, w3, #1
    cbnz    w3, 1b

    // set top of stack just before our code (stack grows to a lower address per AAPCS64)
    ldr     x1, =_start
    mov     sp, x1

    // clear bss
    ldr     x1, =bss_begin
    ldr     w2, =_bss_size
3:  cbz     w2, 4f
    str     xzr, [x1], #8
    sub     w2, w2, #1
    cbnz    w2, 3b

    // jump to relocated C code, should not return
4:  bl      main-0x20000
    // for failsafe, halt this core too
    b       1b