#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

typedef long (*functionPointer)();

int main() {
    void* handle = dlopen("/usr/lib/libc.dylib", RTLD_NOW);

    functionPointer my_function;
    *(void**)(&my_function) = dlsym(handle, "random");
    printf("%p\n", my_function);

    long result = my_function();
    printf("%li == %li\n", result, random());

    return 0;
}
