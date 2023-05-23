#ifndef IO_FUNCS_H
#define IO_FUNCS_H

#include "struct.h"

void init_matrix(matrix_t *matrix);

int read_dimension(matrix_t *matrix);

void read_data(matrix_t *matrix);

int read_matrix(matrix_t *matrix);

void print_matrix(const matrix_t matrix);

#endif // IO_FUNCS_H