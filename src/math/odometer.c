#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char *argv[])
{
  int     *  vals      = NULL;
  int     *  ptr       = NULL;
  size_t     max       = 0;
  int        counter   = 0;
  size_t     i         = 0;

  if (2 == argc) {max = (size_t)atoi(argv[1]);}
  else           {max = (size_t)5;}

  if ( NULL == (vals = malloc((max + 1UL) * sizeof(int))))
  {
    fprintf (stderr, "Error allocating memory.\n");
    return 1;
  }

  for ( i = 0 ; i < max + 1UL ; ++i ) {vals[i]=0;}

  while (0 == vals[max])
  {
    printf("At top of outer while loop.\n");
    ptr = vals; // Reset pointer to lowest place value
    *ptr += 1;  // Increment lowest place value.
    while (10 == *ptr)
    {
      ++counter;       // increment place value counter
      *ptr = 0;        // reset contents of slot to 0
      ++ptr;           // move to next slot
      *ptr += 1;       // increment contents of slot by 1
      printf("incremented place value\n");
      printf("p.v. increment counter = %d\n", counter);
      if (counter > 100000) {goto END;}
    }

    for ( i = 0 ; i < max + 1UL ; ++i ) 
    {
       printf("vals[%ld] = %d\n", i, vals[i]);
    }
  }

  END:
  free   (vals);
  return 0;
}

/* 

11110100001001000000

0000 0010  0100 0010  1111 0000  0000 0000




10000000000000000000000000
10,000,000,000,000,000,000
10,000,000,000,000,000
*/

