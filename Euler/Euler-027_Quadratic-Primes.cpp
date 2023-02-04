/*****************************************************************************\
 * Program:     Euler Project, Problem 27: Quadratic Primes
 * File name:   Euler-27_Quadratic-Primes.cpp
 * Source for:  Euler-27_Quadratic-Primes.exe
 * Description: Finds ab for which n^2 + an + b (|a|<1000 and |b|≤1000)
 *              generates the maximal number of consecutive primes
 * Author:      Robbie Hatley
 * Edit History:
 *   Sat Jan 13, 2018: Wrote it. Took about 2hrs. Worked fine on first try. 
\*****************************************************************************/
#include <iostream>
#include <ctime>
#include "rhmath.hpp"
int main (void)
{
   long     a   = 0;
   long     b   = 0;
   long     c   = 0;
   long     d   = 0;
   long     n   = 0;
   long     y   = 0;
   long     r   = 0;
   long     p   = 0;
   clock_t  t0  = 0;
   clock_t  t1  = 0;
   double   t2  = 0.0;

   t0 = clock();

   for ( a = -999L ; a <= 999L ; ++a )
   {
      for ( b = -1000L ; b <= 1000L ; ++b )
      {
         for ( n = 0L ; ; ++n )
         {
            y = n*n + a*n + b;
            if (!rhmath::PrimeTable::PrimeDecider(y)) {break;}
         }
         if (n > r) {r = n; c = a; d = b; p = a*b;}
      }
   }
   std::cout << "Longest run length = " << r << std::endl;
   std::cout << "a = " << c << std::endl;
   std::cout << "b = " << d << std::endl;
   std::cout << "ab = " << p << std::endl;

   t1 = clock();
   t2 = double(t1-t0)/double(CLOCKS_PER_SEC);
   printf("Expired time = %f seconds\n", t2);

   return 0;
}
