/****************************************************************************\
 * Program:     Primes
 * File name:   primes.cpp
 * Source for:  primes.exe
 * Description: Prints first n prime numbers.
 * Author:      Robbie Hatley
 * Edit History:
 *   Sun Jan 26, 2003
 *     Wrote original prime-number program.
 *   Sat Oct 23, 2004
 *     Did some editing.
 *   Sun Mar 15, 2009
 *     Dramatically simplified.  Changed name from "PrimesUpTo" to "Primes".
 *     Now takes 2 arguments: "number of primes" and "primes up to".  All of
 *     the actual prime generation is now done by the member functions of the
 *     class "rhmath::PrimeTable"
 *   Tue Mar 17, 2009:
 *     Split "Primes" into "Primes" and "Primes In Range".
\****************************************************************************/

// Use asserts:
#undef NDEBUG
#include <assert.h>

// Use BLAT?
//#define BLAT_ENABLE

#include <cstdlib>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <list>

#include "rhutil.hpp"
#include "rhmath.hpp"

namespace ns_Primes
{
   using std::cout;
   using std::cerr;
   using std::endl;
   void Help (void);
}

int main (int Beren, char *Luthien[])
{
   using namespace ns_Primes;

   if (rhutil::HelpDecider(Beren, Luthien, Help)) return 777;

   if (Beren != 2)
   {
      cerr
         << "Error: Primes takes exactly one argument, which must be a number"    << endl
         << "between 1 and 20,000,000 inclusive."                                 << endl
         << "For help, use a \"-h\" or \"--help\" switch instead of an argument." << endl;
      return 666;
   }

   int n = atoi(Luthien[1]);

   if (n < 1 || n > 20000000)
   {
      cerr
         << "Error: Primes takes exactly one argument, which must be a number"    << endl
         << "between 1 and 20,000,000 inclusive."                                 << endl
         << "For help, use a \"-h\" or \"--help\" switch instead of an argument." << endl;
      return 666;
   }

   BLAT("In primes.cpp function main();")
   BLAT("n = " << n)

   // Generate and print the first n prime numbers:
   rhmath::PrimeTable Table;
   Table.GeneratePrimes(n, true, false);

   // We're done, so scram:
   return 0;
}

void
ns_Primes::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to Primes, Robbie Hatley's \"First n Primes\" program."                         << endl
   << "Primes prints the first n prime numbers (where n is the command-line argument)."        << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
   << "primes [switches] [arguments] [> OutputFile]"                                           << endl
                                                                                               << endl
   << "Switch:              Meaning:"                                                          << endl
   << "\"-h\" or \"--help\"     Print help and exit."                                          << endl
                                                                                               << endl
   << "Primes takes either one switch (\"-h\" or \"--help\"), or one argument, n,"             << endl
   << "which must be a number between 1 and 20,000,000 inclusive."                             << endl
   << "Given switch \"-h\" or \"--help\", Primes prints this help and exits."                  << endl
   << "Given argument n, Primes will print the first n prime numbers."                         << endl;
   return;
}
