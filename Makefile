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
	UNAMEOS = $(shell uname)
	ifeq ($(UNAMEOS),Linux)
		PLATFORM_OS = LINUX
	endif
	ifeq ($(UNAMEOS),FreeBSD)
		PLATFORM_OS = BSD
	endif
	ifeq ($(UNAMEOS),OpenBSD)
		PLATFORM_OS = BSD
	endif
	ifeq ($(UNAMEOS),NetBSD)
		PLATFORM_OS = BSD
	endif
	ifeq ($(UNAMEOS),DragonFly)
		PLATFORM_OS = BSD
	endif
	ifeq ($(UNAMEOS),Darwin)
		PLATFORM_OS = OSX
	endif
endif


ifeq ($(LIBTYPE),SHARED)
    CFLAGS_LIBRARY += -fPIC -shared -DSHARED -o $(LIBNAME)
	ifeq ($(PLATFORM_OS),WINDOWS)
		LIBNAME = lib$(PNAME).dll
	endif
	ifeq ($(PLATFORM_OS),LINUX)
		LIBNAME = lib$(PNAME).so
	endif
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
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_RELEASE) $(FILES) -o $(PNAME)_release

library:
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_LIBRARY) $(FILES)
ifeq ($(LIBTYPE),STATIC)
	ar -rc $(LIBNAME) *.o
endif

run: build
	./$(PNAME)_release

debug:
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_DEBUG) $(FILES) -o $(PNAME)_debug 

profile: debug
	valgrind --tool=callgrind ./$(PNAME)_debug

memcheck: debug
	valgrind --leak-check=full ./$(PNAME)_debug

cache: build
	valgrind --tool=cachegrind ./$(PNAME)_release
	#cg_annotate cachegrind.out.{PID}

test:
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_TEST) -DTEST $(FILES_TEST) -o test
	./test
	gcovr -e "tests/*" --xml-pretty --exclude-unreachable-branches --print-summary -o coverage.xml

coverage_html:
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_TEST) -DTEST $(FILES_TEST) -o test
	./test
	gcovr -e "tests/*" --html --html-details --print-summary -o coverage.html

bench:
	$(CC) $(DIRS_INCLUDE) $(DIRS_LIB) $(CFLAGS_RELEASE) -DBENCHMARK $(FILES_BENCH) -o benchmark
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
