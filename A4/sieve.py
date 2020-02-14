#!/usr/bin/env python3
# Assignment 4, Python - CIS3190 
#
# Author: Loui Zibdawi
#
# Find all prime numbers below a certain, user entered, max

import sys
import math
import time

def findPrimes(max):

    isPrime = [False] * 2 + [True] * (max - 1)

    start_time = time.time()

    # Loop through all numbers less than sqrt of max 
    for n in range(2, int(math.sqrt(max))):
        # If they are prime set all their multiplies to false (not prime)
        if isPrime[n]:
            for i in range(n * n, max + 1, n): # start at ``n`` squared
                isPrime[i] = False

    # Printing how long the algorithm took
    print("Time taken: %s milliseconds" % ((time.time() - start_time)*1000))

    # Opening the file to write to
    fPtr = open("sieve-py.txt", "w")

    # Loop through again and print out all prime numbers
    for i in range(2, max):
        if isPrime[i]:
            fPtr.write(str(i) + "\n")
    
    fPtr.close()

if __name__ == "__main__":
    print("------------------------------------")
    print("  Sieve of Erotasthenes Algorithm   ")
    print("        (Written in Python)         ")
    print("------------------------------------")
    
    print("Enter a upper limit of primes: ")
    max = input()

    findPrimes(max)
