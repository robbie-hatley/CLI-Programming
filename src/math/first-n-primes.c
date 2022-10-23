/************************************************************************************************************\
 * Program:     first-n-primes
 * source file: first-n-primes.c
 * exe file:    first-n-primes.exe
 * Description: Finds and prints the first n prime numbers for any given n.
 * Author:      Robbie Hatley
 * Edit History:
 *   ??? ??? ##, ####: Wrote first draft.
 *   Tue Mar 16, 2021: Refactored.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>
#include <error.h>
#include <math.h>

#include "rhutilc.h"
#include "rhmathc.h"

int main (int Beren, char * Luthien[])
{
   uint64_t  c       = 0;     // candidate prime
   uint64_t  i       = 0;     // candidate index
   uint64_t  spoke   ;        // Wheel spoke.
   uint64_t  row     ;        // Wheel row.
   uint64_t           pc      = 0;     // prime count
   uint64_t           n       = 0;     // number of primes to generate

   // If number of arguments is wrong, print error and exit:
   if (2 != Beren)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: \"first-n-primes-wheel\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Get number of primes:
   n = strtoul(Luthien[1], NULL, 10);

   // Don't generate < 1 or > 100 billion primes:
   if (n < 1 || n > 100000000000)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: input is out-of-range.\n"
         "\"first-n-primes-wheel\" takes exactly 1 argument,\n"
         "which is the number of prime numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Serve 2,3,5,7 manually:
   for ( pc = 0 ; pc < 4 && pc < n ; ++pc )
   {
      printf("%lu\n", FirstFour[pc]);
   }

   // Generate and print remaining requested primes:
   for ( i = 0 ; pc < n ; ++i )
   {
      spoke   = i%48; // Modulo 48.
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      c       = 210*row + Wheel[spoke]; // prime candidate
      if (IsPrime(c))
      {
         printf("%lu\n", c);
         ++pc;
      }
   } // end for each candidate
   exit(EXIT_SUCCESS);
}
