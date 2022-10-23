/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/********************************************************************\
 * Program name:  CelsFahrTable                                     *
 * Description:   Celsius-to-Fahrenheit Table Generator             *
 * File name:     celsfahrtable.c                                   *
 * Source for:    celsfahrtable.exe                                 *
 * Author:        Robbie Hatley                                     *
 * Date written:  Sat May 01, 2004                                  *
 * Inputs:        Three CLI args: begin, end, increment.            *
 * Outputs:       Sends chart to cout.  Can be redir'ed to a file.  *
 * To make:       No dependencies.                                  *
 * Edit history:                                                    *
 *   Thu Nov 23, 2006: Split FahrCelsTable from FahrCels.           *
\********************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void Help (void);

int main(int Fred, char* Ethel[])
{
   double CelsMin=0, CelsMax=0, CelsInc=0, Cels=0, Fahr=0;

   if ( 2 == Fred && ( 0 == strcmp(Ethel[1], "-h") || 0 == strcmp(Ethel[1], "--help") ) )
   {
      Help();
      return 777;
   }

   if (4 != Fred) 
   {
      printf("CelsFahrTable must have 3 args.:\n");
      printf("  Celsius Min\n");
      printf("  Celsius Max\n");
      printf("  Celsius Increment\n");
      return 666;
   }

   CelsMin = atof(Ethel[1]);
   CelsMax = atof(Ethel[2]);
   CelsInc = atof(Ethel[3]);

   if (CelsMin > CelsMax - 0.001)
   {
      printf
      (
         "Error: maximum must be at least 0.001 greater than minimum.\n"
      );
      return 666;
   }

   if (CelsInc < 0.001)
   {
      printf
      (
         "Error: increment must be at least 0.001\n"
      );
      return 666;
   }

   printf("    Cels         Fahr   \n");

   for ( Cels = CelsMin ; Cels <= (CelsMax + 0.0001) ; Cels += CelsInc )
   {
      Fahr = (((Cels*180.0)/100.0)+32);
      printf("%10.3f   %10.3f\n", Cels, Fahr);
   }

   return 0;
}


void Help (void)
{
   printf
   (
      "CelsFahrTable must have 3 arguments:\n"
      "  Celsius Min\n"
      "  Celsius Max\n"
      "  Celsius Increment\n"
      "Max must be at least 0.001 greater than Min,\n"
      "and Increment must be at least 0.001\n"
      "CelsFahrTable will then print a table of Celsius-to-Fahrenheit conversions\n"
      "for the range and increment you specified."
   );
   return;
}
