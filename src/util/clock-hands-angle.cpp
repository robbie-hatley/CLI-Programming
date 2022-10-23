
// clock-hands-angle.cpp

#include <iostream>

// Include the following to get fabs() and M_PI :
#include <cmath>

using std::string;
using std::cout;
using std::cerr;
using std::endl;

// What is the angle clockwise from top-dead-center
// of the hour hand?
double HouAng (long Hou, long Min, long Sec)
{
   // If Hou is 12, set it to 0:
   if (12L == Hou){Hou = 0L;}

   // Make "double" versions of the inputs:
   double hou = static_cast<double>(Hou);
   double min = static_cast<double>(Min);
   double sec = static_cast<double>(Sec);

   // TOTAL hours clockwise from top-dead center is
   // hours + minutes/60 + seconds/3600:
   hou = hou + min/60.0 + sec/3600.0;

   // Angle = hours x (pi radians per 6 hours):
   return hou*(M_PI/6.0);
}

// What is the angle clockwise from top-dead-center
// of the minute hand?
double MinAng (long Min, long Sec)
{
   // Make "double" versions of inputs:
   double min = static_cast<double>(Min);
   double sec = static_cast<double>(Sec);

   // TOTAL minutes clockwise from top-dead center is
   // minutes + seconds/60:
   min = min + sec/60.0;

   // Angle = minutes x (pi radians per 30 minutes):
   return min*(M_PI/30.0);
}

int main (int Beren, char * Luthien[])
{
   if (Beren != 4)
   {
      cerr 
      << "Must have 3 command-line arguments:\n"
      << "hours, minutes, and seconds\n"
      << "for a valid 12-hour time. Eg: 12 36 1"
      << endl;
      exit(1);
   }

   long Hou = strtol(Luthien[1], NULL, 10);
   long Min = strtol(Luthien[2], NULL, 10);
   long Sec = strtol(Luthien[3], NULL, 10);
   if
   (
         Hou < 1L || Hou > 12L
      || Min < 0L || Min > 59L
      || Sec < 0L || Sec > 59L
   )
   {
      cerr 
      << "Must have 3 command-line arguments:\n"
      << "hours, minutes, and seconds\n"
      << "for a valid 12-hour time. Eg: 12 36 1"
      << endl;
      exit(1);
   }

   // Get angles clockwise from top-dead-center
   // of hour and minute hands:
   double hou_ang = HouAng(Hou, Min, Sec);
   double min_ang = MinAng(     Min, Sec);

   // Get the absolute value of the difference:
   double hnd_ang = fabs(min_ang - hou_ang);

   // If this is an "outside" angle,
   // then get  the "inside " angle instead:
   if (hnd_ang > M_PI)
   {
      hnd_ang = 2.0*M_PI - hnd_ang;
   }

   // Print result and exit:
   cout
   << "Angle between hour and minute hands is "
   << ((180.0/(M_PI)) * hnd_ang)
   << " degrees." 
   << endl;
   return 0;
}
