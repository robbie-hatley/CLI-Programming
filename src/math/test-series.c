/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * File name:     test-series.c
 * Description:   Tests variants of a fast series for Pi.
 * Edit history:
 *   Tue May 01, 2018: Wrote it.
 \****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <error.h>
#include <math.h>

long double OddProd  (int x);
long double EvenProd (int x);

int main (int Beren, char * Luthien[])
{
   int          Iterations   = 1000; // number of iterations defaults to 1000
   long         Input        =  0;   // user input
   int          Index        =  1;   // iterator
   long double  Sum          =  0.0; // running sum

   // If we have argument(s), and if first argument doesn't start with '-',
   // then assume first argument is number of iterations:
   if (Beren > 1 && '-' != Luthien[1][0])
   {
      Input = strtol(Luthien[1], NULL, 10);
      if ( Input >= 1 && Input < 10000001 )
      {
         Iterations = (int)Input;
      }
      else
      {
         error
         (
            0,
            0, 
            "This program takes one argument,\n"
            "which is the number of iterations.\n"
            "This number should be between 1 and 1 million inclusive.\n"
            "Defaulting to 1000 iterations.\n"
         );
      }
   }
   for ( Index = 0 ; Index <= Iterations ; ++Index )
   {
      Sum += OddProd(Index)/EvenProd(Index);
      printf("Index = %4d    Sum = %1.17Lf\n", Index, Sum);
   }
   return 0;
}

long double OddProd(int x)
{
   int i;
   long double Prod = 1.0;
   for ( i = 1 ; i <= x ; ++i )
   {
      Prod *= (2.0*i-1);
   }
   return Prod;
}

long double EvenProd(int x)
{
   int i;
   long double Prod = 1.0;
   for ( i = 1 ; i <= x ; ++i )
   {
      Prod *= (2.0*i);
   }
   return Prod;
}
