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

    DATA_TYPE, INTENT(IN) :: mydata(:)
    DATA_TYPE, INTENT(OUT) :: alldata(:)
    INTEGER, INTENT(IN) :: comm
#ifndef ALLGATHER
    INTEGER, INTENT(IN)::root
#endif
    INTEGER :: msglen, ierr

    msglen = SIZE(mydata)
    !IF( msglen .NE. SIZE(alldata, 1) ) CALL mp_stop(__LINE__)

#ifdef __MPI__

#ifdef ALLGATHER
    CALL MPI_ALLGATHER(mydata, msglen, MP_TYPE, alldata, msglen, MP_TYPE, comm, IERR)
#else
    CALL MPI_GATHER(mydata, msglen, MP_TYPE, alldata, msglen, MP_TYPE, root, comm, IERR)
#endif

    IF (ierr/=0) CALL mp_stop(__LINE__)

#else
    alldata(1:msglen) = mydata
#endif
    RETURN
