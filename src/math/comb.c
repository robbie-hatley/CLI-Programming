// comb.c
// Unlimited-Precision Unordered Combinations ( n!/((n-k)!k!) )
// Written Wednesday April 4, 2018, by Robbie Hatley.
// Edited Thu Sep 24, 2020 by Robbie Hatley to allow "0" cases.
// To make, link with Gnu Multiple-Precision-Arithmetic Library,
// aka "GMP", downloadable for free from web site "gnu.org".
// Doesn't use any other 3rd-party libraries.
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <gmp.h>

void comb (mpz_t c, unsigned long n, unsigned long k)
{
   mpz_bin_uiui(c,n,k);
   return;
}

int main (int Beren, char * Luthien[]) 
{
   unsigned long  n  = 0;
   unsigned long  k  = 0;
   mpz_t          c;

   if (Beren != 3)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: Wrong number of arguments.\n"
         "\"comb\" requires two non-negative integer arguments,\n"
         "neither greater than 1 billion.\n"
      );
   }

   n = strtoul (Luthien[1], NULL, 10);
   if (n > 1000000000UL)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: First argument is too large.\n"
         "\"comb\" requires two non-negative integer arguments,\n"
         "neither greater than 1 billion.\n"
      );
   }

   k = strtoul (Luthien[2], NULL, 10);
   if (k > 1000000000UL)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: Second argument is too large.\n"
         "\"comb\" requires two non-negative integer arguments,\n"
         "neither greater than 1 billion.\n"
      );
   }

   /*if (k > n)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: Second argument is larger than first argument.\n"
         "\"comb\" requires two non-negative integer arguments,\n"
         "the second not greater than the first,\n"
         "neither greater than 1 billion.\n"
      );
   }*/

   mpz_init(c);
   comb(c,n,k);
   gmp_printf("%Zu", c);

   return 0;
}
