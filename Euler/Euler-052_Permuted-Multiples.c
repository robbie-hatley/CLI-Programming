// Euler-052_Permuted-Multiples.c

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <error.h>

//#define BLAT_ENABLE
#undef  BLAT_ENABLE
#include "rhdefines.h"
#include "rhmathc.h"
#include "rhutilc.h"

unsigned CharacterDigitToNumber (char a)
{
   // NOTE: the following assumes ASCII is being used:
   if      (a >= '0' && a <= '9') return (unsigned)(a - 48);
   else if (a >= 'A' && a <= 'Z') return (unsigned)(a - 55);
   else if (a >= 'a' && a <= 'z') return (unsigned)(a - 87);
   else                           return (unsigned)(  0   );
}

uint64_t Signature (uint64_t Number, unsigned Base)
{
   uint64_t  Bits [40] = {0};      // digit bits
   uint64_t  Sig       = 0;        // signature
   char      Buf  [65] = {'\0'};   // buffer for string version of number
   unsigned  NOD       = 0;        // number of digits
   unsigned  i         = 0;        // iterator

   if (Base < 2 || Base > 36)
   {
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error in Signature(): Base must be >= 2 and <= 36."
      );
   }
   Bits[0] = 1;
   for ( i = 1 ; i < Base ; ++i )
   {
      Bits[i] = Bits[i-1] << 1;
   }
   NOD = NumberOfDigits(Number, Base);
   RepresentInBase(Number, Base, NOD, false, Buf);
   for ( i = 0 ; i < NOD ; ++i)
   {
      Sig |= Bits[CharacterDigitToNumber(Buf[i])];
   }
   return Sig;
}

int main (void)
{
   uint64_t  x  = 0;
   double t0;

   t0 = HiResTime();

   // Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x
   // contain the same digits.
   for ( x = 1 ; x < 1000000 ; ++x)
   {
      if
      (
         Signature(2*x, 10) == Signature(3*x, 10)
         &&
         Signature(3*x, 10) == Signature(4*x, 10)
         &&
         Signature(4*x, 10) == Signature(5*x, 10)
         &&
         Signature(5*x, 10) == Signature(6*x, 10)
      )
      {
         printf("%lu\n", x);
         printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
         return EXIT_SUCCESS;
      }
   }
   printf("Not found.\n");
   printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
   return EXIT_FAILURE;
}

   /*
   printf("The signature of 2957684103 (base 10) is %lu\n", Signature(2957684103, 10));
   printf("The signature of 1648032597 (base 10) is %lu\n", Signature(1648032597, 10));
   printf("The signature of 2204020684 (base 10) is %lu\n", Signature(2204020684, 10));
   printf("The signature of 26M8T (base 30) is %lu\n", Signature(strtoul("26M8T", NULL, 10), 30));
   printf("The signature of 15N9S (base 30) is %lu\n", Signature(strtoul("15N9S", NULL, 10), 30));
   */
