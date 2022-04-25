; **************************** [SEGMENTO][LIBS] ****************************
include Macros.asm

.model small
; **************************** [SEGMENTO][STACK] ****************************
.stack
; **************************** [SEGMENTO][DATA] ****************************
.data
 
; ************************* DECLARACION DE VARIABLES ************************* 
; ************** [EXTRAS] **************
_salto          db 0ah,0dh,               "$"
_igual          db 0ah,0dh,               "=======================================$"
_opcion         db 0ah,0dh,               "> Ingrese Opcion: $"
; ************************* [ERRORES] ************************* 
_msg1           db 0ah,0dh,               ">>          Permission denied          <<$"
_msg2           db 0ah,0dh,               ">> There where 3 failed login attempts <<$"
_msg3           db 0ah,0dh,               ">>   Pease contact the administrator   <<$"
_msg4           db 0ah,0dh,               ">>   Press Enter to go back to menu    <<$"
_msg5           db 0ah,0dh,               ">>          Ingreso al Sistema         <<$"
_msg6           db 0ah,0dh,               ">>         El Usuario No Existe        <<$"
; ************** [IDENTIFICADOR] **************
_cadena1        db 0ah,0dh,               "Universidad de San Carlos de Guatemala$"
_cadena2        db 0ah,0dh,               "Facultad de Ingenieria$"
_cadena3        db 0ah,0dh,               "Escuela de Ciencias y Sistemas$"
_cadena4        db 0ah,0dh,               "Arquitectura de Compiladores y ensambladores 1$"
_cadena5        db 0ah,0dh,               "Seccion A$"
_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
_cadena7        db 0ah,0dh,               "201800937$"
; ************** [MENU] **************
_cadena8        db 0ah,0dh,               "Menu$"
_cadena9        db 0ah,0dh,               "F1. Login$"
_cadena10       db 0ah,0dh,               "F5. Register$"
_cadena11       db 0ah,0dh,               "F9. Exit$"
; ************** [LOGIN] **************
_cadena12       db 0ah,0dh,               "Login$"
_cadena13       db                        "Username: $"
_cadena14       db                        "Password: $"
; ************** [DECLARACIONES] **************
_user           db 100 dup('$');
_usersFile      db  'Archivos', 92, 'users.gal', 0
_password       db 100 dup('$')
_SavedUser      db 100 dup('$')
_SavePass       db 100 dup('$')
_auxContainer   db 1   dup('$')
_tam0           dw 0
_tamPass        dw 0 
_tamFile        dw 0
_controlUser    dw 0
_controlPass    dw 0
_handle         dw  ?

; **************************** [IDENTIFICADOR] **************************** 
identificador proc far
    GetPrint _salto
    GetPrint _cadena1
    GetPrint _cadena2
    GetPrint _cadena3
    GetPrint _cadena4
    GetPrint _cadena5
    GetPrint _cadena6
    GetPrint _cadena7
    ret
identificador endp

fnMenu proc far
    GetPrint _salto
    GetPrint _cadena8
    GetPrint _igual
    GetPrint _cadena9
    GetPrint _cadena10
    GetPrint _cadena11

    ret
fnMenu endp

fnLogin proc far
    GetPrint _salto
    GetPrint _cadena12
    GetPrint _igual
    GetPrint _salto
    ret
fnLogin endp

fnDenied proc far
    GetPrint _salto
    GetPrint _msg1
    GetPrint _msg2
    GetPrint _msg3
    GetPrint _salto
    GetPrint _msg4
    GetPrint _salto
    ret
fnDenied endp

.code

main proc
    mov ax, @data
    mov ds, ax

    Linicio:
    limpiarp
    call identificador

    GetInput
    cmp al,0Dh ; Codigo ASCCI [Enter -> Hexadecimal]
    je Lmenu
    jmp Linicio


    Lmenu:
        call fnMenu

        GetTeclado
        cmp ax,3b00h ; Codigo ASCCI [F1 -> Hexadecimal]
        je Llogin
        cmp ax,3f00h ; Codigo ASCCI [F5 -> Hexadecimal]
        je Lregistro
        cmp ax,4300h ; Codigo ASCCI [F9 -> Hexadecimal]
        je Lsalir

        jmp Lmenu

    Llogin:
    
        call fnLogin

        xor si, si
        GetPrint _cadena13
        ReadUser

        xor si, si
        GetPrint _cadena14
        ReadPassword


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
        ingresarsist:
            GetPrint _msg5
            jmp Lmenu
        errornoexiste:
            imprimir _msg6
            jmp Lmenu
        errorpass:
            mov ah, 3eh
            int 21h
            call fnDenied


    Lregistro:
        GetPrint _cadena10
        GetPrint _salto
        jmp Lmenu

    Lsalir:
        limpiarp
        mov ax,4c00h
        int 21h


main endp
end main