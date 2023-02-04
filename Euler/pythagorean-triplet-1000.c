
/****************************************************************************\
 * pythagorean-triplet-1000.c                                               *
 * This is a 78-character-wide ASCII C source-code text file.               *
 * Finds product-of-sides for the only pythagorean triplet with sum=1000.   *
 *                                                                          *
 * Problem:                                                                 *
 * A Pythagorean triplet is a set of three natural numbers,                 *
 * a < b < c, for which, a2 + b2 = c2                                       *
 * For example, 32 + 42 = 9 + 16 = 25 = 52.                                 *
 * There exists exactly one Pythagorean triplet for which                   *
 * a + b + c = 1000. Find the product abc.                                  *
\****************************************************************************/

#include <stdio.h>

int main (void)
{
   auto int a = 0;
   auto int b = 0;
   auto int c = 0;
   for ( a = 1 ; a <= 1000 ; ++a )
   {
      for ( b = a + 1 ; b <= 1000 ; ++b )
      {
         for ( c = b + 1 ; c <= 1000 ; ++c )
         {
            if ( a + b + c == 1000 && a*a + b*b == c*c )
            {
               goto FOUND;
            }
         }
      }
   }
   goto LOST;
LOST:
   printf("Didn't find answer.\n");
   return 666;
FOUND:
   printf("Found answer.\n");
   printf("a = %d, b = %d, c = %d\n", a, b, c);
   printf("a + b + c = %d\n", a+b+c);
   printf("a * b * c = %d\n", a*b*c);
   return 0;
}

