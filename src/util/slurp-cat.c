#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int Beren, char * Luthien[])
{
   int        i       = 0;
   size_t     j       = 0;
   FILE     * fp      = NULL;
   size_t     dummy   = 0;
   char    ** array   = NULL;
   size_t     asize   = 5000;
   size_t     lnctr   = 0;

   array = (char**)malloc(asize*sizeof(char*));
   if (Beren < 2) return 0;
   for ( i = 1 ; i < Beren ; ++i )
   {
      fp = fopen(Luthien[i], "r");
      if (!fp) continue;
      while ( fp && !ferror(fp) && !feof(fp) )
      {
         if (lnctr > (asize-5))
         {
            asize *= 2;
            array = (char**)realloc(array, asize*sizeof(char*));
         }
         dummy = 0;
         array[lnctr] = NULL;
         getline(&(array[lnctr]), &dummy, fp);
         ++lnctr;
      }
      fclose(fp);
      fp = NULL;
   }
   printf("Read %lu lines in %d files.\n", lnctr, Beren-1);
   printf("Lines read are are follows:\n");
   for ( j = 0 ; j < lnctr ; ++j )
   {
      printf("%s",array[j]);
   }
   return 0;
}
