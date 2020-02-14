*> assignment 4, cobol - cis3190 
*> 
*> author: loui zibdawi
*> 
*> find all prime numbers below a certain, user entered, max
*> 

identification division.
program-id. sieve-of-eratosthenes.

environment division. 
input-output section.
file-control.
select optional dataFile assign to "sieve-cob.txt"
        organization is line sequential.

data division.
file section.
fd dataFile.
    01  rec.
        03  num  pic z(8).

working-storage section.
77  max  pic 9(8).
77  j    pic 9(8).
77  i    pic 9(8).
77  cur  pic 9(8).
01  num-group.
    03  num-table pic x value "t"
            occurs 1 to 10000000 times depending on max
            indexed by num-index.
        88  isPrime value "t" false "f".

procedure division.
    move 100000 to max
    set isPrime(1) to FALSE

    *> Loop through all numbers less than sqrt of max 
    perform varying i from 2 by 1 until i*i > max
        *> If they are prime set all their multiplies to false (not prime)
        if isPrime(i)
            compute cur = i * 2
            perform varying j from cur by i until j > max
                set isPrime(j) to FALSE
            end-perform
        end-if
    end-perform.

    *> Opening output file
    open output dataFile.

    *> Loop through again and print out all prime numbers
    perform varying i from 1 by 1 until i > max
        if isPrime(i)
            move i to num
            *> Writing record to output file
            write rec
        end-if
    end-perform.

    close dataFile.
