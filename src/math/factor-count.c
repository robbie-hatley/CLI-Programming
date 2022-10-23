/****************************************************************************\
 * File name:    factor-count.c
 * Title:        Factor Count
 * Description:  Counts prime factors of positive integers >= 2.
 * Author:       Robbie Hatley
 * Edit history:
 *    Sat Nov 14, 2020: Wrote it.
\****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main ( int Beren, char ** Luthien )
{
   uint64_t i = 0ul; // Index for "for" loop.
   uint64_t n = 0ul; // Counter for factors.
   uint64_t x = 0ul; // Number to be factored.

   if (2 != Beren)
   {
      printf("Error: this program takes exactly one argument, which must be\n");
      printf("an integer in the range [2, 18446744073709551611]\n");
      exit(EXIT_FAILURE);
   }
   
   x = (uint64_t)strtoul(Luthien[1], NULL, 10);
   
   if (x < 3ul || x > 18446744073709551611ul)
   {
      printf("Error: this program's argument must be an integer in the range\n");
      printf("[2, 18446744073709551611]\n");
      exit(EXIT_FAILURE);
   }
   
   n = 0ul;
   while ( 0ul == x % 2ul )
   {
      x /= 2ul;
      ++n;
   }
   if (n > 0ul)
      printf("Factor 2 occurred %lu times.\n", n);
   
   for ( i = 3ul ; i <= x ; i += 2ul )
   {
      if (0ul != x % i)
         continue;
      n = 0ul;
      while ( 0ul == x % i ) 
      {
         x /= i;
         ++n;
      }
      if (n > 0ul)
         printf("Factor %lu occurred %lu times.\n", i, n);
   }

   if (1ul != x)
   {
      printf("Error: left-over remainder.\n");
   }

   exit(EXIT_SUCCESS);
}
