/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  KelvFahr                                                   *
 * Description:   Kelvin-to-Fahrenheit Converter                             *
 * File name:     kelvfahr.c                                                 *
 * Source for:    kelvfahr.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat Jul 17, 2021                                           *
 * Input:         One command-line argument: Temperature in Kelvin.          *
 * Output:        Temperature in Fahrenheit.                                 *
 * To make:       No dependencies other than standard library.               *
 * Edit history:                                                             *
 *   Sat Jul 17, 2021: Wrote it.                                             *
\*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void Help (void);

int main(int Fred, char* Ethel[])
{
   double Kelv=0, Fahr=0;
  
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
  
   Kelv = strtod(Ethel[1], NULL);
   Fahr = (Kelv-273.15)*1.8+32;
   printf("%10.3f\n", Fahr);

   return 0;
}

void Help (void)
{
   printf
   (
      "KelvFahr must have exactly 1 argument, which must be\n"
      "temperature in degrees Kelvin.  KelvFahr will then print\n"
      "the corresponding temperature in degrees Fahrenheit.\n"
   );
   return;
}
