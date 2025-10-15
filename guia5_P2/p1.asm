; Nombre    : p1.asm
;proposito  : sumar dos matrices bidimensionales
;Autor      : Manuel Fernández Mercado FCC BUAP
;Creación   : 19/08/2025
;Compilacion: nams -f elf p1.asm
;enlazar 	: ld -m elf_i386 -s p1.o io.o -o p1 






%include "io.mac"

section .data
	proposito db "Sumar dos matrices bidimensionales MxN",10,0
	ingresarM db "Ingresa M::",0
	ingresarN db "Ingresa N::",0
	ingresarM1 db "Ingresa M1::",10,0
	ingresarM2 db "Ingresa M2::",10,0
	mostrarM1 db "Mostrando la matriz 1::",10,0
	mostrarM2 db "Mostrando la matriz 2::",10,0
	mostrarRes db "Mostrando la matriz resultante::",10,0
	tab db "",9,0 ;Tabulacion entre columnas
section .bss
	matriz: resw 200
	matriz2: resw 200
	matrizRes: resw 200
	m: resw 1; filas
	n: resw 1; columnas
	i: resw 1; indice filas
	j: resw 1; indice columnas

section .text
global _start

_start:
PutStr proposito
;Leer datos de la matriz 
PutStr ingresarM
GetInt word [m]
nwln
PutStr ingresarN
GetInt word [n]
nwln


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

;fin lectura de la matriz

PutStr ingresarM2

;inicializacion de indices
mov eax,0
mov ebx, matriz2
mov word[i],0
mov word[j],0

;lectura de la matriz 2

bucleFilasM2:
	mov word[j],0
bucleColumnasM2:
	GetInt dx;leer valor de 2 bytes

	mov word[ebx+2*eax],dx
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnasM2
	;
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilasM2

;fin lectura de la matriz



;aqui se va a realizar la suma:

mov eax,0
mov ebx, matrizRes
;
push ebx
mov word[i],0
mov word[j],0
nwln


bucleFilasSuma:
	mov word[j],0
bucleColumnasSuma:
	mov ebx, matriz
	mov dx, word[ebx+2*eax]
	mov ebx, matriz2
	add dx, word[ebx+2*eax]
	;ya se realizó la suma ahora la guardo
	pop ebx
	mov word[ebx+2*eax],dx
	push ebx
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnasSuma
	
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilasSuma

;inicialización otra ves





;moatrar la matriz 1
PutStr mostrarM1
mov eax,0
mov ebx, matriz
mov word[i],0
mov word[j],0
nwln

;mostrar la matriz

bucleFilas2:
	mov word[j],0
bucleColumnas2:
	PutInt word[ebx+2*eax]
	PutStr tab
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnas2
	nwln
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilas2
	nwln


PutStr mostrarM2
mov eax,0
mov ebx, matriz2
mov word[i],0
mov word[j],0
nwln

;mostrar la matriz

bucleFilas3:
	mov word[j],0
bucleColumnas3:
	PutInt word[ebx+2*eax]
	PutStr tab
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnas3
	nwln
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilas3
	nwln


PutStr mostrarRes
mov eax,0
mov ebx, matrizRes
mov word[i],0
mov word[j],0
nwln

;mostrar la matriz

bucleFilas4:
	mov word[j],0
bucleColumnas4:
	PutInt word[ebx+2*eax]
	PutStr tab
	inc eax

	inc word[j]
	mov cx, word[j]
	cmp cx, word[n]
	jb bucleColumnas4
	nwln
	inc word[i]
	mov cx, word[i]
	cmp cx, word[m]
	jb bucleFilas4
	nwln






	jmp fin
;mostrar la matriz

fin:
	mov eax, 1
	int 80h
