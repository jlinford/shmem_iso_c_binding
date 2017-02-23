# shmem_iso_c_binding

A simple Fortran example that uses [ISO_C_BINDING](https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fC_005fBINDING.html) to call OpenSHMEM.

Comple with `make`.  Here's with GCC 4.8:
```
jlinford@godzilla ~/workspace/shmem_iso_c_binding $ make
gfortran -c -o shmem.o -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000 -Winline -I/usr/local/packages/openshmem-1.2/include -L/usr/local/packages/openshmem-1.2/lib -Wl,-rpath,/usr/local/packages/openshmem-1.2/lib -L/usr/local/packages//gasnet-1.26.3/lib shmem.f90
gfortran -c -o rotput.o -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000 -Winline -I/usr/local/packages/openshmem-1.2/include -L/usr/local/packages/openshmem-1.2/lib -Wl,-rpath,/usr/local/packages/openshmem-1.2/lib -L/usr/local/packages//gasnet-1.26.3/lib rotput.f90
gfortran -o a.out -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000 -Winline -I/usr/local/packages/openshmem-1.2/include -L/usr/local/packages/openshmem-1.2/lib -Wl,-rpath,/usr/local/packages/openshmem-1.2/lib -L/usr/local/packages//gasnet-1.26.3/lib rotput.o shmem.o -lopenshmem -lelf -lgasnet-smp-par -lpthread -lrt -lgcc -lm
```

Run with `oshrun`:
```
jlinford@godzilla ~/workspace/shmem_iso_c_binding $ make run
oshrun -np 4 ./a.out
Hello from PE 2 of 4
Hello from PE 0 of 4
Hello from PE 1 of 4
Hello from PE 3 of 4
2: got 2: CORRECT
0: got 0: CORRECT
3: got 3: CORRECT
1: got 1: CORRECT
```
