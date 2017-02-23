
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
