/* rand-hex-small.c */
#include <stdio.h>
#include "rhutilc.h"
#include "rhmathc.h"

int main (void)
{
   uint64_t blat;
   Randomize();
   blat = RandU64(0x00000000, 0xFFFFFFFF);
   printf("%08lx\n", blat);
   return 0;
}
