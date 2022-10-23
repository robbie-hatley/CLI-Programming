/************************************************************************************************************\
 * Program name:  Convert Base
 * Description:   Represents an integer in any base from 2 to 36
 * File name:     convert-base.c
 * Source for:    convert-base.exe
 * Inputs:        Three command-line inputs: 
 *                1: Number to be converted (must be in range [0,2^64-1] ([0,18446744073709551615]) ).
 *                2: Original base (2-62).
 *                3: New      base (2-62).
 * Outputs:       Representation of given number in given base.
 * Author:        Robbie Hatley
 * Edit history:  Mon Apr 16, 2018: Wrote first draft.
 *                Wed Apr 18, 2018: Added comments and help.
 *                Thu Apr 19, 2018: Added loads more error checking.
 *                Mon Apr 30, 2018: Expanded bases to the [2,62] range.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <errno.h>
#include <error.h>   

//#define BLAT_ENABLE
#undef  BLAT_ENABLE
#include <rhdefines.h>
#include <rhmathc.h>

void Help (void)
{
   printf
   (
      "Welcome to \"convert-base\", Robbie Hatley's nifty number base conversion\n"
      "program. This program requires three command-line inputs:\n"
      "1. Number to be converted (must be in range [0, 2^64-1]).\n"
      "2. Original base (must be in range [2, 62]).\n"
      "3. New      base (must be in range [2, 62]).\n"
      "convert-base will then print the given number in the given base.\n"
   );
} // end Help()

int main (int Beren, char * Luthien[])
{
   char      * Base1Tail         = NULL;    // ptr to extra junk
   char      * Base2Tail         = NULL;    // ptr to extra junk
   char      * Converted         = NULL;    // converted number
   unsigned    Base1             = 0;       // base to convert from
   unsigned    Base2             = 0;       // base to convert to
   unsigned    NumDig            = 0;       // number of digits
   uint64_t    Number            = 0;       // 2's-comp of number to be cnvrtd

   // If user wants help, just print help and exit:
   if 
   (
      Beren > 1 
      &&
      (
         0 == strcmp("-h", Luthien[1]) 
         || 
         0 == strcmp("--help", Luthien[1])
      )
   )
   {
      Help();
      exit(EXIT_SUCCESS);
   }

   // Otherwise, we must have 3 arguments:
   if (4 != Beren)
   {
      error(EXIT_FAILURE, 0, "Error: Wrong number of arguments. (Requires 3.)");
   }

   // Get Base1:
   if (strlen(Luthien[2]) > 2)
   {
      error(EXIT_FAILURE, 0, "Error: Too many characters in Base1 (max is 2).");
   }
   Base1 = (unsigned)strtoul(Luthien[2], &Base1Tail, 10);
   if (0 != strlen(Base1Tail))
   {
      error(EXIT_FAILURE, 0, "Error: Illegal characters in Base1.");
   }
   if (Base1 < 2 || Base1 > 64)
   {
      error(EXIT_FAILURE, 0, "Error: Base1 must not be < 2 or > 64.");
   }
      
   // Get Base2:
   if (strlen(Luthien[3]) > 2)
   {
      error(EXIT_FAILURE, 0, "Error: Too many characters in Base2 (max is 2).");
   }
   Base2 = (unsigned)strtoul(Luthien[3], &Base2Tail, 10);
   if (0 != strlen(Base2Tail))
   {
      error(EXIT_FAILURE, 0, "Error: Illegal characters in Base2.");
   }
   if (Base2 < 2 || Base2 > 64)
   {
      error(EXIT_FAILURE, 0, "Error: Base2 must not be < 2 or > 64.");
   }

   // Get Number:
   if (strlen(Luthien[1]) > 64)
   {
      error(EXIT_FAILURE, 0, "Error: More than 64 characters in number");
   }
   errno = 0;
   Number = StringToNumber(Luthien[1], Base1);
   if (ERANGE == errno)
   {
      error(EXIT_FAILURE, errno, "Error: Number > (2**64 - 1)");
   }

   // How many digits do we need to represent Number in Base2?
   NumDig = NumberOfDigits(Number, Base2);

   // Allocate sufficient memory for string + terminator:
   Converted = malloc((NumDig + 1)*sizeof(char));
   if (!Converted) error(EXIT_FAILURE,0,"couldn't allocate memory");

   // Convert Number from Base1 to Base2:
   BLAT("in main(), about to run RepresentInBase.\n")
   RepresentInBase(Number, Base2, NumDig, false, Converted);
   printf("%s\n", Converted);
   free(Converted);

   // We be done so scram:
   BLAT("At bottom of main(), about to return.\n")
   return 0;
} // end main()
