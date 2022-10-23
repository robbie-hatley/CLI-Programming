// fract.c
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
int main (int Beren, char * Luthien[])
{
   double Manwe = 0.0;
   double Varda = 0.0;
   if (Beren != 2)
      exit(EXIT_FAILURE);
   Manwe = strtod(Luthien[1], NULL);
   if (Manwe < 0)
      Varda = Manwe - ceil(Manwe);
   else
      Varda = Manwe - floor(Manwe);
   printf("Fractional part = %f\n", Varda);
   exit(EXIT_SUCCESS);
}