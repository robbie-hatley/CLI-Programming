/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * File Name:     makechng.cpp
 * Writen by:     Robbie Hatley.
 * Date written:  Wed. Jul. 18, 2001.
 * Edit history:  Sat. Oct. 23, 2004.
 * Input:         A number of cents from 0 to 99.
 * Output:        The correct change in quarters, dimes, nickels, and  pennies.
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <iostream>

#include "rhutil.hpp"

namespace ns_Change
{
  using std::cin;
  using std::cout;
  using std::cerr;
  using std::endl;
  using std::string;

  using namespace rhutil;

  void MakeChange(int Amount);
  void Instructions(void);
}

int main(int Jack, char *Sam[])
{
   using namespace ns_Change;

   if (2 != Jack)
   {
      Instructions();
   }

   if (string(Sam[1]) == "-h" or string(Sam[1]) == "--help")
   {
      Instructions();
   }

   int Amount = atoi(Sam[1]);

   if (Amount < 0 or Amount > 100)
   {
      Instructions();
   }

   MakeChange(Amount);
   return 0;
}

void ns_Change::MakeChange(int Amount)
{
   // Plan of action:
   // 1. Use maximum number of quarters which give <= amount
   // 2. Use maximum number of dimes which give <= remainder-after-quarters
   // 3. Use maximum number of nickels which give <= remainder-after-dimes
   // 4. Remainder-after-nickels will be necessary number of pennies

   // Declare automatic local integer variables for quarters, dimes, nickels, and remainders,
   // and initialize them all to zero:
   int q=0, qr=0, d=0, dr=0, n=0, nr=0, p=0;

   // Make Change:
   q=Amount/25;      // Get quarters
   qr=Amount%25;     // Get remainder after quarters
   d=qr/10;          // Get dimes
   dr=qr%10;         // Get remainder after dimes
   n=dr/5;           // Get nickels
   nr=dr%5;          // Get remainder after nickels
   p=nr;             // Get pennies

   // Print results:
   cout
      << "Quarters = " << q << endl
      << "Dimes    = " << d << endl
      << "Nickels  = " << n << endl
      << "Pennies  = " << p << endl;
   return;
}

void ns_Change::Instructions(void)
{
   cout 
   << "Number of arguments must be exactly 1, which must be a number of cents"   << endl
   << "between 0 and 100 inclusive.  The output will then be the correct change" << endl
   << "in quarters, dimes, nickels, and pennies."                                << endl;
   return;
}

