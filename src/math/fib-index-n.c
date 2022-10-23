
// fib-index-n.c
// Prints the nth element of The Fibonacci Sequence for a given n in the [3,500] range.

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

unsigned long int Fib(unsigned long int n)
{
   if (n <= 2)
      return 1;
   else
      return Fib(n-1) + Fib(n-2);
}

int main (int Beren, char * Luthien[])
{
   unsigned long int Fred  = 0UL;
   unsigned long int Ethel = 0UL;
   if (Beren != 2)
      exit(EXIT_FAILURE);
   Fred = strtoul(Luthien[1], NULL, 10);
   if (Fred < 3 || Fred > 500)
      exit(EXIT_FAILURE);
   Ethel = Fib(Fred);
   printf("%lu", Ethel);
   exit(EXIT_SUCCESS);
}