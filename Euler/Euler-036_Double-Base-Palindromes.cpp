
/********************************************************************\
 * Program name:  Project Euler Problem 36: Double Base Palindromes
 * File name:     Euler-036_Double-Base-Palindromes.cpp
 * Source for:    Euler-036_Double-Base-Palindromes.exe
 * Description:   Determines how many non-negative integers under 
 *                1,000,000 are palindromic in both base 10 and 
 *                base 2. 
 * Author:        Robbie Hatley
 * Edit History:
 *   Fri Jan 19, 2018: Wrote first draft.
 *   Sat Jan 20, 2018: Continued work on it.
 *   Fri Jan 26, 2018: Finished it. Works.
\********************************************************************/

#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <chrono>

using std::string;
using std::cout;
using std::endl;
using std::setprecision;

bool IsPalindrome(string const & s);
string Binary(int number);

int main (void)
{
   auto time0 = std::chrono::steady_clock::now();
   int i;
   std::vector<int> DecPal {};
   DecPal.reserve(2000);
   string Base2;
   int DBP_count = 0;
   int DBP_sum   = 0;

   // Make a list of all palindromic decimal numbers under 1000000.

   // 1-digit palindromes:
   for (i=1;i<=9;i+=1) {DecPal.push_back(i);}

   // 2-digit palindromes:
   for (i=11;i<=99;i+=11) {DecPal.push_back(i);}

   // 3-digit palindromes:
   for (i=1;i<=99;i+=1)
   {
      if (0 == i%10) {continue;}
      DecPal.push_back(i+100*(i%10));
   }

   // 4-digit palindromes:
   for (i=1;i<=99;++i)
   {
      if (0 == i%10) {continue;}
      DecPal.push_back(i+100*(int(i/10)%10)+1000*(i%10));
   }

   // 5-digit palindromes:
   for (i=1;i<=999;++i)
   {
      if (0 == i%10) {continue;}
      DecPal.push_back(i+1000*(int(i/10)%10)+10000*(i%10));
   }

   // The 6-digit palindromes:
   for (i=1;i<=999;++i)
   {
      if (0 == i%10) {continue;}
      DecPal.push_back
      (i+1000*(int(i/100)%10)+10000*(int(i/10)%10)+100000*(i%10));
   }

   cout << "Found " << DecPal.size() 
   << " base-10-palindromic numbers under 1,000,000." << endl;

   // Now, how many of these are palindromic in base 2?
   for ( i = 0 ; i < int(DecPal.size()) ; ++i )
   {
      Base2 = Binary(DecPal[i]);
      if (IsPalindrome(Base2))
      {
         cout << DecPal[i] << " = " << Base2 
         << " is palindromic in bases 10 and 2." << endl;
         ++DBP_count;
         DBP_sum += DecPal[i];
      }
   }

   cout << "Found " << DBP_count
   << " bases-10-and-2 palindromes under 1,000,000." << endl;
   cout << "Sum = " << DBP_sum << endl;
   auto time1 = std::chrono::steady_clock::now();
   auto RTR = time1 - time0;
   auto RTU = 
   std::chrono::duration_cast<std::chrono::microseconds>(RTR);
   double RTM = double(RTU.count()) / 1000.0;
   cout << "Elapsed time = " << RTM << "ms" << endl;
   return 0;
} // end main()

bool IsPalindrome(string const & s)
{
   bool  IsPal  = 1;
   int   size   = int(s.length());
   int   limit  = int(floor(double(size)/2.0));
   int   i;

   for ( i = 0 ; i < limit ; ++i )
   {
      if (s[i] != s[size - i - 1])
      {
         IsPal = 0;
         break;
      }
   }
   return IsPal;
}

string Binary(int number)
{
   int digits = 1 + int(floor(log(double(number+3))/log(2.0)));
   string repre = string("");
   int place = int(floor(pow(2.0, double(digits - 1))));
   int value = 0;
   const char numerals[3] = "01";
   bool first_non_zero = false;
   for ( ; place > 0; place /= 2)
   {
      value = number / place;
      if (!first_non_zero && value > 0) {first_non_zero = true;}
      if (first_non_zero)               {repre += numerals[value];}
      number -= value * place;
   }
   return repre;
}
