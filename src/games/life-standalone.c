/*****************************************************************************\
 * life-standalone.c
 * Plays "Conway's Game of Life".
 * https://en.wikipedia.org/wiki/Conway's_Game_of_Life
 * Edit history:
 * Wed Mar 11, 2020: Split program into two versions, "life.c" (which 
 *                   #include's <rhncgraphics.h>, which is my personal
 *                   library of ncurses-based graphics routines), and
 *                   "life-standalone.c" (which is identical except that
 *                   the needed contents from rhncgraphics.h have been
 *                   written directly into the file).
 * Fri Aug 21, 2020: Corrected errors in comments, options, and help.
 * Tue Mar 01, 2022: Replaced all meta-programming with actual C programming.
 *                   Program no longer has any defines or enums at all.
\*****************************************************************************/

// Includes:

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <errno.h>
#include <error.h>
#include <assert.h>
#include <locale.h>
#include <curses.h>

// Global variables:

static bool       Help                 = false;
static double     Speed                = 2.0;
static bool       Walk                 = false;
static short      Colors               = (short)50; // 50 = 8*6+2 = green_cyan
static char       Charset  [2]         = {' ', 'O'};
static char       GameGrid [100][200]  = {{'\0'}};
static char       FateGrid [100][200]  = {{'\0'}};
static WINDOW *   WindowHandle         = NULL;
static int        Height               = 0;
static int        Width                = 0;
static char       ColorNames[8][8]     =
                  {"black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"};
//   Color index:     0       1       2         3        4        5         6       7

// Function Definitions:

void InitColorPairs (void)
{
   for ( int index = 0 ; index < 64 ; ++index )
      init_pair((short)index, (short)(index%8), (short)(index/8));
   return;
} // end function InitColorPairs()

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
   assume_default_colors(0,0);
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

void SetSettings (int Robin, char * Marian[])
{
   int    Arg         = 0;
   char * Bar         = NULL;
   char   ForeStr[30] = {'\0'};
   char   BackStr[30] = {'\0'};
   short  ForeCol     = 666;
   short  BackCol     = 666;
   short  Color       = 0;

   // For default settings, see global variable initializations above.

   // Override default settings if user so requests:
   for ( Arg = 1 ; Arg < Robin ; ++Arg )
   {
      if ( 0 == strcmp("-h", Marian[Arg]) || 0 == strcmp("--help", Marian[Arg]) )
      {
         Help = true;
      }
      if ( 0 == strncmp("--speed=", Marian[Arg], 8) )
      {
         Speed = (int)strtod(Marian[Arg]+8, NULL);
         if (Speed <  0.25) {Speed =  0.25;}
         if (Speed > 50.00) {Speed = 50.00;}
      }
      if ( 0 == strcmp("-w", Marian[Arg]) || 0 == strcmp("--walk", Marian[Arg]))
      {
         Walk = true;
      }
      if ( 0 == strncmp("--colors=", Marian[Arg], 9) )
      {
         Bar = strchr(Marian[Arg]+9, '_');
         if(Bar)
         {
            *Bar = '\0';
            strcpy(ForeStr, Marian[Arg]+9);
            strcpy(BackStr, Bar + 1);
            for ( Color = 0 ; Color < 8 ; ++Color )
            {
               if (0 == strcmp(ForeStr, ColorNames[Color]))
                  ForeCol = Color;
               if (0 == strcmp(BackStr, ColorNames[Color]))
                  BackCol = Color;
            }
            if (ForeCol >= 0 && ForeCol <= 7 && BackCol >= 0 && BackCol <= 7)
               Colors = (short)(8*BackCol)+ForeCol;
         }
      }
   }
   return;
} // end function SetSettings()

// Initialize the game grid to all "blank" characters:
void InitGameGrid (void)
{
   int Row, Col;
   for ( Row = 0 ; Row < Height ; ++Row )
   {
      for ( Col = 0 ; Col < Width ; ++Col )
      {
         GameGrid[Row][Col] = Charset[0];
      }
   }
   return;
} // end function InitGameGrid()

// Write several immortal skywalkers to game grid:
void WalkGameGrid (void)
{
   // Refresh Width and Height (user may have resized console window):
   getmaxyx(WindowHandle, Height, Width);

   // If new size isn't big enough, warn user then exit program:
   if (Width < 55 || Height < 25)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "ERROR: Must have Width>=55 && Height>=25 to use \"Walk\" mode.\n"
      );
   }

   // Initialize the game grid (else we write on top of old garbage):
   InitGameGrid();

   // Write several immortal skywalkers to game grid:

   GameGrid[ 5][11] = Charset[1];
   GameGrid[ 6][12] = Charset[1];
   GameGrid[ 7][10] = Charset[1];
   GameGrid[ 7][11] = Charset[1];
   GameGrid[ 7][12] = Charset[1];
  
   GameGrid[20][21] = Charset[1];
   GameGrid[21][22] = Charset[1];
   GameGrid[22][20] = Charset[1];
   GameGrid[22][21] = Charset[1];
   GameGrid[22][22] = Charset[1];

   GameGrid[15][31] = Charset[1];
   GameGrid[16][32] = Charset[1];
   GameGrid[17][30] = Charset[1];
   GameGrid[17][31] = Charset[1];
   GameGrid[17][32] = Charset[1];
  
   GameGrid[ 9][41] = Charset[1];
   GameGrid[10][42] = Charset[1];
   GameGrid[11][40] = Charset[1];
   GameGrid[11][41] = Charset[1];
   GameGrid[11][42] = Charset[1];

   GameGrid[17][51] = Charset[1];
   GameGrid[18][52] = Charset[1];
   GameGrid[19][50] = Charset[1];
   GameGrid[19][51] = Charset[1];
   GameGrid[19][52] = Charset[1];
   return;
} // end function WalkGameGrid()

// Randomize the game grid:
void RandomizeGameGrid (void)
{
   int     Row;    // Raster Row
   int     Col;    // Raster Column
   double  Ratio;  // Live:Blank Ratio
   double  Min;    // Minimum Ratio
   double  Max;    // Maximum Ratio
   int     Live;   // Set Live Cell?

   // Refresh Width and Height (user may have resized console window):
   getmaxyx(WindowHandle, Height, Width);

   // (No need to init the game grid here because this function writes
   // something to every single cell.)

   // Set min and max Live:Dead ratios:
   Min = 0.05;
   Max = 4.00;

   Ratio = (Min-1.0)+exp(log(Max-(Min-1.0))*((double)rand()/(double)RAND_MAX));
   //Ratio = Min + Max*((double)rand()/(double)RAND_MAX);
   for ( Row = 0 ; Row < Height ; ++Row )
   {
      for ( Col = 0 ; Col < Width ; ++Col )
      {
         Live = (int)floor((1.0 + Ratio)*((double)rand()/(double)RAND_MAX));
         GameGrid[Row][Col] = (Live ? Charset[1] : Charset[0]);
      }
   }
   beep();
   return;
} // end function RandomizeGameGrid()

// Write the game grid to the screen:
void WriteGameGrid (void)
{
   int i,j;
   for ( j = 0 ; j < Height ; ++j )
   {
      for ( i = 0 ; i < Width ; ++i )
      {
         WriteChar(GameGrid[j][i], j, i, Colors);
      }
   }

   // Flush the data from RAM to screen (without this we get NOTHING):
   wrefresh(WindowHandle);

   return;
} // end function WriteGameGrid()

// Calculate number of neighbors for each cell:
int Neighbors (int Row, int Col)
{
   int Above, Below, Left, Right;
   int a,b,c,d,e,f,g,h,N;
   if (Row ==    0    ) {Above = Height-1;} else {Above = Row-1;}
   if (Row == Height-1) {Below =    0    ;} else {Below = Row+1;}
   if (Col ==    0    ) {Left  = Width-1 ;} else {Left  = Col-1;}
   if (Col == Width -1) {Right =    0    ;} else {Right = Col+1;}
   a = (GameGrid[Above][Left   ] == Charset[1]) ? 1 : 0;
   b = (GameGrid[Above][Col    ] == Charset[1]) ? 1 : 0;
   c = (GameGrid[Above][Right  ] == Charset[1]) ? 1 : 0;
   d = (GameGrid[Row  ][Right  ] == Charset[1]) ? 1 : 0;
   e = (GameGrid[Below][Right  ] == Charset[1]) ? 1 : 0;
   f = (GameGrid[Below][Col    ] == Charset[1]) ? 1 : 0;
   g = (GameGrid[Below][Left   ] == Charset[1]) ? 1 : 0;
   h = (GameGrid[Row  ][Left   ] == Charset[1]) ? 1 : 0;
   return a+b+c+d+e+f+g+h;
   return N;
} // end function Neighbors()

// Set game grid to next generation:
void NextGen (void)
{
   int Row, Col, N;

   // Calculate fate for each cell:
   for ( Row = 0 ; Row < Height ; ++Row )
   {
      for ( Col = 0 ; Col < Width ; ++Col )
      {
         N = Neighbors(Row, Col);
         if (Charset[1] == GameGrid[Row][Col])  /* if live cell */
         {
            if (2 == N || 3 == N)               /* if moderate neighbors */
            {
               FateGrid[Row][Col] = Charset[1]; /* survive */
            }
            else                                /* if crowded or lonely */
            {
               FateGrid[Row][Col] = Charset[0]; /* die */
            }
         }
         else                                   /* if dead cell */
         {
            if (3 == N)                         /* if optimal neighbors */
            {
               FateGrid[Row][Col] = Charset[1]; /* spawn */
            }
            else                                /* if crowded or lonely */
            {
               FateGrid[Row][Col] = Charset[0]; /* don't spawn */
            }
         }
      }
   }

   // Cause each cell to meet its fate:
   for ( Row = 0 ; Row < Height ; ++Row )
   {
      for ( Col = 0 ; Col < Width ; ++Col )
      {
         GameGrid[Row][Col] = FateGrid[Row][Col]; 
      }
   }
   return;
} // end function NextGen()

void PrintHelpMsg (void)
{
   printf("Welcome to Robbie Hatley's implementation of Conway's Game Of Life.\n");
   printf("\n");
   printf("Command Line:\n");
   printf("life [options]\n");
   printf("\n");
   printf("If no options are given, the game starts with a random pattern and\n");
   printf("plays at 2 frames per second.\n");
   printf("\n");
   printf("If a -h or --help option is given, this help is prints and the program exits.\n");
   printf("\n");
   printf("If a --speed=NUMBER option is given, the NUMBER should be in the\n");
   printf("0.2 to 50.0 range; it will be interpreted as speed in frames per second.\n");
   printf("\n");
   printf("If a -w or --walk option is given, the game will start in \"Walk\" mode,\n");
   printf("using a starting pattern consisting of several Skywalkers.\n");
   printf("\n");
   printf("If a --colors=foreground_background option is given, with\n");
   printf("\"foreground\" and \"background\" each being one of\n");
   printf("black, red, green, yellow, blue, magenta, cyan, black,\n");
   printf("then the foreground and background colors will be set accordingly.\n");
   printf("\n");
   printf("Any other options or arguments will be ignored.\n");
   printf("\n");
   printf("At any time during the game, the following single-key commands may be used\n");
   printf("to adust the gameplay:\n");
   printf("q = quit\n");
   printf("p = pause\n");
   printf("r = randomize game grid\n");
   printf("n = compute next generation\n");
   printf("f = faster\n");
   printf("s = slower\n");
   return;
} // end function Help()

/* Get high-resolution time (time in seconds, to nearest microsecond, since
   00:00:00 on the morning of Jan 1, 1970) as a double (for timing things): */
double HiResTime (void)
{
   struct timeval t;
   gettimeofday(&t, NULL);
   return (double)t.tv_sec + (double)t.tv_usec / 1000000.0;
} // end function HiResTime()

// Program entry point:
int main (int Robin, char * Marian[])
{
   int     c       = 0;      // incoming character from keyboard
   bool    Pause   = false;  // pause the game?
   double  t0      = 0;      // start time for delay
   double  t1      = 0;      // end   time for delay
   double  Period  = 0.0;    // actual period between refreshes

   // Set Settings, based on defaults and on user overrides:
   SetSettings(Robin, Marian);

   // If user wants help, just print help and exit:
   if (Help)
   {
      PrintHelpMsg();
      exit(EXIT_SUCCESS);
   }

   // Seed the pseudo-random-number generator with time:
   srand((unsigned)time(NULL));

   // Enter curses:
   EnterCurses();

   // Draw skywalkers if in Walk mode:
   if (Walk)
   {
      WalkGameGrid();
      WriteGameGrid();
   }

   // Otherwise, randomize the grid:
   else
   {
      RandomizeGameGrid();
      WriteGameGrid();
   }

   // We're about to enter the main loop, so set time 0 to current time:
   t0 = HiResTime();

   // Enter main loop:
   while ( 1 )
   {
      // If sufficient time has expired, compute next generation and
      // flush data from RAM to display screen:
      t1 = HiResTime();
      if (t1 - t0 >= 1/Speed)
      {
         if (!Pause)
         {
            NextGen();       // Compute cell states for next generation.
            WriteGameGrid(); // Write those new cell states to the display.
         }
         Period = t1-t0;
         t0 = t1;
      }

      // Check for user input and take action if necessary:
      c = getch();

      if ('q' == (char)c)          // Quit game
         break;

      if ('p' == (char)c)          // toggle Pause mode
      {
         Pause = !Pause;
         t0 = HiResTime();
      }

      if ('r' == (char)c)          // Randomize the grid
      {
         RandomizeGameGrid(); 
         WriteGameGrid();
         t0 = HiResTime();
      }

      if ('w' == (char)c)          // load grid with immortal skyWalkers
      {
         WalkGameGrid();
         WriteGameGrid();
         t0 = HiResTime();
      }

      if ('n' == (char)c)          // jump to Next generation and pause
      {
         NextGen();
         WriteGameGrid();
         Pause=true;
         t0 = HiResTime();
      }
      
      if ('f' == (char)c)          // go Faster
      {
         Speed*=1.5;
         if(Speed>50.00)
         {
            Speed=50.00;
         }
      }
      
      if ('s' == (char)c)          // go Slower
      {
         Speed/=1.5;
         if(Speed< 0.2)
         {
            Speed= 0.2;
         }
      }

   } // end of main loop
   ExitCurses();
   printf("Last Period = %f seconds.\n", Period);
   exit(EXIT_SUCCESS);
}
