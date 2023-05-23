$(shell mkdir -p out)

CC := g++
CC_ASM := nasm
CFLAGS :=  -fverbose-asm -masm=intel -Iinc

LINKFLAGS := -lpthread

PREF_SRC := ./src/
PREF_INC := ./inc/
PREF_OUT := ./out/

MATH := $(PREF_SRC)main_math.cpp
SIN := $(PREF_SRC)main_sin.cpp

OBJ_MATH := $(PREF_OUT)main_math.o
OBJ_SIN := $(PREF_OUT)main_sin.o

fpu: CFLAGS += -m80387 
fpu: math sin

sse: CFLAGS += -mno-80387 -mno-sse
sse: math sin

pi: sin

math: $(OBJ_MATH)
	$(CC) $(OBJ_MATH) -m32 -o main_math.exe 

sin: $(OBJ_SIN)
	$(CC) $(OBJ_SIN) -m32 -o main_sin.exe 


$(OBJ_MATH): $(MATH)
	$(CC) $(CFLAGS) -m32   -c -MD $< -o $@

$(OBJ_SIN): $(SIN)
	$(CC) $(CFLAGS) -m32  -c -MD $< -o $@

assembly:
	g++ -S $(MATH) -O0 -Iinc -o $(PREF_OUT)main_math_sse.s
	g++ -S $(MATH) -m80387 -O0 -Iinc -o $(PREF_OUT)main_math_fpu.s

	g++ -S $(SIN) -masm=intel -O0 -Iinc -o $(PREF_OUT)main_sin.s

include $(wildcard $(PREF_OUT)*.d)

.PHONY: run assembly clean 

clean :
	rm -Rf $(PREF_OUT) ./*.exe