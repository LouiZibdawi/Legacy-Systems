// Assignment 4, C - CIS3190 
//
// Author: Loui Zibdawi
//
// Find all prime numbers below a certain, user entered, max
// 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>
     
int main(int argc, char** argv) {

    clock_t start, end;
    double timeUsed;
    int max, i, j;

    printf("------------------------------------\n");
    printf("  Sieve of Erotasthenes Algorithm   \n");
    printf("           (Written in C)           \n");
    printf("------------------------------------\n");
    
    printf("Enter a upper limit of primes: ");
    scanf("%d", &max);

    bool prime[max + 1];
    memset(prime, true, sizeof(prime));
    
    start = clock();

    // Loop through all numbers less than sqrt of max 
    for (i = 2; i * i <= max; i++) {
        // If they are prime set all their multiplies to false (not prime)
        if (prime[i] == true) {
            for (j = i*2; j <= max; j += i) {
                prime[j] = false;
            }                
        }
    }

    // Printing how long the algorithm took
    end = clock();
    timeUsed = ((double) (end - start)) / CLOCKS_PER_SEC;      
    printf("Time taken: %lf milliseconds\n", timeUsed*1000);

    //Opem file to write to
    FILE* filePtr = fopen("sieve-c.txt", "w");
    if (filePtr == NULL) {
        puts("Failed to write to file");
        return -1;
    }

    // Loop through again and print out all prime numbers
    for (i = 2; i <= max; i++) {
        if (prime[i] == true) {
            fprintf(filePtr, "%d%c\n", i, ' ');
        }          
    }
    printf("\n");
    fclose(filePtr);  

    return 0;
} 