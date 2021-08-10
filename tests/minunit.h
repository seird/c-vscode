#ifndef __MINUNIT_H__
#define __MINUNIT_H__


#include <stdio.h>
#include <math.h>
#include <float.h>
#include <string.h>


extern int tests_run;
extern int tests_failed;
extern int tests_result;


#define MU_TEST(function) void function(void)

#define MU_CHECK(test) do {\
    if (!(test)) {\
        printf("%s failed:\n\t%s:%d : %s\n\n", __func__, __FILE__, __LINE__, #test);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_FLT_EQ(f1, f2) do {\
    if (fabsf((float)(f1) - (float)(f2)) > FLT_EPSILON) {\
        printf("%s failed:\n\t%s:%d : %f != %f\n\n", __func__, __FILE__, __LINE__, (float)f1, (float)f2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_FLT_EQ_ERROR(f1, f2, error) do {\
    if (fabsf((float)(f1) - (float)(f2)) > (float)error) {\
        printf("%s failed:\n\t%s:%d : %f != %f\n\n", __func__, __FILE__, __LINE__, (float)f1, (float)f2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_DBL_EQ(d1, d2) do {\
    if (fabsf((float)(d1) - (float)(d2)) > FLT_EPSILON) {\
        printf("%s failed:\n\t%s:%d : %f != %f\n\n", __func__, __FILE__, __LINE__, (double)d1, (double)d2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_DBL_EQ_ERROR(d1, d2, error) do {\
    if (fabsf((float)(d1) - (float)(d2)) > (double)error) {\
        printf("%s failed:\n\t%s:%d : %f != %f\n\n", __func__, __FILE__, __LINE__, (double)d1, (double)d2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_INT_EQ(i1, i2) do {\
    if ((int)i1 != (int)i2) {\
        printf("%s failed:\n\t%s:%d : %d != %d\n\n", __func__, __FILE__, __LINE__, (int)i1, (int)i2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_CHECK_STR_EQ(s1, s2) do {\
    if (strcmp((char*)s1, (char*)s2)) {\
        printf("%s failed:\n\t%s:%d : %s != %s\n\n", __func__, __FILE__, __LINE__, (char*)s1, (char*)s2);\
        tests_result = 1;\
    }\
} while (0)

#define MU_ASSERT(message, test) do {\
    if (!(test)) {\
        printf("%s failed:\n\t%s:%d : %s\n\t%s\n\n", __func__, __FILE__, __LINE__, #test, message);\
        tests_result = 1;\
    }\
} while (0)

#define MU_RUN_TEST(test) do {\
    tests_result = 0;\
    test();\
    tests_failed += tests_result;\
    tests_run++;\
} while (0)

#define MU_STATS() printf("%d tests, %d failed\n\n", tests_run, tests_failed)


#endif
