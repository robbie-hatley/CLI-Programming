/*****************************************************************************\
This is a 79-character-wide ASCII C source-code text file.
=========|=========|=========|=========|=========|=========|=========|=========
Program name:  Random Name Generator
Description:   Generates   pseudo-random full personal names based on first and
               last names taken from large lists.
File name:     randnames.c
Source for:    randnames.exe
Author:        Robbie Hatley
Date written:  Circa 2002
Edit History:
   Thu Oct 28, 2004: added selectable number of names.
   Fri Oct 29, 2004: added comments, range checking.
   Fri May 27, 2005: fixed linkage issues.
   Sun Jun 04, 2005: Changed to C++; left libname as C; used
                     extern "C" to link.
   Tue Aug 23, 2005: Changed back to C.  It's ludicrous to use
                     C++ for something this simple.
   Thu Sep 10, 2020: Updated comments and error handling.
Inputs:        One command-line argument, which must be a number between 1 and
               10000 inclusive, which is the number of names to generate.
Outputs:       Writes names to stdout .  (Can be redirected.)
To make:       Link with modules namegen.o and usename.o in
               library "/rhe/lib/libname.a".
               gcc randnames.c -lname -o /rhe/bin/util/randnames.exe
               (or just type "make")
\*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <namegen.h>

int main(int Finwe, char **Fingolfin)
{
   char *rname;
   size_t i, Names;

   // If number of arguments is wrong, bail:
   if (2 != Finwe)
   {
      printf("Error: this program takes exactly 1 argument, which must be\n"
             "an integer in the [1,10000] range.\n");
      return 666;
   }

   // Get number of names:
   Names = strtoul(Fingolfin[1], NULL, 10);

   // If Names is out of range, bail:
   if (Names < 1 || Names > 10000)
   {
      printf("Error: this program takes exactly 1 argument, which must be\n"
             "an integer in the [1,10000] range.\n");
      return 666;
   }

   // Randomize the pseudo-random number generator:
   srand((unsigned)time(0));

   // Generate and print random names:
   for (i=0; i<Names; i++)
   {
      rname=getrandomname(); // getrandomname() returns a pointer to a malloc'ed buffer.
      printf("%s\n", rname); // Print the name.
      free(rname);           // Must free buffer here to prevent memory leak!
   }
   return 0;
}