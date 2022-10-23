// first-n-primes-reel.c
// Finds first n prime number by using a wheel instead of by using an array.
// Runs faster than "first-n-primes-table.c" and uses much less memory.

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <sys/time.h>
#include <errno.h>
#include <error.h>

// First four prime numbers:
const uint64_t FirstFour[4] = {2,3,5,7};

// Prime Wheel of Order 4 (2*3*5*7=210):
const uint64_t Wheel[48] =
{
     1,  11,  13,  17,  19,  23,  29,  31,  37,  41,
    43,  47,  53,  59,  61,  67,  71,  73,  79,  83,
    89,  97, 101, 103, 107, 109, 113, 121, 127, 131,
   137, 139, 143, 149, 151, 157, 163, 167, 169, 173,
   179, 181, 187, 191, 193, 197, 199, 209
};

// IsPrime()
// Returns true if n is prime, false if n is composite, WITHOUT having to first
// generate a table of all prime numbers not greater than the square root of n.
bool IsPrime (uint64_t n)
{
   uint64_t  i       ; // Divisor index.
   uint64_t  spoke   ; // Wheel spoke.
   uint64_t  row     ; // Wheel row.
   uint64_t  divisor ; // Divisor.
            uint64_t  limit   ; // Upper limit for divisors to try.

   // Check to see if n is one of the first 4 prime numbers:
// if (2==n||3==n||5==n||7==n) return true;

   // If n is divisible by any of the first 4 prime numbers, n is composite:
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return false;

   // Set limit to the greatest integer not greater than the square root of n:
   limit = (uint64_t)sqrt((double)n);

   // Only bother testing divisors which are on the prime spokes, because only they could possibly be 
   // prime numbers. Note that we start with i = 1 to avoid divisor 1, which ALL integers are divisible by;
   // instead, we start with divisor 210*0+Wheel[1], which is 11:
   for ( i = 1 ; ; ++i )
   {
      spoke   = i%48; // Modulo 48.
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      divisor = 210*row + Wheel[spoke];
      if (divisor > limit) return true;
      if (!(n%divisor)) return false;
   }
} // end IsPrime()

/* Get high-resolution time (time in seconds, to nearest microsecond, since
00:00:00 on the morning of Jan 1, 1970) as double (for timing things): */
double HiResTime (void)
{
   struct timeval t;
   gettimeofday(&t, NULL);
   return (double)t.tv_sec + (double)t.tv_usec / 1000000.0;
}

int main (int Beren, char * Luthien[])
{
   uint64_t  c       = 0;     // candidate prime
   uint64_t           pc      = 0;     // prime count
   uint64_t           n       = 0;     // number of primes to generate
   double             t0      = 0.0;   // time zero

   t0 = HiResTime();

   // If number of arguments is wrong, print error and exit:
   if (2 != Beren)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: \"first-n-primes-wheel\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Get number of primes:
   n = strtoul(Luthien[1], NULL, 10);

   // Don't generate < 1 or > 100 billion primes:
   if (n < 1 || n > 100000000000)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: input is out-of-range.\n"
         "\"first-n-primes-wheel\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Serve 2,3,5,7 manually:
   for ( pc = 0 ; pc < 4 && pc < n ; ++pc )
   {
      printf("%lu\n", FirstFour[pc]);
   }

   // Generate and print remaining requested primes:
   for ( c = 9 ; ; )
   {
      c += 2;                // 11, 21, 31...
      if (IsPrime(c))
      {
         printf("%lu\n", c);
         ++pc;
         if (pc >= n) break;
      }
      c += 2;                // 13, 23, 33...
      if (IsPrime(c))
      {
         printf("%lu\n", c);
         ++pc;
         if (pc >= n) break;
      }
      c += 4;                // 17, 27, 37...
      if (IsPrime(c))
      {
         printf("%lu\n", c);
         ++pc;
         if (pc >= n) break;
      }
      c += 2;                // 19, 29, 39...
      if (IsPrime(c))
      {
         printf("%lu\n", c);
         ++pc;
         if (pc >= n) break;
      }
   } // end for each candidate

   fprintf(stderr, "Elapsed time = %f\n", HiResTime() - t0);

   // We're done, so scram:
   exit(EXIT_SUCCESS);
}
