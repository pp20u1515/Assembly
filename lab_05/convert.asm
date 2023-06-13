PUBLIC to_dec
PUBLIC to_hex

EXTRN sbhvalue:byte
EXTRN sblvalue:byte
EXTRN hextable:byte
EXTRN sign:byte

EXTRN unsigneddec:word
EXTRN signedhex:byte

SSEG SEGMENT PARA STACK 'STACK'
    db 300h dup (0)
SSEG ENDS

SEGCODE SEGMENT PUBLIC 'CODE'
    ASSUME CS:SEGCODE

to_dec proc near
    cmp sign, "-"
    je reverse
    call convert_to_dec
    ret

    reverse:
        not sbhvalue
        not sblvalue
        add sblvalue, 1
        
        ;not sblvalue
        ;not sbhvalue
        ;add sblvalue, 1
        call convert_to_dec
        sub sblvalue, 1
        not sblvalue
        not sbhvalue
        
        ret

to_dec endp

convert_to_dec proc near
    mov ax, 0
    mov al, sblvalue
    mov ah, sbhvalue

    mov bx, 10
    mov cx, 0

    convert:
        mov dx, 0
        div bx
        add dl, 30h

        push dx
        inc cx

        test ax, ax
        jnz convert

    mov ah, 02h

    print:
        pop dx
        int 21h
        loop print

    ret
convert_to_dec endp

to_hex proc near
    mov bx, offset hextable
    mov al, sbhvalue
    mov cl, 4
    shr al, cl
    xlat 
    mov signedhex[0], al
    mov al, sbhvalue
    and al, 00001111B
    xlat
    mov signedhex[1], al
    mov al, sblvalue
    shr al, cl
    xlat
    mov signedhex[2], al
    mov al, sblvalue
    and al, 00001111B
    xlat
    mov signedhex[3], al
    ret
to_hex endp

SEGCODE ENDS
END