
// analyze-csv-file.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <error.h>

char words [5005] [255] = {'\0'};
int  WordSizes    [255] = {0};

void AnalyzeCsv (char * FileName)
{
   auto    char    * line                = NULL;
   auto    size_t    size                = 0;
   auto    int       numchars            = 0;
   auto    int       maxchars            = 0;
   auto    int       numwords            = 0;
   auto    FILE    * fp                  = NULL;
   auto    int       i                   = 0;

   fp = fopen(FileName, "r");
   if (NULL == fp)
   {
      error
      (
         EXIT_FAILURE, 
         errno, 
         "Couldn't open file %s for reading.", 
         FileName
      );
   }

   while (!ferror(fp) && !feof(fp))
   {
      numchars = (int)getdelim(&line, &size, ',', fp);
      if (NULL == line || ferror(fp) || numchars < 1)
      {
         error
         (
            EXIT_FAILURE,
            errno,
            "After %d words, getdelim ( ) failed to read any characters.",
            numwords
         );
      }
      if (numchars > 253)
      {
         error
         (
            EXIT_FAILURE,
            errno,
            "After %d words, found word with over 250 characters.",
            numwords
         );
      }
      for ( i = 0 ; i < numchars-3 ; ++i )
      {
         words[numwords][i] = line[i+1];
      }
      words[numwords][numchars-3] = '\0';
      numchars -= 3;
      ++numwords;
      if (numchars > maxchars) maxchars = numchars;
      ++WordSizes[numchars];
   }
   fclose(fp);
   free(line);
   printf("File contains %d words.\n", numwords);
   printf("Longest word has %d characters.\n", maxchars);
   for ( i = 1 ; i <= maxchars ; ++i )
   {
      printf("# of words with %3d characters: %3d\n", i, WordSizes[i]);
   }
   return;
}

int main(int Benden, char * Boll[])
{
   char FileName[305] = {'\0'};

   if (2 != Benden) 
   {
      error
      (
         EXIT_FAILURE, 
         0, 
         "This program takes 1 argument, not %d.", 
         Benden
      );
   }
   strcpy(FileName, Boll[1]);
   AnalyzeCsv(FileName);
   return 0;
}
