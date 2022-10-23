/****************************************************************************\
 * Program Name:  Factors
 * File name:     factors.cpp
 * Description:   Prints the prime factors of all integers in a closed
 *                interval of the set of natural numbers {1,2,3...}.
 * Inputs:        Two command-line arguments, x and y, which must be positive
 *                integers.
 * Outputs:       Prints factors of all integers in closed interval [x,y].
 * To make:       Link with modules "rhutil.o" and "rhmath.o" in "librh.a".
 * Author:        Robbie Hatley
 * Date written:  Tue Jan 28, 2003.
 * Edit history:
 *   Tue Jan 28, 2003 - Wrote it.
 *   Sat Oct 23, 2004 - Did some editing.
 *   Wed Mar 25, 2009 - Changed inputs to two command-line arguments, which
 *                      must be the start and end of the closed interval of
 *                      integers to be factored.  Also change output to
 *                      stdout.  Can be redirected via > or |.
\****************************************************************************/

#include <iostream>

#include "rhutil.hpp"
#include "rhmath.hpp"


namespace ns_Factors
{
   using std::cout;
   using std::cerr;
   using std::endl;

   typedef  std::vector<std::string>  VS;
   typedef  VS::iterator              VSI;
   typedef  VS::const_iterator        VSCI;

   struct Bools_t     // program boolean settings
   {
      bool bHelp;     // Did user ask for help?
   };

   void ProcessFlags (VS const & Flags, Bools_t & Bools);
   void Help (void);
}


int main (int Beren, char * Luthien[])
{
   using namespace ns_Factors;
   VS Flags;
   rhutil::GetFlags (Beren, Luthien, Flags);

   Bools_t Bools = Bools_t();
   ProcessFlags(Flags, Bools);

   if (Bools.bHelp)
   {
      Help();
      return 777;
   }

   if (3 != Beren)
   {
      cerr
         << "Error in Factors.exe: Factors takes two arguments, x and y, which must be"  << endl
         << "positive integers between 2 and 2000000000 inclusive, with y > x.  Factors" << endl
         << "will print the prime factors of all integers in the closed interval [x,y]." << endl
         << "For help, type \"factors --help\" or \"factors -h\"."                       << endl;
      return 666;
   }

   uintmax_t  x    = strtoull(Luthien[1], NULL, 10);
   uintmax_t  y    = strtoull(Luthien[2], NULL, 10);
   uintmax_t  max  = std::numeric_limits<uintmax_t>::max()-5;

   if (x < 2 or x > max or y < 2 or y > max or x >= y)
   {
      cerr
         << "Error in Factors.exe: Factors takes two arguments, x and y, which must be"   << endl
         << "positive integers between 2 and " << max << " inclusive, with y > x."        << endl
         << "Factors will print the prime factors of all integers in the closed "         << endl
         << "interval [x,y]. For help, type \"factors --help\" or \"factors -h\"."        << endl;
      return 666;
   }

   uintmax_t i, n, r;
   for (n=x; n<=y; ++n)
   {
      cout << n << " =";
      r=n;
      while (0==r%2)
      {
         r/=2;
         cout << " " << 2;
      }
      for (i=3; i<=r; i+=2)
      {
         while (0==r%i)
         {
            r/=i;
            cout << " " << i;
         }
      }
      cout << endl;

      if (1!=r)
      {
         cerr << "Error in Factors.exe: left-over remainder." << endl;
         return 666;
      }
   } // end for (n=x; n<=y; ++n)

   return 0;
} // end main()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessFlags()                                                          //
//                                                                          //
//  Sets program-state booleans based on Flags.                             //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_Factors::
ProcessFlags
   (
      VS       const  &  Flags,
      Bools_t         &  Bools
   )
{
   using rhutil::InVec;
   Bools.bHelp = InVec(Flags, "-h") or InVec(Flags, "--help");
   return;
}


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Help()                                                                  //
//                                                                          //
//  Prints help.                                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_Factors::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to Factors, Robbie Hatley's prime-factors utility."                             << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
   << "factors x y [> OutputFile]"                                                             << endl
   << "factors -h"                                                                             << endl
   << "factors --help"                                                                         << endl
                                                                                               << endl
   << "Switch:              Meaning:"                                                          << endl
   << "\"-h\" or \"--help\"     Print help and exit."                                          << endl
                                                                                               << endl
   << "Factors takes two arguments, x and y, which must be positive integers between"          << endl
   << "2 and 2000000000 inclusive.  Factors will then print the prime factors of all"          << endl
   << "integers in the closed interval [x,y].  Output is to stdout, but may be"                << endl
   << "redirected to a file by using > or redir(), or to a program by using |."                << endl;

   return;
}
