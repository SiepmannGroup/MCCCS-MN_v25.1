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

      function mbessel(z,nu)

      use var_type,only:double_precision
      use const_math,only:onepi
      implicit none

        real(KIND=double_precision)::z,nu
        real(KIND=double_precision)::mbessel
        
!       mbessel = sqrt(onepi/(2.0d0*z))*exp(-z)*
!     +         (1.0d0 + (4.0d0*nu**2-1)/(8.0d0*z) +
!     +         (4.0d0*nu**2-1)*(4.0d0*nu**2-9.0d0)/(2.0d0*64.0d0*z**2))

! -- simple form     
        mbessel = sqrt(onepi/(2.0d0*z))*exp(-z)
!     +         (1.0d0 + (4.0d0*nu**2-1)/(8.0d0*z) +
!     +         (4.0d0*nu**2-1)*(4.0d0*nu**2-9.0d0)/(2.0d0*64.0d0*z**2))
        end function mbessel

