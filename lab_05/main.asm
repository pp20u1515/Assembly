; Ввод: 
; знаковое в 2 с/с
; Вывод: 
; беззнаковое в 10 с/с
; знаковое в 16 с/с

EXTRN read_bin_sign: near
EXTRN print_bin_sign: near
EXTRN print_dec_unsign: near
EXTRN print_hex: near
EXTRN sbhvalue:byte
EXTRN sblvalue:byte


STK SEGMENT PARA STACK 'STACK'
	    DB 200 dup (0)
STK ENDS

SEGDATA SEGMENT PARA PUBLIC 'DATA'
	menu_print DB "1. Input sign num in binary format", 10, 13
	           DB "2. Output num in binary format", 10, 13
	           DB "3. Output num in unsigned decimal format", 10, 13
	           DB "4. Output num in signed hex format", 10, 13
	           DB "5. Exit", 10, 13
	           DB "Enter mode: $"
	actions    DW read_bin_sign, print_bin_sign, print_dec_unsign, print_hex, exit ; индекси 0, 2,4, 6, 8
SEGDATA ENDS

SEGCODE SEGMENT PARA PUBLIC "CODE"
	        ASSUME CS:SEGCODE, DS:SEGDATA, SS:STK

	new_line proc
		mov    ah, 2 ; вывод символа в stdout
		mov    dl, 10 ;перевести курсор на нов. строку
		int    21h ;вызов функции DOS 
		mov    dl, 13 ;курсор поместить в нач. строки
		int    21h ;вызов функции DOS
		ret
    new_line endp

	main:   
		mov    AX, SEGDATA
		mov    DS, AX
		
		menu:   
			mov    ah, 9 ; вывод строки в stdout
			mov    dx, offset menu_print 
			int    21h ;вызов функции DOS
			mov    ah, 1 ; считать символ из stdin с эхом
			int    21h ;вызов функции DOS

			sub    al, "1" ; если мы выбрали пункт 3, то вычитаем 1 из символьного значения считанного символа.
							; Это связано с тем, что в данном счучае пункты меню нумеруются начиная с 1, а в 
							; процессоре они нумеруются начиная с 0   
			mov    dl, 2 ; загрузка значения 2 в регистр dl
			mul    dl ; умножение регистра al на значение регистра dl. В результате получаем значение, которое
						; будет использоваться в качестве индекса массива "actions" 
			mov    bx, ax ; сохраняем наш выбор из меню
			
			call new_line
			call   actions[bx] ; вызов метки actions
			jmp    menu 
	exit:
		mov    ax, 4c00h
		int    21h
SEGCODE ENDS
END main