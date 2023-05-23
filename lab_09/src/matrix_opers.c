#include "matrix_opers.h"
#include "return_codes.h"

#include <stdlib.h>
#include <time.h>
#include <stdio.h>

void free_matrix(float **data, const unsigned int rows)
{
    for (unsigned int index = 0; index < rows; index++)
        free(data[index]);

    free(data);
}

float **allocate_matrix(const unsigned int rows, const unsigned int columns)
{
    size_t flag = OK;

    float **data = calloc(rows, sizeof(float *));

    if (data)
    {
        for (unsigned int index = 0; flag == OK && index < rows; index++)
        {
            data[index] = calloc(columns, sizeof(float));

            if (data[index] == NULL)
            {
                flag = DATA_ERROR;
                free_matrix(data, rows);
                data = NULL;
            }
        }
    }
    return data;
}

void sum_matrix(const matrix_t first_matrix, const matrix_t second_matrix)
{
    clock_t start = clock();

    for (unsigned int index_i = 0; index_i < first_matrix.rows; index_i++)
        for (unsigned int index_j = 0; index_j < first_matrix.cols; index_j++)
            first_matrix.data[index_i][index_j] += second_matrix.data[index_i][index_j];

    clock_t end = clock() - start;

    printf("sum_matrix_time = %.8f\n", end / (CLOCKS_PER_SEC * 1.0));
}

void sum_matrix_asm(const matrix_t first_matrix, const matrix_t second_matrix)
{
    clock_t start = clock();
    float result = 0;

    for (unsigned int index_i = 0; index_i < first_matrix.rows; index_i++)
        for (unsigned int index_j = 0; index_j < first_matrix.cols; index_j += 4)
        {
            __asm__(
                "movss xmm0, %1\n\t"
                "movss xmm1, %2\n\t"
                "addss xmm0, xmm1\n\t"
                "movss %0, xmm0\n\t"
                : "=m"(result)
                :"m"(first_matrix.data[index_i][index_j]), "m"(second_matrix.data[index_i][index_j])
            );
        }
    clock_t end = clock() - start;

    printf("sum_asm_matrix_time = %.8f\n", end / (CLOCKS_PER_SEC * 1.0));
}