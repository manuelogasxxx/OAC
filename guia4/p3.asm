;Autor: Manuel Fernández Mercado
;nombre: p3.asm
;Propósito: Verifica valor y posición de la primer ocurrencia del elemento mas frecuente en un arreglo
;fecha de creación:11/09/2025
;fecha de modi:	   18/09/2025
;compilacion       nasm -f elf32 p3.asm 
;                  ld -m elf_i386 -s -o p3 p3.o io.o



%include "io.mac"

section .data
    proposito db "Verifica valor y posición de la primer ocurrencia del elemento mas frecuente en un arreglo",10,0
    tamano db "Ingrese el tamaño del arreglo::",10,0
    datos db "Ingrese los datos del vector::",10,0
    valor db "valor en la posicion ",0 
    resultado db "Valor mas frecuente del arreglo::",0
    posicion db "Posicion::",0

    max_valor dd 0
    max_ocurrencia dd 0
    max_pos dd 0

    aux_valor dd 0
    aux_ocurrencia dd 0
    aux_pos dd 0

section .bss
    nroElementos resd 1
    vector resd 1000

section .text
global _start

_start:

    PutStr proposito
    PutStr tamano
    GetInt [nroElementos]

    ; Leer datos del arreglo
    PutStr datos
    XOR ESI, ESI
    MOV ECX, [nroElementos]

leer_siguiente:
    PutStr valor
    PutLInt ESI
    nwln
    GetLInt EAX
    MOV [vector + ESI*4], EAX
    INC ESI
    DEC ECX
    JNZ NEAR leer_siguiente

    ; Reinicio ESI para recorrer el vector
    XOR ESI, ESI
    MOV ECX, [nroElementos]

bucleExterno:
    MOV EDX, [vector + ESI*4]      ; Valor a buscar
    MOV [aux_pos], ESI
    MOV [aux_valor], EDX

    ; Guardar contexto del bucle externo
    PUSH ESI
    PUSH ECX

    ; Bucle interno
    XOR EAX, EAX                   ; Contador de ocurrencias
    XOR EDI, EDI                   ; Índice para bucle interno
    MOV ECX, [nroElementos]

bucleInterno:
    MOV EBX, [vector + EDI*4]
    CMP EBX, EDX
    JNE siguiente
    INC EAX
siguiente:
    INC EDI
    DEC ECX
    JNZ NEAR bucleInterno

    ; Comparar ocurrencias
    CMP EAX, [max_ocurrencia]
    JL NEAR continuarExterno
    JE NEAR empate

    ; Si es mayor, actualizar todo
    MOV [max_ocurrencia], EAX
    MOV EDX, [aux_valor]
    MOV [max_valor], EDX
    MOV EBX, [aux_pos]
    MOV [max_pos], EBX
    JMP NEAR continuarExterno

empate:
    ; En empate de ocurrencias, tomar la primera aparición
    MOV EBX, [aux_pos]
    CMP EBX, [max_pos]
    JGE NEAR continuarExterno
    MOV [max_ocurrencia], EAX
    MOV EDX, [aux_valor]
    MOV [max_valor], EDX
    MOV [max_pos], EBX

continuarExterno:
    POP ECX
    POP ESI
    INC ESI
    DEC ECX
    JNZ NEAR bucleExterno

    ; Mostrar resultados
    PutStr resultado
    PutLInt [max_valor]
    nwln
    PutStr posicion
    PutLInt [max_pos]
    nwln

    ; Salida
fin:
    MOV EAX, 1
    INT 80h

