// catalan.c
#include <stdio.h>
#include <stdlib.h>

unsigned long fact (unsigned long x) {
   unsigned long f = 1UL;
   unsigned long i = 1UL;
   for ( i = 2UL ; i <= x ; ++i ) {
      f *= i;
   }
   return f;
}

int main (int Beren, char *Luthien[]) {
   if ( 2 != Beren ) {
      printf("Error: Must have one argument, which must be a non-negative integer.\n");
      return EXIT_FAILURE;
   }
   unsigned long n = strtoul(Luthien[1], NULL, 10);
   unsigned long c = fact(2UL*n)/(fact(n+1UL)*fact(n));

   printf("Numerator    = %lu\n", fact(2UL*n)            );
   printf("Denominator  = %lu\n", (fact(n+1UL)*fact(n))  );
   printf("catalan[%ld] = %lu\n", n, c                   );

   return EXIT_SUCCESS;
}
