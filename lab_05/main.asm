STK SEGMENT PARA STACK 'STACK' ;сегмент типа STACK, размером параграф класса STACK 
    DB 100 DUP (0) ;выделение память в 100 байт и заполнение 0
STK ENDS ;конец сегмента

DMATRIXSEG SEGMENT PARA PUBLIC 'DATA' ;сегмент типа PUBLIC, размером параграф класса 'DATA'
    M DB 0 ;количество строк
    N DB 0 ;количество столбцов
    MAX_M DB 9 ;выделение память в 9 байт
    MAX_N DB 9 ;выделение память в 9 байт
    MATRIX DB 9 * 9 DUP (0) ;выделение память матрицы в (9 * 9) байт и заполнение 0
DMATRIXSEG ENDS ;конец сегмента

DMSGSEG SEGMENT PARA PUBLIC 'DATA' ;сегмент типа PUBLIC, размером параграф класса 'DATA'
    MSG1 DB 'Enter number of rows: $' ;объявляем переменую MSG1 и передаем ей текст
    MSG2 DB 'Enter number of columns: $' ;объявляем переменую MSG2 и передаем ей текст
    MATRIXMSG DB 'Enter elements: $' ;объявляем переменую MATRIXMSG и передаем ей текст
DMSGSEG ENDS ;конец сегмента

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, SS:STK, DS:DMSGSEG, ES:DMATRIXSEG

PRINT_MESSAGE PROC ;процедура вывода сообщения
    MOV AX, DX ;указываем, что выводим
    MOV AH, 9 ;указываем, что будет вызвана функция вывода строки
    INT 21H ;DOS функция
    RET ;выход
PRINT_MESSAGE ENDP ;конец процедуры

INPUT_NUM PROC ;процедуру ввода числа
    MOV AH, 01H ;ввод чисел
    INT 21H ;вызов DOS

    MOV DH, AL ;в AL cчитано само число как символ
    SUB DH, '0'
    RET
INPUT_NUM ENDP

INPUT_NEW_LINE PROC
    MOV AX, 2 ;вывод на экран символа
    MOV DL, 10 ;символ новой строки
    INT 21H ;функция DOS
    MOV DL, 13 ;переводим указатель на начало
    INT 21H ;функция DOS
    RET ;выход
INPUT_NEW_LINE ENDP

MAIN:
    MOV AX, DMSGSEG ;в сегмент AX кладем адрес сегмента DMSGSEG
    MOV DS, AX ;в сегмент DS записываем адрес сегмента АХ(так как нельза сразу записать в DS) 
    MOV AX, DMATRIXSEG ;в сегмент АХ записываем адрес сегмента DMATRIXSEG  
    MOV ES, AX ;в сегмент ES записываем адрес сегмента AX
    MOV DX, OFFSET MSG1 ;в сегмент DX записываем то, что будем выводить 
    
    CALL PRINT_MESSAGE ;вызываем процедуру вывода строки
    CALL INPUT_NUM ;вызываем процедуру ввода числа 

    MOV N, DH ;переменой N передаем введимое значение

    CALL INPUT_NEW_LINE

    MOV DX, OFFSET MSG2

    CALL PRINT_MESSAGE
    CALL INPUT_NUM

    MOV M, DH

    CALL INPUT_NEW_LINE

    MOV AX, 4C00H ;код завершения
    INT 21H ;вызов DOS
CSEG ENDS
END MAIN