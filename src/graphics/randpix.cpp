// This is a 111-character-wide ASCII-encoded C++ source-code text file.
// ======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * randpix.cpp
 * A random-pixel bitmap program.
 * Author: Robbie Hatley
 * Edit history:
 *   Sun Jan 13, 2002: Wrote it.
 *   Sun Nov 17, 2002: Edited it.
 *   Sun Jun 29, 2007: Updated it.
 *   Mon Feb 05, 2018: Changed tints to be positive or negative, and added "granularity". Simplified.
 *                     Changed "CheckArgs()" to "SetParameters()". Included file name in Parameters.
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <iostream>
#include <string>
#include <vector>
#include <cmath>

#define BLAT_ENABLE
#include "rhdefines.h"

#include "rhutil.hpp"
#include "rhdir.hpp"
#include "rhbitmap.hpp"
#include "rhmath.hpp"

using rhutil::Randomize;
using rhutil::RandInt;

namespace ns_RandPix
{
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::string;
   using std::vector;

   typedef vector<string> VS;

   struct Parameters
   {
      int     gra; // Image Granularity
      int     wid; // Image Width
      int     hgt; // Image Height
      int     red; // Red   Pixel Tint
      int     grn; // Green Pixel Tint
      int     blu; // Blue  Pixel Tint
      string  fil; // File Name
   };

   int  SetParameters (VS const & Args, Parameters & P);
   int  RandPix       (Parameters const & P);
   void Help          (void);
}

int main(int Beren, char *Luthien[])
{
   using namespace ns_RandPix;

   // If user just wants help, give help and return:
   if ( 2 == Beren && (0 == strcmp("-h", Luthien[1]) || 0 == strcmp("--help", Luthien[1])))
   {
      Help();
      return 777;
   }

   // Otherwise, we must have 7 command-line arguments, so Beren must be 8:
   if (8 != Beren)
   {cerr << "Error: invalid number of arguments." << endl; Help(); return 666;}

   // Dump all the command-line args into a std::vector of std::string :
   vector<string> Args;
   for (int i = 1; i < Beren; ++i) {Args.push_back(std::string(Luthien[i]));}

   // Make and set a Parameters object:
   Parameters P;
   if (42 != SetParameters(Args, P)) return 666;

   // Make the random-pixels file:
   RandPix(P);

   // We be done, so scram:
   return 0;
} // end main()

int ns_RandPix::SetParameters (VS const & Args, Parameters & P)
{
   BLAT("At top of SetParameters. # of args = " << Args.size() << endl)
   
   P.gra = stoi(Args[0]);
   P.wid = stoi(Args[1]);
   P.hgt = stoi(Args[2]);
   P.red = stoi(Args[3]);
   P.grn = stoi(Args[4]);
   P.blu = stoi(Args[5]);
   P.fil =      Args[6] ;

   BLAT("In SetParameters. Just loaded P from Args. The 7 fields of P are:")
   BLAT("Granularity = " << P.gra)
   BLAT("Width       = " << P.wid)
   BLAT("Height      = " << P.hgt)
   BLAT("Red   tint  = " << P.red)
   BLAT("Green tint  = " << P.grn)
   BLAT("Blue  tint  = " << P.blu)
   BLAT("File name   = " << P.fil)
   BLAT("About to check parameters for validity." << endl)

   if (P.gra < 1 || P.gra > 10000)
   {cerr << "ERROR! Granularity must bee from 1 to 10000." << endl; return 666;}

   if (P.wid < 1 || P.wid > 10000 || P.hgt < 1 || P.hgt > 10000)
   {cerr << "ERROR! Height and width must both be from 1 to 10000 pixels." << endl; return 666;}

   if (P.red < -255 || P.red > 255 || P.grn < -255 || P.grn > 255 || P.blu < -255 || P.blu > 255)
   {cerr << "ERROR! Red, Green, and Blue tints must all be from -255 to +255." << endl; return 666;}

   if (rhdir::FileExists(P.fil))
   {cerr << "ERROR!  A file with that name already exists!" << endl; return 666;}

   // If we get to here, there are no obvious errors, so return success code:
   BLAT("At bottom of SetParameters, about to return 42.")
   return 42;
}

int ns_RandPix::RandPix (Parameters const & P)
{
   BLAT("At top of ns_RandPix::RandPix.")

   // Declare horizontal and vertical indexes:
   short int x; // horizontal index
   short int y; // vertical   index

   // Set R G B mins and maxes:
   int red_min = P.red > 0 ?   0 + P.red :   0;
   int red_max = P.red < 0 ? 255 + P.red : 255;
   int grn_min = P.grn > 0 ?   0 + P.grn :   0;
   int grn_max = P.grn < 0 ? 255 + P.grn : 255;
   int blu_min = P.blu > 0 ?   0 + P.blu :   0;
   int blu_max = P.blu < 0 ? 255 + P.blu : 255;

   // Create a color grid:
   int grid_y = int(ceil(double(P.hgt)/double(P.gra)));
   int grid_x = int(ceil(double(P.wid)/double(P.gra)));
   // grid_y rows of grid_x columns:
   BLAT("In ns_RandPix::RandPix, about to make vector of vectors.")
   static vector<vector<rhbitmap::Color> > RandomColors 
      (grid_y, vector<rhbitmap::Color> (grid_x, rhbitmap::Color ()));
   BLAT("In ns_RandPix::RandPix, finished making vector of vectors.")

   // Seed the random number generator:
   Randomize();

   // Load color grid with random colors:
   for ( y = 0 ; y < grid_y ; ++y ) // for each row (grid_y rows)
   {
      for ( x = 0 ; x < grid_x ; ++x ) // for each column (grid_x columns)
      {
         RandomColors[y][x].red   = uint8_t(RandInt (red_min, red_max));
         RandomColors[y][x].green = uint8_t(RandInt (grn_min, grn_max));
         RandomColors[y][x].blue  = uint8_t(RandInt (blu_min, blu_max));
      }
   }

   BLAT("In ns_RandPix::RandPix, about to make bitmap object.")

   // Make a bitmap object:
   rhbitmap::Bitmap bmp (P.wid, P.hgt, 24, false);

   BLAT("In ns_RandPix::RandPix, about to set colors of bitmap object.")

   // Set the colors of the bitmap object to the colors of our grid:
   for ( y = 0 ; y < P.hgt ; ++y ) // for each row (P.hgt rows)
   {
      for ( x = 0 ; x < P.wid ; ++x ) // for each column (P.wid columns)
      {
         assert(y/P.gra < grid_y);
         assert(x/P.gra < grid_x);
         bmp.setcolor (x, y, RandomColors[y/P.gra][x/P.gra]);
      }
   }

   BLAT("In ns_RandPix::RandPix, about to write bitmap file.")

   // Write the bitmap object to a bitmap file:
   bmp.filewrite (P.fil);

   BLAT("In ns_RandPix::RandPix, wrote bitmap file, about to return.")

   // We be done, so scram:
   return 42;
}

void ns_RandPix::Help (void)
{
   cout
   << "Welcome to RandPix, Robbie Hatley's nifty random-color-pixel image generator."   << endl
   << "Randpix must have 7 arguments: "                                                 << endl
   << "Granularity, width, height, tint-red, tint-green, tint-blue, and file-name."     << endl
   << "Granularity is the size of each colored square and can be from 1 to 10000."      << endl
   << "The \"width\" and \"height\" arguments must be integers in the 1-10000 range."   << endl
   << "The \"tint\" arguments must be integers in the -255 to +255 range."              << endl
   << "Normally, the red, green, and blue intensities of the pixels will all be random" << endl
   << "numbers in the 0-255 range, corresponding to 0%-100% intensity."                 << endl
   << "Tints > 0 will increase the minimums to the given values."                       << endl
   << "Tints < 0 will decrease the maximums to the given values."                       << endl
   << "Thus the picture can be made darker by setting all three tints to below 0,"      << endl
   << "(say, -128 -128 -128). Or, the over-all color of the pic can be skewed by using" << endl
   << "unequal tints (say, 175 -115 -27, which will be mostly shades of red)."          << endl;
   return;
}
