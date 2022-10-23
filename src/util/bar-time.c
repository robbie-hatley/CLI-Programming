/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/************************************************************************************************************\
 * Program name:  Bar Time
 * Description:   Prints seconds-per-bar for various beats-per-minute.
 * File name:     bar-time.c
 * Source for:    bar-time.exe
 * Inputs:        none
 * Outputs:       Prints seconds-per-bar for various beats-per-minute.
 * To make:       
 * Author:        Robbie Hatley
 * Edit history:
 *    Thu Aug 18, 2016 - Wrote it.
\************************************************************************************************************/

#include <stdio.h>

int main(void)
{
   double  spm     =  60.0;
   double  bpm     =   0.0;
   double  spb     =   0.0;
   double  spbar   =   0.0;
   
   for ( bpm = 100.0; bpm <= 160.0 ; bpm += 1.0 )
   {
      spb = spm / bpm;
      spbar = 4.0 * spb;
      printf("bpm = %3f  seconds per bar = %3f\n", bpm, spbar);
   }
   return 0;
}
