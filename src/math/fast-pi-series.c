/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * File name:     fast-pi-series.c
 * Description:   Tests a fast series for Pi.
 * Edit history:
 *   Wed Jun 06, 2001: Starting writing it.
 *   Sun Jun 24, 2001: Edited it.
 *   Sat Oct 23, 2004: Edited it some more.
 *   Mon Apr 06, 2015: This is obviously a project I never finished.
 *                     unfortunately, I don't remember what this was supposed
 *                     to do. As-written, it calculates the following series: 
 *                     3/2 + 3/24 + 3/160 + ...  Which, frankly, doesn't make 
 *                     any sense at all and I'm not sure it even converges to 
 *                     ANYTHING, much less to something useful.
 *   Tue May 01, 2018: I finally implemented the two functions marked "STUB"
 *                     and named "EvenProd" and "OddProd". I figure they were
 *                     intended to be "even product" and "odd product", so I
 *                     defined them so the give 1*3*5*8*... and 2*4*6*8*... .
 *                     On doing that this program quickly converged to 3+Pi/2 !
 *                     So I tweaked it a little and now it converges to Pi
 *                     very rapidly, about 16 sig figs in 22 iterations!
 *                     WHAT FORMULA IS THIS???
 \****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <error.h>
#include <math.h>

double OddProd  (int x);
double EvenProd (int x);

int main (int Beren, char * Luthien[])
{
   int       Iterations   = 25;   // number of iterations defaults to 10
   long      Input        =  0;   // user input
   int       Index        =  1;   // iterator
   double    Sum          =  0.0; // running sum

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
            "Defaulting to 25 iterations.\n"
         );
      }
   }
   for ( Index = 0 ; Index < Iterations ; ++Index )
   {                             //   1, 3, 5        2, 8, 32
      // v = v + 3.0 * OddProd(i)
      //         /
      //         (EvenProd(i)*(2.0*i+1.0)*pow(2.0,2.0*i+1.0));
      // NOTE RH 2018-05-01: on implementing the "EvenProd" and "OddProd"
      // functions, and on changing V0 from 3.0 to 0.0, this converges to 
      // Pi/2, VERY QUICKLY! Changing the "3.0" to "6.0" should yield a 
      // lovely formula for Pi!
      Sum += 6.0 * OddProd(Index)
             /
             (EvenProd(Index)*(2.0*Index+1.0)*pow(2.0,2.0*Index+1.0));
      printf("Index = %4d    Sum = %1.15f\n", Index, Sum);
   }
   return 0;
}

// ECHIDNA RH 2015-04-06: This program isn't going to do much until 
// I implement the following; but alas, I no longer remember what
// the hell I had in mind:

// Note RH 2018-02-21: This is almost certainly something like
// 1*3*5*7*... and 2*4*6*8*....

// NOTE RH 2018-05-01: Yep, on implementing these, this program 
// converges to Pi very quickly!!!

double OddProd(int x)
{
   int i;
   double Prod = 1.0;
   for ( i = 0 ; i < x ; ++i )
   {
      Prod *= (2.0*i+1);
   }
   return Prod;
}

double EvenProd(int x)
{
   int i;
   double Prod = 1.0;
   for ( i = 0 ; i < x ; ++i )
   {
      Prod *= (2.0*i+2);
   }
   return Prod;
}
