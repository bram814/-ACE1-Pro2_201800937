
; ************** [IMPRIMIR] **************
GetPrint macro texto
    mov dx, offset texto
    mov ah, 09h
    int 21h
endm
; ************** [CAPTURAR ENTRADA] **************
GetInput macro
    MOV AH,01H
    int 21H
endm

GetTeclado macro
    mov ax, 0h
    mov ah, 0h
    int 16h
endm

limpiarp macro
    mov ah, 00h
    mov al, 03h
    int 10h
endm
; ************** [CAPTURAR ENTRADA] **************
imprimir macro texto
    mov dx, offset texto
    mov ah, 09h
    int 21h
endm

GetInputMax macro _resultS
    mov ah, 3fh                     ; int21 para leer fichero o dispositivo
    mov bx, 00                      ; handel para leer el teclado
    mov cx, 20                      ; bytes a leer (aca las definimos con 10)
    mov dx, offset[_resultS]
    int 21h
endm


cleanVariable macro tam, variable
    local Linicio, Lfinal
    xor SI, SI
    Linicio:
        mov variable[SI], 24H
        inc SI
        cmp SI, tam
        je Lfinal

        jmp Linicio
    Lfinal:

endm

; ************** [READ]PASSWORD **************
ReadPassword macro
    local e1, e2
    e1:
        mov ax, 00h
        mov ah, 08h
        int 21h
        cmp al, 0dh
        je e2
        cmp al, 1bh
        je Lmenu
        mov _password[si], al
        inc si
        mov _password[si], '$'
        mov ah, 2h
        mov dl, '*'
        int 21h
        jmp e1
    e2:
endm


GetOpenFile macro buffer,handler
    mov ah,3dh
    mov al,02h
    lea dx,buffer
    int 21h
    jc Lerror1
    mov handler,ax
endm
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
    mov ah,3eh
    mov bx,handler
    int 21h
    jc Lerror2
endm
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc Lerror5
endm


login macro
    local e1, e2, e3, e4

    ; cleanVariable 100, _user
    ; cleanVariable 100, _password

    GetPrint _salto
    GetPrint _cadena13
    GetInputMax _user
    
    GetPrint _cadena14
    ReadPassword

    ; GetPrint _salto
    ; GetPrint _user
    ; GetPrint _password

    e1:
        
        cleanVariable 100, _SavedUser
        cleanVariable 100, _SavePass
        GetSaveUsers
        GetVerifiedUser _user, _SavedUser

        cmp _isBool, 1
        je e2
        jmp e3

    e2: ; correcto

        GetVerifiedUser _password, _SavePass

        cmp _isBool, 0
        je errorpass
        mov _tamFile, 0
        jmp ingresarsist


    e3: ; incorrecto

        mov si, _tamFile
        cmp _bufferInfo[si], 24h
        je errornoexiste

        jmp e1

endm


GetSaveUsers macro
    local e1, e2, e3, e4
    ;GetRoot     _bufferInput  ; Capturar Path
    
    mov si, _tamFile
    xor bx, bx

    e1: ; guarda user

        cmp _bufferInfo[si], ','
        je e2
        mov al, _bufferInfo[si]
        mov _SavedUser[bx], al 
        INC si
        INC bx

        jmp e1

    e2:
        INC si ; pasa de ,
        xor bx,bx
    e3:
    
        cmp _bufferInfo[si], 0Ah
        je e4
        mov al, _bufferInfo[si]
        mov _SavePass[bx], al 
        INC si
        INC bx

        jmp e3
    e4:
        ; GetPrint _salto
        ; GetPrint _SavedUser
        ; GetPrint _SavePass
        ; GetPrint _salto
        inc si
        mov _tamFile, si

endm


GetVerifiedUser macro p1, p2
    local e1, e2, e3, e4, e5

    xor si, si
    xor al, al
    ; GetPrint _palo
    e1:
        mov al, p1[si]
        cmp al, 24h
        je e2
        
        jmp e3

    e3:
        mov al, p2[si]
        cmp al, 24h
        je e4
        cmp al, p1[si]
        jne e2
        inc si
      
        jmp e3


    e4: ; usuario existe
        mov _isBool, 1
        jmp e5

    e2: ; no existe el usuario
        mov _isBool, 0
        jmp e5

    e5:



endm


; ************** [PATH][WRITE] **************
GetWriteFile macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX
    ; MOV AH,40h
    ; MOV BX,handler
    ; MOV CX, SIZEOF buffer 

    XOR BX, BX
    XOR AX, AX 
    ciclo_Ini:
      MOV AL, buffer[ BX ]
      CMP AL, '$'
      JE ciclo_Fin

      INC BX 
      JMP ciclo_Ini
    ciclo_Fin:
    XOR AX, AX

    MOV contadorBuffer, BX
    XOR BX, BX
    
    MOV AH,40h
    MOV BX,handler
    MOV CX, contadorBuffer
    LEA DX, buffer
    INT 21h
endm

; ************** [PATH][CREATE] **************
GetCreateFile macro buffer,handler
    MOV AX,@data
    MOV DS,AX
    MOV AH,3ch
    MOV CX,00h
    LEA DX,buffer
    INT 21h
    ;jc Error4
    MOV handler, AX
endm


GetValidateUser macro p1, tam1, tam2
    local e1, e2, e3, e4, e5

    xor si, si
    mov _isBool, 0

    e1:

        cmp p1[si], 24h
        je e2

        inc si
        jmp e1

    e2:
        cmp si, tam1
        jle e3

        cmp si, tam2
        jg e3

        jmp e4
    e3:
        mov _isBool, 0
        jmp e5
    e4:
        mov _isBool, 1
        jmp e5
    e5:


endm


ConcaUsers macro p1
    local e1, e2, e3
    xor si, si
    e1: 

        mov bl, p1[si]
        mov _SavedUser[di], bl
        cmp bl, 0Ah
        je e2
        cmp bl, '$'
        je e2
        INC si
        INC di

        jmp e1

    e2:

        
        ; GetPrint _salto
        ; GetPrint _SavedUser


endm

; nave

auxdiblinea macro vector, tam
;se le mueve a di en la posicion en la que se empezara a dibujar
;esta macro sirve para dibujar una linea
    mov di, ax
    mov si, offset vector
    mov cx, tam
    rep movsb
endm


dibujarnave macro
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    auxdiblinea naveFila1, 11
    add ax, 320
    auxdiblinea naveFila2, 11
    add ax, 320
    auxdiblinea naveFila3, 11
    add ax, 320
    auxdiblinea naveFila4, 11
    add ax, 320
    auxdiblinea naveFila5, 11
    add ax, 320
    auxdiblinea naveFila6, 11
endm



dibujardis macro
;macro para dibujar el disparo por primera vez
    push cx
    xor cx, cx
    mov cx, 320
    mul cx
    add ax, bx
    mov di, ax
    pop cx
    auxdiblinea disparoFila1, 1
    add ax, 320
    auxdiblinea disparoFila2, 1
    add ax, 320
    auxdiblinea disparoFila3, 1
    add ax, 320
    auxdiblinea disparoFila4, 1
endm


redibujardis macro
;macro que sirve para ir moviendo el disparo hacia arriba
    local e1, salir, quitardisparo, salir1
    ;aqui valida que haya un disparo 
    cmp ydis, 0
    je salir
    ;cada vez que se repinta 5 veces la pantalla va a subir el disparo 1 pixel
    ;inc contador
    ;cmp contador, 5
    ;je e1
    ;jne salir
    e1:
    sub ax, 10
    mov ydis, ax
    dibujardis
    mov contador, 0
    salir:
    cmp ydis, 22
    jb quitardisparo
    jne salir1
    quitardisparo:
    mov ydis, 0
    mov xdis, 0
    salir1:
endm


imprimirnombre macro
    local e1, e2
    mov dl, 0
    e1:
    ;posicion del cursor
        mov ah, 02h
        ;dh fila
        mov dh, 0
        ;dl columna
        mov dl, dl
        int 10h
        mov dx, offset _user
        mov ah, 09h
        int 21h
    e2:
endm


; imprimirPantalla macro text, fila
;     local e1, e2
;     mov dl, 0
;     e1:
;     posicion del cursor
;         mov ah, 02h
;         ;dh fila
;         mov dh, fila
;         dl columna
;         mov dl, dl
;         int 10h
;         mov dx, offset text
;         mov ah, 09h
;         int 21h
;     e2:
; endm


imprimirtiempo macro
    mov al, minutos
    aam
    mov decminutos, ah
    mov uniminutos, al
    mov al, segundos
    aam
    mov decsegundos, ah
    mov unisegundos, al
    
    mov dl, 35
    e1:
        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add decminutos, '0'
        mov al, decminutos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add uniminutos, '0'
        mov al, uniminutos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        mov al, 58
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add decsegundos, '0'
        mov al, decsegundos
        mov bl, 1fh
        mov cx, 1
        int 10h

        inc dl

        mov ah, 02h
        mov dh, 0
        mov dl, dl
        int 10h

        mov ah, 09h
        add unisegundos, '0'
        mov al, unisegundos
        mov bl, 1fh
        mov cx, 1
        int 10h
endm

dibujarmarco macro
    local e1, e2, e3, e4, e5
    ;convertir las coordenadas x y y para la lineazalizacion 
    ;se multiplican por 320 que es el ancho de la matriz la posicion en y
    mov cx, 320
    mul cx
    ;al resultado se le suma la posicion en x
    add ax, bx
    mov di, ax
    e1:
        ;comienza a dibujar el marco desde arriba
        auxdiblinea lineamarco, 20;0
        add ax, 20;
        auxdiblinea lineamarco, 20;20
        add ax, 20 ; ax = 20 + 20
        auxdiblinea lineamarco, 20;40
        add ax, 20
        auxdiblinea lineamarco, 20;60
        add ax, 20
        auxdiblinea lineamarco, 20;80
        add ax, 20
        auxdiblinea lineamarco, 20;100
        add ax, 20
        auxdiblinea lineamarco, 20;120
        add ax, 20
        auxdiblinea lineamarco, 20;140
        add ax, 20
        auxdiblinea lineamarco, 20;160
        add ax, 20
        auxdiblinea lineamarco, 20;180
        ;segunda linea marco
        add ax, 140; ax=320
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 340
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 360
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 380
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 400
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 420
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 440
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 460
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 480
        auxdiblinea lineamarco, 20
        add ax, 20
        ;ax = 500
        auxdiblinea lineamarco, 20
        ;empieza a dibujar lado izquierdo
        add ax, 140
        ;ax = 640
        auxdiblinea lineamarco1, 2
        push ax
        ;se guarda ax con 640
        xor si, si
    e2:
        push si
        ;se le suman 320 para llegar a la siguiente linea
        add ax, 320
        ;se dibuja la linea vertical de la izquierda
        auxdiblinea lineamarco1, 2
        pop si
    e3:
        inc si
        cmp si, 170
        jne e2
    
        pop ax
        ;ax = 640
        add ax, 198
        ;se le suman 198 porque toda la linea tiene una longitud de 200
        ;se dibuja la linea vertical de la derecha
        auxdiblinea lineamarco1, 2
        xor si, si
    e4:
        push si
        add ax, 320
        auxdiblinea lineamarco1, 2
        pop si
    e5:
        ;se dibujan las dos lineas del marco de abajo
        inc si
        cmp si, 170
        jne e4
        sub ax, 198
        ;se le restan 198 para regresar al inicio de la posicion en x
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 140
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
        add ax, 20
        auxdiblinea lineamarco, 20
endm




GetPlay macro 
    local inicioj, inicioj1, tiempo1, masseg, masmin, inicioj2, WaitNotVSync, WaitNotVSync2, WaitVSync, WaitVSync2, disparar, disparar1, moverizq, moverder, finj, salir

    xor si, si
    ;entra en modo grafico
    ;ah = 0
    ;al = 13h
    ;Resolucion 320x200 con 256 colores
    mov ax, 13h
    int 10h
    ;offset de la memoria de video importante
    mov ax, 0A000h
    mov es, ax
    ;coordenadas donde empezara a dibujar la nave
    mov xnave, 150
    mov ynave, 185
    ;set tiempo en 0
    mov segundos, 0
    mov minutos, 0
    mov micsegundos, 0
    inicioj:
         mov ah, 0
        mov al, 13h
        int 10h
     
        ;se guardan los valores de los registros ax y bx ya que se modificaran 
        push ax
        push bx
        imprimirnombre
        imprimirtiempo 
        ; imprimirPantalla 
    inicioj1:
        mov ax, 20 ;y
        mov bx, 50 ;x
        dibujarmarco
        tiempo1:
            mov al, micsegundos
            inc al
            cmp al, 10
            je masseg
            mov micsegundos, al
            jmp inicioj2
        masseg:
            mov al, segundos
            inc al
            cmp al, 60
            je masmin
            mov segundos, al
            mov al, 0
            mov micsegundos, al
            jmp inicioj2
        masmin:
            mov al, minutos
            inc al
            mov minutos, al
            mov al, 0
            mov segundos, al
            mov micsegundos, al
    inicioj2:
        mov ax, ynave ;coordenada y de la nave
        mov bx, xnave ; coordenada x de la nave
        dibujarnave
        mov ax, ydis ; coordenada y del disparo
        mov bx, xdis ; coordenada x del disparo
        redibujardis ; manda a llamar la macro para redibujar el disparo
        ;se sacan los valores de ax y bx
        pop bx
        pop ax
        ;se llaman los metodos para la sincronizacion de la pantalla
        ;esto se usa para que no titile tanto la pantalla
        mov dx, 03dah
        WaitNotVSync:
            in al, dx
            and al, 08h
            jnz WaitNotVSync
        WaitVSync:
            in al, dx
            and al, 08h
            jz WaitVSync

        mov dx, 03dah
        WaitNotVSync2:
            in al, dx
            and al, 08h
            jnz WaitNotVSync2
        WaitVSync2:
            in al, dx
            and al, 08h
            jz WaitVSync2

        ;call Delay; jugar con los valores del delay para que no titile tanto la pantalla
        mov cx, 0000h
        mov dx, 0fffffh
        mov ah, 86h
        int 15h
        ;call HasKey;este procedimiento verifica que se haya pulsado una tecla, si no regresa al inicio del juego a repintar la pantalla
        push ax
        mov ah, 01h
        int 16h
        pop ax
        jz inicioj
        call GetChar;verifica la tecla que pulso
        cmp al, 20h;tecla de espacio
        je finj
        cmp al, 76h;v minuscula para disparar
        je disparar
        cmp ax, 4b00h;flecha de la izquierda
        je moverizq
        cmp ax, 4d00h;flecha de la derecha
        je moverder
        jmp inicioj;vuelve al inicio del juevo para repintar la pantalla
    disparar:
        cmp ydis, 0;verifica que no haya disparo
        je disparar1;si no hay se va a la etiqueta que dibuja el disparo
        jmp inicioj ; si hay vuelve al inicio del juego para repintar la pantalla
    disparar1:
    ;guarda los valores de ax y bx en la pila
        push ax
        push bx
        ;limpia los valores de ax y bx
        xor ax, ax
        xor bx, bx
        mov ax, xnave
        add ax, 5h
        mov xdis, ax; usamos la coordenada de x de la nave y se le suman 5 para correrlo 5 pixeles
        mov ax, ynave
        sub ax, 5
        mov ydis, ax; usamos la coordenada y de la nave y se le restan 5 para que este 5 pixeles arriba 
        mov ax, ydis
        mov bx, xdis
        dibujardis
        pop bx
        pop ax
        jmp inicioj
    moverizq:
        push ax
        mov ax, xnave; movemos la posicion de la nave al registro ax
        cmp ax, 52;comparamos si se puede mover a la izquierda, teniendo en cuenta que la coordenada x donde empieza el marco es la 50
        ;se le suman los dos pixeles de la linea vertical
        je inicioj;si es igual regresa al inicio del juego
        dec ax;si no es igual le resta 1 al valor de ax
        mov xnave, ax; se vuelve a asignar este valor a la coordena x de la nave
        pop ax
        jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
    moverder:
        push ax
        mov ax, xnave
        cmp ax, 237;se compara si se puede mover aun a la derecha, teniendo en cuenta que se empezo en la 50 y termino en la 250, a esto
        ;se le restan los 2 de la linea vertical quedando en 248, y aun se le debe restar los 11 del ancho de la nave dejando el resultado como 237
        je inicioj
        inc ax; si no es igual se incrementa el registro ax
        mov xnave, ax; se regresa a asignar el valor a la coordenada x de la nave
        pop ax
        jmp inicioj;se regresa a repintar el juego con la nueva posicion de x
    finj:
        ;regresa el control de la pantalla a modo texto
        mov ax, 3h
        int 10h
        jmp salir
    salir:
        

endm