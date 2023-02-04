/*
"Euler-078_Coin-Partitions.c"
Attempts to solve problem 78 of Project Euler, "Coin Partitions".
Author:  Robbie Hatley
Written: Mon Mar 12, 2018 through Friday Mar 16, 2018.
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <gmp.h>

#include "rhdefines.h"
#include "rhutilc.h"
#include "rhmathc.h"

#define MAX_N 100000
#define ARRAY_SIZE (MAX_N + 5)

#define MAX_DIV_MIL 1000
#define DIV_MIL_ARRAY_SIZE (MAX_DIV_MIL + 5)

mpz_t PTable        [ARRAY_SIZE];
mpz_t DivMil        [DIV_MIL_ARRAY_SIZE];
int   DivMilIndices [DIV_MIL_ARRAY_SIZE];

void InitArrays (void)
{
   int i;
   for ( i = 0 ; i < ARRAY_SIZE ; ++i )
   {
      mpz_init(PTable[i]);
   }
   mpz_set_si(PTable[ 0],  1);
   mpz_set_si(PTable[ 1],  1);
   mpz_set_si(PTable[ 2],  2);
   mpz_set_si(PTable[ 3],  3);
   mpz_set_si(PTable[ 4],  5);
   mpz_set_si(PTable[ 5],  7);
   mpz_set_si(PTable[ 6], 11);
   mpz_set_si(PTable[ 7], 15);
   mpz_set_si(PTable[ 8], 22);
   mpz_set_si(PTable[ 9], 30);
   mpz_set_si(PTable[10], 42);
   mpz_set_si(PTable[11], 56);
   for ( i = 0 ; i < DIV_MIL_ARRAY_SIZE ; ++i )
   {
      mpz_init(DivMil[i]);
      DivMilIndices[i] = 0;
   }
}

void P (mpz_t result, const int n)
{
   if      (n < 0 )                    {mpz_set_si(result,0);}
   else if (n < 12)                    {mpz_set(result,PTable[n]);}
   else if (mpz_cmp_si(PTable[n],0)>0) {mpz_set(result,PTable[n]);}
   else
   {
      int    sign   = 0;
      int    k      = 0;
      int    Limit  = (int)floor((sqrt(24.0*(double)n+1.0)+1.0)/6.0);
      mpz_t  p;     mpz_init(p);
      mpz_t  pPos;  mpz_init(pPos);
      mpz_t  pNeg;  mpz_init(pNeg);

      for ( k = 1 ; k <= Limit ; ++k )
      {
         sign = k%2 == 0 ? -1 : +1;
         P(pPos, n-k*(3*k-1)/2);
         P(pNeg, n-k*(3*k+1)/2);
         mpz_mul_si(pPos, pPos, sign);
         mpz_mul_si(pNeg, pNeg, sign);
         mpz_add(p, p, pPos);
         mpz_add(p, p, pNeg);
      }
      mpz_set(PTable[n], p); /* STORE IN TABLE! SAVES VAST AMOUNT OF TIME! */
      mpz_set(result,    p); /* Also set the output parameter. */
   }
   return; /* Passing output in "result" parameter, so no return value. */
}

int main(void)
{
   double  t0  = 0;
   int     i   = 0;
   int     dm  = 0;
   mpz_t   p;  mpz_init(p);

   t0 = HiResTime();

   InitArrays();

   for ( i = 0 ; i <= MAX_N ; ++i )
   {
      P(p, i);
      gmp_printf("p(%5d) = %50Zd\n", i, p);
      if (mpz_divisible_ui_p(p,1000000))
      {
         mpz_set(DivMil[dm], p);
         DivMilIndices[dm] = i;
         ++dm;
      }
   }

   printf("Found %d partition counts divisible by 1 million:\n", dm);
   for ( i = 0 ; i < dm ; ++i )
   {
      gmp_printf("p(%d) = %Zd\n", DivMilIndices[i], DivMil[i]);
   }

   printf("Elapsed time = %f seconds\n", HiResTime()-t0);

   return 0; 
}

#if 0

/* These were my earlier, failed attempts at solving this problem;
I #if'ed these out to speed compilation and moved them down here: */

UL P_K (UL left, UL n, UL k)
/*
"left" is size of stack to our left (or n if none).
"n" is number to be partitioned.
"k" is number of partitions.
*/
{
   /* Declare and zero all non-parameter variables here: */
   UL p      = 0;
   UL first  = 0;
   /* Assert that k >= 1 : */
   assert(k>=1);

   /* Assert that k <= n : */
   assert(k<=n);

   /* If k is 1 or n, then there's only one way of partitioning n 
   into k partitions: */
   if (k == 1 || k == n)
   {
      p = 1;
   }

   /* Otherwise, first pile can have at-most n-(k-1) coins,
   and at-least (int)ceil((double)n/(double)k) coins: */
   else
   {
      UL upr;
      UL lwr;

      /* The upper limit for our first stack is n-(k-1), or the size of the stack
      to our left (if any), whichever is smaller. This is because we need to allow
      1 coin for each of the not-yet-inhabited stacks, and because we can't allow
      current "first" stack to be any larger than the stack to the left of it 
      (if any). A pure recursive approach, hence, won't work, because max first 
      stack for P_K(2,2) is 3 only if the stack to the LEFT of it is 3 or larger; 
      else max first stack for P_K(2,2) is "left". */
      upr = n-(k-1); if (upr > left) {upr = left;}

      /* The lower limit for our first stack cannot be less than n/k, else we'd 
      force at least one of the stacks to our right to larger than current first
      stack, which would cause duplicate partitions. */
      lwr = (UL)ceil((double)n/(double)k);

      for ( first = upr ; first >= lwr ; --first )
      {
         p += P_K(first, n-first, k-1);
      }
   }
   return p;
}

UL P (UL n)
{
   UL k = 0;
   UL p = 0;

   for ( k = 1 ; k <= n ; ++k )
   {
      p += P_K (n, n, k);
   }
   return p;
}

UL P2 (UL n, UL m)
{
    if (n == m)
        return 1 + P2(n, m - 1);
    if (m == 0 || n < 0)
        return 0;
    if (n == 0 || m == 1)
        return 1;
    return P2(n, m - 1) + P2(n - m, m);
}

#endif
