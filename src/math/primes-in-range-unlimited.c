// primes-in-range-unlimited.c
// Finds all prime numbers in a closed interval [a,b], with unlimited precision, by using GMP.

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <errno.h>
#include <error.h>
#include <gmp.h>

#include "rhutilc.h"
#include "rhmathc.h"

int main (int Beren, char * Luthien[])
{
   uint64_t    pc    = 0;  // prime count
   double      t0    ;     // time zero
   mpz_t       Start ;     // Start range.
   mpz_t       End   ;     // End   range.
   mpz_t       Cand  ;     // Candidate.

   t0 = HiResTime();

   mpz_init(Start);
   mpz_init(End);
   mpz_init(Cand);

   // If number of arguments is wrong, print error and exit:
   if (3 != Beren)
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error: \"primes-in-range-unlimited\" takes 2 arguments,\n"
         "which must be the start and end of the range of numbers\n"
         "to search for prime numbers in. These integers can have\n"
         "any number of digits. (But bear in mind, if you specify\n"
         "numbers so large that the program takes 7 quintillion\n"
         "years to run, you won't see the results in your lifetime.)\n"
      );

   // Load Start and End:
   mpz_set_str(Start,Luthien[1],10);
   mpz_set_str(End  ,Luthien[2],10);

   // Bail if Start is greater than End:
   if (mpz_cmp(Start, End) > 0)
   {
      fprintf
      (
         stderr, 
         "Error: Starting value must not be greater than Ending value.\n"
      );
      exit(EXIT_FAILURE);
   }

   // If Start is even:
   if (mpz_even_p(Start))
   {
      // If Start is 2, handle it separately:
      if (0 == mpz_cmp_ui(Start, 2))
      {
         gmp_printf("%Zd\n", Start);
         ++pc;
      }
      // Increment Start by 1 so that it is now odd:
      mpz_add_ui(Start,Start,1);
   }

   // Find and print any primes in range:
   for
   (
      mpz_set(Cand,Start);     // Candidate starts at Start.
      mpz_cmp(Cand,End) <= 0;  // Candidate continues to End.
      mpz_add_ui(Cand,Cand,2)  // Consider only odd numbers as prime candidates (except for 2; see above).
   )
   {
      if(IsPrimeUnlimited(Cand))
      {
         gmp_printf("%Zd\n", Cand);
         ++pc;
      }
   } // end for each candidate

   fprintf(stderr, "Found %lu primes. \n", pc);
   fprintf(stderr, "Elapsed time = %f seconds.\n", HiResTime() - t0);

   // We're done, so scram:
   exit(EXIT_SUCCESS);
}
