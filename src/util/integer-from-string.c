// integer-from-string.c
// Copyright 6/23/2018 by Robbie Hatley
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
typedef signed long int sli;
int main (int Beren, char * Luthien [])
{
   size_t   StrLen     = 0;
   char   * Fred       = NULL;
   char   * Ptr1       = NULL;
   char   * Ptr2       = NULL;
   sli      Integer    = 0;
   int      FirstSign  = 0;
   int      FirstDigit = 0;
   if (2 != Beren) {exit(EXIT_FAILURE);}
   StrLen = strlen(Luthien[1]);
   if (StrLen < 1) {exit(EXIT_FAILURE);}
   Fred = calloc((StrLen + 5), sizeof(char));
   Ptr1 = &(Fred[0]);
   Ptr2 = &(Luthien[1][0]);
   for ( ; *Ptr2 ; ++Ptr2 )
   {
      // If *Ptr2 is a sign:
      if ('-' == *Ptr2 || '+' == *Ptr2)
      {
         // If we haven't found first-sign or first digit yet,
         // then record this *Ptr2 as being our sign and set
         // the FirstSign flag:
         if (!FirstSign && !FirstDigit)
         {
            *Ptr1++ = *Ptr2;
            FirstSign = 1;
         }
      }
      // else if *Ptr2 is a digit, then record it as being a
      // digit, and set the FirstDigit flag:
      else if (isdigit((int)(unsigned char)(*Ptr2)))
      {
         *Ptr1++ = *Ptr2;
         FirstDigit = 1;
      }
   }
   Integer = strtol(Fred, NULL, 10);
   free(Fred);
   printf("%ld\n",Integer);
   return 0;
}
