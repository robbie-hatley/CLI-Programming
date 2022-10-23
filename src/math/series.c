/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/***************************************************************************************\
 * File name:     series.c
 * Description:   Tests convergence of series 1/2 - 1/3 + 1/4 - 1/5 + 1/6 - 1/7...
 * Date written:  2001-06-24
 * Edit history:
 *    Sat Oct 23, 2004 - Edited.
 *    Mon Apr 06, 2015 - Cleaned up and corrected comments.
 * 
 * Note, RH, 2015-04-07: Seems to converge to (1 - ln(2)), or about 0.3068528...
 * However, it converges exceedingly slowly, needing over 10,000,000 iterations just
 * to get 7 sig figs of accuracy.
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

   printf("Convergence test of series 1/2 - 1/3 + 1/4 - 1/5...:\n");

   for ( i = 0L ; i <= limit ; ++i )
   {
      v = v + (2L*((i+1L)%2L)-1L) * 1.0L / (i + 2L);
      printf("i = %6li          v = %1.8Lf\n", i, v);
   }
   return 0;
}

