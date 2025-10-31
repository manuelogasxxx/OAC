;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: comprobar si dos numeros son amigos
;fecha de creación:9/10/2025
;fecha de modi:	   30/10/2025
;compilacion       nasm -f elf32 p22.asm 
;                  ld -m elf_i386 -s -o p22 p22.o io.o

;teoricamente ya está pero falta comprobar

%include "io.mac"

section .data
	strProposito: db "Módulo que encuentra los n primeros números amigos",10,0
	strIngresoN: db "ingrese el valor de n",10,0
	strIngresoA: db "Ingrese el número A::",0
	strIngresoB: db "Ingrese el número B::",0
	strSumaA: db "Suma de los divisores propios de A::",0
	strSumaB: db "Suma de los divisores propios de B::",0
	strAmigos: db "Son amigos!",10,0
	strNoAmigos: db "No son amigos!",10,0
	strResultados: db "Mostrando resultados::",10,0
	strIzquierdo: db "[",0
	strDerecho: db "]:",0
	strPares: db " -> ",0
    salto: db 10,0

	flag: db 0 ; inicializada en falso
	suma: dd 0
	cont: dd 0
	temp: dd 0
    temp2: dd 0
	n: dd 0
	contador: dd 0
section .text

global _start 


_start:

PutStr strProposito
PutStr strIngresoN
GetLInt eax
mov [n],eax

PutStr strResultados

mov eax,220 ; primer numero a probar

primerCiclo:
	mov ecx, [contador]
	cmp ecx,[n]
	JE fin
	;sino->continuar
	push eax; guardo el valor original
    mov ebx,eax
    call sumaDivisoresPropios
    mov ecx,[suma]; divisores de eax
	mov [temp],ecx
	pop eax
	;descarto numeros perfectos
	cmp eax,ecx
	JGE noSon1
	;
	push eax
	mov eax,ecx
	call sumaDivisoresPropios 
    mov ecx,[suma]; divisores de eax
	;mov [temp],ecx
	pop eax
	cmp ecx,eax
	JE siSon
    ;calcular una ves los divisores de eax

	noSon1:
		inc eax
		jmp primerCiclo

	siSon:;se imprime la pareja
		mov ecx, [contador]
		inc ecx
		mov [contador], ecx
		PutStr strIzquierdo
		PutLInt ecx
		PutStr strDerecho
		PutLInt eax
		PutStr strPares
		PutLInt [temp]
		nwln
		;
		;mov eax,[temp]
		inc eax
		jmp primerCiclo

fin:
	mov eax, 01
	INT 80h


;funcion para sumar los divisores propios

;devuelve la suma en eax
;recibe el parámetro en eax
sumaDivisoresPropios:
	mov dword [suma], 0
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
