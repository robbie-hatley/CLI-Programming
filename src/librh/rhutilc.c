/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * Filename:             rhutilc.c
 * Source For:           rhutilc.o
 * Module description:   Utility functions in C.
 * Author:               Robbie Hatley
 * Date Written:         Thu Feb 15, 2018.
 * To use in program:    #include "rhutilc.h"
 *                       Link program with rhutilc.o in librhc.a
 * Edit History:         Thu Feb 15, 2018: Created it.
\*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <assert.h>

#include "rhutilc.h"

/* ========== Specialized Input Functions: ================================= */

////////////////////////////////////////////////////////////////////////
//                                                                    //
// Wait for user to press one key on keyboard, then return that       //
// character, the instant user presses key (no buffering).            //
//                                                                    //
////////////////////////////////////////////////////////////////////////
char getkey (void)
{
   char A;
   system("stty -cooked");
   A = (char)getchar();
   system("stty cooked");
   return A;
}


///////////////////////////////////////////////////////////////////////////
//                                                                       //
// Check for recent keypress on keyboard; if there is one, get that one  //
// character; but don't wait more than 1 decisecond for input (keep      //
// executing program).                                                   //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
char getkey_unlocked (void)
{
   char A;
   system("stty -icanon");
   system("stty -echo");
   system("stty time 1");
   A = (char)getchar();
   system("stty echo");
   system("stty icanon");
   return A;
}


/* ========== Random Numbers: ============================================== */


/* Reseed random number generator using clock: */
void Randomize (void)
{
   srand((unsigned)time(0));
}

/* Get random double: */
double RandNum (double min, double max)
{
   return min + (max - min) * ( (double)rand() / (double)RAND_MAX );
}

/* Get random int: */
int RandInt (int min, int max)
{
   return (int)RandNum((double)min + 0.000001, (double)max + 0.999999);
}

/* Get random signed 64-bit int: */
int64_t RandS64(int64_t min, int64_t max)
{
   return (int64_t)RandNum((double)min + 0.000001, (double)max + 0.999999);
}

/* Get random unsigned 64-bit int: */
uint64_t RandU64 (uint64_t min, uint64_t max)
{
   return (uint64_t)RandNum((double)min + 0.000001, (double)max + 0.999999);
}

/* ========== Clocks, Timers, and Delays: ================================== */

/* Get high-resolution time (in seconds, to nearest microsecond,
since 00:00:00 on the morning of Jan 1, 1970), as double, for timing things: */
double HiResTime (void)
{
   struct timeval t;
   gettimeofday(&t, NULL);
   return (double)t.tv_sec + (double)t.tv_usec / 1000000.0;
}

/* Get VERY-high-resolution real time (in seconds, to nearest nanosecond,
since 00:00:00 on the morning of Jan 1, 1970), as double, for timing things: */
double RealTime (void)
{
   struct timespec t;
   clock_gettime(CLOCK_REALTIME, &t);
   return (double)t.tv_sec + (double)t.tv_nsec / 1000000000.0;
}

/* Get VERY-high-resolution monotonic time (in seconds, to nearest nanosecond,
since 00:00:00 on the morning of Jan 1, 1970), as double, for timing things: */
double MonoTime (void)
{
   struct timespec t;
   clock_gettime(CLOCK_MONOTONIC, &t);
   return (double)t.tv_sec + (double)t.tv_nsec / 1000000000.0;
}

/* Delay for a given time in seconds (resolution is theoretically 1us): */
void Delay (double s)
{
   double t0  = 0.0;
   double t   = 0.0;
   double n   = 1.000013;
   double m   = 1.001867;
   int    i;

   t0 = HiResTime();
   for ( t = t0 ; t - t0 < s ; t = HiResTime() )
   {
      for ( i = 0 ; i < 5 ; i = i + (int)n )
      {
         while ( n < 8.0) {n *= m;}
         while ( n > 2.0) {n /= m;}
      }
   }
   return;
}
