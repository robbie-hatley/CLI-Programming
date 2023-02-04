/*
"Euler-044_Pentagon-Numbers.c"
Attempts to solve problem 44 of Project Euler, "Pentagon Numbers".
Author:  Robbie Hatley
Written: Mon Feb 05, 2018
*/

#include <stdio.h>
#include <sys/time.h>

#define SIZE 10000

int pentagons[SIZE] = {0};

void MakePentagons (void)
{
   int n;
   for ( n = 0 ; n < SIZE ; ++n )
   {
      pentagons[n] = n*(3*n-1)/2;
   }
   return;
}

int IsPentagon (int value)
{
   int i;

   for ( i = 0 ; i < SIZE ; ++i )
   {
      if (value == pentagons[i]) return i;
      if (value  < pentagons[i]) break;
   }
   return 0;
}

double HiResTime (void)
{
   struct timeval t;
   double td;
   gettimeofday(&t, NULL);
   td=(double)(t.tv_sec)+(double)(t.tv_usec)/1000000.0;
   return td;
}

int main(void)
{
   int i, j, k, l, sum, diff;
   double t0;

   t0=HiResTime();

   MakePentagons();

   for ( i = 1 ; i < SIZE ; ++i )
   {
      for ( j = 1 ; j < SIZE ; ++j )
      {
         for ( k = j+1 ; k < SIZE ; ++k )
         {
            diff = pentagons[k]-pentagons[j];
            if (diff  > pentagons[i]) break;
            if (diff == pentagons[i])
            {
               sum = pentagons[k]+pentagons[j];
               if ( ( l = IsPentagon(sum) ) )
               {
                  printf("Pentagonal number #%d: %d\n", j, pentagons[j]);
                  printf("Pentagonal number #%d: %d\n", k, pentagons[k]);
                  printf("Sum = pentagonal number #%d = %d\n", l, sum);
                  printf("Difference = pentagonal number #%d = %d\n", i, diff);
                  goto END;
               }
               else
               {
                  break;
               }
            }
         }
      }
   }
   printf("Didn't find minimal difference in first %d pentagonal numbers.\n", SIZE);
   END:
   printf("Elapsed time = %f seconds\n", HiResTime() - t0);
   return 0; 
}
