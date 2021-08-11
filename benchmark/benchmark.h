#ifndef __BENCHMARK_H__
#define __BENCHMARK_H__


#include <stdio.h>
#include <time.h>


#define BENCH_FUNC(function) void function(void)

#define _BENCH_RUN_WIN(function, iterations) do {\
    printf("\n--------- %s ---------\n\n", #function);\
    printf("\r[0 / %d]", iterations);\
    fflush(stdout);\
    float time_start = (float) clock()/CLOCKS_PER_SEC;\
    for (int timeit_i=0; timeit_i < iterations; ++timeit_i) {\
        function();\
        printf("\r[%d / %d]", timeit_i+1, iterations);\
        fflush(stdout);\
    }\
    float time_elapsed = (float) clock()/CLOCKS_PER_SEC - time_start;\
    printf("\n\n%ld ms per run \n", (long)(1000*time_elapsed/iterations));\
    printf("%ld ms total\n\n", (long)(1000*time_elapsed));\
} while (0)


#define _BENCH_RUN_LIN(function, iterations) do {\
    printf("\n--------- %s ---------\n\n", #function);\
    printf("\r[0 / %d]", iterations);\
    fflush(stdout);\
    struct timespec _bench_start_time;\
    clock_gettime(CLOCK_MONOTONIC, &_bench_start_time);\
    for (int timeit_i=0; timeit_i < iterations; ++timeit_i) {\
        function();\
        printf("\r[%d / %d]", timeit_i+1, iterations);\
        fflush(stdout);\
    }\
    struct timespec _bench_end_time;\
    clock_gettime(CLOCK_MONOTONIC, &_bench_end_time);\
    long elapsed_ns = (_bench_end_time.tv_sec - _bench_start_time.tv_sec) * (long)1e9 + (_bench_end_time.tv_nsec - _bench_start_time.tv_nsec);\
    long elapsed_ms = elapsed_ns / 1000000;\
    printf("\n\n%ld ms per run \n", elapsed_ms/iterations);\
    printf("%ld ms total\n\n", elapsed_ms);\
} while (0)


#if __linux__
/**
 * Run a benchmark
 * @param function   The function to be benchmarked
 * @param iterations The number of times to run the function
 */
#define BENCH_RUN _BENCH_RUN_LIN
#else
/**
 * Run a benchmark
 * @param function   The function to be benchmarked
 * @param iterations The number of times to run the function
 */
#define BENCH_RUN _BENCH_RUN_WIN
#endif


#endif
