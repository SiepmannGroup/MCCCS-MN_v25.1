! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <www.gnu.org>.

    USE var_type,ONLY:DP
    USE util_runtime,ONLY:err_exit
    IMPLICIT NONE
#ifdef __MPI__
  include 'mpif.h'
#endif
    INTEGER, INTENT(IN) :: n, root, comm
    DATA_TYPE :: array( n )
#ifdef __MPI__
    INTEGER, PARAMETER :: maxb = __MSGSIZ_MAX
    INTEGER :: nblk, iblk, remaining, istart, ierr

#ifdef __DEBUG_MPI__
    write(*,*) 'MP_BCAST_AUX IN'
#endif

    IF( n <= 0 ) GO TO 1

#ifdef __USE_BARRIER
    CALL mp_synchronize( comm )
#endif

    nblk   = n / maxb
    DO iblk = 1, nblk
       istart = 1 + ( iblk - 1 ) * maxb
       CALL MPI_BCAST( array(istart), maxb, MP_TYPE, root, comm, ierr )
       IF( ierr /= 0 ) call err_exit(__FILE__,__LINE__, 'mp_bcast_aux error in mpi_bcast 1 ', ierr)
    END DO

    remaining = n - nblk * maxb
    IF( remaining > 0 ) THEN
       istart = 1 + nblk * maxb
       CALL MPI_BCAST( array(istart), remaining, MP_TYPE, root, comm, ierr )
       IF( ierr /= 0 ) call err_exit(__FILE__,__LINE__, 'mp_bcast_aux error in mpi_bcast 2 ', ierr)
    END IF

1   CONTINUE

#ifdef __DEBUG_MPI__
    write(*,*) 'MP_BCAST_AUX OUT'
#endif

#endif
    RETURN
