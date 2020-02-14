-- Assignment 4, Ada - CIS3190 
--
-- Author: Loui Zibdawi
--
-- Find all prime numbers below a certain, user entered, max
--

with ada.text_IO; use Ada.text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Calendar; use Ada.Calendar;

procedure sieve is
    str : unbounded_string;
    max, j : integer;
    i : integer := 2;
    ms : Duration;
    fPtr : file_type;
    startTime, endTime : Time;
begin

    put_line("------------------------------------");
    put_line("  Sieve of Erotasthenes Algorithm   ");
    put_line("          (Written in Ada)          ");
    put_line("------------------------------------");
    
    put_line("Enter a upper limit of primes: ");
    get_line(str);

    max := Integer'Value(To_String(str));

    declare
        isPrime: array(1 .. max) of Boolean := (1 => False, others => True);
    begin
        startTime := Clock;
        -- Loop through all numbers less than sqrt of max 
        while i*i < max loop
            -- If they are prime set all their multiplies to false (not prime)
            if isPrime(i) then
                j := i*2;
                while j <= max loop
                    isPrime(j) := False;
                    j := j+i;
                end loop;
            end if;
            i := i+1;
        end loop;

        -- Printing how long the algorithm took
        endTime := Clock;
        ms := (endTime - startTime) * 1000;
        
        put_line("Time taken: " & Duration'Image(ms) & " milliseconds");

        -- Opening file
        create(fPtr,out_file,"sieve-adb.txt"); 

        -- Loop through again and print out all prime numbers
        for i in IsPrime'Range loop
            if (isPrime(i)) then
                put_line(fPtr, Integer'Image(i));
            end if;
        end loop;

    end;
end sieve;