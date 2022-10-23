// This is a 100-character-wide ASCII-encoded C source-code text file.
//=======|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/**************************************************************************************************\
 * Program name:  fib-index-for-digits
 * Description:   Prints the index of the first element of The Fibonacci Sequence which has
 *                the number of digits indicated by the command-line argument, which must be
 *                a positive integer >= 3.
 * File name:     fib-index-for-digits.cpp
 * Source for:    fib-index-for-digits.exe
 * Author:        Robbie Hatley
 * Date written:  2013-05-06
 * Edits:         2020-10-27: Renamed and cleaned-up comments & formatting.
 * Inputs:        None.
 * Outputs:       Prints sum of all even fibonacci numbers <=4M.
 * To make:       Compile with g++ and link with Robbie Hatley's library "rhmath".
\**************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cstdio>
#include <string>

//#define BLAT_ENABLE

#include "rhmath.hpp"

using std::cout;
using std::cerr;
using std::endl;

int main(int Beren, char * Luthien[])
{
   if (2 <= Beren && (std::string("-h") == Luthien[1] || std::string("--help") == Luthien[1]))
   {
      cout
      << "Welcome to Robbie Hatley's \"Fibonacci Index For Digits\". This program" << endl
      << "prints the index of the first element of The Fibonacci Sequence which "  << endl
      << "has the number of digits indicated by the command-line argument, which " << endl
      << "must be a positive integer >= 3."                                        << endl;
      return 777;
   }

   if (2 != Beren)
   {
      cerr
      << "Error in Fibonacci: this program requires exactly one argument," << endl
      << "which must be a positive integer >= 2, indicating number of"     << endl
      << "digits of The Fibonacci Sequence to compute the index for."      << endl;
      return 666;
   }

   std::string::size_type n  = atoi(Luthien[1]);

   if (2 > n)
   {
      cerr
      << "Error in Fibonacci: this program requires exactly one argument," << endl
      << "which must be a positive integer >= 2, indicating number of"     << endl
      << "digits of The Fibonacci Sequence to compute the index for."      << endl;
      return 666;
   }

   int             i     = 0;
   rhmath::BigNum  a     = rhmath::BigNum(1);
   rhmath::BigNum  b     = rhmath::BigNum(1);
   rhmath::BigNum  c     = rhmath::BigNum(0);
   
   for ( i = 3 ;  ; ++i )
   {
      c = a + b;
      if (c.str().length() >= n)
      {
         cout << i << endl;
         return 0;
      }
         
      a = b;
      b = c;
   }
}

