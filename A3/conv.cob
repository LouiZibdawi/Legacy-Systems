*> Assignment 3 - CIS3190 
*> 
*> Author: Loui Zibdawi
*> 
*> Gets passed in a string that represents a roman numerial and it computes 
*> it's numeric value.
identification division.
program-id. conv.
environment division.
input-output section.
data division.

*> Section for variables used in the program
working-storage section.
77  i       pic 99 value 1.
77  prev    pic 9(8) value 1001.
77  temp    pic 9(4).
77  error-mess pic x(22) value ' illegal roman numeral'.

*> Section for arguments being passed in
linkage section.
77  len     pic 99.
77  val     pic 9(8).
01  str.
    02 char pic x(1) occurs 30 times.

*> Main procedure
*>
*> This procedure calls evalChar to evalute characters one at a time
*>
*> Parameters
*>      str - string representing the roman numerial
*>      val - Numeric value of roman numerial string
procedure division using str, val.
    
    move 1001 to prev.
    move 1 to i.
    perform evalChar until str(i:1) = " ".
    goback.

*> evalChar
*>
*> This subroutine looks at a single character in the string and gets it's
*> numerical value and then calls addOrSubtract to decide what to do with 
*> the value
evalChar.
    evaluate str(i:1)
        when 'i'
            move 1 to temp
        when 'v'
            move 5 to temp
        when 'x'
            move 10 to temp
        when 'l' 
            move 50 to temp
        when 'c'
            move 100 to temp
        when 'd'
            move 500 to temp
        when 'm'
            move 1000 to temp
    end-evaluate.

    perform addOrSubtract.
    compute i = i + 1.

*> addOrSubstract
*>
*> This subroutine looks at the current temp value and decides whether to
*> add it to the total (val) depending on if it is greater than prev or not
addOrSubtract.
    compute val = val + temp.
    if temp is greater than prev
        compute val = val - (2 * prev)
    end-if.

    move temp to prev.
