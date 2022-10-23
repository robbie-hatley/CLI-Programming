
// Bearings.cpp

#include <iostream>
#include <cmath>

#define PI (float(M_PI))

using namespace std;

inline float dtr(float deg) {return PI*deg/180.0F;}

void CalculateBearings
   (
      float lat1d, // pass by value (INPUT)
      float lon1d, // pass by value (INPUT)
      float lat2d, // pass by value (INPUT)
      float lon2d, // pass by value (INPUT)
      float & Arc, // NON-CONST REF (OUTPUT)
      float & IB,  // NON-CONST REF (OUTPUT)
      float & FB   // NON-CONST REF (OUTPUT)
   )
{
   float b     = dtr(90.0F - lat1d);
   float c     = dtr(90.0F - lat2d);
   float lon1r = dtr(lon1d);
   float lon2r = dtr(lon2d);
   float A     = lon2r - lon1r;
   Arc = acos(cos(b)*cos(c) + sin(b)*sin(c)*cos(A));         // SEND TO OUTPUT
   IB  = acos((cos(c)-cos(b)*cos(Arc)) / (sin(b)*sin(Arc))); // SEND TO OUTPUT
   FB  = acos((cos(b)-cos(c)*cos(Arc)) / (sin(c)*sin(Arc))); // SEND TO OUTPUT
   return; // Do NOT return a value!
}

int main (void)
{
   float lat1d, lon1d, lat2d, lon2d; // Inputs   to  CalculateBearings()
   float Arc, IB, FB;                // Outputs from CalculateBearings()

   cout << "ENTER LATITUDE  OF START POINT: ";
   cin  >> lat1d;

   cout << "ENTER LONGITUDE OF START POINT: ";
   cin  >> lon1d;

   cout << "ENTER LATITUDE  OF DESTINATION: ";
   cin  >> lat2d;

   cout << "ENTER LONGITUDE OF DESTINATION: ";
   cin  >> lon2d;

   // Get bearings (outputs go into Arc, IB, and FB):
   CalculateBearings(lon1d, lat1d, lon2d, lat2d, Arc, IB, FB);
   
   // Print results:

   cout << "Distance  between coordinates: " 
        << Arc * 6371.0F << " kilometers " 
        << "(" << Arc * 3959.0F << " miles)." << endl;

   cout << "Arclength between coordinates: " 
        << Arc * (180.0F/M_PI) << " degrees." << endl;

   cout << "Initial Bearing: " << 360.0F - IB*(180.0F/PI) << " degrees." << endl;
   cout << "Final   Bearing: " << 180.0F + FB*(180.0F/PI) << " degrees." << endl;

   cout << "Bearing of initial from final: " 
        << FB*(180.0F/PI) << " degrees." << endl;

   // We're done, so return:
   return 0;
}
