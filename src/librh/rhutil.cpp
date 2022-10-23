

/************************************************************************************************************\
 * File Name:            rhutil.cpp
 * Source For:           rhutil.o
 * Module Name:          Robbie Hatley's Utilities
 * Module Description:   Utility Functions, Templates, and Classes
 * Author:               Robbie Hatley
 * Written:              circa 2001
 * To use in program:    #include "rhutil.hpp"
 *                       Link with module rhutil.o in library rhlib.a
 * Edit history:
 *    Sat Apr 24, 2004
 *    Thu Dec 23, 2004 - Added function NCS_Equal() (non-case-sensitive std::string comparison)
 *    Sat Jan 15, 2005 - Dramatically simplifyed RecursionDecider(), making it more argument-tolerant.
 *    Sun Jan 16, 2005 - Changed (*i).name to i->name throughout CursDirs() .
 *    Sun Jan 16, 2005 - Added function StringToUpper()
 *    Mon Jun 06, 2005 - Changed "MakeList()" to "LoadFileToList()"; added "SaveListToFile()",
 *                       "AppendFileToList()", and "AppendListToFile()".  Cleaned up "usings"s.
 *                       Now rhutil.h has no "using"s, and rhutil.cpp has "usings" up front at global level.
 *    Tue Jun 07, 2005 - Moved "LoadFileToList()", "SaveListToFile()", "AppendFileToList()", and
 *                       "AppendListToFile()" from rhutil to rhdir.
 *    Sun Sep 11, 2005 - Added Substitute() (Regular-Expression Substitution & Backreference Function).
 *    Tue Sep 13, 2005 - Fixed infinite-recursion bug in rhutil::Substitute().  Global replace now works fine.
 *    Fri Nov 09, 2007 - Repaired GetArguments() so that it rejects common flags (-h --help -r --recurse).
 *                       (This was causing bizarre crashes in enumerate-file-names.exe, which was attempting
 *                       to pass "-r" as a wildcard to LoadFileList().  OOOPS!!!  DOH!!!)
\************************************************************************************************************/

#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <climits>

#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>

#include <sys/types.h>

//#define NDEBUG
#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#include "rhutil.hpp"

using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using std::setfill;
using std::setw;
using std::string;

namespace rhutil
{

// ============= Command-Execution Utilities: ================================================================

// Execute an OS command expressed as a C++ string :
void
Execute
   (
      std::string const & Command
   )
{
   std::string CommandLine = "cmd /c " + Command;
   system(CommandLine.c_str());
   return;
}


// ============= Time Utilities: =============================================================================

#include "rhtime.cppism"


// ============= C-String Utilities: =========================================================================

// Does a given string represent a number (floating or integer)?
bool
IsNum
   (
      char const * numstr
   )
{
  size_t  numlen   = strlen(numstr);
  bool    numflag  = true;
  char cString[20] = "0123456789+-.eE";
  for ( size_t i = 0 ; i < numlen ; ++i )
  {
    numflag&=(NULL!=strchr(cString, numstr[i]));
  }
  return numflag;
}

// Does a given string represent a positive integer?
bool
IsPosInt
   (
      char const * numstr
   )
{
  size_t  numlen   = strlen(numstr);
  bool    numflag  = true;
  for ( size_t i = 0 ; i < numlen ; ++i ) numflag&=(numstr[i]>47&&numstr[i]<58);
  return numflag;
}

// Strip newline character from a character array:
void
StripNewLine
   (
      char * a
   )
{
   char *NLP;
   NLP=strchr(a, '\n');
   if (NULL==NLP)
   {
      cerr << "Input over-run." << endl;
      exit(666);
   }
   else *NLP='\0';
   return;
}

// Read string of num chars from keyboard, not including newline:
char *
GetString
   (
      char * buf,
      int    num
   )
{
  // Calling program must declare buf as having at least num+2 elements.
  // One of the extra elements is for the newline, and the other is for
  // the null terminator.  This function converts the newline to a null,
  // but space must still be allowed for the newline, hence the
  // two-extra-element requirement.
  if (NULL==fgets(buf, num+2, stdin))
  {
    cerr << "Error in getstring(): unable to get string." << endl;
    return NULL;
  }
  size_t  len  = strlen(buf);
  if ('\n'==buf[len-1])
    buf[len-1]='\0';
  else
  {
    cerr << "Error in getstring(): over-run." << endl;
    return NULL;
  }
  return buf;
}


// ============= std::string Utilities: ======================================================================

// Does a given string represent a number (floating or integer)?
bool
IsNumber
   (
      std::string const & NumStr
   )
{
  // If NumStr is a "simple" number (no exponent), it's a number:
  if (IsSimpleNumber(NumStr)) return true;

  // If we get to here, NumStr is not a "simple number"; so it's either a number in scientific notation,
  // or it's not a number at all.  To be a number, NumStr must have exactly one [e|E] in it:
  if (1 != Occurences(NumStr, "eE")) return false;

  // The [e|E] must not be the first or last character:
  const std::string::size_type Epos = NumStr.find_first_of("eE");
  const std::string::size_type Size = NumStr.size();
  if (Epos == 0 or Epos == Size-1) return false;

  // If the part of NumStr to the left of the [e|E] is a simple number, and the portion of NumStr to the
  // right of the [e|E] is an integer, then NumPos is a number; otherwise, it's not:
  std::string Left  = NumStr.substr(  0   ,     Epos   );
  std::string Right = NumStr.substr(Epos+1, Size-1-Epos);
  if (IsSimpleNumber(Left) and IsInteger(Right)) return true;
  else return false;
}


// Does a string represent a "simple number" (that is, a possibly-negative, possibly-floating-point number
// in simple non-scientific notation, such as "42" or "-3.75")?
bool
IsSimpleNumber
   (
      std::string const & NumStr
   )
{
   // Proceed by winnowing-out strings that contain illegal characters or combinations.
   // Only if NumStr passes all tests will we return true.

   // If NumStr contains characters other than digits, decimal points, and signs,
   // it's not a simple number:
   if (std::string::npos != NumStr.find_first_not_of("0123456789.-+"))
   {
      return false;
   }

   // Count decimal points and negative signs:
   std::string::size_type Pnts = Occurences(NumStr, ".");
   std::string::size_type Poss = Occurences(NumStr, "+");
   std::string::size_type Negs = Occurences(NumStr, "-");

   // If NumStr contains more than one decimal point, it's not a simple number:
   if (Pnts > 1) return false;

   // If NumStr contains more than one positive sign, it's not a simple number:
   if (Poss > 1) return false;

   // If NumStr contains more than one negative sign, it's not a simple number:
   if (Negs > 1) return false;

   // If there a positive sign, it must be the first character:
   if (Poss > 0)
   {
      if ('+' != NumStr[0])
      {
         return false;
      }
   }

   // If there a negative sign, it must be the first character:
   if (Negs > 0)
   {
      if ('-' != NumStr[0])
      {
         return false;
      }
   }

   // A decimal point may be located anywhere in the string, except that if there is a leading zero,
   // the next character must be a decimal point:
   if ('-' == NumStr[0] || '+' == NumStr[0])  // check for invalid leading zero on number with sign
   {
      if ('0' == NumStr[1])
      {
         if ('.' != NumStr[2])
         {
            return false;
         }
      }
   }
   else // check for invalid leading zero on number with no sign (regular positive number)
   {
      if ('0' == NumStr[0])
      {
         if ('.' != NumStr[1])
         {
            return false;
         }
      }
   }

   // If we get to here, we've passed all tests, so return true:
   return true;
}


bool
IsInteger
   (
      std::string const & NumStr
   )
{
   // If NumStr contains characters other than digits and signs, it's not an integer:
   if (std::string::npos != NumStr.find_first_not_of("0123456789-+")) return false;

   // If NumStr contains more than one sign, it's not an integer:
   long Signs = long(Occurences(NumStr, "-+"));
   if (Signs > 1) return false;

   // If NumStr contains no digits, it's not an integer:
   long Size   = long(NumStr.size());
   long Digits = Size - Signs;
   if (0 == Digits) return false;

   // If NumStr contains a sign, it must be the first character, else NumStr is not an integer:
   if (Signs > 0 && '-' != NumStr[0] && '+' !=  NumStr[0]) return false;

   // If NumStr has more than one digit, the first digit must not be zero, else NumStr is not an integer:
   if (Digits > 1 && '0' == NumStr[Signs]) return false;

   // If we reach here, we've passed all tests, so return true:
   return true;
}


// Count all occurences of characters from C-string C in string S:
std::string::size_type
Occurences
   (
      std::string const & S,
      char        const * C
   )
{
  std::string::size_type Size  = S.size(); // Size of string.
  std::string::size_type   i   = 0;        // index
  std::string::size_type Count = 0;        // Count of chars. from C in S.
  for
     (
        i=0;
        (i = S.find_first_of(C, i)) < Size;
        ++i
     )
  {
     ++Count;
  }
  return Count;
}
// Usage example:
// string Phrase ("Now is the time for all good men...");
// string::size_type blat = Occurences(Phrase, "aeiou"); // Count vowels in Phrase.


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
    if (isupper(*i)) OutputString.push_back(char(tolower(*i)));
    else OutputString.push_back(*i);
  }
  return OutputString;
}


// Convert string to all-upper-case:
std::string
StringToUpper
   (
      std::string const & InputString
   )
{
  std::string OutputString;
  std::string::const_iterator i;
  for (i = InputString.begin(); i != InputString.end(); ++i)
  {
    if (islower(*i)) OutputString.push_back(char(toupper(*i)));
    else OutputString.push_back(*i);
  }
  return OutputString;
}


// Convert std::string to "Robbie-Case" (First-Letter-Of-Each-Word-Capitalized):
std::string
StringToRobbie
   (
      std::string const & InputString
   )
{
   std::string             OutputString;
   std::string::size_type  i;
   std::string::size_type  Length;

   Length = InputString.length();

   for ( i = 0 ; i < Length ; ++i)
   {
      if
         (
            0 == i
            ||
            ' ' == InputString[i-1]
            ||
            '-' == InputString[i-1]
            ||
            '(' == InputString[i-1]
         )
      {
         OutputString.push_back(char(toupper(InputString[i])));
      }
      else
      {
         OutputString.push_back(char(tolower(InputString[i])));
      }
   }
   return OutputString;
}



// Return a copy of a source string with a1l instances of a specified character
// stripped from it:
std::string
StripChar
   (
      std::string const & s,
      char        const   c
   )
{
   std::string buffer = s;
   std::string::size_type i = 0;
   while (std::string::npos != (i = buffer.find_first_of(c)))
   {
      buffer.erase(i, 1);
   }
   return buffer;
}


// Return a copy of a source string with a1l instances of any of the characters
// in a given C-string stripped from it:
std::string
StripChar
   (
      std::string const & s,
      char        const * c
   )
{
   std::string buffer = s;
   std::string::size_type i = 0;
   while (std::string::npos != (i = buffer.find_first_of(c)))
   {
      buffer.erase(i, 1);
   }
   return buffer;
}


// Return a copy of a source std::string with any leading and/or trailing spaces stripped from it:
std::string
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


////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//  bool rhutil::NCS_Equal(const string& Bob, const string& Fred)                         //
//                                                                                        //
//  Determines whether two strings are non-case-sensitively equal.                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////

bool
NCS_Equal
   (
      std::string const & Bob,
      std::string const & Fred
   )
{
   return StringToLower(Bob) == StringToLower(Fred);
}



// ============= Container-Sorting-And-DeDuping Template Function: ===========================================

// (Normally, that would go here, but due to DJGPP's lack of support for the
// "export" keyword, it's defined in the header file instead.)



// ============= Function Objects: ===========================================================================

// (Application operators defined in rhutil.h instead, to get inlining.)



// ===========================================================================================================
// Program-Argument-Processing Utilities:

///////////////////////////////////////////////////////////////////////
//                                                                   //
//  HelpDecider                                                      //
//                                                                   //
//  Executes help function and returns true if user uses a "-h" or   //
//  "--help" switch; otherwise, returns false.                       //
//                                                                   //
///////////////////////////////////////////////////////////////////////

bool
HelpDecider
   (
      int      ArgCount,
      char  *  ArgStrings[],
      void     HelpFunction(void)
   )
{
   bool Help = false;

   for (int i = 1; i < ArgCount; ++i)
   {
      if
         (
            std::string("-h") == std::string(ArgStrings[i])
            ||
            std::string("--help") == std::string(ArgStrings[i])
         )
      {
         Help = true;
         break;
      }
   }

   // If user wants help, give help:
   if (Help)
   {
      HelpFunction();
   }

   // Return a boolean indicating whether help was given:
   return Help;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//  GetFlags()                                                                                    //
//                                                                                                //
//  Loads all flags (arguments starting with hyphens) into a std::vector<std::string>.            //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////

void
GetFlags
   (
      int                          ArgCount,
      char                      *  ArgStrings[],
      std::vector<std::string>  &  Flags
   )
{
   // Local variables used in this function:
   std::string Splat;

   // Clear Flags and reserve space for 50 flags:
   Flags.clear();
   Flags.reserve(50);

   // Riffle through raw command-line arguments, looking for arguments starting with "-",
   // and add such arguments to Flags:
   for (int i = 1; i < ArgCount; ++i)
   {
      Splat = std::string(ArgStrings[i]);
      if ('-' == Splat[0]) Flags.push_back(Splat);
   }
   return;
}


///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//  GetArguments()                                                               //
//                                                                               //
//  Loads arguments other than flags (ie, arguments not starting with hypens)    //
//  into a std::vector<std::string>.                                             //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

void
GetArguments
   (
      int                          ArgCount,
      char                      *  ArgStrings[],
      std::vector<std::string>  &  Arguments
   )
{
   // Local variables used in this function:
   std::string Splat;

   // Clear Arguments and reserve space for 50 arguments:
   Arguments.clear();
   Arguments.reserve(50);

   // Riffle through raw command-line arguments, looking for arguments not starting with "-",
   // and add such arguments to Arguments:
   for (int i = 1; i < ArgCount; ++i)
   {
      Splat = std::string(ArgStrings[i]);
      if ('-' == Splat[0]) continue;
      Arguments.push_back(Splat);
   }
   return;
}


/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//  InVec()                                                                        //
//                                                                                 //
//  Determine whether a string is in a vector.                                     //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////
// This is inline, so it's defined in file "rhutil.hpp".  The below is for reference:
// inline
// bool
// rhutil::
// InVec
//    (
//       std::vector<std::string>  const  &  Vec,
//       std::string               const  &  Txt
//    )
// {
//    return Vec.end() != find(Vec.begin(), Vec.end(), Txt);
// } // end rhutil::InVec()


/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  atoint()                                                                   //
//  Converts a program argument string into long long int.  If any minus signs //
//  are present, the number will be negative; otherwise, it will be positive.  //
//  All digits present will be interpreted as the digits of the number, in the //
//  order encountered.  All other characters will be ignored.                  //
//                                                                             //
//  Example: "+pe387-2856+fj&39\2" will be interpreted as "-3872856392LL".     //
//                                                                             //
//  Note: while it is true that the 1998 C++ standard does not recognize       //
//  "long long int", most compilers recognize "long long int", and it is       //
//  expected that future versions of the C++ standard will take a que from C   //
//  and recognize "long long int".                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

int 
atoint(const char *idx)
{
   int  absv  = 0; // Absolute value of number.
   int  sign  = 1; // Sign of number.

   while (*idx != '\0')
   {
      if ( *idx == '-' )
      {
         sign = -1;
      }
      else if (*idx >= '0' && *idx <= '9')
      {
         absv = (absv * 10) + ((*idx) - '0');
      }
      ++idx;
   }
   return (absv * sign);
}


/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  atoll()                                                                    //
//  Converts program argument strings into long long int.  If any minus signs  //
//  are present, the number will be negative; otherwise, it will be positive.  //
//  All digits present will be interpreted as the digits of the number, in the //
//  order encountered.  All other characters will be ignored.                  //
//                                                                             //
//  Example: "+pe387-2856+fj&39\2" will be interpreted as "-3872856392LL".     //
//                                                                             //
//  Note: while it is true that the 1998 C++ standard does not recognize       //
//  "long long int", most compilers recognize "long long int", and it is       //
//  expected that future versions of the C++ standard will take a que from C   //
//  and recognize "long long int".                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

long long int 
atoll(const char *idx)
{
   long long int  absv  = 0LL; // Absolute value of number.
   long long int  sign  = 1LL; // Sign of number.

   while (*idx != '\0')
   {
      if ( *idx == '-' )
      {
         sign = -1LL;
      }
      else if (*idx >= '0' && *idx <= '9')
      {
         absv = (absv * 10LL) + ((*idx) - '0');
      }
      ++idx;
   }
   return (absv * sign);
}



// ===========================================================================================================
// Miscellanious Utility Functions:


// Waste some time:
void
Lollygag
   (
      time_t Seconds
   )
{
   time_t EntryTime;
   time(&EntryTime);

   time_t CurrentTime;
   double Trouble = 1.0001234;
   for (time(&CurrentTime); CurrentTime - EntryTime < Seconds; time(&CurrentTime))
   {
      Trouble *= 1.0001234;
      if (Trouble > 5.0) Trouble = 1.0001234;
   }
   return;
}


// Discern binary representation of an object:
// (Borrowed 2006-07-16 from Frederick Gotham on comp.lang.c++ .)
void
PrintBits
   (
      void          const * const mem,
      size_t                      amount_bytes,
      std::ostream        &       os
   )
{
    assert(mem);
    assert(amount_bytes);
    char static str[CHAR_BIT + 1];
    unsigned char const *p = reinterpret_cast<unsigned char const*>(mem);
    do
    {
        unsigned const byte_val = *p++;
        char *pos = str; // str itself always points to &str[0]
        unsigned to_and_with = (1U << (CHAR_BIT - 1));  // place-value mask
        do
        {
           *pos++ = byte_val & to_and_with ? '1' : '0'; // write to str[i]
        } while(to_and_with >>= 1);                     // test fails 8th try
        os << str;                                      // write string to os
    } while (--amount_bytes); // decrement amount_bytes once for each 8 pos++
}


// // Print binary representation of an object:
// // (Borrowed 2006-07-16 from Frederick Gotham on comp.lang.c++ .)
// // This part is inline and templated, so it's defined in rhutil.h:
// template<class T>
// inline
// void
// PrintObjectBits
//    (
//       T            const & obj,
//       std::ostream       & os
//    )
// {
//     PrintBits(&obj, sizeof obj, os);
// }


// end namespace rhutil:
} 
