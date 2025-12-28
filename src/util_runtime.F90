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

module util_runtime
  implicit none
#ifdef __MPI__
  include 'mpif.h'
#endif
  private
  public::err_exit
contains
  subroutine err_exit(file,lineno,msg,code)
    character(LEN=*),intent(in)::file,msg
    integer,intent(in)::lineno,code
    integer::ierr

    write(*,FMT='("ERROR in ",A,": line ",I0)') TRIM(file),lineno
    write(*,FMT='("code ",I0,": ",A)') code,msg

#ifdef __MPI__
    call MPI_ABORT(MPI_COMM_WORLD,code,ierr)
#endif

    stop
  end subroutine err_exit
end module util_runtime
