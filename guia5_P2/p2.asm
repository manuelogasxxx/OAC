; Nombre    : p1.asm
;proposito  : Encontrar la primer ocurrencia de un num%17==0 en una matriz
;Autor      : Manuel Fernández Mercado FCC BUAP
;Creación   : 19/08/2025
;Compilacion: nams -f elf p1.asm
;enlazar 	: ld -m elf_i386 -s p1.o io.o -o p1 






%include "io.mac"

section .data
	proposito db "Encontrar la fila y columna del primer multiplo de 17 en una matriz",10,0
	ingresarN db "Ingresa # de filas::",0
	ingresarM db "Ingresa # de columnas::",0
	ingresarM1 db "Ingresa la matriz ::",10,0
	mostrarI db "I::",0
	mostrarJ db "J::",0
	mostrarRes db "Multiplo de 17 encontrado...Mostrando los indices::",10,0
	mostrarNo db "No se encontró un multiplo de 17 en la matriz",10,0
	tab db "",9,0 ;Tabulacion entre columnas
	flag dd 0
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

mov eax,0
mov ebx, matriz
mov word[i],0
mov word[j],0

bucleFilasSuma:
	mov word[j],0
bucleColumnasSuma:
	push eax
	mov ax, word[ebx+2*eax]
	;aca voy a hacer las marañas
	push ebx

	mov ebx,17
	xor edx,edx
	div ebx

	cmp edx,0
	JNE continuar
	;mostrar los indices
	PutStr mostrarRes
	PutStr mostrarI
	PutInt word[i]
	nwln
	PutStr mostrarJ
	PutInt word[j]
	nwln
	mov dword [flag],1
	jmp comprobacion
	continuar:
		;restablecemos los valores
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

	jmp comprobacion
;mostrar la matriz

comprobacion:
	;comprobar la bandera
	mov ebx, [flag]
	cmp ebx,1
	JNE noEncontrado
	JMP fin

	noEncontrado:
	PutStr mostrarNo
	JMP fin


fin:
	mov eax, 1
	int 80h
