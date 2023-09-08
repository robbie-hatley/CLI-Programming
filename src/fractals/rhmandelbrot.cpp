/************************************************************************************************************\
 * rhmandelbrot.cpp
 * Robbie Hatley's Mandelbrot Set graphing program,
 *
 * Description:
 *    This program graphs any desired portion of the complex plane, displaying points of the plane as pixels
 *    with colors indicating how mathematically "close" the points are to The Mandelbrot Set.
 *
 * Abstract:
 *    So...  what is "The Mandlebrot Set"?
 *    The Mandelbrot Set is the graph in the complex plane, within 3 units of 0+0i, of all complex numbers c
 *    for which the iterated equation z(n+1)=z(n)^d+c (where d is the "degree" of the Mandelbrot set being
 *    graphed and must be a positive integer in the range of 2-13, and z(0)=0) yields z values with absolute
 *    values which remain less than 3 as n tends to infinity.  This might just be the most complex object in
 *    mathematics.
 *
 * Inputs:
 *    Input is via eleven command-line arguments (for details, see Instructions()) and via an initialization
 *    file, "mandelbrot.ini", currently used to initialize a color table.
 *
 * Outputs:
 *    This program generates a bitmap graph of a region of the complex plane, coloring each pixel commensurate
 *    with the the mathematical "nearness" of the pixel's point to The Mandelbrot Set.  ("Nearness" is
 *    determined by how many iterations the defining equation can be looped before the z value exceeds 3,
 *    since once z exceeds 3, it will explode towards infinity exponentially).  The bitmap is then written
 *    to the file path given on the command line.  (See Instructions() for details on command-line fields.)
 *
 * To make:
 *    Compile with a C++ compiler and link with rhutil.o , rhmath.o , and rhbitmap.o in SLL librh.a .
 *
 * Written by Robbie Hatley on Wednesday January 16, 2002.
 * Edit history:
 * Wed Jan 16, 2002: Wrote first draft
 * Sun Sep 26, 2004: Added some comments and improved formatting.
 * Mon Oct 04, 2004: Converted to a "neighborhood shotgun set" approach.
 * Tue Oct 05, 2004: Re-wrote CyclicRainbow() (simplified dramatically).
 * Thu Oct 14, 2004: Corrected ini-file path to "C:/Software/mandelbrot.ini"
 * Sun Feb 20, 2005: Corrected ini-file path to "C:/bin/mandelbrot.ini"; corrected errors in help.
 * Mon May 03, 2016: Corrected ini-file path to "/rhe/bin/fractals" for use with Cygwin64.
 * Wed Jun 01, 2016: Added argument for "degree" 2-13 to make cubic, quartic, quintic, etc, sets.
 * Thu Dec 14, 2017: Corrected comments and Help().
 * Thu Jan 04, 2018: Corrected ini-file location to "/cygdrive/d/rhe/bin/fractals".
 * Thu Jan 11, 2018: Corrected errors in help.
 * Tue Jan 16, 2018: Increased max degree to 13. Changed limit from multiple-choice to formula.
 * Wed Jan 17, 2018: Increased max size to 10001x10001 (about 100MB).
 * Sun Jan 18, 2018: Altered Color-Table Mode to force iterations=COLORS-1 & skew_factor=0.0 .
 * Thu Dec 19, 2019: Changed ini-file location to "/cygdrive/d/rhe/bin_64_bash/fractals".
 * Fri Dec 20, 2019: Added arg for ini file selection (use "NULL" or whatever if not using an ini file).
 * Sun Mar 01, 2020: Refactored. Removed functions "InitializeColorTable" and "DefaultColorTable" (both
 *                   now subsumed into DefineColors). Removed try/catch blocks and reverted to
 *                   non-"Exception" error handling.
 * Sat Feb 20, 2021: Changed ini-file location to "/cygdrive/d/rhe/bin/fractals".
 * Thu Sep 07, 2023: Renamed from "mandelbrot.cpp" to "rhmandelbrot.cpp".
\************************************************************************************************************/

// Includes:

#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <string>

#include <cstdlib>
#include <cstring>
#include <cmath>

#undef NDEBUG
//#define NDEBUG
#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#undef BLAT_ENABLE
#include "rhdefines.h"

#include "rhutil.hpp"
#include "rhmath.hpp"
#include "rhbitmap.hpp"

namespace ns_Mandelbrot
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::flush;
   using std::setw;
   using std::setfill;
   using std::setprecision;
   using std::string;

   typedef std::vector<rhbitmap::Color> SVRC;

   // Constants:
   const double Pi = 3.141592654;

   // Global variables:
   std::string exefile; // Name of executable file from which this program was launched.

   // Exception structs for throwing:
   struct ArgRngError
   {
      string message;
      ArgRngError(string s) : message(s) {}
   };
   struct FileExistsError
   {
      string name;
      FileExistsError(string s) : name(s) {}
   };
   struct NoIniFileError
   {
      string path;
      NoIniFileError(string s) : path(s) {}
   };

   // Function prototypes:

   void
   DefineColors
      (
         char         & colorswitch, // b&w? grey? inifile? continuous rainbow? cyclic rainbow?
         SVRC         & colortable,  // table of colors
         int          & COLORS,      // colors used by fractal image (always <= number of colors in table)
         string const & inifilename  // color-table initialization file
      );

   void
   SetupBitmapParameters
      (
         int    const & COLORS,      // number of colors used by fractal image (<= number of colors in table)
         int          & bitcount,    // bit-depth of pixels (always 1, 4, 8, or 24)
         bool         & compress     // use compression? (0 or 1)
      );

   void
   ProcessPixels
      (
         rhbitmap::Fractal  &  mandelbrot  // fractal object containing headers, color table, pixels, etc
      );

   double
   Fate
      (
         int     degree,     // degree of equation
         double  seed_r,     // real      part of c
         double  seed_i,     // imaginary part of c
         int     iterations  // target number of iterations
      );

   inline
   double
   Skew
      (
         double s, // Skew Factor
         double f  // Longevity Fraction
      );

   rhbitmap::Color
   ContinuousRainbow
      (
         double f // Longevity Fraction
      );

   rhbitmap::Color
   CyclicRainbow
      (
         const double & f,  // Longevity Fraction
         const double & cyclicity
      );

   void Pow
      (
         long double const  &  xr, // input, real part
         long double const  &  xi, // input, imaginary part
         int         const  &  n,  // exponent
         long double        &  yr, // output, real part
         long double        &  yi  // output, imaginary part
      );

   void
   Help
   (
      void
   );

}

/************************************************************************************************************\
 * main()
\************************************************************************************************************/
int main(int Gaston, char *Benoit[])
{
   std::ios_base::sync_with_stdio();
   using namespace ns_Mandelbrot;

   // Store name of program in global variable exefile:
   exefile = string(Benoit[0]);

   // ============= Process command-line arguments: ===========================================================

   // If user wants help, print help and exit:
   if (rhutil::HelpDecider(Gaston, Benoit, Help)) {exit(777);}

   // Otherwise, did user enter the correct number of arguments?
   if (!(15==Gaston))
   {
      cerr
      << "Error in Mandelbrot: This program takes 14 arguments, but you only typed"               << endl
      << Gaston - 1 << " arguments. Type \"mandelbrot -h\" or \"mandelbrot --help\" for help."    << endl;
      exit(666);
   }

   // Store arguments:
   int     degree      = atoi   (Benoit[ 1]);      // degree (2-13)
   double  x_min       = strtod (Benoit[ 2],NULL); // minimum x value
   double  x_max       = strtod (Benoit[ 3],NULL); // maximum x value
   double  y_min       = strtod (Benoit[ 4],NULL); // minimum y value
   double  y_max       = strtod (Benoit[ 5],NULL); // maximum y value
   int     iterations  = atoi   (Benoit[ 6]);      // number of iterations
   int     width       = atoi   (Benoit[ 7]);      // image width  in pixels
   int     height      = atoi   (Benoit[ 8]);      // image height in pixels
   char    colorswitch =         Benoit[ 9][0];    // color switch
   string  inifilename = string (Benoit[10]);      // file name for ini file
   double  cyclicity   = strtod (Benoit[11],NULL); // cyclicity
   double  skew_factor = strtod (Benoit[12],NULL); // skew_factor
   int     granularity = atoi   (Benoit[13]);      // Granularity
   string  bmpfilename = string (Benoit[14]);      // file name for bmp file

   // Check arguments for validity:
   try
   {
      if (degree < 2 || degree > 13)             throw ArgRngError("Invalid degree.");
      if (x_min<-3.0 or x_min>3.0)               throw ArgRngError("Invalid x_min.");
      if (x_max<-3.0 or x_max>3.0)               throw ArgRngError("Invalid x_max.");
      if (y_min<-3.0 or y_min>3.0)               throw ArgRngError("Invalid y_min.");
      if (y_max<-3.0 or y_max>3.0)               throw ArgRngError("Invalid y_max.");
      if (iterations<1 or iterations>50000)      throw ArgRngError("Invalid iterations.");
      if (width<1 or width>10001)                throw ArgRngError("Invalid image width.");
      if (height<1 or height>10001)              throw ArgRngError("Invalid image height.");
      if (0==strchr("bcdgry", colorswitch))      throw ArgRngError("Invalid color switch.");
      if (cyclicity<0.1 or cyclicity>1000000.0)  throw ArgRngError("Invalid cyclicity.");
      if (skew_factor<0.0 || skew_factor>1.0)    throw ArgRngError("Invalid skew factor.");
      if (granularity < 3 || granularity > 7)    throw ArgRngError("Invalid Granularity.");

      // Declare flag for checking existence of files:
      bool file_exist_flag;

      // Check to see if a file with the name in "bmpfilename" exists in CWD (it shouldn't):
      std::ifstream hBmpFile (bmpfilename.c_str());
      file_exist_flag = hBmpFile.is_open();
      if (file_exist_flag) hBmpFile.close();
      if (file_exist_flag)                       throw FileExistsError (bmpfilename);

      // If colorswitch is 'c' then check to see if a file with the name in "inifilename" exists in the
      // directory "/rhe/bin/fractals" (it should):
      if ('c' == colorswitch)
      {
         string inifilepath = string("/rhe/bin/fractals/")+inifilename;
         std::ifstream hIniFile (inifilepath.c_str());
         file_exist_flag = hIniFile.is_open();
         if (file_exist_flag) hIniFile.close();
         if (!file_exist_flag)                   throw NoIniFileError (inifilepath);
      }
   }
   catch(ArgRngError incoming_error)
   {
      cerr
         << "Error in mandelbrot main(): " << incoming_error.message << endl;
      Help();
      exit(EXIT_FAILURE);
   }
   catch(FileExistsError File)
   {
      cerr
         << "Error in mandelbrot main(): " << endl
         << "A file named " << File.name << " already exists.  Exiting program." << endl;
      exit(EXIT_FAILURE);
   }
   catch(NoIniFileError File)
   {
      cerr
         << "Error in mandelbrot main(): " << endl
         << "No inifile with path " << File.path << " exists.  Exiting program." << endl;
      exit(EXIT_FAILURE);
   }

   // ============= Decide what colors to use: ===============================================================

   int COLORS; // number of colors used by fractal image

   // Declare and initialize a color table to 256 colors, all black (this color table is not always used,
   // but function "DefineColors" below will need access to it if 256-or-fewer colors will be used):
   std::vector<rhbitmap::Color> colortable (256, rhbitmap::Color (0x00, 0x00, 0x00));

   // Determine what kind of color scheme (b&w? greyscale? inifile? continuous rainbow? cyclic rainbow?) to
   // use for our "mandelbrot" fractal object which we create below. If 256-or-fewer colors are being used,
   // store these colors in colortable, in order from mathematically "farthest" to mathematically "closest"
   // from The Mandelbrot Set (they'll get copied to mandebrot's own color table by a for loop below).
   // If COLORS > 256, the color table isn't used and isn't written to the bmp file.
   // The following function sets colortable (maybe) and COLORS, based on colorswitch and inifilename (maybe):
   DefineColors(colorswitch, colortable, COLORS, inifilename);

   // ============= Warn about iterations!=COLORS-1 in color-table mode: =====================================
   if ( COLORS <= 256 && iterations != COLORS - 1 )
   {
      cerr
         << "WARNING: If iterations > COLORS-1 in color-table mode, non-zero-potential"       << endl
         << "points may be colored the zero-potential color, and if iterations < COLORS-1,"   << endl
         << "some colors will be skipped."                                                    << endl;
   }

   // ============= Warn about skew>0 in color-table mode: ===================================================
   if (COLORS <= 256 && skew_factor > 0.0 )
   {
      cerr
         << "WARNING: Using a non-zero skew in color-table mode may cause some colors to be"  << endl
         << "skipped or re-used."                                                             << endl;
   }

   // ============= Set-up parameters for bitmap: ============================================================
   int bitcount;    // bits per pixel
   bool compress;   // will file be compressed?
   SetupBitmapParameters(COLORS, bitcount, compress); // loads values into "bitcount" and "compress"

   // ============= Create a Fractal object to hold the fractal: =============================================
   static rhbitmap::Fractal mandelbrot =
      rhbitmap::Fractal
      (
         degree,
         iterations,
         colorswitch,
         COLORS,
         cyclicity,
         skew_factor,
         granularity,
         bmpfilename,
         x_min,
         x_max,
         y_min,
         y_max,
         width,
         height,
         bitcount,
         compress
      );


   // If bitcount is less than 24, load colortable[] into mandelbrot:
   if (bitcount<24)
   {
      // How many colors are in mandelbrot's color table?
      int colors = mandelbrot.getcolors(); // number of colors in bmp-file color table
      for ( int i = 0 ; i < colors ; ++i )
      {
         mandelbrot.settable(i, colortable[i]);
      }
   }

   // Process pixels:
   ProcessPixels(mandelbrot);

   // Write bitmap to disk file:
   mandelbrot.filewrite(bmpfilename);

   // Display image:
   //std::string Command {};
   //Command = std::string("chmod u=rwx,g=rwx,o=rx '") + bmpfilename + "'";
   //std::system(Command.c_str());
   //Command = std::string("cmd /C '") + bmpfilename + "' &";
   //std::system(Command.c_str());

   // Return to operating system:
   return 0;
} // end main()


/************************************************************************************************************\
 * DefineColors()
 * Sets colortable and COLORS based on colorswitch (and inifilename, if colorswitch is 'c').
\************************************************************************************************************/
void
ns_Mandelbrot::
DefineColors
   (
      char         & colorswitch, // b&w? grey? inifile? continuous rainbow? cyclic rainbow?
      SVRC         & colortable,  // table of colors
      int          & COLORS,      // colors used by fractal image (always <= number of colors in table)
      string const & inifilename  // color-table initialization file
   )
{
   switch (colorswitch)
   {
      case 'b':
         // Kodalith Mode
         COLORS=2;
         colortable[0] = rhbitmap::Color (0xF0, 0xE8, 0xE0);
         colortable[1] = rhbitmap::Color (0x00, 0x00, 0x00);
         break;

      case 'c':
      { // block, because initializing variables at top of block
         int red=0, grn=0, blu=0;
         int row, subpixel;
         // Inifile Mode
         string inipath = string("/cygdrive/d/rhe/bin/fractals/") + inifilename;
         std::ifstream init(inipath);
         if (!init)
         {
            cerr
               << "Error: can't open inifile " << inifilename << " for reading." << endl
               << "Make sure inifile is in this folder:"                         << endl
               << "/cygdrive/d/rhe/bin/fractals/"                                << endl;
            exit(EXIT_FAILURE);
         }
         init.setf(std::ios::hex, std::ios::basefield);
         // init.setf(ios::showbase);
         for ( row = 0 ; !init.eof() && row < 256 ; ++row )
         {
            for ( subpixel = 0 ; subpixel < 3 ; ++subpixel )
            {
               if (0 == subpixel) {init >> red;}
               if (1 == subpixel) {init >> grn;}
               if (2 == subpixel) {init >> blu;}
               if(!init){break;}
            }
            if(!init){break;}
            colortable[row] = rhbitmap::Color (red, grn, blu);
         }
         // If last read-attempt failed, diagnose the problem:
         if (!init)
         {
            // If the problem was catastrophic, alert user and exit:
            if (init.bad())
            {
               cerr
                  << "SEVERE ERROR ENCOUNTERED while reading inifile " << inifilename << endl
                  << "on row " << row << " subpixel " << subpixel                     << endl;
               exit(EXIT_FAILURE);
            }
            // Did we reach end of file?
            else if (init.eof())
            {
               // If subpixel is equal to 0, we discovered that we're actually past the end of the file on
               // trying to read a "red" byte (first byte of an inifile row). This is normal; do nothing:
               if (0 == subpixel)
               {
                  ; // Condition normal; take no action.
               }
               // Otherwise, we're missing data!
               else
               {
                  cerr
                     << "Error: number of bytes in inifile " << inifilename << endl
                     << "is not a multiple of 3." << endl;
                  exit(EXIT_FAILURE);
               }
            }
            // Did the input file stream fail for some reason other than EOS?
            else if (init.fail())
            {
               cerr
                  << "Error: input file stream entered \"fail\" state while reading inifile" << endl
                  << inifilename << " at line " << row << " subpixel " << subpixel << endl;
               exit(EXIT_FAILURE);
            }
            // We can't possibly get to here. But if we do...
            else
            {
               cerr
                  << "Error: something truly bizarre happened while reading inifile" << endl
                  << inifilename << " at line " << row << " subpixel " << subpixel << endl;
               exit(EXIT_FAILURE);
            }
         }
         // If we get to here, we read the inifile correctly, so close the file and set COLORS to
         // the number of rows we read:
         init.close();
         COLORS=row;
         break;  // end case 'c'
      } // end variable initialization block for case 'c'

      case 'd':
         // Default Color Table
         // Load these 16 colors into the color table and set COLORS to 16:
         colortable[0]  = rhbitmap::Color (0x50, 0x18, 0x10); // soil
         colortable[1]  = rhbitmap::Color (0x80, 0x00, 0x00); // rust
         colortable[2]  = rhbitmap::Color (0xC0, 0x00, 0x00); // burgundy
         colortable[3]  = rhbitmap::Color (0xFF, 0x00, 0x00); // red
         colortable[4]  = rhbitmap::Color (0xFF, 0x40, 0x00); // orange-red
         colortable[5]  = rhbitmap::Color (0xFF, 0x80, 0x00); // orange
         colortable[6]  = rhbitmap::Color (0xF0, 0xC0, 0x00); // yellow-orange
         colortable[7]  = rhbitmap::Color (0xFF, 0xFF, 0x00); // yellow
         colortable[8]  = rhbitmap::Color (0xC0, 0xF0, 0x40); // yellow-green
         colortable[9]  = rhbitmap::Color (0x80, 0xFF, 0x80); // medium-bright green
         colortable[10] = rhbitmap::Color (0x80, 0xFF, 0xC0); // mint-chutney
         colortable[11] = rhbitmap::Color (0x80, 0xFF, 0xFF); // bright aqua
         colortable[12] = rhbitmap::Color (0xF0, 0xD0, 0xFF); // bright lilac-blue
         colortable[13] = rhbitmap::Color (0xFF, 0xE0, 0xFF); // bright lilac
         colortable[14] = rhbitmap::Color (0xFF, 0xFF, 0xFF); // white
         colortable[15] = rhbitmap::Color (0x00, 0x00, 0x00); // black
         COLORS = 16;
         break;
      case 'g':
         // Greyscale Mode
         for (short int i=0; i<256; ++i)
            colortable[i] = rhbitmap::Color (255-i, 255-i, 255-i);
         COLORS=256;
         break;
      case 'r':
         // Continuous Rainbow Mode
         // (color table isn't used for this mode)
         COLORS=16777216;
         break;
      case 'y':
         // Cyclic Rainbow Mode
         // (color table isn't used for this mode)
         COLORS=16777216;
         break;
      default:
         // We can't possibly get here!  But if we do...
         cerr
            << "Error: we somehow made it into the color switch with an invalid value for" << endl
            << "colorswitch.  (colorswitch must be b, c, g, or r.)  Exiting program." << endl;
         exit(EXIT_FAILURE);
   } // end switch (colorswitch)

   // Check to see that at least 2 colors are being used:
   if (COLORS<2)
   {
      cerr << "Error: Must use at least two colors.  Exiting program." << endl;
      exit(EXIT_FAILURE);
   }

   // Print number of colors allocated:
   cout << endl;
   cout << "Number of colors allocated for use by fractal image = " << COLORS << endl;

} // end DefineColors()


/************************************************************************************************************\
 * SetupBitmapParameters()
 * Sets-up parameters "bitcount" and "compress" for construction of a "bitmap, based on COLORS.
\************************************************************************************************************/
void
ns_Mandelbrot::
SetupBitmapParameters
   (
      int   const  & COLORS,    // Number of colors allocated for use by fractal.
      int          & bitcount,  // Bit depth of each pixel (always 1, 4, 8, or 24).
      bool         & compress   // Will compression be used? (0 or 1)
   )
{
   // set colors, bitcount, and compress based on COLORS:
   if ( COLORS <= 16 )
   {
      bitcount = 4;      // to get RLE4 compression
      compress = true;   // to get RLE4 compression
   }
   else if ( COLORS > 16 && COLORS <= 256 )
   {
      bitcount=8;        // to get RLE8 compression
      compress=true;     // to get RLE8 compression
   }
   else
   {
      bitcount=24;       // to get NO compression (16-million-color image)
      compress=false;    // to get NO compression (16-million-color image)
   }

   cout
      << "\nParameters for bitmap:\n"
      << "bitcount     = " << bitcount << '\n'
      << "compression  = " << std::boolalpha << compress
      << endl;

   return;
} // end SetupBitmapParameters()


/************************************************************************************************************\
 * ProcessPixels()
 * Processes the pixels of Fractal object mandelbrot, coloring each pixel commensurate with the percentage
 * attained of target number of iterations the defining equation Z[n]=Z[n-1]^2+C underwent before abs(Z)
 * became greater than 2.1.
\************************************************************************************************************/
void
ns_Mandelbrot::
ProcessPixels
   (
      rhbitmap::Fractal  &  mandelbrot  // NON-CONST REF! THIS FUNCTION MAY ALTER ITS ARGUMENT!
   )
{
   cout << endl;
   cout << "Now iterating defining equation for each pixel..." << endl;

   int height = mandelbrot.getheight();
   int width  = mandelbrot.getwidth();
   double Fraction = 0.0;  // neighborhood-maximum fraction actually obtained of target number of iterations
   double skewed_fraction; // skewed fraction
   int colorselect;        // color selector

   cout << "Now processing row " << flush;

   for (short int j = 0 ; j < height ; ++j)  // for each row in the raster...
   {
      if (j > 0) {for (short int k = 0 ; k < 20 ; ++k) {cout << "\010";}}
      cout << setw(5) << j+1 << " of " << setw(5) << height
           << " (" << setw(2) << int(double(j+1)/double(height)*100.0+0.000001) << "%)" << flush;
      for (short int i = 0 ; i < width ; ++i) // for each pixel in the current row...
      {
         // Neighborhood Issues:
         // For the purposes of this discussion, let M = The Mandelbrot Set, and let P(x) = the "Potential"
         // of point x, which is the mathematical "closeness" of z to the Mandelbrot set, measured by
         // the number n of iterations z lasts in the defining iterative equation z[n]=z[n-1]^2+x before
         // z[n] > 2.1 .
         //
         // Consider the neighborhood of the current pixel consisting of all points which are closer to the
         // center point c of this pixel than to the center points of any adjacent pixels.  This pixel then
         // represents that entire neighborhood.  There is a problem, however, in that this neighborhood
         // may contain many points z with high P(z), and yet P(c) may be very low.  Therefore, if we base
         // the color of this pixel solely on P(c), the pixel may have a color which poorly represents
         // the neighborhood as a whole.
         //
         // So what is the solution to this dilemma?
         //
         // The solution is to form a "shotgun set" of points equally spaced throughout the neighborhood:
         //   ------------
         //   |*  *  *  *|   The splats are the members of a "shotgun set", basically a grid of points
         //   |          |   evenly spaced throughout the neighborhood, like pellets shot from a shotgun.
         //   |*  *  *  *|   Point c is the center point of the neighborhood.
         //   |    c     |   Point c is a member of the shotgun set only if the granularity is odd.
         //   |*  *  *  *|   (Since the granularity of the shotgun set in the diagram to the left is 4,
         //   |          |    c is not a member of the shotgun set in this case.)
         //   |*  *  *  *|
         //   ------------
         // Then we can base the color of the pixel on the potentials of all the points in the shotgun set,
         // not just center point c.  One could use average(P(x)) (for better representation of the
         // neighborhood as a whole), or maximum(P(x)) (for better depiction of the beautiful filimentary
         // connectedness of M), or perhaps a compromise, such as average(average(P(x)), maximum(P(x))).
         // For our purposes, let's use a weighted average: (66.6*maximum(P(x)) + 33.4*average(P(x)))/100.0.
         // This should help to darken-up thin filiments.


         // Create a neighborhood and shotgun set for the current pixel:
         rhmath::Neighborhood N =
            rhmath::Neighborhood
            (
               mandelbrot.getx(i),    // real part of point c
               mandelbrot.gety(j),    // imaginary part of point c
               mandelbrot.horscale(), // width of one pixel
               mandelbrot.verscale(), // height of one pixel
               mandelbrot.granularity // granularity
            );

         // Calculate the fates of all the pellets in the shotgun set:
         N.transform(Fate, mandelbrot.degree, mandelbrot.iterations);

         // Let Fraction equal a weighted average of the maximum and average potentials for the points
         // in the shotgun set:
         Fraction = (66.6 * N.maximum() + 33.4 * N.average()) / 100.0;

         // Apply the requested amount of parabolic skew (from none to heavy) to Fraction, and store in
         // skewed_fraction :
         skewed_fraction = Skew(mandelbrot.skew_factor, Fraction);

         // Now paint the pixel commensurate with skewed_fraction and colorswitch:
         switch (mandelbrot.colorswitch)
         {
            case 'b': // (b&w mode)
               if (skewed_fraction > 0.999999) // Can't do equality comparison to floating-point 1.
                  mandelbrot.setcolor(i, j, 1);
               else
                  mandelbrot.setcolor(i, j, 0);
               break;
            case 'c': // (color-table mode)
            case 'd':
               //cerr
               //   << "Row = "   << setw(5) << j << "  Pixel = " << setw(5) << i
               //   << "  Fraction = " << Fraction << endl;
               colorselect=int(floor((skewed_fraction+0.000001)*double(mandelbrot.colors_used-1)));
               mandelbrot.setcolor(i, j, colorselect);
               break;
            case 'g': // (grey-scale mode)
               colorselect=int(floor(skewed_fraction * 255.999999)); // Give 0, 1, 254, 255 equal credence.
               mandelbrot.setcolor(i, j, colorselect);
               break;
            case 'r': // (continuous-rainbow mode)
               mandelbrot.setcolor(i, j, ContinuousRainbow(skewed_fraction));
               break;
            case 'y': // (cyclic-rainbow mode)
               mandelbrot.setcolor(i, j, CyclicRainbow(skewed_fraction, mandelbrot.cyclicity));
               break;
         } // end switch (colorswitch)
      } // end for i
   } // end for j
} // end ProcessPixels()


/************************************************************************************************************\
 * Fate()
 * This function iterates the equation z[n] = z[n-1]^2 + c for the given value of c (z[0]=0).  The return
 * value is the fraction of the given total number of iterations the calculation lasted before z>2.1 .
\************************************************************************************************************/
double
ns_Mandelbrot::
Fate
   (
      int     degree,     // degree of equation
      double  seed_r,     // real      part of c
      double  seed_i,     // imaginary part of c
      int     iterations  // target number of iterations
   )
{
   int  count;       // iteration counter
   long double   prev_r = 0;  // prev, real part
   long double   prev_i = 0;  // prev, imag part
   long double   curr_r = 0;  // curr, real part
   long double   curr_i = 0;  // curr, imag part
   long double   limit;       // limit beyond which points explode to infinity
   long double   limit2;      // limit^2
   double        fate;        // fraction of iterations lasted

   // Limit is given by L^n - L < L ; L^n < 2L ; L^(n-1) < 2 ; L < 2^(1/(n-1))
   // But I use L < 2^(1/(n-1)) + 0.000001 for safety:
   limit = pow(2.0, 1.0/(double(degree) - 1.0)) + 0.000001;
   limit2 = limit*limit;

   // Iterate equation y=z^n+c :
   for ( count = 0 ; count < iterations ; ++count )  // iterate
   {
      // Compute next value of z:
      Pow(prev_r, prev_i, degree, curr_r, curr_i);
      curr_r += seed_r;
      curr_i += seed_i;

      // If abs(curr)^2 >= limit^2, break, because this sequence will now explode to infinity,
      // hence current seed point ( seed_r + i * seed_i ) is not in The Mandelbrot Set:
      if ( curr_r * curr_r + curr_i * curr_i >= limit2 )
         break;

      // Feed current z back into previous z for next loop:
      prev_r = curr_r;
      prev_i = curr_i;
   }

   // fate = (count of iterations for which z remained in-limits) divided by (iteration limit):
   fate = double(count)/double(iterations);
   // cout << "fate = " << fate << endl;

   // Return fate:
   return fate;
} // end Fate()


/************************************************************************************************************\
 * Skew()
 * This function applies a controled amount of parabolic skew to its input.
 * The first  argument, s, is the "Skew Factor", which should be in the range [0.0, 1.0].
 * The second argument, f, is the number to be skewed; it, too, should be in the range [0.0, 1.0].
 * The returned value will be equal to a linearly-weighted average of f and 1-(1-f)^2, with s as weighting
 * factor.
 * (s == 0.0)       gives no skew at all.
 * (s == 1.0)       gives maximum parabolic skew.
 * (s>0.0 && s<1.0) gives a hybrid response.
 * I use this function to skew correspondance between logevity fraction and corresponding color, so as to
 * alter the slopes near the ends, in order to increase the contrast, so that fine details become clear.
 *
 * In the following graphs, the horizontal axis is the longevity fraction f, and the vertical axis is
 * y = skew(s,f):
 *
 * Linear response (s == 0.0;  y = f):
 *    |             *
 *    |           *
 *    |         *
 *    |       *
 *    |     *
 *    |   *
 *    | *
 *    ---------------
 *
 * Parabolic response (s == 1.0;  y = 1-(1-f)^2):
 *    |                *
 *    |           *
 *    |       *
 *    |    *
 *    |  *
 *    | *
 *    |*
 *    ------------------
 *
 * Hybrid response (s == 0.5;  y = 0.5*f + 0.5*(1-(1-f)^2)):
 *    |               *
 *    |          *
 *    |       *
 *    |     *
 *    |   *
 *    | *
 *    |*
 *    ------------------
\************************************************************************************************************/
inline
double
ns_Mandelbrot::
Skew
   (
      double s, // Skew Factor
      double f  // Longevity Fraction
   )
{
   // return (1.0-s)*f + s*(1.0-(1.0-f)*(1.0-f));
   return (1.0-s)*f + s*sqrt(f);
} // end skew()


/************************************************************************************************************\
 * ContinuousRainbow()
 * This function maps longevity fraction f onto a single-cycle rainbow of colors.
 * Input:
 *   f = Logevity fraction (the fraction of maximum iterations (iter in main()) the calculation for this
 *       pixel lasted without going out of bounds)
 * Output:
 *   Returns a rhbitmap::Color object giving the color assigned to this pixel.
\************************************************************************************************************/
rhbitmap::Color
ns_Mandelbrot::
ContinuousRainbow
   (
      double f // Longevity Fraction
   )
{
   // If f is within 1ppm of 1.0, the point is a member of The Mandelbrot Set, so return a black pixel:
   if (f > 0.999999) {return rhbitmap::Color (0,0,0);}

   // Otherwise, calculate "normalized" version of f, mapped to the range from arcsine(0.25)=0.252680 to
   // 0.999*5(PI/2)=7.846128, which gives a span of 7.846128-0.252680=7.593447:

   double n = asin(0.25) + (0.999 * 5.0 * Pi / 2.0 - asin(0.25)) * f;

   // Then, using PI/2 as a unit, calculate the "unit" and "fractional"
   // parts of n, and store in "zone" and "angle" respectively:

   int zone = int(floor(n/(Pi/2.0)));
   double angle = n - zone * Pi / 2.0;

   // Now, assign colors depending on zone and angle:

   double red, grn, blu;
   switch (zone)
   {  // Blue -> Red
      case 0:                 // Dark Blue
         red = 0.0;
         grn = 0.0;           // Med Blue
         blu = sin(angle);
         break;
      case 1:                 // Blue
         red = 0.0;
         grn = sin(angle);
         blu = cos(angle);    // Teal
         break;
      case 2:                 // Green
         red = sin(angle);
         grn = cos(angle);    // Goldenrod
         blu = 0.0;
         break;
      case 3:                 // Red
         red = 1.0;
         grn = sin(angle);    // Orange
         blu = 0.0;
         break;
      case 4:                 // Yellow
         red = 1.0;
         grn = 1.0;           // Yellow-White
         blu = sin(angle);
         break;               // White
      default:                // Black
         cerr << "Error: Invalid zone in rainbow().  Exiting program." << endl;
         exit(1);
   }
   int redint = int(floor(255.9999*red));
   int grnint = int(floor(255.9999*grn));
   int bluint = int(floor(255.9999*blu));
   return rhbitmap::Color(redint, grnint, bluint);
} // end ContinuousRainbow()


/************************************************************************************************************\
 * CyclicRainbow()
 * This function maps longevity fraction f onto a multi-cycle rainbow of colors.
 * Inputs:
 *   f         = Logevity fraction (the fraction of maximum iterations the calculation for this pixel lasted
 *               in the defining equation without going out of bounds)
 *   cyclicity = Cyclicity (the number of times the rainbow repeats from f = 0 to f = 1)
 * Output:
 *   Returns a rhbitmap::Color object giving the color assigned to this pixel.
\************************************************************************************************************/
rhbitmap::Color
ns_Mandelbrot::
CyclicRainbow
   (
      const double & f,
      const double & cyclicity
   )
{
   // Make sure arguments are in-bounds:
   if (f < 0.0 || f > 1.0)
   {
      cerr << "Error: invalid logevity-fraction argument to CyclicRainbow. Aborting program." << endl;
      abort();
   }
   if (cyclicity < 0.1 || cyclicity > 1000000.0)
   {
      cerr << "Error: invalid cyclicity argument to CyclicRainbow. Aborting program." << endl;
      abort();
   }

   // If f is within 1ppm of 1.0, the point is a member of The Mandelbrot Set, so return a black pixel:
   // (We can't do "if (f == 1)" for floating-point f, so we do "if (f > 0.999999)" instead.)
   if (f > 0.999999)
      return rhbitmap::Color (0,0,0);

   // Chop the [0, 1) range of f into cyclicity cycles, and find the position of f within its cycle:
   double position = rhmath::IntegFract(rhmath::LinearRescale(1.0, cyclicity)(f)).fract();

   // For each cycle, we want to cycle colors like this:
   // Red  Yellow  Green  Cyan  Blue  Magenta  Red
   //  ^                                        |
   //  |________________________________________|

   // So, we need to chop the [0, 1) range of position into 6 zones, find which zone position is in,
   // and position's fraction within it's zone:
   rhmath::IntegFract zone_angle (rhmath::LinearRescale(1.0, 5.999999)(position));
   int    zone  = zone_angle.integ();
   double angle = zone_angle.fract();

   // Assign colors depending on zone and angle:
   double red, grn, blu;
   switch (zone)
   {
      case 0:                    // red-to-yellow
         red = 1.0;
         grn = angle;
         blu = 0.0;
         break;
      case 1:                    // yellow-to-green
         red = 1.0-angle;
         grn = 1.0;
         blu = 0.0;
         break;
      case 2:                    // green-to-cyan
         red = 0.0;
         grn = 1.0;
         blu = angle;
         break;
      case 3:                    // cyan-to-blue
         red = 0.0;
         grn = 1.0-angle;
         blu = 1.0;
         break;
      case 4:                    // blue-to-magenta
         red = angle;
         grn = 0.0;
         blu = 1.0;
         break;
      case 5:                    // magenta-looping-back-to-red
         red = 1.0;
         grn = 0.0;
         blu = 1.0-angle;
         break;
      default:
         // We can't possibly get here.  But if we do, assign impossible values to red, grn, blu:
         red = 3845782.5483;
         grn = -876543.21;
         blu = 9284768.20820;
         break;
   }

   if (red<0.0 || red>1.0  || grn<0.0 || grn>1.0 || blu<0.0 || blu>1.0)
   {
      cerr << "Error: Invalid color value in CyclicRainbow. Aborting program." << endl;
      abort();
   }

   // Renormalize colors from interval [0.0, 1.0] (floating point numbers)
   // to interval [0, 255] (integers):
   int redint = int(floor(255.9999*red));
   int grnint = int(floor(255.9999*grn));
   int bluint = int(floor(255.9999*blu));
   return rhbitmap::Color(redint, grnint, bluint);
} // end CyclicRainbow()


// Return an integer power of a complex number:
void
ns_Mandelbrot::
Pow
   (
      long double const  &  xr, // input, real part
      long double const  &  xi, // input, imaginary part
      int         const  &  n,  // exponent
      long double        &  yr, // output, real part
      long double        &  yi  // output, imaginary part
   )
{
   // First of all, the formula for multiplying two complex numbers in a+bi form is:
   // (a+bi)(c+di) = (ac - bd) + (ad + bc)i
   // We'll calculate x^n by simply applying this n-1 times to an accumulator preloaded with z.
   long double ar = xr; // accumulator, real part, preloaded with zr
   long double ai = xi; // accumulator, imag part, preloaded with zi
   long double pr;      // product,     real part
   long double pi;      // product,     imag part
   for ( int i = 2 ; i <= n ; ++i )
   {
      pr = ar*xr - ai*xi;
      pi = ar*xi + ai*xr;
      ar = pr;
      ai = pi;
   }
   yr = ar;
   yi = ai;
   return;
} // end Pow()


void
ns_Mandelbrot::
Help
   (
      void
   )
{
   cout
   << "Welcome to \"Mandelbrot\", Robbie Hatley's nifty Mandelbrot Set grapher!"       << endl
   << "This version was compiled at " << __TIME__ << " on " << __DATE__ << "."         << endl
   << "Executable file name = " << exefile                                             << endl
   << "Input is via 14 command-line arguments:"                                        << endl
   << " #  Name        Type     Description                Range"                      << endl
   << " 1. degree      (int)    degree of graph            2-13"                       << endl
   << " 2. x_min       (double) Minimum x value for graph  [-3.0, 3.0]"                << endl
   << " 3. x_max       (double) Maximum x value for graph  [-3.0, 3.0]"                << endl
   << " 4. y_min       (double) Minimum y value for graph  [-3.0, 3.0]"                << endl
   << " 5. y_max       (double) Maximum y value for graph  [-3.0, 3.0]"                << endl
   << " 6. iterations  (int)    Number of iterations.      [1, 50000]"                 << endl
   << " 7. width       (int)    Width  of image in pixels. [1, 10001]"                 << endl
   << " 8. height      (int)    Height of image in pixels. [1, 10001]"                 << endl
   << " 9. colorswitch (char)   'b' for b&w mode,"                                     << endl
   << "                         'c' for color-table mode,"                             << endl
   << "                         'd' for default color table,"                          << endl
   << "                         'g' for grey-scale mode,"                              << endl
   << "                         'r' for continuous-rainbow mode,"                      << endl
   << "                         'y' for cyclic-rainbow mode."                          << endl
   << "10. inifilename (string) File name for ini file."                               << endl
   << "11. cyclicity   (double) Number of cycles.          [0.1, 1000000.0]"           << endl
   << "12. skew_factor (double) Amount of parabolic skew.  [0.0, 1.0]"                 << endl
   << "                         0.0 gives linear response;"                            << endl
   << "                         1.0 gives parabolic response;"                         << endl
   << "                         numbers in-between give hybrid response."              << endl
   << "13. granularity (int)    size of shotgun set.       [3, 7]"                     << endl
   << "14. bmpfilename (string) Name for bmp file in which to store image."            << endl
   << ""                                                                               << endl
   << "Examples:"                                                                      << endl
   << "mandelbrot  3 -1.5 -1.4  0.7 0.8 750 725 725 c grey.ini 10   0.0 3 blat.bmp"    << endl
   << "mandelbrot 13 -1.5  1.5 -1.5 1.5 500 601 601 y  dummy    5.3 0.4 7 test.bmp"    << endl
   << ""                                                                               << endl
   << "Note that if colorswitch is \"c\", then inifilename most be the name of"        << endl
   << "an existing file in the directory \"/rhe/bin/fractals\"; but if"                << endl
   << "colorswitch is anything OTHER THAN \"c\", then inifilename is ignored,"         << endl
   << "in which case I recommend using \"dummy\" for inifilename. (Note that because"  << endl
   << "the arguments of this program are mandatory and positional, inifilname can NOT" << endl
   << "be omitted; the 10th argument must be SOMETHING, even if just gibberish.)"      << endl
   << ""                                                                               << endl
   << "Also note that \"bmpfilename\" must be a valid file name, but must NOT already" << endl
   << "exist in the current working directory, as this program will attempt to create" << endl
   << "a file of that name in the current working directory."                          << endl;
} // end Help()


/*

Development Notes:

Wednesday September 22, 2004:
I just started these notes today (long over-due!) even though I first started writing this program
way back around 1999 or 2000.  I should have been making notes all along.  Notes, and a LOT more
comments!  I'm really short on comments.  I see from looking at the code for the first time in about
8 or 9 months that I can't tell at a glance what many of the functions are trying to accomplish;
they should all have description comment blocks at their heads.  Also, this program needs more functions;
main() is way too big and much of its contents should be modularized.  (I think one of the reasons I didn't
do that before is that I didn't understand enough about const and non-const ref parameters.)  Well, that's
all about to change!  I'm starting in on comments this evening, and I'll make more functions in days to come.

Tue. Oct. 05, 2004:
I broke-out the actual calculation part of this program and put it in Fate().  I also added a neighborhood
shotgun-set approach to improve representation of filimentary connectedness, and I dramatically simplified
CyclicRainbow().

*/
