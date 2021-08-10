[![codecov](https://codecov.io/gh/seird/c-vscode/branch/master/graph/badge.svg)](https://codecov.io/gh/seird/c-vscode)

.vscode/ folder and makefile for a simple c project


## Clone 

```bash
# Clone the repository
$ git clone https://github.com/seird/c-vscode.git
```

## Run

    $ make run

## Test

See `tests/tests.c` for an example.

    $ make test


```c
MU_TEST(function)
MU_RUN_TEST(test)
MU_STATS()

MU_CHECK(test)
MU_CHECK_FLT_EQ(f1, f2)
MU_CHECK_FLT_EQ_ERROR(f1, f2, error)
MU_CHECK_DBL_EQ(d1, d2)
MU_CHECK_DBL_EQ_ERROR(d1, d2, error)
MU_CHECK_INT_EQ(i1, i2)
MU_CHECK_STR_EQ(s1, s2)
MU_ASSERT(message, test)
```

## Benchmark

See `benchmark/benchmarks.c` for an example.

    $ make bench

```c
BENCH_FUNC(function)
BENCH_RUN(function, iterations)
```
