; Требуется написать программу
; в которой ввести 2 цифры, одна от 3 до 9, вторая от 0 до 3, и
; сохранить их в переменных. Вывести с новой строки разность этих цифр

STACKSEG SEGMENT STACK 'STACK'
    db 100
STACKSEG ENDS

NUM SEGMENT PARA 'DATA'
    X DW ?
    Y DW ?
    result DW ?
NUM ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS:NUM, SS: STACKSEG

main:
    mov ax, NUM
    mov ds, ax

    ;input first num
    mov ah, 1
    int 21h
    sub al, '0'
    mov [X], ax
    
    ;going to next line
    mov dl, 10
    int 21h
	
    ;input second num
    mov ah, 1
    int 21h
    sub al, '0'
    mov [Y], ax

    ;going to next line
    mov dl, 10
	int 21h

    ; find diff
    mov ax, [X]
    sub ax, [Y]
    mov [result], ax

    ; print diff
    mov ax, [result]    
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, 0Ah
    int 21h

    mov ah, 4CH
    int 21h
CSEG ENDS
END main
