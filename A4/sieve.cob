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
01  runTimes.
    03  startDateTime.
        10 startDate.              
            15 startYear  pic  9(4).
            15 startMonth pic  9(2).
            15 startDay   pic  9(2).
        10 startTime.              
            15 startHour  pic  9(2).
            15 startMin   pic  9(2).
            15 startSec   pic  9(2).
            15 startMs    pic  9(2).
    03 endDateTime.
        10 endDate.              
            15 endYear  pic  9(4).
            15 endMonth pic  9(2).
            15 endDay   pic  9(2).
        10 endTime.              
            15 endHour  pic  9(2).
            15 endMin   pic  9(2).
            15 endSec   pic  9(2).
            15 endMs    pic  9(2).
    03 startMilliseconds pic 9(08).
    03 endMilliseconds   pic 9(08).
    03 numMs             pic 9(08).
    03 formattedMs       pic z(06). 


procedure division.
    display "------------------------------------"
    display "  Sieve of Erotasthenes Algorithm   "
    display "        (Written in COBOL)          "
    display "------------------------------------"
    display "Enter a upper limit of primes: " with no advancing
    accept max.

    set isPrime(1) to FALSE

    *> Start time
    move function current-date to startDateTime.

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

    *> End time
    move function current-date to endDateTime.
    
    *> Calculating run time of program
    perform computeRuntime.

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

    stop run.

computeRuntime.

    compute startMilliseconds = (startHour * 3600000) 
                + (startMin * 60000) 
                + (startSec * 1000)
                + startMs.
    compute endMilliseconds = (endHour * 3600000) 
                + (endMin * 60000) 
                + (endSec * 1000)
                + endMs.
    
    compute numMs = (endMilliseconds - startMilliseconds).
    move numMs to formattedMs.
    display "Time taken: ", formattedMs, " milliseconds".

