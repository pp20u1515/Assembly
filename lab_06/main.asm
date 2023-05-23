.MODEL TINY
.186

CSEG SEGMENT
	assume CS:CSEG, DS:CSEG 
    ORG 100h ; смещениe для таблицы обработчиков прерываний

start:   
    jmp init    
   
    speed db 11111b ; скорость автоповтора ввода символов
    oldHandler dd ? ; адресс старого прерывания  
    flag db 154 ; в случае повторного прерывания
    currentTime db 0
    
; обработчик прерывания    
myHandler:
    pusha ; сохраняет в стеке содержимое регистров
    pushf ; сохраняем значения флагов

    call CS:oldHandler

    mov AH, 02h       
    int 1ah ; получение текущего времени (BIOS)
            ; в результате кол-во секунд помещается в DH
    
    cmp DH, current
    mov current, DH

    je endMyHandler
    
    next:
        mov AL, 0F3h ; настройка команды автоповтора
        out 60h, AL ; порт 60h при чтении содержит скан-код последней нажатой клавиши
        mov AL, speed ; устанавливаем новую скорость автоповтора
        out 60h, AL

        dec speed ; увеличиваем скорость
        cmp speed, 0 ; возвращаем начальное значение скорости, если оно равно 00000b

        je setNew
        jmp endMyHandler

    setNew:
        mov speed, 11111b

    endMyHandler:
        popa
        iret

init:
    mov AX, 3508h ; AH = 35h - команда для получение адреса старого обработчика
                  ; AL = 08h - номер прерывания, прерывание от таймера
                  ; ES:BX - адрес старого прерывания
    int 21h

    cmp ES:flag, 154
    je uninstall

    jmp install
    

install:
    mov word ptr oldHandler, BX ; сохраняем адрес предшествующего обработчика
    mov word ptr oldHandler + 2, ES

    mov AX, 2508h ; AH = 25h - установка нового обратотчика
                  ; DS:DX вектор прерывания: адрес программы обработки прерывания
    
    mov DX, offset myHandler
    int 21h 

    mov DX, offset init ; адрес, начиная с которого часть программы
                        ; может быть удалена
    int 27h             ; делаем нашу программу резидентной

uninstall:
    pusha

    mov DX, word ptr ES:oldHandler
    mov DS, word ptr ES:oldHandler + 2

    mov AX, 2508h ; возвращаем старый обработчик
    int 21h

    mov AL, 0F3h
    out 60h, AL

    mov AL, 0
    out 60h, AL

    popa
    
    mov AH, 49h ; освобождаем память, занимаемую нашей
                ; резидентной программой. Сегмент памяти стоит в ES
    int 21h

    mov AX, 4c00h
    int 21h

CSEG ENDS    
END start
