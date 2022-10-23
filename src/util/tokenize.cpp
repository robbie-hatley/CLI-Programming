// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/******************************************************************************\
 * Tokenize
 * converts a string to tokens
\******************************************************************************/

#include <iostream>
#include <vector>
#include <string>

#include <cstring>

#include "rhutil.hpp"

namespace ns_Token
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   void Tokenize
      (
         std::string const & RawText,
         std::string const & Delimiters,
         std::vector<std::string> & Tokens
      );

   void Help (void);
}

int main (int Beren, char * Luthien[])
{
   using namespace ns_Token;
   std::ios_base::sync_with_stdio();
   if (rhutil::HelpDecider(Beren, Luthien, Help)) return 777;
   std::string Text ("\"First Token\",\"Second Token\",\"Third Token\"");
   std::string Delimiters (",\"");
   std::vector<std::string> Tokens;
   Tokenize(Text, Delimiters, Tokens);
   for_each(Tokens.begin(), Tokens.end(), rhutil::PrintString);
   return 0;
}

void ns_Token::Tokenize 
   (
      std::string              const & RawText,
      std::string              const & Delimiters,
      std::vector<std::string>       & Tokens
   )
{
   // Load raw text into an appropriately-sized dynamic char array:
   size_t  StrSize    = RawText.size();
   size_t  ArraySize  = StrSize + 5;
   char*   Ptr        = new char[ArraySize];
   memset(Ptr, 0, ArraySize);
   strncpy(Ptr, RawText.c_str(), StrSize);

   // Clear the Tokens vector:
   Tokens.clear();

   // Get the tokens from the array and put them in the vector:
   char* TokenPtr = NULL;
   char* TempPtr  = Ptr;
   while (NULL != (TokenPtr = strtok(TempPtr, Delimiters.c_str())))
   {
      Tokens.push_back(std::string(TokenPtr));
      TempPtr = NULL;
   }

   // Free memory and scram:
   delete[] Ptr;
   return;
}

void ns_Token::Help (void) 
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
   << "Welcome to tokenize, Robbie Hatley's string-to-tokens utility."                         << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
   << "MyFancyProgram [switches] [arguments] < InputFile > OutputFile"                         << endl
                                                                                               << endl
   << "Switch:                          Meaning:"                                              << endl
   << "\"-h\" or \"--help\"             Print help and exit."                                  << endl
   << "\"-r\" or \"--recurse\"          Process all subdirectories."                           << endl;
   return;
}

// end file tokenize.cpp
