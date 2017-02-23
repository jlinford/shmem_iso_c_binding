!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! A simple example that uses ISO_C_BINDING to call OpenSHMEM functions.
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

program rotput
  use shmem
  use, intrinsic :: iso_c_binding

  integer :: nextpe
  integer(C_INT) :: me, npes
  integer(C_INT) :: src
  type(C_PTR) :: cptr_dest
  integer(C_INT), pointer :: dest
  character(C_CHAR), dimension(SHMEM_MAX_NAME_LEN) :: shmem_name
  integer(C_INT), dimension(2) :: shmem_version

  call shmem_init()

  call shmem_info_get_name(shmem_name)
  write (*,*) shmem_name(1:maxloc(index(shmem_name, C_NULL_CHAR), 1))

  call shmem_info_get_version(shmem_version(1), shmem_version(2))
  write (*,"('Version ',I0,'.',I0)") shmem_version

  me = shmem_my_pe()
  npes = shmem_n_pes()
  write (*,"('Hello from PE ',I0,' of ',I0)") me,npes

  nextpe = mod(me+1, npes)
  src = nextpe

  if (shmem_pe_accessible(int(nextpe,kind=C_INT)) == 0) then
    write (*,"('ERROR: ',I0,' is not acessible from ',I0)") nextpe,me
  else
    write (*,"(I0,' is accessible from ',I0)") nextpe,me
  end if

  cptr_dest = shmem_malloc(c_sizeof(C_INT))
  if (.not.c_associated(cptr_dest)) then
    write (*,*) "shmem_malloc failed"
    stop
  end if
  call c_f_pointer(cptr_dest, dest)

  dest = -1
  call shmem_barrier_all()

  if (shmem_addr_accessible(cptr_dest, int(nextpe,kind=C_INT)) == 0) then
    write (*,"('ERROR: dest on ',I0,' is not acessible from ',I0)") nextpe,me
  else
    write (*,"('dest on ',I0,' is accessible from ',I0)") nextpe,me
  end if

  call shmem_int_put(dest, src, int(1, C_SIZE_T), nextpe)

  call shmem_barrier_all()
  if (dest == me) then
    write (*,"(I0,': got ',I0,': CORRECT')") me,dest
  else
    write (*,"(I0,': got ',I0,': WRONG, expected ',I0)") me,dest,me
  end if

  call shmem_barrier_all()
  call shmem_free(cptr_dest)
  call shmem_finalize()

end program rotput

