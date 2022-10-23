/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/***************\
 * permute.c   *
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

/* Recursively refine partial permutations of a string.
left gets longer and right gets shorter at each level of recursion;
terminate recursion when right has just 2 characters left, 
create finished permutation, and print result: */
void Permute(const char *left, const char *right)
{
   int  Index;
   int  length_left     = (int)strlen(left);
   int  length_right    = (int)strlen(right);
   char temp_left  [21] = {'\0'};
   char temp_right [21] = {'\0'};

   /* Copy left to temp_left here, before the for loop, because the only
   character of temp_left which will change during the loop will be
   temp_left[strlen(left)]. */
   strcpy(temp_left, left);

   /* If length_right is 2, then there are only 2 possible ways to 
   make a complete permutation from temp_left, so handle this case
   manually instead of recursing. This saves 2 recursive levels
   relative to how this function was written before: */
   if (2 == length_right)
   {
      temp_left[length_left]   = right[0];
      temp_left[length_left+1] = right[1];
      ++Permutations;
      if (PrntPrms) {printf("%s\n", temp_left);}

      temp_left[length_left]   = right[1];
      temp_left[length_left+1] = right[0];
      ++Permutations;
      if (PrntPrms) {printf("%s\n", temp_left);}
   }

   /* Else if length_right > 2: */
   else
   {
      /* For each character of right: */
      for (Index = 0; Index < length_right; ++Index)
      {
         /* Assign a fresh copy of right to temp_right at start of each 
         iteration. */
         strcpy(temp_right, right);

         /* Tack a character from temp_right to temp_left (each iteration
         except the first over-writes the character tacked-on during the
         previous iteration): */
         temp_left[length_left] = temp_right[Index];

         /* Erase the character we just copied from temp_right: */
         Elide(temp_right, Index);

         /* Pass temp_left & temp_right to the next recursive level: */
         Permute(temp_left, temp_right);
      } /* end for each character of right */
   } /* end else m > 2 */
   return;
}

/*

NOTES ON FUNCTIONS:

==============================================================================
Notes on function Elide():

WHAT IT DOES:
Erases a character from position "Index" of text "Text", and closes-up
the gap by shifting all characters to the right of Index leftward,
including the terminating null character, thus shortening strlen(Text)
by 1 character.

WARNINGS: 
 - Text must point to the start of a writable array of char.
 - The string in the array must be '\0' terminated.
 - strlen(Text) must be at most (size(array)-1) 
 - Index must be at most (strlen(Text)-1). 

Example: if dealing with a 20-character string, the array must be at least
21 bytes in size (to accomodate the null terminator), and Index must be
at most 19 (due to zero-indexing).

NOTE:
Argument checking is *NOT* done, because this function must be blazing fast,
else the run times of this program will be very slow.

==============================================================================
Notes On Function Permute():

WHAT IT DOES:

Given a length n partial permutation "left" of an original string, 
and a length m string "right" of alternative "next" characters for left, 
Permute() makes m length (n+1) refinements of the given partial 
permutation, each with a size (m-1) set of alternative "next" characters.

Each such refined partial permutation consists of a copy (temp_left) of 
the original partial permutation "left" with one character from "right" 
tacked onto its right end; and each matching list of alternative "next" 
characters consists of a copy (temp_right) of all of the characters from
the original "right" except for the character copied to temp_left[n].

For each such temp_left & temp_right pair, if m is 2, Permute will
now tack the remaining character from temp_right onto temp_left as well,
and print the new temp_left as being a completed permutation.

Otherwise, if m > 2, Permute will send each temp_left & temp_right 
pair to another (recursive) instance of Permute().

HOW IT DOES IT:

All of the above is accomplished via the following algorithm: 

First strcopy left to temp_left.
Then, for each index [i] from 0 through m-1 do the following:
{
   1. strcopy right to temp_right (entire fresh copy each iteration).
   2. Assign temp_right[i] to temp_left[n], 
      thus increasing the size of temp_left  by 1 the first time this
      is done (but size remains unchanged after first iteration because
      each additional added character over-writes the first added character).
   3. Erase character [i] from temp_right and close up the gap,
      thus reducing   the size of temp_right by 1.
      (This is done by calling function Erase() defined in this file.)
   4. If (2 == m)
      {
         temp_left[n+1] = temp_right[0]; print temp_left;
         temp_left[n+1] = temp_right[1]; print temp_left;
      }
      else
      {
         recursively send temp_left and temp_right to Permute().
      }
}

NO NEED TO CHECK ARGUMENTS:

There is no need to check the arguments of Permute, it just slows things down;
main() already insures that the arguments to the initial call to
permute() will have lengths n=0, m=2-20. This, along with the
stipulation below that m must be >2 for recursion to occur,
ensures that for all subsequent calls, n=1-18 and m=19-2.

RUNAWAY RECURSION CAN'T HAPPEN:

Note that at each recursive level of Permute, "left" gets one character 
longer and "right" gets one character shorter until "right" is an empty
string, at which stage Permute() prints "left" as being a finished 
permutation. Since n is never allowed to be larger than 20, the recursion
is thus limited to a maximum depth of 20 levels, hence runaway recursion 
can never occur. 

NUMBER OF FUNCTION CALLS:

Given an original string of length L (in the 2 to 20 range), the number
of calls to Permute() in this program will be:
1 + L + L(L-1) + L(L-1)(L-2) + ... + L(L-1)...(3)
What an odd series. Kinda hard to put into mathematical symbols.
NumCalls = Sigma[i:0->L-2](L!/(L-i)!)

*/

