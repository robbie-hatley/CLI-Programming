// This is a 79-character-wide ASCII C source-code text file.
//=======|=========|=========|=========|=========|=========|=========|=========

/************************************************************************************************************\
 * Program name:  Hatley Primes
 * Description:   Finds prime numbers of the form 30^n-1. Numbers of that form should contain a lot of primes,
 *                because 30 is the product of the first 3 primes. 
 * File name:     hatley-primes.c
 * Source for:    hatley-primes.exe
 * Inputs:        
 * Outputs:       
 * Notes:
 * To make:       
 * Author:        Robbie Hatley
 * Edit history:
 *    Sun Feb 21, 2021: Wrote it.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#include "rhdefines.h"
#include "rhutilc.h"
#include "rhmathc.h"

int main (void)
{
   double   t0         = 0; // Entry time.
   unsigned n          = 0; // exponent for 30
   uint64_t candidate  = 0; // Candidate for primeness.
   bool     isprime    = 0; // Is 30^n-1 prime?

   t0 = HiResTime();

   for ( n = 1 ; n < 15 ; ++n )
   {
      candidate = IntPow(30, n) - 1;
      isprime = IsPrime(candidate);
      printf("Candidate %30ld", candidate);
      isprime ? printf(" is prime.\n")
              : printf(" is composite.\n");
   }

   printf("Elapsed time = %f seconds.\n", HiResTime() - t0);
   return 0;
}
