// fizzbuzz.c

#include <stdio.h>
#include <string.h>

int main (void)
{
   int   i        = 0;
   char  msg[10]  = {'\0'};
   for ( i = 1 ; i <= 100 ; ++i )
   {
      memset(msg, 0, sizeof msg);
      if (0 == i%3)          strcat  (msg, "Fizz");
      if (0 == i%5)          strcat  (msg, "Buzz");
      if (0 == strlen(msg))  sprintf (msg, "%d",i);
      printf("%s\n", msg);
   }
   return 0;
}
