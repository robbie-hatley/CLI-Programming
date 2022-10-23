#ifndef RHUTILC_H_ALREADY_INCLUDED
#define RHUTILC_H_ALREADY_INCLUDED

/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*
rhutilc.h
Header for my collection of utility routines in C.
*/

#include <stdint.h>
#include "rhdefines.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ========== Specialized Input Functions: ================================= */

/* ========== Specialized Input Functions: ================================= */

////////////////////////////////////////////////////////////////////////
//                                                                    //
// Wait for user to press one key on keyboard, then return that       //
// character, the instant user presses key (no buffering).            //
//                                                                    //
////////////////////////////////////////////////////////////////////////
char getkey (void);


///////////////////////////////////////////////////////////////////////////
//                                                                       //
// Check for recent keypress on keyboard; if there is one, get that one  //
// character; but don't wait more than 1 decisecond for input (keep      //
// executing program).                                                   //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
char getkey_unlocked (void);


/* ========== Random Numbers: ============================================== */

/* Reseed pseudo-random number generator using clock: */
void Randomize (void);

/* Get pseudo-random double: */
double RandDouble (double min, double max);

/* Get random int: */
int RandInt (int min, int max);

/* Get random long: */
int64_t Rand64 (int64_t min, int64_t max);

/* Get random uint64_t: */
uint64_t RandU64 (uint64_t min, uint64_t max);

/* ========== Clocks, Timers, and Delays: ================================== */

/* Get high-resolution time (time in seconds, to nearest microsecond, since
00:00:00 on the morning of Jan 1, 1970) as double (for timing things): */
double HiResTime (void);

/* Delay for a given time in seconds (resolution is theoretically 1us): */
void Delay (double s);

/* end C++ guard: */
#ifdef __cplusplus
}
#endif

/* end include guard: */
#endif
