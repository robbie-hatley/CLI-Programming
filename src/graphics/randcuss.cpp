/****************************************************************************\
 * randcuss.cpp
 * Prints random cusswords all over the screen.
 * Written Tue. June 07, 2005 by Robbie Hatley.
 * Edit history:
 *   Jun 07, 2005: Wrote it.
 *   Feb 22, 2018: Updated. Changed from DJGPP & DOS to Cygwin & Ncurses.
\****************************************************************************/

// INCLUDED HEADERS:
#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <cstring>

#include "rhutil.hpp"
#include "rhmath.hpp"
#include "rhncgraphics.h"

// "USING" DECLARATIONS:
using std::string;
using std::vector;
using rhutil::Randomize;
using rhutil::RandInt;
using rhutil::Delay;

// FUNCTION PROTOTYPES:
void   LoadCusswords (void);

// GLOBAL VARIABLES:
vector<string>   CussWords;

// MAIN:
int main(void)
{
   int c;
   Randomize();
   LoadCusswords();
   int Limit = int(CussWords.size())-1;
   EnterCurses();
   
   while (1)
   {
      c = getch();
      if ('q' == char(c)) 
      {
         ExitCurses();
         break;
      }
      WriteString
         (
            CussWords[RandInt(0,Limit)].c_str(), // Random cuss word.
            RandInt(0, Height -  2),             // Random vertical position.
            RandInt(0, Width  - 19),             // Random horizontal position.
            RandInt(1, 21)                       // Random color.
         );
      Delay(1.0);
   }
   return 0;
} // end main()

// FUNCTION DEFINITIONS:

void LoadCusswords (void)
{
   CussWords.reserve(20);
   CussWords.push_back("EB TVOYU MAT!!!");
   CussWords.push_back("FUCK!!!");
   CussWords.push_back("FUCK YOU!!!");
   CussWords.push_back("FUCKING-SHIT!!!");
   CussWords.push_back("SHIT!!!");
   CussWords.push_back("DAMN!!!");
   CussWords.push_back("GODDAM!!!");
   CussWords.push_back("CRAP!!!");
   CussWords.push_back("MOTHER-FUCKER!!!");
   CussWords.push_back("HOLY-CRAP!!!");
   CussWords.push_back("HOLY-SHIT!!!");
   CussWords.push_back("AYE-CHINGAR!!!");
   CussWords.push_back("CHINGADERA!!!");
   CussWords.push_back("CHINGATE, PUTO!!!");
   CussWords.push_back("CARAMBA!!!");
   CussWords.push_back("AYE-CARAMBA!!!");
   CussWords.push_back("AYE-CHIHUAHUA!!!");
   return;
}
