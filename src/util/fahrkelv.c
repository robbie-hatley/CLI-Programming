/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  FahrKelv                                                   *
 * Description:   Fahrenheit-to-Kelvin Converter                             *
 * File name:     fahrkelv.c                                                 *
 * Source for:    fahrkelv.exe                                               *
 * Author:        Robbie Hatley                                              *
 * Date written:  Sat Jul 17, 2021                                           *
 * Input:         One command-line argument: Temperature in Fahrenheit.      *
 * Output:        Temperature in Kelvin.                                     *
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
   double Fahr=0, Kelv=0;
  
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
   Kelv = (Fahr-32)/1.8+273.15;
   printf("%10.3f\n", Kelv);

   return 0;
}

void Help (void)
{
   printf
   (
      "FahrKelv must have exactly 1 argument, which must be\n"
      "temperature in degrees Fahrenheit. FahrKelv will then print\n"
      "the corresponding temperature in degrees Kelvin.\n"
   );
   return;
}
