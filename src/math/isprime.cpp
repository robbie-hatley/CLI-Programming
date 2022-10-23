/*** This is a 107-character-wide ASCII-text C-source-code file. *****************************************\
 * Program name:  IsPrime
 * Description:   Tells whether the argument is a prime number.
 * File name:     isprime.cpp
 * Source for:    isprime.exe
 * Author:        Robbie Hatley
 * Date written:  Sun Mar 15, 2009
 * Inputs:        One command-line argument, which must be a positive integer.
 * Outputs:       "Yes." or "No."
 * To make:       Link with rhutil.o and rhmath.o in librh.a .
 * Edit History:
 *   Sun Mar 15, 2009 - Wrote it.
 *   Sun Mar 29, 2009 - Minor clean-up.
\*********************************************************************************************************/

// Include new C++ headers:
#include <iostream>
#include <iomanip>
#include <list>

// Use assert?
#undef NDEBUG
//#define NDEBUG
#include <assert.h>
#include <errno.h>

// Use BLAT?
#undef BLAT_ENABLE
//#define BLAT_ENABLE

// Include personal library headers:
#include "rhutil.hpp"
#include "rhmath.hpp"

namespace ns_Prime
{
   using std::cout;
   using std::cerr;
   using std::endl;

   using namespace rhutil;
   using namespace rhmath;

   void Help(void);

   unsigned long int DirCount;
}



int
main
   (
      int    Beren,
      char*  Luthien[]
   )
{
   using namespace ns_Prime;
   std::ios_base::sync_with_stdio();
   if (rhutil::HelpDecider(Beren, Luthien, Help)) return 0;
   int i = atoi(Luthien[1]);
   if (rhmath::PrimeTable::PrimeDecider(i))
   {
      cout << "Yes." << endl;
   }
   else
   {
      cout << "No." << endl;
   }
   return 0;
}


void
ns_Prime::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to isprime, Robbie Hatley's prime-decider utility."                      << endl
                                                                                        << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."              << endl
                                                                                        << endl
   << "isprime tells whether any integer from 1 to 2000000000 is prime or not."         << endl
                                                                                        << endl
   << "Command-line syntax:"                                                            << endl
                                                                                        << endl
   << "To print this help and exit:"                                                    << endl
   << "isprime -h|--help"                                                               << endl
                                                                                        << endl
   << "To check a number for primeness:"                                                << endl
   << "isprime number"                                                                  << endl
   << "(where \"number\" is an integer between 1 and 2 billion inclusive)"              << endl
                                                                                        << endl;
   return;
}

// end file MyFancyProgram.cpp
