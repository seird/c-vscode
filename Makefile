CC = gcc
CFLAGS_DEBUG = -g -Wall -Wextra -Werror -Wshadow
CFLAGS_RELEASE = -O3 -Wall -Wextra -Werror -Wshadow -march=native
CFLAGS_TEST = -O0 -Wall -Wextra -Werror -Wshadow -march=native -fprofile-arcs -ftest-coverage
CFLAGS_LIBRARY = -O3 -Wall -Wextra -Werror -Wshadow -march=native

FILES = \
	$(wildcard src/*.c) \

FILES_TEST = \
	$(FILES) \
	$(wildcard tests/*.c) \

FILES_BENCH = \
	$(FILES) \
	$(wildcard benchmark/*.c) \

PNAME   ?= name
LIBTYPE ?= STATIC


ifeq ($(OS),Windows_NT)
	PLATFORM_OS = WINDOWS
else
	PLATFORM_OS = LINUX
endif


ifeq ($(LIBTYPE),SHARED)
	ifeq ($(PLATFORM_OS),WINDOWS)
		LIBNAME = lib$(PNAME).dll
	endif
	ifeq ($(PLATFORM_OS),LINUX)
		LIBNAME = lib$(PNAME).so
	endif
    CFLAGS_LIBRARY = -o $(LIBNAME) -fPIC -shared -DSHARED $(CFLAGS_LIBRARY)
endif
ifeq ($(LIBTYPE),STATIC)
    CFLAGS_LIBRARY += -c -DSTATIC
	LIBNAME = lib$(PNAME).a
endif


ifeq ($(PLATFORM_OS),WINDOWS)
	DIRS_INCLUDE = -IC:/CLibraries/include -IC:/CLibraries/include2
	DIRS_LIB = -LC:/CLibraries/libs
endif
ifeq ($(PLATFORM_OS),LINUX)
	DIRS_INCLUDE = -I/usr/local/include/
	DIRS_LIB = -L/usr/local/lib/
endif


build: 
	$(CC) -o $(PNAME)_release $(FILES) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_RELEASE)

library:
	$(CC) $(FILES) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_LIBRARY)
ifeq ($(LIBTYPE),STATIC)
	ar -rc $(LIBNAME) *.o
endif

run: build
	./$(PNAME)_release

debug:
	$(CC) -o $(PNAME)_debug $(FILES) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_DEBUG)

profile: debug
	valgrind --tool=callgrind ./$(PNAME)_debug

gprof:
	$(CC) -o $(PNAME)_gprof $(FILES) $(CFLAGS_DEBUG) -pg -lm
ifeq ($(PLATFORM_OS),WINDOWS)
	del gmon.out /s
	./$(PNAME)_gprof.exe
	gprof $(PNAME)_gprof.exe gmon.out > a_debug-gprof.out
else
	rm -fv gmon.out
	./$(PNAME)_gprof
	gprof $(PNAME)_gprof gmon.out > a_debug-gprof.out
endif

memcheck: debug
	valgrind --leak-check=full ./$(PNAME)_debug

cache: build
	valgrind --tool=cachegrind ./$(PNAME)_release
	#cg_annotate cachegrind.out.{PID}

test:
	$(CC) -o test -DTEST $(FILES_TEST) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_TEST)
	./test
	gcovr -e "tests/*" --xml-pretty --exclude-unreachable-branches --print-summary -o coverage.xml

coverage_html:
	$(CC) -o test -DTEST $(FILES_TEST) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_TEST)
	./test
	gcovr -e "tests/*" --html --html-details --print-summary -o coverage.html

bench:
	$(CC) -o benchmark -DBENCHMARK $(FILES_BENCH) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_RELEASE)
	./benchmark

clean:
ifeq ($(PLATFORM_OS),WINDOWS)
	del *.o /s
	del *.exe /s
	del *.dll /s
	del *.out.* /s
	del *.so /s
	del *.a /s
	del *.gcda /s
	del *.gcno /s
else
	rm -fv *.o *.exe *.dll *.so *.out.* *.a *.gcda *.gcno
endif
