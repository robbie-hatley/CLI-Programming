/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  KelvCels                                                   *
 * Description:   Kelvin-to-Celsius Converter                                *
 * File name:     kelvcels.c                                                 *
 * Source for:    kelvcels.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat Jul 17, 2021                                           *
 * Input:         One command-line argument: Temperature in Kelvin.          *
 * Output:        Temperature in Celsius.                                    *
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
   double Kelv=0, Cels=0;
  
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
   Cels = Kelv-273.15;
   printf("%10.3f\n", Cels);

   return 0;
}

void Help (void)
{
   printf
   (
      "KelvCels must have exactly 1 argument, which must be\n"
      "temperature in degrees Kelvin. KelvCels will then print\n"
      "the corresponding temperature in degrees Celsius.\n"
   );
   return;
}
