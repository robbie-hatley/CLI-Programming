/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  CelsFahr                                                   *
 * Description:   Celsius-to-Fahrenheit Converter                            *
 * File name:     celsfahr.c                                                 *
 * Source for:    celsfahr.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat May 01, 2004                                           *
 * Input:         One command-line argument: Temperature in Celsius.         *
 * Output:        Temperature in Fahrenheit.                                 *
 * To make:       No dependencies other than standard library.               *
 * Edit history:                                                             *
 *   Thu Nov 23, 2006: Split FahrCelsTable from FahrCels.                    *
 *   Sat Jul 17, 2021: Corrected formatting & comments.                      *
\*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void Help (void);

int main(int Fred, char* Ethel[])
{
   double Cels=0, Fahr=0;
  
   if ( 2 == Fred && ( 0 == strcmp(Ethel[1], "-h") || 0 == strcmp(Ethel[1], "--help") ) )
   {
      Help();
      return 777;
   }

   if (2 != Fred) 
   {
      Help();
      return 666;
   }
  
   Cels = strtod(Ethel[1], NULL);
   Fahr = Cels*1.8+32.0;
   printf("%10.3f\n", Fahr);

   return 0;
}

void Help (void)
{
   printf
   (
      "CelsFahr must have exactly 1 argument, which must be\n"
      "temperature in degrees Celsius.  CelsFahr will then print\n"
      "the corresponding temperature in degrees Fahrenheit.\n"
   );
   return;
}
