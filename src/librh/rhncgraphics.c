/* This is a 79-character-wide ASCII C source-code text file.                */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

/*****************************************************************************\
 * rhncgraphics.c
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

#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
#include <locale.h>

//#define NDEBUG
#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#include "rhncgraphics.h"

// Global variables:

int      NumColors        = 0;
WINDOW * WindowHandle     = NULL;
int      Height           = 0;
int      Width            = 0;
char     ColorNames[8][8] = {"black",
                             "red",
                             "green",
                             "yellow",
                             "blue",
                             "magenta",
                             "cyan",
                             "white",};

// Functions:

void EnterCurses (void)
{
   setlocale(LC_ALL, "en_US.ISO-8859-1");
   WindowHandle = initscr(); 
   cbreak(); 
   noecho();
   nonl();
   nodelay(WindowHandle, 1);
   getmaxyx(WindowHandle, Height, Width);
   start_color();
   InitColorPairs();
   attron(A_BOLD);
   clear();
   wrefresh(WindowHandle);
   return;
} // end function EnterCurses()

void ExitCurses (void)
{
   nodelay(WindowHandle, 0);
   echo();
   nocbreak();
   attroff(A_BOLD);
   delwin(WindowHandle);
   endwin();
   return;
} // end function ExitCurses()

void WriteChar (char c, int Row, int Column, int Color)
{
   move(Row, Column);
   addch((chtype)((long)c|(long)COLOR_PAIR(Color)));
   return;
} // end function WriteChar()

void WriteString (const char * String, int Row, int Column, int Color)
{
   move(Row, Column);
   do {addch((chtype)((long)(*String++)|(long)COLOR_PAIR(Color)));}
   while ('\0' != *String);
   return;
} // end function WriteString()

void InitColorPairs (void)
{
   PAIR_INITS
   NumColors = 64;
   return;
} // end function InitColorPairs()
