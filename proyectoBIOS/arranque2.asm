[BITS 16]
[ORG 0x0]

; Inicializador de segmentos
    mov ax, 0x7c0           ; Dirección de arranque
    mov ds,ax
    mov es,ax
    mov ax,0x8000
    mov ss,ax
    mov sp,0xf000

; Mostrar mensajes
    mov si, strBienvenida1
    call imprimirCadena
    mov si, strBienvenida2
    call imprimirCadena
    mov si, strBienvenida3
    call imprimirCadena
    
    ; *** Nuevo: Pedir y leer la cadena ***
    mov si, strPedirCadena
    call imprimirCadena     ; Mostrar mensaje para solicitar entrada
    
    mov di, cadenaUsuario   ; ES:DI apunta al buffer
    call leerCadenaBIOS     ; Leer la cadena del usuario
    
    ; *** Nuevo: Mostrar la cadena leída ***
    mov si, strCadenaLeida
    call imprimirCadena
    mov si, cadenaUsuario   ; SI apunta al inicio de la cadena
    call imprimirCadena     ; La rutina de impresión ahora usa el terminador NULL
    
    ; Esperar una tecla para finalizar
    mov si, strFinalizado
    call imprimirCadena
    call esperarTecla
    
end:
    jmp end
; Ciclo infinito

; --- Definiciones de Datos ---
strBienvenida1 db "|------------------------|",13,10,0
strBienvenida2 db "|-----Booteador BIOS-----|",13,10,0
strBienvenida3 db "|------------------------|",13,10,0
strFinalizado  db 13,10,"Programa finalizado......:)",13,10,0
strPedirCadena db 13,10,"Escribe algo (max 30 caracteres) y pulsa ENTER: ",0
strCadenaLeida db 13,10,"La cadena que ingresaste es: ",13,10,0

; *** Nuevo: Buffer para almacenar la cadena del usuario ***
; Usamos 31 bytes: 30 para la cadena + 1 para el terminador NULL (0)
MAX_LONGITUD equ 30
cadenaUsuario  db 31 dup(0) 

; --- Rutinas Antiguas (imprimirCadena y esperarTecla) ---

imprimirCadena:
    ; (No necesita cambios, sigue usando SI y el terminador NULL)
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


; --- Nueva Rutina de Lectura de Cadena (Puro BIOS) ---

leerCadenaBIOS:
    ; Lee caracteres uno por uno usando INT 0x16 hasta que se pulsa ENTER o se alcanza el límite.
    ; DI debe apuntar al inicio del buffer (cadenaUsuario)
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov cx, MAX_LONGITUD    ; CX = contador de caracteres restantes
    mov bx, di              ; Guardar DI original para poner el NULL al final
    
    .bucle_lectura:
        ; 1. Leer tecla (con espera)
        mov ah, 0x00        ; INT 0x16, AH=0: Esperar y leer pulsación
        int 0x16
        
        cmp al, 0x0D        ; ¿Es ENTER (Retorno de Carro)?
        je .final_lectura   ; Si es ENTER, terminar
        
        ; 2. Comprobar límite
        cmp cx, 0           ; ¿Hemos alcanzado la longitud máxima?
        je .bucle_lectura   ; Si es 0, ignorar la tecla y seguir esperando ENTER
        
        ; 3. Mostrar carácter (Eco)
        push ax             ; Guardar AL (carácter)
        mov ah, 0x0E        ; INT 0x10, AH=0x0E: Teletype Output
        mov bx, 0x07        ;explicar el formato de escritura
        int 0x10
        pop ax
        
        ; 4. Almacenar carácter
        stosb               ; [DI] = AL, DI = DI + 1
        loop .bucle_lectura ; Decrementar CX y saltar si no es cero
        
    .final_lectura:
        ; Almacenar terminador NULL (0) en el final de la cadena
        mov al, 0           
        stosb               ; [DI] = 0 (Terminador NULL)
        
        ; Emitir Nueva Línea (CR/LF) después del ENTER
        mov al, 0x0A        ; Line Feed
        mov ah, 0x0E
        mov bx, 0x07
        int 0x10
        
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret

; Rellenar hasta 510 bytes con NOP (No operation)
times 510-($-$$) db 144
dw 0xAA55 ; Código mágico (Magic code)