// sizeof-gmp.c

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

int main (void)
{
   printf
   (
      "GMP version: %d.%d.%d\n",
      __GNU_MP_VERSION ,
      __GNU_MP_VERSION_MINOR ,
      __GNU_MP_VERSION_PATCHLEVEL
   );

   printf("Bits per limb: %d\n", mp_bits_per_limb);

   return 0;
}
