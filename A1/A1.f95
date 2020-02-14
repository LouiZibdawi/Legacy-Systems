! Assignment 1 - CIS3190 
!
! Author: Loui Zibdawi
!
! Tic-Tac-Toe game where user plays again "AI" computer that makes decisions based on
! either a winning move, block move or random number if there is no other
!
program A1
    write (*,*) ' '
    write (*,*) 'PLAY TIC-TAC-TOE. ENTER 1-9 TO PLAY'
    write (*,*) ' '
    write (*,*) '        1 | 2 | 3 '
    write (*,*) '       ---+---+---'
    write (*,*) '        4 | 5 | 6 '
    write (*,*) '       ---+---+---'
    write (*,*) '        7 | 8 | 9 '

    call playTicTacToe()

end program A1

! Runs the game and calls all subroutines. Checks for winner and ends game
!
! Important Local Variables
!   board - 9 character array for board data
!   choice - Users move (1-9)
!   compMove - Computers move (1-9)
!   winner ('X', 'O' or 'd')
!
subroutine playTicTacToe()
    implicit none

    ! Local Variables
    character (len=1), dimension(9) :: board
    integer :: choice, compMove
    logical :: gameOver
    character(len=1) :: winner

    ! Functions used
    integer, external :: getMove
    integer, external :: pickMove

    ! Sets the board to all spaces
    call initBoard(board)

    gameOver = .FALSE.
    do while(gameOver .neqv. .TRUE.)
        write(*,*) '+------------------+'
        write(*,*) '|    Your turn...  |'    
        write(*,*) '+------------------+'
        ! Get users move
        choice = getMove(board)

        ! Placing the users play on the board and show it
        call updateBoard(board, choice, 'X')
        call showBoard(board) 
        call chkOver(board, gameOver, winner)

        if(gameOver .neqv. .TRUE.) then
            write(*,*) '+------------------+'
            write(*,*) '| After my turn... |'
            write(*,*) '+------------------+'
            ! Getting computers move
            compMove = pickMove(board)

            ! Placing the users play on the board and show it
            call updateBoard(board, compMove, 'O')
            call showBoard(board) 
            call chkOver(board, gameOver, winner)
        end if
    end do
    ! Now that the game is over, check who won or if it was a tie
    if(winner == 'X') then
        write(*,*) 'GAME OVER: YOU WIN!!'
    else if(Winner == 'O') then
        write(*,*) 'GAME OVER: The computer wins :('
    else 
        write(*,*) 'GAME OVER: It was a tie!'
    end if

end subroutine playTicTacToe

subroutine initBoard(board)

    character(len=1),dimension(9),intent(out) :: board
    integer :: i

    do i = 1, 9, 1
        board(i) = ' '    
    end do

end subroutine initBoard

! Gets valid user input for their next move
!
! Input Arguments
!   board - 9 character array for board data
! Returns
!   integer for move
!
integer function getMove(board)
    implicit none

    ! Parameters
    character(len=1), dimension(9), intent(in) :: board
    
    ! Local Variables
    logical :: valid
    integer :: choice, ierror

    ! Functions used
    logical, external :: chkPlay

    valid = .FALSE.
    ! Loop unit a valid play is made
    do while(valid .neqv. .TRUE.)
        
        ! Get user input
        write(*,*) 'Enter a valid number between 1-9: '
        read(*,'(i10)',iostat=ierror) choice

        ! Checks if the number entered is an int between 1-9
        if(choice < 1 .or. choice > 9) then
            valid = .FALSE.
            write(*,*) 'Input was not valid';
        else
            ! Checks to see if the spot on the board is empty
            valid = chkPlay(board, choice)

            if(valid .eqv. .FALSE.) then
                write(*,*) 'The spot you chose is taken';
            end if
        end if
    end do

    getMove = choice

end function getMove

! Checks if three parameters are the same
!
! Input Arguments
!   a, b, c - Three characters representing X, O or space
! Returns
!   Logical for whether or not they are all the same and not spaces
!
logical function same(a, b, c)
    implicit none
    ! Paratemers
    character(len=1), intent(in) :: a,b,c

    ! Checking if all parameters are equal
    if(a == b .and. a /= ' ') then
        if(b == c) then
            same = .TRUE. 
        else
            same = .FALSE.
        end if
    else 
        same = .FALSE.
    end if

end function same

! Checks if move on the board is valid
!
! Input Arguments
!   board - 9 character array for board data
!   move - index that the user wants to move to
! Returns
!   Logical for whether the play is valid or not
!
logical function chkPlay(board,move)
    implicit none
    ! Parameters
    character(len=1),dimension(9), intent(in) :: board
    integer, intent(in) :: move

    ! Checking if the spot on the board is empty
    if(board(move) == ' ') then
        chkPlay = .TRUE.
    else
        chkPlay = .FALSE.
    end if

end function

! Printing out the current board, given the board array
!
! Input Arguments
!   board - 9 character array for board data
!   index - Index of the move (1-9)
!   player - Who's turn it is. X or O
! Output Arguments
!   board - 9 character array for board data to be updated
!
subroutine updateBoard(board, index, player)
    character(len=1), dimension(9), intent(inout) :: board
    integer, intent(in) :: index
    character(len=1),intent(in) :: player

    if(player == 'X') then
        board(index) = 'X'
    else
        board(index) = 'O'
    end if

end subroutine updateBoard

! Printing out the current board, given the board array
!
! Input Arguments
!   board - 9 character array for board data
!
subroutine showBoard(board)
    implicit none

    character (len=1), dimension(9), intent(in) :: board
    integer :: i

    ! Loop through each row and draw board
    do i = 1, 9, 3
        write(*,*) '     ', board(i), ' | ', board(i+1), ' | ', board(i+2)
        if (i < 7) then
            write(*,*) '    ---+---+---'
        end if
    end do

end subroutine showBoard

! check if tic-tac-toe is over and determine winner (if any)
! 
! Input arguments
!   board - represents the current state of the board game
! Output arguments
!   over - indicates whether or not game is over
!   winner - indicates the winner (o or x) or a draw (d)
subroutine chkOver(board, over, winner)
    implicit none

    ! Parameters
    character (len=1), dimension(9), intent(in) :: board
    character (len=1), intent(out) :: winner
    logical, intent(out) :: over

    ! Functions used
    logical, external :: same

    ! Local variables
    logical :: dsame
    integer :: i
    character(len = 1) :: blank, draw

    ! Initialize local variables
    over = .true.
    blank = ' '
    draw = 'd'

    ! Check rows for a winner
    do i=1, 9, 3
        if (same(board(i), board(i+1), board(i+2))) then
            winner = board(i)
            return
        endif
    end do

    ! No winner by rows, check columns for a winner
    do i=1, 3, 1
        if (same(board(i), board(i+3), board(i+6))) then
            winner = board(i)
            return
        endif
    end do

    ! No winner by rows or columns, check diagonals for a winner   
    dsame = same(board(1), board(5), board(9)) .or. same(board(3), board(5), board(7))
     
    if (dsame) then
        winner = board(5)
        return
    end if

    ! No winner at all. see if game is a draw
    ! Check each row for an empty space
    do i = 1, 9, 1

     if(board(i) == ' ') then
        over = .FALSE.
        return
     end if

    end do
    
    ! No blank found, grame is a draw
    winner = draw
    
end subroutine chkOver

! Chooses the most appropriate move for the computer to make. 
! Win first, then block, then random
! 
! Input arguments
!   board - represents the current state of the board game
! Returns
!   integer for move
!
integer function pickMove(board)
    implicit none
    ! Paramaters
    character(len=1), dimension(9), intent(in) :: board

    ! Local Variables
    integer :: sum, move, i, r, values(1:8)
    real :: num
    logical :: valid
    ! Declare an assumed shape, dynamic array
    integer, dimension(:), allocatable :: seed

    ! Functions used
    integer, external :: getValue, randomNum
    logical, external :: chkPlay

    move = 0
    ! Check rows for winning spot and block
    do i=1, 9, 3
        sum = getValue(board(i)) + getValue(board(i+1)) + getValue(board(i+2))
        ! If there is a winning move
        if (sum == 8) then
            if(chkPlay(board,i)) then
                move = i
            else if (chkPlay(board, i+1)) then
                move = i+1
            else if (chkPlay(board, i+2)) then
                move = i+2
            end if
            pickMove = move
            return
        ! If there is a block
        else if (sum == 2) then
            if(chkPlay(board, i)) then
                move = i
            else if (chkPlay(board, i+1)) then
                move = i+1
            else if (chkPlay(board, i+2)) then
                move = i+2
            end if
        endif
    end do

    ! No winner in rows, check columns for a winning play and block
    do i= 1, 3, 1
        sum = getValue(board(i)) + getValue(board(i+3)) + getValue(board(i+6))
        ! If there is a winning move
        if (sum == 8) then
            if(chkPlay(board, i)) then
                move = i
            else if (chkPlay(board, i+3)) then
                move = i+3
            else if (chkPlay(board, i+6)) then
                move = i+6
            end if
            pickMove = move
            return
        ! If there is a block
        else if (sum == 2) then
            if(chkPlay(board,i)) then
                move = i
            else if (chkPlay(board, i+3)) then
                move = i+3
            else if (chkPlay(board, i+6)) then
                move = i+6
            end if
        endif
    end do

    ! No winner by rows or columns, check diagonals for a winner and block (1,5,9)
    sum = getValue(board(1)) + getValue(board(5)) + getValue(board(9))
    ! If there is a winning move
    if (sum == 8) then
        if(chkPlay(board, 1)) then
            move = 1
        else if (chkPlay(board, 5)) then
            move = 5
        else if (chkPlay(board, 9)) then
            move = 9
        end if
        pickMove = move
        return
    ! If there is a block
    else if (sum == 2) then
        if(chkPlay(board,1)) then
            move = 1
        else if (chkPlay(board, 5)) then
            move = 5
        else if (chkPlay(board, 9)) then
            move = 9
        end if
    endif

    ! Checking other diagonal (3,5,7)
    sum = getValue(board(3)) + getValue(board(5)) + getValue(board(7))
    ! If there is a winning move
    if (sum == 8) then
        if(chkPlay(board, 3)) then
            move = 3
        else if (chkPlay(board, 5)) then
            move = 5
        else if (chkPlay(board, 7)) then
            move = 7
        end if
        pickMove = move
        return
    ! If there is a block
    else if (sum == 2) then
        if(chkPlay(board,3)) then
            move = 3
        else if (chkPlay(board, 5)) then
            move = 5
        else if (chkPlay(board, 7)) then
            move = 7
        end if
    endif

    ! Seed random number generator
    call date_and_time(VALUES=values)
    call random_seed(size=r)
    allocate(seed(1:r))
    seed(:) = values(8)
    call random_seed(put=seed)

    ! If a block or win was found
    if(move /= 0) then
        write(*,*) 'Found block at: ', move
        pickMove = move
    else
        
        ! Set default valid to false
        valid = .FALSE.

        ! Looping unit valid random move is generated
        do while(valid .neqv. .TRUE.)

            ! Get random number
            call random_number(num)
            move = FLOOR(10 * num)

            write(*,*) 'Random num: ', move
    
            if(move < 10 .and. move > 0) then
                valid = .TRUE.
            end if
    
            if(chkPlay(board, move) .eqv. .FALSE.) then
                valid = .FALSE.
            end if
        end do
        
        write(*,*) 'Produced random number: ', move

        pickMove = move
    end if

end function pickMove
! Get value for character on board. 'X' = 1, 'O' = 4
!
! Input Arguments
! 9 character array for board data
! Returns
!   integer for value of character passed in
!
integer function getValue(user)
    implicit none
    ! Paramaters
    character(len=1), intent(in) :: user

    if(user == 'X') then
        getValue = 1
    else if(user == 'O') then
        getValue = 4
    else
        getValue = 0
    end if

end function getValue