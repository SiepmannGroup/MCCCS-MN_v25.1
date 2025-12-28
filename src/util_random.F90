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

!> \brief (Pseudo)random number generator (RNG)
!>
!> -- Mersenne-Twister (MT19937) with initialization improved
!> \author Originally coded in C by Takuji Nishimura and Makoto Matsumoto (2002-01-26)
!> \author Translated to Fortran 77 by Tsuyoshi TADA. (2005-12-19)
!> \author Modified for use in topmon by Peng Bai. (2012-02-11)
module util_random
  use var_type,only:dp
  use const_math,only:twopi
  use util_runtime,only:err_exit
  use util_prng,only:rng_stream_type_ptr,create_rng_stream,next_random_number
  implicit none
  private
  save
  public::ranset,random,sphere,rotmat

  TYPE(rng_stream_type_ptr),ALLOCATABLE::rng(:)
contains
!-----------------------------------------------------------------------
!> \brief Initialize large number (over 32-bit constant number)
!-----------------------------------------------------------------------
  subroutine mt_initln
    integer::ALLBIT_MASK
    integer::TOPBIT_MASK
    integer::UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
    integer::mag01(0:1)
    common /mt_mask1/ ALLBIT_MASK
    common /mt_mask2/ TOPBIT_MASK
    common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
    common /mt_mag01/ mag01
!C    TOPBIT_MASK = Z'80000000'
!C    ALLBIT_MASK = Z'ffffffff'
!C    UPPER_MASK  = Z'80000000'
!C    LOWER_MASK  = Z'7fffffff'
!C    MATRIX_A    = Z'9908b0df'
!C    T1_MASK     = Z'9d2c5680'
!C    T2_MASK     = Z'efc60000'
    TOPBIT_MASK=1073741824
    TOPBIT_MASK=ishft(TOPBIT_MASK,1)
    ALLBIT_MASK=2147483647
    ALLBIT_MASK=ior(ALLBIT_MASK,TOPBIT_MASK)
    UPPER_MASK=TOPBIT_MASK
    LOWER_MASK=2147483647
    MATRIX_A=419999967
    MATRIX_A=ior(MATRIX_A,TOPBIT_MASK)
    T1_MASK=489444992
    T1_MASK=ior(T1_MASK,TOPBIT_MASK)
    T2_MASK=1875247104
    T2_MASK=ior(T2_MASK,TOPBIT_MASK)
    mag01(0)=0
    mag01(1)=MATRIX_A
    return
  end subroutine mt_initln

!-----------------------------------------------------------------------
!> \brief Initialize mt(0:N-1) with a seed
!>
!> This subroutine should be called once before using the RNG, otherwise
!> a default seed will be used.
!>
!> \param s seed, must be non-negative
!-----------------------------------------------------------------------
  subroutine RANSET(s,nStream)
    use util_string,only:integer_to_string
    integer,intent(in)::s,nStream
    integer,parameter::N=624,DONE=123456789
    integer::ALLBIT_MASK
    integer::mti,initialized
    integer::mt(0:N-1)
    common /mt_mask1/ ALLBIT_MASK
    common /mt_state1/ mti,initialized
    common /mt_state2/ mt
    real(8)::iseeds(3,2)
    integer::i,ierr
    logical::err

    call mt_initln
    mt(0)=iand(s,ALLBIT_MASK)
    do mti=1,N-1
       mt(mti)=1812433253*ieor(mt(mti-1),ishft(mt(mti-1),-30))+mti
       mt(mti)=iand(mt(mti),ALLBIT_MASK)
    end do
    initialized=DONE

    if (nStream.gt.1) then
       if (allocated(rng)) deallocate(rng,stat=ierr)
       allocate(rng(0:nStream-1),stat=ierr)
       if (ierr.ne.0) call err_exit(__FILE__,__LINE__,'RANSET: allocation error',ierr)

       do i=0,nStream-1
          rng(i)%val=>null()
       end do

       iseeds=s
       err=create_rng_stream(rng(0)%val,integer_to_string(0),seed=iseeds)
       if (err) call err_exit(__FILE__,__LINE__,'RANSET: error creating prng stream 0',-1)

       do i=1,nStream-1
          err=create_rng_stream(rng(i)%val,integer_to_string(i),last_rng_stream=rng(i-1)%val)
          if (err) call err_exit(__FILE__,__LINE__,'RANSET: error creating prng stream '//integer_to_string(i),-1)
       end do
    end if

    return
  end subroutine RANSET

!-----------------------------------------------------------------------
!> \brief Generates a random number on [0,1)-real-interval
!-----------------------------------------------------------------------
  function random(iStream)
    integer,intent(in)::iStream
    real::random
    integer,parameter::N=624,M=397,DONE=123456789
    integer::UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
    integer::mti,initialized
    integer::mt(0:N-1)
    integer::mag01(0:1)
    common /mt_state1/ mti,initialized
    common /mt_state2/ mt
    common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
    common /mt_mag01/ mag01
    integer::y,kk

    if (iStream.ge.0) then
       RANDOM=next_random_number(rng(iStream)%val)
       return
    end if

    ! iStream.lt.0

    if(initialized.ne.DONE)then
       call RANSET(21641,1)
    end if
!   First generates a random number on [0,0xffffffff]-interval
    if(mti.ge.N)then
       do kk=0,N-M-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+M),ishft(y,-1)),mag01(iand(y,1)))
       end do
       do kk=N-M,N-1-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+(M-N)),ishft(y,-1)),mag01(iand(y,1)))
       end do
       y=ior(iand(mt(N-1),UPPER_MASK),iand(mt(0),LOWER_MASK))
       mt(kk)=ieor(ieor(mt(M-1),ishft(y,-1)),mag01(iand(y,1)))
       mti=0
    end if

    y=mt(mti)
    mti=mti+1

    y=ieor(y,ishft(y,-11))
    y=ieor(y,iand(ishft(y,7),T1_MASK))
    y=ieor(y,iand(ishft(y,15),T2_MASK))
    y=ieor(y,ishft(y,-18))

    if(y.lt.0.E0_dp) then
       random=dble(y)+2.E0_dp**32
    else
       random=dble(y)
    end if
! Divide by 2^32-1, for [0,1]-real-interval
!    random=random/4294967295.E0_dp
! Divide by 2^32, for [0,1)-real-interval
    random=random/4294967296.E0_dp
    return
  end function random

!> \brief Generate random vector of length 1 on unit spheres
!>
!> \see http://mathworld.wolfram.com/SpherePointPicking.html for further explanations
!> \see P349 of Allen & Tildesley: G.4 Random vectors on the surface of a sphere
  subroutine sphere(x,y,z,iStream)
    real,intent(out)::x,y,z
    integer,intent(in)::iStream

#ifdef RANDOM_SPHERE_DIRECT
    real::theta,phi
    theta=twopi*random(iStream)
    z=2.0_dp*random(iStream)-1.0_dp
    phi=acos(z)
    x=sin(phi)*cos(theta)
    y=sin(phi)*sin(theta)
#else
    integer::ii
    real::xi1,xi2,xisq
    do ii = 1,100
       xi1 = ( 2.0E0_dp * random(iStream) ) - 1.0E0_dp
       xi2 = ( 2.0E0_dp * random(iStream) ) - 1.0E0_dp
       xisq = xi1**2 + xi2**2
       if ( xisq .lt. 1.0E0_dp ) then
          x = 2.0E0_dp * xi1 * sqrt( 1.0E0_dp - xisq )
          y = 2.0E0_dp * xi2 * sqrt( 1.0E0_dp - xisq )
          z = ( 1.0E0_dp - 2.0E0_dp * xisq )
          return
       end if
    end do
    call err_exit(__FILE__,__LINE__,'exceeded 100 tries to get a vector in sphere',-1)
#endif
  end subroutine sphere

!> \brief Generate a normal deviate
!>
!> \param mu mean
!> \param sig standard deviation
!>
!> Leva's ratio-of-uniforms method; \see $7.3.9 of Numerical Recipes (3rd ed.)
!> \note The algorithms in P347 of Allen & Tildesley, G.4 Generating non-uniform
!> distributions, are inferior in either speed, accuracy, or both
  function gaussian(mu,sig,iStream) result(gau)
    real,intent(in)::mu,sig
    integer,intent(in)::iStream
    real::gau

    real::u,v,x,y,q

    do
       u=random(iStream)
       v=1.7156_dp*(random(iStream)-0.5_dp)
       x=u-0.449871_dp
       y=abs(v)+0.386595_dp
       q=x*x+y*(0.19600_dp*y-0.25472_dp*x)
       if (q.le.0.27597) exit
       if (q.le.0.27846 .and. v*v.le.-4.0_dp*log(u)*u*u) exit
    end do
    gau=mu+sig*v/u
  end function gaussian

!> \brief Generate a random rotational matrix
!> Uses a four-dimentional unit vector to create the matrix.
!> \see F. J. Vesely, J. Comp. Phys, 47, 291-296 (1982).
  subroutine rotmat(mat, iStream)
    integer, intent(in) :: iStream
    
    real :: l, u, v, r, s, s1, s2
    real :: l2, u2, v2, r2, lu, lv, lr, uv, ur, vr

    real, intent(out) :: mat(3, 3)

    ! Create a 4D unit vector (l, u, v, r)
    do
      l = 2.0E0_dp * random(iStream) - 1.0E0_dp
      u = 2.0E0_dp * random(iStream) - 1.0E0_dp
      s1 = l * l + u * u
      if (s1 .lt. 1.0E0_dp) exit
    end do
    do
      v = 2.0E0_dp * random(iStream) - 1.0E0_dp
      r = 2.0E0_dp * random(iStream) - 1.0E0_dp
      s2 = v * v + r * r
      if (s2 .lt. 1.0E0_dp) exit
    end do
    s = sqrt((1.0E0_dp - s1) / s2)
    v = v * s
    r = r * s
    ! constuct the rotation matrix
    l2 = l * l
    u2 = u * u
    v2 = v * v
    r2 = r * r
    lu = l * u
    lv = l * v
    lr = l * r
    uv = u * v
    ur = u * r
    vr = v * r
    mat(1, 1) = l2 - u2 - v2 + r2
    mat(1, 2) = 2.0E0_dp * (lu - vr)
    mat(1, 3) = 2.0E0_dp * (lv + ur)
    mat(2, 1) = 2.0E0_dp * (lu + vr)
    mat(2, 2) = u2 - v2 - l2 + r2
    mat(2, 3) = 2.0E0_dp * (uv - lr)
    mat(3, 1) = 2.0E0_dp * (lv - ur)
    mat(3, 2) = 2.0E0_dp * (uv + lr)
    mat(3, 3) = v2 - l2 - u2 + r2
  end subroutine rotmat
end module util_random
