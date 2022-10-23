/// This is a 110-character-wide ASCII-encoded C++ header file.
#ifndef RHREGEX_CPP_HEADER_ALREADY_INCLUDED
#define RHREGEX_CPP_HEADER_ALREADY_INCLUDED
/************************************************************************************************************\
 * File Name:            rhregex.hpp
 * Header For:           rhregex.o
 * Module Name:          Robbie Hatley's Regular-Expression Functions
 * Module Description:   Contains functions pertaining to regular expressions.
 * Functions contained:  rhregex::Substitute().  If I write other regex functions in the future,
 *                       those will also go in this file.
 * To use in program:    #include "rhregex.h" and link with object rhregex.o in library librh.a
 * Author:               Robbie Hatley
 * Version:              2016-04-13_10-37
\************************************************************************************************************/

// Note: to turn-on BLAT for any code which may be inside any of my personal
// library headers, #define BLAT_ENABLE then #include <rhdefines.h> or any of 
// my other headers (which all include this one).

#include <string>

#include "rhdefines.h"

// ============= Exceptions Thrown By Functions In This Header: ==============================================
// rhregex::Substitute() may throw an exception of type rhregex::RegExException if an error occurs.

namespace rhregex
{
// ============= Exception Classes: =======================================================================

struct RegExException
{
   RegExException(void)                    : msg(std::string(""))    {}
   RegExException(char const * Msg)        : msg(std::string(Msg))   {}
   RegExException(std::string const & Msg) : msg(Msg)                {}
   std::string msg;
};

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
      std::string const & Flags = "" // Contains 'g' means "global".
   );
// (Defined in rhregex.cpp .)


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
std::string
SubstituteC
   (
      std::string const & Pattern,
      std::string const & Replacement,
      std::string const & Text,
      std::string const & Flags = "" // Contains 'g' means "global".
   ); 
// (Defined in rhregex.cpp .)


} // end namespace rhregex

// End include guard:
#endif
