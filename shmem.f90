!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! ISO_C_BINDING interface to OpenSHMEM.
!
! John C. Linford (jlinford@paratools.com)
!
!
! Copyright (c) 2017, ParaTools, Inc.
! All rights reserved.
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! (1) Redistributions of source code must retain the above copyright notice,
!     this list of conditions and the following disclaimer.
! (2) Redistributions in binary form must reproduce the above copyright notice,
!     this list of conditions and the following disclaimer in the documentation
!     and/or other materials provided with the distribution.
! (3) Neither the name of ParaTools, Inc. nor the names of its contributors may
!     be used to endorse or promote products derived from this software without
!     specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
! FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
! DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
! SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
! CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
! OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
! OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


module shmem
  implicit none

  interface
    subroutine shmem_init() &
        bind(C,name="shmem_init")
      use, intrinsic :: iso_c_binding
      ! void shmem_init(void);
    end subroutine shmem_init
  end interface

  interface
    integer(kind=C_INT) function shmem_my_pe() &
        bind(C,name="shmem_my_pe")
      use, intrinsic :: iso_c_binding
      ! int shmem_my_pe(void);
    end function shmem_my_pe
  end interface

  interface
    integer(kind=C_INT) function shmem_n_pes() &
        bind(C,name="shmem_n_pes")
      use, intrinsic :: iso_c_binding
      ! int shmem_n_pes(void);
    end function shmem_n_pes
  end interface

  interface
    type(C_PTR) function shmem_malloc(size) &
        bind(C,name="shmem_malloc")
      use, intrinsic :: iso_c_binding
      integer(kind=C_SIZE_T), value :: size
      ! void *shmem_malloc(size_t size);
    end function shmem_malloc
  end interface

  interface
    subroutine shmem_barrier_all() &
        bind(C,name="shmem_barrier_all")
      use, intrinsic :: iso_c_binding
      ! void shmem_barrier_all(void);
    end subroutine shmem_barrier_all
  end interface

  interface
    subroutine shmem_int_put(dest, source, nelems, pe) &
        bind(C,name="shmem_int_put")
      use, intrinsic :: iso_c_binding
      integer(kind=C_INT) :: dest
      integer(kind=C_INT) :: source
      integer(kind=C_SIZE_T), value :: nelems
      integer(kind=C_INT), value :: pe
      !void shmem_int_put(int *dest, const int *source, size_t nelems, int pe);
    end subroutine shmem_int_put
  end interface

  interface
    subroutine shmem_free(ptr) &
        bind(C,name="shmem_free")
      use, intrinsic :: iso_c_binding
      type(C_PTR), value :: ptr
      ! void shmem_free(void *ptr);
    end subroutine
  end interface

  interface
    subroutine shmem_finalize() &
        bind(C,name="shmem_finalize")
      use, intrinsic :: iso_c_binding
      ! void shmem_finalize(void);
    end subroutine
  end interface

end module shmem
