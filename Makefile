TARGET = a.out

FC = gfortran
FFLAGS = $(OPT_FLAGS) $(WARN_FLAGS) $(OPENSHMEM_FLAGS) $(GASNET_FLAGS)

OPT_FLAGS = -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000
WARN_FLAGS = -Winline
OPENSHMEM_FLAGS = -I/usr/local/packages/openshmem-1.2/include -L/usr/local/packages/openshmem-1.2/lib -Wl,-rpath,/usr/local/packages/openshmem-1.2/lib
GASNET_FLAGS = -L/usr/local/packages//gasnet-1.26.3/lib

LD = $(FC)
LDFLAGS = $(FFLAGS)
LIBS = -lopenshmem -lelf -lgasnet-smp-par -lpthread -lrt -lgcc -lm

OBJ = rotput.o shmem.o

.PHONY: all clean run

all: $(TARGET)

run: all
	oshrun -np 4 ./$(TARGET)

$(TARGET): $(OBJ)
	$(LD) -o $(TARGET) $(LDFLAGS) $(OBJ) $(LIBS)

%.o: %.f90
	$(FC) -c -o $@ $(FFLAGS) $<

clean:
	rm -f $(OBJ) $(MOD)

rotput.o: shmem.o
