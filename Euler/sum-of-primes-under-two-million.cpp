/****************************************************************************\
 * Program:     Primes In Range
 * File name:   sum-of-primes-under-two-million.cpp
 * Source for:  sum-of-primes-under-two-million.exe
 * Description: Prints the sum of all prime numbers under two million.
 * Author:      Robbie Hatley
 * Edit History:
 *   Mon Feb 15, 2016 - Wrote it.
\****************************************************************************/
#include <iostream>
#include "rhmath.hpp"
int main (void)
{
   rhmath::PrimeTable Table;
   long Sum = Table.GeneratePrimesInRange(2L, 1999999L, false, false);
   std::cout << Sum << std::endl;
   return 0;
}
