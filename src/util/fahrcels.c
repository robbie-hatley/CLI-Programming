/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  FahrCels                                                   *
 * Description:   Fahrenheit-to-Celsius converter                            *
 * File name:     fahrcels.cpp                                               *
 * Source for:    fahrcels.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat May 01, 2004                                           *
 * Input:         One command-line argument: Temperature in Fahrenheit.      *
 * Output:        Temperature in Celsius.                                    *
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
   double Fahr=0, Cels=0;

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

   Fahr = strtod(Ethel[1], NULL);
   Cels = (Fahr-32.0)/1.8;
   printf("%10.3f\n", Cels);

   return 0;
}

void Help (void)
{
   printf
   (
      "FahrCels must have exactly 1 argument, which must be\n"
      "temperature in degrees Fahrenheit.  FahrCels will then print\n"
      "the corresponding temperature in degrees Celsius.\n"
   );
   return;
}
