/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/* permute-no-comments.c */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

long int Permutations = 0;

void Elide(char *Text, int Index);
void Permute(const char *left, const char *right);

int main(int Beren, char * Luthien[])
{
   if (2 != Beren) 
   {
      fprintf(stderr, "Error: Argument must have 2-to-20 characters.\n");
      return 666;
   }
   if (strlen(Luthien[1]) < 2 || strlen(Luthien[1]) > 20)
   {
      fprintf(stderr, "Error: Argument must have 2-to-20 characters.\n");
      return 666;
   }
   fprintf(stderr, "Entry time: %ld\n", time(0));
   Permute("", Luthien[1]);
   fprintf(stderr, "Found %ld permutations.\n", Permutations);
   fprintf(stderr, "Exit  time: %ld\n", time(0));
   return 0;
}

void Elide(char *Text, int Index)
{
   while ('\0' != Text[Index])
   {
      Text[Index] = Text[Index+1];
      ++Index;
   }
}

void Permute(const char *left, const char *right)
{
   int Index;
   int n = (int)strlen(left);
   int m = (int)strlen(right);
   char temp_left  [21] = {'\0'};
   char temp_right [21] = {'\0'};
   strcpy(temp_left, left);
   if (2 == m)
   {
      temp_left[n]   = right[0];
      temp_left[n+1] = right[1];
      ++Permutations;
      printf("%s\n", temp_left);
      temp_left[n]   = right[1];
      temp_left[n+1] = right[0];
      ++Permutations;
      printf("%s\n", temp_left);
   }
   else
   {
      for (Index = 0; Index < m; ++Index)
      {
         strcpy(temp_right, right);
         temp_left[n] = temp_right[Index];
         Elide(temp_right, Index);
         Permute(temp_left, temp_right);
      }
   }
   return;
}
