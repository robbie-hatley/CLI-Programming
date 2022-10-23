/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  CelsKelv                                                   *
 * Description:   Celsius-to-Kelvin Converter                                *
 * File name:     celskelv.c                                                 *
 * Source for:    celskelv.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat Jul 17, 2021                                           *
 * Input:         One command-line argument: Temperature in Celsius.         *
 * Output:        Temp in Kelvin.                                            *
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
   double Cels=0, Kelv=0;
  
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
   Kelv = Cels+273.15;
   printf("%10.3f\n", Kelv);

   return 0;
}

void Help (void)
{
   printf
   (
      "CelsKelv must have exactly 1 argument, which must be\n"
      "temperature in degrees Celsius. CelsKelv will then print\n"
      "the corresponding temperature in degrees Kelvin.\n"
   );
   return;
}
