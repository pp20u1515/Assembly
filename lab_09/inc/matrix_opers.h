#ifndef MATRIX_OPERS_H
#define MATRIX_OPERS_H

#include "struct.h"

float **allocate_matrix(const unsigned int rows, const unsigned int columns);

void free_matrix(float **data, const unsigned int rows);

void sum_matrix_asm(const matrix_t first_matrix, const matrix_t second_matrix);

void sum_matrix(const matrix_t first_matrix, const matrix_t second_matrix);

#endif // MATRIX_OPERS_H