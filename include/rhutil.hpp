/// This is a 110-character-wide ASCII-encoded C++ header file.
#ifndef RH_UTIL_CPP_HEADER_ALREADY_INCLUDED
#define RH_UTIL_CPP_HEADER_ALREADY_INCLUDED
/************************************************************************************************************\
 * File Name:            rhutil.hpp
 * Header For:           rhutil.cpp
 * Module Name:          Robbie Hatley's Utilities
 * Module Description:   Utility Functions, Templates, and Classes
 * Author:               Robbie Hatley
 * Written:              circa 2001
 * To use in program:    #include "rhutil.h"
 *                       Link with module rhutil.o in library rhlib.a
 * Edit history:
 *    ??? ??? ??, 2001: Wrote first draft.
 *    Sat Apr 24, 2004: Performed unknown modifications.
 *    Thu Dec 23, 2004: Added function NCS_Equal() (non-case-sensitive std::string comparison)
 *    Sat Jan 15, 2005: Dramatically simplifyed RecursionDecider(), making it more argument-tolerant.
 *    Sun Jan 16, 2005: Changed (*i).name to i->name throughout CursDirs() .
 *    Sun Jan 16, 2005: Added function StringToUpper()
 *    Mon Jun 06, 2005: Changed "MakeList()" to "LoadFileToList()"; added "SaveListToFile()",
 *                      "AppendFileToList()", and "AppendListToFile()".  Cleaned up "usings"s.
 *                      Now rhutil.h has no "using"s, and rhutil.cpp has "usings" up front at global level.
 *    Tue Jun 07, 2005: Moved "LoadFileToList()", "SaveListToFile()", "AppendFileToList()", and
 *                      "AppendListToFile()" from rhutil to rhdir.
 *    Sun Sep 11, 2005: Added Substitute() (Regular-Expression Substitution & Backreference Function).
 *    Tue Sep 13, 2005: Fixed infinite-recursion bug in rhutil::Substitute().  Global replace now works fine.
 *    Tue Mar 06, 2018: Many updates. Now #include's "rhutilc.h" for random-number routines written in C.
\************************************************************************************************************/

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <list>
#include <algorithm>
#include <functional>
#include <sys/types.h>
#include <assert.h>
#include <errno.h>

#include <cstdint>

#include "rhdefines.h"

using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using std::setfill;
using std::setw;
using std::string;


// ===========================================================================================================
// Exceptions Thrown By Functions In This Header:

// Qsort will throw rhutil::RecursionException if recursion runs over 100 levels deep.


namespace rhutil
{

#include "rhutilc.h"

//============= Exception Structs: ===========================================================================


struct RecursionException
{
   RecursionException(std::string const & text) : msg(text) {}
   std::string msg;
};


// ============= Command-Execution Utilities: ================================================================

void
Execute
   (
      std::string const & Command
   );


// ============= Time Utilities: =============================================================================

#include "rhtime.cppismh"


// ============= C-String Utilities: =========================================================================

// Does a given C-string represent a number?
bool
IsNum
   (
      char const * numstr
   );

// Does a given C-string represent a positive integer?
bool
IsPosInt
   (
      char const * numstr
   );

// Strip newline from end of C-string:
void
StripNewLine
   (
      char * a
   );

// Read a specified number of characters from keyboard into a C-string
char *
GetString
   (
      char * buf,
      int num
   );


// ============= std::string Utilities: ======================================================================

// Print a string:
void
inline
PrintString
   (
      std::string const & Text
   )
{
   std::cout << Text << std::endl;
}

// Does a given std::string represent a number?
bool
IsNumber
   (
      std::string const & numstr
   );

// Does a given std::string represent a "simple" number (no exponent)?
bool
IsSimpleNumber
   (
      std::string const & numstr
   );

// Does a given std::string represent an integer?
bool
IsInteger
   (
      std::string const & NumStr
   );

// Count all occurences of characters from C-string C in std::string S:
std::string::size_type
Occurences
   (
      std::string const & S,
      char        const * C
   );

// Convert std::string to all-lower-case:
std::string
StringToLower
   (
      std::string const & InputString
   );

// Convert std::string to all-upper-case:
std::string
StringToUpper
   (
      std::string const & InputString
   );

// Convert std::string to "Robbie-Case" (First-Letter-Of-Each-Word-Capitalized):
std::string
StringToRobbie
   (
      std::string const & InputString
   );

// Strip all instances of specified character(s) from a std::string:
std::string
StripChar
   (
      std::string const & s,
      char        const   c
   );

std::string
StripChar
   (
      std::string const & s,
      char        const * c
   );

// Return a copy of a source std::string with any leading and/or trailing spaces stripped from it:
std::string
StripLeadingAndTrailingSpaces
   (
      std::string const & Input
   );


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  bool rhutil::NCS_Equal(const string& Bob, const string& Fred)     //
//                                                                    //
//  Determines whether two strings are non-case-sensitively equal.    //
//                                                                    //
////////////////////////////////////////////////////////////////////////

bool
NCS_Equal
   (
      std::string const & Bob,
      std::string const & Fred
   );


//========== Container-DeDuping Template Functions: ==========================================================

template <class T> void SortDup (T& c)
{
  if (c.size()<2) return;           // If container has < 2 elements, it doesn't have duplicates.
  sort(c.begin(), c.end());         // sort the container
  typename T::iterator u;           // Get an iterator.
  u = unique(c.begin(), c.end());   // Move unique elements to before iterator u.
  c.erase(u, c.end());              // Erase non-unique elements.
  return;                           // Return.
}

// Version of above template for std::list only:
template <class E> void SortDup (std::list<E>& L)
{
  if (L.size()<2) return;           // If list has < 2 elements, it doesn't have duplicates.
  L.sort();                         // Sort list.
  L.unique();                       // Erase duplicates.
  return;                           // Return.
}

// Version for arrays:
template <class E> E* SortDup (E* Left, size_t Size)
{
  if (Size < 2) return Left + Size; // If array has < 2 elements, it doesn't have duplicates.
  Qsort(Left, Size);                // Sort the array.
  E* u;                             // Declare element pointer u.
  u = unique(Left, Left + Size);    // Move unique elements to left of u.
  return u;                         // Return u.
}


//========== Function classes for use with algorithms: ====================================================


// Functor which converts a std::string to all-lower-case, in-place:
class StringToLower_Functor : public std::unary_function<std::string &, void>
{
   public:
      void operator()(std::string & Blat)
      {
         std::string::iterator i;
         for (i = Blat.begin(); i != Blat.end(); ++i)
         {
            if (std::isupper(*i))
            {
               (*i) = char(tolower(*i));
            }
         }
         return;
      }
};


// Functor which converts a std::string to all-upper-case, in-place:
class StringToUpper_Functor : public std::unary_function<std::string &, void>
{
   public:
      void operator()(std::string & Blat)
      {
         std::string::iterator i;
         for (i = Blat.begin(); i != Blat.end(); ++i)
         {
            if (std::islower(*i))
            {
               (*i) = char(toupper(*i));
            }
         }
         return;
      }
};


// Binary predicate which returns true iff two std::strings are NCS_Equal:
class NCS_Equal_Functor : public std::binary_function<std::string, std::string, bool>
{
   public:
      bool operator() (std::string const & a, std::string const & b) const
      {
         return NCS_Equal(a, b);
      }
};


// Perform a non-case-sensitive compare of two std::strings:
struct NoCase
{
   bool operator()(const std::string& a, const std::string& b) const
   {
      std::string::const_iterator i, j;
      for (i = a.begin(), j = b.begin();                               // Start at left.
           i != a.end() && j != b.end() && tolower(*i) == tolower(*j); // While curr chars are equal,
           ++i, ++j)                                                   // iterate rightward.
      {
         ; // do nothing                                               // Take no action in loop.
      }
      if ( j == b.end() )
      {
         return false;
         // (If b    ended    before    a, then a  > b, so "a < b" is false.)
         // (If b ended at same time as a, then a == b, so "a < b" is false.)
      }
      else
      {
         if ( i == a.end() )
         {
            return true;
            // (a ended before b, therefore a < b, so "a < b" is true.)
         }
         else
         {
            // If we get to here, we've established that we haven't run off the end of either
            // string yet, so the reason the loop ended must be that the current characters
            // are not NCS_Equal.  Since we know that all the characters up till now *have* been
            // NCS_Equal, the truth of "a < b" is therefore dependent soley on the current characters:
            return (toupper(*i) < toupper(*j));
         } // end else (haven't run off end of a)
      } // end else (haven't run off end of b)
   } // end operator()
}; // end struct NoCase


// Does std::string a have fewer characters than std::string b?
struct Shorter
{
  bool operator()(const std::string& a, const std::string& b) const
  {
     return a.size() < b.size();
  }
};


// Do items in a sequence match a given reference item?  (For use with the "for_each" algorithm.)
// Note: this will only work for types T for which "a == b" (a, b of type T) is defined.
template<typename T>
class Match : public std::unary_function<T, bool>
{
   public:
      Match(T const & Ref) : Ref_(Ref) {}
      bool operator()(T const & Item)
      {
         return Item == Ref_;
      }
   private:
      T Ref_;
};


// Are strings in a sequence NCS_Equal to a given reference string?
// (For use with the "for_each" algorithm.)
class NCS_Match_Functor : public std::unary_function<std::string, bool>
{
   public:
      NCS_Match_Functor(std::string const & Ref) : Ref_(Ref) {}
      bool operator() (std::string const & Item)
      {
         return StringToLower(Item) == StringToLower(Ref_);
      }
   private:
      std::string Ref_;
};


// Do items in a sequence NOT match a given reference item?  (For use with the "for_each" algorithm.)
// Note: this will only work for types T for which "a != b" (a, b of type T) is defined.
template<typename T>
class NonMatch : public std::unary_function<T, bool>
{
   public:
      NonMatch(T const & Ref) : Ref_(Ref) {}
      bool operator()(T const & Item)
      {
         return Item != Ref_;
      }
   private:
      T Ref_;
};


// Are stringss in a sequence *NOT* NCS_Equal to a given reference string?
// (For use with the "for_each" algorithm.)
class NCS_NonMatch_Functor : public std::unary_function<std::string, bool>
{
   public:
      NCS_NonMatch_Functor(std::string const & Ref) : Ref_(Ref) {}
      bool operator() (std::string const & Item)
      {
         return StringToLower(Item) != StringToLower(Ref_);
      }
   private:
      std::string Ref_;
};


// ===========================================================================================================
// Program-Argument-Processing Utilities:


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  HelpDecider                                                       //
//                                                                    //
//  Executes help function and returns true if user uses a "-h" or    //
//  "--help" switch; otherwise, returns false.                        //
//                                                                    //
////////////////////////////////////////////////////////////////////////

bool
HelpDecider
   (
      int      ArgCount,
      char  *  ArgStrings[],
      void     HelpFunction(void)
   );
// (defined in rhutil.cpp)


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  GetFlags()                                                        //
//                                                                    //
//  Loads all flags (arguments starting with hyphens) into a          //
//  std::vector<std::string>.                                         //
//                                                                    //
////////////////////////////////////////////////////////////////////////
void
GetFlags
   (
      int                          ArgCount,
      char                      *  ArgStrings[],
      std::vector<std::string>  &  Flags
   );
// (defined in rhutil.cpp)


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  GetArguments()                                                    //
//                                                                    //
//  Loads arguments other than flags (ie, arguments not starting      //
//  with hypens)                                                      //
//  into a std::vector<std::string>.                                  //
//                                                                    //
////////////////////////////////////////////////////////////////////////
void
GetArguments
   (
      int                          ArgCount,
      char                      *  ArgStrings[],
      std::vector<std::string>  &  Arguments
   );
// (defined in rhutil.cpp)


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  InVec()                                                           //
//                                                                    //
//  Determine whether a string is in a vector.                        //
//                                                                    //
////////////////////////////////////////////////////////////////////////

inline
bool
InVec
   (
      std::vector<std::string>  const  &  Vec,
      std::string               const  &  Txt
   )
{
   return Vec.end() != find(Vec.begin(), Vec.end(), Txt);
}


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  atoint                                                            //
//  Converts program argument strings into int.                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////

int
atoint(const char *idx);
// (defined in rhutil.cpp)


////////////////////////////////////////////////////////////////////////
//                                                                    //
//  atoll                                                             //
//  Converts program argument strings into long long int.             //
//                                                                    //
////////////////////////////////////////////////////////////////////////

long long int
atoll(const char *idx);
// (defined in rhutil.cpp)


////////////////////////////////////////////////////////////////////////
//                                                                    //
// Memory-Swapping Template Function:                                 //
//                                                                    //
////////////////////////////////////////////////////////////////////////
template <class T> void MemSwap(T *p1, T *p2)
{
   T temp;
   temp=*p2;
   *p2=*p1;
   *p1=temp;
   return;
}


////////////////////////////////////////////////////////////////////////
//                                                                    //
// Array-Sorting Template Function:                                   //
//                                                                    //
////////////////////////////////////////////////////////////////////////
template <class T>
void
Qsort
   (
      T        * left,        // "left"    == pointer to first (left) element of an array
      long int   size,        // "size"    == number of elements in array
      int        recurse = 0  // "recurse" == recursion depth (0 for initial call)
   )
{
   // ----- Define variables: ---------------------------------------------------
   T           *right       = left+(size-1); // Point "right" to right end of array
   T           *pivot       = left+(size/2); // Point "pivot" to  middle   of array
   T            pval        = *pivot;        // Store value at pivot in variable "pval"
   T           *red         = left;          // Set "red" to left end
   T           *blue        = right;         // Set "blue" to right end
   T           *cursor      = NULL;          // Create cursor for traversing array
   bool         rflag       = false;
   bool         gflag       = false;
   bool         bflag       = false;
   static int   partitions  = 0;             // Initialize partition counter only on first call

   if (0==recurse)    // If this is initial call to Qsort<>()...
      partitions=1;   // initialize partition counter to 1...
   else               // otherwise...
      ++partitions;   // increment partition counter

   // ----- Print info if debugging: --------------------------------------------

   BLAT(std::endl)
   BLAT("Just entered Qsort().")
   BLAT("Recursion level  = " << recurse)
   BLAT("Partition number = " << partitions)
   BLAT("Size of array    = " << size)
   BLAT("Array contents   = ")
   for (cursor=left; cursor<=right; ++cursor)
   {
   BLAT("   " << *cursor)
   }

   // ----- Abort if number of levels of recursions is excessive: ---------------

   // Only 100 levels of recursion are necessary to sort an array of
   // one nonillion (10^30) objects, so throw up if recurse>100 :
   if (recurse>100)
   {
      RecursionException up ("Recursion error in Qsort<>(): over 100 levels!  Aborting.");
      throw up;
   }

   // ----- Simplify special cases: ---------------------------------------------

   // If the array has 0 or 1 elements, return,
   // because it is already sorted:
   if (size<2) {
     goto exitpoint;
   }

   // If the array has 2 elements, sort is trivial:
   if (2==size) {
     if (left[0]>left[1]) MemSwap(left, left+1);
     goto exitpoint;
   }

   // ----- Initialize red and blue zones: --------------------------------------

   // Find lowest non-red:
   while ((*red)<pval&&red<right) ++red;

   // Find highest non-blue:
   while ((*blue)>pval&&blue>left) --blue;

   // ----- Check success of initialization: ------------------------------------

   if ((*red)<pval) {
     std::cerr << "Red-zone initialization error: value at red pointer "
               << "less than pval." << std::endl;
     std::exit(1);
   }

   if ((*blue)>pval) {
     std::cerr << "Blue-zone initialization error: value at blue pointer "
               << "more than pval." << std::endl;
     std::exit(1);
   }

   // ----- Percolate reds and blues out of green zone: -------------------------

   for (cursor=red; cursor<=blue; ++cursor) {
     // Keep processing current cursor position until it is either green,
     // or no longer in the green zone:
     do {
       if ((*cursor)<pval) {      // If value at cursor is red...
         MemSwap(cursor, red);    // swap to red zone...
         ++red;                   // and increment red pointer.
       }
       else if ((*cursor)>pval) { // Else if value at cursor is blue...
         MemSwap(cursor, blue);   // swap to blue zone...
         --blue;                  // and decrement blue pointer.
       }
     } while (red<=cursor && cursor<=blue && (*cursor)!=pval);
   }

   // ----- Check pointers: -----------------------------------------------------

   if (NULL==left || NULL==right || NULL==pivot || NULL==red || NULL==blue
      || blue<red || red<left    || red>right   || blue<left || blue>right
      || !((right-left)==(size-1)))
   {
     std::cerr << "Error in Qsort<>(): bad pointer after percolation." << std::endl;
   }

   // ----- Check Zone Purity: --------------------------------------------------

   // Check red zone:
   if (red>left) { // if red zone is non-empty...
     for (cursor=left; cursor<=red-1; ++cursor) {
       rflag=rflag||(*cursor)>=pval;
     }
     if (rflag) {
       std::cerr << "Error in Qsort<>(): red zone impure:" << std::endl;
       for (cursor=left; cursor<=red-1; ++cursor) {
         std::cerr << *cursor;
       }
       std::cerr << std::endl;
       std::exit(1);
     }
   }

   // Check green zone:
   if (red<blue) { // if green zone has more than one element...
     for (cursor=red; cursor<=blue; ++cursor) {
       gflag=gflag||(*cursor)!=pval;
     }
     if (gflag) {
       std::cerr << "Error in Qsort<>(): green zone impure:" << std::endl;
       for (cursor=red; cursor<=blue; ++cursor) {
         std::cerr << *cursor;
       }
       std::cerr << std::endl;
       exit(1);
     }
   }

   // Check blue zone:
   if (blue<right) { // if blue zone is non-empty...
     for (cursor=blue+1; cursor<=right; ++cursor) {
       bflag=bflag||(*cursor)<=pval;
     }
     if (bflag) {
       std::cerr << "Error in Qsort<>(): blue zone impure:" << std::endl;
       for (cursor=blue+1; cursor<=right; ++cursor) {
         std::cerr << *cursor;
       }
       std::cerr << std::endl;
       std::exit(1);
     }
   }

   // ----- Recurse: ------------------------------------------------------------

   if (red>left+1) Qsort(left, red-left, recurse+1);
   if (blue<right-1) Qsort(blue+1, right-blue, recurse+1);

   // ----- Exit: ---------------------------------------------------------------

   exitpoint:
   ; // Empty statement that does nothing (necessitated by "exitpoint:" label).
   BLAT(std::endl)
   BLAT("About to exit Qsort().")
   BLAT("Recursion level  = " << recurse)
   BLAT("Partition number = " << partitions)
   BLAT("Size of array    = " << size)
   BLAT("Array contents   = ")
   for (cursor=left; cursor<=right; ++cursor) { BLAT("   " << (*cursor)) }
   if  (0 == recurse)                         { BLAT("FINAL EXIT.")      }
   return;
} // End Qsort<>()
/******************************************************************************\
 * Qsort<>() Notes:
 *
 * Note regarding template definition location:
 * Normally, the definition of the MemSwap<>() and Qsort<>() templates would
 * go in a cpp file, but I'm forced to define them in this header file because
 * DJGPP doesn't support the "export" keyword.
 *
 * Tuesday July 9, 2002:
 * I've been having a lot of problems the last few days
 * with my Qsort<>() template.  It seemed to work for ints but not chars.
 *
 * PROBLEM: The algorithm was flawed to the core. It only established TWO
 * categories, "low" and "high", when it actually needs THREE categories:
 * "red", "green", and "blue", for items which are less-than, equal-to, or
 * greater-than the pivot value, respectively.  Once the sub-array has been
 * partitioned into these three zones, only the red and blue zones are
 * sent to the next level of recursion.  This ensures that infinite recursion
 * will never take place, because the green zone always has at least one item
 * in it (the pivot), so each processing step simplifies the problem by
 * at least one element.  So 100 elements could require no more than
 * 100 levels of recursion, at worst, and probably require far fewer levels
 * in most cases.
 *
 * Pointers:
 *   blue: everything to the right of blue is blue (greater than pivot)
 *   red:  everything to the leftof redis red(lessthan pivot)
 *
 * Procedure:
 *   1. select pivot value
 *   2. build red zone on left end of sub-array
 *   3. build blue zone on right end of sub-array
 *   4. remainder is green zone; don't recurse!
 *   5. recurse red
 *   6. recurse blue
 *
 * Thursday July 11, 2002, 10:33PM:
 * I totally re-vamped Qsort<>(), and dramatically simplified the
 * percolation section.
 *
 * Saturday November 30, 2002:
 * I've taken the variables "recurse" and "partitions" out of the global
 * namespace and put them in a new namespace called "qsortvariables", to
 * prevent conflicts.
 *
 * Sun. Dec. 29, 2002:
 * I've gotten rid of namespace "qsortvariables".  "recurse" is now an
 * argument with a default value of "0", and "partitions" is now a static
 * variable within Qsort().
\******************************************************************************/



//========== Miscellanious Utility Functions: =============================================================


// Do nothing for a given number of seconds:
void
Lollygag
   (
      time_t  Seconds
   );
// defined in rhutil.cpp


// Discern binary representation of an object:
// (Borrowed 2006-07-16 from Frederick Gotham on comp.lang.c++ .)
void
PrintBits
   (
      void          const * const mem,
      size_t                      amount_bytes,
      std::ostream        &       os
   );
// defined in rhutil.cpp


// Print binary representation of an object:
// (Borrowed 2006-07-16 from Frederick Gotham on comp.lang.c++ .)
template<class T>
inline
void
PrintObjectBits
   (
      T            const & obj,
      std::ostream       & os
   )
{
    PrintBits(&obj, sizeof obj, os);
}


// end namespace rhutil:
}

// End include guard:
#endif
