.section .data
msjNo: .string "No son triangulares\n"
msjSi: .string "SI son triangulares\n"

.section .text
.global _start
_start:

    # Cargar lados
    li t0, 3      # A
    li t1, 4      # B
    li t2, 5      # C

    # Calcular sumas
    add t3, t0, t1  # A + B
    add t4, t1, t2  # B + C
    add t5, t0, t2  # A + C

    # Verificar desigualdad triangular
    ble t3, t2, NO
    ble t4, t0, NO
    ble t5, t1, NO

    # SI son triangulares
    li a7, 64         # syscall write
    li a0, 1          # stdout
    la a1, msjSi      # dirección del mensaje
    li a2, 20         # longitud del mensaje
    ecall
    j fin

NO:
    li a7, 64
    li a0, 1
    la a1, msjNo
    li a2, 22
    ecall

fin:
    li a7, 93         # syscall exit
    li a0, 0
    ecall

