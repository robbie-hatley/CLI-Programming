/*
"Euler-040_Champernownes-Constant.c"
Attempts to solve problem 40 of Project Euler, "Champernowne's Constant".
Author:  Robbie Hatley
Written: Wed Jan 31, 2018
*/

#include <stdio.h>
#include <time.h>

/* What are the prefixes for each zone? */
static int prefix[8] = 
{
   0,
   9*1,
   9*1 + 90*2,
   9*1 + 90*2 + 900*3,
   9*1 + 90*2 + 900*3 + 9000*4,
   9*1 + 90*2 + 900*3 + 9000*4 + 90000*5,
   9*1 + 90*2 + 900*3 + 9000*4 + 90000*5 + 900000*6,
   9*1 + 90*2 + 900*3 + 9000*4 + 90000*5 + 900000*6 + 9000000*7
};

/* Integer Powers: */
int IntPow (int base, int exp)
{
   int i;
   int pow = 1;
   for ( i = 1 ; i <= exp ; ++i)
   {
      pow *= base;
   }
   return pow;
}

/* What zone are we in? */
int Zone(int index)
{
   int zone = 0;
   while (prefix[zone + 1] < index)
   {
      ++zone;
   }
   return zone;
}

/* What offset are we at? */
int Offset(int index)
{
   return index - prefix[Zone(index)] - 1;
}

/* What is the digit at Index? */
int Digit(int index)
{
   int zone   = Zone(index);
   int offset = Offset(index);
   int number = IntPow(10, zone) + offset/(zone+1);
   int place  = zone - offset%(zone+1);
   int digit  = number / IntPow(10,place) % 10;
   printf("index  = %d\n",   index);
   printf("zone   = %d\n",   zone);
   printf("offset = %d\n",   offset);
   printf("number = %d\n",   number);
   printf("place  = %d\n",   place);
   printf("digit  = %d\n\n", digit);
   return digit;
}

int main(void)
{
   clock_t  t0       = 0;
   clock_t  t1       = 0;
   double   t2       = 0.0;
   int      product  = 0;

   t0 = clock();
   
   product =   Digit(      1)
             * Digit(     10)
             * Digit(    100)
             * Digit(   1000)
             * Digit(  10000)
             * Digit( 100000) 
             * Digit(1000000);
   printf ("product = %d\n", product);

   t1 = clock();
   t2 = (double)(t1-t0)/(double)CLOCKS_PER_SEC;
   printf("Elapsed time = %.3f seconds\n", t2);
   return 0; 
}
