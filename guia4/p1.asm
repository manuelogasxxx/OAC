;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: ingresar datos en un arreglo y vreficar si un numero pertenece al arreglo
;fecha de creación:11/09/2025
;fecha de modi:	   11/09/2025
;compilacion       nasm -f elf32 p1.asm 
;                  ld -m elf_i386 -s -o p1 p1.o io.o



%include "io.mac"
section .data

proposito db "Verifica si un numero está en un arreglo",10,0

tamano  db "Ingrese el tamaño del arreglo::",10,0
datos db "Ingrese los datos del vector::",10,0
valor db "valor  en la posicion  ",0 
busqueda db "¿que valor desea buscar?::",10,0
msjEncontrado db "SI está en el arreglo",10,0
msjNoEncontrado db "NO está en el arreglo",10,0

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

;set termino la lectura
XOR ESI,ESI
XOR EAX,EAX 
MOV ECX, [nroElementos]

;mostrar el arreglo 
PutStr busqueda
GetLInt EBX

verificacion:
	MOV EDX,[vector +ESI*4] 
	CMP EBX, EDX
	JE encontrado
	INC ESI
	LOOPNZ verificacion	
	PutStr msjNoEncontrado
	jmp fin

encontrado:
	PutStr msjEncontrado
	JMP fin 

fin:
	MOV EAX,01
	INT 80h
