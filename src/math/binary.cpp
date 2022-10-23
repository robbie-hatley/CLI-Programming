/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * binary.cpp
 * A program which shows the bits of an int variable
 * Written Tuesday July 24, 2001 by Robbie Hatley
 * Last updated 2001-07-24
 * Input: a single integer command-line argument
 * Output: a binary representation of the contents of the int variable
 *   used to store that integer
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <cstring>
#include <cctype>
#include <cmath>

using std::cout;
using std::cerr;
using std::endl;

int main(int argc, char *argv[])
{
   if (2 != argc)
   {
      cerr 
         << "Error: binary.exe takes exactly one argument, which must be a positive" << endl
         << "decimal integer not greater than 2147483647 to be converted to binary." << endl;
      return 666;
   }
   int number;                          // the number we're examining
   int mask;                            // bit mask to extract bits of number
   int test;                            // masked number (number&mask)
   unsigned short int bit;     // a bit of number
   unsigned short int i;       // a counter
   number=atoi(argv[1]);                // number = integer-convertion of CL arg.
   for (i=8*sizeof(number) ; i>0 ; --i) // iterate back through bits
   {
      mask=1<<(i-1);                     // mask = single bit at position i
      test=number&mask;                  // test = masked number
      if (test!=0) bit=1;                // set bit = 1 if test is non-zero
      else bit=0;                        // set bit = 0 if test is zero
      cout << bit;                       // display bit
   }
   cout << '\n';
   return 0;
}

