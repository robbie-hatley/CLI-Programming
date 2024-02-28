/************************************************************************************************************\
 * Program:        primes-in-range
 * source file:    primes-in-range.c
 * exe file (lin): primes-in-range
 * exe file (win): primes-in-range.exe
 * Description:    Prints all prime numbers in range [a,b].
 * Author:         Robbie Hatley
 * Edit History:
 * Wed Dec 05, 2018: Wrote it.
 * Tue Mar 16, 2021: Refactored.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#include "rhutilc.h"
#include "rhmathc.h"

void HlpMsg (void)
{
   printf
   (
      "primes-in-range-c takes exactly two arguments, Lwr and Upr,\n"
      "which must be numbers between 2 and 100 billion inclusive,\n"
      "with Lwr <= Upr.\n"
   );
   return;
}

int main (int Beren, char *Luthien[])
{
   uint64_t i   = 0; // index
   uint64_t c   = 0; // candidate
   uint64_t Lwr = 0; // lower limit
   uint64_t Upr = 0; // upper limit
   uint64_t Sta = 0; // start point for wheel search
   uint64_t pc  = 0; // prime count
   double start,end,elapsed;

   start = MonoTime();

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

   // If Lwr < 11, then we must handle the first 4 primes manually,
   // as an order-4 wheel can't find them:
   if (Lwr < 11)
   {
      for ( i = 0 ; i < 4 ; ++i )
      {
         c=FirstFour[i];
         if (c>=Lwr && c<=Upr)
         {
            // printf("%lu\n", c);
            ++pc;
         }
      }
   }

   // If Upr < 11, we're done:
   if (Upr < 11)
   {
      goto END;
   }

   // If we get to here, Upr > 11, so set start point for wheel search:
   Sta = (Lwr<11?11:Lwr);

   // Find index of smallest viable candidate not-less-than Sta:
   i = (Sta/210)*48;
   while(210*(i/48)+Wheel[i%48]<Sta)
   {
      ++i;
   }

   // Find and print primes in range [Sta, Upr]:
   while((c=210*(i/48)+Wheel[i%48])<=Upr)
   {
      if(IsPrime(c))
      {
         printf("%15lu\n",c);
         ++pc;
      }
      ++i;
   }
   END:
   printf("primes found = %lu\n", pc);
   end = MonoTime();
   elapsed = end-start;
   printf("elapsed time = %.9f\n", elapsed);
   exit(EXIT_SUCCESS);
}