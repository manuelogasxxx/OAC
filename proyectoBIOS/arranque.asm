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
    call esperarTecla
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
strIngresar    db "Pulse enter para salir::::",13,10,0



imprimirCadena:
    push ax
    push bx
    .ciclo:
        lodsb
        cmp al,0
        jz .final
        mov ah,0x0E; número de interrupcion
        mov bx,0x07; servicio 7
        int 0x10; interrupcion 10
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

;rellenar hasta 510 bytes con NOP (No operation)
times 510-($-$$) db 144
dw 0xAA55; código mágico
;el arhivo si o si debe pesar 512 Bytes 
