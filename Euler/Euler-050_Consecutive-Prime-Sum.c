/*
Euler-050_Consecutive-Prime-Sum.c
Written Sun Feb 11, 2018 by Robbie Hatley
*/

#include <stdio.h>
#include <sys/time.h>

/* Primes under 1 million: */
#include "Array-Of-78498-Primes-Under-1000000.cism"

/* Order-4 wheel (2*3*5*7=210, 48 spokes) for finding primes: */
const int Wheel[48] =
{
     1,  11,  13,  17,  19,  23,  29,  31,  37,  41,
    43,  47,  53,  59,  61,  67,  71,  73,  79,  83,
    89,  97, 101, 103, 107, 109, 113, 121, 127, 131,
   137, 139, 143, 149, 151, 157, 163, 167, 169, 173,
   179, 181, 187, 191, 193, 197, 199, 209
};

/* Integer Square Root: */
int IntSqrt (int n)
{
   int i = 1;
   while ( i * i <= n )
   {
      ++i;
   }
   return i - 1;
}

/* Is a given integer a prime number? */
int IsPrime (int n)
{
   int  i        = 0; /* Divisor index.                   */
   int  index    = 0; /* Wheel index.                     */
   int  spoke    = 0; /* Wheel spoke.                     */
   int  limit    = 0; /* Upper limit for divisors to try. */
   int  divisor  = 0; /* Divisor.                         */
   if (n<2) return 0;
   if (2==n||3==n||5==n||7==n) return 1;
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return 0;
   limit = IntSqrt(n);
   for ( i = 1 ; ; ++i )
   {
      spoke   = i/48;
      index   = i%48;
      divisor = 210*spoke + Wheel[index];
      if (divisor > limit) return 1;
      if (!(n%divisor))    return 0;
   }
} /* end IsPrime() */

double HiResTime (void)
{
   struct timeval t;
   gettimeofday(&t, NULL);
   return (double)t.tv_sec + (double)t.tv_usec / 1000000.0;
}

int main (void)
{
   // Variable pre-declarations:
   double t0;
   int start, end, sum, i, longest_start, longest_end, longest_prime;

   // Initial time:
   t0 = HiResTime();

   // How many consecutive primes can we add together and get
   // a prime under 1000000 as sum?
   longest_start = 0; 
   longest_end   = 1; 
   longest_prime = 5;
   for ( start = 0 ; start < 78497 ; ++start )
   {
      for ( end = start + 1 ; end < 78498 ; ++end )
      {
         sum = 0;
         for ( i = start ; i <= end ; ++i )
         {
            sum += Primes[i];
         }
         if (sum >= 1000000) break;
         // If sum is a prime, 
         // and if the sequence is the longest we've seen so far,
         // then set the "longest_" variables to record that:
         if (IsPrime(sum))
         {
            if ( end - start > longest_end - longest_start)
            {
               longest_start = start;
               longest_end   = end;
               longest_prime = sum;
            }
         }
      }
   }
   printf("%d", Primes[longest_start]);
   for ( i = longest_start + 1 ; i <= longest_end ; ++i )
   {
      printf(" + %d", Primes[i]);
   }
   printf(" = %d\n", longest_prime);

   // Print elapsed time and exit:
   printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
   return 0;
}
