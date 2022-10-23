#include <stdio.h>
#include <stdlib.h>
int main (int Beren, char * Luthien[])
{
   unsigned char Bytes [10] = {0};
   FILE * fp;
   int i;
   if (Beren < 2) {exit(666);}
   fp=fopen(Luthien[1], "r");
   if (!fp) {exit(666);}
   fread(&Bytes, 10, 1, fp);
   for ( i = 0 ; i < 10 ; ++i )
   {
      printf("%02X ", (unsigned)Bytes[i]);
   }
   printf("\n");
   return 0;
}
