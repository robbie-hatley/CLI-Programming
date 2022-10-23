// This is a 100-character-wide ASCII-encoded C source-code text file.
//=======|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/**************************************************************************************************\
 * Program name:  Robbie Hatley's Unlimited Fibonacci Sequence Generator
 * Description:   Generates and prints as many elements of The Fibonacci Sequence as the user
 *                indicates with a command-line argument, which must be an integer in the range of
 *                3 through 2 billion.
 * File name:     fib.cpp
 * Source for:    fib.exe
 * Author:        Robbie Hatley
 * Date written:  2013-05-06
 * Edits:         2020-10-27: Structured as functions and cleaned-up comments & formatting.
 * Inputs:        None.
 * Outputs:       Generates and prints elements of The Fibonacci Sequence.
 * To make:       Compile with g++ and link with Robbie Hatley's library "rhmath".
\**************************************************************************************************/


// "fibonacci.cpp"
// Robbie Hatley's Nifty Fibonacci Sequence Generator

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

void args_error_msg (void)
{
   cerr
   << "Error in Fibonacci: this program requires exactly one argument," << endl
   << "which must be a positive integer >= 3, indicating number of"     << endl
   << "elements of The Fibonacci Sequence to compute and print."        << endl;
   return;
}

void range_error_msg (void)
{
   cerr
   << "Error in Fibonacci: this program requires exactly one argument," << endl
   << "which must be a positive integer >= 3, indicating number of"     << endl
   << "elements of The Fibonacci Sequence to compute and print."        << endl;
   return;
}

void help_msg (void)
{
   cout
   << "Welcome to Robbie Hatley's Fibonacci Sequence generator. This program "  << endl
   << "generates and prints as many elements of The Fibonacci Sequence as the " << endl
   << "user indicates with a command-line argument. For example, the command "  << endl
   << "\"fibonacci 17\" prints the first 17 elements. The number of elements "  << endl
   << "to be printed must be at least 3."                                       << endl;
   return;
}

int main(int Beren, char * Luthien[])
{
   if (2 <= Beren && (std::string("-h") == Luthien[1] || std::string("--help") == Luthien[1]))
   {
      return 777;
   }

   if (2 != Beren)
   {
   }

   int n  = atoi(Luthien[1]);

   if (3 > n)
   {
      return 666;
   }

   int             i     = 0;
   rhmath::BigNum  a     = rhmath::BigNum(1);
   rhmath::BigNum  b     = rhmath::BigNum(1);
   rhmath::BigNum  c     = rhmath::BigNum(0);
   
   cout << std::setw(65) << a << endl;
   cout << std::setw(65) << b << endl;

   for ( i = 3 ; i <= n ; ++i )
   {
      c = a + b;
      cout << std::setw(65) << c << endl;
      a = b;
      b = c;
   }

   return 0;
}

