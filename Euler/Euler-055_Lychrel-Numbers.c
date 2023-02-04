/* Euler-055_Lychrel-Numbers.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <gmp.h>
#include <stdarg.h>

#include "rhutilc.h"
#include "rhmathc.h"

/* Invert a number: */
void mpz_Invert (mpz_t Bckward, const mpz_t Forward)
{
   char Buffer1 [105] = {'\0'};
   char Buffer2 [105] = {'\0'};
   size_t Length = 0;
   size_t i = 0;
   gmp_snprintf(Buffer1, 100, "%Zd", Forward);
   Length = strlen(Buffer1);
   for ( i = 0 ; i < Length ; ++i )
   {
      Buffer2[Length - 1 - i] = Buffer1[i];
   }
   mpz_set_str (Bckward, Buffer2, 10);
   return;
}

/* Is a given number palindromic? */
bool mpz_IsPalindrome (mpz_t Number)
{
   char Buffer [105] = {0};
   int Length = 0;
   int Half = 0;
   int i = 0;
   gmp_snprintf(Buffer, 100, "%Zd", Number);
   Length = (int)strlen(Buffer);
   Half = Length / 2 - 1;
   for ( i = Half ; i >= 0 ; --i )
   {
      if (Buffer[i] != Buffer[Length - 1 - i]) return false;
   }
   printf("In IsPalindrome; supposed palindrome: %s\n", Buffer);
   printf("Length = %d   Half = %d\n", Length, Half);
   return true;
}

/* Is a given number a Lychrel Number? */
bool IsLychrel (unsigned n)
{
   unsigned  i  = 0;
   mpz_t Forward;
   mpz_t Bckward;

   mpz_init_set_ui (Forward, n);
   mpz_init        (Bckward   );
   for ( i = 1 ; i <= 50 ; ++i )
   {
      mpz_Invert(Bckward, Forward);
      mpz_add(Forward, Forward, Bckward);
      gmp_printf ("Forward = %Zd\n", Forward);
      if (mpz_IsPalindrome(Forward))
      {
         gmp_printf ("%u formed palindrome %Zd in %u iterations\n", n, Forward, i);
         return false;
      }
   }
   gmp_printf ("%u failed to form a palindrome in %u iterations\n", n, i);
   return true;
}

int main (void)
{
   unsigned  n  = 0;
   unsigned  c  = 0;
   
   for ( n = 1 ; n < 10000 ; ++n )
   {
      if (IsLychrel(n))
      {
         ++c;
      }
   }
   printf("Found %u Lychrel numbers under 10000.\n", c);
   return 0;
}

