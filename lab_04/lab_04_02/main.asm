SD1 SEGMENT PARA COMMON 'STACK' ;сегмент SD1 параграф, сегменты будут наложены друг на
                                ;друга по одним и тем же адресами памяти
    C1 LABEL BYTE ;объявление переменной С1 размером байт
    ORG 1H ;смещение на байт, директива ORG содержит параметр, указывающий адрес памяти,
           ;с которого будет располагаться следующий за этой директивой участок программы
    C2 LABEL BYTE ;объявление переменной С2 размером байт
SD1 ENDS

CSEG SEGMENT PARA 'CODE' ;сегмент размером параграф, класс CODE
    ASSUME CS:CSEG, DS:SD1 ;установка сегментов по умолчанию
MAIN:
    MOV AX, SD1 ;в сегмент АХ записываем адрес начала сегмента SD1
    MOV DS, AX ;в сегмент DS записываем AX(так как в DS нельза сразу записать SD1)
    MOV AH, 2 ;в АН кладем команду 2(вывод на экран символа)
    MOV DL, C1 ;в DL(регистер ввода/вывода) записываем адрес того, что будем выводить
    INT 21H ;вызов DOS
    MOV DL, C2 ;в DL(регистер ввода/вывода) записываем адрес того, что будем выводить
    INT 21H ;вызов DOS
    MOV AX, 4C00H ;код завершения
    INT 21H ;вызов DOS
CSEG ENDS
END MAIN ;точка выхода