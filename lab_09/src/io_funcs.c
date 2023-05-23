#include <stdio.h>
#include <stdlib.h>

#include "io_funcs.h"
#include "return_codes.h"
#include "matrix_opers.h"

#define MIN_DATA 0
#define MAX_DATA 10

void init_matrix(matrix_t *matrix)
{
    matrix->data = NULL;
    matrix->rows = 0;
    matrix->cols = 0;
}

int read_dimension(matrix_t *matrix)
{
    int rc = OK;

    printf("Введите количество строк и столбцов матрицы: ");

    if (scanf("%u", &matrix->rows) == 1 && matrix->rows > 0)
    {
        if (scanf("%u", &matrix->cols) != 1 && matrix->cols <= 0)
            rc = DIMENSTIONS_ERROR;
    }
    else
        rc = DIMENSTIONS_ERROR;

    return rc;        
}

void read_data(matrix_t *matrix)
{
    for (unsigned int index_i = 0; index_i < matrix->rows; index_i++)
        for (unsigned int index_j = 0; index_j < matrix->cols; index_j++)
        {
            float x = MIN_DATA + rand() % (MAX_DATA - MIN_DATA + 1);
            matrix->data[index_i][index_j] = x;
        }
}

int read_matrix(matrix_t *matrix)
{
    int rc = read_dimension(matrix);
    
    if (rc == OK)
    {
        matrix->data = allocate_matrix(matrix->rows, matrix->cols);

        if (matrix->data)
            read_data(matrix);
        else
            rc = ALLOCATE_ERROR;
    }

    return rc;
}

void print_matrix(const matrix_t matrix)
{
    printf("\tMatrix:\n\n");

    for (unsigned int index_i = 0; index_i < matrix.rows; index_i++)
    {
        for (unsigned int index_j = 0; index_j < matrix.cols; index_j++)
            printf("%.4f ", matrix.data[index_i][index_j]);

        printf("\n");
    }
}