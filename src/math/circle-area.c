// circle-area.c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main (int Beren, char * Luthien[])
{
   int i;
   for ( i = 1 ; i < Beren ; ++i )
   {
      double Radius = strtod(Luthien[i], NULL);
      double Area = M_PI*Radius*Radius;
      printf("%.15g\n", Area);
   }
   exit(EXIT_SUCCESS);
}