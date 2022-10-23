

// This is a 110-character-wide utf8-encoded C++ library source file.
/************************************************************************************************************\
 * File Name:            rhdir.cpp
 * Source For:           rhdir.o (see file "rhdir.hpp" for header)
 * Module Name:          Directory and File Utilities
 * Author:               Robbie Hatley
 * To use in program:    #include "rhdir.hpp" and Link program with module rhdir.o in library librh.a .
 * Edit history:         See bottom of this file.
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

// GNU headers:
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fnmatch.h>

#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#include "rhdir.hpp"

using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using std::setfill;
using std::setw;

namespace rhdir
{

/*
 * The following sections mirror the sections of namespace rhdir declared in header file "rhdir.hpp". 
 * The commented-out parts are defined in "rhdir.hpp" because they are defined constants, inline functions, 
 * templates, functors, etc. Such things need to be in header files instead of source files, because the 
 * compiler needs to see their definitions.  (In the case of templates, the compiler can't link to a function 
 * with unknown types of arguments and/or return value. In the case of inline functions, the whole idea of 
 * inlining is to paste the source code, and linking to the machine-language version can't do that.  In the 
 * case of functors, they're types, not objects, and hence can't be linked-to.)
 */


//============================================================================================================
// Section 1                                                                                         Section 1
// Constants used by module "rhdir":
//============================================================================================================


//const unsigned short int  FA_RDONLY  =  1;
//const unsigned short int  FA_HIDDEN  =  2;
//const unsigned short int  FA_SYSTEM  =  4;
//const unsigned short int  FA_LABEL   =  8;
//const unsigned short int  FA_DIREC   = 16;
//const unsigned short int  FA_ARCH    = 32;

// (These are defined in file "rhdir.hpp".)


//============================================================================================================
// Section 2                                                                                         Section 2
// Exception Classes:
//============================================================================================================


// struct FileSystemException {};
//
// struct FileIOException : public FileSystemException // : public std::runtime_error
// {
//    FileIOException     (    void     ) : msg("") {} // , runtime_error("") {}
//    FileIOException     (std::string S) : msg(S ) {} // , runtime_error(S ) {}
//    ~FileIOException() throw() {}
//    std::string msg;
// };


// struct DirNavException : public FileSystemException // : public std::runtime_error
// {
//    DirNavException     (    void     ) : msg("") {} // , runtime_error("") {}
//    DirNavException     (std::string S) : msg(S ) {} // , runtime_error(S ) {}
//    ~DirNavException() throw() {}
//    std::string msg;
// };


//============================================================================================================
// Section 3                                                                                         Section 3
// Private functions for use by functions in namespace rhdir:
//============================================================================================================


// Convert string to all-lower-case:
std::string
StringToLower
   (
      std::string const & InputString
   )
{
   std::string OutputString;
   std::string::const_iterator i;
   for (i = InputString.begin(); i != InputString.end(); ++i)
   {
      OutputString.push_back(static_cast<char>(tolower(*i)));
   }
   return OutputString;
}


// Determine whether two std::strings are non-case-sensitively "equal":
bool
NCS_Equal
   (
      std::string const & Bob,
      std::string const & Fred
   )
{
   return StringToLower(Bob) == StringToLower(Fred);
}


// Return a copy of a source std::string with any leading and/or trailing spaces stripped from it:
std::string
//rhdir::
StripLeadingAndTrailingSpaces
   (
      std::string const & Input
   )
{
   std::string Output = Input;
   while (' ' == Output[0])
   {
      Output.erase(0, 1);
   }
   while (' ' == Output[Output.size()-1])
   {
      Output.erase(Output.size()-1, 1);
   }
   return Output;
}


// Get random double:
double RandNum(double min, double max)
{
   return min + (max - min) * (static_cast<double>(rand()) / static_cast<double>(RAND_MAX));
}


// Get random int:
int RandInt(int min, int max)
{
   return static_cast<int>(RandNum(min + 0.001, max + 0.999)); // min, max: int->double promotion
}



//============================================================================================================
// Section 4                                                                                         Section 4
// General file and directory utility functions:
//============================================================================================================


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// 4.01                                                                                                     //
// GetCwd()                                                                                                 //
// Returns full path of current working directory.                                                          //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

std::string 
GetCwd(void)
{
   int            Size     = 512;
   char         * BufPtr   = NULL;
   std::string    Path     = "";

   while (Size < 10000)
   {
      BufPtr = static_cast<char*>(malloc(Size));
      if (NULL == BufPtr)
      {
         cerr
            << "Error in rhdir::GetCwd: malloc returned NULL. Either you are out of memory," << endl
            << "or your operating system has crashed. Consider restarting your system."      << endl
            << "About to exit program with code 666, because something evil just happened."  << endl
            << "errno = " << errno << ".  Error description: " << strerror(errno)            << endl;
         exit(666);
      }
      if (getcwd(BufPtr, Size) == BufPtr)
      {
         Path = std::string(BufPtr);
         free(BufPtr);
         return Path;
      }
      if (ERANGE != errno)
      {
         cerr
            << "Error in rhdir::GetFullCwd: getcwd() from header unistd.h returned a NULL"  << endl
            << "pointer. This might mean that your operating system denied this"            << endl
            << "program the write to read this directory, in which case consider changing"  << endl
            << "permissions on your directories. About to exit program with code 666."      << endl
            << "errno = " << errno << ".  Error description: " << strerror(errno)           << endl;
         exit(666);
      }
      free (BufPtr);
      Size *= 2;
   } // end while (Size < 10000)
   cerr
      << "Error in rhdir::GetFullCwd: getcwd() from header unistd.h returned a NULL"  << endl
      << "pointer. This might mean that your current working directory has a"         << endl
      << "path length over 8191 characters long, in which case consider shortening"   << endl
      << "your paths. About to exit program with code 666."                           << endl
      << "errno = " << errno << ".  Error description: " << strerror(errno)           << endl;
   exit(666);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// 4.02                                                                                                     //
// FileExists()                                                                                             //
// Returns true if and only if an object of the given name exists and can be accessed by unistd.h's         //
// access() function.                                                                                       //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool FileExists (std::string FileName)
{
   bool bExist = (0 == access(FileName.c_str(), F_OK));
   if (bExist)
   {
      return true;
   }
   else
   {
      BLAT( "FileExists() says file " << FileName << " does not exist." )
      BLAT( "errno = " << errno << ". strerror = " << strerror(errno)   )
      return false;
   }
}


////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
// 4.03                                                                                   //
// bool rhdir::FilesAreIdentical (const std::string& File1, const std::string& File2)     //
//                                                                                        //
// Compares two files and returns true if identical, false if different.                  //
// This should work if File1 and File2 are either *names* of existing files in the        //
// current working directory, or are *paths* to files existing elsewhere.                 //
// Throws FileIOException if file IO error occurs.                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////

bool
//rhdir::
FilesAreIdentical
   (
      const std::string& File1,
      const std::string& File2
   )
{
   char F1Byte, F2Byte;
   std::ifstream F1 (File1.c_str(), std::ios_base::binary);
   std::ifstream F2 (File2.c_str(), std::ios_base::binary);

   if (!F1)
   {
      rhdir::FileIOException up;
      up.msg  = "File IO error in FilesAreIdentical; can't open " + File1 +".";
      throw up;
   }
   if (!F2)
   {
      rhdir::FileIOException up;
      up.msg  = "File IO error in FilesAreIdentical; can't open " + File2 +".";
      throw up;
   }

   while (42)
   {
      F1.get(F1Byte);
      F2.get(F2Byte);
      if (StreamIsBad(F1))
      {
         rhdir::FileIOException up;
         up.msg  = "File IO error in FilesAreIdentical while reading " + File1 +".";
         throw up;
      }
      if (StreamIsBad(F2))
      {
         rhdir::FileIOException up;
         up.msg  = "File IO error in FilesAreIdentical while reading " + File2 +".";
         throw up;
      }
      if (F1.eof() xor F2.eof()) // If files are inequal in size,
      {
         F1.close();             // close first file,
         F2.close();             // close second file,
         return false;           // and return false (files are NOT identical).
      }
      if (F1.eof() and F2.eof()) // If both files reached end simultaneously,
      {
         break;                  // break out of while loop.
      }
      if (F1Byte != F2Byte)      // If current bytes of files are inequal,
      {
         F1.close();             // close first file,
         F2.close();             // close second file,
         return false;           // and return false (files are NOT identical).
      }
   }

   // If we get to here, the two files reached their ends simultaneously without us discovering
   // even one iota of difference between them.  Therefore, they are identical.  Close both files
   // and return true:
   F1.close();
   F2.close();
   return true;

} // End FilesAreIdentical()


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// 4.04                                                                                                     //
// GoToDir()                                                                                                //
// Attempts to change current directory to given target.  Returns an error code which is                    //
// false if attempt suceeded or true if attempt failed.  If attempt failed, prints                          //
// detailed error message indicating original, target, and final directories.                               //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool 
GoToDir (const std::string& TargetDir)
{
   bool ErrorFlag;
   std::string OriginalDir;
   std::string ActualDir;

   // Record original path:
   OriginalDir = GetCwd();

   // Attempt to chdir to target directory:
   ErrorFlag = (0 != chdir(TargetDir.c_str()));

   // Where did we end up?
   ActualDir = GetCwd();

   if (ErrorFlag)
   {
      cerr
         << endl
         << endl
         << "Error in GoToDir():  unable to change to specified directory." << endl
         << "Original (absolute)          directory = " << OriginalDir << endl
         << "Target   (possibly-relative) directory = " << TargetDir   << endl
         << "Actual   current absolute    directory = " << ActualDir   << endl;
   }
   return ErrorFlag;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                       //
//  4.05                                                                                                 //
//  FileNameIsWindowsInvalid()                                                                           //
//                                                                                                       //
//  Returns true if FileName is invalid; otherwise returns false.                                        //
//  For the purposes of this function, "invalid" means that one or more of the following is true:        //
//  1. File name is more than 256 characters long                                                        //
//  2. First character of FileName is a space                                                            //
//  3. Last  character of FileName is a space                                                            //
//  4. Last  character of FileName is a dot                                                              //
//  5. File name contains one or more reserved characters:  \/:*?"<>|                                    //
//  6. File name contains one or more ASCII control characters: (0-31, 127)                              //
//  7. File name contains one or more non-ASCII characters (128-255)                                     //
//                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////

bool
FileNameIsWindowsInvalid
   (
      std::string         const & FileName,
      std::ostringstream        & ErrMsg
   )
{
   // 1. If file name is longer than 256 characters, it's invalid:
   if (FileName.size() > 256)
   {
      ErrMsg
         << "Error message from FileNameIsInvalid(): The"                      << endl
         << "file name \"" << FileName << "\" is longer than 200 characters."  << endl;
      return true;
   }

   // 2. If first character of file name is a space, it's invalid:
   if (' ' == FileName[0])
   {
      ErrMsg
         << "Error message from FileNameIsInvalid(): The first character of"   << endl
         << "file name \"" << FileName << "\" is a space."                     << endl;
      return true;
   }

   // 3. If last  character of file name is a space, it's invalid:
   if (' ' == FileName[FileName.size()-1])
   {
      ErrMsg
         << "Error message from FileNameIsInvalid(): The last character of"    << endl
         << "file name \"" << FileName << "\" is a space."                     << endl;
      return true;
   }

   // 4. If last  character of file name is a  dot,  it's invalid:
   if ('.' == FileName[FileName.size()-1])
   {
      ErrMsg
         << "Error message from FileNameIsInvalid(): The last character of"    << endl
         << "file name \"" << FileName << "\" is a dot."                       << endl;
      return true;
   }

   // 5. Disallow characters invalid in Windows LFNs:
   std::string Poison ("<>:\"/\\|?*");

   // 6. Disallow ASCII characters 0-31:
   for(int i = 0; i < 32; ++i) Poison += char(i); // Disallow ASCII 0-31

   // If file name contains any "poisonous" characters, it's invalid:
   std::string::size_type Pos = 0;
   unsigned int Code = 0;
   if (std::string::npos != (Pos = FileName.find_first_of(Poison)))
   {
      Code = static_cast<unsigned int>(static_cast<unsigned char>(FileName[Pos]));
      ErrMsg
         << "Error message from FileNameIsInvalid(): Character " << Pos << " of file name \""
         << FileName << "\" is invalid character code " << Code << endl;
      return true;
   }

   // If we get to here, file name is not invalid, so return false:
   return false;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  4.06                                                                                                    //
//  void rhdir::RenameFile(const std::string& OldFileName, const std::string& NewFileName)                  //
//                                                                                                          //
//  Renames a file in the current directory from one name to another (still within the current directory),  //
//  while taking some safety precautions.                                                                   //
//                                                                                                          //
//  If file rename fails, this function prints to cerr a detailed explanation of why rename failed.         //
//                                                                                                          //
//  This function returns true if file rename was successful, false if file rename failed.  (But this       //
//  function may not return at all if a file rename fails in a severe, low-level way; see next paragraph.)  //
//                                                                                                          //
//  This function calls stdio.h's "rename()" function to do the actual renaming of the file. If rename()    //
//  returns a non-zero code (indicating an extreme, low-level error), this function alerts the user to the  //
//  extreme error with a GLARING ALL-CAPITAL-LETTERS ERROR MESSAGE, presents an English interpretation of   //
//  rename()'s error code, then calls abort() to prevent further destruction of files.                      //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool
//rhdir::
RenameFile
   (
      const std::string& OldFileName,
      const std::string& NewFileName
   )
{

   // Before daring to attempt to rename the file, first check for the presence of these error conditions:

   // First of all, the file or directory must exist before we can rename it!!!
   if (!FileExists(OldFileName))
   {
      cerr
        << "Error in RenameFile(): cannot rename file from \n   \""
        << OldFileName << "\"\nto\n   \"" << NewFileName
        << "\"\nbecause no file exists with old file name."
        << endl;
      return false;
   }

   // Secondly, the name we want to rename it to must be valid:
   std::ostringstream ErrMsg ("");
   if (FileNameIsWindowsInvalid(NewFileName, ErrMsg))
   {
      cerr
         << "Error in RenameFile(): cannot rename file from"          << endl
         << "   \"" << OldFileName << "\""                            << endl
         << "to"                                                      << endl
         << "   \"" << NewFileName << "\""                            << endl
         << "because new file name is invalid."                       << endl
         << "FileNameIsWindowsInvalid() returned error message:"      << endl
         << ErrMsg.str()                                              << endl;
         
      return false;
   }

   // Thirdly, there is no sense trying to rename a file back to the name it already has!
   // In fact, trying to do this might cause data loss.  So forbid this:
   if (NewFileName == OldFileName)
   {
      cerr
         << "Error in RenameFile(): new file name same as old: \n"
         << "Old file name:  \"" << OldFileName << "\".\n"
         << "New file name:  \"" << NewFileName << "\"."
         << endl;
      return false;
   }

   // If we get to here, we have ascertained the following:
   //    The original file exists
   //    The new file name is valid
   //    The old and new file names are not equal.
   //    OldName and NewName do not refer to the same file.

   // Is this proposed rename just a case adjustment?  (I.e., "AsDf.txt" to "aSdF.txt"?)
   bool CaseAdj = rhdir::NCS_Equal(NewFileName, OldFileName) && NewFileName != OldFileName;

   // Unless we're trying to adjust case, make sure no file exists with a name which is NCS_Equal to
   // the new file name:
   if (!CaseAdj && FileExists(NewFileName.c_str()))
   {
      cerr
         << "Error in RenameFile(): cannot rename file from \n   \""
         << OldFileName << "\"\nto\n   \"" << NewFileName
         << "\"\nbecause a file already exists with the new file name."
         << endl;
      return false;
   }

   // Attempt to rename the file using rename(). 
   int ReturnValue = rename(OldFileName.c_str(), NewFileName.c_str());
   
   // If rename() returned 0, the file-rename succeeded, so return true:
   if (0 == ReturnValue) {return true;}

   // Otherwise, an error has occurred. In that case, alert the user, and either abort the application 
   // or continue, depending on whether the error was likely to have caused data loss:
   cerr
      << "An error has occurred in rename(), called from RenameFile()."    << endl
      << "OldFileName = " << OldFileName                                   << endl
      << "NewFileName = " << NewFileName                                   << endl
      << "errno = " << errno << "  Error description: " << strerror(errno) << endl;

   /*
   File renaming errors which may occur during rename attempt include:

   ENAMETOOLONG
      This error is used when either the total length of a file name is greater than
      PATH_MAX, or when an individual file name component has a length greater than
      NAME_MAX. On GNU/Hurd systems, there is no imposed limit on overall file name length,
      but some file systems may place limits on the length of a component.

   ENOENT 
      This error is reported when a file referenced as a directory component in the
      file name doesn't exist, or when a component is a symbolic link whose target
      file does not exist.

   ENOTDIR
      A file that is referenced as a directory component in the file name exists, but
      it isn't a directory.

   ELOOP
      Too many symbolic links were resolved while trying to look up the file name.
      The system has an arbitrary limit on the number of symbolic links that may
      be resolved in looking up a single file name, as a primitive way to detect loops.

   EACCES
      One of the directories containing newname or oldname refuses write permission;
      or newname and oldname are directories and write permission is refused for one of them.

   EBUSY
      A directory named by oldname or newname is being used by the system in
      a way that prevents the renaming from working. This includes directories
      that are mount points for filesystems, and directories that are the current
      working directories of processes.

   ENOTEMPTY or EEXIST
      The directory newname isn't empty. GNU/Linux and GNU/Hurd systems
      always return ENOTEMPTY for this, but some other systems return EEXIST.

   EINVAL
      oldname is a directory that contains newname.

   EISDIR
      newname is a directory but the oldname isn't.

   EMLINK
      The parent directory of newname would have too many links (entries).

   ENOENT
      This error is reported when a file referenced as a directory component in the
      file name doesn't exist, or when a component is a symbolic link whose target
      file does not exist.

   ENOSPC
      The directory that would contain newname has no room for another entry,
      and there is no space left in the file system to expand it.

   EROFS
      The operation would involve writing to a directory on a read-only file
      system.

   EXDEV 
      The two file names newname and oldname are on different file systems.

   */

   // Continue if the error is such that probably no data loss occurred:
   if
      (
         ENAMETOOLONG  == errno ||  // trying to rename to a too-long name
         ENOSPC        == errno ||  // out of file-system space
         EACCES        == errno     // access permission denied for OldName
      )
   {
      cerr
         << "Data loss has probably not occurred."  << endl
         << "Continuing with application."          << endl;
      return false;
   }

   // Otherwise, abort the calling application:
   else
   {
      cerr
         << "DANGEROUS ERROR DETECTED."       << endl
         << "ABORTING APPLICATION."           << endl;
      abort();
   }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  4.07                                                                                                    //
//  UnTilde()                                                                                               //
//                                                                                                          //
//  Replaces '~' with '_' in all file names in current directory, to prevent                                //
//  Windows long file names from interfering with automatically-generated                                   //
//  DOS 8x3 file names.  It is very important to run this program before                                    //
//  running any file-deduping, file-renaming, or file-archiving programs!                                   //
//  Otherwise, if any file names contain '~', data loss can occur.                                          //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

void
//rhdir::
UnTilde
   (
      void
   )
{
   std::string OldName, NewName;
   std::string::size_type Tilde;
   std::list<rhdir::FileRecord> FileList;
   std::list<rhdir::FileRecord>::iterator i;

   LoadFileList(FileList);

   for (i=FileList.begin(); i != FileList.end(); ++i)
   {
      OldName = i->name;
      NewName = OldName;
      while (std::string::npos != (Tilde = NewName.find('~')))
      {
         NewName.replace(Tilde, 1, 1, '_');
      }

      if (NewName != OldName)
      {
         RenameFile(OldName, NewName);
         // Note: if rename fails, ignore error and continue with next file.
      }
   } // end for (each file)

   return;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  4.08                                                                                                    //
//  unsigned long int CountLinesInFile (const std::string&)                                                 //
//                                                                                                          //
//  Given a file-name std::string, returns the number of lines in the file.                                 //
//                                                                                                          //
//  Warning: this function is intended for use with text files.  Use with other types of files may yield    //
//  unpredictable results, because this function uses getline(), which uses '\n' as line terminator,        //
//  whereas binary files don't have "lines" or "line terminators", and any presence of a '\n' byte will be  //
//  purely coincidental. '\n' may occur "not once in the entire file", or "nearly every byte", so the       //
//  "number of lines" could be as few as 1, or nearly as many as the number of bytes in the file.           //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
unsigned long int
//rhdir::
CountLinesInFile
   (
      const std::string& file_name
   )
{
   unsigned long int Lines = 0;

   std::string Line;

   // Try to open file:
   std::ifstream SourceFile (file_name.c_str());

   // If attempt failed, throw exception:
   if (not SourceFile.is_open() or StreamIsBad(SourceFile))

   {
      FileIOException Up;
      Up.msg = "Error: Can't open file " + file_name + "\n";
      throw Up;
   }

   // If we get to here, we have an open stream in good standing, so let's count lines:
   while (42) // ... loop until pigs fly or politicians stop lying ...
   {
      // Attempt to get a line of text:
      getline(SourceFile, Line);

      // If attempt crashed, throw exception:
      if (StreamIsBad(SourceFile))
      {
         FileIOException Up;
         Up.msg = "IO error reading file " + file_name + "\n";
         throw Up;
      }

      // If attempt failed purely because there is no more text to read, break:
      if (SourceFile.eof())
      {
         break;
      }

      // Otherwise, increment line counter and continue looping:
      ++Lines;
   }

   return Lines;
}


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  std::string GetPrefix (std::string const & Name);                                    //
//                                                                                       //
//  Returns the prefix of the given file name.  (Here "prefix" means that part of a file //
//  name to the left of the right-most dot, or the entire file name if there is no dot.) //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

std::string
//rhdir::
GetPrefix
   (
      std::string const & Name
   )
{
   // Declare a variable to hold the index of the right-most dot (if any):
   std::string::size_type DotIdx = 0;

   // Set DotIdx equal to the index of the right-most dot, or equal to
   // std::string::npos if there is no dot:
   DotIdx = Name.rfind('.');

   // If there's no dot, return the whole name:
   if (std::string::npos == DotIdx)
   {
      return Name;
   }
   // Else if the 0th character is a dot, return whole name:
   else if (0 == DotIdx)
   {
      return Name;
   }
   // Else return that portion of the name which is to the left of 
   // the right-most dot:
   else
   {
      return Name.substr(0, DotIdx);
   }
}


/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  std::string GetSuffix (std::string const & Name);                                      //
//                                                                                         //
//  Returns the suffix of the given file name.  (Here "suffix" means that part of a file   //
//  name to the right of the right-most dot, or an empty std::string if there is no dot.)  //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

std::string
//rhdir::
GetSuffix
   (
      std::string const & Name
   )
{
   // Declare a variable to hold the index of the right-most dot (if any):
   std::string::size_type DotIdx = 0;

   // Set DotIdx equal to the index of the right-most dot, or equal to
   // std::string::npos if there is no dot:
   DotIdx = Name.rfind('.');

   // If there's no dot, return an empty std::string:
   if (std::string::npos == DotIdx)
   {
      return std::string("");
   }
   // Else if the 0th character is a dot, return empty string:
   else if (0 == DotIdx)
   {
      return std::string("");
   }
   // Else return that portion of the name from the right-most dot rightward:
   else
   {
      return Name.substr(DotIdx, std::string::npos);
   }
}



//////////////////////////////////////////////////////////////////
//                                                              //
//  SetPrefix()                                                 //
//                                                              //
//  Renames a file, giving it a new prefix but retaining the    //
//  original suffix, while taking some safety precautions.      //
//  Return value indicates whether file rename was successful.  //
//                                                              //
//////////////////////////////////////////////////////////////////

bool
SetPrefix
   (
      std::string const & OldFileName,
      std::string const & NewPrefix
   )
{
   std::string  OldPrefix = GetPrefix(OldFileName);
   std::string  OldSuffix = GetSuffix(OldFileName);
   std::string  NewFileName = NewPrefix + OldSuffix;
   return RenameFile(OldFileName, NewFileName);
}



//////////////////////////////////////////////////////////////////
//                                                              //
//  SetSuffix()                                                 //
//                                                              //
//  Renames a file, giving it a new suffix but retaining the    //
//  original prefix, while taking some safety precautions.      //
//  Return value indicates whether file rename was successful.  //
//                                                              //
//////////////////////////////////////////////////////////////////

bool
SetSuffix
   (
      std::string const & OldFileName,
      std::string const & NewSuffix
   )
{
   std::string  OldPrefix = GetPrefix(OldFileName);
   std::string  OldSuffix = GetSuffix(OldFileName);
   std::string  NewFileName = OldPrefix + NewSuffix;
   return RenameFile(OldFileName, NewFileName);
}



/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//  std::string rhdir::Debracket(std::string const & OldFileName)                          //
//                                                                                         //
//  Removes all instances of "[#]" substrings from the input std::string, and returns the  //
//  resulting "debracketed" std::string.  Useful for cleaning up names of files from the   //
//  "Temporary Internet Files" directories.                                                //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////

std::string
//rhdir::
Debracket
   (
      std::string const & OldFileName
   )
{
   std::string::size_type  Index        = 0;
   std::string             NewFileName  = OldFileName;

   BLAT("Just entered function rhdir::Debracket().  OldFileName = " << OldFileName)
   for (Index=0 ; Index <= NewFileName.size() - 3 ; ++Index)
   {
      if ('[' == NewFileName[Index])                       // If we find a left bracket in file name...
      {
         if (std::isdigit(NewFileName[Index+1]))           // if next character is a digit...
         {
            if (']' == NewFileName[Index+2])               // if next character is a right bracket...
            {
               NewFileName.erase(Index, 3);                // erase 3 characters at Index;
            }
            else if (std::isdigit(NewFileName[Index+2]))   // if 1st digit is followed by a second digit...
            {
               if (']' == NewFileName[Index+3])            // if 2nd digit is followed by a right bracket...
               {
                  NewFileName.erase(Index, 4);             // erase 4 characters at Index.
               }
            }
         }
      }
   }

   // Get rid of any leading or trailing spaces which may now be present:
   NewFileName = rhdir::StripLeadingAndTrailingSpaces(NewFileName);

   BLAT("About to return from function rhdir::Debracket().")

   return NewFileName;
}


////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//  unsigned short int rhdir::CountNumerators(std::string const & Name);              //
//                                                                                    //
//  Counts "-(####)" substrings in a std::string.                                     //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////
unsigned short int
//rhdir::
CountNumerators
   (
      std::string const & Name
   )
{
   unsigned short int      Count  = 0;
   std::string::size_type  Index  = 0;
   // If Name length is < 7, Name contains no numerators:
   if (Name.length() < 7)
   {
      return 0;
   }

   // Start searching, from left to right, for an instance of "-(####)":
   for
      (
         // INIT:     (start at position zero)
         Index=0;

         // COND:     (break if no more hyphens found)
         (Index=Name.find("-(", Index)) <= (Name.length() - 7);

         // INCR:     (move one position to the right and try again)
         ++Index
      )
   {
      // If we find "-(####)" starting at Index, increment Count:
      if
         (
               '-' ==  Name[Index + 0]
            && '(' ==  Name[Index + 1]
            && isdigit(Name[Index + 2])
            && isdigit(Name[Index + 3])
            && isdigit(Name[Index + 4])
            && isdigit(Name[Index + 5])
            && ')' ==  Name[Index + 6]
         )
      {
         ++Count;
      }
      // Then continue looping, starting one character further to the right, as long as we keep finding
      // "-(" substrings starting <= 7 spaces from the end marker of the std::string.
   }
   return Count;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  std::string rhdir::Denumerate(std::string const & OldFileName)                               //
//                                                                                               //
//  Removes all instances of "-(####)" substrings from the input std::string, and returns        //
//  the resulting "debracketed" std::string.  Useful for cleaning up names of files downloaded   //
//  from Usenet by NewsBin.                                                                      //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

std::string
//rhdir::
Denumerate
   (
      std::string const & OldFileName
   )
{

   BLAT("Just entered Denumerate().")

   if (OldFileName.size() < 7) return OldFileName;

   std::string NewFileName = OldFileName;

   for (std::string::size_type Index = 0; Index + 7 <= NewFileName.size(); ++Index)
   {
      while
      (
            '-' ==       NewFileName[Index+0]       // While character at Index is a hyphen...
         && '(' ==       NewFileName[Index+1]       // and next character is a left paren...
         && std::isdigit(NewFileName[Index+2])      // and next character is a digit...
         && std::isdigit(NewFileName[Index+3])      // and next character is a digit...
         && std::isdigit(NewFileName[Index+4])      // and next character is a digit...
         && std::isdigit(NewFileName[Index+5])      // and next character is a digit...
         && ')' ==       NewFileName[Index+6]       // and next character is a right paren...
      )
      {
         NewFileName.erase(Index, 7);               // Erase numerator.
         if (Index + 7 > NewFileName.size()) break; // If there's now no room for a numerator, break.
      }
   }

   // Get rid of any leading or trailing spaces which may now be present:
   NewFileName = rhdir::StripLeadingAndTrailingSpaces(NewFileName);

   BLAT("About to exit Denumerate().")

   return NewFileName;                              // Return new file name.
}



////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//  std::string Enumerate (std::string const & OldFileName);                                      //
//                                                                                                //
//  Strips any old "bracket expressions" ("[#]" or "[##]") or "numerators" ("-(####)") from       //
//  OldFileName, then tacks a single new numerator, using a random number, to the end of the      //
//  prefix of the new file name.                                                                  //
//                                                                                                //
//  NOTE: A program which uses this function should seed the random-number generator (by calling  //
//  srand(time(0)) or rhmath::Randomize() ) exactly once at the beginning of the program, else    //
//  the file names generated may not be sufficiently random to avoid name collision.              //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////

std::string
Enumerate
   (
      std::string const & OldFileName
   )
{
   // Make variable std::string NewFileName to hold file name:
   std::string NewFileName = OldFileName;

   // Debracket the file name:
   NewFileName = Debracket(NewFileName);

   // Denumerate the file name:
   NewFileName = Denumerate(NewFileName);

   // Split file name into prefix and suffix:
   std::string Prefix = GetPrefix(NewFileName);
   std::string Suffix = GetSuffix(NewFileName);

   // Append a random numerator to prefix of file name:
   char Digits[10] = {'0','1','2','3','4','5','6','7','8','9'};
   Prefix += "-(";
   Prefix += Digits[rhdir::RandInt(0,9)];
   Prefix += Digits[rhdir::RandInt(0,9)];
   Prefix += Digits[rhdir::RandInt(0,9)];
   Prefix += Digits[rhdir::RandInt(0,9)];
   Prefix += ")";

   // Store new prefix in NewFileName:
   NewFileName = Prefix;

   // If suffix is non-empty, append a dot and suffix to NewFileName:
   if (!Suffix.empty())
   {
      NewFileName += ".";
      NewFileName += Suffix;
   }
   return NewFileName;
}


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  std::string Signature(std::string Text)                                   //
//                                                                            //
//  Returns the "signature" of a file name (or other text string), which is   //
//  the source string with all digits replaced by octothorpes ('#').          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

std::string
Signature
   (
      std::string Text // pass by value to create copy
   )
{
   std::string::iterator i;
   for (i = Text.begin(); i != Text.end(); ++i)
   {
      if (std::isdigit(*i))
      {
         (*i) = '#';
      }
   }
   return Text;
}



/////////////////////////////////////////////////////////////////////////////
//                                                                         //
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
   )
{
   std::string::size_type Position;
   while (std::string::npos != (Position = Text.find_first_not_of("0123456789")))
   {
      Text.erase(Position, 1);
   }
   return Text;
}


//============================================================================================================
// Section 5                                                                                         Section 5
// File attribute, time, and date functions:
//============================================================================================================

#include "rhtime.cppism"


//============================================================================================================
// Section 6                                                                                         Section 6
// class FileRecord and associated ctors, dtors, methods, functions, and templates:
//============================================================================================================


// Define the following 3 functions first, because these are used by one of FileRecord's constructors:

// Get the type of a file, given the file's dirent entry:
std::string Type (struct dirent const * EntPtr)
{
   std::string FileType;
   if      (DT_REG     == EntPtr->d_type) FileType = "F"; // regular file
   else if (DT_DIR     == EntPtr->d_type) FileType = "D"; // directory
   else if (DT_FIFO    == EntPtr->d_type) FileType = "P"; // FIFO, aka pipe
   else if (DT_SOCK    == EntPtr->d_type) FileType = "S"; // socket
   else if (DT_CHR     == EntPtr->d_type) FileType = "C"; // character special file
   else if (DT_BLK     == EntPtr->d_type) FileType = "B"; // block special file
   else if (DT_LNK     == EntPtr->d_type) FileType = "L"; // symbolic link (to file or directory)
   else if (DT_UNKNOWN == EntPtr->d_type) FileType = "U"; // unknown
   else                                   FileType = "U"; // unknown
   return FileType;
}


// Get file permissions from mode_t object:
std::string Perm (mode_t Mode)
{
   std::string PermString ("---------+");
   if (S_IRUSR & Mode) PermString[0] = 'r';
   if (S_IWUSR & Mode) PermString[1] = 'w';
   if (S_IXUSR & Mode) PermString[2] = 'x';
   if (S_IRGRP & Mode) PermString[3] = 'r';
   if (S_IWGRP & Mode) PermString[4] = 'w';
   if (S_IXGRP & Mode) PermString[5] = 'x';
   if (S_IROTH & Mode) PermString[6] = 'r';
   if (S_IWOTH & Mode) PermString[7] = 'w';
   if (S_IXOTH & Mode) PermString[8] = 'x';
   return PermString;
}


// Get the attributes of a file, given the file's dirent entry:
std::string Attr (struct dirent const * EntPtr)
{
   FILE         * Aardvark          = NULL;
   char         * Command           = NULL;
   char         * Line              = NULL;
   size_t         AttrSize          = 25;
   ssize_t        Return            = 0;
   size_t         NamLen            = 0;

   // Abort if input is NULL:
   if (!EntPtr) {cerr << "Error in Attr(): EntPtr is NULL; aborting." << endl; abort();}

   // Allocate Command:
   NamLen = strlen(EntPtr->d_name);
   Command = static_cast<char *>(malloc(NamLen + 45));
   if (!Command) {cerr << "Error in Attr(): malloc of Command failed; aborting." << endl; abort();}

   // Fill-in Command:
   strcpy(Command, "/cygdrive/c/Windows/system32/attrib \"");
   strcat(Command, EntPtr->d_name);
   strcat(Command, "\"");

   // popen Command:
   Aardvark = popen(Command, "r");
   if (!Aardvark) {cerr << "Error in Attr(): popen of Command failed; aborting." << endl; abort();}

   // Allocate Line:
   Line = static_cast<char *>(malloc(AttrSize));
   if (!Line) {cerr << "Error in Attr(): malloc failed; aborting." << endl; abort();}

   // Get line of text spewed forth by Windows's attrib:
   Return = getline(&Line, &AttrSize, Aardvark);
   if (Return < 16)
   {
      cerr 
         << "Error in Attr(): getline failed for this file:"                                 << endl
         << EntPtr->d_name                                                                   << endl
         << "Using bogus attributes \"XXXXXX\" for this file instead of actual attributes."  << endl
         << "errno = " << errno << ". strerr = " << strerror(errno)                          << endl;
      return std::string("XXXXXX");
   }

   BLAT("In Attr(). Got line of test from attrib via getline.")
   BLAT("AttrSize = " << AttrSize << ". Return = " << Return << ". Line = " << Line)

   // Haul out the garbage:
   if (Line)    free (Line);
   if (Command) free (Command);
   if (0 != pclose(Aardvark)) {cerr << "Error in Attr(): pclose failed; aborting." << endl; abort();}

   // Get RawAttrString and AttrString:
   std::string RawAttrString (Line, 13);
   std::string AttrString ("      ");
   if (std::string::npos != RawAttrString.find_first_of("R")) AttrString[0] = 'R';
   if (std::string::npos != RawAttrString.find_first_of("H")) AttrString[1] = 'H';
   if (std::string::npos != RawAttrString.find_first_of("S")) AttrString[2] = 'S';
   if (DT_DIR == EntPtr->d_type)                              AttrString[3] = 'D';
   if (std::string::npos != RawAttrString.find_first_of("A")) AttrString[4] = 'A';
   if (std::string::npos != RawAttrString.find_first_of("I")) AttrString[5] = 'I';

   // We're done, so return AttrString:
   BLAT("About to return from Attr().")
   BLAT("RawAttrString = " << RawAttrString)
   BLAT("AttrString    = " << AttrString)
   return AttrString;
}


// Default constructor for FileRecord:
FileRecord::FileRecord() : name(""), dir(""), type(""), size(0), mtime(0), date(""), time(""), attr("") {}

// Parameterized constructor for FileRecord:
FileRecord::FileRecord
   (
      std::string    const & Dir,       // The directory this file resides in.
      struct dirent  const * EntPtr,    // Pointer   to directory entry struct.
      struct stat    const & FileStats  // Reference to file statistics struct.
   )
{
   // Assign file info to file record:         
   BLAT("About to load file info into file record.")
   // FR fields to load:
   // std::string  name;  // Name of file, excluding directory.
   // std::string  dir;   // Full path of directory in which file resides.
   // std::string  type;  // File type letter code.
   // std::string  perm;  // File permissions.
   // size_t       size;  // File size in bytes.
   // time_t       mtime; // Last-modified time, UTC, in seconds since 00:00:00 on 1970-01-01.
   // std::string  date;  // Last-modified date, local time, string format.
   // std::string  time;  // Last-modified time, local time, string format.
   // std::string  attr;  // File attributes string.
   this->name  = std::string(EntPtr->d_name);
   this->dir   = Dir;
   this->type  = Type(EntPtr);
   this->perm  = Perm(FileStats.st_mode);
   this->size  = static_cast<size_t>(FileStats.st_size);
   this->mtime = FileStats.st_mtime;
   this->date  = rhdir::GetDate(FileStats.st_mtime, 0);
   this->time  = rhdir::GetTime(FileStats.st_mtime, 0);
   this->attr  = Attr(EntPtr);
   BLAT("In FileRecord parameterized constructor. Constructed a FileRecord with these values:");
   BLAT("this->name  = " << this->name)
   BLAT("this->dir   = " << this->dir)
   BLAT("this->type  = " << this->type)
   BLAT("this->perm  = " << this->perm)
   BLAT("this->size  = " << this->size)
   BLAT("this->mtime = " << this->mtime)
   BLAT("this->date  = " << this->date)
   BLAT("this->time  = " << this->time)
   BLAT("this->attr  = " << this->attr)
}

// FileRecord copy constructor:
FileRecord::FileRecord(FileRecord const & FR)
   : name (FR.name), dir  (FR.dir),  type  (FR.type),  
     perm (FR.perm), size (FR.size), mtime (FR.mtime),
     date (FR.date), time (FR.time), attr  (FR.attr)
     {} // empty function body (all work done by initializer list)

// FileRecord destructor:
FileRecord::~FileRecord() {} // Nothing to do.

// class FileRecord method "path"; returns full path of the file for which this object is a record:
// std::string path (void) const // "const" means that this method doesn't alter this object's data.
// {
//    return dir + '/' + name;
// } // Defined in "rhdir.hpp" for inlining.

// Comparator ("<" operator) for FileRecord:
// inline
// bool
// operator<
//    (
//       rhdir::FileRecord const & Left,
//       rhdir::FileRecord const & Right
//    )
// {
//    return Left.name < Right.name;
// } // Defined in "rhdir.hpp" for inlining.


// Inserter for FileRecord:
std::ostream&
operator<<
   (
      std::ostream            & s,
      rhdir::FileRecord const & f
   )
{
   return s
      << std::left  << setw( 1) << f.type
      << std::left  << setw( 9) << f.perm << " "
      << std::left  << setw( 4) << f.attr << " "
      << std::right << setw(10) << f.date << " "
      << std::right << setw(10) << f.time << " "
      << std::right << setw(10) << std::scientific << std::setprecision(3) << f.size  << "  "
      << std::left              << f.name;
}

// Print function for rhdir::FileRecord :
// inline
// void
// PrintFileRecord
//    (
//       rhdir::FileRecord const & File
//    )
// {
//    cout << File << endl;
// } // Defined in "rhdir.hpp" for inlining.


// Print function for a container of rhdir::FileRecord objects:
// template<class ContainerType>
// inline
// void
// PrintFileList
//    (
//       ContainerType const & FileList
//    )
// {
//    for_each(FileList.begin(), FileList.end(), PrintFileRecord);
// } // Declared & defined in "rhdir.cpp" because templated.


// Templated function "LoadFileList()" is declared and defined in "rhdir.hpp" because it is templated. 
// This funtion loads a list of all files and/or directories in current directory matching a wildcard 
// into a std::vector, std::deque, or std::list of rhdir::FileRecord objects:
// template<class Container>
// Container& 
// LoadFileList
//    (
//       Container& C,                          // vector, deque, or list of FileRecord's
//       const std::string& Wildcard  = "*",    // Default is "all names"
//       int EntCode                  = 1,      // 1 => Files only (default).
//                                              // 2 => Dirs only.
//                                              // 3 => Both files and directories.
//       int ClrCode                  = 1       // 1 => Clear list (default)
//                                              // 2 => append
//    )
// {
//    ...etc...
// } // Declared & defined in "rhdir.cpp" because templated.


// Load file records of all files in current directory into a map of file records, keyed by size:
Flubber & LoadFileMap
   (
      Flubber           & M,         // Reference to map into which to load file records.
      const std::string & Wildcard,  // (= "*")  Default is "all names"
      int                 ClrCode    // (=  1 )  1 => Clear list (default), 2 => append
   )
{
   int                     done        = 0;
   std::string::size_type  LastSlant   = 0;
   std::string             Dir         = std::string();

   // What directory are these files in?

   // Get dir from Wildcard, if present.
   LastSlant = Wildcard.find_last_of("/");
   if (std::string::npos != LastSlant)
   {
      Dir = Wildcard.substr(0, LastSlant); // (index, size)
   }

   // Otherwise, set dir equal to current working directory.
   else
   {
      Dir = rhdir::GetCwd();
   }

   // Erase all prior contents (if any) of M, unless user indicates otherwise:
   if (2 != ClrCode)
   {
      M.clear();
   }

   // Search for all non-system files in directory indicated by Wildcard (or in current directory if
   // Wildcard does not indicate a directory):
   for ( done = 0 ; done < 3 ; ++done )  // ECHIDNA : flesh-out.
   {
      ; // ECHIDNA : flesh-out.
   }

   return M;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
// inline unsigned long int CountLinesInFile (const rhdir::FileRecord&)                                     //
// (Overloaded inline version taking a FileRecord instead of a string.)                                     //
// Given a rhdir::FileRecord, returns the number of lines in the file.                                      //
//                                                                                                          //
// Warning: this function is intended for use with text files.  Use with other types of files may yield     //
// unpredictable results, because this function uses getline(), which uses '\n' as line terminator,         //
// whereas binary files don't have "lines" or "line terminators", and any presence of a '\n' byte will be   //
// purely coincidental. '\n' may occur "not once in the entire file", or "nearly every byte", so the        //
// "number of lines" could be as few as 1, or nearly as many as the number of bytes in the file.            //
//                                                                                                          //
// Also see version taking a std::string as argument in x.xx above.                                         //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

size_t CountLinesInFile(const rhdir::FileRecord& file_record)
{
   return CountLinesInFile(file_record.path());
} // Also see overloaded version which takes a std::string, defined in section 3 above.



//============================================================================================================
// Section 7                                                                                         Section 7
// File-to-Container and Container-to-File functions:
//============================================================================================================


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  rhdir::LoadFileToContainer()                                                         //
//  Reads all lines of text from a file and stores them in a container of strings.       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  template<class ContainerType>                                                        //
//  size_t                                                                               //
//  LoadFileToContainer                                                                  //
//     (                                                                                 //
//        std::string             const &  Filename,                                     //
//        typename ContainerType        &  Container                                     //
//     ); // Defined in rhdir.h                                                          //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  rhdir::SaveContainerToFile()                                                         //
//  Writes all lines of text from a container of strings to a file.                      //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  template<class ContainerType>                                                        //
//  size_t                                                                               //
//  SaveContainerToFile                                                                  //
//     (                                                                                 //
//        typename ContainerType  const  &  Container,                                   //
//        std::string             const  &  Filename                                     //
//     ); // Defined in rhdir.h                                                          //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  rhdir::AppendFileToContainer()                                                       //
//  Reads all lines of text from a file and appends them to a container of strings.      //
//  (Note: this function is the same as LoadFileToContainer(), except that the container //
//  is not cleared.)                                                                     //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  template<class ContainerType>                                                        //
//  size_t                                                                               //
//  AppendFileToContainer                                                                //
//     (                                                                                 //
//        std::string    const &  Filename,                                              //
//        ContainerType        &  Container                                              //
//     ); // Defined in rhdir.h                                                          //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  AppendFileToListFunctor()()                                                          //
//  Functor which reads all lines of text from the file named by the argment of its      //
//  application operator and appends them to the std::list<std::string> named by the     //
//  argument of its constructor.                                                         //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  class AppendFileToListFunctor : public std::unary_function<std::string, void>;       //
//  // (defined in rhdir.h)                                                              //
//  // (also see initialization of static member ref_count below)                        //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////

int rhdir::AppendFileToListFunctor::ref_count(0);


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  rhdir::AppendContainerToFile()                                                       //
//  Writes all lines of text from a container of strings to a file.                      //
//  (Note that this function is the same as SaveContainerToFile(), except that the file  //
//  is not cleared.)                                                                     //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//  template<class ContainerType>                                                        //
//  int                                                                                  //
//  AppendContainerToFile                                                                //
//     (                                                                                 //
//        ContainerType  const  &  Container,                                            //
//        std::string    const  &  Filename                                              //
//     ); // Defined in rhdir.h                                                          //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////



//============================================================================================================
// Section 8                                                                                         Section 8
// Recursion-related functions:
//============================================================================================================


///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
// void RecursionDecider (const int& ArgC, const char *ArgV[], void Function(void))      //
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
//rhdir::
RecursionDecider
   (
      int ArgC,
      char *ArgV[],
      void Function(void)
   )
{
   bool Recurse = false;

   for (int i=1; i<ArgC; ++i)
   {
      if (std::string("-r") == std::string(ArgV[i]) || std::string("--recurse") == std::string(ArgV[i]))
      {
         Recurse = true;
         break;
      }
   }

   if (Recurse)
   {
      CursDirs(Function);
   }

   else
   {
      Function();
   }

   return;
}


///////////////////////////////////////////////////////////////////
//                                                               //
// Template function CursDirs is defined in rhdir.h .            //
//                                                               //
///////////////////////////////////////////////////////////////////


} // end namespace rhdir


/************************************************************************************************************\
 *    Sat Jan 10, 2004 - Wrote first draft.
 *    Wed Oct 27, 2004 - Added PrintFileName and PrintFileList.
 *    Sat Nov 20, 2004 - Added two versions of CountLinesInFile.
 *    Wed Dec 22, 2004 - Added function RenameFile() to safely rename files (or safely fail to do so).
 *    Sun Jan 16, 2005 - Changed any _rename() calls to RenameFile() calls (except in RenameFile() itself).
 *    Mon Jan 24, 2005 - Added more error checking to RenameFile() .
 *    Mon Mar 28, 2005 - Loosened error checking in RenameFile() to allow case adjustment of file names.
 *    Thu Jun 02, 2005 - Added HelpDecider() .
 *    Sat Jun 04, 2005 - Increased file-name length limit from 100 to 200.  (Win. 2000 limit is 211.)
 *    Mon Jun 06, 2005 - Cleaned-up "using"s.  Now rhdir.h has "using"s only inside inline-function and
 *                       template-function definitions, and rhdir.cpp has "usings" at the top of the file.
 *    Tue Jun 07, 2005 - Moved "LoadFileToList()", "SaveListToFile()", "AppendFileToList()", and
 *                       "AppendListToFile()" from rhutil to rhdir.
 *    Wed Aug 10, 2005 - Added GetPrefix(), GetSuffix(), and Demultiply().
 *    Sat Sep 10, 2005 - Refactored, fixed bugs, cleaned-up comments.  Added PrintFileRecord() and
 *                       PrintFileList().
 *    Mon Oct 10, 2005 - Added GetArguments() and corrected some comments.
 *    Circa  2006-2007 - Moved GetArguments() to rhutil.cpp.
 *    Fri Nov 09, 2007 - Added lots of BLATs to CursDirs.
 *    Sun Sep 21, 2007 - Added some directory exclusions to CursDirs.
 *    Tue Nov 13, 2007 - Fixed bug in rhdir::Debracket() on line 1083: use of unsigned integral type
 *                       std::string::size_type lead to underflow when subtracting 3 from 2.  Instead
 *                       of getting -1 (as we should), we get over 4 billion.  Oooooooops.  Use int instead.
 *                     - Also fixed similar bug on line 1090 where subtracing 3 from an unsigned long yielded
 *                       an unsigned long result, in a context where a signed result was necessary to prevent
 *                       -1 from being interpreted as over 4 billion (yet again).  Fixed with typecast.
 *                       These bugs were causing General Protection Faults do to array overruns when the
 *                       program tried to access the first 4 billion members of a 17 byte array.  Oh, my.
 *    Thu Mar 04, 2010 - I corrected a bug in Debracket() which was allowing the first or last 
 *                       character of a file name to be a space.
 *    Sat Apr 17, 2010 - Removed all but a few of the directory exclusions from CursDirs.  The only
 *                       directories still excluded are "Documents and Settings", "Program Files",
 *                       "RECYCLED", "RECYCLER", "System Volume Information", and "WINNT".  I removed
 *                       the others because they contain primarily "my" files, whereas the directories still
 *                       excluded contain the OS's files.
 *    Fri Jul 22, 2011 - I removed the proscription against file names starting with a dot, because Bash and
 *                       Picasa both use such file names.
 *    Sun Apr 12, 2015 - I had to strip all of the directory functionality out of this module to get it to
 *                       compile, because I've had to go over to using Cygwin as my platform, because
 *                       djgpp is obsolete and won't work on 64-bit Windows, nor will it work on Linux.
 *                       So this module is now just a decimated shell. I'm re-implementing everything in
 *                       Perl instead, because Perl excells at Unicode, pattern matching, and working with
 *                       directories and files, whereas C++ sux at those things.
 *    Mon Feb 15, 2016 - Cut out a lot of material made obsolete by transfer from DJGPP to Cygwin.
 *    Wed Mar 23, 2016 - Made massive deletions and changes pertaining to transfer from DJGPP to Cygwin, and
 *                       totally re-implimented LoadFileList using opendir/readdir/closedir from "dirent.hpp".
\************************************************************************************************************/
