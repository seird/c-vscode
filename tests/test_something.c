#include "tests.h"
#include "../src/main.h"


MU_TEST(test_something_A)
{
    MU_ASSERT("test_something_A failed", 1 == 1);
    MU_CHECK(1 == 1);
    MU_CHECK_INT_EQ(20, 20);
    MU_CHECK_FLT_EQ(1.1, 1.1);
    MU_CHECK_FLT_EQ_ERROR(1.0, 1.2, 0.21);
    MU_CHECK_DBL_EQ(1.1, 1.1);
    MU_CHECK_DBL_EQ_ERROR(1.0, 1.2, 0.21);
    MU_CHECK_STR_EQ("str", "str");

    MU_CHECK_INT_EQ(1, return_1());
}
