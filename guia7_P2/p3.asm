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
    strResultado: db "mostrando los resultados",10,0
    suma: dd 0
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

indices:
    PutStr strIzquierdo
    PutInt [i]
    PutStr strComa
    PutInt [j]
    PutStr strDerecho
    ret

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

funcion:
    enter 0,0
    push ebx
    mov esi,[ebp+8]
    mov dword [suma],0
    mov eax,esi

bucle_funcion:
    cmp eax,0
    je salir_funcion
    xor edx,edx
    mov ebx,10
    div ebx
    push eax
    mov eax,edx
    mul eax
    add [suma],eax
    pop eax
    jmp bucle_funcion

salir_funcion:
    mov eax,[suma]
    pop ebx
    leave
    ret 4

esFeliz:
    enter 0,0
    push ebx
    push ecx
    mov esi,[ebp+8]

comprobacion:
    push esi
    call funcion        ; resultado en eax
    cmp eax,1
    je siEs
    cmp eax,4
    je noEs
    mov esi, eax        ; ACTUALIZAR esi con el nuevo valor
    jmp comprobacion

siEs:
    PutStr strFeliz
    jmp final_esFeliz

noEs:
    PutStr strInfeliz

final_esFeliz:
    pop ecx
    pop ebx
    leave
    ret 4

principal:
    PutStr strResultado
    mov ebx, matriz
    mov word[i], 0
    mov eax, 0           ; índice lineal (reemplaza [aux])

bucleFilasSuma:
    mov word[j], 0
bucleColumnasSuma:
    ; Obtener elemento usando eax como índice lineal
    mov cx, [ebx + eax*2]
    movsx ecx, cx
    
    ; Mostrar coordenadas actuales
    PutStr strIzquierdo
    PutInt [i]
    PutStr strComa
    PutInt [j]
    PutStr strDerecho
    PutInt cx           ; Mostrar el número que se evaluará
    nwln
    
    push eax            ; Preservar índice lineal
    push ebx
    push ecx            ; Pasar número a evaluar
    call esFeliz
    pop ebx
    pop eax
    
    inc eax             ; Incrementar índice lineal para siguiente elemento
    inc word[j]
    mov cx, word[j]
    cmp cx, word[n]
    jb bucleColumnasSuma

    inc word[i]
    mov cx, word[i]
    cmp cx, word[m]
    jb bucleFilasSuma
    ret