#include "io_funcs.h"
#include "return_codes.h"
#include "matrix_opers.h"

int main(void)
{
    matrix_t first_matrix, second_matrix;
    int rc = OK;

    init_matrix(&first_matrix);
    init_matrix(&second_matrix);

    rc = read_matrix(&first_matrix);

    if (rc == OK)
    {
        rc = read_matrix(&second_matrix);

        if (rc == OK)
        {
            print_matrix(first_matrix);
            print_matrix(second_matrix);
            sum_matrix(first_matrix, second_matrix);
            sum_matrix_asm(first_matrix, second_matrix);
        }
    }

    return rc;
}
