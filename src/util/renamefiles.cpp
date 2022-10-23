// This is a 79-character-wide utf-8-encoded C++ source-code text file.  
// ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。  
//=======|=========|=========|=========|=========|=========|=========|=========

/************************************************************************************************************\
 * Program name:  RenameFiles
 * File name:     renamefiles.cpp
 * Source for:    renamefiles.exe
 * Description:   File and directory renaming utility for MS Windows DOS prompt (32-bit protected Mode)
 * Instructions:  See "Help" function.
 * Written by:    Robbie Hatley
 * Date written:  October 2000
 * To make:       Link with rhdir.o in librh.a
 * Edit History:
 * 2000-10-21:
 *    Win98 file names can have more than one dot!  So the LAST dot is the only important one. I need to
 *    devise a means to determine the position of the last dot in a file name.
 * 2000-10-25:
 *    I need to use structures, and change input from command line to scanf.
 * 2000-12-03:
 *    I changed the input format from command-line arguments to internal inputs via scanf.
 * 2000-12-30:
 *    I had to change the input method for files to be renamed and pattern string from scanf to gets, because
 *    scanf stops inputting after the first word.
 * 2001-06-24:
 *    gets() is not good, because it doesn't check for array over-run. Use fgets(char *StringVar, int Length,
 *    stdin) instead. Also, get rid of unnecessary output clutter. I did the above things.  It didn't work,
 *    because I forgot that unlike gets(), fgets() includes the newline character in the input! DOH! :-)
 *    Easy enough to fix... Fixed! I also ran into a problem with my new Input() function: since it was a void
 *    function, it didn't return a pointer like fgets() does, so I couldn't test for read failure or
 *    end-of-file. So I changed it to type "char * Input(char *a, int max, FILE p)". Input() now returns the
 *    value of fgets() as its value.
 * 2001-07-28:
 *    I cleaned up these corrected instructions, and improved the "abort / continue" prompt to read an
 *    unbuffered character and decide what to do based on whether the character is 'y' (rename), 'n' (skip),
 *    or 'a' (abort program). This involved having to add this include: "#include <conio.h>" in order to be
 *    able to use the getch() function, which is an unbuffered version of getchar() function.
 * 2002-07-18:
 *    I added the ability to read characters from the prefix and suffix portions of the original file name and
 *    put them anywhere in the new file name.  This involved inventing three new wildcard characters for
 *    pattern strings: ':' (write one char from suffix), '|' (write all remaining chars from suffix), and
 *    '<' (backspace).  It also involved changing the meaning of '\' from "backspace" to "skip one suffix
 *    char". I also cleaned up a bunch of things that were being done in an inappropriate or dangerous way.
 *    Eg, I replace most instanced of sprintf() with strncat() and strcat() and some pointer arithmetic.
 *    And, I thoroughly updated the instructions.
 * 2002-07-18:
 *    I just copied this program from "renamefiles.c" to "renamefiles.cpp". I now intend to re-work this as
 *    a C++ program.  That way I can make FileInfo and FileName classes instead of structs.  This should
 *    allow me to easily create and destroy local instances of these classes, reducing reliance on global
 *    variables.
 * 2003-05-02:
 *    It's all C++ now, and much improved over the original C version in many ways.  Most of the work on the
 *    new version was done in February 2003.  I cleaned it up a bit more today, removing some C vestiges and
 *    improving formatting. I moved all the typedefs to the beginning of the program, and changed them all
 *    to #defines, just because I felt like being a bit anachronistic. Macros are cool. I also cleaned-up
 *    the instructions, getting rid of all those "+="s and that ridiculously long string.  It's just 1 cout
 *    statement now, with only one endl.
 *     Wed May 19, 2004 - Edited.
 * 2004-05-26:
 *    I've setup my library to provide a template function (LoadFileList<>())
 *    that can load file information into a variety of containers of elements,
 *    including a vector of FileName.  I've also altered the indentation system
 *    to use tabs instead of spaces, and I've moved a lot of the code from
 *    main() to subroutines.
 *    Sun Jul 11, 2004 - Edited.
 * 2005-09-11:
 *    I just added regular expressions to this program!  This has been a long
 *    time in the works.  After futilely searching for a RegEx library I could
 *    use, I discovered that djgpp already has (deeply buried) RegEx functions
 *    available.  So I used those to create rhutil::Substitute(), which is
 *    basically the same as the s/asdf/asdf/ operator in Awk or Perl.  Works
 *    great, too!
 * 2005-09-13:
 *    I ran into some infinite-recursion and stack-overflow problems, because
 *    my global replace was replacing substrings of substrings it had already
 *    replaced.  So I had to break Text2 in rhdir::Substitute into
 *    "processed" and "not-yet-processed" chunks, and only send the
 *    not-yet-processed chunk to the next recursive level of Substitute,
 *    then re-glom the already-processed chunk with the return value of
 *    the recusive Substitute call, and return the result.  Global replace
 *    now works correctly.
 * Fri Jun 09, 2005:
 *    Cleaned-up main(); started adding directory-renaming support (in progress); added new switches for
 *    recursion, mode, and target.
 * Fri Sep 09, 2005:
 *    Simplified. Got rid of GetPatternString() and CheckPatternString(). Combined filename-pattern-replace
 *    into renamefiles. 
 * Sun Sep 11, 2005:
 *    Added Regular Expressions!!!  This is now the default renaming method.
 * Tue Sep 13, 2005:
 *    Fixed infinite-recursion bug in rhutil::Substitute().  Global replace now works fine.
 * Thu Oct 28, 2004:
 *    Edited.
 * Fri Dec 03, 2010:
 *    Decided to go with command-line interface instead of prompting user for input. 
 *    This program will now take exactly 3 command-line arguments:
 *    Arg 1: "files to be renamed"
 *    Arg 2: "regex to be replaced"
 *    Arg 3: "replacement pattern"
 *    Switches and arguments can be freely mixed as long as arguments are in this order.
 * Mon Apr 20, 2015:
 *    I got fed up with the limitations, inefficiencies, and complexities of trying to use
 *    C++ to work with files, folders, and Unicode, so I started re-writing this program as a Perl script.
 * Fri Jul 17, 2015: 
 *    The Perl version of this program is now fully functional (and fully Unicode compliant) and MUCH easier
 *    to maintain, so this C++ version is now just a toy.
 * Wed Mar 30, 2016:
 *    Made many changes in this C++ version to accommodate change-over from DJGPP to Cygwin.
 * Sun Apr 10, 2016:
 *    Separated-out my homebrew "getkey" routine from this program to rhutil where it will
 *    be of wider use. Also spent many hours struggling with bugs in my rhregex module. 
 *    I'm considering going over to the new C++ std::regex (new in C++ as of 2011).
 * Tue Apr 12, 2016:
 *    Got the C version of Substitute working, so back to using that for now, because I
 *    want to explore using C technology in conjunction with C++ technology.
 *    (Either that, or I'm a closet masochist.)
 * Sat Feb 20, 2021:
 *    This C++ version hasn't been maintained in nearly 5 years and will almost certainly continue to be
 *    a dunsel forever. Don't use this; use "rename-files.pl" instead.
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <cstdio>

#undef NDEBUG
#include <assert.h>
#include <errno.h>

#define BLAT_ENABLE
#include "rhdefines.h"
#include "rhutilc.h"
#include "rhutil.hpp"
#include "rhdir.hpp"
#include "rhregex.hpp"

namespace ns_RNF
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;

   typedef std::vector<std::string>                        VS;
   typedef std::vector<std::string>::const_iterator        VSCI;
   typedef rhdir::FileRecord                               FR;
   typedef std::vector<rhdir::FileRecord>                  VFR;
   typedef std::vector<rhdir::FileRecord>::const_iterator  VFRCI;

   enum Mode_t
   {
      PROMPT,
      SIMULATE,
      NOPROMPT
   };

   enum Target_t
   {
      FILES = 1,
      DIRS  = 2,
      BOTH  = 3
   };

   struct Settings_t
   {
      // data members:
      bool          Help;         // Print help and exit?            (bool)
      Mode_t        Mode;         // Prompt mode?                    (enum)
      bool          Recurse;      // Recurse?                        (bool)
      bool          Verbose;      // Blather on so?                  (bool)
      Target_t      Target;       // Files, directories, or both?    (enum)
      std::string   Entities;     // Files and/or Directories.       (string)
      std::string   RegEx;        // Regular Expression to look for. (string)
      std::string   Replacement;  // Replacement string.             (string)
      std::string   Wildcard;     // Process which files?            (string)
      // function members:
      Settings_t()                // default constructor
      {
         Help        = false;     // no help
         Mode        = PROMPT;    // prompt
         Recurse     = false;     // don't recurse
         Verbose     = true;      // do blather on so
         Target      = FILES;     // files only
         Entities    = "Files";   // files only
         RegEx       = "(.*)";    // default regex is "group containing any string of characters"
         Replacement = "\\1";     // default replacement is "matched group"
         Wildcard    = "*";       // default wildcard is "all files"
      }
     ~Settings_t(){}              // Nothing for destructor  to do.
   };

   struct Stats_t
   {
      // data members:
      long int   DirsCount; // Count of directories  processed.
      long int   FileCount; // Count of    items     encountered.
      long int   BypaCount; // Count of    items     bypassed by program.
      long int   ConsCount; // Count of    items     consided for renaming.
      long int   SkipCount; // Count of    items     skipped by user.
      long int   AtteCount; // Count of file renames attempted.
      long int   SuccCount; // Count of file renames succeeded.
      long int   FailCount; // Count of file renames failed.
      // function members:
      Stats_t() // default constructor
         : DirsCount(0), FileCount(0), BypaCount(0), ConsCount(0), 
           SkipCount(0), AtteCount(0), SuccCount(0), FailCount(0)
         {} // empty function body (all work is done by initializer list)
     ~Stats_t(){} // no work for destructor to do
      void PrintStats (void)
      {
         // Write statistics to screen:
         cout
                                                          << endl
         << "Directories processed       = " << DirsCount << endl
         << "Items encountered           = " << FileCount << endl
         << "Items bypassed by program   = " << BypaCount << endl
         << "Items considered for rename = " << ConsCount << endl
         << "Items skipped by user       = " << SkipCount << endl
         << "Renames attempted           = " << AtteCount << endl
         << "Renames Succeeded           = " << SuccCount << endl
         << "Renames failed              = " << FailCount << endl
                                                          << endl;
      }
   };

   bool
   IsSwitch
   (
      std::string Item
   );

   void 
   GetSwitchesAndArguments
   (
      int     const  &  Kevin, 
      char**  const  &  Clarise, 
      VS             &  Switches, 
      VS             &  Arguments
   );

   void 
   ProcessSwitchesAndArguments
   (
      VS          const  &  Switches, 
      VS          const  &  Arguments, 
      Settings_t         &  Settings
   );
   
   class ProcessCurDirFunctor
   {
      public:
         ProcessCurDirFunctor
            (
               Settings_t  &  Settings_,
               Stats_t     &  Stats_,
               VFR         &  FileList_
            )
            : Settings(Settings_), Stats(Stats_), FileList(FileList_)
            {}
         void operator()(void); // defined below
      private:
         Settings_t  &  Settings;
         Stats_t     &  Stats;
         VFR         &  FileList;
   };

   void
   ProcessCurrentFile
   (
      Settings_t         &  Settings,
      Stats_t            &  Stats,
      FR          const  &  FileRec
   );

   void Help (void);

} // End namespace ns_RNF.


int main(int Kevin, char** Clarise)
{
   std::ios_base::sync_with_stdio();

   using namespace ns_RNF;

   VS           Switches   = VS();
   VS           Arguments  = VS();
   Settings_t   Settings   = Settings_t();
   Stats_t      Stats      = Stats_t();
   
   GetSwitchesAndArguments (Kevin, Clarise, Switches, Arguments);

   ProcessSwitchesAndArguments (Switches, Arguments, Settings);

   // If user wants help, give help and exit:
   if (Settings.Help)
   {
      Help();
      return 777;
   }

   // If number of arguments is not 2 or 3, bail:
   if ( Arguments.size() < 2 or Arguments.size() > 3 )
   {
      cerr 
      << "Error: RenameFiles takes either 2 or 3 arguments: RegEx, Replacement, and" << endl
      << "optionally a file-filter wildcard.  But you typed " << Arguments.size() << " arguments." << endl
      << "Did you forget to put the arguments (esp. the wildcard!) in 'single quotes'?" << endl
      << "Failure to do this can send dozens -- or hundreds, or thousands -- of" << endl
      << "arguments to RenameFiles, instead of the required 2 or 3." << endl;
      return 666; // Something evil happened!
   }

   // If we get to here, we're committing to actually doing something functional,
   // so make a file-list container and reserve 10,000 spots in it:
   static VFR FileList;
   FileList.reserve(10000);

   // Now make a function object of type "ProcessCurDirFunctor":
   ProcessCurDirFunctor ProcessCurDir (Settings, Stats, FileList);

   // If user wants recursion, recurse:
   if (Settings.Recurse)
   {
      rhdir::CursDirs(ProcessCurDir);
   }

   // Otherwise, process current directory only:
   else
   {
      ProcessCurDir();
   }

   // Print stats:
   Stats.PrintStats();

   // We be done, so scram:
   return 0;
} // End main()


bool
ns_RNF::
IsSwitch
   (
      std::string Item
   )
{
   if
      (
         Item == "-h" or Item == "--help"          or
         Item == "-p" or Item == "--mode=prompt"   or
         Item == "-s" or Item == "--mode=simulate" or
         Item == "-y" or Item == "--mode=noprompt" or
         Item == "-r" or Item == "--recurse"       or
         Item == "-q" or Item == "--quiet"         or
         Item == "-f" or Item == "--target=files"  or
         Item == "-d" or Item == "--target=dirs"   or
         Item == "-b" or Item == "--target=both"
      )
   {
      return true;
   }
   else
   {
      return false;
   }
}

void 
ns_RNF::
GetSwitchesAndArguments
   (
      int     const  &  Kevin, 
      char**  const  &  Clarise, 
      VS             &  Switches, 
      VS             &  Arguments
   )
{
   for ( int i = 1 ; i < Kevin ; ++i)
   {
      if (IsSwitch(Clarise[i]))
      {
         Switches.push_back(Clarise[i]);
      }
      else
      {
         Arguments.push_back(Clarise[i]);
      }
   }
   return;
}


void 
ns_RNF::
ProcessSwitchesAndArguments
   (
      VS            const  &  Switches, 
      VS            const  &  Arguments, 
      Settings_t           &  Settings
   )
{
   // First, set settings based on switches:
   for ( VSCI i = Switches.begin() ; i != Switches.end() ; ++i )
   {
      if ((*i) == "-h" or (*i) == "--help"          ) Settings.Help    = true;
      if ((*i) == "-p" or (*i) == "--mode=prompt"   ) Settings.Mode    = PROMPT;
      if ((*i) == "-s" or (*i) == "--mode=simulate" ) Settings.Mode    = SIMULATE;
      if ((*i) == "-y" or (*i) == "--mode=noprompt" ) Settings.Mode    = NOPROMPT;
      if ((*i) == "-r" or (*i) == "--recurse"       ) Settings.Recurse = true;
      if ((*i) == "-q" or (*i) == "--quiet"         ) Settings.Verbose = false;

      if ((*i) == "-f" or (*i) == "--target=files"  )
      {
         Settings.Target   = FILES;
         Settings.Entities = "Files";
      }

      if ((*i) == "-d" or (*i) == "--target=dirs"   )
      {
         Settings.Target   = DIRS;
         Settings.Entities = "Directories";
      }

      if ((*i) == "-b" or (*i) == "--target=both"   )
      {
         Settings.Target   = BOTH;
         Settings.Entities = "Files and Directories";
      }

   }

   // Store arguments in Settings:
   if ( Arguments.size() > 0 ) Settings.RegEx       = Arguments[0];
   if ( Arguments.size() > 1 ) Settings.Replacement = Arguments[1];
   if ( Arguments.size() > 2 ) Settings.Wildcard    = Arguments[2];
   BLAT("In program \"renamefiles.exe\",")
   BLAT("in function \"ProcessSwitchesAndArguments\";")
   BLAT("Settings.RegEx = " << Settings.RegEx)
   BLAT("Length of regex = " << Settings.RegEx.size())
   return;
}


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessCurDirFunctor::operator()                                        //
//                                                                          //
//  Processes current directory.                                            //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void ns_RNF::ProcessCurDirFunctor::operator() (void)
{
   BLAT("Just entered ns_RNF::ProcessCurDirFunctor::operator().");

   // Increment directory counter:
   ++Stats.DirsCount;

   // Get current directory:
   char Buffer[300] = {'\0'};
   getcwd(Buffer, sizeof(Buffer)-5);

   // Announce current directory if being verbose:
   if (Settings.Verbose)
   {
      cout
         << endl
         << endl
         << "Directory #" << Stats.DirsCount << ":" << endl
         << Buffer << endl;
   }

   // Load names of files and/or directories in current directory which match Wildcard into
   // a list "Files" of file-record objects:
   rhdir::LoadFileList(FileList, Settings.Wildcard, Settings.Target);

   // Print file and/or directory names matching wildcard:
   if (Settings.Verbose)
   {
      cout 
         << endl 
         << endl 
         << "The matching " << Settings.Entities << " in the current directory are:" << endl;
      rhdir::PrintFileList(FileList);
   }

   // Now that we have collected all the information we need, process the files:
   BLAT("In ns_RNF::ProcessCurDirFunctor::operator().  About to process files.");
   for ( VFRCI i = FileList.begin() ; i != FileList.end() ; ++i )
   {
      ProcessCurrentFile(Settings, Stats, *i);
   } // End for (each file in FileList)
   BLAT("In ns_RNF::ProcessCurDirFunctor::operator().  Finished processing files.");

   // We be done, so scram:
   BLAT("About to return from ns_RNF::ProcessCurDirFunctor::operator().");
   return;
} // End ProcessCurDir()


//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  ProcessCurrentFile()                                                    //
//                                                                          //
//  Processes current file.                                                 //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////

void
ns_RNF::
ProcessCurrentFile
   (
      Settings_t         &  Settings,
      Stats_t            &  Stats,
      FR          const  &  FileRec
   )
{
   BLAT("Just entered ns_RNF::ProcessCurrentFile(). Current file = " << FileRec.name);
   std::string OldName = FileRec.name;
   std::string NewName = std::string();

   // Increment file counter:
   ++ Stats.FileCount;

   BLAT("In ns_RNF::ProcessCurrentFile(). About to call rhregex::SubstituteC().")
   try
   {
      NewName = rhregex::SubstituteC(Settings.RegEx, Settings.Replacement, OldName, "g");
   }
   catch (rhregex::RegExException up)
   {
      cerr << up.msg                                                            << endl;
      cerr << "Warning: Bad RE.  Reusing old name as new name."                 << endl;
      cerr << "You are strongly advised to abort this session of RenameFiles,"  << endl;
      cerr << "correct the bad RE, and try again."                              << endl;
   }
   BLAT("In ns_RNF::ProcessCurrentFile().  Returned from rhregex::Substitute().");

   // While last character of new file name is a dot, strip last character:
   bool bDotFlag = false;
   while ('.' == NewName[NewName.size()-1])
   {
      bDotFlag = true;
      NewName.erase(NewName.size()-1, 1);
   }

   if (bDotFlag)
   {
      cerr
         << "Warning: had to erase one or more dots from end of new file name." << endl;
   }

   // If new name is same as old, bypass this item and skip to next:
   if (NewName == OldName)
   {
      ++Stats.BypaCount;
      return;
   }

   // Otherwise, new name is different from old name, so increment the "consideration" counter
   // to indicate we've found a potential rename and are considering some action (such as prompt, 
   // simulate, automatically-rename-all, etc.) depending on Mode setting:
   else
   {
      ++Stats.ConsCount;
   }

   // Now, try take some action, depending on what mode we're in:
   switch (Settings.Mode)
   {
      case PROMPT: // prompt Mode
      {
         BLAT("In ns_RNF::ProcessCurrentFile(), switch (Mode), case PROMPT.");
         // Prompt user and get a response (a single keystroke, which must be one of "ynqa"):
         cout
            << endl
            << "Rename \"" << OldName << "\" to \"" << NewName << "\"?" << endl
            << "(Press \'y\' to rename, \'n\' to skip, \'q\' to quit, or \'a\' to rename all)" << endl;
         char ch = 0;
         while (42) // Loop 'til pigs fly.
         {
            ch = getkey();
            if (std::string("ynqa").find(ch) < 4) break;
            cout
               << endl
               << "Invalid keystroke!" << endl
               << "Press \'y\' to rename, \'n\' to skip, \'q\' to quit, or \'a\' to rename all." << endl
               << "Keystroke must be lower-case, so don't use the \"Shift\" or \"Caps-Lock\" keys." << endl;
         }

         // Take action depending on user's response:
         switch (ch)
         {
            case 'y': // Attempt to rename the file, then return:
            {
               ++Stats.AtteCount;
               bool bSuccess = rhdir::RenameFile(OldName, NewName);
               if (bSuccess)
               {
                  ++Stats.SuccCount;
                  cout << "Successfully renamed \"" << OldName << "\" to \"" << NewName << "\"." << endl;
               }
               else
               {
                  ++Stats.FailCount;
                  cerr << "Failed to rename \"" << OldName << "\" to \"" << NewName << "\"." << endl;
               }
               return;
            }

            case 'n': // Don't rename the file, just return (move on to next file):
            {
               ++Stats.SkipCount;
               return;
            }

            case 'q': // Exit the application, returning 0:
            {
               exit(0);
            }

            case 'a': // Set Mode to NOPROMPT, attempt to rename the file, and return:
            {
               Settings.Mode = NOPROMPT;
               ++Stats.AtteCount;
               bool bSuccess = rhdir::RenameFile(OldName, NewName);
               if (bSuccess)
               {
                  ++Stats.SuccCount;
                  cout << "Successfully renamed \"" << OldName << "\" to \"" << NewName << "\"." << endl;
               }
               else
               {
                  ++Stats.FailCount;
                  cerr << "Failed to rename \"" << OldName << "\" to \"" << NewName << "\"." << endl;
               }
               return;
            }

            default:
            {
               cerr << "Impossible keystroke in switch in \"renamefile.cpp\"; aborting program." << endl;
               assert(0);
            }

         } // End switch (State)
      } // End switch (Mode) case PROMPT

      case SIMULATE: // "simulate" Mode
      {
         BLAT("In ns_RNF::ProcessCurrentFile(), switch (Mode), case SIMULATE.");
         ++Stats.SkipCount;
         cout
            << endl
            << "Simulated rename:" << endl
            << "Old name: \"" << OldName << "\"    New name: \"" << NewName << "\"" << endl;
         return;
      } // End switch (Mode) case SIMULATE

      case NOPROMPT: // "no-prompt" Mode
      {
         BLAT("In ns_RNF::ProcessCurrentFile(), switch (Mode), case NOPROMPT.");
         ++Stats.AtteCount;
         if (Settings.Verbose)
         {
            cout
               << endl
               << "Renaming \"" << OldName << "\" to \"" << NewName << "\"..." << endl;
         }
         bool bSuccess = rhdir::RenameFile(OldName, NewName);
         if (bSuccess)
         {
            ++Stats.SuccCount;
            if (Settings.Verbose)
            {
               cout << "Successfully renamed \"" << OldName << "\" to \"" << NewName << "\"." << endl;
            }
         }
         else
         {
            ++Stats.FailCount;
            cerr << "Failed to rename \"" << OldName << "\" to \"" << NewName << "\"." << endl;
         }
         return;
      } // End switch (Mode) case NOPROMPT
   } // End switch(mode)
   BLAT("About to return from ns_RNF::ProcessCurrentFile().");
   return;
} // End ProcessFile()


void ns_RNF::Help(void)
{
   cout
   << "Welcome to renamefiles.exe, Robbie Hatley's file renaming utility."                     << endl
                                                                                               << endl
   << "This version compiled at " << __TIME__ << " on " << __DATE__ << "."                     << endl
                                                                                               << endl
   << "Command line:"                                                                          << endl
   << "renamefiles [-h] [-r] [-t -u -x] [-p -s -y] [-f -d -b] Arg1 Arg2 [Arg3]"                << endl
                                                                                               << endl
   << "Brief description of switches:"                                                         << endl
   << "Switch:                      Meaning:"                                                  << endl
   << "\"-h\" or \"--help\"             Print help and exit."                                  << endl
   << "\"-p\" or \"--mode=prompt\"      Prompt for each rename (default)."                     << endl
   << "\"-s\" or \"--mode=simulate\"    Simulate renames (don't actually rename files)."       << endl
   << "\"-y\" or \"--mode=noprompt\"    Rename files without prompting."                       << endl
   << "\"-r\" or \"--recurse\"          Rename files in all subdirectories."                   << endl
   << "\"-f\" or \"--target=files\"     Rename files but not directories (default)."           << endl
   << "\"-d\" or \"--target=dirs\"      Rename directories only."                              << endl
   << "\"-b\" or \"--target=both\"      Rename both files and directories"                     << endl
                                                                                               << endl
   << "Brief description of arguments:"                                                        << endl
   << "Arg 1: \"Regular Expression\" giving a pattern to find and replace in file names."      << endl
   << "Arg 2: \"Replacement String\" giving substitution for regex match."                     << endl
   << "Arg 3: \"Wildcard\" specifying files to be renamed (optional)."                         << endl
                                                                                               << endl
   << "Example command lines:"                                                                 << endl
   << "renamefiles -r \"([[:alpha:]]{3})([[:digit:]]{3})\" \"\\1-\\2\" \"*.txt\""              << endl
   << "   (would rename \"sjx387.txt\" to \"sjx-387.txt\")"                                    << endl
   << "renamefiles -d \"dog\" \"cat\""                                                         << endl
   << "   (would renames \"red-dogs-0375\" to \"red-cats-0375\")"                              << endl
                                                                                               << endl
   << "Detailed explanation of switches and arguments:"                                        << endl
                                                                                               << endl
   << "By default, Renamefiles will prompt the user to confirm or reject each rename"          << endl
   << "it proposes based on the settings the user gave.  However, this can be altered."        << endl
                                                                                               << endl
   << "Using a \"-s\" or \"--mode=simulate\" switch will cause Renamefiles to simulate"        << endl
   << "file renames rather than actually perform them, displaying the new names which"         << endl
   << "would have been used had the rename actually occurred."                                 << endl
                                                                                               << endl
   << "Using a \"-y\" or \"--mode=noprompt\" switch will have the opposite effect:"            << endl
   << "all renames will be performed automatically without prompting."                         << endl
                                                                                               << endl
   << "Also, the prompt mode can be changed from \"prompt\" to \"no-prompt\" on the fly"       << endl
   << "by tapping the \'a\' key instead of the \'y\' key at the prompt.  All remaining"        << endl
   << "renames will then be performed automatically without further prompting."                << endl
                                                                                               << endl
   << "Directory selection:"                                                                   << endl
   << "By default, RenameFiles will rename files in the current directory only."               << endl
   << "However, if a \"-r\" or \"--recurse\" switch is used, all subdirectories"               << endl
   << "of the current directory will also be processed."                                       << endl
                                                                                               << endl
   << "Quiet vs Verbose:"                                                                      << endl
   << "Normally, renamefiles prints all sorts of useful information to the screen"             << endl
   << "while it's processing folders and files; but you can make it shut up and"               << endl
   << "be quiet by using a \"-q\" or \"--quiet\" switch."                                      << endl
                                                                                               << endl
   << "Target selection:"                                                                      << endl
   << "By default, RenameFiles renames files only, not directories.  However, if a"            << endl
   << "\"-d\" or \"--target=dirs\" switch is used, it will rename directories instead."        << endl
   << "If a \"-b\" or \"--target=both\" switch is used, it will rename both."                  << endl
                                                                                               << endl
   << "Arguments:"                                                                             << endl
   << "Renamefiles takes 2 or 3 command-line arguments.  THE ARGUMENTS SHOULD BE"              << endl
   << "ENCLOSED IN \"DOUBLE QUOTES\"!  Failure to do this may result in unexpected"            << endl
   << "errors, because if DOS sees unquoted characters which could be construed"               << endl
   << "as a file-name wildcard, it will send the matching file names in the current"           << endl
   << "directory to RenameFiles as arguments, instead of sending the actual wildcard"          << endl
   << "which you typed.  That won't work, because RenameFiles is designed to navigate"         << endl
   << "directory structures recursivly, so it needs the symbolic wildcard instead of"          << endl
   << "just a list of matching files in one directory.  Arguments may be freely mixed"         << endl
   << "with switches, but the arguments must appear in this order:"                            << endl
   << "Arg 1: \"Regular Expression\" giving a pattern to find and replace in file names."      << endl
   << "       This has the usual regular-expression syntax and semantics as in egrep."         << endl
   << "Arg 2: \"Replacement String\" giving the string to substitute for regex match."         << endl
   << "       This may contain backreferences to items stored via the regex."                  << endl
   << "       Backreference syntax is \"\\1\", \"\\2\", etc."                                  << endl 
   << "Arg 3: (optional) \"Wildcard\" specifying files to be renamed.  This has the"           << endl
   << "       usual DOS syntax and semantics.  Ie, ? means \"any one character\","             << endl
   << "       * means zero-or-more characters, and . means a literal dot."                     << endl
   << "       The purpose of this wildcard is to do initial filtering of files,"               << endl
   << "       such as selecting *.txt files only, or *.jpg files only."                        << endl
   << "       If the wildcard is ommitted, it will be assumed to be '*'."                      << endl
                                                                                               << endl
   << "File renaming method:"                                                                  << endl
   << "This program renames files by using a regular expression (\"regex\"),"                  << endl
   << "and a replacement string, which may contain back references stored by the"              << endl
   << "regex.  For more on using regular expressions to find and/or alter text,"               << endl
   << "google \"regular expressions\"."                                                        << endl
                                                                                               << endl
   << "Happy file renaming!"                                                                   << endl
                                                                                               << endl
   << "Cheers,"                                                                                << endl
   << "Robbie Hatley,"                                                                         << endl
   << "programmer."                                                                            << endl
                                                                                               << endl;
   return;
} // End Help()


/****************************************************************************\
 * Development Notes for this program:
\****************************************************************************/
