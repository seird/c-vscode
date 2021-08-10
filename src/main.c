#include "main.h"


int
return_1()
{
    return 1;
}


#if (!defined(TEST) && !defined(SHARED) && !defined(STATIC) && !defined(BENCHMARK))
int
main(int argc, char * argv[])
{
    for (int i=0; i<argc; ++i)
        printf("[%d] %s\n", i, argv[i]);
    return 0;
}
#endif
