// ieee754.c
#include <stdio.h>
#include <stdlib.h>
typedef union {
   double        flt;
   unsigned long bin;
} Fred;
int main (int Beren, char *Luthien[]) {
   Fred x;
   if (2 != Beren) {return 1;}
   x.flt = strtod(Luthien[1], NULL);
   printf("%064lb\n", x.bin);
   return 0;
}
