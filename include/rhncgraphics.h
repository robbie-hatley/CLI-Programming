#ifndef rhncgraphics_H_ALREADY_INCLUDED
#define rhncgraphics_H_ALREADY_INCLUDED

/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * rhncgraphics.h
 * Provides functions for writing text to specified locations on a screen,
 * by using the "ncurses" library.
 * Originally written by Robbie Hatley on Wed. June 26, 2002, for DJGPP and
 * Windows DOS console. Rewritten by Robbie Hatley on Thu Feb 22, 2018,
 * now using ncurses.
 *
 * Edit history:
 *   Wed Jun 26, 2002: Wrote original (DOS) version.
 *   Tue Jun 07, 2005: Re-wrote using enum instead of #define for constants.
 *   Thu Feb 22, 2018: Re-wrote for ncurses. Now include-able in C or C++.
 *   Wed Mar 11, 2020: Implemented the full 64 possible color combos, and
 *                     refactored enums and pair-inits using meta-programming.
\*****************************************************************************/

#include <stdint.h>

#include <curses.h>

#include "rhdefines.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PAIR_NAME(FORE,BACK)  \
   FORE ## _ ## BACK ,

#define PAIR_NAMES_BACK(BACK) \
PAIR_NAME(BLACK   , BACK)     \
PAIR_NAME(RED     , BACK)     \
PAIR_NAME(GREEN   , BACK)     \
PAIR_NAME(YELLOW  , BACK)     \
PAIR_NAME(BLUE    , BACK)     \
PAIR_NAME(MAGENTA , BACK)     \
PAIR_NAME(CYAN    , BACK)     \
PAIR_NAME(WHITE   , BACK)

#define PAIR_NAMES            \
PAIR_NAMES_BACK(BLACK)        \
PAIR_NAMES_BACK(RED)          \
PAIR_NAMES_BACK(GREEN)        \
PAIR_NAMES_BACK(YELLOW)       \
PAIR_NAMES_BACK(BLUE)         \
PAIR_NAMES_BACK(MAGENTA)      \
PAIR_NAMES_BACK(CYAN)         \
PAIR_NAMES_BACK(WHITE)

#define PAIR_INIT(FORE,BACK)  \
   init_pair( FORE ## _ ## BACK , COLOR_ ## FORE , COLOR_ ## BACK );

#define PAIR_INITS_BACK(BACK) \
PAIR_INIT(BLACK   , BACK)     \
PAIR_INIT(RED     , BACK)     \
PAIR_INIT(GREEN   , BACK)     \
PAIR_INIT(YELLOW  , BACK)     \
PAIR_INIT(BLUE    , BACK)     \
PAIR_INIT(MAGENTA , BACK)     \
PAIR_INIT(CYAN    , BACK)     \
PAIR_INIT(WHITE   , BACK)

#define PAIR_INITS            \
PAIR_INITS_BACK(BLACK)        \
PAIR_INITS_BACK(RED)          \
PAIR_INITS_BACK(GREEN)        \
PAIR_INITS_BACK(YELLOW)       \
PAIR_INITS_BACK(BLUE)         \
PAIR_INITS_BACK(MAGENTA)      \
PAIR_INITS_BACK(CYAN)         \
PAIR_INITS_BACK(WHITE)

/* types: */

typedef enum ColorPair_tag
{
PAIR_NAMES
} ColorPair;

/* variables: */

extern int      NumColors;
extern WINDOW * WindowHandle;
extern int      Height;
extern int      Width;
extern char     ColorNames[8][8];

/* functions: */

void EnterCurses (void);
void ExitCurses  (void);
void WriteString (const char * String, int Row, int Column, int Color);
void WriteChar (char c, int Row, int Column, int Color);
void InitColorPairs (void);

/* end C++ guard: */
#ifdef __cplusplus
}
#endif

/* end include guard: */
#endif
