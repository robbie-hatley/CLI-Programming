// print-even-digits.c
#include <stdio.h>
#include <stdlib.h>
unsigned long ten_to_the (unsigned x)
{
   unsigned long  y = 1; 
   unsigned       i;
   for ( i = 1U ; i <= x ; ++i ) y *= 10UL;
   return y;
}
unsigned log_ten_of (unsigned long x)
{
   unsigned i;
   for ( i = 0U ; x >= 10UL ; ++i ) x /= 10UL;
   return i;
}
int main (int Beren, char *Luthien[])
{
   unsigned long int number;
   unsigned      int d;
   unsigned      int i;
   unsigned      int max_index;
                 
   if (2 != Beren) {exit(EXIT_FAILURE);}
   number = strtoul(Luthien[1], NULL, 10);
   max_index = log_ten_of(number);
   
   for ( i = max_index ; ; --i )
   {
      d = (unsigned)((number/ten_to_the(i))%10LU);
      if (0 == d%2) {printf("%u", d);}
      if (0 == i  ) {break;}
   }
   exit(EXIT_SUCCESS);
}