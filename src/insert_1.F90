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

  if (.not.allocated(p)) then
     allocate(p(pos:pos+999))
  else if (pos.gt.ubound(p,1)) then
     call reallocate(p,lbound(p,1),pos+999)
  else if (pos.lt.lbound(p,1)) then
     call reallocate(p,pos-999,ubound(p,1))
  end if
  p(pos)=val
