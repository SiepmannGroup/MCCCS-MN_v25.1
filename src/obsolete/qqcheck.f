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

      subroutine qqcheck(i,ibox,rxuu1,ryuu1,rzuu1)

!     **************************************************************
!     ***  sets up the coulom() array for use with the group based *
!     ***  cutoff for charged molecules     Marcus Martin          *
!     **************************************************************

      use global_data
      use var_type
      use const_phys
      use const_math
      use util_math
      use util_string
      use util_files
      use util_timings
      implicit none
      include 'common.inc'

!$$$      include 'control.inc'
!$$$      include 'coord.inc'
!$$$      include 'poten.inc'
!$$$      include 'system.inc'
!$$$      include 'qqlist.inc'

      integer(KIND=normal_int)::i,ibox,jmolty,j

      real(KIND=double_precision)::rcutsq,rxuu1,ryuu1,rzuu1,rxuij,ryuij,rzuij ,rijsq

      rcutsq = rcut(ibox)*rcut(ibox)

      if ( lpbc ) call setpbc(ibox)

      do j = 1,nchain
         lcoulom(j) = .false.
         jmolty = moltyp(j)

         if ( (nboxi(j) .eq. ibox) .and. (i .ne. j) ) then

! ---  check for the group based qq cutoff
            if ( lelect(jmolty) ) then
               rxuij = rxuu1 - rxu(j,1)
               ryuij = ryuu1 - ryu(j,1)
               rzuij = rzuu1 - rzu(j,1)

! --- minimum image the coulombic bead pair separations ***
               if ( lpbc ) call mimage ( rxuij,ryuij,rzuij,ibox )

               rijsq = rxuij*rxuij + ryuij*ryuij + rzuij*rzuij

               if ( (rijsq .lt. rcutsq) .or. lchgall) then
                  lcoulom(j) = .true.
               end if
            end if

         end if

      end do

      return
      end
