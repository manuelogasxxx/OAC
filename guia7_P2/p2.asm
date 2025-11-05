;numeros felices
;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: obtener los n primeros numeros primos
;fecha de creación:9/10/2025
;fecha de modi:	   9/10/2025
;compilacion       nasm -f elf32 p1.asm 
;                  ld -m elf_i386 -s -o p1 p1.o io.o

%include "io.mac"
section .data
    strProposito: db "Prog. que determina si un numero es feliz",10,0
    strIngreso: db "Ingrese el valor::",0
    strFeliz: db "Si es feliz",10,0
    strInfeliz: db "NO es feliz",10,0

    suma: dd 0
section .text

    global _start


_start:
    PutStr strProposito
    call esFeliz


fin:
    mov eax,1
    int 80h

funcion:
    enter 0,0
    mov esi,[ebp+8]; recuperar el parametro de la funcion
    mov dword [suma],0 ; poner en 0 la suma
    mov eax,esi
    mov ebx,10

    cmp esi,0
    ;obtiene los digitos 
    bucle:
        cmp eax,0
        je salir
        ;continuar si no es 0
        xor edx,edx
        mov ebx,10
        div ebx

        ;PutLInt edx; es el resto de la division
        ;en este punto hago la multiplicación por si mismo
        push eax; guardo eax
        mov eax,edx
        xor edx,edx
        mov ebx,eax
        mul ebx ; (eax)*(ebx)=eax^2
        add [suma],eax
        pop eax
        jmp bucle

    salir:
    nwln
    PutLInt [suma]
    mov eax,[suma]
    leave
    ret 4; se pasó un argumento de 32 bits

esFeliz:
    PutStr strIngreso
    GetLInt eax
    ;comprobar casos bases::
    comprobacion:
        push eax
        call funcion;se devuelve en eax la suma
        cmp eax,1
        JE siEs
        cmp eax,4
        JE noEs
        jmp comprobacion

    nwln
    siEs:
        PutStr strFeliz
        jmp final

    noEs:
        PutStr strInfeliz
        jmp final
    
    final:
    ret
