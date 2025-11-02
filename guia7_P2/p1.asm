;Autor: Manuel Fernández Mercado
;nombre: p1.asm
;Propósito: obtener los n primeros numeros primos
;fecha de creación:9/10/2025
;fecha de modi:	   9/10/2025
;compilacion       nasm -f elf32 p1.asm 
;                  ld -m elf_i386 -s -o p1 p1.o io.o


%include "io.mac"


section .data
    strProposito: db "Prog que calcula la suma de los primos en un arreglo de 20 elementos",10,0
    strIngreso:   db "Ingrese los valores del arreglo "
    strResultado: db "La suma es::",0
    strIzquierda: db "[",0
    strDerecha:   db "]:",0

	temp: dd 0
	flag: dd 0
	suma: dd 0

section .bss
	nroElementos resd 1
    vector resd 20

section .text

global _start

_start:

PutStr strProposito
call leer_datos
;aqui inicia el programa:
xor esi,esi
mov ecx,20

bucle:
	
	mov edx, [vector + esi*4]
	push edx; pasar el valor a la pila
	call esPrimo
	cmp dword [flag],1
	JE siEsPrimo
	jmp siguiente
	siEsPrimo:
		;
		;
		mov edx, [vector + esi*4]
		add [suma],edx
		PutLInt edx
		jmp siguiente
	siguiente:
		inc esi
		dec ecx
		JNZ bucle

PutStr strResultado
PutLInt [suma]




fin:
    mov eax,01
    int 80h

;espacio para los modulos

;lectura de arreglo (sin paso de parametros)
leer_datos:
	PutStr strIngreso
	XOR ESI,ESI
	MOV ECX,20
leer_siguiente:
	PutStr strIzquierda
	PutLInt ESI
    PutStr strDerecha
	GetLInt EAX
	nwln
	
	mov [vector +ESI*4],EAX
	INC ESI 
	LOOPNZ leer_siguiente

;set termino la lectura

;modificarlo para que agarre desde la pila
esPrimo:
    enter 0, 0
    mov dword [temp], 0
    
    ; Preservar registros
    push eax
    push ebx
    push ecx 
    push edx
    push esi
    
    ; Obtener parámetro de la pila (EBP+8)
    mov ecx, [ebp+8]
    
    ; Verificar casos especiales
    cmp ecx, 1
    jle no_primo           ; 0 y 1 no son primos
    
    ; Inicializar variables
    mov esi, ecx           ; Respaldar número original
    dec ecx                ; Empezar desde n-1
    
    sumar_divisores:
        cmp ecx, 1
        jl comprobacion    ; Terminar cuando lleguemos a 1
        
        mov eax, esi       ; Número original
        xor edx, edx       ; Limpiar EDX antes de DIV
        mov ebx, ecx       ; Divisor candidato
        div ebx            ; EAX / EBX → residuo en EDX
        
        cmp edx, 0
        jne continuar      ; Si no es divisible, seguir
        
        ; Sumar contador
        inc dword [temp]
        
    continuar:
        dec ecx
        jmp sumar_divisores
                            
    comprobacion:
    ; Un número primo tiene exactamente 1 divisor (además de 1 y sí mismo)
    cmp dword [temp], 1
    je verdadero
    
    no_primo:
    mov dword [flag], 0
    jmp final
    
    verdadero:
    mov dword [flag], 1
    
    final:
    ; Restaurar registros
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret 4  ; Limpiar 4 bytes del parámetro