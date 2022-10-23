// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/************************************************************************************************************\
 * Program name:  zero-one-two
 * File name:     zero-one-two.cpp
 * Source for:    zero-one-two.exe
 * Description:   Converts text into a trinary representation of its iso-8859-1 character codes.
 * Author:        Robbie Hatley
 * Date written:  2018-04-18
 * Inputs:        stdin  (use < or |)
 * Outputs:       stdout (use > or |)
 * Edit history:
 *   Wed Apr 18, 2018: Wrote it.
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <string>

//#define BLAT_ENABLE
#include <rhdefines.h>
#include <rhmathc.h>
#include <rhutil.hpp>

namespace ns_Trinary
{
   using std::cin;
   using std::cout;
   using std::endl;

   void ProcessFile(void);
   std::string ProcessLine(std::string const & text);
   void Chunk(std::string & buffer);
   void Help(void);
}

int main (int Beren, char * Luthien[])
{
   std::ios_base::sync_with_stdio(true);
   using namespace ns_Trinary;
   if (rhutil::HelpDecider(Beren, Luthien, Help)) return 777;
   ProcessFile();
   BLAT("At bottom of main(), about to return.\n")
   return 0;
}

void ns_Trinary::ProcessFile (void)
{
   std::string in_buffer;
   std::string out_buffer;

   while (1)
   {
      std::getline(cin, in_buffer);
      if (cin.eof()) break;
      out_buffer += ProcessLine(in_buffer);
      //if (out_buffer.size() >= 300) {Chunk(out_buffer);}
   }
   //Chunk(out_buffer);
   cout << out_buffer << endl;
   return;
}

std::string ns_Trinary::ProcessLine (std::string const & text)
{
   char Buffer[7];
   std::string output = std::string("");
   std::string::const_iterator ti; // "ti" = "text iterator"

   BLAT("In ProcessLine, above for loop.")
   BLAT("text = " << text << "    length = " << text.length())
   for (ti = text.begin(); ti != text.end(); ++ti)
   {
      BLAT("At top of for loop; (*ti) = " << (*ti) )
      RepresentInBase(uint64_t(uint8_t(*ti)), 3, 6, true, Buffer);
      BLAT("In for loop; just ran RepresentInBase; Buffer = " << Buffer)
      output += std::string(Buffer);
      output += std::string(" ");
   }
   return output;
}

void ns_Trinary::Chunk (std::string & buffer)
{
   while (buffer.size() >= 80)
   {
      cout << buffer.substr(0, 80) << endl;
      buffer.erase(0,80);
   }
   return;
}

void ns_Trinary::Help (void)
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to \"zero-one-two\" by Robbie Hatley.  This program converts iso-8859-1"   << endl
   << "text into trinary representations of the iso-8859-1 character codes for all of"    << endl
   << "the characters in the original text, formated as 80-character-wide rows of"        << endl
   << "zeros, ones, and twos."                                                            << endl
                                                                                          << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                << endl
                                                                                          << endl
   << "Command-line syntax:"                                                              << endl
   << "zero-one-two [-h|--help] < InputFile > OutputFile"                                 << endl
                                                                                          << endl
   << "Switch:                          Meaning:"                                         << endl
   << "\"-h\" or \"--help\"             Print help and exit."                             << endl
   << "\"-r\" or \"--recurse\"          Process all subdirectories."                      << endl;
   return;
}

// end file binary.cpp
