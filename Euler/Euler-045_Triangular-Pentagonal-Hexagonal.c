/*
"Euler-045_Triangular-Pentagonal-Hexagonal.c"
Solves problem 45 of Project Euler, 
"Triangular-Pentagonal-Hexagonal".
Author:  Robbie Hatley
Written: Mon Feb 05, 2018
*/

#include <stdio.h>
#include <sys/time.h>

#define SIZE 100000

unsigned long int triangles [SIZE] = {0};
unsigned long int pentagons [SIZE] = {0};
unsigned long int hexagons  [SIZE] = {0};

void MakePolygons (void)
{
   unsigned long int n;
   for ( n = 0 ; n < SIZE ; ++n )
   {
      triangles [n] = n*(n+1)/2;
      pentagons [n] = n*(3*n-1)/2;
      hexagons  [n] = n*(2*n-1);
   }
   return;
}

int IsTriangle (unsigned long int value)
{
   int i;

   for ( i = 0 ; i < SIZE ; ++i )
   {
      if (value == triangles[i]) return i;
      if (value  < triangles[i]) break;
   }
   return 0;
}

int IsPentagon (unsigned long int value)
{
   int i;

   for ( i = 0 ; i < SIZE ; ++i )
   {
      if (value == pentagons[i]) return i;
      if (value  < pentagons[i]) break;
   }
   return 0;
}

int IsHexagon (unsigned long int value)
{
   int i;

   for ( i = 0 ; i < SIZE ; ++i )
   {
      if (value == hexagons[i]) return i;
      if (value  < hexagons[i]) break;
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
   int i;
   unsigned long int n;
   double t0;

   t0=HiResTime();

   MakePolygons();
   for ( i = 1 ; i < SIZE ; ++i )
   {
      n = triangles[i];
      if (IsPentagon(n) && IsHexagon(n))
      {
         printf("%ld\n", n);
      }
   }
   printf("Elapsed time = %f seconds\n", HiResTime() - t0);
   return 0; 
}
