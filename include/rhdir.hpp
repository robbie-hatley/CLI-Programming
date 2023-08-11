/// This is a 110-character-wide ASCII-encoded C++ library header file.
#ifndef RHDIR_CPP_HEADER_ALREADY_INCLUDED
#define RHDIR_CPP_HEADER_ALREADY_INCLUDED
/************************************************************************************************************\
 * File Name:            rhdir.hpp
 * Header For:           rhdir.o (see file "rhdir.cpp" for source code)
 * Module Name:          Directory and File Utilities
 * Author:               Robbie Hatley
 * To use in program:    #include "rhdir.h" and Link program with module rhdir.o in library librh.a .
 * Edit history:         See bottom of file "rhdir.cpp".
\************************************************************************************************************/

// Std C++ headers:
#include <iostream>
#include <iomanip>
#include <string>
#include <list>
#include <map>
#include <sstream>
#include <fstream>
#include <stdexcept>
#include <functional>
#include <algorithm>

// Std C headers:
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cctype>
#include <cstdint>

// GNU headers:
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fnmatch.h>

// Personal headers:
#include "rhdefines.h"

// Using declarations:
using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using std::setfill;
using std::setw;

//============================================================================================================
// Exceptions Thrown By Functions In This Header:
//============================================================================================================
// rhdir::FileIOException    An error occured while trying to read or write a file.
// rhdir::DirNavException    An error occured while trying to navigate directories.
//
// The cause of the error will appear in the std::string "msg" member of the exception object, usually "up",
// which is thrown up to the calling program.
//
// Therefore any functions which call file or directory handling functions in rhdir should catch
// the above exceptions.
//
// Example:
//
//    try
//    {
//       rhdir::SomeFunctionThatOpensAFile(FileName);
//    }
//    catch (rhdir::FileIOException E)
//    {
//       cerr
//          << "Error occurred trying to dewhizculate file " << FileName << endl
//          << "Error message from rhdir::SomeFunctionThatOpensAFile():" << endl
//          << E.msg << endl;
//          << "Continuing with next file. << endl;
//       continue;
//    }

//============================================================================================================
// Functions In This Header Which Throw Exceptions:
//============================================================================================================
// LoadFileList           throws DirNavException "up" on failure to open directory.
// LoadFileToContainer    throws FileIOException "up" on failure to open file.
// LoadFileToContainer    throws FileIOException "up" on file stream going bad.
// SaveContainerToFile    throws FileIOException "up" on failure to open file.
// SaveContainerToFile    throws FileIOException "up" on file stream going bad.
// AppendFileToContainer  throws FileIOException "up" on failure to open file.
// AppendFileToContainer  throws FileIOException "up" on file stream going bad.
// AppendContainerToFile  throws FileIOException "up" on failure to open file.
// AppendContainerToFile  throws FileIOException "up" on file stream going bad.
//
// Note: rhdir::RenameFile() does not throw exceptions because it does not open files or even attempt to
// directly rename them.  It uses djgpp non-std library function rename() from libc.a (in header <cstdio>
// or <stdio.h>) to do the actual renaming.  That function returns a result code which is 0 if no error, or
// non-zero error code if error.  If an error occurs, rhdir::RenameFile() presents an english interpretation
// of the error code received from rename(), then calls abort() in order to prevent further destruction of
// files.
//
// Note: rhdir::GetFullCurrPath() does not throw exceptions because if one is not even able to get one's full
// current path, then the program and/or OS and/or hardware is totally hosed, so rhdir::GetFullCurrPath
// prints an error message to cerr and exits the program with code 666.


/************************************************************************************************************\
 * Namespace rhdir:                                                                                         *
\************************************************************************************************************/

// This is the main namespace, "rhdir", for this module.  In it, declare all classes and functions
// for this module, and also include the definitions in the case of classes, templates, and inline functions:

namespace rhdir
{
//============================================================================================================
// Section 1:
// Constants used by RH directory module:
//============================================================================================================

const unsigned short int  FA_RDONLY  =  1;
const unsigned short int  FA_HIDDEN  =  2;
const unsigned short int  FA_SYSTEM  =  4;
const unsigned short int  FA_LABEL   =  8;
const unsigned short int  FA_DIREC   = 16;
const unsigned short int  FA_ARCH    = 32;

//============================================================================================================
// Section 2:
// Exception Classes:
//============================================================================================================

struct FileSystemException {};

struct FileIOException : public FileSystemException // : public std::runtime_error
{
   FileIOException     (    void     ) : msg("") {} // , runtime_error("") {}
   FileIOException     (std::string S) : msg(S ) {} // , runtime_error(S ) {}
   ~FileIOException() throw() {}
   std::string msg;
};

struct DirNavException : public FileSystemException // : public std::runtime_error
{
   DirNavException     (    void     ) : msg("") {} // , runtime_error("") {}
   DirNavException     (std::string S) : msg(S ) {} // , runtime_error(S ) {}
   ~DirNavException() throw() {}
   std::string msg;
};



//============================================================================================================
// Section 3:
// Private functions for use by functions in this namespace only (keeps modules separate):
//============================================================================================================


// Convert std::string to all-lower-case:
std::string
StringToLower
   (
      std::string const & InputString
   );


// Determine whether two std::strings are non-case-sensitively "equal":
bool
NCS_Equal
   (
      std::string const & Bob,
      std::string const & Fred
   ); // (Defined in "rhdir.cpp".)


// Return a copy of a source std::string with any leading and/or trailing spaces stripped from it:
std::string
StripLeadingAndTrailingSpaces
   (
      std::string const & Input
   ); // (Defined in "rhdir.cpp".)


// Get random double:
double RandNum(double min, double max);
// (Defined in "rhdir.cpp".)


// Get random int:
int RandInt(int min, int max);
// (Defined in "rhdir.cpp".)


//============================================================================================================
// Section 4:
// General file and directory utility functions:
//============================================================================================================


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// 4.01                                                                                                     //
// GetCwd()                                                                                                 //
// Returns path of current working directory as a std::string.                                              //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

std::string GetCwd(void);
// (Defined in rhdir.cpp .)


/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
// 4.02                                                                                    //
// FileExists()                                                                            //
// Returns true if and only if the given file exists.                                      //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

bool
FileExists
(
   std::string FileName
);
// (Defined in rhdir.cpp .)


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
// 4.03                                                                                  //
// FilesAreIdentical()                                                                   //
// Compares two files and returns true if they identical, false if they are different.   //
// Throws a "FileIOException" exception if file IO error occurs.                         //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

bool FilesAreIdentical (const std::string& File1, const std::string& File2);
// (Defined in rhdir.cpp .)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// 4.04                                                                                                     //
// GoToDir()                                                                                                //
// Attempts to change current directory to given target.  Returns an error code which is                    //
// false if attempt suceeded or true if attempt failed.  If attempt failed, prints                          //
// detailed error message indicating original, target, and final directories.                               //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool GoToDir (const std::string & TargetDir);
// (Defined in rhdir.cpp .)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  4.05                                                                                                    //
//  FileNameIsWindowsInvalid()                                                                              //
//                                                                                                          //
//  Returns true if FileName is invalid; otherwise returns false.                                           //
//  For the purposes of this function, "invalid" means that one or more of the following is true:           //
//  1. File name is more than 256 characters long                                                           //
//  2. First character of FileName is a space                                                               //
//  3. Last  character of FileName is a space                                                               //
//  4. Last  character of FileName is a dot                                                                 //
//  5. File name contains one or more reserved characters:  \/:*?"<>|                                       //
//  6. File name contains one or more ASCII control characters: (0-31)                                      //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool
FileNameIsWindowsInvalid
   (
      std::string         const & FileName,
      std::ostringstream        & ErrMsg
   );
// (Defined in rhdir.cpp .)


//////////////////////////////////////////////////////////////////
//                                                              //
//  4.06                                                        //
//  RenameFile()                                                //
//                                                              //
//  Renames a file, while taking some safety precautions.       //
//  Return value indicates whether file rename was successful.  //
//                                                              //
//////////////////////////////////////////////////////////////////

bool
RenameFile
   (
      std::string const & OldFileName,
      std::string const & NewFileName
   );
// (Defined in rhdir.cpp .)



////////////////////////////////////////////////////////////////////
//                                                                //
//  4.07                                                          //
//  Untilde()                                                     //
//                                                                //
//  Replaces '~' with '_' in all file names in current directory  //
//                                                                //
////////////////////////////////////////////////////////////////////

void
UnTilde
   (
      void
   );
// (Defined in rhdir.cpp .)



//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//  4.08                                                                         //
//  size_t CountLinesInFile (const std::string&)                                 //
//                                                                               //
//  Given a std::string file name, returns the number of lines in the file.      //
//  Warning: this in intended for use with text files.  Use with other           //
//  types of files may yield unpredictable results.                              //
//                                                                              //
//  Note: also see overloaded version x.xx below, which takes a FileRecord       //
//  object as argument.                                                          //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

unsigned long int
CountLinesInFile
   (
      const std::string& file_name
   );
// (Defined in rhdir.cpp .)
// (But also see overloaded version which takes a FileRecord in section 5 below.)



///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  4.09                                                                                 //
//  std::string GetPrefix (std::string const & Name);                                    //
//                                                                                       //
//  Returns the prefix of the given file name.  (Here "prefix" means that part of a file //
//  name to the left of the right-most dot, or the entire file name if there is no dot.) //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

std::string
GetPrefix
   (
      std::string const & Name
   );
// (Defined in rhdir.cpp .)



///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  4.10                                                                                 //
//  std::string GetSuffix (std::string const & Name);                                    //
//                                                                                       //
//  Returns the suffix of the given file name.  (Here "suffix" means that part of a file //
//  name to the right of the right-most dot, or an empty string if there is no dot.)     //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

std::string
GetSuffix
   (
      std::string const & Name
   );
// (Defined in rhdir.cpp .)



//////////////////////////////////////////////////////////////////
//                                                              //
//  4.11                                                        //
//  SetPrefix()                                                 //
//                                                              //
//  Renames a file, while taking some safety precautions.       //
//  Return value indicates whether file rename was successful.  //
//                                                              //
//////////////////////////////////////////////////////////////////

bool
SetPrefix
   (
      std::string const & OldFileName,
      std::string const & NewPrefix
   );
// (Defined in rhdir.cpp .)



//////////////////////////////////////////////////////////////////
//                                                              //
//  4.12                                                        //
//  SetSuffix()                                                 //
//                                                              //
//  Renames a file, while taking some safety precautions.       //
//  Return value indicates whether file rename was successful.  //
//                                                              //
//////////////////////////////////////////////////////////////////

bool
SetSuffix
   (
      std::string const & OldFileName,
      std::string const & NewSuffix
   );
// (Defined in rhdir.cpp .)



//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//  4.13                                                                                //
//  std::string rhdir::Debracket(std::string const & OldFileName)                       //
//                                                                                      //
//  Removes all instances of "[#]" substrings from the input string, and returns the    //
//  resulting "debracketed" string.  Useful for cleaning up names of files from the     //
//  "Temporary Internet Files" directories.                                             //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////

std::string
Debracket
   (
      std::string const & OldFileName
   );
// (Defined in rhdir.cpp .)



////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//  4.14                                                                              //
//  unsigned short int rhdir::CountNumerators(std::string const & Name);              //
//                                                                                    //
//  Counts "-(####)" substrings in a file name.                                       //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

unsigned short int
CountNumerators
   (
      std::string const & Name
   );
// (Defined in rhdir.cpp .)



////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//  4.15                                                                                  //
//  std::string rhdir::Denumerate(std::string const & OldFileName)                        //
//                                                                                        //
//  Removes all instances of "-(####)" substrings from the input string, and returns      //
//  the resulting "debracketed" string.  Useful for cleaning up names of files downloaded //
//  from Usenet by NewsBin.                                                               //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////
std::string
Denumerate
   (
      std::string const & OldFileName
   );
// (Defined in rhdir.cpp .)



////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//  4.16                                                                                          //
//  std::string rhdir::Enumerate (std::string const & OldFileName);                               //
//                                                                                                //
//  Strips any old "bracket expressions" ("[#]" or "[##]") or "numerators" ("-(####)") from       //
//  OldFileName, then tacks a single new numerator, using a random number, to the end of the      //
//  prefix of the new file name.                                                                  //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////
std::string
Enumerate
   (
      std::string const & OldFileName
   );
// (Defined in rhdir.cpp .)



///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  4.17                                                                     //
//  std::string Signature(std::string Text)                                  //
//                                                                           //
//  Returns the "signature" of a file name (or other text string), which is  //
//  the source string with all digits replaced by octothorpes ('#').         //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

std::string
Signature
   (
      std::string Text // pass by value to create copy
   );
// (Defined in rhdir.cpp .)



/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//  4.18                                                                   //
//  std::string Number(std::string Text)                                   //
//                                                                         //
//  Returns a string containing only the digits from a file name (or other //
//  text string).                                                          //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

std::string
Number
   (
      std::string Text // pass by value to create copy
   );
// defined in rhdir.cpp


//============================================================================================================
// Section 5:
//============================================================================================================

#include "rhtime.cppismh"


//============================================================================================================
// Section 6:
// struct FileRecord and associated functions and templates:
//============================================================================================================

// Declare the following 3 functions first, because these are used by one of FileRecord's constructors:

// Get the type of a file, given the file's dirent entry:
std::string Type (struct dirent const * EntPtr);


// Get file permissions from mode_t object:
std::string Perm (mode_t Mode);


// Get the attributes of a file, given the file's dirent entry:
std::string Attr (struct dirent const * EntPtr);


// struct FileRecord (holds information about a file):
struct FileRecord
{
   // data members:
   std::string  name;  // Name of file, excluding directory.
   std::string  dir;   // Full path of directory in which file resides.
   std::string  type;  // File type letter code.
   std::string  perm;  // rwxrw-r-- and that sort of thing.
   size_t       size;  // File size in bytes.
   time_t       mtime; // Last-modified time, UTC, in seconds since 00:00:00 on Jan 1, 1970, minus lp scnds.
   std::string  date;  // Last-modified date, local time, string format.
   std::string  time;  // Last-modified time, local time, string format.
   std::string  attr;  // File attributes string.

   // Constructors:
   FileRecord();
   FileRecord(std::string const & Dir, struct dirent const * EntPtr, struct stat const & FileStats);
   FileRecord(FileRecord const & FR);

   // Destructors:
   ~FileRecord();

   // Methods:
   std::string path (void) const {return dir + '/' + name;} // Returns full path of file.

};


// Comparator ("<" operator) for FileRecord:
inline
bool
operator<
   (
      rhdir::FileRecord const & Left,
      rhdir::FileRecord const & Right
   )
{
   return Left.name < Right.name;
}


// Inserter for FileRecord:
std::ostream&
operator<<
   (
      std::ostream            & s,
      rhdir::FileRecord const & f
   ); // Defined in "rhdir.cpp".


// Print function for rhdir::FileRecord :
inline
void
PrintFileRecord
   (
      rhdir::FileRecord const & File
   )
{
   std::cout << File << std::endl;
}


// Print function for a container of rhdir::FileRecord objects:
template<class ContainerType>
inline
void
PrintFileList
   (
      ContainerType const & FileList
   )
{
   for_each(FileList.begin(), FileList.end(), PrintFileRecord);
}


// Load a list of all files, directories, or objects in current directory matching a wildcard into a
// vector, deque, or list of rhdir::FileRecord objects:
template<class Container>
Container&
LoadFileList
   (
      Container& C,                          // vector, deque, or list of FileRecord's
      const std::string& Wildcard  = "*",    // Default is "all names"

      int EntityCode               = 1,      // 1 => Regular files only (default).
                                             // 2 => Directories only.
                                             // 3 => All file-system objects.

      int ClrCode                  = 1       // 1 => Clear list (default)
                                             // 2 => append
   )
{
   BLAT("Just entered function LoadFileList() with parameters:")
   BLAT("Wildcard   = " << Wildcard)
   BLAT("EntityCode = " << EntityCode)
   BLAT("ClrCode    = " << ClrCode)

   #ifdef _DIRENT_HAVE_D_TYPE
   BLAT("struct dirent has d_type")
   #else
   BLAT("struct dirent does NOT have d_type")
   #endif

   std::string                 Dir           = "";
   std::string                 Wild          = "";
   DIR                     *   DirPtr        = NULL;
   struct dirent           *   EntPtr        = NULL;
   std::string::size_type      LastSlant     = 0;
   struct stat                 FileStats;
   bool                        ErrorFlag     = false;

   // Does Wildcard specify a directory?
   LastSlant = Wildcard.find_last_of("/");

   // If no slant found, set dir equal to current working directory,
   // and set Wild to Wildcard:
   if (std::string::npos == LastSlant)
   {
      BLAT("No slant found in Wildcard; getting Dir from getcwd.")
      Dir  = rhdir::GetCwd();
      Wild = Wildcard;
   }

   // Otherwise, slant was found, so get dir from Wildcard,
   // and set Wild to the part of Wildcard after slant:
   else
   {
      BLAT("Slant found in Wildcard; getting Dir from LastSlant.")
      Dir  = Wildcard.substr(0, LastSlant);
      Wild = Wildcard.substr(LastSlant, std::string::npos);
   }

   BLAT("Got Dir and Wild.")
   BLAT("Dir  = " << Dir)
   BLAT("Wild = " << Wild)

   // Erase all prior contents (if any) of C if in "Clear" mode:
   if (1 == ClrCode) {C.clear();}

   DirPtr = opendir(Dir.c_str());
   BLAT("Ran opendir(). DirPtr = " << DirPtr)
   if (!DirPtr)
   {
      rhdir::DirNavException up;
      up.msg = "Error in LoadFileList: couldn't open directory " + Dir;
      throw up;
   }

   // Search for directory entries matching flags and wildcard:
   while ( ( EntPtr = readdir(DirPtr) ) )
   {
      BLAT("At top of LoadFileList() while loop.")
      BLAT("EntPtr->d_name = " << EntPtr->d_name)

      // First of all, what kind of object is "EntPtr->d_name"? Ie, is it a regular file, directory,
      // or something else? To find out, get stats for current file:
      BLAT("About to run lstat() for file " << EntPtr->d_name)
      ErrorFlag = lstat(EntPtr->d_name, &FileStats);
      if (ErrorFlag)
      {
         cerr
            << "Error in LoadFileList: lstat failed for file " << EntPtr->d_name << endl
            << "errno = " << errno << "  Error description: " << strerror(errno) << endl
            << "Continuing to next file."                                        << endl;
         continue;
      }

      // Now, what kind of entities is user looking for? This will be indicated by parameter
      // "EntityCode".
      switch (EntityCode)
      {
         // If Entity Code is 1 (regular files only), continue if not regular file:
         case 1:
            BLAT("DirCode is 1.")
            if (DT_REG != EntPtr->d_type)
            {
               BLAT("Continuing because current object is not a regular file.")
               continue;
            }
            BLAT("Staying because current object is a regular file.")
            break;

         // If Entity Code is 2 (directories only), continue if not directory:
         case 2:
            BLAT("DirCode is 2.")
            if (DT_DIR != EntPtr->d_type)
            {
               BLAT("Continuing because d_type is not directory.")
               continue;
            }
            BLAT("Staying because d_type is directory.")
            break;

         // If Entity Code is 3 (all file system objects), or anything else, stay:
         case 3:
         default:
            BLAT("DirCode is neither 1 nor 2. Staying in while loop.")
            break;
      }

      // Continue to next file if current object is "." (current directory) or ".." (parent directory):
      if ("."  == std::string(EntPtr->d_name)) continue;
      if (".." == std::string(EntPtr->d_name)) continue;

      // Continue if this file does not match wildcard:
      // ECHIDNA : I need to find a way to implement this which works with file names in Japanese,
      // Vietnamese, Bengali. Function fnmatch() doesn't work for those. (ASCII only?)
      if (0 != fnmatch(Wild.c_str(), EntPtr->d_name, 0))
      {
         BLAT("Continuing because file " << EntPtr->d_name << " doesn't match wildcard " << Wild)
         continue;
      }

      // Finally, continue if current object is nonexistant or inaccessible:
      if (!FileExists(EntPtr->d_name))
      {
         BLAT("Continuing because file " << EntPtr->d_name << " is nonexistant or inaccessible.")
         continue;
      }

      // If we get to here, we've ruled-out any reasons *not* to include the current file in our list of
      // files, so let's construct a FileRecord for it and push it onto the right end of our container.

      // Construct a FileRecord object:
      BLAT("About to construct a file record object.")
      FileRecord FR (Dir, EntPtr, FileStats);

      // Convert records to appropriate type and push them onto the end of the container:
      C.push_back(FR);

      BLAT("At bottom of LoadFileList() for loop. Pushed file onto end of container.")
   }
   BLAT("About to return from LoadFileList().  Size of list = " << C.size())
   return C;
}


// Load sizes and file record of all files in current directory into
// a multimap of file records keyed by size:
typedef std::multimap<size_t, rhdir::FileRecord> Flubber;
Flubber & LoadFileMap
   (
      Flubber           & M,
      const std::string & Wildcard = "*", // Default is "all names"
      int                 ClrCode  = 1    // 1 => Clear list (default), 2 => append
   );
// (Defined in rhdir.cpp .)


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// inline size_t CountLinesInFile (const rhdir::FileRecord&)                  //
// (Overloaded inline version taking a FileRecord instead of a string.)       //
// Given a rhdir::FileRecord, returns the number of lines in the file.        //
// Warning: this in intended for use with text files.  Use with other         //
// types of files may yield unpredictable results.                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

size_t CountLinesInFile(const rhdir::FileRecord& file_record);


//============================================================================================================
// Section 7:
// File-to-Container and Container-to-File functions:
//============================================================================================================


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  LoadFileToContainer()                                                                //
//  Reads all lines of text from a file and stores them in a container of strings.       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

template<class ContainerType>
size_t
LoadFileToContainer
   (
      std::string    const &  Filename,
      ContainerType        &  Container
   )
{
   typename ContainerType::iterator i;
   size_t Count = 0;
   std::string LineOfText;

   // Empty the container:
   Container.clear();

   std::ifstream IFS (Filename.c_str(), std::ios_base::in); // Open file in INPUT mode.
   if ( not (IFS) )
   {
      rhdir::FileIOException up;
      up.msg = "Exception in rhdir::LoadFileToList():  unable to attach ifstream to file "
               + Filename;
      throw up;
   }
   while (42)
   {
     getline(IFS, LineOfText);
     if (StreamIsBad(IFS))
     {
        rhdir::FileIOException up;
        up.msg = "Exception in rhdir::LoadFileToList(): ifstream went bad while reading file "
                 + Filename;
        throw up;
     }
     if (IFS.eof()) {break;}
     Container.push_back(LineOfText);
     ++Count;
   }
   IFS.close();
   return Count;
}


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  SaveContainerToFile()                                                                //
//  Writes all lines of text from a container of strings to a file.                      //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

template<class ContainerType>
size_t
SaveContainerToFile
   (
      ContainerType  const  &  Container,
      std::string    const  &  Filename
   )
{
   typename ContainerType::const_iterator i;
   size_t Count = 0;

   std::ofstream OFS (Filename.c_str(), std::ios_base::out); // Open file in OUTPUT mode.
   if (!OFS)
   {
      FileIOException up;
      up.msg = std::string("Exception in rhdir::SaveListToFile(): "
                           "unable to attach std::ofstream to file ")
               + Filename;
      throw up;
   }
   for (i = Container.begin(); i != Container.end(); ++i)
   {
      OFS  << (*i) << std::endl;
      if (StreamIsBad(OFS))
      {
         FileIOException up;
         up.msg = std::string("Exception in rhdir::SaveListToFile(): "
                              "std::ofstream went bad while writing to file ")
                  + Filename;
         throw up;
      }
      ++Count;
   }
   OFS.close();
   return Count;
}


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  AppendFileToContainer()                                                              //
//  Reads all lines of text from a file and appends them to a container of strings.      //
//  (Note: this function is the same as LoadFileToContainer(), except that the container //
//  is not cleared.)                                                                     //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

template<class ContainerType>
size_t
AppendFileToContainer
   (
      std::string    const &  Filename,
      ContainerType        &  Container
   )
{
   typename ContainerType::iterator i;
   size_t Count = 0;
   std::string LineOfText;

   // Do NOT clear the container!

   std::ifstream IFS (Filename.c_str(), std::ios_base::in); // Open file in INPUT mode.
   if ( not (IFS) )
   {
      rhdir::FileIOException up;
      up.msg = "Exception in rhdir::AppendFileToContainer():  unable to attach ifstream to file "
               + Filename;
      throw up;
   }
   if ( not ( IFS.good() ) )
   {
      rhdir::FileIOException up;
      up.msg = "Exception in rhdir::AppendFileToContainer():  ifstream not good before reading file "
               + Filename;
      throw up;
   }

   while (42)
   {
     getline(IFS, LineOfText);
     if (StreamIsBad(IFS))
     {
        rhdir::FileIOException up;
        up.msg = "Exception in rhdir::AppendFileToContainer(): ifstream went bad while reading file "
                 + Filename;
        throw up;
     }
     if (IFS.eof()) {break;}
     Container.push_back(LineOfText);
     ++Count;
   }
   IFS.close();
   return Count;
} // end AppendFileToContainer()



///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  AppendFileToListFunctor()()                                                          //
//  Functor which reads all lines of text from the file named by the argment of its      //
//  application operator and appends them to the std::list<std::string> named by the     //
//  argument of its constructor.                                                         //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

class AppendFileToListFunctor : public std::unary_function<std::string, void>
{
   public:
      AppendFileToListFunctor(std::list<std::string> & Container)
      : applications (0) , ContainerRef_ (Container)
      {
         ++ref_count;
         instance = ref_count;
         BLAT("     ")
         BLAT("In AppendFileToListFunctor()() main constructor.")
         BLAT("ref_count    = " << ref_count)
         BLAT("instance     = " << instance)
         BLAT("applications = " << applications)
      }
      AppendFileToListFunctor (AppendFileToListFunctor const & Orig)
      : applications (Orig.applications) , ContainerRef_ (Orig.ContainerRef_)
      {
         ++ref_count;
         instance = ref_count;
         BLAT("     ")
         BLAT("In AppendFileToListFunctor()() copy constructor.")
         BLAT("ref_count    = " << ref_count)
         BLAT("instance     = " << instance)
         BLAT("applications = " << applications)
      }
      ~AppendFileToListFunctor(void)
      {
         BLAT("     ")
         BLAT("In AppendFileToListFunctor()() destructor.")
         BLAT("ref_count    = " << ref_count)
         BLAT("instance     = " << instance)
         BLAT("applications = " << applications)
      }
      void operator()(std::string const & FileName)
      {
         AppendFileToContainer(FileName, ContainerRef_);
         ++applications;
         BLAT("     ")
         BLAT("In AppendFileToListFunctor()() application operator.")
         BLAT("ref_count    = " << ref_count)
         BLAT("instance     = " << instance)
         BLAT("applications = " << applications)
      }
      static int ref_count;
      int instance;
      int applications;
   private:
      std::list<std::string> & ContainerRef_;
};


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  AppendContainerToFile()                                                              //
//  Writes all lines of text from a container of strings to a file.                      //
//  (Note that this function is the same as SaveContainerToFile(), except that the file  //
//  is not cleared.)                                                                     //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

template<class ContainerType>
size_t
AppendContainerToFile
   (
      ContainerType  const  &  Container,
      std::string    const  &  Filename
   )
{
   typename ContainerType::const_iterator i;
   size_t Count = 0;
   std::ofstream OFS (Filename.c_str(), std::ios_base::app); // Open file in APPEND mode.
   if (!OFS)
   {
      FileIOException up;
      up.msg = std::string("Exception in rhdir::SaveListToFile(): "
                           "unable to attach std::ofstream to file ")
               + Filename;
      throw up;
   }
   if (StreamIsBad(OFS))
   {
      FileIOException up;
      up.msg = std::string("Exception in rhdir::SaveListToFile(): "
                           "std::ofstream not good before writing to file ")
               + Filename;
      throw up;
   }
   for (i = Container.begin(); i != Container.end(); ++i)
   {
      OFS  << (*i) << std::endl;
      if (StreamIsBad(OFS))
      {
         FileIOException up;
         up.msg = std::string("Exception in rhdir::SaveListToFile(): "
                              "std::ofstream went bad while writing to file ")
                  + Filename;
         throw up;
      }
      ++Count;
   }
   OFS.close();
   return Count;
}



//============================================================================================================
// Section 8:
// Recursion-related functions:
//============================================================================================================


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
// void RecursionDecider (int ArgC, char *ArgV[], void Function(void))                   //
//                                                                                       //
// Decides whether to recurse a directory tree.                                          //
//                                                                                       //
// Notes:  I may eventually templatize this function as I did CursDirs,but for now, it's //
// still a regular function.  The purpose of this function is to look at ArgC and ArgV   //
// and see if "-r" or "--recurse" are present; if they are, recurse; otherwise, run the  //
// function "Function" for the current directory only.                                   //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

void
RecursionDecider
   (
      int ArgC,
      char* ArgV[],
      void Function(void)
   );
// (Defined in rhdir.cpp .)


/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//  CursDirs()                                                                         //
//                                                                                     //
//  Recursively navigate directory tree, beginning with current directory, applying a  //
//  given function or functor to each node of the tree, and returning the total number //
//  of directories processed:                                                          //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////

template<class F>
unsigned long int
CursDirs
   (
      F Func
   )
{
   using std::cout;
   using std::cerr;
   using std::endl;

   // Automatic (reentrant) variables, on stack, initialized on each entry and released on each return:

   bool ErrorFlag;
   std::string DirLine;
   std::string FileName;
   std::string RootName;
   std::list<rhdir::FileRecord> DirList;
   std::list<rhdir::FileRecord>::iterator i;

   // Static (non-reentrant) variables, initialized the first time the function executes ONLY:
   static  unsigned long int   DirCount    = 0;
   static                int   Recursion   = 0;

   // Increment recursion level:
   ++Recursion;

   BLAT("\nNear top of CursDirs.  Declared variables, incremented Recursion, and got CWD.")
   BLAT("CWD        = " << GetCwd())
   BLAT("Recursion  = " << Recursion)
   BLAT("DirCount   = " << DirCount << "\n")

   // Announce current directory:
   // BLAT RH 2004-11-20: No, on second though, don't; it screws things up if cursdirs is called
   // by a function that is used in a printout.
   // cout
   //    << endl
   //    << endl
   //    << "Processing directory #" << DirCount << ": " << GetCwd() << endl;

   BLAT("In CursDirs.  About to call LoadFileList() to get list of subdirectories.")

   // Get list of subdirectories of current directory:
   LoadFileList(DirList, "*", 2);

   // If directory list is not empty, call CursDirs() for each directory in the list:
   if ( 0 != DirList.size() )
   {
      for (i=DirList.begin(); i!=DirList.end(); ++i)
      {
         // If (*i) is a "forbidden" directory, bypass it:
         if
         (
               NCS_Equal(i->name, "Documents and Settings")
            || NCS_Equal(i->name, "Program Files")
            || NCS_Equal(i->name, "RECYCLED")
            || NCS_Equal(i->name, "RECYCLER")
            || NCS_Equal(i->name, "System Volume Information")
            || NCS_Equal(i->name, "WINNT")
         )
         {
            BLAT("In CursDirs.  Bypassing forbidden directory " << i->name)
            continue;
         }

         BLAT("In CursDirs.  About to attempt to CD to subdirectory " << i->name)

         // Attempt to change current directory to next name on list:
         ErrorFlag = chdir(i->name.c_str());

         // If not succesful, print error message and bail:
         if (ErrorFlag)
         {
            cerr
               << "Fatal Error in CursDirs()!  Cannot descend directory tree!" << endl
               << "Now exiting application." << endl;
            exit(666);
         }

         BLAT("\nIn CursDirs.  ======= ABOUT TO RECURSE!!! =======")
         BLAT("CWD        = " << GetCwd())
         BLAT("Recursion  = " << Recursion)
         BLAT("DirCount   = " << DirCount << "\n")

         // Recurse:
         CursDirs(Func);

         BLAT("\nIn CursDirs.  ======= JUST RETURNED FROM RECURSION =======")
         BLAT("CWD        = " << GetCwd())
         BLAT("Recursion  = " << Recursion)
         BLAT("DirCount   = " << DirCount)
         BLAT("About to attempt to pop back up to next higher directory level." << "\n")

         // Attempt to return to original dirctory:
         ErrorFlag = chdir("..");

         // If not succesful, print error message and bail:
         if (ErrorFlag)
         {
            cerr
               << "Fatal Error in CursDirs()!  Cannot ascend directory tree!" << endl
               << "Now exiting application." << endl;
            exit(666);
         }

         BLAT("\nIn CursDirs, bottom of for loop, just popped up one level.")
         BLAT("CWD        = " << GetCwd())
         BLAT("Recursion  = " << Recursion)
         BLAT("DirCount   = " << DirCount << "\n")

      } // End for (each subdirectory of current directory).
   } // End if (current directory has one or more subdirectories).

   BLAT("In CursDirs.  About to call Func() (the function to be recursed).")

   // Execute Func() (which probably does something to some or all of the contents of
   // the current directory, which is why I put it here; that way, if it renames the
   // subdirectories, we don't get screwed):
   Func();

   // Increment directory counter here, to indicate that Func() was called for
   // this directory:
   ++DirCount;

   // Decrement recursion level here, to indicate we're about to pop up one recursive level:
   --Recursion;

   BLAT("\nIn CursDirs.  Just called Func(), incremented DirCount, and decremented Recursion.")
   BLAT("About to return.")
   BLAT("CWD        = " << GetCwd())
   BLAT("Recursion  = " << Recursion)
   BLAT("DirCount   = " << DirCount << "\n")
   if (0 == Recursion) {BLAT("FINAL EXIT from CursDirs.")}

   // Return to next-higher recursive level, or to calling function if Recursion is now 0:
   return DirCount;
} // end CursDirs()

} // End namespace rhdir

// End include guard:
#endif
