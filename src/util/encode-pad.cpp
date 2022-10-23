// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/***************************************************************\
 * encode-pad.cpp
\***************************************************************/

#include <iostream>
#include <vector>
#include <string>

#include <cstring>

// Use assert?  (Undefine "NDEBUG" to use asserts; define it to NOT use them.)
//#define NDEBUG
#include <assert.h>
#include <errno.h>

// Use BLAT?  (Define "BLAT_ENABLE" to use BLAT; undefine it to NOT use BLAT.)
//#define BLAT_ENABLE
#include <rhutilc.h>
#include <rhmath.hpp>
#include <rhutil.hpp>

namespace ns_EncodePad
{
   using std::cin;
   using std::cout;
   using std::endl;

   typedef  std::vector<std::string>  VS;
   typedef  VS::iterator              VSI;
   typedef  VS::const_iterator        VSCI;

   struct Settings_t  // Program settings (boolean or otherwise).
   {
      int  Lines;     // Number of lines (100 to 10000).
      bool bHelp;     // Did user ask for help?
      bool bRecurse;  // Walk directory tree downward from current node?
   };

   void
   ProcessFlags       // Set settings based on flags.
   (
      VS          const  &  Flags,
      Settings_t         &  Settings
   );

   void
   ProcessArguments   // Set settings based on arguments.
   (
      VS          const  &  Arguments,
      Settings_t         &  Settings
   );

   std::string Permute (std::string const & Text);
   void Help (void);
}


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  main()                                                                  //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

int main (int Beren, char **Luthien)
{
   using namespace ns_EncodePad;

   srand(unsigned(time(0)));

   // Make a "settings" object to hold program settings:
   Settings_t Settings = Settings_t();

   // Make a "flags" object to hold flags:
   VS Flags;

   // Get flags (items in Luthien starting with '-'):
   rhutil::GetFlags (Beren, Luthien, Flags);
   
   // Process flags (set settings based on flags):
   ProcessFlags(Flags, Settings);

   // If user wants help, just print help and return:
   if (Settings.bHelp)
   {
      Help();
      return 777;
   }

   // Make an "arguments" object to hold arguments:
   VS Arguments;

   // Get arguments (items in Luthien *not* starting with '-'):
   rhutil::GetArguments(Beren, Luthien, Arguments);

   // Process arguments (set settings based on arguments; this can be deleted if not using
   // arguments to set settings):
   ProcessArguments(Arguments, Settings);

   std::string CharSet =
      "abcdefghijklmnopqrstuvwxyz"          // lower-case (26)
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"          // upper-case (26)
      "0123456789"                          // digits     (10)
      "`~!@#$%^&*()-_=+[{]}\\|;:\'\",<.>/?" // symbols    (32)
      "\11\40";                             // tab, space ( 2)
                                            // total:     (96)

   // No need to store entire pad in memory, so commenting this out and doing it a different way:
   //std::vector<std::string> Pad;
   //Pad.reserve(Settings.Lines + 2);
   std::string Line ("");

   for ( int i = 0 ; i < Settings.Lines ; ++i )
   {
      // No need to store entire pad in memory, so commenting this out and doing it a different way:
      //Pad.push_back(Permute (CharSet));
      //cout << Pad[i] << endl;
      Line = Permute (CharSet);
      cout << Line << endl;
   }

   return 0;
} // end main()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessFlags()                                                          //
//                                                                          //
//  Sets program settings based on Flags.                                   //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
void
ns_EncodePad::
ProcessFlags
   (
      VS          const  &  Flags,
      Settings_t         &  Settings
   )
{
   BLAT("\nJust entered ProcessFlags().  About to set Settings.\n")

   // Use InVec from rhutil:
   using rhutil::InVec;

   Settings.bHelp = InVec(Flags, "-h") or InVec(Flags, "--help"   );

   BLAT("About to return from ProcessFlags.\n")
   return;
} // end ns_EncodePad::ProcessFlags()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessArguments()                                                      //
//                                                                          //
//  Sets program settings based on Arguments.                               //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_EncodePad::
ProcessArguments
   (
      VS          const  &  Arguments,
      Settings_t         &  Settings
   )
{
   BLAT("\nJust entered ProcessArguments().\n")

   // If arguments exist, use first argument as number of elements for pad:
   if ( Arguments.size() > 0 )
   {
      Settings.Lines = rhutil::atoint(Arguments[0].c_str());
   }
   // Otherwise, use 1000 lines.
   else
   {
      Settings.Lines = 1000;
   }

   BLAT("About to return from ProcessArguments.\n")
   return;
} // end ns_rhdedup::ProcessArguments()


std::string 
ns_EncodePad::
Permute
   (
      std::string const & Text
   )
{
   std::string TextCopy = Text;
   std::string Output = std::string ("");
   std::string::size_type j;

   while (TextCopy.size() > 0)
   {
      j = RandU64(0UL, TextCopy.size()-1UL);
      Output += TextCopy[j];
      TextCopy.erase(j, 1);
   }

   return Output;
}


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Help()                                                                  //
//                                                                          //
//  Prints help.                                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_EncodePad::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to EncodePad, Robbie Hatley's one-time-pad generating utility."                 << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "EncodePad prints a random one-time pad to stdout."                                      << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
                                                                                               << endl
   << "To print this help and exit:"                                                           << endl
   << "encodepad -h|--help"                                                                    << endl
                                                                                               << endl
   << "To print a random one-time pad to stdout:"                                              << endl
   << "encodepad"                                                                              << endl;
   return;
} // end ns_EncodePad::Help()

// end file encode-pad.cpp
