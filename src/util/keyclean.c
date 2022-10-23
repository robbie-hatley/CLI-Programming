/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Program name:  Key Clean
 * Description:   "Eats" all keyboard input during key cleaning.
 * File name:     keyclean.c
 * Source for:    keyclean.exe
 * Author:        Robbie Hatley
 * Date written:  Fri Nov 13, 2009
 * Inputs:        Ignores all input except for capital letter "Q" (shift-"q").
 * Outputs:       None.
 * To make:       Uses only standard library modules. Should compile and link
 *                using any C-standard-compliant compiler&linker (eg, gcc).
\*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>

int main(void)
{
   int a;

   // Set terminal to raw mode 
   system("stty raw -echo"); 

   while (42)
   {
      a = getchar();
      if ((int)'Q' == a) {break;} /* locked until user presses shift + Q */
   }

   // Reset terminal to normal "cooked" mode 
   system("stty -raw echo"); 

   return 0;
}
