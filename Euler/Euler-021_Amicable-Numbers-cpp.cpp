/*****************************************************************************\
 * Program name:  Euler 21 - Amicable Numbers
 * Description:   Prints sum of Amicable numbers under 10000.
 * File name:     Euler-021_Amicable-Numbers.cpp
 * Source for:    Euler-021_Amicable-Numbers.exe
 * Author:        Robbie Hatley
 * Edit history:
 *    Wed Jan 10, 2018 - Wrote it.
\*****************************************************************************/

#include <iostream>

// Return sum of proper divisors of a number:
int div_sum (int x)
{
   int sum = 0;
   int a;
   for ( a = 1 ; a < x ; ++a )
   {
      if ( 0 == x % a )
      {
         sum += a;
      }
   }
   return sum;
}

// Are two numbers amicable? (If they are, then they can be amicable with
// no other numbers, because if div_sum(a) is b, then no number other than
// b can be div_sum(a); an if div_sum(b) ia a, then no number other than
// a can be div_sum(b). So there are no amicable trios, quartets, etc,
// only pairs.)
int are_amicable (int a, int b)
{
   return div_sum(a) == b && div_sum(b) == a;
}

int main(void)
{
   int s = 0;
   int a = 0;
   int b = 0;
   for ( a = 1 ; a < 10000 ; ++a )
   {
      for ( b = a + 1 ; b < 10000 ; ++b )
      {
         if (are_amicable(a,b))
         {
            std::cout << "Amicable pair: " << a << " " << b << std::endl;
            s += a;
            s += b;
         }
      }
   }
   std::cout << "Sum of all amicable numbers under 10000 = " << s << std::endl;
   return 0;
}
