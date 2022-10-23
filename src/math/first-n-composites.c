/************************************************************************************************************\
 * Program:     first-n-composites
 * source file: first-n-composites.c
 * exe file:    first-n-composites.exe
 * Description: Finds and prints the first n composites numbers for any given n.
 * Author:      Robbie Hatley
 * Edit History:
 *   Tue Mar 16, 2021: Wrote it.
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

uint64_t FirstFiveCompNums[5] = {4,6,8,9,10};

int main (int Beren, char * Luthien[])
{
   uint64_t  c       = 0;     // candidate prime
   uint64_t  i       = 0;     // candidate index
   uint64_t  spoke   ;        // Wheel spoke.
   uint64_t  row     ;        // Wheel row.
   uint64_t  cc      = 0;     // composite count
   uint64_t  n       = 0;     // number of composites to generate

   // If number of arguments is wrong, print error and exit:
   if (2 != Beren)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: \"first-n-composites\" takes exactly 1 argument,\n"
         "which is the number of composite numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Get number of composites:
   n = strtoul(Luthien[1], NULL, 10);

   // Don't generate < 1 or > 100 billion composites:
   if (n < 1 || n > 100000000000)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: input is out-of-range.\n"
         "\"first-n-composites\" takes exactly 1 argument,\n"
         "which is the number of composite numbers to be printed,\n"
         "and which must be an integer between 1 and 100 billion inclusive.\n"
      );

   // Serve 4,6,8,9,10 manually:
   for ( cc = 0 ; cc < 5 && cc < n ; ++cc )
   {
      printf("%lu\n", FirstFiveCompNums[cc]);
   }

   // Generate and print remaining requested composites:
   for ( i = 0 ; cc < n ; ++i )
   {
      spoke   = i%48; // Modulo 48.
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      c       = 210*row + Wheel[spoke]; // prime candidate
      if (!IsPrime(c))
      {
         printf("%lu\n", c);
         ++cc;
      }
   } // end for each candidate
   exit(EXIT_SUCCESS);
}
