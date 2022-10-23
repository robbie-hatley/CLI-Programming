// This is a 110-character-wide ASCII-encoded C++ source-code text file.  
//=======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/************************************************************************************************************\
 * Program name:  zero-one
 * File name:     zero-one.cpp
 * Source for:    zero-one.exe
 * Description:   Converts text into "01010100 10111010 10011010" binary representations
 *                of the iso-8859-1 character codes of the standard input to standard output.
 * Author:        Robbie Hatley
 * Date written:  Unknown
 * Inputs:        stdin  (use < or |)
 * Outputs:       stdout (use > or |)
 * To make:       Link with modules "rhmath.o", "rhutil.o", and "rhdir.o" in library "librh.a".
 * Edit History:
 *   Wed Feb 21, 2018: Converted ASCII->UTF8 and WinEOL->UnixEOL, and re-did comments above. 
 *   Thu Apr 18, 2019: Converted back to ANSI, improved Help, and added spaces.
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <string>

//#define BLAT_ENABLE
#include <rhdefines.h>
#include <rhmathc.h>
#include <rhutil.hpp>

namespace ns_Binary
{
   using std::cin;
   using std::cout;
   using std::endl;

   void ProcessFile(void);
   std::string ProcessLine(std::string const & text);
   void Print(std::string & buffer);
   void Help(void);
}

int main (int Beren, char * Luthien[])
{
   std::ios_base::sync_with_stdio(true);
   using namespace ns_Binary;
   if (rhutil::HelpDecider(Beren, Luthien, Help)) return 777;
   ProcessFile();
   BLAT("At bottom of main(), about to return.\n")
   return 0;
}

void ns_Binary::ProcessFile (void)
{
   std::string in_buffer;
   std::string out_buffer;

   while (1)
   {
      std::getline(cin, in_buffer);
      if (cin.eof()) break;
      out_buffer += ProcessLine(in_buffer);
   }
   Print(out_buffer);
   return;
}

std::string ns_Binary::ProcessLine (std::string const & text)
{
   char Buffer[9];
   std::string output = std::string("");
   std::string::const_iterator ti; // "ti" = "text iterator"

   BLAT("In ProcessLine, above for loop.")
   BLAT("text = " << text << "    length = " << text.length())
   for (ti = text.begin(); ti != text.end(); ++ti)
   {
      BLAT("At top of for loop; (*ti) = " << (*ti) )
      RepresentInBase(uint64_t(uint8_t(*ti)), 2, 8, true, Buffer);
      BLAT("In for loop; just ran RepresentInBase; Buffer = " << Buffer)
      output = output + std::string(Buffer) + " ";
   }
   return output;
}

void ns_Binary::Print (std::string & buffer)
{
   while (buffer.size() >= 45)
   {
      cout << buffer.substr(0, 45) << endl;
      buffer.erase(0,45);
   }
   cout << buffer << endl;
   return;
}

void ns_Binary::Help (void)
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to \"zero-one\" by Robbie Hatley.  This program converts normal text into"      << endl
   << "the binary representations of the iso-8859-1 character codes for all of the"            << endl
   << "characters in the original text, written as rows of 5 8-digit binary numbers"           << endl
   << "separated by single spaces (so that each row has 45 characters including 5"             << endl
   << "spaces)."                                                                               << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
   << "binary [-h|--help] < InputFile > OutputFile"                                            << endl
                                                                                               << endl
   << "Switch:                          Meaning:"                                              << endl
   << "\"-h\" or \"--help\"             Print help and exit."                                  << endl;
   return;
}

// end file zero-one.cpp
