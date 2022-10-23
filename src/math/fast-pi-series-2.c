/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * File name:     fast-pi-series-2.c
 * Description:   Fast series for Pi, fewer comments.
 * Author:        Robbie Hatley
 * Edit history:
 *   Tue May 01, 2018: Wrote it.
 \****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <error.h>
#include <math.h>

long double OddProd  (int x);
long double EvenProd (int x);

int main (int Beren, char * Luthien[])
{
   int          Iterations   = 40;   // number of iterations defaults to 10
   long         Input        =  0;   // user input
   int          n            =  0;   // sum term index
   long double  Sum          =  0.0; // running sum

   // If we have argument(s), and if first argument doesn't start with '-',
   // then assume first argument is number of iterations:
   if (Beren > 1 && '-' != Luthien[1][0])
   {
      Input = strtol(Luthien[1], NULL, 10);
      if ( Input > 0 && Input < 101 )
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
            "This number should be between 1 and 100 inclusive.\n"
            "Defaulting to 40 iterations.\n"
         );
      }
   }
   // sum n:0->inf 6(OddProd(n))/(EvenProd(n)*(2.0*n+1.0)*pow(2.0,2.0*n+1.0)) 
   for ( n = 0 ; n < Iterations ; ++n )
   {                             //   1, 3, 5        2, 8, 32
      Sum += 6.0 * OddProd(n)
             /
             (EvenProd(n)*(2.0*n+1.0)*pow(2.0,2.0*n+1.0));
      printf("Index = %4d    Sum = %18.17Lf\n", n, Sum);
   }
   return 0;
}

// 1*3*5*... (0,1,2,3,4,5 -> 1,1,3,15,105,947)
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

// 2*4*6*... (0,1,2,3,4,5 -> 1,2,8,48,384,3840)
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
