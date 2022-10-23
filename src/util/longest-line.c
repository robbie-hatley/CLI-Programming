/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/******************************************************************************\
 *
 * longest-line.c
 *
\******************************************************************************/

#include <stdio.h>
#include <string.h>

#include "rhdefines.h"

int main (int Beren, char* Luthien[])
{
   char            line_buf[505] = {'\0'};
   FILE          * fred          = NULL;
   unsigned long   line_num      = 0;
   unsigned long   line_siz      = 0;
   unsigned long   lline_num     = 0;
   unsigned long   lline_siz     = 0;

   if (Beren != 2) return 666;

   fred = fopen(Luthien[1], "r");
   
   if (!fred)
   {
      printf("Couldn't open file \"%s\".\n", Luthien[1]);
      return 666;
   }
   
   while (1)
   {
      line_buf[0] = '\0';
      fgets(line_buf, 500, fred);
      if (!fred) break;
      if (feof(fred)) break;
      if (strlen(line_buf) < 1) break;
      line_siz = strlen(line_buf);
      ++line_num;

      /* Strip newline: */
      while (line_siz > 0 && '\n' == line_buf[line_siz - 1])
      {
         line_buf[line_siz - 1] = '\0';
         line_siz = strlen(line_buf);
      }

      /* If we've found a new longest line, record it: */
      if (line_siz > lline_siz)
      {
         lline_num = line_num;
         lline_siz = line_siz;
      }
   }
   
   fclose(fred);
   
   printf("Line number of longest line = %ld\n", lline_num);
   printf("Line  size  of longest line = %ld\n", lline_siz);
      
   return 0;
}
