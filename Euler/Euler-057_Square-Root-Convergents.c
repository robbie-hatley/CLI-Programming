// Euler-057_Square-Root-Convergents.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <gmp.h>
#include <rhutilc.h>
#include <rhmathc.h>

int main (void)
{
   unsigned  i;
   mpz_t     p1;
   mpz_t     q1;
   mpz_t     t1;
   mpz_t     p;
   mpz_t     q;
   char*     ps;
   char*     qs;
   size_t    pl;
   size_t    ql;
   double    pd;
   double    qd;
   long      pe;
   long      qe;
   double    r;
   unsigned  Count = 0;
   double    t0;

   t0 = HiResTime();
   mpz_init_set_ui(p1,3);
   mpz_init_set_ui(q1,2);
   mpz_init(t1);
   mpz_init(p);
   mpz_init(q);
   for ( i = 2 ; i <= 1000 ; ++i )
   {
      mpz_mul_ui(t1,q1,2); // t1 = 2*q1
      mpz_add(p, p1, t1);  // p  = p1 + 2*q1
      mpz_add(q, p1, q1);  // q  = p1 + 1*q1
      pd = mpz_get_d_2exp(&pe, p);
      qd = mpz_get_d_2exp(&qe, q);
      r = pow(2,(double)(pe-qe))*(pd/qd);
      ps = mpz_get_str(NULL, 10, p);
      qs = mpz_get_str(NULL, 10, q);
      pl = strlen(ps);
      ql = strlen(qs);
      printf("\ni = %u\n", i);
      printf("p = %s\n", ps);
      printf("q = %s\n", qs);
      printf("Ratio = %1.14f\n", r);
      printf("p digits = %lu\n", pl);
      printf("q digits = %lu\n", ql);
      if (pl > ql)
      {
         ++Count;
         printf("GREATER\n");
      }
      free(ps); ps = NULL; 
      free(qs); qs = NULL;
      mpz_set(p1,p);
      mpz_set(q1,q);
   }
   printf("Ratio = %f\n", r);
   printf("Count = %u\n", Count);
   printf("Elapsed time = %f seconds.\n", HiResTime()-t0);
   return 0;
}
