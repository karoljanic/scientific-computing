// Karol Janic
// 15.10.2023
// Lista 1, zad 1

#include <stdio.h>
#include <float.h>

int main() {
    printf("FLT_EPSILON = %e\n", FLT_EPSILON);
    printf("DBL_EPSILON = %e\n", DBL_EPSILON);
    printf("LDBL_EPSILON = %Le\n", LDBL_EPSILON);

    printf("FLT_MIN = %e\n", FLT_MIN);
    printf("DBL_MIN = %e\n", DBL_MIN);
    printf("LDBL_MIN = %Le\n", LDBL_MIN);
    
    printf("FLT_MAX = %e\n", FLT_MAX);
    printf("DBL_MAX = %e\n", DBL_MAX);
    printf("LDBL_MAX = %Le\n", LDBL_MAX);

    return 0;
}