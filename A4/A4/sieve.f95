! Assignment 4, Fortran - CIS3190 
!
! Author: Loui Zibdawi
!
! Find all prime numbers below a certain, user entered, max
!
program sieve
    implicit none
    integer :: i, j, max
    logical, dimension (:), allocatable :: isPrime
    real :: start,end

    write (*,*) ' '
    write (*,*) '------------------------------------'
    write (*,*) '   Sieve of Erotasthenes Algorithm  '
    write (*,*) '        (Written in Fortran)        '
    write (*,*) '------------------------------------'
    write(*,*) 'Enter a upper limit of primes: '
    read(*,*) max

    call CPU_TIME(start)
    allocate (isPrime(max))   
 
    ! Set the whole array to true
    isPrime = .true.
    ! Set the first value to false
    isPrime (1) = .false.

    ! Loop through all numbers less than sqrt of max 
    do i = 2, int(sqrt (real(max))), 1
        ! If they are prime set all their multiplies to false (not prime)
        if (isPrime (i)) then
            do j = i*2, max, i
                isPrime (j) = .false.
            end do
        end if
    end do

    ! Printing how long the algorithm took
    call CPU_TIME(end)
    write(*,*) 'Time taken: ', (end-start) * 1000, 'ms'

    ! Opening file
    open(1, file='sieve-f95.txt')  
    ! Loop through again and print out all prime numbers
    do i = 1, max, 1
        if (isPrime (i)) then
            write (1, '(i0, 1x)') i
        end if
    end do
    write (*, *)

    deallocate(isPrime)
    close(1)

end program sieve