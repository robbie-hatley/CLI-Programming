/*****************************************************************************\
 * Program name:  Euler 21 - Amicable Numbers
 * Description:   Prints sum of Amicable numbers under 10000.
 * File name:     Euler-021_Amicable-Numbers.c
 * Source for:    Euler-021_Amicable-Numbers.exe
 * Author:        Robbie Hatley
 * Edit history:
 *    Wed Jan 10, 2018: Wrote it.
 *    Wed Jan 10, 2018: Limited divisor checks and converted from C++ to C.
\*****************************************************************************/

#include <stdio.h>
#include <time.h>

int div_sum (int x);
int are_amicable (int a, int b);

// Return sum of proper divisors of a number:
int div_sum (int x)
{
   int sum = 0;
   int a;
   int x_a;
   for ( a = 1 ; a * a <= x ; ++a )
   {
      if ( 0 == x % a )
      {
         x_a = x/a;
         if (a == 1)
         {
            sum += a; 
            continue;
         }
         else if (a < x_a)
         {
            sum += a; 
            sum += x_a; 
            continue;
         }
         else if (a == x_a) 
         {
            sum += a; 
            break;
         }
         else
         {
            break;
         }
      }
   }
   return sum;
}

// Are two numbers amicable? (If they are, then they can be amicable with
// no other numbers, because if div_sum(a) is b, then no number other than
// b can be div_sum(a); an if div_sum(b) is a, then no number other than
// a can be div_sum(b). This is because "sum of divisors" for any integer x
// is invariant. So there are no amicable trios, quartets, etc, only pairs.)
int are_amicable (int a, int b)
{
   return div_sum(a) == b && div_sum(b) == a;
}

int main(void)
{
   int     s   = 0;
   int     a   = 0;
   int     b   = 0;
   time_t  t0  = time(NULL);
   
   for ( a = 1 ; a < 10000 ; ++a )
   {
      for ( b = a + 1 ; b < 10000 ; ++b )
      {
         if (are_amicable(a,b))
         {
            printf("Amicable pair: %d %d\n", a, b);
            s += a;
            s += b;
         }
      }
   }
   printf("Sum of all amicable numbers under 10000 = %d\n", s);
   printf("Expired time = %ld seconds\n", time(NULL)-t0);
   return 0;
}
