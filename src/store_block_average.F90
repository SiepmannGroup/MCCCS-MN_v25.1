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

    real::inv_dif_count

    inv_dif_count=real(new_count-last_count,dp)
    if (inv_dif_count.gt.0.5_dp) then
       inv_dif_count=1.0_dp/inv_dif_count
       ! The sequence of calculations is for avoiding overflow problems
       block_average=inv_dif_count*new_count*new_value-inv_dif_count*last_count*last_value
       last_value=new_value
       last_count=new_count
    end if
