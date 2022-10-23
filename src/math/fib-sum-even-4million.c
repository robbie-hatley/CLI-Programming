// This is a 90-character-wide ASCII-encoded C source-code text file.
//=======|=========|=========|=========|=========|=========|=========|=========|=========|

/****************************************************************************************\
 * Program name:  fib-sum-even-4million
 * Description:   Prints sum of all even fibonacci numbers <=4M.
 * File name:     fib-sum-even-4million.c
 * Source for:    fib-sum-even-4million.exe
 * Author:        Robbie Hatley
 * Date written:  2013-05-06
 * Edited:        2020-10-27: Cleaned-up comments and formatting.
 * Inputs:        None.
 * Outputs:       Prints sum of all even fibonacci numbers <=4M.
 * To make:       Compile with GCC
\****************************************************************************************/

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
   long int a = 1;
   long int b = 2;
   long int c = 3;
   long int d = 2;
   while ( c <= 4000000L )
   {
      if (0==(c%2))
      {
         d+=c;
      }
      a=b;
      b=c;
      c=a+b;
   }
   printf("Sum of all even fibonacci numbers not more than 4 million = %8ld\n", d);
   return 0;
}

