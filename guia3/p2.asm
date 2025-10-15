;nombre    : p1.asm
;Propósito : Saber si un número es abundante
;autor     : Manuel Fernández Mercado
;FCreacion : 2/08/2025
;FModif    : 2/08/2025
;compilar  :
;			 nasm -f elf32 p2.asm
;			 ld -m elf_i386 -s -o p2 p2.o io.o
%include "io.mac"

section .data
	msjTitulo: db "Verificar si un numero es abundante",10,0
    msg:    db "Ingrese un valor::",10,0
    sumaMsg: db "Suma de divisores propios: ",0
    msgSi: db "SI es abundante",10,0
    msgNo: db "NO es abundante",10,0
    suma:   dd 0
    temp: dd 0

section .text
    global _start

_start:
    ; Mostrar mensaje e ingresar número
    PutStr msjTitulo
    PutStr msg
    GetLInt ECX              ; ECX = número ingresado
    MOV ESI, ECX             ; Guardar original en ESI

    ;casos base
    CMP ECX,1
    JE mensajeNo
    CMP ECX,2
    JE mensajeSi

    ; Empezar bucle desde ECX-1 hasta 1
    DEC ECX                  ; Empezamos desde n-1

sumar_divisores:
    CMP ECX, 0
    JE comprobacion        ; Terminar si llegamos a 0

    MOV EAX, ESI             ; Número original
    XOR EDX, EDX             ; Limpiar EDX antes de DIV
    MOV EBX, ECX             ; Divisor candidato
    DIV EBX                  ; EAX / EBX → residuo en EDX

    CMP EDX, 0
    JNE continuar            ; Si no es divisible, seguir

    ; Sumar divisor
    MOV EAX, [suma]
    ADD EAX, EBX
    MOV [suma], EAX

    continuar:
        DEC ECX
        JMP sumar_divisores

comprobacion:
    PutStr sumaMsg
    PutLInt [suma]
    nwln
    MOV EAX,ESI ;[temp]
    MOV EBX,[suma]
    CMP EAX,EBX
    JNG mensajeSi
    JMP mensajeNo
mensajeSi:
    PutStr msgSi
    JMP fin
mensajeNo:
    PutStr msgNo
    JMP fin
fin:
    MOV EAX, 1
    INT 80h
