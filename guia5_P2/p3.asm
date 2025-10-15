;Nombre     : p1.asm
;proposito  : Multiplicar dos matrices y mostrar el resultado
;Autor      : Manuel Fernández Mercado FCC BUAP
;Creación   : 20/08/2025
;Compilacion: nams -f elf p1.asm
;enlazar 	: ld -m elf_i386 -s p1.o io.o -o p1 






%include "io.mac"

section .data
	proposito db "Multiplicar dos matrices ",10,0
	ingresarF1 db "Ingresa # de filas M1::",0
	ingresarC1 db "Ingresa # de columnas M1::",0
	ingresarF2 db "Ingresa # de filas M2::",0
	ingresarC2 db "Ingresa # de columnas M2::",0
	ingresarM1 db "Ingresa la matriz 1::",10,0
	ingresarM2 db "Ingresa la matriz 2::",10,0
	error db "Error::Columnas de M1 != de Filas M2!!!!",10,0
	mostrarRes db "Mostrando la matriz resultado::",10,0
	tab db "",9,0 ;Tabulacion entre columnas
section .bss
	matriz: resw 200
	matriz2: resw 200
	matrizRes: resw 200
	m: resw 1; filas matriz 1
	n: resw 1; columnas matriz 1
	n1: resw 1; filas matriz 2
	p: resw 1;  columnas matriz 2
	i: resw 1; indice filas
	j: resw 1; indice columnas
	k: resw 1; indice auxiliar

section .text
global _start

_start:
PutStr proposito


PutStr ingresarF1
GetInt word [m]
nwln
PutStr ingresarC1
GetInt word [n]
nwln
PutStr ingresarF2
GetInt word [n1]
nwln
PutStr ingresarC2
GetInt word [p]

;comprobación para saber si se pueden multiplicar

mov ax,word[n]
cmp ax, word[n1]
JNE errorDeMultiplicacion




PutStr ingresarM1

;inicializacion de indices
mov eax,0
mov ebx, matriz
mov word[i],0
mov word[j],0

;lectura de la matriz 1

bucleFilasM1:
	mov word[j],0
bucleColumnasM1:
	GetInt dx;leer valor de 2 bytes

	mov word[ebx+2*eax],dx
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnasM1
	;
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilasM1

;fin lectura de la matriz 1


mov eax,0
mov ebx, matriz2
mov word[i],0
mov word[j],0

;lectura de la matriz 2

PutStr ingresarM2

bucleFilasM2:
	mov word[j],0
bucleColumnasM2:
	GetInt dx;leer valor de 2 bytes

	mov word[ebx+2*eax],dx
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[p]
	jb bucleColumnasM2
	;
	inc word[i]
	mov cx, word[i]
	cmp cx, word[n1]
	jb bucleFilasM2

;ya la multiplicación de matrices

; --- Multiplicación de matrices ---
; C = A * B
; A = m x n
; B = n x p
; C = m x p

mov word[i], 0              ; i = 0
bucleFilasMul:
    mov word[j], 0          ; j = 0

bucleColumnasMul:
    xor edx, edx            ; acumulador (suma) = 0 (32 bits)
    mov word[k], 0          ; k = 0

bucleSumaMul:
    ; ---- A[i][k] ----
    movzx eax, word[i]      ; eax = i
    movzx ebx, word[n]      ; ebx = n
    imul eax, ebx           ; eax = i * n
    movzx ebx, word[k]      ; ebx = k
    add eax, ebx            ; eax = i*n + k
    shl eax, 1              ; *2 porque son words
    movzx eax, word [matriz + eax]   ; eax = A[i][k]

    ; ---- B[k][j] ----
    movzx ebx, word[k]      ; ebx = k
    movzx esi, word[p]      ; esi = p
    imul ebx, esi           ; ebx = k * p
    movzx esi, word[j]      ; esi = j
    add ebx, esi            ; ebx = k*p + j
    shl ebx, 1              ; *2 porque son words
    movzx ebx, word [matriz2 + ebx]  ; ebx = B[k][j]

    ; ---- multiplicar y acumular ----
    mov ecx, eax            ; ecx = A[i][k]
    imul ecx, ebx           ; ecx = ecx * B[k][j]
    add edx, ecx            ; sum += producto

    ; k++
    inc word[k]
    movzx ecx, word[k]
    movzx esi, word[n]
    cmp ecx, esi
    jb bucleSumaMul

    ; ---- guardar en C[i][j] ----
    movzx eax, word[i]
    movzx ebx, word[p]
    imul eax, ebx           ; eax = i * p
    movzx ebx, word[j]
    add eax, ebx            ; eax = i*p + j
    shl eax, 1              ; *2
    mov [matrizRes + eax], dx   ; guarda resultado (word, los 16 bits bajos de edx)

    ; j++
    inc word[j]
    movzx ecx, word[j]
    movzx esi, word[p]
    cmp ecx, esi
    jb bucleColumnasMul

    ; i++
    inc word[i]
    movzx ecx, word[i]
    movzx esi, word[m]
    cmp ecx, esi
    jb bucleFilasMul

;mostrar la matriz resultado

PutStr mostrarRes 
mov eax,0
mov ebx, matrizRes
mov word[i],0
mov word[j],0
bucleFilasResultado:
	mov word[j],0
bucleColumnasResultado:
	PutInt word[ebx+2*eax]
	PutStr tab
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[p]
	jb bucleColumnasResultado
	nwln
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilasResultado
	nwln
	jmp fin
errorDeMultiplicacion:
	PutStr error
	jmp fin

fin:
	mov eax, 1
	int 80h
