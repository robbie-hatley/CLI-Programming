/********************************************************************\
 * Program name:  Project Euler Problem 38: Pandigital Multiples
 * File name:     Euler-038_Pandigital-Multiples.cpp
 * Source for:    Euler-038_Pandigital-Multiples.exe
 * Description:   Finds largest 1-9 pandigital multiple.
 * Author:        Robbie Hatley
 * Edit History:
 *   Fri Jan 26, 2018: Started writing it.
 *   Sat Jan 27, 2018: Finished it.
\********************************************************************/

#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <chrono>

using namespace std;

bool IsPandigital(string const & s);

int main (void)
{
   auto time0 = chrono::steady_clock::now();

   unsigned short int x;
   unsigned short int m;
   unsigned long  int num;
   unsigned       int count = 0;
   unsigned long  int max = 0;
   string s;
   vector<unsigned long int> PM;
   for ( x = 1 ; x <= 9876 ; ++x )
   {
      s = "";
      for ( m = 1 ; s.length() < 9 ; ++m )
      {
         s += to_string(m*x);
      }
      if (s.length() != 9)
      {
         continue;
      }
      if (IsPandigital(s))
      {
         ++count;
         num = stoul(s);
         cout << "Pandigital: " << setw(4) << x << " x " 
         << "(1..." << m-1 << ") = " << num << endl;
         if (num > max) {max = num;}
      }
   }
   cout << endl;
   cout << "Found " << count << " pandigital multiples." << endl;
   cout << "Max = " << max   << endl;

   auto time1 = chrono::steady_clock::now();
   auto RTR = time1 - time0;
   auto RTU = 
   chrono::duration_cast<chrono::microseconds>(RTR);
   double RTM = double(RTU.count()) / 1000.0;
   cout << "Elapsed time = " << RTM << "ms" << endl;
   return 0;
} // end main()

bool IsPandigital(string const & s)
{
   if
      (
         s.length() == 9
         &&
         string::npos != s.find_first_of('1')
         &&
         string::npos != s.find_first_of('2')
         &&
         string::npos != s.find_first_of('3')
         &&
         string::npos != s.find_first_of('4')
         &&
         string::npos != s.find_first_of('5')
         &&
         string::npos != s.find_first_of('6')
         &&
         string::npos != s.find_first_of('7')
         &&
         string::npos != s.find_first_of('8')
         &&
         string::npos != s.find_first_of('9')
      )
   {
      return true;
   }
   else
   {
      return false;
   }
}
