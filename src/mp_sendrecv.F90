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

    INTEGER, INTENT(IN) :: dest, src, tag
    INTEGER, INTENT(INOUT) :: msglen
    INTEGER, INTENT(IN) :: comm
    INTEGER :: myid
#ifdef __MPI__
    INTEGER :: istatus(MPI_STATUS_SIZE)
    INTEGER :: ierr, nrcv

    CALL MPI_comm_rank( comm, myid, ierr )
    IF( ierr /= 0 ) CALL mp_stop(__LINE__)
#else
    myid = 0
#endif

    IF (src .NE. dest) THEN
#ifdef __MPI__
       IF(myid .EQ. src) THEN
          CALL MPI_SEND( msg_src, msglen, MP_TYPE, dest, tag, comm, ierr)
          IF (ierr/=0) CALL mp_stop(__LINE__)
       ELSE IF(myid .EQ. dest) THEN
          CALL MPI_RECV( msg_dest, msglen, MP_TYPE, src, tag, comm, istatus, ierr )
          IF (ierr/=0) CALL mp_stop(__LINE__)
          CALL MPI_GET_COUNT(istatus, MP_TYPE, nrcv, ierr)
          IF (ierr/=0) CALL mp_stop(__LINE__)
          msglen=nrcv
       ELSE
          ! processors not taking part in the communication have 0 length message
          msglen = 0
       END IF
#endif
    ELSE IF (myid .EQ. src)THEN
       msg_dest = msg_src
    END IF

#ifdef __USE_BARRIER
    CALL mp_barrier(comm)
#endif

    RETURN
