/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* 
Lollygag.c
Wastes some time.  Eg, to waste 5 seconds, type "lollygag 5".
*/

#include <stdlib.h>
#include <time.h>

int main (int Beren, char * Luthien[])
{
   time_t  Seconds  = 0;
   time_t  t0       = 0;
   time_t  t        = 0;
   double  Trouble  = 1.0001234;

   if (2 != Beren) return 666;

   Seconds = atol(Luthien[1]);

   time(&t0);

   for (time(&t); t - t0 < Seconds; time(&t))
   {
      Trouble *= 1.0001234;
      if (Trouble > 5.0) Trouble = 1.0001234;
   }

   return 0;
}
