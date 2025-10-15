;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: comprobar si dos numeros son amigos
;fecha de creación:9/10/2025
;fecha de modi:	   9/10/2025
;compilacion       nasm -f elf32 p1.asm 
;                  ld -m elf_i386 -s -o p1 p1.o io.o

;teoricamente ya está pero falta comprobar

%include "io.mac"

section .data
	strProposito: db "Módulo que encuentra si dos valores ingresados son amigos",10,0
	strIngresoA: db "Ingrese el número A::",0
	strIngresoB: db "Ingrese el número B::",0
	strSumaA: db "Suma de los divisores propios de A::",0
	strSumaB: db "Suma de los divisores propios de B::",0
	strAmigos: db "Son amigos!",10,0
	strNoAmigos: db "No son amigos!",10,0

	flag: db 0 ; inicializada en falso
	suma: dd 0
	cont: dd 0
	temp: dd 0
section .text

global _start 


_start:

PutStr strProposito
PutStr strIngresoA
GetLInt eax
nwln
PutStr strIngresoB
GetLInt ebx
nwln
call sonAmigos


CMP byte [flag] ,1
JNE noAmigos
PutStr strAmigos
JMP fin


noAmigos:
	PutStr strNoAmigos
	jmp fin

fin:
	mov eax, 01
	INT 80h


;funcion para sumar los divisores propios

;devuelve la suma en eax
;recibe el parámetro en eax
sumaDivisoresPropios:
	mov ecx,eax
	dec ecx
	xor esi,esi
	mov esi,eax
	bucleSuma:

		cmp ecx,0
		JE final
		mov eax,esi
		xor edx,edx
		mov ebx,ecx
		div ebx
		cmp edx,0 ; comprueba si el valor es divisor
		jne continuar

		mov eax, [suma] ;guardar la suma en la variable
		add eax, ebx
		mov [suma],eax
		continuar:
			dec ecx
			jmp bucleSuma

	;mov eax ,[suma] ;devuelve el valor de la suma en eax
ret

;falta hacer la funcion

;recibe A en eax y B en ebx
sonAmigos:
	push eax
	push ebx
	call sumaDivisoresPropios
	mov ecx,[suma]; divisores de eax
	mov [temp],ecx

	mov dword [suma],0
	pop ebx
	pop eax
	push eax;
	push ebx
	mov eax,ebx
	call sumaDivisoresPropios
	mov edx,[suma]; divisores de ebx
	pop ebx
	pop eax;

	mov ecx, [temp]	
	;comprobacion
	PutStr strSumaA
	PutLInt ECX
	nwln
	PutStr strSumaB
	PutLInt EDX
	nwln 
	CMP ecx,ebx
	JNE noSon
	CMP edx,eax
	JNE noSon
	mov byte [flag],1
	jmp final
	noSon:
		mov byte [flag],0
		jmp final
		
	final:
	ret




