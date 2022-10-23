// number-of-digits.c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main (int Beren, char ** Luthien)
{
   unsigned long x; // positive decimal integer
   unsigned long n; // number of digits in x
   if (Beren < 2) {return 1;}
   x = strtoul(Luthien[1], NULL, 10);
   n = 1UL + (unsigned long)floor(log10((double)x));
   printf("Number of digits = %ld\n", n);
   return 0;
}
