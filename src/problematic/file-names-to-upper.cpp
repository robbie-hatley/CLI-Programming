/************************************************************************************************************\
 * Program name:  File-Name Upper-Case Enforcer
 * File name:     filenames-to-upper.cpp
 * Source for:    filenames-to-upper.exe
 * Author:        Robbie Hatley
 * Date written:  Thursday May 20, 2004
 * Description:   Converts all file names in current directory to all-upper-case.
 * To make:       Link with modules rhdir.o and rhutil.o in librh.a
 * Edit history:
 *    Thu. May. 20, 2004
 *    Sun. Jan. 16, 2005 - Changed "_rename" call to "RenameFiles" call.  Invoked function StringToLower().
\************************************************************************************************************/

#include <cstdlib>
#include <cstring>
#include <cctype>

#include <iostream>
#include <iomanip>
#include <fstream>
#include <list>
#include <string>

#include "rhutil.hpp"
#include "rhdir.hpp"

namespace FNTU
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   void FileNamesToUpper(void);
   void Help(void);

   unsigned long int Count = 0;
}

int main(int Vinca, char* Azalea[])
{
   using namespace FNTU;
   if (rhutil::HelpDecider(Vinca, Azalea, Help)) return 777;
   rhdir::RecursionDecider(Vinca, Azalea, FileNamesToUpper);
   cout << "Renamed " << Count << " files to all-lower-case." << endl;
   return 0;
}

void
FNTU::
FileNamesToUpper
(
   void
)
{
   std::list<rhdir::FileRecord> FileNames;
   std::list<rhdir::FileRecord>::iterator i;
   bool bSuccess = false;

   LoadFileList(FileNames);

   for (i = FileNames.begin(); i != FileNames.end(); ++i)
   {
      std::string OldName = i->name;
      std::string NewName = rhutil::StringToUpper(OldName);
      if (NewName != OldName)
      {
         ++Count;
         cout
            << endl
            << endl
            << "Rename #" << Count << endl
            << "Old file name:  " << OldName << endl
            << "New file name:  " << NewName << endl;
         bSuccess = rhdir::RenameFile(OldName, NewName);
         if (!bSuccess)
         {
            cerr
               << "Failed to rename file from\n   "
               << OldName
               << "\nto\n   "
               << NewName << endl
               << "Continuing with next file." << endl;
            --Count;
         }
      }
   }
   return;
}


void
FNTU::
Help
(
   void
)
{
   rhutil::PrintString
   (
      "Converts the names of all files in current directory to all-upper-case.\n"
      "Use this program with caution, in that some filenames, especially those of\n"
      "picture files from Webshots.com user galleries, are case-sensitive.\n"
      "Running this program on such files will remove the information which can\n"
      "allow finding the gallery the pic came from by plugging the unexpurgated\n"
      "file name into a URL in a browser.\n"
   );
   return;
}
