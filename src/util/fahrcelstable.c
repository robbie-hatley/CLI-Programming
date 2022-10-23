/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/********************************************************************\
 * Program name:  FahrCelsTable                                     *
 * Description:   Fahrenheit-to-Celsius Table Generator             *
 * File name:     fahrcelstable.c                                   *
 * Source for:    fahrcelstable.exe                                 *
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
   double FahrMin=0, FahrMax=0, FahrInc=0, Fahr=0, Cels=0;

   if ( 2 == Fred && ( 0 == strcmp(Ethel[1], "-h") || 0 == strcmp(Ethel[1], "--help") ) )
   {
      Help();
      return 777;
   }

   if (4 != Fred) 
   {
      printf("FahrCelsTable must have 3 args.:\n");
      printf("  Fahrenheit Min\n");
      printf("  Fahrenheit Max\n");
      printf("  Fahrenheit Increment\n");
      return 666;
   }

   FahrMin = atof(Ethel[1]);
   FahrMax = atof(Ethel[2]);
   FahrInc = atof(Ethel[3]);

   if (FahrMin > FahrMax - 0.001)
   {
      printf
      (
         "Error: maximum must be at least 0.001 greater than minimum.\n"
      );
      return 666;
   }

   if (FahrInc < 0.001)
   {
      printf
      (
         "Error: increment must be at least 0.001\n"
      );
      return 666;
   }

   printf("    Fahr         Cels\n");

   for ( Fahr = FahrMin ; Fahr <= (FahrMax + 0.0001) ; Fahr += FahrInc )
   {
      Cels = (((Fahr-32)*100.0)/180.0);
      printf("%10.3f   %10.3f\n", Fahr, Cels);
   }

   return 0;
}


void Help (void)
{
   printf
   (
      "FahrCelsTable must have 3 arguments:\n"
      "  Fahrenheit Min\n"
      "  Fahrenheit Max\n"
      "  Fahrenheit Increment\n"
      "Max must be at least 0.001 greater than Min,\n"
      "and Increment must be at least 0.001\n"
      "FahrCelsTable will then print a table of Fahrenheit-to-Celsius conversions\n"
      "for the range and increment you specified."
   );
   return;
}
