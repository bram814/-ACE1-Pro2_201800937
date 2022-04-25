
; ************** [IMPRIMIR] **************
GetPrint macro buffer
    MOV AX,@data
    MOV DS,AX
    MOV AH,09H
    MOV DX,OFFSET buffer
    INT 21H
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

; ************** [READ USER] **************


GetInputMax macro _resultS
    mov ah, 3fh                     ; int21 para leer fichero o dispositivo
    mov bx, 00                      ; handel para leer el teclado
    mov cx, 20                      ; bytes a leer (aca las definimos con 10)
    mov dx, offset[_resultS]
    int 21h
endm



ReadUser macro
    local e1, e2
    mov _tam0, 0
    e1:
        xor ax, ax
        mov ah, 01h
        int 21h
        cmp al, 0dh
        je e2
        cmp al, 1bh
        je Lmenu
        mov _user[si], al
        inc si 
        mov _user[si], '$'
        jmp e1
    e2:
endm


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

calctamuserle macro
    local e1, e2
    xor si, si
    mov _tam0, 0
    e1: 
        cmp _user[si], '$'
        je e2
        inc _tam0
        inc si
        jmp e1
    e2:
endm

calctamuser macro
    local e1, e2
    xor si, si 
    mov _tamFile, 0
    e1:
        cmp _SavedUser[si], '$'
        je e2
        inc _tamFile
        inc si
        jmp e1
    e2:
endm


calctampass macro
    local e1, e2
    xor si, si
    mov _tamPass, 0
    e1: 
        cmp _password[si], '$'
        je e2
        inc _tamPass
        inc si
        jmp e1
    e2:
endm


login macro
    local e1, e2, e3, e4, e5, e6
    mov ah, 3dh
    mov al, 0h
    mov dx, offset _usersFile
    int 21h
    mov _handle, ax
    mov bx, _handle
    mov ah, 42h
    mov al, 00h
    mov cx, 0
    mov dx, 0
    int 21h
    e1:
        mov si, 00h
        mov _controlPass, 0
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h

        cmp _auxContainer[si], '$'
        je errornoexiste
        cmp _auxContainer[si], ','
        je e2
        mov al, _auxContainer[si]
        mov si, _controlUser
        mov _SavedUser[si], al
        inc _controlUser
        inc si
        mov _SavedUser[si], '$'
        jmp e1
    e2:
        calctamuser
        calctamuserle
        mov si, _tam0
        cmp _tamFile, si
        je e3
        jne e4
    e3:
        xor si, si
    e6:
        mov al, _SavedUser[si]
        cmp al, '$'
        je e7
        cmp _user[si], al
        jne e4
        inc si
        jmp e6
    e4:
        mov si, 00h
        mov _controlUser, 0
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h
        cmp _auxContainer[si], 0dh
        je e5
        jmp e4
    e5:
        mov si, 00h
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h
        cmp _auxContainer[si], '$'
        je e1
        cmp _auxContainer[si], 0ah
        je e5
        mov _controlUser, 0
        mov al, _auxContainer[si]
        mov si, _controlUser
        mov _SavedUser[si], al
        inc _controlUser
        inc si
        mov _SavedUser[si], '$'
        jmp e1
    e7:
        mov si, 00h
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h

        cmp _auxContainer[si], '$'
        je errorpass
        cmp _auxContainer[si], 0dh
        je e8
        cmp _auxContainer[si], 0ah
        je e8
        mov al, _auxContainer[si]
        mov si, _controlPass
        mov _SavePass[si], al
        inc _controlPass
        inc si
        mov _SavePass[si], '$'
        jmp e7
    e8:
        calctampasss
        calctampass
        mov si, _tamPass
        cmp _tamFile, si
        je e9
        jne e10
    e9:
        xor si, si
    e12:
        mov al, _SavePass[si]
        cmp al, '$'
        je ingresarsist
        cmp _password[si], al
        jne e10
        inc si
        jmp e12
    e10:
        mov si, 00h
        mov _controlPass, 0
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h
        cmp _auxContainer[si], ','
        je e11
        cmp _auxContainer[si], '$'
        je errorpass
        jmp e10
    e11:
        mov si, 00h
        mov ah, 3fh
        mov bx, _handle
        lea dx, _auxContainer
        mov cx, 1
        int 21h
        cmp _auxContainer[si], '$'
        je e7
        cmp _auxContainer[si], ','
        je e11
        mov _controlPass, 0
        mov al, _auxContainer[si]
        mov si, _controlPass
        mov _SavePass[si], al
        inc _controlPass
        inc si
        mov _SavePass[si], '$'
        jmp e7
endm


calctampasss macro
    local e1, e2
    xor si, si
    mov _tamFile, 0
    e1:
        cmp _SavePass[si], '$'
        je e2
        inc _tamFile
        inc si
        jmp e1
    e2:
endm