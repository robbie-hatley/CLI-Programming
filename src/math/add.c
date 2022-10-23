/* add.c */

#include <stdio.h>
#include <stdlib.h>

int main (int Karamell, char * Dansen[])
{
   double a,b;
   if (Karamell != 3) return 666;
   a = strtod(Dansen[1], NULL);
   b = strtod(Dansen[2], NULL);
   printf("%f", a+b);
   return 0;
}
