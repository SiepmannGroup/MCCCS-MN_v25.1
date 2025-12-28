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

!> \brief Define variable types(kinds) based on required precision, rather than
!> the default values that rely on the computer architecture and may
!> cause inconsistent behavior across platforms
module var_type
  implicit none

  integer,parameter::single_precision=selected_real_kind(6,30),single_precision_size=4
  integer,parameter::double_precision=selected_real_kind(14,200),double_precision_size=8
!> \brief dp is default precision
#ifdef __DOUBLE_PRECISION__
  integer,parameter::dp=double_precision
#else
  integer,parameter::dp=single_precision
#endif

  integer,parameter::normal_int=selected_int_kind(5),int_size=4
  integer,parameter::long_int=selected_int_kind(10),long_int_size=8

  integer,parameter::default_string_length=512,default_path_length=256,atom_symbol_length=4

  type IntegerPtr
     integer,pointer::val
  end type IntegerPtr

  type IntegerAllocArray3D
     integer,allocatable::val(:,:,:)
  end type IntegerAllocArray3D

  type RealPtr
     real,pointer::val
  end type RealPtr

  type RealAllocArray3D
     real,allocatable::val(:,:,:)
  end type RealAllocArray3D
end module var_type
