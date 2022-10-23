// letter-count.c
#include <stdlib.h>
#include <stdio.h>

int main (void)
{
   char    *  Buffer             = NULL;
   size_t     Count              = 0;
   int        LetterCounts [26]  = {0};
   char    *  Char               = NULL;
   int        i                  = 0;

   printf("Type a line of text.\n");
   getline(&Buffer, &Count, stdin);
   Char = &Buffer[0];                  // start at beginning of string
   while ('\0' != *Char)               // while not yet at end of string
   {
      if (*Char >= 65 && *Char <=  90) // upper-case
         ++LetterCounts[*Char - 65];
      if (*Char >= 97 && *Char <= 122) // lower-case
         ++LetterCounts[*Char - 97];
      ++Char;                          // move on to next letter
   }
   printf("You typed the following numbers of the following letters:\n");
   for (i=0;i<26;++i)
   {
      printf("%c : %d\n", (char)(i+65), LetterCounts[i]);
   }
   return 0;
}
