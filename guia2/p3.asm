;nombre    : p3.asm
;Propósito : calcular los impuestos de 5ta categoría
;autor     : Manuel Fernández Mercado
;FCreacion : 27/08/2025
;FModif    : 28/08/2025
;compilar  :
;			 nasm -f elf32 p3.asm
;			 ls -m elf_i386 -s -o p3 p3.o io.o

;voy a probar a poner solo la renta para agilizar
%include "io.mac"

section .data
	;principales
		reGobReg dd 0
		reMinsa  dd 0
		UI dd 0
		deGobReg dd 0
		deMinsa  dd 0
	;secundarias
		reTotal  dd 0
		deTotal  dd 0
		rentaNeta dd 0
		impuestoT dd 0
		NA dd 0
		deuda dd 0
		;IMPUESTOS
		h_5UIT   dd 0;Hasta 5
		d5_20UIT  dd 0;de 5 a 20
		d20_35UIT dd 0;20 a 35
		d35_45UIT dd 0
		d45_UIT   dd 0
		;
		flag db 0
		temp dd 0

	;Carteles necesarios
	msjBienvenida     db "::::CALCULADORA DE IMPUESTOS::::",10,0
	msjIndicaciones   db "Ingrese los siguientes valores sin punto decimal",10,0
	msjRemuneraciones db "__REMUNERACIONES__",10,0
		msjGobReg db "Gobierno Regional::",0
		msjMinsa  db "Minsa::",0
		msjUI     db "Unidad Impositiva::",0
		msjNA     db "No afecto (7 UIT)::",0
	msjImpuesto db "__IMPUESTO__",10,0
	msjDeducciones db "__Deducciones__",10,0
	msjRetenciones db "__Retenciones en Exceso/Deuda__",10,0
	;revisar el formato de estas cadenas
	msjTotal db "TOTAL-> ",0
	msjSol db"S/.",0
	msjRN db "DIFERENCIA NETA (RENTA NETA)::",0

	msj db "primer tramo",0
	msjExonerado db "Exonerado de impuestos",10,0

	msjResultados db "---RESULTADOS---",10,0

	msjPrimera db "::Primera Categoría::",0
	msjSegunda db "::Segunda Categoría::",0
	msjTercera db "::Tercera Categoría::",0
	msjCuarta db "::Cuarta Categoría::",0
	msjQuinta db "::Quinta Categoría::",0
	
	
section .text
global _start

_start:
	;inicio mostrando los letreros
	PutStr msjBienvenida
	nwln
	PutStr msjIndicaciones
	nwln
	PutStr msjRemuneraciones
	;
	;obtengo la remuneracion del gob regional
	PutStr msjGobReg
	GetLInt eax
	mov [reGobReg], eax
	
	;obtengo la remuneracion de minsa
	PutStr msjMinsa
	GetLInt ebx
	mov [reMinsa], ebx
	
	;Obtengo el valor de la Unidad impositiva
	PutStr msjUI
	GetLInt ebx
	mov [UI], ebx

	;Obtengo el valor de las deducciones
	PutStr msjDeducciones
	PutStr msjGobReg
	GetLInt eax
	mov [deGobReg], eax

	;obtengo la remuneracion de minsa
	PutStr msjMinsa
	GetLInt ebx
	mov [deMinsa], ebx	

	;leidos todos los datos ya puedo hacer los cálculos
	;hago la suma de remuneraciones y la guardo en su variable
	MOV EBX,[reGobReg]
	MOV EAX,[reMinsa]
	ADD EBX,EAX
	MOV [reTotal], EBX; total de remuneraciones

	MOV EBX,[UI]
	MOV EAX, 7
	MUL EBX ;MUltiplico la UI*7 y la guardo en memoria 
	MOV [NA],EAX 

	MOV EBX, [reTotal]
	SUB EBX, EAX
	MOV [rentaNeta],EBX
	push ebx

	;si la renta neta es menor que 5UIT se exonera de impuestos

	;posteriormente pregunto si la renta es mayor o igual
	;límite superior (se aplica el porcentaje al rango )
	; sino: aplico total-lim inferior y a eso le saco el porcentaje
	;eso lo hago con cada caso
	
	nwln
	nwln
	PutStr msjResultados
	nwln
	;PutStr msjImpuesto
	;nwln
	;CALCULO DE LOS IMPUESTOS (LA PARTE MAS INSANA)
	XOR EAX,EAX
	MOV EAX,5
	MOV EBX,[UI]
	MUL EBX
	pop ebx
	;AQUI PREGUNTO SI LA RENTA ES MENOR A 5UIT
	CMP EBX,EAX; comparo el r
	;PUSH EBX; guardo rentaNeta en la pila
	PUSH EAX ; guardo el valor de las 5 UIT
	JAE primerTramo
	;PutStr msjImpuesto
	;está exonerado de impuestos
	PutStr msjExonerado
	JMP FIN

	;Aquí voy a poner unos letreros


	;LOS RESULTADOS PARCIALES SE PUEDEN MANDAR A IMPRIMIR
	primerTramo: ;EBX tiene el resultado de la MUL
		MOV EBX,EAX
		MOV EAX,8
		MUL EBX
		MOV EBX,100
		DIV EBX
		;PutLInt EAX
		MOV [h_5UIT],EAX
		;PutLInt EAX
		;nwln
		;PutStr msj
		;jmp FIN
		;comparo con 20 UIT, la comparación con 5UIT está implícita
		XOR EAX,EAX
		MOV EAX,20
		MOV EBX,[UI]
		MUL EBX
		MOV EBX, [rentaNeta]
		CMP EBX,EAX
		MOV ECX,EAX ; guardo el resultado de 20UIT
		MOV [temp],EAX
 		JAE segundoTramo
 		;si es mayor el límite superior es UIT*20
 		;sino el limite superior es la renta neta

		;aquí pongo la flag::
		MOV byte [flag],1
 		MOV EAX,EBX
 		jmp segundoTramo		

	segundoTramo:
		;hago la diferencia nada mas
		;PutStr msjBienvenida
		POP EBX
		SUB EAX,EBX; resta para saber lo que se tiene que pagar
		MOV EBX,EAX
		MOV EAX,14
		MUL EBX
		MOV EBX,100
		DIV EBX
		;PutLInt EAX
		MOV [d5_20UIT],EAX
		;PutLInt EAX
		;nwln

		;se viene la parte insana
		; si la flag se activó ya valió verga
		
		CMP byte [flag],1
		JE FIN
		;comparo con 35 UIT y 20 uit
		XOR EAX,EAX
		MOV EAX,35
		MOV EBX,[UI]
		MUL EBX
		
		MOV EBX, [rentaNeta]
		;PutLInt EAX
		;nwln
		;PutLInt EBX
		;nwln
		CMP EBX,EAX
		MOV ECX,EAX; aguas con esta parte***guardo los
		
		JAE tercerTramo
		;PutStr msjBienvenida
		;si es mayor el límite superior es UIT*20
		;sino el limite superior es la renta neta
		;PutLInt ECX
		MOV byte [flag],1
		MOV EAX,EBX
		jmp tercerTramo


		;jmp FIN
	
	
	tercerTramo:
	;empiezo haciendo la diferencia
		;POP EBX
		MOV EBX,[temp]
		;PutLInt EAX
		;nwln
		SUB EAX,EBX; resta para saber lo que se tiene que pagar
		;PutLInt EAX
		;nwln
		MOV EBX,EAX
		MOV EAX,17; porcentaje para el tercer tramo
		MUL EBX
		MOV EBX,100
		DIV EBX
		;PutLInt EAX
		MOV [d20_35UIT],EAX
		;PutLInt EAX
		;nwln
		;MOV [temp],EAX;guardo el valor de 35UIT***

		
		;PutStr msjIndicaciones


		;aqui viene la parte insana de 35 a 45
		CMP byte [flag],1
		JE FIN
		XOR EAX,EAX
		MOV EAX,45
		MOV EBX,[UI]
		MUL EBX
		MOV EBX, [rentaNeta]
		CMP EBX,EAX
		MOV [temp],eax;;;;
		JAE cuartoTramo
		;PutStr msjBienvenida
		MOV byte [flag],1
		MOV EAX,EBX
		jmp cuartoTramo

		;jmp FIN
		
	cuartoTramo:
		MOV EBX,ECX
		;PutLInt EBX
		;nwln
		SUB EAX,EBX; resta para saber lo que se tiene que pagar
		;PutLInt EAX
		;nwln
		MOV EBX,EAX
		MOV EAX,20; porcentaje para el tercer tramo
		XOR EDX,EDX
		MUL EBX
		MOV EBX,100
		XOR EDX,EDX
		DIV EBX
		;PutLInt EAX
		MOV [d35_45UIT],EAX
		;PutLInt EAX
		;nwln
		;MOV [temp],EAX;guardo el valor de 35UIT
		;PutStr msjIndicaciones

		CMP byte [flag],1;ya no pasa a la 5ta categoria
		JE FIN
		jmp quintoTramo
		;MOV EBX,[rentaNeta]
		;MOV EAX,[temp]
		;*
		;MOV EBX,[temp]
		;MOV EAX,[rentaNeta]
		;CMP EBX,EAX
		;*
		;MOV [temp],eax;;;;
		JAE quintoTramo ; el quinto tramo funciona diferente

		;PutStr msjBienvenida
		;MOV byte [flag],1
		;MOV EAX,EBX
		;jmp quintoTramo


		;jmp FIN
		
				;aqui viene la parte insana de 35 a 45

	quintoTramo:
		;MOV EBX,[temp]
		
		;PutLInt EBX
		;nwln
		;PutLInt EAX
				;nwln
		MOV EBX,[temp]
		MOV EAX,[rentaNeta]
		CMP EBX,EAX
		

		;PutStr msjIndicaciones
		SUB EAX,EBX; resta para saber lo que se tiene que pagar
		;PutLInt EAX
		;nwln
		MOV EBX,EAX
		MOV EAX,30; porcentaje para el tercer tramo
		MUL EBX
		MOV EBX,100
		DIV EBX
		;PutLInt EAX
		MOV [d45_UIT],EAX
		;PutLInt EAX
		;nwln
		jmp FIN

	
	;Calculo de las deducciones y almaceno en deTotal
	MOV EBX,[deGobReg]
	MOV EAX,[deMinsa]
	ADD EBX,EAX
	MOV [deTotal], EBX;

	;Calculo de la deuda final

	PutLInt [reTotal]
	nwln
	PutLInt [rentaNeta]
	nwln






;Fin del programa
;se impremen las directivas necesarias
	FIN:

	;realizo algunas operaciones
	MOV EAX,[h_5UIT]
	MOV EBX,[d5_20UIT]
	ADD EAX,EBX
	MOV ECX,[d20_35UIT]
	MOV EDX,[d35_45UIT]
	ADD ECX,EDX
	ADD EAX,ECX
	MOV EBX,[d45_UIT]
	ADD EAX,EBX
	MOV [impuestoT],EAX
	;
	MOV EBX,[deGobReg]
	MOV EAX,[deMinsa]
	ADD EBX,EAX
	MOV [deTotal], EBX;
	;
	MOV EAX,[impuestoT]
	SUB EAX,EBX;checar el signo
	MOV [deuda],EAX
	nwln

	;aqui voy a poner los datos leidos al inicio
	PutStr msjGobReg
	PutStr msjSol
	PutLInt [reGobReg]
	nwln

	PutStr msjMinsa
	PutStr msjSol
	PutLInt [reMinsa]
	nwln
	
	PutStr msjNA
	PutStr msjSol
	PutLInt [NA]
	nwln
	PutStr msjRN
	PutStr msjSol
	PutLInt [rentaNeta]
	nwln
	nwln
	PutStr msjImpuesto		
	PutStr msjPrimera
	PutStr msjSol
	PutLInt [h_5UIT]
	nwln
	PutStr msjSegunda
	PutStr msjSol
	PutLInt [d5_20UIT]
	nwln
	PutStr msjTercera
	PutStr msjSol
	PutLInt [d20_35UIT]
	nwln
	PutStr msjCuarta
	PutStr msjSol
	PutLInt [d35_45UIT]
	nwln
	PutStr msjQuinta
	PutStr msjSol
	PutLInt [d45_UIT]
	nwln
	PutStr msjTotal
	PutStr msjSol
	PutLInt [impuestoT]
	nwln
	nwln

	PutStr msjDeducciones
	PutStr msjGobReg
	PutStr msjSol
	PutLInt [deGobReg]
	nwln
	;
	PutStr msjMinsa
	PutStr msjSol
	PutLInt [deMinsa]	
	nwln
	;
	PutStr msjTotal
	PutStr msjSol
	PutLInt [deTotal]
	nwln
	nwln
	;
	PutStr msjRetenciones
	PutStr msjTotal
	PutStr msjSol
	PutLInt [deuda]
	nwln

		mov eax,01
		int 80h
