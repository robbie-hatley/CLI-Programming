// even-odd.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main (int Beren, char *Luthien[]) {
   if (2!=Beren) {return 0;}
   long long x = strtoll(Luthien[1], NULL, 10);
   if (1&x) {printf("odd");} else {printf("even");}
   return 0;
}
