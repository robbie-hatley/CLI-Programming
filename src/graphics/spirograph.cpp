/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * Spirograph.cpp
 * Spirograph drawing program
 * Written Tue. Jan. 15, 2002 by Robbie Hatley
 * Edit history:
 *   Tue Jan 15, 2002: Wrote it.
 *   Sun Jan 27, 2002: Updated.
 *   Wed Dec 19, 2007: Updated.
 *   Thu Feb 22, 2018: Updated. 
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <iostream>
#include <cstdlib>
#include <cmath>
//#define NDEBUG
#include <assert.h>
#include <errno.h>
#define BLAT_ENABLE
#include "rhdefines.h"
#include "rhbitmap.hpp"

// Inline functions:
inline double get_x (double r, double t)       {return r*cos(t);     }
inline double get_y (double r, double t)       {return r*sin(t);     }
inline double multisine (int cycles, double t) {return sin(cycles*t);}

int main(int argc, char *argv[])
{
  unsigned     i            = 0;
  unsigned     points       = 0;
  unsigned     cycles       = 0;
  std::string  path         = "";
  double       t            = 0.0;
  double       r            = 0.0;

  if (argc != 4) return 666;
  path = std::string(argv[1]);
  cycles = unsigned(strtoul(argv[2], NULL, 10));
  points = unsigned(strtoul(argv[3], NULL, 10));

  rhbitmap::Graph
     spirograph
     (
        -1.15,      // x min
         1.15,      // x max
        -1.15,      // y min
         1.15,      // y max
        751,        // width
        751,        // height
        1,          // bitcount = 1 (2 colors)
        false       // compression = false
     );

  rhbitmap::Color Burgundy (240,  10,  10);
  rhbitmap::Color Cream    (240, 230, 220);

  spirograph.settable (0, Burgundy);  // Foreground color
  spirograph.settable (1, Cream   );  // Background color

  for ( i = 0 ; i < points ; ++i )
  {
    t=(2*PI)*(double(i)/double(points));
    r=multisine(cycles, t);
    spirograph.plotpoint(get_x(r,t), get_y(r,t), 0);
  }
  spirograph.filewrite(path);
  return 0;
}
