/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*
"goldbach.c"
Searches for counterexamples to Goldbach's Conjecture.
Goldbach wrote to Euler, "Seems to me that any odd number could be
expressed as the sum of three prime numbers. However, I do not
immediately see a proof of this."  A stronger version of this conjecture
is that every even number greater than 2 is the sum of two prime numbers.
This latter form is what most people refer to as "Goldbach's Conjecture".
Written by Robbie Hatley on 2000-05-25.
Edit history:
  Mon Oct 16, 2017: Removed spurious "extern" re-declarations of array C.
  Thu Feb 15, 2018: Included routines from my new C library.
  Tue Feb 20, 2018: Fixed major bug which was completely invalidating this 
                    program: 
                    IsPrime(p1) || IsPrime(p2) instead of
                    IsPrime(p1) && IsPrime(p2).
                    Must check for instances when BOTH are prime,
                    then look for i such that NEITHER partition is prime.
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NDEBUG
#include <assert.h>

#include "rhmathc.h"


/* Find exceptions to Goldbach's conjecture: */
int IsGoldbachException(unsigned long i)
{
   unsigned long h, p1, p2;

   /* Numbers under four aren't involved in the conjecture: */
   if (i<4) return 0;

   /* Four is the only even number which is the sum of two even primes */
   if (i==4) return 0;

   /* Odd numbers aren't involved in the conjecture: */
   if (i%2) return 0;

   /* h is greatest integer <= half i */
   h=i/2;

   /* Partition i into two partitions, P1 and P2, with P1 starting at 3 and
   increasing by 2s up to a limit of half i:  */
   p1 = 3;
   p2 = i - p1;

   /* For each partitioning, is this a sum of primes? If so, i is NOT an 
   exception to Goldbach's conjecture, so return 0. Otherwise, if we exit the
   bottom of the loop without finding a sum of primes adding to i, then i is
   an exception to Goldbach's conjecture, so return 1. */
   while (p1<=h)
   {
      assert(p1 + p2 == i);           /* Assert that p1 and p2 partition i. */
      if (IsPrime(p1) && IsPrime(p2)) /* Is this partitioning a sum of primes? */
      {
         return 0;                    /* If so, i is not a Goldbach exception. */
      }
      p1 += 2;                        /* Increment p1 */
      p2 = i - p1;                    /* Decrement p2 */
   }                                  /* Loop. */
   /* If we get to here, i is a Goldbach exception: */
   return 1;
}

int main (int Mary, char ** David)
{
   unsigned long  i           = 0;
   unsigned long  GOLD_LIMIT  = 1000000;
   int            exceptions  = 0;

   if (Mary >= 2) GOLD_LIMIT = strtoul(David[1], NULL, 10);

   for ( i = 4 ; i <= GOLD_LIMIT ; i += 2 )
   {
      if (IsGoldbachException(i))
      {
         ++exceptions;
         printf("%ld is an exception to Goldbach\'s conjecture.\n", i);
      }
   }
   printf("Checked Goldbach\'s conjecture through %ld.\n", GOLD_LIMIT);
   printf("Found %d exceptions.\n", exceptions);
   return 0;
}
