// odometer.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

bool db = false;

int main (int argc, char *argv[]) {
   int     *  vals         = NULL;
   int     *  ptr          = NULL;
   long       digits_input = 0L;
   int        digits       = 0;
   int        size         = 0;
   int        i            = 0;

   // If user wants help, give help and exit:
   for ( i = 0 ; i < argc ; ++i ) {
      if (0==strcmp("-h",argv[i])||0==strcmp("--help",argv[i])) {
         printf
         (
            "Welcome to Robbie Hatley's nifty odometer program.\n"
            "To use, invoke this program with a single argument which must be\n"
            "an integer in the 1-to-10 range. This program will then create an\n"
            "odometer of that many digits and increment it as fast as it can,\n"
            "printing every value from all-zeros to all-nines.\n"
         );
         return 0;
      }
   }

   // If user specifies a number-of-digits in the 1-100 range, use that:
   if ( 2 == argc && strlen(argv[1]) < 4 ) {
      digits_input = strtol(argv[1],NULL,10);
      if ( digits_input >= 1L && digits_input <= 10 ) {
         digits = (int)digits_input;
      }
      else {
         digits = 5;
      }
   }
   // Otherwise, use 5 digits:
   else {
      digits = 5;
   }

   // size = digits + 1 because we need 1 extra digit for "roll-over":
   size = digits + 1;

   // Allocate a dynamic array of size ints and store the address of its zeroth element in vals,
   // or die trying:
   if ( NULL == (vals = malloc( (size_t)size*sizeof(int) ) ) ) {
      fprintf (stderr, "Error allocating memory.\n");
      return 1;
   }

   // Zero all size elements of val (indexes 0 through size-1):
   for ( i = 0 ; i < size ; ++i ) {vals[i]=0;}

   // While the size-1 (overflow) place of vals is 0 (ie, while overflow has not occurred yet),
   // first print the value of the odometer, then increment the odometer:
   while (0 == vals[size-1]) {
      // Print the values of all places, starting with the digits-1 (highest) place:
      for ( i = digits-1 ; i >= 0 ; --i ) {
         printf("%d", vals[i]);
      }
      printf("\n");
      // Now increment the odometer and carry any overflow leftward:
      ptr = vals;          // Reset pointer to lowest place value.
      *ptr += 1;           // Increment lowest place value.
      while (10 == *ptr) { // While value of current place is 10,
         *ptr = 0;         // reset contents of place to 0,
         ++ptr;            // move to next place,
         *ptr += 1;        // and increment contents of place by 1.
      }
      // If the result was to increment the value of the overflow place from 0 to 1,
      // this loop will exit when we get back to the top. Until then, it will keep looping.
   }
   free(vals); // Free-up dynamically-allocated memory.
   return 0;   // Return sucess code 0 to caller.
}
