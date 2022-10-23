/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/****************************************************************************\
 * divisors.c                                                               *
 * This is a 78-character-wide ASCII C source-code text file.               *
 * Prints all of the positive-integer divisors of a given positive integer. *
 *                                                                          *
 * Author: Robbie Hatley                                                    *
 * Date Written: Wed Feb 17, 2016.                                          *
\****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int Fred, char* Ethel[])
{
   unsigned long  i       = 0;
   unsigned long  Number  = 0;
   
   if (Fred != 2) {return 666;}

   Number = strtoull(Ethel[1], NULL, 10);

   for ( i = 1 ; i <= Number ; ++i )
   {
      if (0 == Number % i)
      {
         printf(" %lu", i);
      }
   }
   return 0;
}
