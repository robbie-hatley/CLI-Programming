/****************************************************************************\
 * File name:    Euler-047_Distinct-Prime-Factors.c
 * Source for:   Euler-047_Distinct-Prime-Factors.exe
 * Author:       Robbie Hatley
 * Written:      Fri Feb 09, 2018.
\****************************************************************************/

#include <stdio.h>
#include <sys/time.h>

int DistinctPrimeFactors(int n)
{
   int count = 0;
   int i = 2;

   if ( n < 2 ) return 0;

   if ( 0 == n%i ) ++count; 
   while ( 0 == n%i )
   {
      n/=i;
   }

   for ( i=3 ; i<=n ; i+=2 )
   {
      if ( 0 == n%i ) ++count;
      while (0==n%i) 
      {
         n/=i;
      }
   }
   return count;
}

double HiResTime (void)
{
   struct timeval t;
   gettimeofday(&t, NULL);
   return (double)t.tv_sec + (double)t.tv_usec / 1000000.0;
}

int main(void)
{
   static int DPF[1000010] = {0, 0, 1, 1, 1, 1, };
   int i;
   double t0;

   t0 = HiResTime();

   for ( i = 6 ; i <= 1000000 ; ++i )
   {
      DPF[i] = DistinctPrimeFactors(i);
      if (4 == DPF[i-3] && 4 == DPF[i-2] && 4 == DPF[i-1] && 4 == DPF[i-0] )
      {
         printf("%d %d %d %d\n", i-3, i-2, i-1, i-0);
         break;
      }
   }

   printf("Elapsed time = %f\n", HiResTime()-t0);

   return 0;
}
