// This is a 120-character-wide ASCII C source-code text file.
//=======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/************************************************************************************************************\
 * Program name:  
 * Module name:   (this line for library modules only)
 * Description:   
 * File name:     
 * Header for:    (this line for headers only)
 * Source for:    
 * Inputs:        
 * Outputs:       
 * Notes:
 * To make:       
 * Author:        Robbie Hatley
 * Edit history:
 *    Fri Apr 08, 2016 - Wrote it.
 *    Mon Apr 11, 2016 - Fix xxxxx bug in xxxxxx. 
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <time.h>

#include "rhdefines.h"
#include "rhutilc.h"
#include "rhmathc.h"
#include "rhncgraphics.h"

int main(int Beren, char * Luthien[])
{
   double t0 = MonoTime();

   printf("Hi. The arguments you typed were:\n");
   for ( int i = 1 ; i < Beren ; ++i )
   {
      printf("%s\n", Luthien[i]);
   }

   printf("Elapsed time = %.9f seconds.\n", MonoTime() - t0);
   return 0;
}
