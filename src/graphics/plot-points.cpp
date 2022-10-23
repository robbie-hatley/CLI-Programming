/****************************************************************************\
 * File name:   plot-points.cpp
 * Source for:  plot-points.exe
 * Title:       Plot-Points
 * Description: Creates a graph and plots points to it.
 * Inputs:      11 command-line arguments, plus one external data file.
 * Outputs:     Creates a bmp file displaying the graph.
 * To make:     Link with object "rhbitmap.o" in archive "librh.a".
 * Author:      Robbie Hatley
 * Created:     Wednesday December 04, 2002.
 * Edit history:
 *    2002-12-04: First starting writing this.
 *    2016-04-20: This equation-graphing progam works rather well, though
 *                it currently requires hard-coding the equations into the 
 *                program. I need to make this more flexible. Use Perl as a
 *                glue & interface language, perhaps?
 *    2016-04-29: Completely re-vamped. Now using Perl script "graph-equations"
 *                to do the calculating, and this program just does the 
 *                graphing.
 *    2018-01-07: Removed BLAT_ENABLE as we're not using BLAT here.
 \****************************************************************************/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <cmath>

#include <assert.h>
#include <errno.h>

#include "rhdefines.h"
#include "rhbitmap.hpp"

using std::cout;
using std::cerr;
using std::endl;
using std::setw;
using std::setfill;

int main (int Beren, char** Luthien)
{
   if (11 != Beren)
   {
      cerr 
      << "Error in plot-points.exe: Plot-Points must receive exactly 10 arguments," << endl
      << "which must be as follows:" << endl
      << "Arg  1 = xmin for graph      (floating-point number)" << endl
      << "Arg  2 = xmax for graph      (floating-point number)" << endl
      << "Arg  3 = ymin for graph      (floating-point number)" << endl
      << "Arg  4 = ymax for graph      (floating-point number)" << endl
      << "Arg  5 = width  of bitmap    (integer)"               << endl
      << "Arg  6 = height of bitmap    (integer)"               << endl
      << "Arg  7 = bitcount            (1, 4, 8, or 24)"        << endl
      << "Arg  8 = compression         (0 or 1)"                << endl
      << "Arg  9 = path of input  file (string)"                << endl
      << "Arg 10 = path of output file (string)"                << endl
      << "But you typed only " << Beren - 1 << " arguments:"    << endl;
      for ( int i = 1 ; i < Beren ; ++i )
      {
         cerr << "Arg " << i << " = " << Luthien[i] << endl;
      }
      exit(666);
   }

   double       xmin         = strtod(Luthien[1], NULL);
   double       xmax         = strtod(Luthien[2], NULL);
   double       ymin         = strtod(Luthien[3], NULL);
   double       ymax         = strtod(Luthien[4], NULL);
   int          width        = static_cast<int>  (strtol(Luthien[5], NULL, 10));
   int          height       = static_cast<int>  (strtol(Luthien[6], NULL, 10));
   int          bitcount     = static_cast<int>  (strtol(Luthien[7], NULL, 10));
   int          compress     = static_cast<bool> (strtol(Luthien[8], NULL, 10));
   std::string  DatFilePath  = Luthien[9];
   std::string  BmpFilePath  = Luthien[10];

   rhbitmap::Graph graph (xmin, xmax, ymin, ymax, width, height, bitcount, compress);
   graph.settable( 5, rhbitmap::Color (  0,   0,   0)); // black
   graph.settable( 6, rhbitmap::Color (113,  81,  57)); // brown
   graph.settable( 7, rhbitmap::Color (255,   0,   0)); // red
   graph.settable( 8, rhbitmap::Color (  0, 136,   0)); // green
   graph.settable( 9, rhbitmap::Color (  0,   0, 255)); // blue
   graph.settable(10, rhbitmap::Color (255, 119,   0)); // orange
   graph.settable(11, rhbitmap::Color (162,  72, 180)); // violet
   graph.settable(12, rhbitmap::Color (204, 150, 102)); // goldenrod
   graph.settable(13, rhbitmap::Color ( 93, 185, 177)); // teal
   graph.settable(14, rhbitmap::Color (126, 201,  20)); // lime
   
   double x        =     0.0;       // x coordinate of point to be plotted
   double y        =     0.0;       // y coordinate of point to be plotted
   int    c        =     0;         // color-index  of point to be plotted
   std::ifstream DatFileHand;
   DatFileHand.open(DatFilePath);
   assert(DatFileHand.is_open());
   while (!DatFileHand.eof())
   {
      DatFileHand >> x >> y >> c;
      graph.plotpoint(x, y, c);
   }
   DatFileHand.close();
   graph.filewrite(BmpFilePath);
   return 0;
}
