    .section .text
    .global _start

_start:
    movi a2, 42      # cargar 42 en a2
    movi a3, 58      # cargar 58 en a3
    add a4, a2, a3   # sumar y guardar en a4
    ret
