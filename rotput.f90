
program rotput
  use shmem
  use, intrinsic :: iso_c_binding

  integer :: nextpe
  integer(C_INT) :: me, npes
  integer(C_INT) :: src
  type(C_PTR) :: cptr_dest
  integer(C_INT), pointer :: dest

  call shmem_init()

  me = shmem_my_pe()
  npes = shmem_n_pes()
  write (*,"('Hello from PE ',I0,' of ',I0)") me,npes

  nextpe = mod(me+1, npes)
  src = nextpe

  cptr_dest = shmem_malloc(c_sizeof(C_INT))
  if (.not.c_associated(cptr_dest)) then
    write (*,*) "shmem_malloc failed"
    stop
  end if
  call c_f_pointer(cptr_dest, dest, [1])

  dest = -1
  call shmem_barrier_all()

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

