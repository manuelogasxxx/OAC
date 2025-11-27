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
    strProposito: db "Prog. que determina si los numeros de una matriz son felices",10,0
    strIngreso: db "Ingrese el valor::",0
    strFeliz: db "Si es feliz",10,0
    strInfeliz: db "NO es feliz",10,0
    strIzquierdo: db "[",0
    strDerecho: db "]:",0
    strComa: db ",",0
    strIngresoM: db "Ingrese M::",0
    strIngresoN: db "Ingrese N::",0
    strIngreseMatriz: db "Ingrese los valores de la matriz",10,0
    strResultado: db "mostrando los resultados (Progresion de cuadrados)",10,0
    strProgresion: db "Progresión de la suma de cuadrados de cada digito",10,0
    suma: dd 0
    aux: dd 0
section .bss
    matriz: resw 200
    m: resw 1
    n: resw 1
    i: resw 1
    j: resw 1
    flag: resd 1
section .text

    global _start


_start:
    PutStr strProposito
    call leerMatriz
    call principal


fin:
    mov eax,1
    int 80h

;mostrar los indices
indices:
	PutStr strIzquierdo
	PutInt [i]
	PutStr strComa
	PutInt [j]
	PutStr strDerecho
ret

;para leer la matriz
leerMatriz:
    PutStr strIngresoM
    GetInt word[m]
    PutStr strIngresoN
    GetInt word[n]
    PutStr strIngreseMatriz

    mov eax, 0          
    mov ebx, matriz
    mov word[i], 0

bucleFilasM1:
    mov word[j], 0
bucleColumnasM1:
	call indices
    GetInt dx
    mov [ebx + eax*2], dx
    inc eax

    inc word[j]
    mov cx, word[j]
    cmp cx, word[n]
    jb bucleColumnasM1

    inc word[i]
    mov cx, word[i]
    cmp cx, word[m]
    jb bucleFilasM1

    ret

;esta función retorna la suma de los cuadrados de los dígitos del número que le pases
funcion:
    enter 0,0
    push ebx 
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
    ;nwln
    PutLInt [suma]
    nwln
    mov eax,[suma]
    pop ebx
    leave
    ret 4; se pasó un argumento de 32 bits

esFeliz:
    enter 0,0
    push ebx
    push ecx
    mov esi,[ebp+8] ; obtener el valor desde la pila
    ;comprobar casos bases::
    comprobacion:
        push esi
        call funcion;se devuelve en eax la suma
        cmp eax,1
        JE siEs
        cmp eax,4
        JE noEs
        mov esi, eax; esta parte lo cambia todo
        jmp comprobacion

    siEs:
        ;nwln
        PutStr strFeliz
        nwln
        jmp final

    noEs:
        ;nwln
        PutStr strInfeliz
        nwln
        jmp final
    
    final:
    pop ecx
    pop ebx
    leave
    ret 4



;funcion que recorre la matriz
principal:
	PutStr strResultado
    mov ebx, matriz      ; dirección de la matriz
    mov word[i], 0
    mov eax, 0           ; índice lineal

bucleFilasSuma:
    mov word[j], 0
bucleColumnasSuma:
    mov cx, [ebx + eax*2]
    movsx ecx, cx        ; extender a 32 bits
    call indices
    PutLInt ecx
    nwln
    ;PutStr strProgresion
    push eax
    push ebx
    push ecx             ;paso del parámetro  
    call esFeliz
    pop ebx
    pop eax

    inc eax

    inc word[j]
    mov cx, word[j]
    cmp cx, word[n]
    jb bucleColumnasSuma

    inc word[i]
    mov cx, word[i]
    cmp cx, word[m]
    jb bucleFilasSuma

    ret