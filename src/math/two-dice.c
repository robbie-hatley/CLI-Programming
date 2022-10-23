/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

#include <stdio.h>

int main(void)
{
   int x = 0;
   int y = 0;

   for ( x = 1 ; x<=6 ; ++x )
   {
      for ( y = 1 ; y<=6 ; ++y )
      {
         printf("%4i",x+y);
      }
      printf("\n");
   }
   return 0;
}
