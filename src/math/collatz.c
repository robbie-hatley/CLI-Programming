
/****************************************************************************\
 * Program name:  Collatz
 * File name:     collatz.c
 * Source for:    collatz.exe
 * Description:   Generates Collatz sequences for seeds from 1 through 
 *                the number given as argument.
 * Inputs:        One command-line argument, giving MaxSeed.
 * Outputs:       Collatz sequences for seeds from 1 through MaxSeed.
 * To make:       No non-std dependencies. Just type "make collatz.exe",
 *                or use gcc manually.
 * Author:        Robbie Hatley
 * Date written:  Fri Feb 19, 2016
\****************************************************************************/

#include <stdio.h>
#include <stdlib.h>

int main(int Fred, char *Ethel[])
{
   long     Seed                 = 0;
   long     MaxSeed              = 0;
   long     SeqLength            = 0;
   long     MaxSeqLength         = 0;
   long     Number               = 0;
   long     MaxNumber            = 0;
   long     SeedForMaxSeqLength  = 0;
   long   * NumberArray          = NULL; // Numbers seen so-far in curr. seq.
   size_t   ArraySize            = 100;  // This may increase, so not const.

   if (2 != Fred)
   {
      fprintf(stderr, "Error: this program needs exactly 1 argument,\n");
      fprintf(stderr, "which must be a positive integer.\n");
      exit(EXIT_FAILURE);
   }

   NumberArray = malloc(ArraySize * sizeof(long));
   if (!NumberArray)
   {
      fprintf(stderr, "Ran out of memory!");
      exit(EXIT_FAILURE);
   }

   MaxSeed = strtol(Ethel[1], 0, 10);

   for ( Seed = 1 ; Seed <= MaxSeed ; ++Seed )
   {
      Number = Seed;
      MaxNumber = Number;
      do                    // generate next number
      {
         ++SeqLength;
         if (0 == Number%2) // if even
         {
            Number /= 2;
         }
         else               // if odd
         {
            Number = 3*Number + 1;
         }
         if (Number > MaxNumber) MaxNumber = Number;
      } while (Number > 1);
      printf("Seed: %10ld  Length: %10ld  Max:%10ld\n", 
         Seed, SeqLength, MaxNumber);
      if (SeqLength > MaxSeqLength)
      {
         SeedForMaxSeqLength = Seed;
         MaxSeqLength = SeqLength;
      }
   }
   printf("For seeds from 1 through %ld:\n", MaxSeed);
   printf("Maximum sequence length = %ld for seed = %ld\n", 
      MaxSeqLength, SeedForMaxSeqLength);
   return 0;
}
