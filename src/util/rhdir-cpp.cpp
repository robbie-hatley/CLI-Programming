// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/************************************************************************************************************\
 * Program name:  RHDir
 * Description:   Ultra-simple directory program.
 * File name:     rhdir.cpp
 * Source for:    rhdir.exe
 * Author:        Robbie Hatley
 * Date written:  Sun Sep 25, 2005
 * Inputs:        None.
 * Outputs:       Prints current directory.
 * To make:       Link with rhdir.o in librh.a
 * Edit History:
 *    Sun Sep 25, 2005 - Wrote the damn thing.
 *
\************************************************************************************************************/

#include <ctime>

#include <iostream>
#include <iomanip>
#include <list>
#include <string>

// NOTE: The following 4 lines must appear *above* inclusion of personal headers:
#undef  NDEBUG
#include <assert.h>
#include <errno.h>
#undef  BLAT_ENABLE

#include "rhutil.hpp"
#include "rhdir.hpp"

namespace ns_RHDir
{
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::setfill;
   using std::setw;

   typedef  std::list<std::string>    LS;
   typedef  LS::iterator              LSI;
   typedef  LS::const_iterator        LSCI;
   typedef  std::vector<std::string>  VS;
   typedef  VS::iterator              VSI;
   typedef  VS::const_iterator        VSCI;
   typedef  rhdir::FileRecord         FR;
   typedef  std::list<FR>             LFR;
   typedef  LFR::iterator             LFRI;
   typedef  LFR::const_iterator       LFRCI;
   typedef  std::vector<FR>           VFR;
   typedef  VFR::iterator             VFRI;
   typedef  VFR::const_iterator       VFRCI;

   bool bAttrib;   // List only System, Hidden, and Read-Only files?
   bool bHelp;     // Did user ask for help?
   bool bRecurse;  // Walk directory tree downward from current node?

   void ProcessFlags(VS const & Flags);

   struct Stats_t     // program run-time statistics
   {
      uint32_t  DirCount;  // Count of directories processed.
      uint32_t  FilCount;  // Count of files examined.
      uint32_t  BypCount;  // Count of files bypassed.
      uint32_t  ProCount;  // Count of files successfully processed.
      void PrintStats (void)
      {
         cout
                                                                        << endl
            << "Finished processing files in this tree."                << endl
            << "Directories processed:        " << setw(7) << DirCount  << endl
            << "Files examined:               " << setw(7) << FilCount  << endl
            << "Files bypassed:               " << setw(7) << BypCount  << endl
            << "Files successfully processed: " << setw(7) << ProCount  << endl
                                                                        << endl;
      }
   };

   class ProcessCurDirFunctor
   {
      public:
         ProcessCurDirFunctor
            (
               VS       const  &  Arguments_,
               Stats_t         &  Stats_,
               VFR             &  FileList_
            )
            : Arguments(Arguments_), Stats(Stats_), FileList(FileList_)
            {}
         void operator()(void); // defined below
      private:
         VS       const  &  Arguments;
         Stats_t         &  Stats;
         VFR             &  FileList;
   };

   void Help(void);
} // end namespace ns_RHDir


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  main()                                                                  //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

int main (int Beren, char * Luthien[])
{
   using namespace ns_RHDir;
   srand(unsigned(time(0)));
   VS Flags;
   rhutil::GetFlags (Beren, Luthien, Flags);

   ProcessFlags(Flags);

   if (bHelp)
   {
      Help();
      return 777;
   }

   VS Arguments;
   rhutil::GetArguments(Beren, Luthien, Arguments);

   Stats_t Stats = Stats_t();
   static VFR FileList;
   FileList.reserve(10000);
   ProcessCurDirFunctor ProcessCurDir (Arguments, Stats, FileList);

   if (bRecurse)
   {
      rhdir::CursDirs(ProcessCurDir);
   }
   else
   {
      ProcessCurDir();
   }

   Stats.PrintStats();

   return 0;
} // end main()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessFlags()                                                          //
//                                                                          //
//  Sets program-state booleans based on Flags.                             //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void ns_RHDir::ProcessFlags(VS const & Flags)
{
   BLAT("\nJust entered ProcessFlags(). About to set booleans.\n")

   // Use InVec from rhutil:
   using rhutil::InVec;

   bHelp    = InVec(Flags, "-h") or InVec(Flags, "--help"   );
   bRecurse = InVec(Flags, "-r") or InVec(Flags, "--recurse");
   bAttrib  = InVec(Flags, "-a") or InVec(Flags, "--attrib" );

   BLAT("About to return from ProcessFlags.\n")
   return;
} // end ProcessFlags()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessCurDirFunctor::operator()                                        //
//                                                                          //
//  Processes current directory.                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void ns_RHDir::ProcessCurDirFunctor::operator() (void)
{
   // ABSTRACT:
   // The idea of this function is
   // to twaddle all turnips in
   // the current directory.

   BLAT("\nJust entered ProcessCurDir::operator().\n")

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
   std::string Wildcard ("*");
   if (Arguments.size() > 0)
   {
      for (VSCI i = Arguments.begin(); i != Arguments.end(); ++i)
      {
         Wildcard = *i;
         rhdir::LoadFileList
         (
            FileList,  // Name of container to load.
            Wildcard,  // File-name wildcard.
            3,         // Include both files and directories in vector.
            2          // Append to vector without clearing.
         );
      }
   }
   else
   {
      rhdir::LoadFileList
      (
         FileList,  // Name of container to load.
         Wildcard,  // File-name wildcard (will always be "*" here).
         3,         // Include both files and directories in vector.
         2          // Append to vector without clearing.
      );
   }

   BLAT("\nIn ProcessCurDirFunctor::operator().")
   BLAT("Finished building file list.")
   BLAT("File list size is " << FileList.size())
   BLAT("About to enter file-iteration for loop.\n")

   /* --------------------------------------------------------------- */
   /*  Iterate through the files, performing xxxxx for each file:     */
   /* --------------------------------------------------------------- */
   for ( VFRI  i = FileList.begin() ; i != FileList.end() ; ++i )
   {
      ++Stats.FilCount;
      if (bAttrib)
      {
         if ('R'==i->attr[0]||'H'==i->attr[1]||'S'==i->attr[2])
         {
            ++Stats.ProCount;
            rhdir::PrintFileRecord(*i);
         }
         else
         {
            ++Stats.BypCount;
         }
      }
      else
      {
         ++Stats.ProCount;
         rhdir::PrintFileRecord(*i);
      }
   } // end for (each file in FileList)
   return;
} // end ProcessCurDirFunctor::operator()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Help()                                                                  //
//                                                                          //
//  Prints help.                                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_RHDir::Help(void)
{
   cout
                                                                                           << endl
   << "Welcome to rhdir-cpp, Robbie Hatley's nifty directory lister."                      << endl
   << "This version was compiled at " __TIME__ " on " __DATE__ "."                         << endl
                                                                                           << endl
   << "This program prints a listing of all files in the current directory,"               << endl
   << "and all of its subdirectories if a --recurse or -r switch is used."                 << endl
   << "The fields, from left to right, are as follows:"                                    << endl
   << "Date     Time     File/Dir     Size     Atributes    Name"                          << endl
   << "The \"Name\" field is last because it's variable length, and is often the"          << endl
   << "longest of the six fields; that helps the columns to line up to the greatest"       << endl
   << "extent possible."                                                                   << endl
                                                                                           << endl
   << "Command-Line Syntax:"                                                               << endl
   << "   rhdir [switches and/or arguments]"                                               << endl
                                                                                           << endl
   << "Valid switches include:"                                                            << endl
   << "Switch:                      Meaning:"                                              << endl
   << "\"-a\" or \"--attrib\"           List only System, Hidden, and Read-Only Files."    << endl
   << "\"-h\" or \"--help\"             Print help and exit."                              << endl
   << "\"-r\" or \"--recurse\"          Process all subdirectories."                       << endl
                                                                                           << endl
   << "Any other arguments will be interpreted as wildcards, and only files matching"      << endl
   << "those wildcards will be listed.  Switches and arguments may be freely mixed."       << endl
                                                                                           << endl;
   return;
} // end Help()
