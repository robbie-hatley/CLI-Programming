// first-n-primes-table-2.c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <error.h>
#include <assert.h>
int main (int Beren, char * Luthien[])
{
   int    * Primes   = NULL; // prime-number array
   size_t   LIMIT      =  100; // size limit for prime-number array
   size_t   pindex     =    0; // prime index
   size_t   pcount     =    0; // count of prime numbers found so far
   int      candidate  =    0; // candidate for possible primeness
   int      flag       =    0; // "is prime" flag
   int      sqrt_cand  =    0; // int(floor(square root(candidate)))

   if (Beren > 1) {LIMIT = strtoul(Luthien[1], NULL, 10);}
   errno = 0;
   Primes = malloc((LIMIT+10)*sizeof(int));
   if (NULL == Primes)
      error(EXIT_FAILURE, errno, "Error: couldn't allocate Primes.");
   Primes[0] = 2;
   printf("%11d\n", Primes[0]);
   Primes[1] = 3;
   printf("%11d\n", Primes[1]);
   pcount = 2;
   for ( candidate = 5 ; pcount < LIMIT ; candidate += 2 )
   {
      sqrt_cand = (int)floor(sqrt((double)candidate));
      flag = 1;
      for ( pindex = 0 ; Primes[pindex] <= sqrt_cand ; ++pindex )
      {
         // Because sqrt_cand is always far less than candidate, it's unlikely that pindex will reach LIMIT
         // before Primes[pindex] reaches sqrt_cand, but let's "assert" that and see if that ever fails:
         assert(pindex < LIMIT);
         if(0 == (candidate % Primes[pindex]))
         {
            flag=0;
            break;
         }
      }
      if(flag)
      {
         Primes[pcount] = candidate;
         printf("%11d\n", Primes[pcount]);
         ++pcount;
      }
   }
   free(Primes);
   exit(EXIT_SUCCESS);
}
