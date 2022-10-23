/****************************************************************************\
 * julia.cpp
 * Julia Set graphing program.
 * Written Thu. Jan. 24, 2002, by Robbie Hatley
 * Last updated Fri. Dec. 6, 2002
 *
 * Abstract:
 *   A "Julia Set" is a graph in the complex plane of all complex numbers
 *   z(0) for which an iterated rational equation z(n) = R(z(n-1)) + c
 *   (c constant) yields z values which remain finite as n tends to infinity.
 *
 *   A "Quadratic Julia Set" is a Julia set where the equation is the
 *   iterated quadratic equation z(n+1)=z(n)^2+c.
 *
 *   The Mandelbrot Set acts as a map of all Quadratic Julia Sets.
 *   "c" values which are IN the Mandelbrot Set always yield connected
 *   Julia Sets.  "c" values which are NOT in the Mandelbrot Set yield
 *   disconnected Julia Sets (also known as Fatou Dusts).
 *
 * Inputs:
 *   Eight command-line arguments:
 *     width     (width  of image in pixels)
 *     height    (height of image in pixels)
 *     filename  (file name for image)
 *     p         (real seed)
 *     q         (imag seed)
 *     iter      (maximum number of iterations to loop equation)
 * Outputs:
 *   Makes bitmap, maps complex-number space to bitmap, asigns one of
 *   a set of colors to each point depending on whether that point
 *   is in The Madelbrot Set, on the boundary of The Mandelbrot Set,
 *   or far outside of The Mandelbrot Set.
 *
 * Exit Codes:
 *   400 - Program executed and terminated normally.
 *   401 - Wrong number of arguments.
 *   402 - Wrong type or value of arguments.
 *   403 - Output file already exists.
 *   500 - Debug.
 *
\****************************************************************************/

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstring>
#include <cmath>

#include "rhbitmap.hpp"

using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using rhbitmap::Color;

void SetDefaultColors ( Color (&ColorArray)[256] , int & NumColors );

int main(int argc, char *argv[])
{
  // Declare and initialize counters for use throughout the program:
  short int count=0;
  short int i=0;
  short int j=0;
  short int k=0;

  // check for 7 arguments:
  if (argc != 8) {
    cout << "ERROR 401: wrong number of arguments."                       << endl;
    cout << "Arguments for this program are:"                             << endl;
    cout << "p            (real seed)"                                    << endl;
    cout << "q            (imag seed)"                                    << endl;
    cout << "iter         (maximum iterations to loop equation)"          << endl;
    cout << "width        (width  of image in pixels)"                    << endl;
    cout << "height       (height of image in pixels)"                    << endl;
    cout << "colorswitch  (d or c for color, g for greyscale, b for b&w)" << endl;
    cout << "filename     (name of *.bmp file for image)"                 << endl;
    exit(401);
  }

  // store command-line arguments in the variables declared above:
  double      p           {atof(argv[1])};         // real seed
  double      q           {atof(argv[2])};         // imag seed
  long        iter        {atol(argv[3])};         // number of iterations
  short       width       {short(atol(argv[4]))};  // image width
  short       height      {short(atol(argv[5]))};  // image height
  char        colorswitch {argv[6][0]};            // color or b&w
  std::string filename    {argv[7]};               // file name for *.bmp file

  try {
    char tag[128];

    if (width<10 || width>6000) {
      strcpy(tag, "width");
      throw tag;
    }

    if (height<10 || height>6000) {
      strcpy(tag, "height");
      throw tag;
    }

    if (p<-2 || p>2) {
      strcpy(tag, "p");
      throw tag;
    }

    if (q<-2 || q>2) {
      strcpy(tag, "q");
      throw tag;
    }
    if (iter<10 || iter>10000) {
      strcpy(tag, "iterations");
      throw tag;
    }
    if
    (
       colorswitch != 'b' 
       &&
       colorswitch != 'c'
       &&
       colorswitch != 'd'
       &&
       colorswitch != 'g'
    ) 
    {
      strcpy(tag, "color switch");
      throw tag;
    }
  }
  catch(char* arg) {
    cerr<<"\n\nERROR: Illegal "<<arg<<"."<<endl;
    cerr<<"Legal argument values:"<<endl;
    cerr<<"Width and height must be between 10 and 6000."<<endl;
    cerr<<"Output file must not already exist."<<endl;
    cerr<<"p and q must be between -2 and 2."<<endl;
    cerr<<"Iterations must be between 10 and 10,000."<<endl;
    cerr<<"Color switch must be g (for greyscale) or c (for color) or b (for b&w).\n\n"<<endl;
    exit(402);
  }

  try {
    std::ifstream file_01_in (filename.c_str());
    bool flag = file_01_in.is_open();
    if (flag) file_01_in.close();
    if (flag) throw filename.c_str();
  }
  catch(char* name) {
    cout<<"File "<<name<<" already exists."<<endl;
    exit(403);
  }

  // Declare variables for bitcount, colors, luminance, and compression:
  int bitcnt;           // bits per pixel
  int colors;           // number of colors in bmp-file color table
  int COLORS;           // number of colors used
  bool compress;        // will file be compressed?

  // Declare and initialize color table to 256 colors, all black:
  static Color color[256]={Color (0,0,0)};

  // Define colors to use for colored Julia graphs, and store these colors 
  // in the array color[], in order of increasing "iterations lasted", 
  // and also set bitcnt and compress:

  switch (colorswitch) {
    case 'c':
    // Attempt to open julia.ini, and if attempt succeeds,
    // read colors into color table:
    try {
      std::ifstream init("/rhe/bin/fractals/julia.ini");
      if (!init) {
        init.close();
        throw 1;
      }
      init.setf(std::ios::hex, std::ios::basefield);
      init.setf(std::ios::showbase);
      int redTemp=0, grnTemp=0, bluTemp=0;
      char comment[122]={'\0', '\0', '\0'};
      for (i=0; !init.eof() && i<256; ++i) {
        if (EOF==init.peek()) {
          break;
        }
        init >> redTemp >> grnTemp >> bluTemp;
        if (init.fail() || init.bad() || init.eof()) {
          init.close();
          throw 2;
        }
        color[i] = Color (redTemp, grnTemp, bluTemp);
        cout << i << "  " << color[i];
        init.getline(comment, 67);
        cout << comment << endl;
      }
      init.close();
      COLORS=i;
    } // end try block
    // If try fails to read ini file, use default color table:
    catch(int a) {
      char ans;
      if (1==a) {cerr << "Can't open ini file.  ";}
      if (2==a) {cerr << "Error while reading ini file.  ";}
      cerr << "Use default color table [y|n] ?" << endl;
      cin >> ans;
      if ('y'==ans || 'Y'==ans)
      {
         SetDefaultColors(color, COLORS);
      }
      else
      {
        exit(1);
      }
    } // end of catch block
    if (COLORS<=256) {
      bitcnt=8;
      colors=256;
      compress=true;
    }
    else {
      bitcnt=24;
      colors=16777216;
      compress=false;
    }
    break;

    case 'd': // Default color table
    SetDefaultColors(color, COLORS);
    colors   = 256;
    bitcnt   =   8;
    compress =true;
    break;

    case 'g':
    bitcnt=8;
    colors=256;
    compress=true;
    for (i=0; i<256; ++i) {
      color[i] = Color (255-i, 255-i, 255-i);
    }
    COLORS=256;
    break;

    case 'b':
    bitcnt=1;
    colors=2;
    compress=false;
    color[0] = Color (0xF0, 0xEB, 0xE8);
    color[1] = Color (0x00, 0x00, 0x00);
    COLORS=2;
    break;

    default:
    cerr << "Error: we somehow made it into the color switch with ";
    cerr << "a bad value for " << endl << "colorswitch.  (colorswitch ";
    cerr << "must be d, c, g, or b.)" << endl;
    exit(1);
  } // end switch (colorswitch)

  cout << endl;
  cout << "Finished setting up color table." << endl;
  cout << "total colors = " << colors << endl;
  cout << "colors used  = " << COLORS << endl;

  // declare graph boundary variables:
  const static double x_min=-1.75;
  const static double x_max= 1.75;
  const static double y_min=-1.75;
  const static double y_max= 1.75;

  // create Graph object to graph Julia Set
  // ("Graph" is a class declared in bitmap.h)
  rhbitmap::Graph julia (x_min, x_max, y_min, y_max,
               width, height, bitcnt, compress);

  // Now load color[] into julia:
  for (k=0; k<colors; ++k) {
    julia.settable(k, color[k]);
  }

  // declare some variables for use in graphing Julia set:
  double x, y;           // the real and imaginary parts of z
  double xtemp, ytemp;   // temporary holding variables
  double fraction;       // fraction of target potential actually attained
  double skew;           // logarithmic skew of fraction
  short int colorSelect; // color selector

  // Now we process all pixels, iterating the defining equation on the
  // complex value c corresponding to each pixel, and coloring the pixel
  // with regard to how "close" or "far" they are to The Julia Set we're computing:
  cout << endl;
  cout << "Now iterating defining equation for each pixel..." << endl;
  for (j=0; j<height; ++j) {               // for each row...
    for (i=0; i<width; ++i) {              // for each pixel...
      // Get the complex value c corresponding to pixel (i,j) of the graph:
      x=julia.getx(i);                     // get x(0)
      y=julia.gety(j);                     // get y(0)
      for (count=1; count<iter; ++count) { // Iterate equation z=z*z+c
        xtemp=x*x-y*y+p;                   // get next x
        ytemp=2*x*y+q;                     // get next y
        x=xtemp;                           // feed x back into x for next loop
        y=ytemp;                           // feed y back into y for next loop
        if ((x*x+y*y)>4.000004000001) break; // break out of loop if abs(z)>2.000001
      }
      // Paint pixel onto graph:
      fraction=(double(count)/double(iter));
      skew=log(fraction+1.0)/log(2.0);
      colorSelect=short(floor(skew * double(COLORS-1)));
      if (24==bitcnt)
        julia.setcolor(i, j, color[colorSelect]);
      else
        julia.setcolor(i, j, colorSelect);
    }
  }
  julia.filewrite(filename.c_str());       // write bitmap to disk file
  // Display image:
  std::string Command {};
  Command = std::string("chmod u=rwx,g=rwx,o=rx '") + filename + "'";
  std::system(Command.c_str());
  Command = std::string("cmd /C '") + filename + "'";
  std::system(Command.c_str());
  return 0;
} // end main()


void SetDefaultColors ( Color (&ColorArray)[256] , int & NumColors )
{
   ColorArray[0]  = Color (0x50, 0x18, 0x10); // soil
   ColorArray[1]  = Color (0x80, 0x00, 0x00); // rust
   ColorArray[2]  = Color (0xC0, 0x00, 0x00); // burgundy
   ColorArray[3]  = Color (0xFF, 0x00, 0x00); // red
   ColorArray[4]  = Color (0xFF, 0x40, 0x00); // orange-red
   ColorArray[5]  = Color (0xFF, 0x80, 0x00); // orange
   ColorArray[6]  = Color (0xF0, 0xC0, 0x00); // yellow-orange
   ColorArray[7]  = Color (0xFF, 0xFF, 0x00); // yellow
   ColorArray[8]  = Color (0xC0, 0xF0, 0x40); // yellow-green
   ColorArray[9]  = Color (0x80, 0xFF, 0x80); // medium-bright green
   ColorArray[10] = Color (0x80, 0xFF, 0xC0); // mint-chutney
   ColorArray[11] = Color (0x80, 0xFF, 0xFF); // bright aqua
   ColorArray[12] = Color (0xF0, 0xD0, 0xFF); // bright lilac-blue
   ColorArray[13] = Color (0xFF, 0xE0, 0xFF); // bright lilac
   ColorArray[14] = Color (0xFF, 0xFF, 0xFF); // white
   ColorArray[15] = Color (0x00, 0x00, 0x00); // black
   NumColors=16;
   return;
}





