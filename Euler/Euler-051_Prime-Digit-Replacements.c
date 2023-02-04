// This is a 110-character-wide ASCII C source-code text file.

/************************************************************************************************************\
 * Program name:  Project Euler Problem 51: "Prime Digit Replacements"
 * File name:     Euler-051_Prime-Digit-Replacements.c
 * Source for:    Euler-051_Prime-Digit-Replacements.exe
 * Description:   Attempts to solve Project Euler's Problem 51, "Prime Digit Replacements"
 * Inputs:        None.
 * Outputs:       Prints first 8-member prime number "family" it finds. 
 * To make:       
 * Author:        Robbie Hatley
 * Edit history:  
 *    Wed Sep 23, 2020: Wrote it.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "rhutilc.h"
#include "rhmathc.h"

int main (int Beren, char ** Luthien)
{
   double    t0     = 0; // timer
   unsigned  fn     = 0; // family number (current family being worked on)
   unsigned  limit  = 0; // limit on number of digits
   unsigned  n      = 0; // current  number of digits

   t0 = HiResTime();

   if (2 != Beren) exit(666);
   limit = (unsigned)strtol(Luthien[1], NULL, 10);
   if (limit < 3 || limit > 15) exit(666);

   for ( n = 3 ; n <= limit ; ++n )
   {
      uint64_t  Pattern;                      // binary Pattern of replacement digits
      uint64_t  lower_limit = 2;              // right digit can NOT be replacement digit!
      uint64_t  upper_limit = IntPow(2, n)-2; // 2**6-1 would be 0b111111 which is not allowed
      for ( Pattern = lower_limit ; Pattern <= upper_limit ; Pattern+=2 )
      {
         uint64_t  Seed;        // current Seed
         uint64_t  lsl    = 1;  // lower Seed limit (1)
         uint64_t  usl    = 0;  // upper Seed limit (10^nsd-1)
         uint64_t  r;           // replacement digit
         unsigned  d;           // digit position
         unsigned  nsd    = 0;  // number of Seed digits

         // For each Pattern, we need to try all possible combinations of "Seed" digits. How many digits?
         for (d = 0 ; d <= n-1 ; ++d)
         {
            if (!(1<<d & Pattern))
               ++nsd;
         }

         // Top Seed value will be 10^nsd-1:
         usl = IntPow(10,nsd)-1;

         // Iterate through all possible Seed values, skipping those which are invalid (such as even numbers):
         for ( Seed = lsl ; Seed <= usl ; Seed+=2 )
         {
            // Made a Skeleton variable for this combo of Pattern+Seed:
            uint64_t Skeleton  = 0;
            // Made a Candidate variable for this combo of Pattern+Seed:
            uint64_t Candidate = 0;
            // If rightmost digit is not replacement, rightmost digit of Seed must be 1, 3, 7, or 9:
            if (!(1&Pattern))
            {
               if (1!=Seed%10 && 3!=Seed%10 && 7!=Seed%10 && 9!=Seed%10)
                  continue;
            }
            // If leftmost digit is not replacement, leftmost digit of Seed must be non-zero:
            if (!((1<<(n-1))&Pattern))
            {
               if ( 0 == Seed/IntPow(10,nsd-1))
                  continue;
            }

            // If we get to HERE, we have a valid Pattern AND a valid Seed, so form a Candidate number by
            // putting the digits of Seed in the gaps in the Pattern and adding their place values.

            // Put Seed digits into the Pattern gaps in Skeleton:
            unsigned p = 0; // current Seed place.
            for ( d = 0 ; d <= n-1 ; ++d ) // for each digit
            {
               if (!((1<<d)&Pattern))      // if NOT a replacement digit
               {
                  Skeleton += ((Seed/IntPow(10,p))%10)*IntPow(10,d);
                  ++p;
               }
            }

            // Print intro for this family:
            printf("\n"                            );
            printf("Family #    = %u\n",  fn       );
            printf("# of digits = %u\n",  n        );
            printf("Pattern     = %lu\n", Pattern  );
            printf("Seed        = %lu\n", Seed     );
            printf("Skeleton    = %lu\n", Skeleton );

            // Initialize a Members counter to count members (if any) of this prime number family:
            unsigned Members = 0;

            // Now try all valid replacement digits for this Pattern+Seed:
            for ( r = 0 ; r <=9 ; ++r )
            {
               // Can't use 0 if leftmost column is replacement column:
               if ((1<<(n-1) & Pattern) && 0==r)
                  continue; // can't replace left column with 0
               // Resetting Candidate back to Skeleton for each r:
               Candidate = Skeleton;
               // Now form a new Canditate for this r:
               for ( d = 0 ; d <= n-1 ; ++d )
               {
                  if ((1<<d)&Pattern)
                  {
                     Candidate += r*IntPow(10,d);
                  }
               }
               printf("Candidate: %lu\n", Candidate);
               // If resulting number is prime, push it onto member list for this family:
               if (IsPrime(Candidate))
               {
                //Families[fn][Members[fn]] = Candidate;
                  printf("PRIME: %lu\n", Candidate); // Families[fn][Members[fn]]);
                  ++Members;
               }
            }
            // How many Members in this Pattern+Seed family?
            printf("Members     = %u\n", Members);
            // Increment family number in preparation for next family:
            ++fn;
         } // end for (each valid Seed)
      } // end for (each valid Pattern)
   } // end for (each number of digits)

   // Print elapsed time and exit:
   printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
   return 0;
}
