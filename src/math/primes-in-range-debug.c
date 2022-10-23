/****************************************************************************\
 * Program:     Primes In Range C
 * File name:   primes-in-range-c.c
 * Source for:  primes-in-range-c.exe
 * Description: Prints all prime numbers in range [a,b].
 * Author:      Robbie Hatley
 * Edit History:
 *   Wed Dec 5, 2018:
 *     Wrote it.
\****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <sys/time.h>
#include <errno.h>
#include <error.h>

// Use asserts?
#define NDEBUG
#include <assert.h>
#ifndef NDEBUG
#define DB 1
#else
#define DB 0
#endif

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
// Returns true if n is prime, false if n is composite, WITHOUT having to first generate all prime numbers
// not greater than the square root of n.
bool IsPrime (uint64_t n)
{
   uint64_t  i       ; // Divisor index.
   uint64_t  spoke   ; // Wheel spoke.
   uint64_t  row     ; // Wheel row.
   uint64_t  divisor ; // Divisor.
            uint64_t  limit   ; // Upper limit for divisors to try.

   // Check to see if n is one of the first 4 prime numbers:
   if (2==n||3==n||5==n||7==n) return true;

   // If n is divisible by any of the first 4 prime numbers, n is composite:
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return false;

   // Set limit to the greatest integer not greater than the square root of n:
   limit = (uint64_t)sqrt((double)n);

   // Only bother testing divisors which are on the prime spokes, because only they could possibly be 
   // prime numbers. Note that we start with i = 1 to avoid divisor 1, which ALL integers are divisible by;
   // instead, we start with divisor 210*0+Wheel[1], which is 11:
   for ( i = 1 ; ; ++i )
   {
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      spoke   = i%48; // Modulo 48.
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

void HlpMsg (void)
{
   fprintf
   (
      stdout, 
      "primes-in-range-c takes exactly two arguments, Lwr and Upr,\n"
      "which must be numbers between 2 and 100 billion inclusive,\n"
      "with Lwr <= Upr. For help, use a \"-h\" or \"--help\" switch.\n"
   );
   return;
}

int main (int Beren, char *Luthien[])
{
   uint64_t  i       ; // index
   uint64_t  s       ; // spoke
   uint64_t  r       ; // row
   uint64_t  c       ; // candidate
   uint64_t  Lwr     ; // lower limit
   uint64_t  Upr     ; // upper limit

   if (Beren > 1 && (0==strcmp("-h", Luthien[1])||0==strcmp("--help",Luthien[1])))
   {
      HlpMsg();
      exit(777);
   }

   if (Beren != 3)
   {
      HlpMsg();
      exit(666);
   }

   Lwr = strtoul(Luthien[1], NULL, 10);
   Upr = strtoul(Luthien[2], NULL, 10);

   if (Lwr < 2 || Lwr > 100000000000 || Upr < 2 || Upr > 100000000000 || Lwr > Upr)
   {
      HlpMsg();
      exit(666);
   }

   if (DB)
   {
      fprintf(stderr, "Lwr = %lu  Upr = %lu\n", Lwr, Upr);
      assert(Lwr>=2); assert(Lwr<=100000000000);
      assert(Upr>=2); assert(Upr<=100000000000);
      assert(Lwr<=Upr);
   }

   // If Lwr < 11, then we must handle the first four primes manually, 
   // as an order-4 wheel can't find them:
   if (Lwr < 11)
   {
      for ( i = 0 ; i < 4 && (c=FirstFour[i]) <= Upr ; ++i )
      {
         printf("%15lu\n", c);
      }
      Lwr = 11;
   }

   // If Upr < 11, we're done:
   if (Upr < 11)
   {
      exit(0);
   }

   // Find index, row, and spoke of smallest viable candidate not-less-than Lwr:
   i = (Lwr/210)*48;
   if (DB)
   {
      fprintf(stderr, "starting index = %lu\n", i);
   }
   while(r=i/48,s=i%48,(c=210*(r)+Wheel[s])<Lwr)
   {
      ++i;
   }
   if (DB)
   {
      fprintf(stderr, "adjusted index = %lu\n", i);
   }

   // Find and print primes in range:
   while(r=i/48,s=i%48,(c=210*(r)+Wheel[s])<=Upr)
   {
      if (DB)
      {
         fprintf(stderr, "index     = %lu\n", i);
         fprintf(stderr, "row       = %lu\n", r);
         fprintf(stderr, "spoke     = %lu\n", s);
         fprintf(stderr, "candidate = %lu\n", c);
      }
      if(IsPrime(c))
      {
         if (DB)
         {
            fprintf(stderr, "candidate SUCCEEDED\n");
         }
         printf("%15lu\n",c);
      }
      else
      {
         if (DB)
         {
            fprintf(stderr, "candidate FAILED\n");
         }
      }
      ++i;
   }

   // We're done, so scram:
   return 0;
}