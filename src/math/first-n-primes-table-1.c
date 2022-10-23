// first-n-primes-table-1.c
// Finds first n prime numbers and stores them in an array.
// Runs slower than non-array versions, but provides quick lookup.

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <sys/time.h>
#include <errno.h>
#include <error.h>

#include <rhdefines.h>
#include <rhmathc.h>
#include <rhutilc.h>

int main (int Beren, char * Luthien[])
{
   unsigned long   c      = 0;     // candidate prime
   unsigned long   i      = 0;     // iterator
   unsigned long   j      = 0;     // test divisor
   unsigned long   n      = 0;     // number of primes
   char          * tail   = NULL;  // pointer to first non-numeric character
   unsigned long * primes = NULL;  // prime number array
   unsigned long   size   = 0;     // size of array
   unsigned long   s      = 0;     // integer sqrt of c
   bool            f      = false; // composite flag
   double          t0     = 0.0;   // time zero

   t0 = HiResTime();

   // If number of arguments is wrong, print error and exit:
   if (2 != Beren)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: \"first-n-primes\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 4 billion inclusive.\n"
      );

   // Get number of primes:
   n = strtoul(Luthien[1], &tail, 10);

   // Reject gibberish:
   if (0 != strlen(tail))
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: extra characters in input.\n"
         "\"first-n-primes\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 4 billion inclusive.\n"
      );

   // Don't generate < 1 or > 4 billion primes:
   if (n < 1 || n > 4000000000)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: input is out-of-range.\n"
         "\"first-n-primes\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 4 billion inclusive.\n"
      );

   // Attempt to allocate memory for table of prime numbers,
   // with safety margin of 10; abort if allocation fails:
   size = n + 10;
   errno = 0;
   primes = malloc(size*sizeof(unsigned long));
   if (NULL == primes)
      error(EXIT_FAILURE, errno, "Error: out of memory");
   
   // Set first prime to 2, and print it, manually:
   primes[0] = 2;
   printf("%lu\n", 2LU); // print 2

   // Generate and print remaining requested primes:
   for ( c = 3 , i = 1 ; i < n ; c+=2 )
   {
      f = false; // tentatively assume not composite
      s = IntSqrt(c); // limit for test divisor
      // Use primes up-to-and-including s as test divisors:
      for ( j = 0 ; primes[j] <= s ; ++j )
      {
         if (0 == c%primes[j])
         {
            f = true;
            break;
         }
      }
      if (!f) // if not composite (ie, if prime)
      {
         printf("%lu\n", c); // print candidate
         primes[i] = c;      // store candidate
         ++i;                // increment index
      }
   } // end for each candidate

   fprintf(stderr, "Elapsed time = %f\n", HiResTime() - t0);

   // We're done, so scram:
   exit(EXIT_SUCCESS);
}
