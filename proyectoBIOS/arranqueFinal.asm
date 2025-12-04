;Autores:           Manuel Fernández Mercado && Jeliel
;nombre:            arranque.asm
;Propósito:         Hacer uso a interrupciones del BIOS en un dispositivo x86
;fecha de creación: 28/11/2025
;fecha de modi:	    28/11/2025

;Entorno de ejecución: Ubuntu WSL2 W11
;Paquetes necesarios: NASM, QEMU (i386)
;$sudo apt install -y nasm
;$sudo apt-get install qemu-system
;$sudo apt install qemu-system-x86 

;compilación: nasm -f bin arranque.asm -o boot.img
;crea una imagen ejecutable, "-f bin" significa binario puro sin cabeceras
;ejecución;   qemu-system-i386 -fda boot.img
;emula un sistema completo 80386, "-fda" significa que el siguiente argumento será-
;el dispositivo de arranque del sistema.

[BITS 16]
[ORG 0x0]

;inicializador de segmentos
mov ax, 0x7c0          ;dirección de arranque
mov ds,ax
mov es,ax
mov ax,0x8000
mov ss,ax
mov sp,0xf000

;mostrar mensajes
mov si, strBienvenida1
call imprimirCadena
;
mov si, strBienvenida2
call imprimirCadena
;
mov si, strBienvenida3
call imprimirCadena

.bucle:
    mov si, strIngresar
    call imprimirCadena
    ;se guarda en DI el inicio de la cadena a guardar
    mov di, cadenaUsuario
    call esperarTecla2
    ;
    mov si, strResultado
    call imprimirCadena
    ;
    mov si, cadenaUsuario
    call imprimirCadena
    ;aqui se va a hacer la comparación
    call compararCadenas
    jz  .correcta
    jmp .incorrecta
    
    .correcta:
        mov si, strOk
        call imprimirCadena
        mov si, strFinOk
        call imprimirCadena
        jmp end

    .incorrecta:
        mov si, strNotOk
        call imprimirCadena
        jmp .bucle

end:
    jmp end
;ciclo infinito

;mensajes
strBienvenida1 db "|------------------------|",13,10,0
strBienvenida2 db "|-----Booteador BIOS-----|",13,10,0
strBienvenida3 db "|------------------------|",13,10,0
strIngresar    db "Ingrese la contrasena::::",13,10,0
strResultado   db 13,10,"Contrasena ingresada:::",13,10,0
strOk          db 13,10,"Es correcta!...",13,10,0
strNotOk       db 13,10,"Es incorrecta!...Pruebe de nuevo",13,10,0
strFinOk       db 13,10,"Continuando operaciones....",13,10,0

;buffer de datos
;equivalente a #define
MAX_LONGITUD equ 30
;31 bytes con caracter nulo
cadenaUsuario  db 31 dup(0)
;contraseña predefinida
PASSWORD       db "12345",0

;imprime una cadena iniciada en SI
imprimirCadena:
    push ax
    push bx
    .ciclo:
        ;Load String Byte
        ;AL->[SI];SI++
        lodsb
        ;¿fin de linea?
        cmp al,0
        jz .final
        ;interrupcion 0x10 funcion 0x0E
        ;Teletype output 
        mov ah,0x0E
        ;mov bx,0x07
        int 0x10
        jmp .ciclo 
    .final:
        pop bx
        pop ax
ret

esperarTecla:
    push ax
    push bx
    .bucle:
        mov ah,0x00
        int 0x16
        push ax
        ;el caracter leido se guarda en AL
        mov ah,0x0E;teletype output
        ;mov bx,0x03; bh página de video, BL color
        int 0x10
        pop ax
        cmp al,0x0D; caracter enter
        JNE .bucle
    pop bx
    pop ax
ret

;se guarda un máximo de 31 caracteres y se espera un "enter"
esperarTecla2:
    ;guardar registros
    pusha
    mov cx, MAX_LONGITUD
    ;leer caracter por caracter y guardarlo en memoria
    .bucle_lectura:
        ;funcion 0 de la int 16
        mov ah,0x00
        int 0x16
        ;caracter enter
        cmp al,0x0D
        je .final_lectura
        ;fin de cadena
        cmp cx,0
        je .bucle_lectura

        ;mostrar el caracter
        push ax
        ;asterisco
        mov al,0x2A
        ; funcion 0x0E int 0x10
        mov ah,0x0E 
        mov bx,0x07
        int 0x10
        pop ax
        
        ;almacenar el caracter
        ;[DI]->AL y DI++
        stosb
    loop .bucle_lectura

    .final_lectura:
        mov al,0;caracter nulo
        stosb
        ;escribir nueva linea
        mov al, 0x0A 
        mov ah, 0x0E
        ;mov bx, 0x07
        int 0x10

    popa
ret

compararCadenas:
    pusha
    ;punteros a las cadenas
    mov si, cadenaUsuario
    mov di, PASSWORD
    .loop_comparacion:
        lodsb; carga en AL [SI] y SI++
        mov bl,[di]
        ;comparar
        cmp al,bl
        jne .no_iguales
        cmp al,0
        je .iguales; si se llegó al final son iguales
        inc di; incrementa el puntero de la contraseña
        jmp .loop_comparacion
        .iguales:
            ;clc;clear carry flag
            xor ax,ax ; poner en 1 ZF
            cmp ax,0
            jmp .fin_comparacion
        .no_iguales:
            ;stc;set carry flag
            mov al,1
            cmp al,0
        .fin_comparacion:
    popa
ret 


;rellenar hasta 510 bytes con NOP (No operation)
times 510-($-$$) db 144
dw 0xAA55; código mágico
;el arhivo si o si debe pesar 512 Bytes 