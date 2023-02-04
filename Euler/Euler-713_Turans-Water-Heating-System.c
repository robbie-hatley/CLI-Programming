// This is a 79-character-wide ASCII-encoded C source-code file.
// Euler-713_Turans-Water-Heating-System.c
// Solves Project Euler Problem 713: Turan's Water Heating System
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

// How many combinations of k things from a set of n exist?
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
} // end comb

uint64_t T (uint64_t n, uint64_t m)
{
   if (m-1 >= (uint64_t)ceil((double)n/2.0))
      return n-m+1;
   else
   {
      uint64_t q = n/(m-1);
      uint64_t r = n%(m-1);
      return r*comb(q+1,2)+(m-1-r)*comb(q,2);
   }
}

uint64_t L (uint64_t n)
{
   uint64_t  m    = 0ul;
   uint64_t  Sum  = 0ul;
   for ( m = 2ul ; m <= n ; ++m )
   {
      Sum += T(n,m);
   }
   return Sum;
}

int main (int Beren, char ** Luthien)
{
   uint64_t  n    = 0ul;
   uint64_t  Sum  = 0ul;
   if (2ul != Beren) {return 1;}
   n = (uint64_t)strtoul(Luthien[1],NULL,10);
   if (n<2ul || n>10000000ul) {exit(EXIT_FAILURE);}
   Sum = L(n);
   printf("T(%lu,%lu) = %lu\n", 3ul, 2ul, T(3ul,2ul));
   printf("T(%lu,%lu) = %lu\n", 8ul, 4ul, T(8ul,4ul));
   printf("L(%lu) = %lu\n", n, Sum);
   exit(EXIT_SUCCESS);
}
