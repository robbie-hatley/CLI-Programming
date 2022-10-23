// factorial.c
// Unlimited-Precision factorial.
// Written Friday April 12, 2019, by Robbie Hatley.
// To make, link with Gnu Multiple-Precision-Arithmetic Library,
// aka "GMP", downloadable for free from web site "gnu.org".
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <gmp.h>

int main (int Beren, char * Luthien[]) 
{
   unsigned long  n  = 0;
   mpz_t          f;

   if (Beren != 2)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: Wrong number of arguments.\n"
         "\"factorial\" requires one non-negative integer argument,\n"
         "at least 0 and at most 1 billion.\n"
      );
   }

   n = strtoul (Luthien[1], NULL, 10);
   if (n > 1000000000UL)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error: Argument out-of-range.\n"
         "\"factorial\" requires one non-negative integer argument,\n"
         "at least 0 and at most 1 billion.\n"
      );
   }

   mpz_init(f);
   mpz_fac_ui(f,n);
   gmp_printf("%Zu", f);

   return 0;
}
