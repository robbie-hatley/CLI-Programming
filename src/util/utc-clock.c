// utc-clock.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

int main(void)
{
   time_t     et      = 0      ;                             // Time in seconds since 0:0:0, 1970-1-1.
   struct tm  st               ;                             // Structured time.
   char       ft[51]  = {'\0'} ;                             // Formatted  time.
   printf("Perpetual utc clock. Press Ctrl-C to exit.\n");   // Announce perpetural clock.
   for ( ; ; sleep(1) )                                      // Loop back to this point once each second.
   {
      time(&et);                                             // What time is it?
      st = *gmtime(&et);                                     // Load structure.
      strftime(ft, 60, "%H:%M:%S, %A %B %d, %Y", &st);       // Format time.
      printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");    // Backspace 20 times.
      printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");    // Backspace 20 times.
      printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");    // Backspace 20 times.
      printf("%s", ft);                                      // Print time.
      fflush(stdout);
   }
}
