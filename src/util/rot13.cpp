// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/****************************************************************************\
 * File name:     rot13.cpp
 * Title:         Rotate 13
 * Author:        Robbie Hatley
 * Date written:  Saturday February  8, 2003
 * Description:   Alphabetically rotates text file 13 letters.
 * Notes:         A rather "naive" program: little error checking.  I was in a
 *                hurry to get this up and running.
 * Input:         Command-line argument = name of file to be rotated
 * Output:        File with same name but "rot" extention
 * Edit history:
 *    Sat Feb 08, 2003 - Wrote it.
 *    Sun Jan 18, 2004 - Edited it.
 *    Wed Sep 14, 2005 - Simplified it.
 *    Mon Mar 17, 2008 - Updated to make correct use of HelpDecider(),
 *                       GetArgs(), and GetFlags().
\****************************************************************************/

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>

#include <cctype>

#include "rhutil.hpp"
#include "rhdir.hpp"

namespace ns_ROT13
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   std::vector<std::string> Args;
   std::vector<std::string> Flags;

   void RotateFile         (std::string const & OldFileName);
   void RotateStdIn        (void                           );
   void RotateAndPrintLine (std::string       & Line       );
   void RotateChar         (char              & C          );
   void Help               (void                           );
}


int main(int Mike, char * Dianne[])
{
   using namespace ns_ROT13;
   if (rhutil::HelpDecider(Mike, Dianne, Help))
   {
      return 777;
   }

   rhutil::GetArguments(Mike, Dianne, Args);
   size_t NumArgs = Args.size();

   rhutil::GetFlags(Mike, Dianne, Flags);
   size_t NumFlags = Flags.size();

   if (0 == NumFlags && 0 == NumArgs)
   {
      RotateStdIn();
      return 0;
   }

   else if (0 == NumFlags && 1 == NumArgs)
   {
      std::string Buffer (Args[0]);
      RotateAndPrintLine(Buffer);
      return 0;
   }

   else if (1 == NumFlags && 1 == NumArgs && "-f" == Flags[0])
   {
      std::string FileName = Args[0];
      try
      {
         RotateFile(FileName);
      }
      catch(rhdir::FileIOException Fred)
      {
         cerr << Fred.msg << endl;
         return 666;
      }
      return 0;
   }

   else
   {
      return 666;
   }
}



void
ns_ROT13::
RotateFile
   (
      std::string const & FileName
   )
{
   if (!rhdir::FileExists(FileName))
   {
      std::string Buffer = "Error: No file exists called " + FileName;
      throw rhdir::FileIOException(Buffer);
   }
   std::ifstream InStream;
   InStream.open(FileName.c_str());
   std::string Buffer;
   while (InStream)
   {
      getline(InStream, Buffer);
      if (StreamIsBad(InStream)) break;
      if (InStream.eof()) break;
      RotateAndPrintLine(Buffer);
   }
   InStream.close();
   return;
}



void
ns_ROT13::
RotateStdIn
   (
      void
   )
{
   std::string Agamemnon;
   while (42)
   {
      getline(cin, Agamemnon);
      if (StreamIsBad(cin)) break;
      if ( cin.eof() ) break;
      RotateAndPrintLine(Agamemnon);
   }
   return;
}



void
ns_ROT13::
RotateAndPrintLine
   (
      std::string & Line
   )
{
   for_each(Line.begin(), Line.end(), RotateChar);
   cout << Line << endl;
   return;
}



void
ns_ROT13::
RotateChar
   (
      char & C
   )
{
   static const std::string lower = "abcdefghijklmnopqrstuvwxyz";
   static const std::string UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   if      (islower(C)) {C=lower[(lower.find(C)+13)%26];}
   else if (isupper(C)) {C=UPPER[(UPPER.find(C)+13)%26];}
}



void
ns_ROT13::
Help
   (
      void
   )
{
   cout
      << "Welcome to rot13, Robbie Hatley\'s rotate-13 utility.\n\n"

      << "This program outputs a version of its input in which all letters\n"
      << "are translated 13 letters up (or down) alphabetically.\n\n"

      << "This version was compiled at " << __TIME__ << " on " << __DATE__ << "\n\n"

      << "rot13 takes zero, one, or two command-line arguments.\n"
      << "With zero arguments, it ouputs a rotation of stdin.\n"
      << "With one argument, it outputs the rotation of its argument.\n"
      << "(Unless, of course, the argument is \"-h\" or \"--help\".)\n"
      << "With two arguments, the first argument must be \"-f\", and the\n"
      << "second argument must be the a valid name of an existing text file;\n"
      << "rot13 will then output the rotated version of that file to stdout.\n\n"

      << "Note: rot13 never alters its input file." << endl;

   return;
}
