;Autor: Manuel Fernández Mercado
;nombre: x86.asm
;Propósito: ingresar datos en un arreglo y obtener el promedio
;fecha de creación:18/09/2025
;fecha de modi:	   18/09/2025
;compilacion       nasm -f elf32 x86.asm 
;                  ld -m elf_i386 -s -o x86 x86.o io.o


%include "io.mac"
section .data

proposito db "Obtener el promedio de un arreglo",10,0

tamano  db "Ingrese el tamaño del arreglo::",10,0
datos db "Ingrese los datos del vector::",10,0
valor db "valor  en la posicion  ",0 
resultado db "El promedio del arreglo es:::",0
mostrandoArreglo db "Mostrando el arreglo",10,0
espacio db " ",0

;datos auxiliares

section .bss
nroElementos resd 1
vector resd 1000


section .text

global _start

_start:

PutStr proposito
PutStr tamano
GetInt [nroElementos]

;solicitar datos del arreglo
leer_datos:
	PutStr datos
	XOR ESI,ESI
	MOV ECX,[nroElementos]
leer_siguiente:
	PutStr valor
	PutLInt ESI
	nwln
	GetLInt EAX
	
	mov [vector +ESI*4],EAX
	INC ESI 
	LOOPNZ leer_siguiente

;se termino la lectura
XOR ESI,ESI
XOR EAX,EAX 
MOV ECX, [nroElementos]

PutStr mostrandoArreglo
mostrar_siguiente:
	mov EAX,[vector +ESI*4]
	PutLInt EAX
	PutStr espacio
	INC ESI 
	LOOPNZ mostrar_siguiente
nwln


XOR ESI,ESI
XOR EAX,EAX 
MOV ECX, [nroElementos]

sumaArreglo:
	MOV EDX,[vector +ESI*4] 
	ADD EAX, EDX
	INC ESI
	LOOPNZ sumaArreglo	 

fin:
	XOR EDX,EDX
	MOV EBX,[nroElementos]
	DIV EBX
	PutStr resultado
	PutLInt EAX 
	nwln
	MOV EAX,01
	INT 80h
