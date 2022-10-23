/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* time1970.c */

#include <stdio.h>
#include <time.h>

int main(void)
{
   time_t Ommm;
   time(&Ommm);
   printf("Time since 12:00:00AM on 1-1-1970:  %lu seconds.\n", Ommm ) ;
   return 0;
}
