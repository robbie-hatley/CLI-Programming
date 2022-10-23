// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/*****************************************************************************\
 * encode.cpp
 * Encodes plaintext to cyphertext (or decodes cyphertext to plaintext) using
 * my rot48 cypher system. It appears that I abandoned doing this in C++ and
 * took up this project in Perl back in 2015 (it's 2018 as I write this) for
 * reasons I no longer remember. C++ seems like a more reasonable language for
 * cryptography, though, so I have to wonder why I switched languages.
\*****************************************************************************/

#include <iostream>
#include <vector>
#include <string>

#include <cstring>

// Use assert? (Undefine "NDEBUG" to use asserts; define it to NOT use them.)
//#undef  NDEBUG
#include <assert.h>
#include <errno.h>

// Use BLAT? (Define "BLAT_ENABLE" to use BLAT; undefine it to NOT use BLAT.)
//#define BLAT_ENABLE

#include "rhmath.hpp"
#include "rhutil.hpp"
#include "rhdir.hpp"

namespace ns_Encode
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   typedef  std::string               SS;
   typedef  SS::size_type             SSS;
   typedef  SS::iterator              SSI;
   typedef  SS::const_iterator        SSCI;
   typedef  std::vector<std::string>  VS;
   typedef  VS::size_type             VSS;
   typedef  VS::iterator              VSI;
   typedef  VS::const_iterator        VSCI;

   struct Bools_t
   {
      bool bHelp;
   };

   void ProcessFlags (VS const & Flags, Bools_t & Bools );
   bool CheckArgs    (VS const & Arguments);
   bool CheckPad     (VS const & Arguments);
   void ReadInput    (VS & Text);
   bool CheckInput   (VS const & Pad, VS const & Input);
   void Encode       (VS const & Pad, VS const & Input);
   void Help         (void);

} // end declaration of namespace ns_Encode


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  main()                                                                  //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

int main (int Beren, char **Luthien)
{
   using namespace ns_Encode;

   srand(unsigned(time(0)));

   VS Flags;
   rhutil::GetFlags (Beren, Luthien, Flags);

   Bools_t Bools = Bools_t();
   ProcessFlags(Flags, Bools);

   if (Bools.bHelp)
   {
      Help();
      return 777;
   }

   VS Arguments;
   rhutil::GetArguments(Beren, Luthien, Arguments);
   bool ArgsOk = CheckArgs(Arguments);
   if (!ArgsOk) return 666;

   VS Pad;
   rhdir::LoadFileToContainer(Arguments[0], Pad);
   bool PadOk = CheckPad(Pad);
   if (!PadOk) return 666;

   VS Input;
   Input.reserve(10000);
   ReadInput(Input);
   bool InputSizeOk = CheckInput(Pad, Input);
   if (!InputSizeOk) return 666;

   Encode(Pad, Input);

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
ns_Encode::
ProcessFlags
   (
      VS       const  &  Flags,
      Bools_t         &  Bools
   )
{
   BLAT("\nJust entered ProcessFlags().  About to set Bools.\n")

   // Use InVec from rhutil:
   using rhutil::InVec;

   Bools.bHelp    = InVec(Flags, "-h") or InVec(Flags, "--help"   );

   BLAT("About to return from ProcessFlags.\n")
   return;
} // end ns_Encode::ProcessFlags()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  CheckArgs()                                                             //
//                                                                          //
//  Checks arguments.                                                       //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

bool
ns_Encode::
CheckArgs
   (
      VS const & Arguments
   )
{
   BLAT("\nJust entered CheckArg().\n")

   if (1 != Arguments.size())
   {
      cerr
         << "Error: encode must have exactly 1 argument, which must be" << endl
         << "a valid path to a [137][96] one-time-pad file.  You typed" << endl
         << Arguments.size() << " arguments." << endl;
      return false;
   }

   BLAT("\nIn CheckArg().  Verified exactly 1 argument.")
   BLAT("Arguments[0] = " << Arguments[0] << "\n")

   if (!rhdir::FileExists(Arguments[0]))
   {
      cerr
         << "Error: one-time-pad file " << Arguments[0] << " does not exist." << endl;
      return false;
   }

   BLAT("\nIn CheckArgs.  Verified pad file exists.  About to return true.\n")
   return true;
} // end ns_Encode::CheckArgs()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  CheckPad()                                                              //
//                                                                          //
//  Checks one-time-pad integrity.                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

bool
ns_Encode::
CheckPad
   (
      VS const & Pad
   )
{
   BLAT("\nJust entered CheckPad().\n")

   if (Pad.size()<100 || Pad.size()>10000)
   {
      cerr
         << "Error: the one-time-pad must have at least 100 lines and at most 10000 lines." << endl
         << "The file you gave contains " << Pad.size() << " lines." << endl;
      return false;
   }

   // Store our character set in SS "CharSet":
   SS CharSet =
      "abcdefghijklmnopqrstuvwxyz"          // lower-case (26)
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"          // upper-case (26)
      "0123456789"                          // digits     (10)
      "`~!@#$%^&*()-_=+[{]}\\|;:\'\",<.>/?" // symbols    (32)
      "\11\40";                             // tab, space ( 2)
                                            // total:     (96)

   // Now check each line of the pad for problems:
   for ( VS::size_type i = 0 ; i < Pad.size() ; ++i )
   {
      // Store current line in a SS var called Line:
      SS Line = Pad[i];

      // Is current line exactly 96 characters long?
      if (96 != Line.size())
      {
         cerr
            << "Error: each line of the one-time-pad must be exactly 96 characters long." << endl
            << "line # " << i << " of the pad you gave contains "
            << Pad[i].size() << " characters." << endl;
         return false;
      }

      // Does current line have any characters not in our standard set?
      if ( SS::npos != Line.find_first_not_of(CharSet) )
      {
         cerr
            << "Error: pad line #" << i << " contains invalid character(s)." << endl;
         return false;
      }

      // Are there any missing characters?
      if ( SS::npos != CharSet.find_first_not_of(Line))
      {
         cerr
            << "Error: pad line #" << i << " does not contain entire character set." << endl;
         return false;
      }

      // Are there any duplicate characters?  No, if we get here, there can't be,
      // because we've ascertained that we have exactly 96 characters,
      // and that we have no characters which are *not* in our character set,
      // and that we have all of the characters which *are* in our character set.
      // Hence logically, there can be no duplicates.  (In fact, after ascertaining
      // that Line has exactly 96 characters, passing either the invalid-character *OR*
      // the missing-character tests will imply no duplicates.)
      // Therefore, the current pad line is a permutation of our character set.

      // Now, if we want to be thorough, we could run other tests at this point,
      // such as scrutinizing for lines which are non-random, or lines which are
      // duplicates of other lines; but it's not really necessary to idiot-proof
      // operations.  The key goal of this function isn't to guard against
      // maliciously-malformed pad files, but rather to guard against inadvertantly
      // using a file which was never intended for use as a one-time pad, or using
      // a damaged one-time-pad file.

   } // end for (each line of the one-time pad)

   BLAT("\nIn Checkpad().")
   BLAT("Passed all pad-integrity tests.")
   BLAT("About to return true.\n.")
   return true;
} // end ns_Encode::CheckPad()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ReadInput()                                                             //
//                                                                          //
//  Reads up to ten thousand lines of text from stdin.                      //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_Encode::
ReadInput
   (
      std::vector<std::string> & Text
   )
{
   std::string LineOfText;                   // Make a string to hold text.
   for ( int i = 0 ; ; ++i )                 // Loop up to 10001 times.
   {                                         // Top of loop.
      getline(cin, LineOfText);              // Get a line of text.
      if (cin.eof()) break;                  // Break if stream is end-of-file.
      if (cin.fail()) break;                 // Break if stream is failed.
      if (cin.bad()) break;                  // Break if stream is bad.
      if (10000 == i)
      {
         cout << "WARNING: Text was over 10,000 lines; remainder truncated." << endl;
         break;
      }
      Text.push_back(LineOfText);            // Record data in list.
   }                                         // Do it again.
   return;                                   // We be done.
} // end ns_Encode::ReadInput()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  CheckInput()                                                            //
//                                                                          //
//  Checks size of input relative to pad.                                   //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

bool
ns_Encode::
CheckInput
   (
      VS const & Pad,
      VS const & Input
   )
{
   unsigned long int  PadSize     = Pad.size();
   unsigned long int  InputSize   = 0;
   for ( VSCI i = Input.begin() ; i < Input.end() ; ++i )
   {
      InputSize += i->size();
   }
   if (InputSize > 3*PadSize)
   {
      cerr 
         << "Error: Number of characters in input is more than three times number of" << endl
         << "lines in pad. Encoding aborted because cyphertext may be breakable."     << endl
         << "Use a larger pad or a smaller plaintext to insure unbreakability."       << endl;
      return false;
   }
   else
   {
      return true;
   }
} // end ns_Encode::CheckInput()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Encode()                                                                //
//                                                                          //
//  Encodes plaintext to cyphertext.                                        //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_Encode::
Encode
   (
      VS const & Pad,
      VS const & Input
   )
{
   long int     InputLines  = Input.size();
   long int     Line        = 0;
   long int     i           = 0;               // Index of character within PLAINTEXT LINE
   long int     j           = 0;               // Index of character within pad line
   char         Character   = 'a';
   long int     CharIdx     = 0;               // Index of character within ENTIRE PLAINTEXT
   std::string  LineOfText  = std::string();
   long int     LineLength  = 0;
   long int     PadLines    = 0;               // Number of lines in one-time-pad.

   PadLines = Pad.size();

   for ( Line = 0 ; Line < InputLines ; ++Line )
   {
      LineOfText = Input[Line];
      LineLength = LineOfText.size();
      // Note that i is initialized to 0 each time inner for loop is started, but CharIdx is NOT.
      // That way CharIdx is a running index of character position within entire plaintext file.
      for ( i = 0 ; i < LineLength ; ++i,++CharIdx )
      {
         Character = LineOfText[i];
         for ( j = 0 ; j < 96 ; ++j )
         {
            if (Character == Pad[(CharIdx%PadLines)][j])
            {
               break;
            }
         }

         // If the character is on the pad, rotate it 48:
         // (Note that this cypher is invertible, so if cyphertext is encoded again, this program will
         // output the original plaintext. Hence no need for a "decode" program; the "encode" program
         // already *IS* the "decode" program.)
         if (j < 96)
         {
            cout << Pad[(CharIdx%PadLines)][((j + 48) % 96)];
         }

         // Otherwise, just output the character as embedded plaintext:
         // (Hopefully not too many of these, else secrecy is compromised!)
         else
         {
            cout << Character;
         }
      }
      cout << endl;
   }

   return;
} // end ns_Encode::Encode()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Help()                                                                  //
//                                                                          //
//  Prints help.                                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_Encode::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to Encode, Robbie Hatley's one-time-pad cryptography utility."                  << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Encode encodes a plaintext to an unbreakable cyphertext, using a one-time pad."         << endl
   << "This code is unbreakable.  Not even the NSA with all their supercomputers can"          << endl
   << "decode cyphertext generated with this program.  If one does not have a copy of"         << endl
   << "the one-time pad used to encrypt the plaintext, the cyphertext can NOT be"              << endl
   << "decoded.  PERIOD."                                                                      << endl
                                                                                               << endl
   << "Another nifty feature of this program is, even though it's unbreakable,"                << endl
   << "it's also invertible.   Encoding a plaintext twice with the same pad"                   << endl
   << "returns it to its original form."                                                       << endl
                                                                                               << endl
   << "Method of encryption is heartbreakingly simple: 48-click rotation in an"                << endl
   << "order-96 circular Abelian group consisting of random permutations of"                   << endl
   << "the 94 glyphical ASCII characters plus tab and space.  Each one-time pad has"           << endl
   << "100o lines of 96 characters each of random gibberish, so as long as the"                << endl
   << "plaintext isn't more than 1000 characters long (about 140 words),"                      << endl
   << "no supercomputer can possibly decrypt the cyphertext without the pad."                  << endl
   << "Command-line syntax:"                                                                   << endl
                                                                                               << endl
   << "This system does have some drawbacks.  For one, the sender and receiver need"           << endl
   << "identical copies of the same one-time pad in their possession, (this is"                << endl
   << "definitely \"private-key\" cryptography, not \"public-key\"), so getting the"           << endl
   << "pad to the intended recipient securely and secretly (which are actually two"            << endl
   << "separate issues) is problematic.  It's best to slip the key to the intended"            << endl
   << "message recipient tete-a-tete, rather than transmit it electronically."                 << endl
                                                                                               << endl
   << "Another drawback is that a separate one-time pad is needed for each message."           << endl
   << "If you use a one-time pad more than one time, the cyphertext is then"                   << endl
   << "vulnerable to computer cryptoanalysis.  In short, \"one-time\" pads"                    << endl
   << "are to be used ONE TIME ONLY.  So for ongoing messages, a stack of one-time"            << endl
   << "pad files needs to be given to the intended message recipient, and the order"           << endl
   << "in which the pads are used must be agreed upon in advance."                             << endl
                                                                                               << endl
   << "Yet another drawback is, if anyone gets a copy of the pads, the cyphertext"             << endl
   << "can be decoded trivially.  Two parties may think they're conversing privately"          << endl
   << "via this code, but if someone has seen the pads, he could be listening-in and"          << endl
   << "secretly understanding every word.  So pad security is a vulnerability."                << endl
                                                                                               << endl
   << "But in spite of its drawbacks, this program remains a practical and truly"              << endl
   << "unbreakable tool for positively hiding the meanings of messages from"                   << endl
   << "unfriendly eyes."                                                                       << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
                                                                                               << endl
   << "To print this help and exit:"                                                           << endl
   << "encode -h|--help"                                                                       << endl
                                                                                               << endl
   << "To encode a plaintext to a cyphertext:"                                                 << endl
   << "encode PadFileName < InputFileName > OutputFileName"                                    << endl;
   return;
} // end ns_Encode::Help()

// end file encode.cpp

