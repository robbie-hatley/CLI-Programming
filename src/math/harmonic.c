/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/***************************************************************************************\
 * File name:     harmonic.c
 * Description:   Tests convergence of series 1/1 - 1/2 + 1/3 - 1/4 + 1/5 - 1/6...
 *                Apparently converges to ln(2), but very, very slowly.
 * Date written:  Tue Apr 07, 2015
 * Edit history:
 *    Tue Apr 17, 2015 - Wrote it.
 * 
 * Note, RH, 2015-04-07: Seems to converge to ln(2). However, it converges exceedingly 
 * slowly, needing over 3,000,000 iterations just to get 6 sig figs of accuracy.
 \***************************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <math.h>

int main(int argc, char *argv[])
{
   long int      i        = 0L;
   long int      limit    = 10L;
   long double   v        = 0.0L;

   if (argc >= 2)
   {
      limit = (long int)atoi(argv[1]);
   }

   printf("Convergence test of series 1/1 - 1/2 + 1/3 - 1/4...:\n");

   for ( i = 1L ; i <= limit ; ++i )
   {
      v = v + (2L*(i%2L)-1L) * 1.0L / i;
      printf("i = %10li          v = %2.14Lf\n", i, v);
   }
   return 0;
}

