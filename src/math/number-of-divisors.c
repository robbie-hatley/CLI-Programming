/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/****************************************************************************\
 * number-of-divisors.c                                                     *
 * This is a 78-character-wide ASCII C source-code text file.               *
 * Prints the number of divisors of the positive integer given by the first *
 * command-line argument.                                                   *
 *                                                                          *
 * Author: Robbie Hatley                                                    *
 * Date Written: Wed Feb 17, 2016.                                          *
\****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int Fred, char* Ethel[])
{
   uint64_t     i           = 0;
   uint64_t     Number      = 0;
   uint64_t     Count       = 0;
   
   if (Fred != 2) {return 666;}

   Number = strtoull(Ethel[1], 0, 10);

   for ( i = 1 ; i <= Number ; ++i )
   {
      if (0 == Number % i)
      {
         ++Count;
      }
   }
   printf("%ju", Count);
   return 0;
}
