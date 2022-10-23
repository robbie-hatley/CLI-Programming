/*****************************************************************************\
This is a 79-character-wide ASCII C source-code text file.
=========|=========|=========|=========|=========|=========|=========|=========
Program name:  Random Name Generator
Description:   Generates a pseudo-random full personal name  based on first and
               last names taken from large lists.
File name:     randname.c
Source for:    randname.exe
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
Inputs:        None.

Outputs:       Writes name  to stdout .  (Can be redirected.)
To make:       Link with modules namegen.o and usename.o in
               library "/rhe/lib/libname.a".
               gcc randname.c  -lname -o /rhe/bin/util/randname.exe
               (or just type "make")
\*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <namegen.h>

int main(void)
{
   char *rname;
   srand((unsigned)time(0));
   rname=getrandomname();
   printf("%s\n", rname);
   free(rname);
   return 0;
}