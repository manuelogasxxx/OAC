;Autor:             Manuel Fernández Mercado
;nombre:            p1.asm
;Propósito:         comprobar valores abundantes de una matriz
;fecha de creación: 9/10/2025
;fecha de modi:	    9/10/2025
;compilacion:       nasm -f elf32 p3.asm 
;                   ld -m elf_i386 -s -o p3 p3.o io.o

%include "io.mac"

section .data
    strProposito: db "Módulo que encuentra los valores abundantes de una matriz",10,0
    strIngresoM: db "Ingrese M::",0
    strIngresoN: db "Ingrese N::",0
    strIngreseMatriz: db "Ingrese los valores de la matriz",10,0
    strSiAbundante: db "  -> Es abundante",10,0
    strNoAbundante: db "  -> No es abundante",10,0
    strIzquierdo: db "[",0
    strDerecho: db "]:",0
    strComa: db ",",0
    strResultado: db 10,"Mostrando resultados.....",10,10,0
    strNoHay: db "No se encontraron números abundantes en la matriz",10,0
	flag1: dd 0
section .bss
    matriz: resw 200
    m: resw 1
    n: resw 1
    i: resw 1
    j: resw 1
    suma: resd 1
    flag: resd 1

section .text
global _start

_start:
    PutStr strProposito
    call leerMatriz
    
    call principal

    mov eax, 1
    mov ebx, 0
    int 80h




indices:
	PutStr strIzquierdo
	PutInt [i]
	PutStr strComa
	PutInt [j]
	PutStr strDerecho
ret




;---------------------------------------------
leerMatriz:
    PutStr strIngresoM
    GetInt word[m]
    PutStr strIngresoN
    GetInt word[n]
    PutStr strIngreseMatriz

    mov eax, 0          ; índice lineal
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


;---------------------------------------------
; esAbundante(eax = número)
; Devuelve flag = 1 si abundante, 0 si no
;---------------------------------------------
esAbundante:
    push eax
    push ebx
    push ecx
    push edx

    mov dword [suma], 0    ; limpiar suma
    mov esi, eax           ; esi = número original
    mov ecx, esi
    dec ecx                ; divisor = n - 1

bucleSuma:
    cmp ecx, 0
    je finSuma
    mov eax, esi           ; eax = número original ✅
    xor edx, edx
    div ecx
    cmp edx, 0
    jne noDivisor
        mov eax, [suma]
        add eax, ecx
        mov [suma], eax
noDivisor:
    dec ecx
    jmp bucleSuma

finSuma:
    mov eax, [suma]
    cmp eax, esi
    jle noAb
    mov dword [flag], 1
    jmp salir
noAb:
    mov dword [flag], 0
salir:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret



;---------------------------------------------
principal:
	PutStr strResultado
    mov ebx, matriz      ; dirección de la matriz
    mov word[i], 0
    mov eax, 0           ; índice lineal

bucleFilasSuma:
    mov word[j], 0
bucleColumnasSuma:
    ; Obtener elemento matriz usando índice lineal
    mov cx, [ebx + eax*2]
    movsx ecx, cx        ; extender a 32 bits
    
    ; Preparar parámetro para esAbundante
    push eax             ; guardar índice lineal
    mov eax, ecx         ; eax = número a verificar
    
    ; Llamar a esAbundante
    call esAbundante
    
    ; Mostrar resultados
    ;call indices
    ;PutInt ax
    cmp dword [flag], 1
    je esAb
        ;PutStr strNoAbundante
    jmp sig
esAb:
	mov dword [flag1],1
    call indices
    PutInt ax
    PutStr strSiAbundante
sig:
    nwln
    
    pop eax              ; recuperar índice lineal
    inc eax              ; siguiente elemento

    inc word[j]
    mov cx, word[j]
    cmp cx, word[n]
    jb bucleColumnasSuma

    inc word[i]
    mov cx, word[i]
    cmp cx, word[m]
    jb bucleFilasSuma

	cmp dword [flag1],0
	je noEncontrados
	jmp finaal
	noEncontrados:
		PutStr strNoHay

	finaal:
    ret
