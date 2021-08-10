#include "benchmarks.h"


int
main(void)
{
    int num_runs = 10;

    printf("\n=================================================\nBenchmarking ...\n");
    printf("\tNumber of runs     = %20d\n", num_runs);
    putchar('\n');

    BENCH_RUN(bench_something_A, num_runs);
    BENCH_RUN(bench_something_B, num_runs);

    return 0;
}
