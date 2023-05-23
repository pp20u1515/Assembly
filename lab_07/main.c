#include <stdio.h>

#define STR_LEN 35

extern  char *my_strncpy(char *dst, const char *src, const size_t n);

size_t my_strlen(const char *string) {
    size_t len = 0;

    __asm__ (
            "movl $0xffffffff, %%ecx\n\t"
            "mov $0, %%al\n\t"
            "repne scasb\n\t"  // где находится регистер flags
            
            "not %%ecx\n"                 
            "dec %%ecx\n\t"                 
            "movl %%ecx, %0\n\t" 

            : "=D" (len)
            : "D" (string)
            );

    return len;
}

int main(void) {

    char buff1[STR_LEN] = "First test!", buff2[STR_LEN] = "Lets test again this program!";
    char new_buff[STR_LEN] = "\0", new_buff2[STR_LEN] = "\0";

    size_t size = my_strlen(buff1);
    printf("size = %u\n", size);
    my_strncpy(new_buff, buff1, size);
    printf("buff = %s\n\n", new_buff);

    size = my_strlen(buff2);
    printf("size = %u\n", size);
    my_strncpy(new_buff, buff2, size);
    printf("buff = %s\n", new_buff);

    return 0;
}
