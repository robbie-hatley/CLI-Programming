// comb-iter.c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>

unsigned long comb (unsigned long n, unsigned long k)
{
   unsigned long num = 1;
   unsigned long den = 1;
   unsigned long i   = 0;
   for ( i = n - k + 1 ; i <= n ; ++i )
   {
      num *= i;
   }
   for ( i = 1 ; i <= k ; ++i )
   {
      den *= i;
   }
   return num/den;
}

int main (int Beren, char * Luthien[]) 
{
   unsigned long n = 0;
   unsigned long k = 0;

   if (Beren != 3) 
   {
      error
      (
         EXIT_FAILURE, 
         EINVAL, 
         "%s\n%s\n%s\n",
         "Requires two non-negative integer arguments,",
         "the second not greater than the first,",
         "neither greater than 18 quintillion."
      );
   }

   n = strtoul (Luthien[1], NULL, 10);
   if (n > 18000000000000000000UL) 
   {
      error
      (
         EXIT_FAILURE, 
         ERANGE, 
         "%s\n%s\n%s\n",
         "Requires two non-negative integer arguments,",
         "the second not greater than the first,",
         "neither greater than 18 quintillion."
      );
   }

   k = strtoul (Luthien[2], NULL, 10);
   if (k > 18000000000000000000UL) 
   {
      error
      (
         EXIT_FAILURE, 
         ERANGE, 
         "%s\n%s\n%s\n",
         "Requires two non-negative integer arguments,",
         "the second not greater than the first,",
         "neither greater than 18 quintillion."
      );
   }

   if (k > n)
   {
      error
      (
         EXIT_FAILURE, 
         EINVAL, 
         "%s\n%s\n%s\n",
         "Requires two non-negative integer arguments,",
         "the second not greater than the first,",
         "neither greater than 18 quintillion."
      );
   }

   printf("comb(%lu, %lu) = %lu\n", n, k, comb(n,k));
   return 0;
}
