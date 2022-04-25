; **************************** [SEGMENTO][LIBS] ****************************
include Macros.asm

.model small
; **************************** [SEGMENTO][STACK] ****************************
.stack
; **************************** [SEGMENTO][DATA] ****************************
.data
 
; ************************* DECLARACION DE VARIABLES ************************* 
; ************** [IDENTIFICADOR] **************
_salto          db 0ah,0dh,               "$"
_igual          db 0ah,0dh,               "=======================================$"
_opcion         db 0ah,0dh,               "> Ingrese Opcion: $"

_cadena1        db 0ah,0dh,               "Universidad de San Carlos de Guatemala$"
_cadena2        db 0ah,0dh,               "Facultad de Ingenieria$"
_cadena3        db 0ah,0dh,               "Escuela de Ciencias y Sistemas$"
_cadena4        db 0ah,0dh,               "Arquitectura de Compiladores y ensambladores 1$"
_cadena5        db 0ah,0dh,               "Seccion A$"
_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
_cadena7        db 0ah,0dh,               "201800937$"


_cadena8        db 0ah,0dh,               "Menu$"
_cadena9        db 0ah,0dh,               "F1. Login$"
_cadena10       db 0ah,0dh,               "F5. Register$"
_cadena11       db 0ah,0dh,               "F9. Exit$"


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
    GetPrint _opcion

    ret
fnMenu endp


.code

main proc
    mov ax, @data
    mov ds, ax

    Linicio:
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
    GetPrint _cadena9
    GetPrint _salto
    jmp Lmenu

    Lregistro:
    GetPrint _cadena10
    GetPrint _salto
    jmp Lmenu

    Lsalir:
    mov ax,4c00h
    int 21h


main endp
end main