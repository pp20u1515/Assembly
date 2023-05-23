PUBLIC read_bin_sign

PUBLIC sign
PUBLIC unsigneddec
PUBLIC sbhvalue
PUBLIC sblvalue
PUBLIC signedhex
PUBLIC hextable

SEGDATA SEGMENT PARA PUBLIC 'DATA'
    sign    DB '+'
    sbhvalue DB 00000000B ; старшая часть числа
    sblvalue DB 00000000B ; младшая часть числа

    unsigneddec DW 0 
    signedhex DB 4 dup (0), "$"

    hextable DB "0123456789ABCDEF$"

    msg_in db "Enter binary digit with sign(max 16 digits): $"
SEGDATA ENDS

SEGCODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:SEGCODE, DS:SEGDATA

read_bin_sign proc near
    mov ah, 9
    mov dx, offset msg_in
    int 21h

    mov ah, 1
    int 21h
    mov sign, al

    ; читаем оствашие 8 цифр старшей части числа, сдвигая текущее значение на один бит влево 
    ; и добавляя новую цифру
    mov cx, 8
    read_symb: 
        mov ah, 1 ; ввод символа с эхом
        int 21h 
        cmp al, 13 ; проверяем, является ли считанный символ символом перевода строки, который обычно вводится после ввода числа 
        je finishswitch ; если считанный символ равен символу перевода строки, то переходим на метку finishswitch, если нет то
        sub al, "0" ; переводим значение числа с ascii кодировки в двоичное
        shl sbhvalue, 1 ; сдвигаем содержимое регистра на один байт влево
        add sbhvalue, al ; к полученному числу добавляется считаное значение al, которое было преобразованое в двоичное число
                         ; таким образом, получается двоичное число, представленое в виде целого числа в регистре sbhvalue
                         ; (потому, что изначало в массиве 0)
        loop read_symb
    
    ; переходим к считыванию младшей части числа
    read_symbl:
        mov ah, 1
        int 21h
        cmp al, 13
        je finish
        sub al, "0"
        shl sblvalue, 1
        add sblvalue, al
        jmp read_symbl

    finishswitch:
        mov bl, sbhvalue
        mov sblvalue, bl
        mov sbhvalue, 0
    
    finish:
        ret
read_bin_sign ENDP

SEGCODE ENDS
END