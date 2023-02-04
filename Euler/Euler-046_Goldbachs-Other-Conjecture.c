/*
"Euler-046_Goldbachs-Other-Conjecture.c"
Author:  Robbie Hatley
Written: Mon Feb 05, 2018
*/

#include <stdio.h>
#include <sys/time.h>
#include <gmp.h>

#include "rhutilc.h"
#include "rhmathc.h"

#define SIZE_PRIME 10000000
#define SIZE_DBSQR     2500

/* Table of prime numbers, preloaded with all under 11: */
unsigned long Primes [SIZE_PRIME] = {2UL,3UL,5UL,7UL};
unsigned long PrimeCount = 4UL; 

/* Table of odd composite numbers, preloaded with all under 11: */
unsigned long OddComposites [SIZE_PRIME] = {9UL};
unsigned long CompCount = 1UL;

/* Table of double-square numbers, zeroed: */
unsigned long DoubleSquares [SIZE_DBSQR] = {0UL};
unsigned long SquareCount = 0UL;

/* Generate tables of prime numbers and odd composite numbers under SIZE: */
void MakePrimesAndOddComposites (void)
{
   /* Riffle through all odd numbers >= 11 but < SIZE ;
      each such number is either prime or odd-composite: */
   unsigned long i;
   for ( i = 11UL ; i < SIZE_PRIME ; i += 2UL )
   {
      /* Is i prime? If so, include i in table of primes: */
      if ( IsPrime(i) )
      {
         Primes[PrimeCount] = i;
         ++PrimeCount;
      }
      /* Else, include i in table of oddcmp: */
      else
      {
         OddComposites[CompCount] = i;
         ++CompCount;
      }
   }
   return;
}

/* Generate tabe of double-square numbers: */
void MakeDoubleSquares (void)
{
   unsigned long i;
   for ( i = 0UL ; i < SIZE_DBSQR ; ++i )
   {
      DoubleSquares[SquareCount] = 2UL * i * i;
      ++SquareCount;
   }
   return;
}

int IsDoubleSquare (unsigned long n)
{
   unsigned long i;
   for ( i = 0UL ;  ; ++i )
   {
      if ( i >= SquareCount )
      {
         printf("RAN OUT OF DOUBLE SQUARES.\n");
         break;
      }
      if (DoubleSquares[i]  > n) break;
      if (DoubleSquares[i] == n) return 1;
   }
   return 0;
}

int main(void)
{
   unsigned long i, j, oddcomp, prime, residue;
   double t0;

   t0=HiResTime();

   MakePrimesAndOddComposites();
   MakeDoubleSquares();
   printf ( "Primes Count:         %ld\n", PrimeCount                   );
   printf ( "Maximum prime:        %ld\n", Primes[PrimeCount-1]         );
   printf ( "OddComps Count:       %ld\n", CompCount                    );
   printf ( "Maximum OddComp:      %ld\n", OddComposites[CompCount-1]   );
   printf ( "DoubleSquares Count:  %ld\n", SquareCount                  );
   printf ( "Maximum DoubleSquare: %ld\n", DoubleSquares[SquareCount-1] );

   for ( i = 0UL ; i < CompCount ; ++i )
   {
      oddcomp = OddComposites[i];            // Next odd composite to examine.
      for ( j = 0UL ;  ; ++j )
      {
         if ( j >= PrimeCount )
         {
            printf("RAN OUT OF PRIMES.\n");
            break;
         }
         prime = Primes[j];
         if (prime >= oddcomp)               // If we ran out of primes,
         {                                   // this odd composite has no solution.
            printf("Odd composite # %ld = %ld isn't sum of prime+DblSqr\n", i, oddcomp);
            break;
         }
         residue = oddcomp - prime;
         if (IsDoubleSquare(residue)) break; // Found solution.
      }
   }

   printf("Elapsed time = %f seconds\n", HiResTime() - t0);
   return 0; 
}
