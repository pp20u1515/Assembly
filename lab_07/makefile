CC := gcc
CC_ASM := nasm
CFLAGS := -Wfloat-equal -fverbose-asm -Wfloat-conversion -Iinc -Wvla

OBJ := ./obj/

.PHONY: clean 

app.exe: obj main.c
	$(CC) $(CFLAGS) -c main.c  -m32  -o $(OBJ)main.o
	$(CC_ASM) -f elf32 additional_funcs.asm -o $(OBJ)additional_funcs.o
	$(CC) $(OBJ)main.o $(OBJ)additional_funcs.o -m32 -o app.exe -lpthread

obj:
	mkdir -p obj

clean :
	rm -fr obj/
	rm *.exe