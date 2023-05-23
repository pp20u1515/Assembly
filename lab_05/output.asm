PUBLIC print_bin_sign
PUBLIC print_dec_unsign

EXTRN sign:BYTE
EXTRN sbhvalue:BYTE
EXTRN sblvalue:BYTE
EXTRN unsigneddec: BYTE
EXTRN signedhex: BYTE

EXTRN to_dec:near
EXTRN to_hex:near
EXTRN new_line: near

SEGCODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:SEGCODE

; вывод знака на экран
print_sign proc
    mov ah, 2
    mov dl, sign
    int 21h
    ret
print_sign endp

; вывод беззнакого десятичного числа
print_dec_unsign proc near
    call to_dec ;переводим двоичное число в десятичное 
    call new_line
    call print_sign

    ; вывод числа, которое находится по адрессу offset unsigneddec
    mov ah, 9
    mov dx, offset unsigneddec
    int 21h

    call new_line
    ret
print_dec_unsign endp

print_hex proc near 
    call print_sign
    call to_hex

    ; вывод числа, которое находится по адрессу offset signedhex
    mov ah, 9
    mov dx, offset signedhex
    int 21h

    call new_line
    ret
print_hex endp

shift proc
    shr bl, cl ; сдвиг вправо, чтобы получить значение самого старшего бита числа
    add bl, "0" ; преобрауем в символьное значение
    mov dl, bl ; копируем символьное значение в dl, который используется для вывода символа на экран
    int 21h
    ret
shift endp

print_bin_sign proc near 
    call print_sign

    mov cx, 8
    mov si, 0
    mov ah, 2
    print_sh_b:
        mov bl, sbhvalue
        and bl, 10000000B ; оставляем в bl только самый старший бит числа 
        mov cl, 7
        call shift

        mov bl, sbhvalue
        and bl, 01000000B
        mov cl, 6
        call shift

        mov bl, sbhvalue
        and bl, 00100000B
        mov cl, 5
        call shift

        mov bl, sbhvalue
        and bl, 00010000B
        MOV CL, 4
        call shift

        mov bl, sbhvalue
        and bl, 00001000B
        mov cl, 3
        call shift

        mov bl, sbhvalue
        and bl, 00000100B
        mov cl, 2
        call shift

        mov bl, sbhvalue
        and bl, 00000010B
        mov cl, 1
        call shift

        mov bl, sbhvalue
        and bl, 00000001B
        add bl, "0"
        mov dl, bl
        int 21h

    print_sh_l:
        mov bl, sblvalue
        and bl, 10000000B
        mov cl, 7
        call shift

        mov bl, sblvalue
        and bl, 01000000B
        mov cl, 6
        call shift

        mov bl, sblvalue
        and bl, 00100000B
        mov cl, 5
        call shift

        mov bl, sblvalue
        and bl, 00010000B
        mov cl, 4
        call shift

        mov bl, sblvalue
        and bl, 00001000B
        mov cl, 3
        call shift

        mov bl, sblvalue
        and bl, 00000100B
        mov cl, 2
        call shift

        mov bl, sblvalue
        and bl, 00000010B
        mov cl, 1
        call shift

        mov bl, sblvalue
        and bl, 00000001B
        add bl, "0"
        mov dl, bl
        int 21h

    call new_line
    ret
print_bin_sign endp

SEGCODE ENDS
END