/// This is a 110-character-wide ASCII-encoded C++ header file.
#ifndef RH_MATH_CPP_HEADER_ALREADY_INCLUDED
#define RH_MATH_CPP_HEADER_ALREADY_INCLUDED
/************************************************************************************************************\
 * Filename:             rhmath.hpp
 * Header For:           rhmath.cpp
 * Module Description:   Math Functions, Templates, and Classes
 * Author:               Robbie Hatley
 * Date Written:         circa 2001
 * To use in program:    #include "rhmath.h"
 *                       Link program with rhutil.o and rhmath.o in librh.a
 * Notes:                See developement notes for Qsort<>() at end of this file
 * Edit History:
 *   Mon Jul 19, 2004: Started writing it.
 *   Sat Oct 02, 2004: Added class Neighborhood .
 *   Mon Oct 04, 2004: corrected errors in Neighborhood; improved transform() .
 *   Mon Jun 06, 2005: Cleaned-up "using"s.  Now rhmath.h has no "using"s, and
 *                     rhmath.cpp has "usings" up front, at global level.
 *   Sun Mar 15, 2009: Added Sieve() (indexed-value-return function) to class PrimeTable.
 *   Tue Mar 06, 2018: Now #include's "rhmathc.h" for routines written in C.
 *
\************************************************************************************************************/

#include <cstdlib>
#include <cmath>
#include <ctime>
#include <cstring>

#include <iostream>
#include <vector>
#include <list>
#include <sstream>
#include <utility>
#include <limits>

#include "rhdefines.h"

// Undefine the pesky macro "minor" which SOMETHING keeps cramming into this program:
#undef minor

// Convenient typedefs:
typedef unsigned int  UI;
typedef unsigned long UL;

namespace rhmath
{

#include "rhmathc.h"

   // ========================================================================================================
   // Private functions for use by functions in this namespace only:

   // Count all occurences of characters from C-string C in std::string S:
   std::string::size_type
   Occurences
      (
         std::string const & S,
         char        const * C
      );

   // Does a given std::string represent an integer?
   bool
   IsInteger
      (
         std::string const & NumStr
      );


   // ========== Misc. Math. Functions: =========================================

   double SnapToInt(double x, double p);


   // ========== Function Classes: =============================================

   // To use these, instantiate them to create function objects.  Then use the
   // function objects with the application operator () as if they were
   // functions.  Example:
   // Quadratic blat (3.1, -6.7, 1.8); // creates function object blat(x) = 3.1x^2 - 6.7x + 1.8
   // y=blat(x);

   class Quadratic
   {
     public:
       Quadratic(double aa, double bb, double cc) : a(aa), b(bb), c(cc) {}
       double operator()(double x) {return a*x*x + b*x + c;}
     private:
       double a;
       double b;
       double c;
   };

   class LinearRescale
   {
     public:
       LinearRescale(double delta_x, double delta_y) : slope(delta_y/delta_x) {}
       double operator()(double x) {return slope * x;}
     private:
       double slope;
   };

   class AffineRescale
   {
     public:
       AffineRescale(double delta_x, double delta_y, double x_offset, double y_offset)
         : slope(delta_y/delta_x), x_off(x_offset), y_off(y_offset) {}
       double operator()(double x) {return slope * (x+x_off) + y_off;}
     private:
       double slope;
       double x_off;
       double y_off;
   };

   // ========== Class Matrix: =================================================

   class Matrix {
     public:
       Matrix(int M, int N);
       Matrix(const Matrix&);
       ~Matrix();
       int    rows();
       int    cols();
       double get(int row, int col);
       void   set(int row, int col, double val);
       void   operator=(const Matrix& src);
       Matrix operator+(const Matrix& src) const;
       Matrix operator-(const Matrix& src) const;
       Matrix operator*(const Matrix& src) const;
       Matrix operator/(const double&   d) const;
       Matrix minormatrix(int, int);
       double minor(int, int);
       double cofactor(int, int);
       double det();
       Matrix inv();
     private:
       int m;            // m is number of rows
       int n;            // n is number of columns
       double *mat;      // pointer to matrix values
   };


   //========== Class IntegFract: ==============================================

   // Decompose a real number into its integral and fractional parts and store
   // those parts as members in an object for later retrieval:
   class IntegFract
   {
      public:
         // Parameterized constructor:

         // Put fractional part in fract_var, and put integral part in integ_var:
         IntegFract(double x)
         {
            fract_var = modf(x, &integ_var);
         }

         // Return integral part:
         int integ()
         {
            return static_cast<int>(integ_var);
         }

         // Return fractional part:
         double fract()
         {
            return fract_var;
         }

      private:
         double fract_var;
         double integ_var;

   }; // end class IntegFract


   // ========== class Neighborhood: ===========================================

   /////////////////////////////////////////////////////////////////////////////
   //                                                                         //
   // class "Neighborhood" holds matrices of pre-image and image points       //
   // equally spaced within a rectangular neighborhood of Euclidean 2-space.  //
   // This class should be especially useful in graphing iterated fractals,   //
   // such as The Mandelbrot Set or Julia sets, when one wishes to display a  //
   // pixel color corresponding to the maximum number of iterations lasted by //
   // any of a bunch of points less than one-half-pixel-width from the pixel. //
   // This "shotgun" approach should darken thin, wispy filiments within such //
   // sets for better visibility.                                             //
   //                                                                         //
   /////////////////////////////////////////////////////////////////////////////
   class Neighborhood
   {
      public:
         Neighborhood
         (
            double x,               // x-coordinate of center point of neighborhood
            double y,               // y-coordinate of center point of neighborhood
            double xspan,           // width  of neighborhood
            double yspan,           // height of neighborhood
            int    granularity = 3  // number of points per row or column
         );
         std::pair<double, double>  get_preimage (int i, int j);
         void set_image (int i, int j, double val);
         double get_image (int i, int j);
         double maximum (void);
         double minimum (void);
         double average (void);
         void transform (double (*map)(int, double, double, int), int degree, int iterations);
      private:
         int Granularity;
         std::vector<std::vector<std::pair<double, double> > >   PreImage;
         std::vector<std::vector<double> >                       Image;
   };


   // ========== Prime Numbers: =================================================

   /////////////////////////////////////////////////////////////////////////////
   //                                                                         //
   // class "PrimeTable" generates (and optionally prints and/or retains in   //
   // a list) prime numbers, either the first n primes, or primes within a    //
   // range [a,b].                                                            //
   //                                                                         //
   /////////////////////////////////////////////////////////////////////////////
   class PrimeTable
   {
      public:
         // List to hold prime numbers:
         std::list<UL> Primes;

         // Function which decides whether a candidate is prime:
         static bool PrimeDecider(UL n);

         // Function which generates the first n prime numbers:
         void
         GeneratePrimes
         (
            UI   n,      // Generate first n prime numbers.
            bool bPrint, // Print them one-at-a-time as they are generated?
            bool bPush   // Push them onto a list for future reference?
         );

         // Function which generates prime numbers in the range [a,b],
         // and return their sum:
         UL
         GeneratePrimesInRange
         (               // Generate all prime numbers which are
            UL a,        // not  less   than a and
            UL b,        // not greater than b.
            bool bPrint, // Print them one-at-a-time as they are generated?
            bool bPush   // Push them onto a list for future reference?
         );

      protected:
         static UL Limit(UL n);

      private:
         // Declare a Wheel containing all the positive integers not
         // greater than the product of the first 4 prime numbers (2,3,5,7)
         // which are not divisible  by the first 4 prime numbers (2,3,5,7)
         // (to be defined and initialized in file rhmath.cpp):
         static const UL Wheel[48];
   };


   // ======= Class BigNum: ===============================================================================
   // A two-billion-digit-precision integer class.  (CAUTION: DO NOT ATTEMPT TO COMPREHEND JUST HOW MUCH
   // PRECISION THAT ACTUALLY IS; BRAIN DAMAGE MAY RESULT.)

   // Advance declaration of class BigNum (used by advance declaration of inserter):
   class BigNum; // defined below

   // Advance declaration of inserter (used by BLAT macros in definition of BigNum):
   inline std::ostream& operator<<(std::ostream& S, const BigNum& N); // defined below

   // Definition of class BigNum:
   class BigNum
   {
      // Two-billion-digit-precision integer with ops.
      public:
         // Default constructor:
         BigNum (void)  : g(false), n("0")
         {
            BLAT("In BigNum default constructor.")
            BLAT("   g = " << g << ", n = " << n)
         }

         // Construct from a long:
         BigNum (long const & Num) : g(false), n("0")
         {
            std::ostringstream OSS;
            OSS << Num;
            ParseSourceString(OSS.str());
            BLAT("In BigNum-from-long-int constructor.")
            BLAT("   Num = " << Num << ", g = " << g << ", n = " << n)
         }

         // Construct from a std::string :
         BigNum (std::string const & Str) : g(false), n("0")
         {
            ParseSourceString(Str);
            BLAT("In BigNum-from-std::str constructor.")
            BLAT("   Str = " << Str << ", g = " << g << ", n = " << n)
         }

         // Construct from BigNum (copy constructor)
         BigNum(BigNum const & src) : g(src.g), n(src.n)
         {
            BLAT("In BigNum copy constructor.")
            BLAT("   src = " << src << ", g = " << g << ", n = " << n)
         }

         // Assignment operator:
         BigNum const & operator=(BigNum const & src)
         {
            g = src.g; n = src.n;
            BLAT("In BigNum assignment operator.")
            BLAT("   src = " << src << ", g = " << g << ", n = " << n)
            return *this;
         }

         // Is this integer negative?
         bool const & neg(void) const {return g;}

         // Invert this integer:
         void inv(void)
         {
            g ? g = false : g = true;
         }

         // Return const reference to the string representation of this integer:
         std::string const & str(void) const {return n;}

      private:
         bool         g; // negativity             (true for negative, false for positive)
         std::string  n; // string representation  (digits only)
         void ParseSourceString(std::string const & SrcStr); // defined in rhmath.cpp
   };

   // Declare the following BigNum-related operators as NON-MEMBER operators, because they don't modify
   // existing BigNum objects, and because they don't need access to BigNum's private parts:

   // Is a == b?
   bool operator==(const BigNum& a, const BigNum& b);

   // Is a < b?
   bool operator<(const BigNum& a, const BigNum& b);

   // Is a > b?
   inline bool operator>(const BigNum& a, const BigNum& b) {return !(a < b || a == b);}

   // Return the additive inverse of a BigNum integer:
   BigNum operator-(const BigNum& a);

   // Addition:
   BigNum operator+(const BigNum& a, const BigNum& b);

   // Subtraction:
   BigNum operator-(const BigNum& a, const BigNum& b);

   // Multiplication:
   BigNum operator*(const BigNum& a, const BigNum& b);

   // Integer Division:
   BigNum operator/(const BigNum& a, const BigNum& b);

   // Modulus:
   BigNum operator%(const BigNum& a, const BigNum& b);

   // Inserter for printing BigNum's to a std::ostream (such as cout):
   std::ostream& operator<<(std::ostream& S, const BigNum& N)
   {
      return N.neg()?S<<'-'<<N.str():S<<N.str();
   }

   // Finally, here's a couple of inline utility functions for use with class BigNum; they convert
   // back and forth between the ASCII code for a digit and the numerical value of the digit:
   inline long ctol(char c) {return static_cast<long>(c) - 48;}
   inline char ltoc(long l) {return static_cast<char>(l + 48);}



   // ======= (OBSOLETE) Number Bases (OBSOLETE) ================================================================


   ///////////////////////////////////////////////////////////////////////////
   //                                                                       //
   //  (OBSOLETE) Base (OBSOLETE)                                           //
   //  Represent an integer in any base from 2 to 36.                       //
   //                                                                       //
   ///////////////////////////////////////////////////////////////////////////

   // Now renamed "RepresentInBase" and completely rewritten in C for numbers of type "uint64_t" only, 
   // and moved from module "rhmath" to module "rhmathc".



   // ======= Combinatorial Analysis: ========================================================================

   long Pow(long x, long y);

   long Fact(long x);

   long Perm(long x, long y);

   long Comb(long x, long y);

} // end namespace "rhmath"

//========== Notes: ==========================================================

/****************************************************************************\
 * Note regarding PrimeSpace::Limit():
 * Note that I increase the size of the sqrt by 1 ppm before flooring;
 * this is to compensate for any inaccuracy in the sqrt() function,
 * to insure that floor() doesn't return a number which is one-less-than
 * the correct value of floor(sqrt(n)).
 * If n is 4.2 billion, then sqrt(n) is about 64807.40698, and
 * sqrt(1.0001*n) == sqrt(1.0001)*sqrt(n)
 *                == 1.000049999*64807.40698
 *                == 64810.64729
 * which is an error of about 3 parts in 65000.  Hence, no more than
 * 4 extra steps per 65000 total steps will ever be performed when testing
 * integers from 0 to about 4 billion (the range of long int) for primeness.
\***************************************************************************/

/***************************************************************************\
 * Mathematical background for my prime-number functions and classes:
 * These functions and classes use the "method of 30s" sieve technique which
 * I invented to avoid wasting time considering impossible candidates for
 * alleged prime-ness.  The key is to see that the distribution of primes
 * among the integers is NOT random, but very well-ordered, and is patterned
 * by cyclic groups, including this one of order 8: {6,4,2,4,2,4,6,2}
 * This group defines a subset H of the integers which contains all the
 * primes. The complimentary subset ~H contains NO primes.  Hence much time
 * can be saved by not looking for primes in ~H.  The subsets H and ~H become
 * very visually obvious if you write first 300 positive integers on paper
 * in the form of a chart of 10 rows and 30 columns with 1 in the upper-left
 * corner, then circle all the primes. You will see that the primes except
 * for 2, 3, and 5 are in the 8 columns 1, 7, 11, 13, 17, 19, 23, and 29.
 * The other 22 columns contain no primes whatsoever!  (Except, of course,
 * for the first three prime numbers, 2, 3, and 5.)
 * The mathematical proof of this is as follows:
 * 1. 30 is the product of the first 3 prime numbers, 2, 3, and 5.
 * 2. Any positive integer n can be expressed as n=x+30i for some
 *    non-negative integer i and some integer x such that 0<x<31.
 *    (In other words: 30 can be used as a "base" for the integers,
 *    just as we can use 10 ("decimal"), or 2 ("binary"), or 16 ("hexadecimal")
 *    as bases.)
 * 3. If x is divisible by 2, 3, or 5, then so is n, because
 *    n=x+30i=x+(2)(3)(5)i.
 * 4. Hence if x is divisible by 2, 3, or 5, n is not prime.
 * 5. All numbers x such that 0<x<31 are divisible by 2, 3, or 5 except for
 *    1, 7, 11, 13, 17, 19, 23, and 29.
 * 6. Hence all columns other than 1, 7, 11, 13, 17, 19, 23, 29 are totally
 *    devoid of prime numbers (except for 2, 3, and 5), QED.
 * Note that the spacings between these 8 columns are the cyclic group
 * {6,4,2,4,2,4,6,2}.  Hence this cyclic group can and should be used
 * as a sieve to weed out known none-primes from consideration when
 * searching for prime numbers. This is best done with modular arithmetic,
 * going around the cycle:
 *   c[8]={6,4,2,4,2,4,6,2};
 *   unsigned long int primes[NumberOfPrimes]={2,3,5}; // 2,3,5 are prime
 *   for (n=1,i=0,j=3; j<NumberOfPrimes; ++i) // start search for primes
 *     n=n+c[i%8];           // use sieve to weed out obvious non-primes
 *     if (PrimeDecider(n))  // is n prime?
 *       primes[j++]=n;      // if so, put n in primes[]
 * The same technique could be used with the first 4 primes, or the first 5
 * primes, but the size of the cyclic group would get large rather quickly.
 * For example, using the first 4 primes, we get a "Method-Of-210s Sieve".
 * Of the first 210 positive integers, 46 are prime, so our cyclic group
 * would need to be of order 46.  That would be much messier than using
 * a cyclic group of order 8.  Therefore I use the "Method-Of-30s Sieve" in
 * my programs.
\****************************************************************************/

// End include guard:
#endif
