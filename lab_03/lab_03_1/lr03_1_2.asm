PUBLIC output_X ; указываем что метка output_X может быть вызвана из другого модуля
EXTRN X: byte ; указываем что метка X находится в другом модуле

DS2 SEGMENT AT 0b800h ; сегмент данных с физическим адрессом на сегмент видеопамяти, так сам адрес видеопамяти d8000h
	CA LABEL byte ; Директива LABEL определяет метку и задает ее тип
	ORG 80 * 2 * 2 + 2 * 2 ; 80 строк по 2 символа, каждый символ занимает ячейку из 2 байта,
	 					   ; последная строка 2, каждый символ занимает ячейку из 2 байта

	SYMB LABEL word ; Директива LABEL определяет метку и задает ее тип
DS2 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, ES:DS2
output_X proc near
	mov ax, DS2
	mov es, ax
	mov ah, 10
	mov al, X
	mov symb, ax
	ret
output_X endp
CSEG ENDS
END