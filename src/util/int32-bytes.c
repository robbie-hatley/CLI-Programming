// int32-bytes.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main (int Beren, char ** Luthien)
{ 
   int32_t x = 0;
   if (Beren > 1)
   {
      x = (int32_t)strtol(Luthien[1], NULL, 10);
   }
   uint8_t * p  = (uint8_t*)&x;
   printf("Bytes: %02X %02X %02X %02X", p[0], p[1], p[2], p[3]);
   exit(EXIT_SUCCESS);
}
