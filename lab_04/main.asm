;Описание сегмента стека.
SSEG SEGMENT PARA STACK 'STACK'
	db 100 dup (0)
SSEG ENDS

;Описание сегмента данных
DSEG SEGMENT PARA 'DATA'
	row_msg db 'Enter num of rows: $'
	col_msg db 'Enter num of columns: $'
	matrix_msg db 'Enter elements of matrix: $'
	result_msg db 'Result: $'
	rows db 0
	cols db 0
	decr dw 0 ;переменная для корректировки индексирования матрицы
	max_num_of_odd dw 0 ;максимальное количество нечетных элементов в строке
	row_to_del dw 0 ;номер строки с максимальным количеством нечетных элементов
	matrix db 9 * 9 dup (0)
DSEG ENDS

;Описание сегмента кода
CSEG SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
	
;Ввод символа с эхом
input_symb:
	mov ah, 1h
	int 21h
	ret
	
;Печать символа на экран
output_symb:
	mov ah, 2h
	int 21h
	ret
	
;Перевод строки
new_line:
	mov ah, 2h
	mov dl, 13 ; переводим указатель на начало
	int 21h
	mov dl, 10 ; символ новой строки
	int 21h
	ret
	
;Печать пробела
print_space:
	mov ah, 2h
	mov dl, ' '
	int 21h
	ret

print_matrix:
	;Вывод результата
	mov ah, 9h
	mov dx, OFFSET result_msg
	int 21h
	call new_line
	
	mov decr, 0
	mov bx, 0
	mov cl, rows
	output_matrix: ;Печать матрицы
		mov cl, cols
		output_row:
			mov dl, matrix[bx]
			add dl, '0'
			call output_symb
			inc bx
			call print_space
			loop output_row
		call new_line
		mov cl, rows
		mov si, decr
		sub cx, si
		inc decr
		add bx, 9h
		sub bl, cols
		loop output_matrix
	ret
	
;Основная функция, реализующая удаление из матрицы строки, содержащей максимальное количество нечетных элементов
main:
	;Инициализация сегментного регистра
	mov ax, DSEG
	mov ds, ax
	
	;Приглашение ввода
	mov ah, 9h
	mov dx, OFFSET row_msg
	int 21h
	call new_line
	
	;Ввод количества строк
	call input_symb
	mov rows, AL
	sub rows, '0'
	call new_line
	
	;Приглашение ввода
	mov ah, 9h
	mov dx, OFFSET col_msg
	int 21h
	call new_line
	
	;Ввод количества столбцов
	call input_symb
	mov cols, AL
	sub cols, '0'
	call new_line
	
	;Приглашение ввода
	mov ah, 9h
	mov dx, OFFSET matrix_msg
	int 21h
	call new_line

	;Построчный ввод матрицы
	mov bx, 0 ; Установка регистр bx в 0
	mov cl, rows ;Установка регистра-счетчика
	input_matrix:
		mov cl, cols ;Переустановка регистра-счетчика
		input_row:
			call input_symb
			mov matrix[bx], al ;Ввод очередного элемента
			sub matrix[bx], '0' ; Измениние представленого число с ascii-кода на десятичное
			inc bx ;Увеличение индекса
			call print_space
			loop input_row
		call new_line
		mov cl, rows
		mov si, decr 
		sub cx, si ;Обновление регистра-счетчика
		inc decr ;Очередная строка прочитана
		add bx, 9
		sub bl, cols
		loop input_matrix

	mov decr, 0 
	mov bx, 0 ; Установка регистр bx в 0
	mov cl, rows ;Установка регистра-счетчика
	find_row: ;Нахождение номера строки с указанным свойством
		mov di, 0
		mov cl, cols ;Переустановка регистра-счетчика
		check_row:
			test matrix[bx], 1 ;Проверка цифры на нечетность
			jp evn ; проверка четности
			inc di
			evn:
			inc bx
			loop check_row
		cmp di, max_num_of_odd ;Определение максимального количества нечетных элементов в строке
		jna not_a ; если не выше	
		mov max_num_of_odd, di
		mov di, decr
		mov row_to_del, di ;Сохранение номера нужной строки
		not_a:
		mov cl, rows
		mov si, decr
		sub cx, si ;Обновление регистра-счетчика
		inc decr ;Очередная строка проанализирована
		add bx, 9h 
		sub bl, cols
		loop find_row
		
	mov bx, row_to_del
	mov ax, 1
	mul bx
	mov bx, 9
	mul bx
	mov bx, ax ;Установка регистра базы на начало удаляемой строки
	
	mov di, row_to_del
	mov decr, di ;Инициализация вспомогательной переменной, используемой для индексации
	
	mov cl, rows
	sub cx, row_to_del ;Установка регистра-счетчика
	
	del: ;Удаление строки с указанным свойством
		mov cl, cols
		shift_row:
			add bl, 9
			mov ah, matrix[bx]
			sub bl, 9
			mov matrix[bx], ah ;Реализация сдвига строки на одну позицию влево
			inc bx
			loop shift_row
		mov cl, rows
		mov si, decr
		sub cx, si ;Обновление регистра-счетчика
		inc decr ;Очередная строка проанализирована
		add bx, 9h
		sub bl, COLS
		loop del
		
	sub rows, 1 ;Строка удалена
	
	call print_matrix
		
	mov ax, 4C00h ;Завершение работы программы
	int 21h

CSEG ENDS
END main
	