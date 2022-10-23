// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/**********************************************************************************************************************\
 * Program name:  [name of program]        (Template)
 * File name:     [source-code file]       (template.cpp)
 * Source for:    [executable file]        (template.exe)
 * Description:   [brief description of what program does]
 *                (Template for most of my files-and-folders-utilities programs.  Navigates directory trees
 *                and takes to-be-specified actions on all or selected files-and-or-folders found in the 
 *                tree.  Alter a copy of this file to make just about any kind of utility you want.)
 * Author:        Robbie Hatley
 * Date written:  [the date I finished the first draft]
 * Inputs:        [Where does program get its info?  Command line?  Prompt?  Other?]
 * Outputs:       [Where does program sent its output?  Screen?  File?  Other?]
 * Notes:         [Info about the program: what it does, how it does it, etc.  But don't put developement
 *                notes here; put development notes at bottom instead.]
 * To make:       Link with modules [x, y, z] in library "librh.a" in folder "E:\RHE\lib".
 * Edit History:
 *   [today's date] - Wrote the first draft of the goddamn thing.
 *   [future  date] - Updated the kawhozitz and demickulated the garganzatso.
 *   [another date] - Fixed stupid bug in the gergitzeemu.
\**********************************************************************************************************************/

// Include old C headers:
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cctype>
#include <cmath>
#include <ctime>

// Include new C++ headers:
#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <list>
#include <deque>
#include <map>
#include <utility>
#include <string>
#include <algorithm>
#include <functional>
#include <typeinfo>
#include <new>

// Use assert?  (Undefine "NDEBUG" to use asserts; define it to NOT use them.)
//#define NDEBUG
#include <assert.h>
#include <errno.h>

// Use BLAT?  (Define "BLAT_ENABLE" to use BLAT; undefine it to NOT use BLAT.)
//#define BLAT_ENABLE

// Include personal C library headers:
#include "rhutilc.h"
#include "rhmathc.h"
#include "rhncgraphics.h"

// Include personal C++ library headers:
#include "rhutil.hpp"
#include "rhdir.hpp"
#include "rhmath.hpp"
#include "rhbitmap.hpp"

namespace ns_MyNameSpace
{
   using std::string;
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::setfill;
   using std::setw;

   typedef  std::list<std::string>     LS;
   typedef  LS::iterator               LSI;
   typedef  LS::const_iterator         LSCI;
   typedef  std::vector<std::string>   VS;
   typedef  VS::iterator               VSI;
   typedef  VS::const_iterator         VSCI;
   typedef  rhdir::FileRecord          FR;
   typedef  std::multimap<size_t, FR>  MMFR;
   typedef  MMFR::iterator             MMFRI;
   typedef  MMFR::const_iterator       MMFRCI;
   typedef  std::list<FR>              LFR;
   typedef  LFR::iterator              LFRI;
   typedef  LFR::const_iterator        LFRCI;
   typedef  std::vector<FR>            VFR;
   typedef  VFR::iterator              VFRI;
   typedef  VFR::const_iterator        VFRCI;

   struct Settings_t       // Program settings (boolean or otherwise).
   {
      bool   Help;         // Did user ask for help?
      bool   Recurse;      // Walk directory tree downward from current node?
   };

   void
   ProcessOptions            // Set settings based on options.
   (
      VS          const  &  Options,
      Settings_t         &  Settings
   );

   struct Stats_t          // program run-time statistics
   {
      uint32_t  DirCount;  // Count of directories processed.
      uint32_t  FilCount;  // Count of files examined.
      uint32_t  BypCount;  // Count of files bypassed.
      uint32_t  ErrCount;  // Count of errors encountered.
      uint32_t  ProCount;  // Count of files successfully processed.
      void PrintStats (void)
      {
         cout
                                                                        << endl
            << "Finished processing files in this tree."                << endl
            << "Directories processed:        " << setw(7) << DirCount  << endl
            << "Files examined:               " << setw(7) << FilCount  << endl
            << "Files bypassed:               " << setw(7) << BypCount  << endl
            << "Errors encountered:           " << setw(7) << ErrCount  << endl
            << "Files successfully processed: " << setw(7) << ProCount  << endl
                                                                        << endl;
      }
   };

   // Main current-directory-processing functor declaration follows.  If necessary, other data
   // (such as Options) can also be stored in instantiations of this functor; but for this template, 
   // I'm just storing Settings, Arguments, Stats, and a reference to the file list.
   // Also remember that all of the member variables can be set to either const or non-const 
   // as the needs of each application demand.

   class ProcessCurDirFunctor
   {
      public:
         ProcessCurDirFunctor
            (
               Settings_t  const  &  Settings_,
               VS          const  &  Arguments_,
               VFR                &  FileList_,
               Stats_t            &  Stats_
            )
            : Settings(Settings_), Arguments(Arguments_), FileList(FileList_), Stats(Stats_)
            {}
         void operator()(void); // defined below
      private:
         Settings_t  const  &  Settings;
         VS          const  &  Arguments;
         VFR                &  FileList;  // Non-const so function can clear/write file list.
         Stats_t            &  Stats;     // Non-const so function can increment stats counters.
   };

   // For programs that process individual files, this next function is "the function that does
   // all the real work of the program".  This may be just gleaning info from a file, or altering
   // the contents of a file, or perhaps renaming it.  This function is intended to be called
   // from a for loop in ProcessCurDirFunctor:

   void
   ProcessCurrentFile
   (
      FR          const  &  FileRecord,
      Stats_t            &  Stats
   );

   void Help (void);

} // end namespace ns_MyNameSpace


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  main()                                                                  //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

int main (int Beren, char * Luthien[])
{
   // Set main namespace we're using:
   using namespace ns_MyNameSpace;

   // Seed random-number generator (this can be deleted if not using random numbers):
   Randomize();

   // Make a "settings" object to hold program settings:
   Settings_t Settings = Settings_t();

   // Make a "options" object to hold options:
   VS Options;

   // Get options (items in Luthien starting with '-'):
   rhutil::GetFlags (Beren, Luthien, Options);
   
   // Process flags (set settings based on flags):
   ProcessOptions(Options, Settings);

   // If user wants help, just print help and return:
   if (Settings.Help)
   {
      Help();
      return 777;
   }

   // Make an "arguments" object to hold arguments:
   VS Arguments;

   // Get arguments (items in Luthien *not* starting with '-'):
   rhutil::GetArguments(Beren, Luthien, Arguments);

   // Make a stats object to hold program run-time statistics:
   Stats_t Stats = Stats_t();

   // Make a vector of file records (in "static" memory instead of the stack, else this can very easily
   // overflow the stack!!!):
   static VFR FileList;

   // Reserve room for info on 10,000 files (this Allocates memory for 10,000 items, but it doesn't
   // actually bloat the vector to that size yet; it just creates contiguous block of 10,000 cells
   // of "reserved-but-unused" space, so that we don't have to keep re-allocating as the vector grows):
   FileList.reserve(10000);

   // Create a function object of type "ProcessCurDirFunctor" for use with CursDirs:
   ProcessCurDirFunctor ProcessCurDir (Settings, Arguments, FileList, Stats);

   // If recursing, pass ProcessCurDir to CursDirs:
   if (Settings.Recurse)
   {
      rhdir::CursDirs(ProcessCurDir);
   }

   // Otherwise, just run ProcessCurDir():
   else
   {
      ProcessCurDir();
   }

   // Processing files is finished, so print final stats:
   Stats.PrintStats();

   // We be done, so scram:
   return 0;
} // end main()


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  ProcessOptions()                                                         //
//                                                                           //
//  Sets program settings based on Options.                                  //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

void
ns_MyNameSpace::
ProcessOptions
   (
      VS          const  &  Options,
      Settings_t         &  Settings
   )
{
   BLAT("\nJust entered ProcessOptions().  About to set settings.\n")

   // Use InVec from rhutil:
   using rhutil::InVec;

   Settings.Help    = InVec(Options, "-h") or InVec(Options, "--help"   );
   Settings.Recurse = InVec(Options, "-r") or InVec(Options, "--recurse");

   BLAT("About to return from ProcessOptions.\n")
   return;
} // end ns_MyNameSpace::ProcessOptions()


///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  ProcessCurDirFunctor::operator()                                         //
//                                                                           //
//  Processes current directory.                                             //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

void ns_MyNameSpace::ProcessCurDirFunctor::operator() (void)
{
   // Collects file records for user-specified files, then feeds each record
   // to ProcessCurrentFile() for processing.

   BLAT("\nJust entered ProcessCurDirFunctor::operator().\n")

   // Increment directory counter:
   ++Stats.DirCount;

   // Get current directory:
   std::string CurDir = rhdir::GetCwd();

   // Annouce processing current directory:
   cout
      << "\n"
      << "=================================================================\n"
      << "Directory #" << Stats.DirCount << ":\n"
      << CurDir << "\n"
      << endl;

   // Get vector of file records for all files in current directory which match
   // the wildcards given by the command-line arguments, if any.
   // If no arguments were given, get all files:
   FileList.clear();
   std::string Wildcard;
   if (Arguments.size() > 0)
   {
      for (VSCI i = Arguments.begin(); i != Arguments.end(); ++i)
      {
         Wildcard = *i;
         rhdir::LoadFileList
         (
            FileList,  // Name of container to load.
            Wildcard,  // File-name wildcard.
            1,         // Files only (not dirs).
            2          // Append to list without clearing.
         );
      }
   }
   else
   {
      rhdir::LoadFileList(FileList); // Get all files.
   }

   BLAT("\nIn ProcessCurDirFunctor::operator().")
   BLAT("Finished building file list.")
   BLAT("File list size is " << FileList.size())
   BLAT("About to enter file-iteration for loop.\n")

   /* ----------------------------------------------------------------------- */
   /*  Iterate through the files, calling ProcessCurrentFile() for each file: */
   /* ----------------------------------------------------------------------- */
   for ( VFRI  i = FileList.begin() ; i != FileList.end() ; ++i )
   {
      // Process current file:
      ProcessCurrentFile(*i, Stats);
   } // end for (each file in FileList)
   BLAT("\nAt end of ProcessCurDirFunctor::operator(), about to return.\n")
   return;
} // end ns_MyNameSpace::ProcessCurDirFunctor::operator()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessCurrentFile()                                                    //
//                                                                          //
//  Processes current file.                                                 //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_MyNameSpace::
ProcessCurrentFile
   (
      FR          const  &  FileRecord,
      Stats_t            &  Stats
   )
{
   // Process the file who's record is in FileRecord;
   // this may or may-not modify the file:
   ++Stats.FilCount;
   cout << FileRecord.path() << endl;
   ; // Do stuff.

   // Print various messages depending on what happened:

   // If error occurred, increment error counter and return:
   if (0)
   {
      ++Stats.ErrCount;
      cout << "Error encountered." << endl;
      return;
   }

   // If bypassing this file, increment bypass counter and return:
   else if (0)
   {
      ++Stats.BypCount;
      cout << "Bypassed file." << endl;
      return;
   }

   // If all turned out well, increment success counter:
   else
   {
      ++ Stats.ProCount;
   }

   // We're done, so return:
   return;
} // end ns_MyNameSpace::ProcessCurrentFile()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Help()                                                                  //
//                                                                          //
//  Prints help.                                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_MyNameSpace::
Help
   (
      void
   )
{
   //  12345678901234567890123456789012345678901234567890123456789012345678901234567890
   cout
                                                                                               << endl
   << "Welcome to MyFancyProgram, Robbie Hatley's turnip-twaddling utility."                   << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command-line syntax:"                                                                   << endl
   << "MyFancyProgram [options] [arguments] < InputFile > OutputFile"                          << endl
                                                                                               << endl
   << "Option:                      Meaning:"                                                  << endl
   << "\"-h\" or \"--help\"             Print help and exit."                                  << endl
   << "\"-r\" or \"--recurse\"          Process all subdirectories."                           << endl
                                                                                               << endl
   << "In addition to options, MyFancyProgram can also accept any number of arguments."        << endl
   << "Each argument will be."              << endl
   << "But since this isn't, it wasn't."                                                       << endl
                                                                                               << endl;
   return;
} // end ns_MyNameSpace::Help()


/*

Development Notes:

I first started writing this program on xxxxxxxx, when I realized the need for xxxxxxxxxx.
On xxxxxx, I ran into a problem with xxxxxxxx, and had to redo the way I did the xxxxxxx,
electing to xxxxx instead of xxxxxxx.  (etc)

*/


// end file template.cpp
