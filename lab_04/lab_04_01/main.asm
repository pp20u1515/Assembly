EXTRN output_X: NEAR ;описываем идентификатор output_X ближнего доступа (из другого модуля)

STK SEGMENT PARA STACK 'STACK' ;сегмент типа STACK размером параграф класса STACK
    DB 100 DUP (0) ;выделение память в 100 байт и заполниение 0
STK ENDS ;конец сегмента

DATAS SEGMENT PARA PUBLIC 'DATA' ;PUBLIC - объединение сегментов с одним именем
    X DB 'R' ;ячейка 1 байт, даст ей имя Х и запишет туда R
DATAS ENDS

CSEG SEGMENT PARA PUBLIC 'CODE' ;сегмент типа паблик класс CODE
    ASSUME CS:CSEG, DS:DATAS, SS:STK ; установка значений сегментов по умолчанию
main:
    MOV AX, DATAS ;в регистр AX записываем адрес сегмента DSEG
    MOV DS, AX ;в регистр данных DS записываем адрес регистра AX(так как нельзя сразу в DS записать)
        
    CALL output_X ;вызов процедуры output_X которую мы экспортировали

    MOV AX, 4c00h ;код завершения
    INT 21H ;вызов DOS
CSEG ENDS

PUBLIC X ;делаем ячейку X публичной

END main ;точка входа