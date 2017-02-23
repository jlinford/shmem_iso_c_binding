###############################################################################
#
# John C. Linford (jlinford@paratools.com)
#
# Copyright (c) 2017, ParaTools, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# (1) Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
# (2) Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
# (3) Neither the name of ParaTools, Inc. nor the names of its contributors may
#     be used to endorse or promote products derived from this software without
#     specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################

TARGET = a.out

FC = mpif90
FFLAGS = $(OPT_FLAGS) $(WARN_FLAGS) $(OPENSHMEM_FLAGS) $(GASNET_FLAGS)

OPT_FLAGS = -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000 -Winline -std=gnu99 -D_GNU_SOURCE=1
WARN_FLAGS =
OPENSHMEM_FLAGS = -I/usr/local/packages/openshmem-1.3/openmpi-1.8_gcc-4.9/include -L/usr/local/packages/openshmem-1.3/openmpi-1.8_gcc-4.9/lib
GASNET_FLAGS = -L/usr/local/packages/GASNet-1.28.0/openmpi-1.8_gcc-4.9/lib -L/storage/packages/gcc/4.9.3/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.9.3

mpif90 -I/usr/local/packages/openshmem-1.3/openmpi-1.8_gcc-4.9/include rotput.f90 -L/usr/local/packages/openshmem-1.3/openmpi-1.8_gcc-4.9/lib -O3 --param max-inline-insns-single=35000 --param inline-unit-growth=10000 --param large-function-growth=200000 -Winline -std=gnu99 -D_GNU_SOURCE=1 -lopenshmem -L/usr/lib64 -Wl,-rpath,/usr/lib64 -lelf -L/usr/local/packages/GASNet-1.28.0/openmpi-1.8_gcc-4.9/lib -lgasnet-mpi-par -lammpi -lpthread -lrt -L/storage/packages/gcc/4.9.3/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.9.3 -lgcc -lm


LD = $(FC)
LDFLAGS = $(FFLAGS) -L/usr/lib64 -Wl,-rpath,/usr/lib64
LIBS = -lopenshmem -lelf -lgasnet-mpi-par -lammpi -lpthread -lrt -lgcc -lm

OBJ = rotput.o shmem.o

MOD = shmem.mod


.PHONY: all clean run

all: $(TARGET)

run: all
	oshrun -np 4 ./$(TARGET)

clean:
	rm -f $(OBJ) $(MOD) $(TARGET)

$(TARGET): $(OBJ)
	$(LD) -o $(TARGET) $(LDFLAGS) $(OBJ) $(LIBS)

%.o: %.f90
	$(FC) -c -o $@ $(FFLAGS) $<

rotput.o: shmem.o

