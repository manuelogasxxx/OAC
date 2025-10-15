.section .data
msg: .string "No forman triangulo\n"
len_msg = . - msg

msg1: .string "Si forman triangulo\n"
len_msg1 = . - msg1

.section .text
.global _start
_start:
    li t0, 3      # A
    li t1, 4      # B
    li t2, 5      # C

    # Calcular sumas
    add t3, t0, t1  # A + B
    add t4, t1, t2  # B + C
    add t5, t0, t2  # A + C

    # Check for the triangle inequality theorem:
    # A + B > C
    # B + C > A
    # A + C > B
    # If any of these conditions are false, it's not a triangle.
    blt t3, t2, NO  # If (A + B) < C, branch to NO
    blt t4, t0, NO  # If (B + C) < A, branch to NO
    blt t5, t1, NO  # If (A + C) < B, branch to NO

    # It's a triangle → print msg1
    li a7, 64       # syscall write
    li a0, 1        # stdout
    la a1, msg1
    li a2, len_msg1
    ecall
    j fin

NO:
    # It's not a triangle → print msg
    li a7, 64       # syscall write
    li a0, 1        # stdout
    la a1, msg
    li a2, len_msg
    ecall

fin:
    li a0, 0
    li a7, 93       # syscall exit
    ecall

