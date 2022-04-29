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
_dolar          db                        24h, "$"
_igual          db 0ah,0dh,               "=======================================$"
_opcion         db 0ah,0dh,               "> Ingrese Opcion: $"
_palo           db '|$'
; ************** [ERRORES] **************
_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
_error7         db 0ah,0dh,               "> Error al crear el Archivo",                  "$"
; ************************* [ERRORES] ************************* 
_msg1           db 0ah,0dh,               ">>          Permission denied          <<$"
_msg2           db 0ah,0dh,               ">> There where 3 failed login attempts <<$"
_msg3           db 0ah,0dh,               ">>   Pease contact the administrator   <<$"
_msg4           db 0ah,0dh,               ">>   Press Enter to go back to menu    <<$"
_msg5           db 0ah,0dh,               ">>          Ingreso al Sistema         <<$"
_msg6           db 0ah,0dh,               ">>         El Usuario No Existe        <<$"

_msg7           db 0ah,0dh,               ">>                Action Rejected               <<$"
_msg8           db 0ah,0dh,               ">>                                              <<$"
_msg9           db 0ah,0dh,               ">> Missed requirements:                         <<$"
_msg10          db 0ah,0dh,               ">> Username begins with a letter                <<$"
_msg11          db 0ah,0dh,               ">> Username length between 8 and 15 characters  <<$"
_msg12          db 0ah,0dh,               ">> Password must contain at least one number    <<$"
_msg13          db 0ah,0dh,               ">> Password length at least 16 characters       <<$"
_msg14          db 0ah,0dh,               ">>         Press Enter to go back to menu       <<$"

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
_cadena13       db 0ah,0dh,               "Username: $"
_cadena14       db                        "Password: $"
_cadena15       db 0ah,0dh,               "Register$"
; ************** [DECLARACIONES] **************
_user           db 100 dup('$');
_password       db 100 dup('$')
_SavedUser      db 100 dup('$')
_SavePass       db 100 dup('$')
_tam0           dw 0
_tamPass        dw 0 
_usersFile      db 'users.gal', '$'
_auxContainer   db 1   dup('$')
_controlUser    dw 0
_controlPass    dw 0
_tamFile        dw 0
_handle         dw ?
_isBool         dw 0

_bufferInput    db 50 dup('$')
_handleInput    dw ? 
_bufferInfo     db 2000 dup('$')
contadorBuffer  dw 0 ; Contador para todos los WRITE FILE, para escribir sin que se vean los $
_reporteHandle  dw ?

; *********************** [VISTA DE JUEGO] ********************************
; l1              db  'EJEMPLO 5', 10, 13, '$'
; l2              db  'SE PULSO F1', 10, 13, '$'
; l3              db  'SE PULSO F2', 10, 13, '$'
; l4              db  'SE PULSO HOME', 10, 13, '$'
; user            db  'oscar','$'
; ;coordenadas nave
; xnave           dw  0
; ynave           dw  0
; ;marco
; lineamarco      db  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24 
; lineamarco1     db  24, 24
; ;nave
; naveFila1       db  00, 00, 00, 00, 00, 39, 00, 00, 00, 00, 00
; naveFila2       db  00, 00, 00, 00, 00, 15, 00, 00, 00, 00, 00
; naveFila3       db  00, 00, 39, 00, 15, 11, 15, 00, 39, 00, 00
; naveFila4       db  00, 15, 15, 15, 15, 11, 15, 15, 15, 15, 00
; naveFila5       db  15, 15, 15, 15, 15, 11, 15, 15, 15, 15, 15
; naveFila6       db  15, 15, 15, 15, 15, 11, 15, 15, 15, 15, 15
; ;disparo
; disparoFila1    db  12
; disparoFila2    db  29
; disparoFila3    db  29
; disparoFila4    db  45
; ;coordenadas disparo
; xdis            dw  0
; ydis            dw  0
; contador        dw  0
; ;tiempo
; minutos         db  0
; decminutos      db  0
; uniminutos      db  0
; segundos        db  0
; decsegundos     db  0
; unisegundos     db  0
; micsegundos     db  0
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

fnRegister proc far
    GetPrint _salto 
    GetPrint _cadena15
    GetPrint _igual
    ret
fnRegister endp

fnDeniedRegister proc far
    GetPrint _salto
    GetPrint _msg7
    GetPrint _msg8
    GetPrint _msg9
    GetPrint _msg10
    GetPrint _msg11
    GetPrint _msg12
    GetPrint _msg13
    GetPrint _salto
    GetPrint _msg14
    GetPrint _salto
    ret
fnDeniedRegister endp


; limpiarpantallag proc
; ;vuelve a entrar en el modo video
;     mov ah, 0
;     mov al, 13h
;     int 10h
;     ret
; limpiarpantallag endp

; GetChar proc
; ;lee un caracter
;     xor ah, ah
;     int 16h
;     ret
; GetChar endp


; ; VSync proc
; ; ;metodo de sincronizacion vertical de la pantalla
; ;     mov dx, 03dah
; ;     WaitNotVSync:
; ;         in al, dx
; ;         and al, 08h
; ;         jnz WaitNotVSync
; ;     WaitVSync:
; ;         in al, dx
; ;         and al, 08h
; ;         jz WaitVSync
; ;     ret
; ; VSync endp

; Delay proc
; ;metodo para agregar un delay en microsegundos para refrescar la pantalla
; ;los microsegundos se toman como cx:dx
;     mov cx, 0000h
;     mov dx, 0fffffh
;     mov ah, 86h
;     int 15h
;     ret
; Delay endp

.code

main proc
    mov ax, @data
    mov ds, ax
    GetOpenFile _usersFile,_handleInput                          ; Abrir file
    GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo       ; Guardar Contenido
    GetCloseFile _handleInput

    Linicio:
    limpiarp
    call identificador

    GetInput
    cmp al,0Dh ; Codigo ASCCI [Enter -> Hexadecimal]
    je Lmenu
    jmp Linicio


    Lmenu:
        mov _tamFile, 0
        xor si, si
        xor bx, bx
        xor al, al
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
      
       login
       jmp Lsalir

       
    ingresarsist:
        GetPrint _msg5
        jmp Lmenu
    errornoexiste:
        mov _tamFile, 0
        imprimir _msg6
        jmp Lmenu
    errorpass:
        mov _tamFile, 0
        call fnDenied
        jmp Lmenu
    Lregistro:
        call fnRegister
        cleanVariable 100, _user
        GetPrint _cadena13
        GetInputMax _user

        GetValidateUser _user, 9, 17

        cmp _isBool, 0
        je Lerror8

        GetPrint _cadena14
        ; ReadPassword
        GetInputMax _password

        xor di, di
        ConcaUsers _user
        dec si
        mov bl, 2ch
        mov _SavedUser[si], bl
        
        ConcaUsers _password

        GetCreateFile _usersFile, _reporteHandle

        GetWriteFile _reporteHandle, _SavedUser
        GetWriteFile _reporteHandle, _bufferInfo
        GetWriteFile _reporteHandle, _dolar

        jmp Lmenu


    Lerror1:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerror2:
        GetPrint _salto
        GetPrint _error2
        jmp Lmenu
    Lerror3:
        GetPrint _salto
        GetPrint _error3
        jmp Lmenu
    Lerror4:
        GetPrint _salto
        GetPrint _error4
        jmp Lmenu
    Lerror5:
        GetPrint _salto
        GetPrint _error5
        jmp Lmenu
    Lerror7:
        GetPrint _salto
        GetPrint _error7
        jmp Lsalir
    Lerror8:
        call fnDeniedRegister
        GetInput
        cmp al,0Dh ; Codigo ASCCI [Enter -> Hexadecimal]
        je Lmenu
        jmp Lerror8

    Lsalir:
        limpiarp

        mov ax,4c00h
        int 21h


main endp
end main