/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* randip.c */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main (void)
{
   srand((unsigned)time(0));
   int i;
   printf("25 random IP addresses:\n");
   for ( i = 0 ; i < 25 ; ++i)
   {
      printf("%03d.%03d.%03d.%03d\n", 
         rand()%256, rand()%256, rand()%256, rand()%256);
   }
   return 0;
}
