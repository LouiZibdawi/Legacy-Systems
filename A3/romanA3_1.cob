*> Assignment 3 - CIS3190 
*> 
*> Author: Loui Zibdawi
*> 
*> Asks the user to enter roman numerial, or a file with roman numerials and 
*> it calls a function to convert them into their numerical value and then
*> displays the returned value to the screen
*> 
identification division.
program-id. romannumerals.

environment division.

input-output section.
file-control.
*> Current input file variable, depending on a dynamic name entered by the user
select input-file assign to dynamic fname 
    organization is line sequential.

data division.
file section.
*> Input file array of strings of 20 characters
fd input-file.
    01 file-array.
        03 char pic x(1) occurs 20 times.

*> Section for variables used in the program
working-storage section.
77  fname       pic x(30).
77  option      pic 99.
77  eof-switch  pic 9 value 1.
77  validStr    pic 9 value 0.
77  val         pic 9(8) value 0.
77  i           pic 99 value 1.
01  temp-array.
    03 char     pic x(1) occurs 20 times.
01  str-array.
    03 char     pic x(1) occurs 20 times.

*> Main procedure
*>
*> This procedure calls the getOption menu forever. The program ends when
*> the user enters '3' in that option menu
procedure division.
    display "--------------------------------------------".
    display "         Roman Numerial Equivalents         ".
    display "--------------------------------------------".

    perform getOption forever.

    stop run.

*> getOption
*>
*> This subroutine will display a menu to the user and call other subroutines
*> according to what the user enters. It alsos checks for valid input
getOption.
    display " ".
    display "Select an option:".
    display "(1) Read From a File".
    display "(2) Enter Roman Numerials".
    display "(3) Quit".
    accept option.

    evaluate option
        when 1 perform fileInput
        when 2 perform userInput
        when 3 stop run
        when other display "Invalid input"
    end-evaluate.

*> fileInput
*>
*> This subroutine gets a filename from the user, opens the file and calls
*> computation to parse the file
fileInput.
    display "Filename? ".
    accept fname.
    
    open input input-file.

    display "--------------------------------------------".
    display "      Roman Number         Dec. Equivalent  ".
    display "----------------------    ------------------".

    move 1 to eof-switch.
    perform computation until eof-switch = 0.
    close input-file.

*> computation
*>
*> This subroutine gets parses a file and takes each record (single string on a line) 
*> and converts it to lowercase, checks if its a valid roman numerial and if it is 
*> then it calls conv from conv.cob to convert it to it's numeric value. Finally it 
*> prints out the input and corresponding value
computation.
    read input-file into file-array
        at end move zero to eof-switch
    end-read.
    if eof-switch is not = 0
        move 0 to val
        inspect file-array converting "ABCDEFGHIJKLMNOPQRSTUVWXYZ" to "abcdefghijklmnopqrstuvqxyz" 
        move file-array to temp-array
        perform checkValidStr

        if validStr = 1
            call "conv" using temp-array, val
            display "          ", temp-array, val
        else
            display function trim(temp-array trailing), " is not a valid roman numerial"
        end-if
    end-if.

*> userInput
*>
*> This subroutine gets users input, converts it to lowercase, checks if it
*> is a valid roman numerial and if it is then it calls conv from conv.cob 
*> to convert it to it's numeric value. Finally it prints out the input and 
*> corresponding value
userInput.
    display "Enter Roman Numerial:"
    accept str-array.

    inspect str-array converting "ABCDEFGHIJKLMNOPQRSTUVWXYZ" to "abcdefghijklmnopqrstuvqxyz". 
    move str-array to temp-array.
    perform checkValidStr.

    if validStr = 1 then
        move 0 to val
        call "conv" using temp-array, val

        display "         Roman Numerial Equivalents         "
        display "--------------------------------------------"
        display "      Roman Number         Dec. Equivalent  "
        display "----------------------    ------------------"
        display "          ", temp-array, val
    else 
        display "Invalid roman numerial"
    end-if.

*> checkValidStr
*>
*> This subroutine checks if the current temp-array is a valid roman numerial.
*> If it is, it moves 1 into validStr and if not, 0.
checkValidStr.
    move 1 to i.
    move 1 to validStr.

    perform until temp-array(i:1) = " "
        if (temp-array(i:1) is not = 'i' and 'v' and 'x' and 'l' and 'c' and 'd' and 'm') then
            move 0 to validStr
        end-if
        compute i = i + 1
    end-perform.
