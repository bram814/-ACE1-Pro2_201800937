
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

; ; ****************************** NAVE ****************************


; auxdiblinea macro vector, tam
; ;se le mueve a di en la posicion en la que se empezara a dibujar
; ;esta macro sirve para dibujar una linea
;     mov di, ax
;     mov si, offset vector
;     mov cx, tam
;     rep movsb
; endm


; dibujarnave macro
;     mov cx, 320
;     mul cx
;     add ax, bx
;     mov di, ax
;     auxdiblinea naveFila1, 11
;     add ax, 320
;     auxdiblinea naveFila2, 11
;     add ax, 320
;     auxdiblinea naveFila3, 11
;     add ax, 320
;     auxdiblinea naveFila4, 11
;     add ax, 320
;     auxdiblinea naveFila5, 11
;     add ax, 320
;     auxdiblinea naveFila6, 11
; endm


; dibujardis macro
; ;macro para dibujar el disparo por primera vez
;     push cx
;     xor cx, cx
;     mov cx, 320
;     mul cx
;     add ax, bx
;     mov di, ax
;     pop cx
;     auxdiblinea disparoFila1, 1
;     add ax, 320
;     auxdiblinea disparoFila2, 1
;     add ax, 320
;     auxdiblinea disparoFila3, 1
;     add ax, 320
;     auxdiblinea disparoFila4, 1
; endm


; redibujardis macro
; ;macro que sirve para ir moviendo el disparo hacia arriba
;     local e1, salir, quitardisparo, salir1
;     ;aqui valida que haya un disparo 
;     cmp ydis, 0
;     je salir
;     ;cada vez que se repinta 5 veces la pantalla va a subir el disparo 1 pixel
;     ;inc contador
;     ;cmp contador, 5
;     ;je e1
;     ;jne salir
;     e1:
;     sub ax, 10
;     mov ydis, ax
;     dibujardis
;     mov contador, 0
;     salir:
;     cmp ydis, 22
;     jb quitardisparo
;     jne salir1
;     quitardisparo:
;     mov ydis, 0
;     mov xdis, 0
;     salir1:
; endm


; imprimirnombre macro
;     local e1, e2
;     mov dl, 0
;     e1:
;     ;posicion del cursor
;         mov ah, 02h
;         ;dh fila
;         mov dh, 0
;         ;dl columna
;         mov dl, dl
;         int 10h
;         mov dx, offset user
;         mov ah, 09h
;         int 21h
;     e2:
; endm


; imprimirtiempo macro
;     mov al, minutos
;     aam
;     mov decminutos, ah
;     mov uniminutos, al
;     mov al, segundos
;     aam
;     mov decsegundos, ah
;     mov unisegundos, al
    
;     mov dl, 35
;     e1:
;         mov ah, 02h
;         mov dh, 0
;         mov dl, dl
;         int 10h

;         mov ah, 09h
;         add decminutos, '0'
;         mov al, decminutos
;         mov bl, 1fh
;         mov cx, 1
;         int 10h

;         inc dl

;         mov ah, 02h
;         mov dh, 0
;         mov dl, dl
;         int 10h

;         mov ah, 09h
;         add uniminutos, '0'
;         mov al, uniminutos
;         mov bl, 1fh
;         mov cx, 1
;         int 10h

;         inc dl

;         mov ah, 02h
;         mov dh, 0
;         mov dl, dl
;         int 10h

;         mov ah, 09h
;         mov al, 58
;         mov bl, 1fh
;         mov cx, 1
;         int 10h

;         inc dl

;         mov ah, 02h
;         mov dh, 0
;         mov dl, dl
;         int 10h

;         mov ah, 09h
;         add decsegundos, '0'
;         mov al, decsegundos
;         mov bl, 1fh
;         mov cx, 1
;         int 10h

;         inc dl

;         mov ah, 02h
;         mov dh, 0
;         mov dl, dl
;         int 10h

;         mov ah, 09h
;         add unisegundos, '0'
;         mov al, unisegundos
;         mov bl, 1fh
;         mov cx, 1
;         int 10h
; endm



; dibujarmarco macro
;     local e1, e2, e3, e4, e5
;     ;convertir las coordenadas x y y para la lineazalizacion 
;     ;se multiplican por 320 que es el ancho de la matriz la posicion en y
;     mov cx, 320
;     mul cx
;     ;al resultado se le suma la posicion en x
;     add ax, bx
;     mov di, ax
;     e1:
;         ;comienza a dibujar el marco desde arriba
;         auxdiblinea lineamarco, 20;0
;         add ax, 20;
;         auxdiblinea lineamarco, 20;20
;         add ax, 20 ; ax = 20 + 20
;         auxdiblinea lineamarco, 20;40
;         add ax, 20
;         auxdiblinea lineamarco, 20;60
;         add ax, 20
;         auxdiblinea lineamarco, 20;80
;         add ax, 20
;         auxdiblinea lineamarco, 20;100
;         add ax, 20
;         auxdiblinea lineamarco, 20;120
;         add ax, 20
;         auxdiblinea lineamarco, 20;140
;         add ax, 20
;         auxdiblinea lineamarco, 20;160
;         add ax, 20
;         auxdiblinea lineamarco, 20;180
;         ;segunda linea marco
;         add ax, 140; ax=320
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 340
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 360
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 380
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 400
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 420
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 440
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 460
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 480
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         ;ax = 500
;         auxdiblinea lineamarco, 20
;         ;empieza a dibujar lado izquierdo
;         add ax, 140
;         ;ax = 640
;         auxdiblinea lineamarco1, 2
;         push ax
;         ;se guarda ax con 640
;         xor si, si
;     e2:
;         push si
;         ;se le suman 320 para llegar a la siguiente linea
;         add ax, 320
;         ;se dibuja la linea vertical de la izquierda
;         auxdiblinea lineamarco1, 2
;         pop si
;     e3:
;         inc si
;         cmp si, 170
;         jne e2
    
;         pop ax
;         ;ax = 640
;         add ax, 198
;         ;se le suman 198 porque toda la linea tiene una longitud de 200
;         ;se dibuja la linea vertical de la derecha
;         auxdiblinea lineamarco1, 2
;         xor si, si
;     e4:
;         push si
;         add ax, 320
;         auxdiblinea lineamarco1, 2
;         pop si
;     e5:
;         ;se dibujan las dos lineas del marco de abajo
;         inc si
;         cmp si, 170
;         jne e4
;         sub ax, 198
;         ;se le restan 198 para regresar al inicio de la posicion en x
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 140
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
;         add ax, 20
;         auxdiblinea lineamarco, 20
; endm