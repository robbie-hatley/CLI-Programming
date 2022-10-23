

/************************************************************************************************************\
 * File Name:            rhregex.cpp
 * Source For:           rhregex.o
 * Module Name:          Robbie Hatley's Regular-Expression Functions
 * Module Description:   Contains functions pertaining to regular expressions.
 * Functions contained:  rhregex::Substitute().  If I write other regex functions in the future,
 *                       those will also go in this file.
 * To use in program:    #include "rhregex.hpp" and link with object rhregex.o in library librh.a
 * Author:               Robbie Hatley
 * Version:              2016-04-13_10-37
 * Edit history:
 *    Around      2005 - First wrote it.
 *    Tue Sep 12, 2006 - Added comments, cleaned up formatting.
 *    Sat Apr 09, 2016 - Made many, many changes in order to get this working with Cygwin (as opposed to
 *                       DJGPP, which it was originally written for).
 *    Mon Apr 11, 2016 - Going over to using C++ 2011 std lib <regex> functionality, replacing the old C-based
 *                       <regex.h> regex stuff, which was a hodge-podge from BSD,RedHat,GNU.
 *    Tue Apr 12, 2016 - Added C version of Substitute back in, after debugging. Renamed the two versions to
 *                       SubstituteCPP() and SubstituteC().
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <regex>
#include <regex.h>

#include <assert.h>
#include <errno.h>

//#define BLAT_ENABLE
#include "rhregex.hpp"

using std::cout;
using std::cerr;
using std::setw;
using std::setfill;
using std::endl;

typedef std::string::size_type SSST;

namespace rhregex
{

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//  std::string                                                                         //
//  rhregex::                                                                           //
//  SubstituteCPP                                                                       //
//     (                                                                                //
//        std::string const & Pattern,                                                  //
//        std::string const & Replacement,                                              //
//        std::string const & Text,                                                     //
//        std::string const & Flags = "" // Contains 'g' means "global".                //
//     );                                                                               //
//                                                                                      //
//  SubstituteCPP() looks for matches to regular expression Pattern in Text, and        //
//  returns a copy of Text with all matches to Pattern replaced by Replacement.         //
//  Pattern may contain any number of parenthetical groups, and Replacement may         //
//  contian any number of backreferences to matches to parenthetical groups in          //
//  Pattern.                                                                            //
//                                                                                      //
//  Example:                                                                            //
//     Pattern     = "(red)"                                                            //
//     Replacement = is "r\1io"                                                         //
//     Text        = "Fred ate a steak.".                                               //
//  SubstituteCPP() would then return "Frredio ate a steak.".                           //
//                                                                                      //
//  SubstituteCPP() does not alter its arguments.                                       //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////
std::string 
SubstituteCPP
   (
      std::string const & Pattern,
      std::string const & Replacement,
      std::string const & Text,
      std::string const & Flags      // Contains 'g' means "global".
   )
{
   std::regex_constants::match_flag_type RegexFlags {};
   if (std::string::npos == Flags.find_first_of("g"))
      RegexFlags = std::regex_constants::format_first_only;
   std::regex RegEx {Pattern};
   std::string Result = std::regex_replace(Text, RegEx, Replacement, RegexFlags);
   return Result;
} // end function rhregex::SubstituteCPP()

// Private function "GetRegError() for use by SubstituteC():
std::string GetRegError (int Gripe, regex_t *RegEx)
{
   size_t Garp = regerror (Gripe, RegEx, NULL, 0);
   char* Biff = new char[Garp+4];
   regerror(Gripe, RegEx, Biff, Garp+2);
   std::string Message {Biff};
   delete[] Biff;   
   return Message;
}


//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//  std::string                                                                         //
//  rhregex::                                                                           //
//  SubstituteC                                                                         //
//     (                                                                                //
//        std::string const & Pattern,                                                  //
//        std::string const & Replacement,                                              //
//        std::string const & Text,                                                     //
//        std::string const & Flags = "" // Contains 'g' means "global".                //
//     );                                                                               //
//                                                                                      //
//  SubstituteC() looks for matches to regular expression Pattern in Text, and          //
//  returns a copy of Text with all matches to Pattern replaced by Replacement.         //
//  Pattern may contain any number of parenthetical groups, and Replacement may         //
//  contian any number of backreferences to matches to parenthetical groups in          //
//  Pattern.                                                                            //
//                                                                                      //
//  Example:                                                                            //
//     Pattern     = "(red)"                                                            //
//     Replacement = is "r\1io"                                                         //
//     Text        = "Fred ate a steak.".                                               //
//  SubstituteC() would then return "Frredio ate a steak.".                             //
//                                                                                      //
//  SubstituteC() does not alter its arguments.                                         //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////
std::string SubstituteC 
   (
      std::string const & Pattern,
      std::string const & Replacement,
      std::string const & Text,
      std::string const & Flags      // Contains 'g' means "global".
   )
{
   BLAT("\nJust entered Substitute() with following parameters:")
   BLAT("Pattern     = " << Pattern)
   BLAT("Replacement = " << Replacement)
   BLAT("Text        = " << Text)
   BLAT("Flags       = " << Flags << "\n")

#ifdef PLATFORM_IS_LINUX
   regex_t      RegEx               = regex_t ();
   int          Result              = 0;
   std::string  ReturnString        ("");
   bool         DoingGlobalReplace  = false;
#else
   regex_t      RegEx               {}; // Works in Cygwin but not Linux.
   int          Result              {}; // Works in Cygwin but not Linux.
   std::string  ReturnString        {}; // Works in Cygwin but not Linux.
   bool         DoingGlobalReplace  {}; // Works in Cygwin but not Linux.
#endif

   // Make variable ReplacementCopy to hold copy of Replacement.
   // (We can't alter Replacement because it is a const reference.)
   std::string ReplacementCopy {Replacement};

   // Make variable TextCopy to hold copy of Text.
   // (We can't alter Text because it is a const reference.)
   std::string TextCopy {Text};

   // COMPILE REGULAR EXPRESSION:
   BLAT("\nIn Substitute(), about to call regcomp().")
   Result = regcomp(&RegEx, Pattern.c_str(), REG_EXTENDED);
   BLAT("In Substitute(), just returned from regcomp().\n")

   // If regcomp() failed, throw exception:
   if (REG_NOERROR != Result)
   {
      std::string ErrorMessage =
           std::string("regcomp() failed.\nError message from regerror():\n")
         + GetRegError(Result, &RegEx) + "\n";
      RegExException up (ErrorMessage);
      throw up;
   }

   // If we get to here, regcomp() did NOT fail, so grab number of parenthesized
   // subexpressions which regcomp() found in Pattern:
   size_t NumParSubExp = RegEx.re_nsub;
   BLAT("In Substitute(), regcomp() succeeded NumParSubExp = " << NumParSubExp)

   // ALLOCATE MATCHES:
   BLAT("In Substitute(), about to allocate Matches.")
   regmatch_t Matches [NumParSubExp + 1];
   BLAT("In Substitute(), just allocated Matches.")

   // EXECUTE REGULAR EXPRESSION:
   // Run regexec(), which will look for matches to the RE in Text:
   BLAT("In Substitute(), about to call regexec().")
   Result = regexec(&RegEx, Text.c_str(), NumParSubExp + 1, Matches, 0);
   BLAT("In Substitute(), called regexec().")

   // IF EXECUTION FAILED, THROW EXCEPTION:
   if (REG_NOERROR != Result && REG_NOMATCH != Result)
   {
      std::string ErrorMessage =
           std::string("regexec() failed.\nError message from regerror():\n")
         + GetRegError(Result, &RegEx) + "\n";
      RegExException up (ErrorMessage);
      throw up;
   }

   BLAT("In Substitute(), after \"if (exec error) throw exception\" section;")
   BLAT("just above \"if (no match)\" section.")

   // IF NO MATCH, JUST RETURN TextCopy:
   if (REG_NOMATCH == Result)
   {
      BLAT("In Substitute(), in \"no-match\" section;")
      BLAT("TextCopy = " << TextCopy)
      return TextCopy;
   }

   // If we get to here, we have matches.

   // EXPAND BACKREFERENCES (IF ANY):

   BLAT("In Substitute, just above Parenthesized-Subexpression-Expansion for loop.")
   for ( size_t i = 1 ; i <= NumParSubExp ; ++i )
   {
      // While there are instances of backreference i in Replacement, expand those:
      std::ostringstream SS ("");
      std::string::size_type Index;
      SS << "\\" << setw(1) << i;
      BLAT("In Substitute(), inside top of backreference-expansion for loop;")
      BLAT("SS.str() = " << SS.str())
      while (std::string::npos != (Index = ReplacementCopy.find(SS.str())))
      {
         BLAT("In Substitute(), just inside top of while(backreferences exist) loop,")
         BLAT("Index = " << Index)
         if // If there was a match for parenthetical group i...
         (
            Matches[i].rm_so > -1
            &&
            Matches[i].rm_eo > -1
            &&
            Matches[i].rm_so <  static_cast<long>(TextCopy.size())
            &&
            Matches[i].rm_eo <= static_cast<long>(TextCopy.size())
            &&
            Matches[i].rm_eo > Matches[i].rm_so
         )
         {
            BLAT("In Substitute(), inside if (match exists to backreference).")
            // Expand current instance of backreferrence i:
            ReplacementCopy.replace
            (
               Index,
               2,
               Text.substr
               (
                  std::string::size_type(Matches[i].rm_so),
                  std::string::size_type(Matches[i].rm_eo - Matches[i].rm_so)
               )
            );
         } // end if (there was a match for parenthetical group i)
         else // Otherwise, current backreference is unused, so erase it:
         {
            BLAT("In Substitute(), inside else (no match to backreference).")
            ReplacementCopy.erase(Index, 2);
         } // end else (current backreference is unused)
      } // end while (unexpanded backreference i instances exist in ReplacementCopy)
   } // end for (each submatch, i = 1 through n)

   // REPLACE FIRST MATCH:

   long RepPos {Matches[0].rm_so};
   long RepLen {Matches[0].rm_eo - Matches[0].rm_so};
   BLAT("In Substitute(), about to do replacement on TextCopy with these parameters:")
   BLAT("TextCopy        = " << TextCopy)
   BLAT("RepPos          = " << RepPos)
   BLAT("RepLen          = " << RepLen)
   BLAT("ReplacementCopy = " << ReplacementCopy)
   TextCopy.replace(RepPos, RepLen, ReplacementCopy);
   BLAT("TextCopy after replacement = " << TextCopy)

   // DECIDE WHETHER TO DO GLOBAL REPLACE:

   // Firstly, is 'g' in Flags? If so, tentatively assume we're doing global replace:
   if (Flags.find('g') != std::string::npos)
   {
      DoingGlobalReplace = true;
      BLAT("In SubstituteC(), just set DoingGlobalReplace to true because g")
   }

   // But don't do global replacement if the characters '^' or '$' appear in contexts
   // other than litterals or character-list inversions.  Otherwise, we'd violate the
   // user's request that a replacement be done ONLY at the beginning or ending of a line:
   std::string::size_type Index;
   Index = Pattern.find('^');
   if (Index < std::string::npos)
   {
      if ('[' != Pattern[Index-1] && '\\' != Pattern[Index-1])
      {
         DoingGlobalReplace = false;
         BLAT("In SubstituteC(), just set DoingGlobalReplace to false because ^")
      }
   }
   Index = Pattern.find('$');
   if (Index < std::string::npos)
   {
      if ('\\' != Pattern[Index-1])
      {
         DoingGlobalReplace = false;
         BLAT("In SubstituteC(), just set DoingGlobalReplace to false because $")
      }
   }

   // IF DOING GLOBAL REPLACE, RECURSE:

   BLAT("In Substitute, just above global recursion section;")
   BLAT("DoingGlobalReplace = " << DoingGlobalReplace)
   // If doing global replace, recurse:
   if (DoingGlobalReplace)
   {
      BLAT("In Substitute, just inside \"if (global)\" section;")
      BLAT("TextCopy = " << TextCopy);
      // Now here things get very, very tricky!  It would be tempting to do this:
      // return Substitute(Pattern, Replacement, TextCopy, 'g');
      // Tempting... but disastrous!  if Pattern matches a substring of Replacement,
      // then this would recurse forever!  (Actually, it would recurse till it overflows
      // the stack and crashes the system.)  So we must split TextCopy into "processed" and
      // "unprocessed" chunks, and pass only the unprocessed chunk to Substitute at the
      // next recursive level down, then re-glom the chucks and return the result:
      std::string::size_type FirstChunkSize = Matches[0].rm_so + ReplacementCopy.size();

      BLAT("In Substitute, about to recurse;")
      BLAT("TextCopy.substr(0,  FirstChunkSize  ) = ")
      BLAT(TextCopy.substr(0, FirstChunkSize))
      BLAT("TextCopy.substr(FirstChunkSize , std::string::npos) = ")
      BLAT(TextCopy.substr(FirstChunkSize , std::string::npos))

      // RECURSE!!!
      ReturnString = // return string passed from below
         // substring, starting at 0, size = FirstChunkSize:
         TextCopy.substr(0, FirstChunkSize)
         +
         SubstituteC // RECURSE!!!
         (
            Pattern,
            Replacement,
            // substring, starting at FirstChunkSize, size = unlimited:
            TextCopy.substr(FirstChunkSize, std::string::npos),
            Flags
         );

      BLAT("In Substitute(), just returned from recursion;")
      BLAT("ReturnString = " << ReturnString)
   }

   // OTHERWISE, DON'T RECURSE:
   else
   {
      ReturnString = TextCopy;
      BLAT("In Substitute(), at bottom of \"else not recursing\" section;")
      BLAT("Didn't recurse;")
      BLAT("ReturnString = " << ReturnString)
   }

   // RETURN ReturnString:
   BLAT("In Substitute(), freed Matches, at bottom, about to return;")
   BLAT("ReturnString = " << ReturnString)
   return ReturnString; // return string passed to above (not necessarily to calling program!!!)
} // end function rhregex::SubstituteC()


} // end namespace rhregex
