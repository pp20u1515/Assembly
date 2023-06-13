#include <stdio.h>

#define N 4
#define M 128

void neon_add(const float *v1, const float *v2, float *res)
{
    __asm(
        "ld1 {v0.4s}, [%0]\n" // elements (operand suffix .4S, where S indicates word)
        "ld1 {v1.4s}, [%1]\n"

        "fadd v2.4s, v0.4s, v1.4s\n" 

        "st1 {v2.4s}, [%2]\n" 
        :
        : "r" (v1), "r" (v2), "r" (res) //операнды ввода для ассемблерного кода.
        : "v0", "v1", "v2"
    );
}

size_t strlen_arm(char *buf)
{
    size_t len;

    __asm(
          "ldr x1, %[buf]\n"
          "mov x2, #0\n"    //счетчик длины строки
          "loop:\n"
          "ldrb w0, [x1, x2]\n" 
          "cbz w0, end\n"    
          "add x2, x2, #1\n"    
          "B loop\n"    // безусловный переход к метке "loop"
          "end:\n"
          "mov %[len], x2\n"    //Эта строка перемещает значение из регистра x2 в переменную len.
          : [len] "=r" (len)
          : [buf] "m" (buf) // значение будет прочитано из памяти.
          : "x0", "x1", "x2"//объявляет операнды ввода-вывода и регистры, используемые в инлайн-ассемблере.
      );

    return len;
}

int main()
{
    char row[M] = "test my strlen_arm";
    int len = 0;
    
    len = strlen_arm(row);
    printf("%s \n %d\n\n", row, len);
    
    float v1[N] = {1, 2, 3 , 4};
    float v2[N] = {0.1, 0.2, 0.3 , 0.4};
    float v_res[N] = {0};

    neon_add(v1, v2, v_res);
    puts("res sum {1, 2, 3 , 4} +  {0.1, 0.2, 0.3 , 0.4}");
    for (int i = 0; i < N; ++i)
        printf("%f", v_res[i]);

    return 0;
}