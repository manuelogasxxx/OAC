;nombre    : p1.asm
;Propósito : Saber si un número pertenece a la sucesión de fibonacci
;autor     : Manuel Fernández Mercado
;FCreacion : 22/08/2025
;FModif    : 22/08/2025
;compilar  :
;			 nasm -f elf32 p1.asm
;			 ld -m elf_i386 -s -o p1 p1.o io.o

%include "io.mac"

section .data
    msjTitulo db "Verificar si un numero pertenece a la sucesion de Fibonacci",10,0 
    msj db "Ingrese un numero: ",0
    msjPertenece db "Pertenece a la sucesion",10,0
    msjNoPertenece db "NO pertenece a la sucesion",10,0
    valorBuscado dd 0

section .text
global _start

_start:
    PutStr msjTitulo
    PutStr msj
    GetLInt EAX             
    MOV [valorBuscado], EAX

    CMP EAX, 0
    JL noPertenece           

    CMP EAX, 0
    JE pertenece             
    CMP EAX, 1
    JE pertenece             

    
    MOV EBX, 0               
    MOV ECX, 1               

siguiente:
    ADD EBX, ECX             
    XCHG EBX, ECX            

    CMP ECX, [valorBuscado]  
    JE pertenece
    JA noPertenece           

    JMP siguiente

pertenece:
    PutStr msjPertenece
    JMP fin

noPertenece:
    PutStr msjNoPertenece
    JMP fin

fin:
    MOV EAX, 1
    INT 80h
