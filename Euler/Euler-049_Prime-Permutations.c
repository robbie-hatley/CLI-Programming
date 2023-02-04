/*
Euler-049_Prime-Permutations.c
Written Sun Feb 11, 2018 by Robbie Hatley
*/

#include <stdio.h>
#include <sys/time.h>

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

int Signature (int n)
{
   if ( n < 1000 || n > 9999 ) return 0; // Reject all non-4-digit numbers.
   int Digits [10] = {0};                // Counts of occurrences of each of the 10 digits.
   ++Digits[(n/1000) % 10];              // The 1000s digit.
   ++Digits[(n/ 100) % 10];              // The  100s digit.
   ++Digits[(n/  10) % 10];              // The   10s digit.
   ++Digits[(n/   1) % 10];              // The    1s digit.
   int result = 0;
   int pv [4] = {1000,100,10,1};
   int pvi = 0;
   int di;
   for ( di = 0 ; di < 10 ; ++di )
   {
      while (Digits[di]-- > 0)           // While this digit occurs, decrement its counter,
      {
         result += pv[pvi++]*di;         // add digit to result, and increment place-value counter.
      }
   }
   return result;
}

static int Primes [10000][25] = {0}; // Primes for each signature.
static int Counts [10000]     = {0}; // Counts of primes for each signature.

void FindFourDigitPrimes (void)
{
   int n, sig;
   for ( n = 1000 ; n < 10000 ; ++n )            // for all 10,000 4-digit numbers
   {
      if ( IsPrime(n) )                          // if number is prime
      {
         sig = Signature(n);                     // get signature of number
         if ( sig > 0 )                          // if sig is greater than zero
         {
            Primes[sig][Counts[sig]++] = n;      // store number in Primes[][] for this sig
         }
      }
   }
   return;
}

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
   int sig, pri, i, j, k;

   // Initial time:
   t0 = HiResTime();

   // Find all 4-digit primes with no 0 digits:
   FindFourDigitPrimes();

   // Print all signatures, all primes:
   for ( sig = 0 ; sig < 10000 ; ++sig )             // For all 10,000 possible signatures
   {
      if ( Counts[sig] > 0 )                         // If count of primes for this sig > 0
      {
         printf("Signature = %04d:", sig);           // Print signature.
         for ( pri = 0 ; pri < Counts[sig] ; ++pri ) // For all primes with this signature
         {
            printf(" %d", Primes[sig][pri]);         // print prime
         }
         printf("\n");                               // print newline
      }
   }

   printf("\n");
   
   // Look for equally-spaced threesomes:
   for ( sig = 0 ; sig < 10000 ; ++sig )             // For all 10,000 possible signatures
   {
      if ( Counts[sig] >= 3 )                        // If count of primes for this sig >= 3
      {
         for (i=0;i<Counts[sig]-2; ++i)              // first prime in this sequence
         {
            for (j=i+1;j<Counts[sig]-1;++j)          // second prime in this sequence
            {
               for (k=j+1;k<Counts[sig];++k)         // third prime in this sequence
               {
                  if 
                  (
                     Primes[sig][k]-Primes[sig][j]
                     ==                              // if equally spaced,
                     Primes[sig][j]-Primes[sig][i]
                  )
                  {
                     printf("Interval = %04d: ",
                     Primes[sig][j]-Primes[sig][i]);
                     printf("%d %d %d\n", 
                     Primes[sig][i],
                     Primes[sig][j],                 // print primes
                     Primes[sig][k]);
                  }
               }
            }
         }
      }
   }

   // Print elapsed time and exit:
   printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
   return 0;
}
