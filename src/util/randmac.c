/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* randmac.c */

int main (void)
{
   srand((unsigned)time(0));
   int i;
   printf("25 random MAC addresses:\n");
   for ( i = 0 ; i < 25 ; ++i)
   {
      printf("%02x - %02x - %02x - %02x - %02x\n", 
         rand()%256, rand()%256, rand()%256, rand()%256, rand()%256);
   }
   return 0;
}
