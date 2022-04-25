include Macros.asm

.model small
.stack
.data
    msg1        db 'Iniciar Sesion', 10, 13, '$'
    msg2        db 'usuario: ', '$'
    msg3        db 'contrase', 164, 'a: ', '$'
    msg4        db 'LA CONTRASE', 165, 'A INGRESADA NO ES CORRECTA', 10, 13, '$'
    msg5        db  'Ingreso al sistema', 10, 13, '$'
    msg6        db 'El usuario no existe', 10, 13, '$'
    usering     db  100 dup('$');
    passing     db  100 dup('$');
    usersaved   db  100 dup('$')
    passsaved   db  100 dup('$')
    tamus       dw  0
    tampass     dw  0
    usuarios    db  'Archivos', 92, 'users.gal', 0
    auxcontenidoar db   1 dup('$')
    controlusers    dw  0
    controlpass     dw  0
    tamarch         dw  0
    handle      dw  ?

.code

main proc
    mov ax, @data
    mov ds, ax
inicio:
    limpiarp
    imprimir msg1
    imprimir msg2
    xor si, si
    leerusuario
    imprimir msg3
    xor si, si
    leerpass
    ;login
    mov ah, 3dh
    mov al, 0h
    mov dx, offset usuarios
    int 21h
    mov handle, ax
    mov bx, handle
    mov ah, 42h
    mov al, 00h
    mov cx, 0
    mov dx, 0
    int 21h
    e1:
        mov si, 00h
        mov controlpass, 0
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h

        cmp auxcontenidoar[si], '$'
        je errornoexiste
        cmp auxcontenidoar[si], ','
        je e2
        mov al, auxcontenidoar[si]
        mov si, controlusers
        mov usersaved[si], al
        inc controlusers
        inc si
        mov usersaved[si], '$'
        jmp e1
    e2:
        calctamuser
        calctamuserle
        mov si, tamus
        cmp tamarch, si
        je e3
        jne e4
    e3:
        xor si, si
    e6:
        mov al, usersaved[si]
        cmp al, '$'
        je e7
        cmp usering[si], al
        jne e4
        inc si
        jmp e6
    e4:
        mov si, 00h
        mov controlusers, 0
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h
        cmp auxcontenidoar[si], 0dh
        je e5
        jmp e4
    e5:
        mov si, 00h
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h
        cmp auxcontenidoar[si], '$'
        je e1
        cmp auxcontenidoar[si], 0ah
        je e5
        mov controlusers, 0
        mov al, auxcontenidoar[si]
        mov si, controlusers
        mov usersaved[si], al
        inc controlusers
        inc si
        mov usersaved[si], '$'
        jmp e1
    e7:
        mov si, 00h
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h

        cmp auxcontenidoar[si], '$'
        je errorpass
        cmp auxcontenidoar[si], 0dh
        je e8
        cmp auxcontenidoar[si], 0ah
        je e8
        mov al, auxcontenidoar[si]
        mov si, controlpass
        mov passsaved[si], al
        inc controlpass
        inc si
        mov passsaved[si], '$'
        jmp e7
    e8:
        calctampasss
        calctampass
        mov si, tampass
        cmp tamarch, si
        je e9
        jne e10
    e9:
        xor si, si
    e12:
        mov al, passsaved[si]
        cmp al, '$'
        je ingresarsist
        cmp passing[si], al
        jne e10
        inc si
        jmp e12
    e10:
        mov si, 00h
        mov controlpass, 0
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h
        cmp auxcontenidoar[si], ','
        je e11
        cmp auxcontenidoar[si], '$'
        je errorpass
        jmp e10
    e11:
        mov si, 00h
        mov ah, 3fh
        mov bx, handle
        lea dx, auxcontenidoar
        mov cx, 1
        int 21h
        cmp auxcontenidoar[si], '$'
        je e7
        cmp auxcontenidoar[si], ','
        je e11
        mov controlpass, 0
        mov al, auxcontenidoar[si]
        mov si, controlpass
        mov passsaved[si], al
        inc controlpass
        inc si
        mov passsaved[si], '$'
        jmp e7
ingresarsist:
    imprimir msg5
    jmp salir
errornoexiste:
    imprimir msg6
    jmp salir
errorpass:
    mov ah, 3eh
    int 21h
    imprimir msg4
salir:
    mov ax, 4c00h
    int 21h
main endp
end main