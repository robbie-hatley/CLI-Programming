/*****************************************************************************\
 * Program name:  Euler 23 - Abundant Numbers
 * Description:   Prints sum of all positive integers which cannot be written
 *                as the sum of two abundant numbers.
 * File name:     Euler-023_Abundant-Numbers.c
 * Source for:    Euler-023_Abundant-Numbers.exe
 * Author:        Robbie Hatley
 * Edit history:
 *    Wed Jan 10, 2018 (11PM): Started writing it.
 *    Thu Jan 11, 2018 ( 1AM): Finished. Worked fine on first try.
\*****************************************************************************/

#include <stdio.h>
#include <time.h>

int div_sum (int x);
void load_abundant (void);

/* Global Variables: */
int Abundant[28123] = {0};

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

// For each integer in [1, 28123], determine if it's abundant:
void load_abundant (void)
{
   int i;
   int divsum;
   for ( i = 1 ; i <= 28123 ; ++i )
   {
      divsum = div_sum(i);
      if (divsum > i) {Abundant[i] = 1;}
   }
   return;
}

int main(void)
{
   int      s        = 0;
   int      i        = 0;
   int      a        = 0;
   int      b        = 0;
   int      ab_flag  = 0;
   clock_t  t0       = 0;
   clock_t  t1       = 0;
   double   t2       = 0.0;

   t0 = clock();

   /* Find all abundant numbers in [1, 28123]: */
   load_abundant();

   /* Find the sum of all the positive integers which cannot be written as 
   the sum of two abundant numbers: */
   for ( i = 1 ; i <= 28123 ; ++i )
   {
      ab_flag = 0;
      /* Iterate a starting at 12 (the first abundant), through i/2, 
      setting b = i - a for each a, and see if both and b are abundant: */
      for ( a = 12 ; a <= i/2 ; ++a)
      {
         b = i - a; /* hence i = a + b */
         if (Abundant[a] && Abundant[b]) /* if a and b are both abundant */
         {
            ab_flag = 1;                 /* set flag                     */
            break;
         }
      }
      /* If ab_flag is still 0 here, this number can't be expressed as
      the sum of two abundant numbers: */
      if (!ab_flag)
      {
         printf("%d can't be expressed as the sum of 2 abundant numbers.\n", i);
         s += i;
      }
   }

   printf("The sum of all positive integers which cannot be written as\n");
   printf("the sum of two abundant numbers = %d\n", s);

   t1 = clock();
   t2 = (double)(t1-t0)/(double)CLOCKS_PER_SEC;
   printf("Elapsed time = %f seconds\n", t2);

   return 0;
}
