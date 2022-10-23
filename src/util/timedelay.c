/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/****************************************************************************\
 * timedelay.c
 * This program does nothing, for the time duration specified by the 
 * command-line argument, which must be a positive number, 
 * at least 0.001 and at most 100.0, indicating the number of seconds
 * to spend doing nothing.
 * Author: Robbie Hatley
 * Date written: Unknown, but probably circa 2002.
 * Edit history:
 *    Mon Mar 21, 2016:
 *       Added comments and error checking and help.
\****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

double  GetSecs       (void);
void    Delay         (double s);
void    PrintHelpMsg  (void);

int main(int Beren, char *Luthien[])
{
   double DelayTime;

   if
   (
      Beren >= 2 
      &&
      (
         0 == strcmp ( "-h"     , Luthien[1] )
         ||
         0 == strcmp ( "--help" , Luthien[1] )
      )
   )
   {
      PrintHelpMsg();
      exit(777);
   }

   if (Beren != 2)
   {
      printf("Error:ÅÅ Wrong number of arguments.\n"); 
      PrintHelpMsg();
      exit(666);
   }

   DelayTime = strtod(Luthien[1], NULL);
   if (DelayTime<0.001 || DelayTime>100.0)
   {
      printf("Error: Argument is out of bounds.\n");
      PrintHelpMsg();
      exit(666);
   };

   printf("Begin %3.3f-second delay.\n", DelayTime);
   Delay(DelayTime);
   printf("End   %3.3f-second delay.\n", DelayTime);
   return 0;
}

double GetSecs(void)
{
   return (double)clock() / (double)CLOCKS_PER_SEC;
}

void Delay(double s)
{
   double a, b;
   for (a=GetSecs(),b=GetSecs(); b-a<s; b=GetSecs())
   {
      ; /* Do nothing. */
   }
}

void PrintHelpMsg (void)
{
   printf("This program does nothing, for the time duration specified by the command-line\n");
   printf("argument, which must be a positive number, at least 0.001 and at most 100.0,\n");
   printf("indicating the number of seconds to spend doing nothing.\n");
   return;
}
