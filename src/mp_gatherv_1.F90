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

    DATA_TYPE:: mydata(:)
    DATA_TYPE:: alldata(:)
    INTEGER, INTENT(IN) :: recvcount(:), displs(:)
    INTEGER, INTENT(IN) :: comm
#ifndef ALLGATHER
    INTEGER, INTENT(IN) :: root
#endif
    INTEGER :: ierr, npe, myid

#ifdef __MPI__

    CALL MPI_comm_size( comm, npe, ierr )
    IF (ierr/=0) CALL mp_stop(__LINE__)

    CALL MPI_comm_rank( comm, myid, ierr )
    IF (ierr/=0) CALL mp_stop(__LINE__)

    IF ( SIZE( recvcount ) < npe .OR. SIZE( displs ) < npe ) CALL mp_stop(__LINE__)

#ifndef ALLGATHER
    IF ( myid == root ) THEN
#endif

       IF ( SIZE( alldata ) < displs( npe ) + recvcount( npe ) ) CALL mp_stop(__LINE__)

#ifndef ALLGATHER
    END IF
#endif

    IF ( SIZE( mydata ) < recvcount( myid + 1 ) ) CALL mp_stop(__LINE__)

#ifdef ALLGATHER
    CALL MPI_ALLGATHERV( mydata, recvcount( myid + 1 ), MP_TYPE, &
     alldata, recvcount, displs, MP_TYPE, comm, ierr )
#else
    CALL MPI_GATHERV( mydata, recvcount( myid + 1 ), MP_TYPE, &
     alldata, recvcount, displs, MP_TYPE, root, comm, ierr )
#endif

    IF (ierr/=0) CALL mp_stop(__LINE__)

#else
    IF ( SIZE( alldata ) < recvcount( 1 ) ) CALL mp_stop(__LINE__)
    IF ( SIZE( mydata  ) < recvcount( 1 ) ) CALL mp_stop(__LINE__)
    alldata( 1:recvcount( 1 ) ) = mydata( 1:recvcount( 1 ) )
#endif
    RETURN
