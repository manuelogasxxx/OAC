;se va a hacer un código que use interrupciones del sistema


;se va a emular

section .data




section .text

global _start


_start:

;ingrese el nombre del archivo a crear
;manejar errores
;




fin:
    mov eax,1
    mov ebx,0
    INT 80h
    ;interrupcion para 