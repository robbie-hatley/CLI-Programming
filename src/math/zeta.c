// zeta.c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main (int Beren, char * Luthien[])
{
   unsigned long int  i       = 0;
   unsigned long int  limit   = 0;
   double             x       = 0.0;
   double             sum     = 0.0;

   if (Beren > 1)
      x = strtod(Luthien[1], NULL);
   if (Beren > 2)
      limit = strtoul(Luthien[2], NULL, 10);
   for ( i = 1 ; i <= limit ; ++i )
   {
      sum += 1.0/pow((double)i,x);
      printf("%15.9f\n", sum);
   }
}