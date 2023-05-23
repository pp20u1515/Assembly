#include <iostream>
#include <ctime>
#include <cmath>

using namespace std;

#define TIMES 1000

void cout_time(clock_t time, const char* action)
{
    cout << "   " << action << ": " << ((double)time) / CLOCKS_PER_SEC << " s.";
}

void sum_float(const float a, const float b)
{
    float result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a + b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sum");
}

void mul_float(const float a, const float b)
{
    float result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a * b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");
}

void sum_asm_float(const float a, const float b)
{
    float result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__(
            "fld %1\n"                                          
            "fld %2\n"                                          
            "faddp %%ST(1), %%ST(0)\n"                          
            "fstp %0\n"                                         
            : "=m"(result)                                      
            : "m"(a),                                           
              "m"(b)                                            
        );
        res_time += clock() - start_time;
    }
    
    cout_time(res_time, "Sum");
}

void mul_asm_float(const float a, const float b)
{
    float result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__
        (
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");
}

void sum_double(const double a, const double b)
{
    double result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a + b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Sum");
}

void mul_double(const double a, const double b)
{
    double result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        result = a * b;
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");
}

void sum_asm_double(const double a, const double b)
{
    double result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__(
            "fld %1\n"                                          
            "fld %2\n"                                          
            "faddp %%ST(1), %%ST(0)\n"                          
            "fstp %0\n"                                         
            : "=m"(result)                                      
            : "m"(a),                                           
              "m"(b)                                            
        );
        res_time += clock() - start_time;
    }
    
    cout_time(res_time, "Sum");
}

void mul_asm_double(const double a, const double b)
{
    double result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < TIMES; i++)
    {
        start_time = clock();
        __asm__
        (
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }

    cout_time(res_time, "Mul");
}

template <typename Type>
void time_measure(Type a, Type b)
{
    cout << "   ASM_FLOAT:";
    sum_asm_float(a, b);
    mul_asm_float(a, b);

    cout << "   CPP_FLOAT:";
    sum_float(a, b);
    mul_float(a, b);

    cout << endl;
    cout << "   ASM_DOUBLE:";
    sum_asm_double(a, b);
    mul_asm_double(a, b);

    cout << "   CPP_DOUBLE:";
    sum_double(a, b);
    mul_double(a, b);
}

int main()
{
    float f1 = 1.1f;
    float f2 = 2.3f;
    cout << " FLOAT:" << endl;
    time_measure(f1, f2);

    double d1 = 2.3;
    double d2 = 5.6;
    cout << "\n DOUBLE:" << endl;
    time_measure(d1, d2);
    cout << endl;
    
    return 0;
}
