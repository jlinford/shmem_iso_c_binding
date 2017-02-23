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

