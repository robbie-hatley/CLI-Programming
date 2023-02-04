/********************************************************************\
 * Program name:  Project Euler Problem 37: Truncatable Primes
 * File name:     Euler-037_Truncatable-Primes.cpp
 * Source for:    Euler-037_Truncatable-Primes.exe
 * Description:   Finds and sums all 11 double-truncatable primes.
 * Author:        Robbie Hatley
 * Edit History:
 *   Fri Jan 26, 2018: Wrote it.
\********************************************************************/

#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <chrono>

using namespace std;

bool IsPrime (long n);
bool IsLTP   (string s);

int main (void)
{
   auto time0 = chrono::steady_clock::now();

   char Digits [4] = {'1', '3', '7', '9'};
   vector< vector<string> > RTP {};
   RTP.reserve(19);
   // It's easy to find all 2-digit right-truncatable primes by visual 
   // inspection, seeing as how there are only 21 2-digit primes to 
   // begin with:
   RTP[2] = {"23", "29", "31", "37", "53", "59", "71", "73", "79"};
   cout << "RTPs:" << endl;
   cout << "23 29 31 37 53 59 71 73 79";
   string numstr;
   string trystr;
   unsigned short int i;
   unsigned short int n;
   unsigned short int j;
   unsigned short int RTPcount = 9;
   unsigned short int DTPcount = 0;
   long               DTPsum   = 0;
   for ( n = 2 ; n <= 17 ; ++n ) 
   {
      if (RTP[n].size() == 0)
      {
         break;
      }
      for ( i = 0 ; i < RTP[n].size() ;  ++i )
      {
         numstr = RTP[n][i];
         for ( j = 0 ; j < 4 ; ++j )
         {
            trystr = numstr + Digits[j];
            if (IsPrime(stol(trystr)))
            {
               RTP[n+1].push_back(trystr);
               ++RTPcount;
               cout << " " << trystr;
            }
         }
      }
   }
   cout << endl << endl << "No RTPs over " << n-1 << " digits." << endl;
   cout << "Found " << RTPcount << " RTPs." << endl << endl;

   cout << "DTPs: " << endl;
   for ( n = 2 ; n <= 17 ; ++n ) 
   {
      if (RTP[n].size() == 0)
      {
         break;
      }
      for ( i = 0 ; i < RTP[n].size() ;  ++i )
      {
         if (IsLTP(RTP[n][i]))
         {
            ++DTPcount;
            cout << RTP[n][i] << " ";
            DTPsum += stol(RTP[n][i]);
         }
      }
   }
   cout << endl << endl << "Found " << DTPcount << " DTPs." << endl;
   cout << "Sum = " << DTPsum << endl;

   auto time1 = chrono::steady_clock::now();
   auto RTR = time1 - time0;
   auto RTU = 
   chrono::duration_cast<chrono::microseconds>(RTR);
   double RTM = double(RTU.count()) / 1000.0;
   cout << "Elapsed time = " << RTM << "ms" << endl;
   return 0;
} // end main()

bool IsPrime (long n)
{
   static const long Wheel[48] =
   {
        1,  11,  13,  17,  19,  23,  29,  31,  37,  41,
       43,  47,  53,  59,  61,  67,  71,  73,  79,  83,
       89,  97, 101, 103, 107, 109, 113, 121, 127, 131,
      137, 139, 143, 149, 151, 157, 163, 167, 169, 173,
      179, 181, 187, 191, 193, 197, 199, 209
   };
   long    i           ; // Divisor index.
   long    spoke    = 0; // Wheel spoke.
   long    row      = 0; // Wheel row.
   long    limit    = 0; // Upper limit for divisors to try.
   long    divisor  = 0; // Divisor.
   if (n<2) return false;
   if (2==n||3==n||5==n||7==n) return true;
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return false;
   limit = long(floor(1.0001*sqrt(double(n))));
   for ( i = 1 ; ; ++i )
   {
      row     = i/48;
      spoke   = i%48;
      divisor = 210*row + Wheel[spoke];
      if (divisor > limit) return true;
      if (!(n%divisor)) return false;
   }
} // end IsPrime()

bool IsLTP (string s)
{
   while (s.length() > 0)
   {
      if (!IsPrime(stol(s)))
      {
         return false;
      }
      s.erase(0, 1);
   }
   return true;
}
