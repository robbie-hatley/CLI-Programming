/*
Euler-060_Prime-Pair-Sets.c
Finds lowest-sum five-prime-pair set.
Written Tue Feb 13, 2018 by Robbie Hatley.
Heavily edited on Wed Feb 14, 2018. (Corrected many 
errors and problems which were causing run times to
bloat into weeks, and causing erroneous output.
Runtime is still about 1 day, but at least it works.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include "rhutilc.h"
#include "rhmathc.h"

typedef unsigned long UL;

/* Primes under 100,000: */
#include "Array-Of-9592-Primes-Under-100000.cism"

/* Return index of smallest prime not less than n, plus 1,
for use as limits in for() loops: */
int Limit (UL n)
{
   int i;
   for ( i = 0 ; i < PAS ; ++i )
   {
      if (Primes[i] >= n) return i+1;
   }
   return PAS;
}

/* Program entry point: */
int main (void)
{
   double t0;
   int i, j, k, l, m, limit;
   UL sum;
   UL smallest_1 = 0;
   UL smallest_2 = 0;
   UL smallest_3 = 0;
   UL smallest_4 = 0;
   UL smallest_5 = 0;
   UL smallest_s = 8364927;

   t0 = HiResTime();

   limit = PAS; // Start with limit set to 9592.
   for ( i = 1 ; i < limit - 4 ; ++i )                             // skip Primes[i] == 2
   {
      if ( 2 == i ) continue;                                      // skip Primes[i] == 5
      for ( j = i + 1 ; j < limit - 3 ; ++j )
      {
         if ( 2 == j ) continue;                                   // skip Primes[j] == 5
         if (!IsPrimePair(Primes[i],Primes[j])) continue;          // skip non-prime-pair
         for ( k = j + 1 ; k < limit - 2 ; ++k )
         {
            if (!IsPrimePair(Primes[i],Primes[k])) continue;       // skip non-prime-pair
            if (!IsPrimePair(Primes[j],Primes[k])) continue;       // skip non-prime-pair
            for ( l = k + 1 ; l < limit - 1 ; ++l )
            {
               if (!IsPrimePair(Primes[i],Primes[l])) continue;    // skip non-prime-pair
               if (!IsPrimePair(Primes[j],Primes[l])) continue;    // skip non-prime-pair
               if (!IsPrimePair(Primes[k],Primes[l])) continue;    // skip non-prime-pair
               for ( m = l + 1 ; m < limit - 0 ; ++m )
               {
                  if (!IsPrimePair(Primes[i],Primes[m])) continue; // skip non-prime-pair
                  if (!IsPrimePair(Primes[j],Primes[m])) continue; // skip non-prime-pair
                  if (!IsPrimePair(Primes[k],Primes[m])) continue; // skip non-prime-pair
                  if (!IsPrimePair(Primes[l],Primes[m])) continue; // skip non-prime-pair
                  sum = Primes[i] + Primes[j] + Primes[k] + Primes[l] + Primes[m];
                  printf("%ld + %ld + %ld + %ld + %ld = %ld\n", 
                  Primes[i], Primes[j], Primes[k], Primes[l], Primes[m], sum);
                  if (sum < smallest_s)
                  {
                     smallest_1 = Primes[i];
                     smallest_2 = Primes[j];
                     smallest_3 = Primes[k];
                     smallest_4 = Primes[l];
                     smallest_5 = Primes[m];
                     smallest_s = sum;
                     limit = Limit(sum);
                  }
               }
            }
         }
      }
   }
   printf("\nSmallest sum found:\n");
   printf("%ld + %ld + %ld + %ld + %ld = %ld\n",
   smallest_1, smallest_2, smallest_3, smallest_4, smallest_5, smallest_s);
   printf("\nElapsed time = %f seconds.\n", HiResTime()-t0);
   return 0;
}
