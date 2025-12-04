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
    mov si, strBienvenida2
    call imprimirCadena
    mov si, strBienvenida3
    call imprimirCadena
    ;
    mov si, strIngresar
    call imprimirCadena
    ;call esperarTecla
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
        jmp end

    .incorrecta:
        mov si, strNotOk
        call imprimirCadena
        jmp end

    mov si, strFinalizado
    call imprimirCadena
end:
    
    jmp end
;ciclo infinito

;mensajes
strBienvenida1 db "|------------------------|",13,10,0
strBienvenida2 db "|-----Booteador BIOS-----|",13,10,0
strBienvenida3 db "|------------------------|",13,10,0
strFinalizado  db 13,10,"Programa finalizado......:)",13,10,0
strIngresar    db "Ingrese la contrasena::::",13,10,0
strResultado   db 13,10,"Contraseña ingresada:::",13,10,0
strOk          db 13,10,"Es correcta!",13,10,0
strNotOk       db 13,10,"Es incorrecta!",13,10,0

;buffer de datos
MAX_LONGITUD equ 30
cadenaUsuario  db 31 dup(0)
PASSWORD       db "12345",0

imprimirCadena:
    push ax
    push bx
    .ciclo:
        lodsb
        cmp al,0        ;¿fin de linea?
        jz .final
        mov ah,0x0E     ; número de interrupcion
        mov bx,0x07     ; atributos de la impresion
        int 0x10        ; interrupcion 10
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
        mov bx,0x07; bh página de video, BL color
        int 0x10
        pop ax
        cmp al,0x0D; caracter enter
        JNE .bucle
    pop bx
    pop ax
ret

esperarTecla2:
    ;guardar registros
    pusha
    mov cx, MAX_LONGITUD
    ;leer caracter por caracter y guardarlo en memoria
    .bucle_lectura:
        ;funcion 0 de la int 16
        mov ah,0x00
        int 0x16

        cmp al,0x0D
        je .final_lectura

        cmp cx,0
        je .bucle_lectura

        ;mostrar el caracter
        push ax
        mov al,0x2A; asterisco
        mov ah,0x0E ; funcion E int 1
        mov bx,0x07
        int 0x10
        pop ax
        
        ;almacenar el caracter
        stosb;guarda en [DI] AL y DI++
    loop .bucle_lectura

    .final_lectura:
        mov al,0;caracter nulo
        stosb

        ;escribir nueva linea
        mov al, 0x0A        ; Line Feed
        mov ah, 0x0E
        mov bx, 0x07
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