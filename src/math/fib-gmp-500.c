// fib500.c

#include <stdio.h>
#include <gmp.h>

int main (void)
{
   int i;
   mpz_t a,b,c;

   mpz_init_set_ui(a, 1);
   gmp_printf("%110Zd\n", a);
   mpz_init_set_ui(b, 1);
   gmp_printf("%110Zd\n", a);
   mpz_init(c);
   for ( i = 2 ; i < 500 ; ++i )
   {
      mpz_add(c,a,b);
      gmp_printf("%110Zd\n", c);
      mpz_set(a,b);
      mpz_set(b,c);
   }

   return 0;
}
