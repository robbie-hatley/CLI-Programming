/*****************************************************************************\
 * Program name:  Euler 21 - Amicable Numbers
 * Description:   Prints sum of Amicable numbers under 10000.
 * File name:     Euler-021_Amicable-Numbers-c2.c
 * Source for:    Euler-021_Amicable-Numbers.exe
 * Author:        Robbie Hatley
 * Edit history:
 *    Wed Jan 10, 2018: Wrote it.
 *    Wed Jan 10, 2018: Limited divisor checks and converted from C++ to C.
 *    Wed Jan 10, 2018: Created array of sums-of-divisors, so that no number
 *                      has it's sum-of-divisors calculated more than once.
\*****************************************************************************/

#include <stdio.h>
#include <time.h>

int div_sum (int x);
int are_amicable (int a, int b);

/* Global Variables: */
int divsums[10005] = {0};

/* Return sum of proper divisors of a number: */
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
   return divsums[a] == b && divsums[b] == a;
}

int main(void)
{
   int      s   = 0;
   int      a   = 0;
   int      b   = 0;
   clock_t  t0  = 0;
   clock_t  t1  = 0;
   double   t2  = 0.0;

   t0 = clock();

   /* Calculate sum-of-divisors for each integer 1-9999: */
   for ( a = 1 ; a < 10000 ; ++a ) {divsums[a] = div_sum(a);}

   /* Calculate and print sum of all amicable positive integers under 10000
   by looking-up their amicability in the array we just created: */
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

   t1 = clock();
   t2 = (double)(t1-t0)/(double)CLOCKS_PER_SEC;
   printf("Expired time = %f seconds\n", t2);

   return 0;
}
