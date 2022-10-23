/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/***************\
 * permute-0.c *
\***************/

#include <stdio.h>
#include <string.h>
#include <time.h>

/* Global Variables: */
unsigned long Permutations  = 0;
unsigned long StringLength  = 0;
int           PrntPrms      = 1;

/* Functions: */
void Elide(char *Text, int Index);
void Permute(const char *left, const char *right);

/* main(): */
int main(int Beren, char * Luthien[])
{
   time_t  enter_time  = 0;
   time_t  exit_time   = 0;

   /* Print entry time: */
   enter_time = time(0);
   fprintf(stderr, "Entry time: %ld\n", enter_time);

   /* Make sure that user supplied exactly 1 argument, and that that argument
      is at least 2 and at most 20 characters long: */
   if (Beren < 2)
   {
      fprintf
      (
         stderr, 
         "Error: Permute takes exactly 1 argument, which must be\n"
         "a string with at least 2 characters and at most 20 characters.\n"
      );
      return 666;
   }

   if (Beren == 3) 
   {
      if (0 == strcmp(Luthien[2], "--noprint")
       || 0 == strcmp(Luthien[2], "-n"))
      {
         PrntPrms = 0;
      }
   }

   StringLength = strlen(Luthien[1]);
   if (StringLength < 2 || StringLength > 20)
   {
      fprintf
      (
         stderr, 
         "Error: Permute takes exactly 1 argument, which must be\n"
         "a string with at least 2 characters and at most 20 characters.\n"
      );
      return 666;
   }

   /* Start a tree of recursive calls to Permute: */
   Permute("", Luthien[1]);

   /* Print total number of permutations found: */
   fprintf(stderr, "Found %lu permutations.\n", Permutations);

   /* Print exit time and elapsed time: */
   exit_time = time(0);
   fprintf(stderr, "Exit time: %ld\n", exit_time);
   fprintf(stderr, "Elapsed time: %ld\n", exit_time - enter_time);

   /* We be done, so scram: */
   return 0;
}

/* Erase one character from a string and close-up the gap: */
void Elide(char *Text, int Index)
{
   while ('\0' != Text[Index])
   {
      Text[Index] = Text[Index+1];
      ++Index;
   }
}

/* Recursively refine partial permutations of a string. */
void Permute(const char *left, const char *right)
{
   char temp_left  [21] = {'\0'};
   char temp_right [21] = {'\0'};
   int  i;
   int  LL = (int)strlen(left);
   int  LR = (int)strlen(right);

   if ('\0' == right[0])
   {
      if (PrntPrms) {printf("%s\n", left);}
      ++Permutations;
   }
   else
   {
      strcpy(temp_left, left);
      for (i = 0; i < LR; ++i)
      {
         strcpy(temp_right, right);
         temp_left[LL] = temp_right[i];
         Elide(temp_right, i);
         Permute(temp_left, temp_right);
      }
   }
   return;
}
