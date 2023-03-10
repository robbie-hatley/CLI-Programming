/************************************************************************************\
 * Program:        eratosthenes
 * source file:    eratosthenes.c
 * exe file (lin): eratosthenes
 * exe file (win): eratosthenes.exe
 * Description:    Prints all prime numbers in range [a,b].
 * Author:         Robbie Hatley
 * Edit History:
 * Wed Mar 08, 2023: Wrote it.
 * Thu Mar 09, 2023: Changed to using "MonoTime" to time.
 * Fri Mar 10, 2023: Changed to using bitmap and achieved MASSIVE speed increase!!!
\************************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>

// Get 1ns-resolution time in seconds since an arbitrary epoch which is not
// effected by system time changes, as a double, for timing things (valid for
// durations only; is NOT based on calendar/clock time):
double MonoTime (void)
{
   struct timespec t;
   clock_gettime(CLOCK_MONOTONIC, &t);
   return (double)t.tv_sec + (double)t.tv_nsec / 1000000000.0;
}

// Set a bit in a uint64_t-based bitmap:
void setbit (uint64_t * map, int idx)
{
   map[idx/64] = map[idx/64] | (1UL<<(idx%64));
}

// Get a bit in a uint64_t-based bitmap:
int getbit (uint64_t * map, int idx)
{
   if ( map[idx/64] & (1UL<<(idx%64)) ) {return 1;}
   else                                 {return 0;}
}

int main ( int Beren , char **Luthien )
{
   // Declare and initialize all variables used in main() here:
   uint64_t *  Fred    = NULL    ; // Map of composites.
   int         n       = 1000000 ; // Find primes through this number.
   int         asize   = 0       ; // Array size.
   int         esize   = 64      ; // Our bitmap uses 64-bit chunks.
   int         limit   = 0       ; // Stop looking past limit.
   int         count   = 1       ; // Primes found. (2 is prime.)
   int         i       = 0       ; // Outer index.
   int         j       = 0       ; // Inner index.
   double      start   = 0.0     ; // Start time.

   // Capture start time:
   start = MonoTime();
   
   // If we have arguments, use first argument as n ("top" number):
   if (Beren > 1){
      n = (size_t)strtoul(Luthien[1],NULL,10);
   }

   // But if n is now < 11 or > 1 billion, revert n back to 1 million:
   if ( n < 11 || n > 1000000000 ){
      printf("Error: n is out-of-range; defaulting to 1 million.\n");
      n = 1000000;
   }

   // Announce n:
   printf("Searching for primes in range [0,%lu].\n", n);

   // Array must be big enough to contain n+1 bits, due to needing to contain 0:
   asize = (int)ceil((n+1)/64.0);

   // Our composite-map elements are unsigned char to save space:
   Fred = calloc(asize, esize);

   // No sense looking past sqrt(n):
   limit = (int)sqrt((double)n);

   // DON'T EVEN BOTHER marking the even numbers as "composite", as we won't
   // even be looking at them; instead, mark multiples of odd numbers 3+ only:
   for ( i = 3 ; i <= limit ; i+=2 ){
      if ( !getbit(Fred,i) ){
         for ( j = i*i ; j <= n ; j+=i ){
            setbit(Fred,j);
         }
      }
   }

   // Count the prime numbers we've found:
   for ( i = 3 ; i <= n ; i+=2 ){ 
      if ( !getbit(Fred,i) ){
         ++count;
      }
   }

   // Free dynamically-allocated memory:
   free(Fred);
   
   // Print results:
   printf("Found %lu primes in %.9f seconds.\n", count, MonoTime() - start);

   // Computer, end program.
   return 0;
}
