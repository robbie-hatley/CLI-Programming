/*
"Euler-039_Integer-Right-Triangles.c"
Solves problem 39 of Project Euler, "Integer Right Triangles",
which asks "What perimeter, not greater than 1000, has the greatest number
of integer right triangles?"
Author:  Robbie Hatley
Written: Tue Jan 30, 2018
*/
#include <stdio.h>
int main (void)
{
   int a, b, c, p, limit;
   int MaxPerim     = 0;
   int NumSols      = 0;
   int MaxNumSols   = 0;
   /* Defining equations and inequalities:
    * 1<=a     a<=b      b<=c
    * a+b>c (else it's not an actual triangle)
    * p=a+b+c  p>=3      p<=1000   
    * a*a+b*b==c*c (else it's not a right triangle)
    *
    * Derived equations and inequalities:
    * (b<=c  && c=p-a-b    ) => b<=p-a-b => 2b<=p-a => b<=(p-a)/2
    * (a<=b  && b<=(p-a)/2 ) => a<=(p-a)/2 => 2a<=p-a => 3a<=p
    * (a+b>c && c=p-a-b    ) => a+b>p-a-b => 2(a+b)>p => a+b>p/2 => b>p/2-a
    * HENCE: a[min]=1, a[max]=p/3, b[min]=max(a, p/2-a+1), b[max]=(p-a)/2
    */
   for ( p = 3 ; p <= 1000 ; ++p ) /* Perimeters from 3 through 1000. */
   {
      NumSols = 0; /* Number of solutions for this perimeter. */
      for ( a = 1 ; 3*a<=p ; ++a )
      {
         limit = p/2 - a + 1;
         for ( b = a > limit ? a : limit ; c=p-a-b , b<=c ; ++b )
         {
            if (a<1 || b<1 || c<1 || p<3 || a>b || b>c || a+b<=c)
            {
               fprintf(stderr, "out of bounds: %d %d %d %d\n", a, b, c, p);
               continue;
            }
            if (a*a + b*b == c*c)
            {
               printf("Solution: %d %d %d %d\n", a, b, c, p);
               ++NumSols;
            }
         }
      }
      if (NumSols > MaxNumSols)
      {
         MaxPerim = p;
         MaxNumSols = NumSols;
      }
   }
   printf
   ("Maximum # of solutions was %d, attained at a perimeter of %d.\n", 
   MaxNumSols, MaxPerim);
   return 0;
}
