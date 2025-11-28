;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: Módulo que encuentra el n-esimo numero primo
;fecha de creación:9/10/2025
;fecha de modi:	   9/10/2025
;compilacion       nasm -f elf32 p1.asm 
;                  ld -m elf_i386 -s -o p1 p1.o io.o


%include "io.mac"

section .data
	strProposito: db "Módulo que encuentra el n-esimo numero primo",10,0
	strIngreso: db "Ingrese el valor de N::",0
	strResultado: db "El n-esimo primo es::",10,0
	strLimite: db "Límite de 32 bits excedido",10,0
	strPrimo: db "Si es primo",10,0
	strNoPrimo: db "No es primo",10,0

	flag dd 0 ; 
	temp dd 0 ; cuantos divisores propios tiene un numero
	n dd 0    ; numero primo encontrado
section .text

global _start 


_start:

PutStr strProposito
PutStr strIngreso
GetLInt ebx

PutStr strResultado
call nPrimos


fin:
	mov eax, 01
	INT 80h


;el número a comprobar está en eax
esPrimo:
	;se mueve eax al contador y se le resta 1
	mov dword [temp],0
	push eax
	push ebx
	push ecx 
	push edx
	 
	mov ecx,eax
	dec ecx
	; esi contiene el respaldo del numero original
	xor esi,esi
	mov esi,eax
	sumar_divisores:
	    CMP ECX, 0
	    JE comprobacion;Terminar si llegamos a 0
	
	    MOV EAX, ESI; Número original
	    XOR EDX, EDX; Limpiar edx
	    MOV EBX, ECX; Divisor candidato
	    DIV EBX 
	
	    CMP EDX, 0
	    JNE continuar            ; Si no es divisible, seguir
	
	    INC dword [temp]
	    continuar:
	        DEC ECX
	        JMP sumar_divisores
							
	comprobacion:
	CMP dword [temp],1
	JE verdadero
	mov dword [flag],0
	jmp final
	verdadero:
		mov dword [flag],1
	final:
	;retornar los valores de los registros
	pop edx
	pop ecx
	pop ebx
	pop eax 
	ret

;se va a comenzar desde 1 
nPrimos:
	mov eax,1 
	bucle:
	call esPrimo
	cmp byte [flag],1
	JE siEs
	jmp continuar1
	siEs:
	inc dword [n]

	continuar1:
		inc eax
		CMP dword [n],ebx
		JL bucle
	dec eax
	PutLInt eax
	nwln
ret
