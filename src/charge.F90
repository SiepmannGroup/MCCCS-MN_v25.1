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

!> \brief Calculates the intramolcular polarization energies
!> for fluctuating charge moves
!>
!> \par History
!> written by Marcus G. Martin 9-16-97 \n
!> rewritten by Bin Chen 6-25-99
!> updated to remove vewald calculation 1-26-15
subroutine charge( i, qion, vflucq )
  use sim_system
  use energy_pairwise,only:type_2body
  implicit none

  integer::i,imolty,iunit,ii,jj,ntii,ntjj,ntij,ibox
  real::vflucq,qion(numax),qqii
  vflucq = 0.0E0_dp
  imolty = moltyp(i)
  iunit = nunit(imolty)
  ibox = nboxi(i)

! *************************************
! INTRACHAIN FLUCQ INTERACTIONS ***
! *************************************

  ! calculate intramolecular flucq energy for chain i
  do ii = 1, iunit
     ntii = ntype(imolty,ii)
     qqii = qion(ii)
     
     do jj = ii, iunit
        if ( ii .eq. jj ) then
           vflucq = vflucq + xiq(ntii)*qqii + jayself(ntii)*qqii*qqii
        else
           ntjj = ntype(imolty,jj)
           ntij = type_2body(ntii,ntjj)
           
           vflucq = vflucq + jayq(ntij)*qqii*qion(jj)
        end if
     end do
  end do
  ! remove the ground state gas phase energy
  vflucq = vflucq - fqegp(imolty)
  
  return
end subroutine charge






