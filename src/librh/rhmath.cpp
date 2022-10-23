/// This is a 110-character-wide ASCII-encoded C++ source-code file.


/************************************************************************************************************\
 * Filename:             rhmath.cpp                                                                         *
 * Source For:           rhmath.o                                                                           *
 * Module description:   Math Functions, Templates, and Classes                                             *
 * Author:               Robbie Hatley                                                                      *
 * Date Written:         circa 2001                                                                         *
 * To use in program:    #include "rhmath.hpp"                                                              *
 *                       Link program with rhmath.o in librh.a                                              *
 * Notes:                See developement notes for Qsort<>() at end of rhmath.h                            *
 * Edit History:         Mon Jul 19, 2004                                                                   *
 *                       Sat Oct 02, 2004 - Added class Neighborhood .                                      *
 *                       Mon Oct 04, 2004 - corrected errors in Neighborhood; improved transform() .        *
 *                       Mon Jun 06, 2005 - Cleaned-up "using"s.  Now rhmath.h has no "using"s, and         *
 *                                          rhmath.cpp has "usings" up front, at global level.              *
 *                       Sun May 06, 2007 - Added #include of missing header <assert.h>.                    *
\************************************************************************************************************/

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <limits>
#include <list>
#include <assert.h>

//#define BLAT_ENABLE
#include "rhmath.hpp"

using std::cout;
using std::cerr;
using std::endl;
using std::pair;

// ===========================================================================================================
// Private functions for use by functions in this namespace:

// Count all occurences of characters from C-string C in string S:
std::string::size_type
rhmath::
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


// Does a given string represent an integer?
bool
rhmath::
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



// ========== Misc. Math. Functions: =========================================

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  double SnapToInt(double x, double p)                                                                    //
//                                                                                                          //
//  Snaps a floating-point value x to the nearest integer if it's within p of that integer                  //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

double
rhmath::
SnapToInt
   (
      double x,
      double p
   )
{
   double Fract = x - floor(x);

   // Assert that Fract is not more than one quadrillionth outside of the open interval (0,1) :
   assert(Fract > (0.0 - 1e-15));
   assert(Fract < (1.0 + 1e-15));
   // Note: if floating-point math was perfect, Fract would always obey 0 <= Fract < 1 .
   // However, floating-point math is NOT always perfect, so sometimes Fract can be outside of [0,1).
   // Specifically, if x is a very tiny negative value (say, 6.8e-18), then Fract can often be exactly 1.

   if      (Fract <    p    ) return floor(x); // If x is within p of lower integer, return lower integer.
   else if (Fract > (1 - p) ) return ceil(x);  // If x is within p of upper integer, return upper integer.
   else return x;                              // If x is NOT within p of an integer, return x unchanged.
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  class Matrix                                                                                            //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

rhmath::Matrix::Matrix(int M, int N) : m(M), n(N)
{
  BLAT("In " << rows << "x" << cols << " matrix parameterized constructor.")
  if(!(m>=1 && m<=100 && n>=1 && n<=100))
  {
    cerr << "Error: rows and columns for new matrix must be ";
    cerr << "at least 1 and at most 100." << endl;
    exit(1);
  }
  if (1==m && 1==n)
  {
    mat=new double;
    (*mat)=(0.0);
  }
  else
  {
    mat = new double [m*n];
    for (int i=0; i<m*n; ++i) {mat[i]=0.0;}
  }
}

rhmath::Matrix::Matrix(const Matrix &src)
{
  m=src.m;
  n=src.n;
  BLAT("In " << m << "x" << n << " matrix copy constructor.")
  if(!(m>0 && m<=100 && n>0 && n<=100))
  {
    cerr << "Error: rows and columns for copied matrix must be "
         << "at least 1 and at most 100."
         << endl;
    std::exit(1);
  }
  if (1==m && 1==n)
  {
    mat=new double;
    (*mat)=(*(src.mat));
  }
  else
  {
    mat = new double [m*n];
    for (int i=0; i<m*n; ++i) {mat[i]=src.mat[i];}
  }
}

rhmath::Matrix::~Matrix()
{
  BLAT("In " << m << "x" << n << " matrix destructor.")
  if (1==m && 1==n)
  {
    delete mat;
  }
  else
  {
    delete [] mat;
  }
}

int rhmath::Matrix::rows()
{
  return m;
}

int rhmath::Matrix::cols()
{
  return n;
}

double rhmath::Matrix::get(int row, int col)
{
  if (!(row>=1 && row<=m && col>=1 && col<=n))
  {
    cerr << "Error: subscript out of bounds in Matrix::get().\n"
         << "row = " << row << "   (must be from 1 to " << m << ")\n"
         << "col = " << col << "   (must be from 1 to " << n << ")"
         << endl;
    std::exit(1);
  }
  return mat[(row-1)*n+(col-1)];
}

void rhmath::Matrix::set(int row, int col, double val)
{
  if (!(row>=1 && row<=m && col>=1 && col<=n))
  {
    cerr << "Error: subscript out of bounds in Matrix::set().\n"
         << "row = " << row << "   (must be from 1 to " << m << ")\n"
         << "col = " << col << "   (must be from 1 to " << n << ")"
         << endl;
    exit(1);
  }
  mat[(row-1)*n+(col-1)]=val;
}

void rhmath::Matrix::operator=(const Matrix &src)
{
  BLAT("In " << m << "x" << n << " matrix assignment operator.")
  if (!(src.m==m && src.n==n))
  {
    cerr << "Error: attempt to assign a matrix to a matrix of different "
         << "shape!"
         << endl;
    exit(1);
  }
  for (int i=0; i<m*n; ++i) {mat[i]=src.mat[i];}
}

rhmath::Matrix rhmath::Matrix::operator+(const Matrix &src) const
{
  if (!(m==src.m && n==src.n))
  {
    cerr << "Error: attempt to add two different shapes of matrix!"
         << endl;
    exit(1);
  }
  Matrix temp (*this);
  for (int i=0; i<m*n; ++i) {temp.mat[i]=mat[i]+src.mat[i];}
  return temp;
}

rhmath::Matrix rhmath::Matrix::operator-(const Matrix &src) const
{
  if (!(m==src.m && n==src.n))
  {
    cerr << "Error: attempt to subtract two different shapes of matrix!"
         << endl;
    exit(1);
  }
  Matrix temp (*this);
  for (int i=0; i<m*n; ++i) {temp.mat[i]=mat[i]-src.mat[i];}
  return temp;
}

rhmath::Matrix rhmath::Matrix::operator*(const Matrix &src) const
{
  if (!(n==src.m))
  {
    cerr << "Error: attempt to multiply two incompatible shapes of matrix!"
         << endl;
    exit(1);
  }
  Matrix temp (m, src.n);
  double acc=0.0;
  for (int i=0; i<m; ++i)
  {
    for (int j=0; j<src.n; ++j)
    {
      acc=0.0;
      for (int k=0; k<n; ++k)
      {
        acc+=mat[i*n+k]*src.mat[k*src.m+j];
      }
      temp.mat[i*src.n+j]=acc;
    }
  }
  return temp;
}

rhmath::Matrix rhmath::Matrix::operator/(const double& d) const
{
  if (fabs(d) < 1.0E-15)
  {
    cerr << "Error: cannot divide matrix by zero." << endl;
    exit(1);
  }
  Matrix tempmat (m, n);
  for (int i=0; i<m*n; ++i)
  {
    tempmat.mat[i]=this->mat[i]/d;
  }
  return tempmat;
}

rhmath::Matrix rhmath::Matrix::minormatrix(int p1, int q1)
{
  // I'm defining the "minormatrix" of element (p1, q1) of a matrix to be
  // that matrix whose determinant is the (p1, q1) minor of the original
  // matrix.  This function is primarily for internal use by Matrix::det(),
  // but it can also be used directly, like this:
  // Matrix newmat=minormatrix(oldmat);
  if (!(m==n))
  {
    cerr << "Error: cannot obtain minormatrix of non-square matrix."
         << endl;
    exit(1);
  }
  if (!(p1>0 && p1<=m && q1>0 && q1<=n))
  {
    cerr << "Error: invalid coordinates for minormatrix."
         << endl;
    exit(1);
  }
  int i, j;
  Matrix minmat(n-1, n-1);
  for (i=1; i<p1; ++i)
  {
    for (j=1; j<q1; ++j)
    {
      minmat.set(i, j, get(i, j));
    }
    for (j=q1; j<=n-1; ++j)
    {
      minmat.set(i, j, get(i, j+1));
    }
  }
  for (i=p1; i<=n-1; ++i)
  {
    for (j=1; j<q1; ++j)
    {
      minmat.set(i, j, get(i+1, j));
    }
    for (j=q1; j<=n-1; ++j)
    {
      minmat.set(i, j, get(i+1, j+1));
    }
  }
  return minmat;
}

double rhmath::Matrix::minor(int p1, int q1)
{
  if (!(m==n))
  {
    cerr << "Error: cannot obtain minor of non-square matrix."
         << endl;
    exit(1);
  }
  if (!(p1>0 && p1<=m && q1>0 && q1<=n))
  {
    cerr << "Error: invalid coordinates for minor."
         << endl;
    exit(1);
  }
  return minormatrix(p1, q1).det();
}


double rhmath::Matrix::cofactor(int p1, int q1)
{
  if (!(m==n))
  {
    cerr << "Error: cannot obtain cofactor of non-square matrix."
         << endl;
    exit(1);
  }
  if (!(p1>0 && p1<=m && q1>0 && q1<=n))
  {
    cerr << "Error: invalid coordinates for cofactor."
         << endl;
    exit(1);
  }
  return (((p1+q1)%2)?(-1.0):(1.0))*minor(p1, q1);
}


double rhmath::Matrix::det()
{
  if (!(m==n))
  {
    cerr << "Error: cannot take determinant of non-square matrix."
         << endl;
    exit(1);
  }
  if (n<2)
  {
    cerr << "Error: cannot take determinant of matrix smaller than 2x2."
         << endl;
    exit(1);
  }
  if (n>10)
  {
    cerr << "Error: cannot take determinant of matrix larger than 10x10,\n"
         << "because of enormous number of calculations necessary."
         << endl;
    exit(1);
  }
  if (2==n)
  {
    return get(1,1)*get(2,2)-get(1,2)*get(2,1);
  }
  else
  {
    double acc=0;
    for (int j=1; j<=n; ++j)
    {
      acc+=get(1, j)*(((1+j)%2)?(-1.0):(1.0))*this->minormatrix(1, j).det();
    }
    return acc;
  }
}

rhmath::Matrix rhmath::Matrix::inv()
{
  if (!(m==n))
  {
    cerr << "Error: cannot invert non-square matrix."
         << endl;
    exit(1);
  }
  if (n<2)
  {
    cerr << "Error: cannot invert matrix smaller than 2x2."
         << endl;
    exit(1);
  }
  if (n>10)
  {
    cerr << "Error: cannot invert matrix larger than 10x10,\n"
         << "because of enormous number of calculations necessary."
         << endl;
    exit(1);
  }
  double d;
  d=this->det();
  if (fabs(d) < 1.0E-15)
  {
    cerr << "Error: cannot invert matrix with zero determinant."
         << endl;
    exit(1);
  }
  Matrix invmat (n, n);
  for (int i=1; i<=n; ++i)
  {
    for (int j=1; j<=n; ++j)
    {
      invmat.set(i, j, this->cofactor(j, i)/d);
    }
  }
  return invmat;
}


//========== Function Classes ================================================

// All of my function-class member functions are inline, so they are defined
// in rhmath.h, not here in rhmath.cpp.  For reference:


//========== Random-Number Functions =========================================

// All of my random-number functions are inline, so I declare and define them
// in rhmath.h rather than here in rhmath.cpp.


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//  class Neighborhood                                                                                      //
//  Holds matrices of pre-image and image points equally spaced within a rectangular neighborhood of E2.    //
//  This class should be especially useful in graphing iterated fractals, such as The Mandelbrot Set        //
//  or Julia sets, when one wishes to display a pixel color corresponding to the maximum number of          //
//  iterations lasted by any of a bunch of points less than one-half-pixel-width from the pixel.            //
//  This "shotgun" approach should darken thin, wispy filiments within such sets for better visibility.     //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

rhmath::
Neighborhood::
Neighborhood
(
   double x,           // x-coordinate of center point of neighborhood
   double y,           // y-coordinate of center point of neighborhood
   double xspan,       // width  of neighborhood
   double yspan,       // height of neighborhood
   int    granularity  // number of points per row or column (Defaults to 3; see rhmath.h .)
)
: Granularity(granularity)
{
   // We need to create a matrix of points equally spaced within a rectangular neighborhood.
   // Example matrix of granularity 5:
   //     -----------
   //     |* * * * *|
   //     |* * * * *|
   //     |* * * * *|
   //     |* * * * *|
   //     |* * * * *|
   //     -----------

   // Size matrix to (Granularity x Granularity):
   PreImage.resize(Granularity);      // # of rows = Granularity
   Image.resize(Granularity);         // # of rows = Granularity
   for (int i=0; i<Granularity; ++i)
   {
      PreImage[i].resize(Granularity);  // # of columns = Granularity
      Image[i].resize(Granularity);     // # of columns = Granularity
   }

   // Calculate the horizontal and vertical distances between adjacent points:
   double xgrain = xspan/Granularity; // distance between points, horizontally
   double ygrain = yspan/Granularity; // distance between points, vertically

   // Calculate the left and bottom edges of the pixel:
   double LeftEdge = x - xspan/2.0;
   double BottEdge = y - yspan/2.0;

   // Now calculate the coordinates of the points and store them in PreImage. (The outer-most points will be
   // xgrain/2.0 or ygrain/2.0 from the edges of the pixel.) Also take precautions to repair any corruption of
   // integers to non-integers by floating-point math errors. Also, set all Image values to zero.
   for(int j = 0; j < Granularity; ++j)
   {
      for(int i = 0; i < Granularity; ++i)
      {
         PreImage[j][i].first  = rhmath::SnapToInt((LeftEdge + xgrain/2.0 + i * xgrain), 1e-12);
         PreImage[j][i].second = rhmath::SnapToInt((BottEdge + ygrain/2.0 + j * ygrain), 1e-12);
         Image[j][i] = 0.0;
      }
   }
   return;
}

pair<double, double>
rhmath::
Neighborhood::
get_preimage(int i, int j)
{
   return PreImage[j][i];
}

void rhmath::Neighborhood::set_image(int i, int j, double val)
{
   Image[j][i] = val;
   return;
}

double rhmath::Neighborhood::get_image(int i, int j)
{
   return Image[j][i];
}

double rhmath::Neighborhood::maximum(void)
{
   double Maximum = Image[0][0];
   for (int j=0; j<Granularity; ++j)
   {
      for (int i=0; i<Granularity; ++i)
      {
         if (Image[j][i]>Maximum)
         {
            Maximum = Image[j][i];
         }
      }
   }
   return Maximum;
}

double rhmath::Neighborhood::minimum(void)
{
   double Minimum = Image[0][0];
   for (int j=0; j<Granularity; ++j)
   {
      for (int i=0; i<Granularity; ++i)
      {
         if (Image[j][i]<Minimum)
         {
            Minimum = Image[j][i];
         }
      }
   }
   return Minimum;
}

double rhmath::Neighborhood::average(void)
{
   double accum = 0;
   for (int j=0; j<Granularity; ++j)
   {
      for (int i=0; i<Granularity; ++i)
      {
         accum += Image[j][i];
      }
   }
   return accum/double(Granularity*Granularity);
}

void rhmath::Neighborhood::transform(double (*map)(int, double, double, int), int degree, int iterations)
{
   for (int j=0; j<Granularity; ++j)
   {
      for (int i = 0; i < Granularity; ++i)
      {
         Image[j][i] = map(degree, PreImage[j][i].first, PreImage[j][i].second, iterations);
      }
   }
}


//========== Class PrimeTable: ===============================================

// Define and initialize rhmath::PrimeTable::Wheel[48], which is an order-4
// wheel containing all 48 positive integers not greater than the product of
// the first 4 prime numbers (2*3*5*7 = 210) which are not divisible by
// any of the first 4 prime numbers (2,3,5,7):
const UL rhmath::PrimeTable::Wheel[48] =
{
     1,  11,  13,  17,  19,  23,  29,  31,  37,  41,
    43,  47,  53,  59,  61,  67,  71,  73,  79,  83,
    89,  97, 101, 103, 107, 109, 113, 121, 127, 131,
   137, 139, 143, 149, 151, 157, 163, 167, 169, 173,
   179, 181, 187, 191, 193, 197, 199, 209
};
/*
This array is a "Robbie Hatley Prime-Number Wheel Of Order 4", consisting of all of the natural 
numbers in the range [1, 2*3*5*7=210] which are NOT divisible by any of the first 4 prime numbers
(2, 3, 5, 7). 

If one arranges the entire natural number system {1,2,3,4,5,...} into a 210-column-wide grid 
with 1 in the upper-left corner and 210 in the upper-right, like so:

  1,   2,   3, ..., 208, 209, 210, 
211, 212, 213, ..., 418, 419, 420,
421, 422, 423, ..., 628, 629, 630,
...

Then ALL of the prime numbers will be in the columns headed by the 48 numbers in my "Wheel" array.
Thus I call those 48 numbers the "Prime Spokes" of my "Wheel". The columns under those 48 numbers
contain ALL of the prime numbers > 210 (along with some composites).

Whereas the columns under all of the OTHER members of [1,210] contain NO primes whatsoever! 
Hence I call those columns the "Composite Spokes" of my "Wheel".

Since only about 1/4 of the 210 columns are prime spokes, we can skip considering about 3 of 
every 4 natural numbers for primeness, because we already know they aren't prime.

Note that the top row of the wheel does NOT contain all of the primes in [1,210] (it's missing 2,3,5,7),
and NOT all of the numbers in the row are prime (1, 121, 143, 169, 187, and 209 are not prime), so the
number of primes in [1,210] is 48+4-6 = 46.

Thus the magic of my Wheel is thus not that it contains all of the primes in [1,210] (it doesn't), 
nor that all of its numbers are prime (they aren't), but rather that ALL prime numbers > 210 are 
UNDER THOSE 48 NUMBERS in the 210-column grid. THAT is the magic of my "Wheel".

Of course, various orders of wheels could be used (2, 3, 4, 5, 6, ...), and the higher orders do have the
advantage of allowing us to skip an even higher portion of the natural numbers from consideration; however,
the number of spokes in such wheels increase very rapidly:
Order 2: 2*3           =     6 spokes
Order 3: 2*3*5         =    30 spokes
Order 4: 2*3*5*7       =   210 spokes
Order 5: 2*3*5*7*11    =  2310 spokes
Order 6: 2*3*5*7*11*13 = 30030 spokes
Indeed, order 5 is already too unwieldy for my purposes, so I use order 4 for my PrimeTable class.
*/

// PrimeDecider()
// Returns true if n is prime, false if n is composite, WITHOUT having to first generate all prime numbers
// not greater than the square root of n.
bool rhmath::PrimeTable::PrimeDecider(UL n)
{
   UL  i       ; // Divisor index.
   UL  spoke   ; // Wheel spoke.
   UL  row     ; // Wheel row.
   UL  divisor ; // Divisor.
   UL  limit   ; // Upper limit for divisors to try.

   // If n is less than 2, n is composite:
   if (n<2) return false;

   // Check to see if n is one of the first 4 prime numbers:
   if (2==n||3==n||5==n||7==n) return true;

   // If n is divisible by any of the first 4 prime numbers, n is composite:
   if (!(n%2)||!(n%3)||!(n%5)||!(n%7)) return false;

   // Set limit to the greatest integer not greater than the square root of n:
   limit=Limit(n);

   // Only bother testing divisors which are on the prime spokes, because only they could possibly be 
   // prime numbers. Note that we start with i = 1 to avoid divisor 1, which ALL integers are divisible by;
   // instead, we start with divisor 210*0+Wheel[1], which is 11:
   for ( i = 1 ; ; ++i )
   {
      spoke   = i%48; // Modulo 48.
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      divisor = 210*row + Wheel[spoke];
      if (divisor > limit) return true;
      if (!(n%divisor)) return false;
   }
} // end rhmath::PrimeTable::PrimeDecider()


// GeneratePrimes()
// Generates the first n prime numbers.
void
rhmath::PrimeTable::
GeneratePrimes
   (
      UI    n,
      bool  bPrint,
      bool  bPush
   )
{
   UL  first_four[4]  = {2,3,5,7} ; // First 4 prime numbers.
   UL  i                          ; // Candidate index.
   UL  spoke                      ; // Wheel spoke.
   UL  row                        ; // Wheel row.
   UL  candidate                  ; // Prime candidate.
   UL  primes_so_far  = 0         ; // Number of primes found so far.

   // Since the first 4 prime numbers won't fit through the sieve,
   // they must be handled separately:
   for ( i = 0 ; i < 4 ; ++i )
   {
      candidate = first_four[i];

      // If we're finished, return:
      if (primes_so_far >= n) return;

      // Increment primes_so_far:
      ++primes_so_far;

      // Print current prime if requested:
      if (bPrint)
      {
         cout << std::setw(10) << candidate << endl;
      }

      // Push current prime onto list if requested:
      if (bPush)
      {
         Primes.push_back(candidate);
      }
   } // end for (each of the first 4 primes)

   // Check the natural numbers on the prime spokes for primeness:
   for ( i = 1 ; primes_so_far < n ; ++i )
   {
      spoke     = i%48; // Modulo 48.
      row       = i/48; // Integer division by 48.
      candidate = 210*row + Wheel[spoke];

      BLAT("In GeneratePrimes() main for loop;")
      BLAT("now considering candidate: " << candidate << "\n")

      // If candidate is prime, increment primes_so_far,
      // print if requested, and push onto list if requested:
      if (PrimeDecider(candidate))
      {
         BLAT("In GeneratePrimes() main for loop;")
         BLAT("found prime number: " << candidate << "\n")

         // Increment primes_so_far:
         ++primes_so_far;

         // Print this prime if so requested:
         if (bPrint)
         {
            cout << std::setw(10) << candidate << endl;
         }

         // Push this prime onto list if so requested:
         if (bPush)
         {
            Primes.push_back(candidate);
         }
      } // end if (candidate is prime)
   } // end for (each candidate)

   // We're finished, so scram:
   return;
} // end rhmath::PrimeTable::GeneratePrimes()


// GeneragePrimesInRange()
// Generates all prime numbers in the range [a,b], and returns their sum:
UL                    // Return sum of all primes in range.
rhmath::PrimeTable::
GeneratePrimesInRange
   (                  // Generate all prime numbers which are
      UL    a,        // not  less   than a and
      UL    b,        // not greater than b.
      bool  bPrint,   // Print them one-at-a-time as they are generated?
      bool  bPush     // Push them onto a list for future reference?
   )
{
   UL  first_four[4]   = {2,3,5,7}; // First 4 prime numbers.
   UL  i               = 0;         // Sieve index.
   UL  spoke           = 0;         // Wheel spoke.
   UL  row             = 0;         // Wheel row.
   UL  candidate       = 0;         // Prime candidate.
   UL  PrimeSum        = 0;         // Sum of all prime number in [a,b].

   // Since the first 4 prime numbers won't fit through the sieve,
   // they must be handled separately:
   if (a < 8)
   {
      for ( i = 0 ; i < 4 ; ++i )
      {
         candidate = first_four[i];

         // If below range, continue to next:
         if (candidate < a) continue;

         // If above range, break out of loop:
         if (candidate > b) break;

         // If we get to here, include current prime in
         // whatever we're doing (print, store, sum).

         // Print current prime if requested:
         if (bPrint)
         {
            cout << std::setw(20) << candidate << endl;
         }

         // Push current prime onto list if requested:
         if (bPush)
         {
            Primes.push_back(candidate);
         }

         // Add current prime to PrimeSum:
         PrimeSum += candidate;

      } // end for (each of the first 4 primes)

   } // end if (a < 8)

   // Now that we've separately considered the first 4 prime numbers for inclusion in our set (provided a was
   // less than 8), let's consider all the other numbers in the range [a,b] which are on the prime spokes of
   // our wheel. But we need to start at the beginning of a wheel row in order to synch with the wheel.
   // (Unless it's row 0, in which case we start at spoke 1 instead of spoke 0, to avoid 1).
   // Integer-divide a by 210 to get starting wheel row:
   row = a/210;

   // Multiply row by 48 to get starting candidate index:
   i = row*48;

   // But if i is now 0, set it to 1 instead to avoid
   // dividing by (210*0+sieve[0]) = 1 (which is a divisor of ALL numbers):
   if ( 0 == i ) i = 1;

   // Check those natural numbers which fit through the sieve,
   // and which are in-range, for primeness:
   for ( ; ; ++i )
   {
      spoke     = i%48; // Modulo 48.
      row       = i/48; // Integer division by 48.
      candidate = 210*row + Wheel[spoke];

      BLAT("In GeneratePrimesInRange() main for loop;")
      BLAT("about to check this candidate for range: " << candidate << "\n")

      // If below range, continue to next:
      if (candidate < a) continue;

      // If above range, break out of loop:
      if (candidate > b) break;

      BLAT("In GeneratePrimesInRange() main for loop;")
      BLAT("about to check this candidate for primeness: " << candidate << "\n")

      // If we get to here, candidate is in-range.

      // If candidate is prime, include it in our set:
      if (PrimeDecider(candidate))
      {
         BLAT("In GeneratePrimesInRange() main for loop;")
         BLAT("Found prime number " << candidate << "\n")

         // Print this prime if requested:
         if (bPrint)
         {
            cout << std::setw(20) << candidate << endl;
         }

         // Push this prime onto list if requested:
         if (bPush)
         {
            Primes.push_back(candidate);
         }

         // Add this prime to PrimeSum:
         PrimeSum += candidate;

      } // end if (candidate is prime)
   } // end for (each candidate)

   // We're finished, so scram:
   return PrimeSum;
} // end rhmath::PrimeTable::GeneratePrimesInRange()


UL rhmath::PrimeTable::Limit(UL n)
{
   return UL(floor(1.0001*sqrt(double(n))));
}


//========== Class BigNum: ===================================================

// (In addition to the functions defined here, see the BigNum constructors, 
// methods, and operators defined in file "rhmath.hpp".)

// Get g and n from source string (private function member of BigNum):
void rhmath::BigNum::ParseSourceString(std::string const & SrcStr)
{
   // Strip-and-record '+' sign, if any:
   if ('+' == SrcStr[0])
   {
      g = false;
      n = SrcStr.substr(1);
   }

   // Strip-and-record '-' sign, if any:
   else if ('-' == SrcStr[0])
   {
      g = true;
      n = SrcStr.substr(1);
   }

   // Else the first character of n is not a sign, so assume positive for now:
   else
   {
      g = false;
      n = SrcStr;
   }

   // The string representation of the number should now contain only digits.
   // If this is not the case, reset sign to false and representation to "0":
   if (std::string::npos != n.find_first_not_of("0123456789"))
   {
      cerr << "Invalid string \"" << SrcStr << "\" in BigNum::ParseSourceString();" << endl
           <<"reverting to zero." << endl;
      g = false;
      n = std::string("0");
   }

   // If n is more than one character long, n should not start with a zero.
   // While it does, strip-off the extra zero(s):
   while (n.size() > 1 && '0' ==  n[0])
   {
      n = n.substr(1);
   }

   return;
}


// Is a == b?
inline bool rhmath::operator==(const BigNum& a, const BigNum& b)
{
   return ( a.neg() == b.neg() && a.str() == b.str() );
}


// Is a < b?
bool rhmath::operator<(const BigNum& a, const BigNum& b)
{
        if ( a.neg() && !b.neg())          {return true; }  // a is negative
   else if (!a.neg() &&  b.neg())          {return false;}  // b is negative
   else if ( a.neg() &&  b.neg())                           // both are negative
   {
      if (a.str().size() > b.str().size()) {return true; }
      if (a.str().size() < b.str().size()) {return false;}
      if (a.str()        > b.str()       ) {return true; }
      else                                 {return false;}
   }
   else                                                     // neither is negative
   {
      if (a.str().size() < b.str().size()) {return true; }
      if (a.str().size() > b.str().size()) {return false;}
      if (a.str()        < b.str()       ) {return true; }
      else                                 {return false;}
   }
}


// Return the additive inverse of a BigNum integer:
rhmath::BigNum rhmath::operator-(const BigNum& a)
{
   if (std::string("0") == a.str())     // If a is zero,
   {
      return BigNum(0);                 // return zero;
   }
   else if (a.neg())                    // else if a is negative,
   {
      return BigNum (a.str());          // return positive number of magnitude a;
   }
   else                                 // else if a is positive,
   {
      return BigNum ('-' + a.str());    // return negative number of magnitude a.
   }
}

// BigNum Addition:
rhmath::BigNum rhmath::operator+(const BigNum& a, const BigNum& b)
{
   BLAT("Just entered BigNum addition operator.")
   if ( a.neg() && !b.neg()) {return  (( b)-(-a));} // result could go either way
   if (!a.neg() &&  b.neg()) {return  (( a)-(-b));} // result could go either way
   if ( a.neg() &&  b.neg()) {return -((-a)+(-b));} // result will always be negative
   if (!a.neg() && !b.neg()) {goto BOTH_NON_NEG  ;} // result will always be positive

   BOTH_NON_NEG:
   // If we get to here, a and b are both non-negative integers.

   // Get sizes of a and b:
   long a_size = a.str().size();
   long b_size = b.str().size();

   // Get necessary size for C:
   long C_size = 1;
   if (a_size > C_size) {C_size = a_size;}
   if (b_size > C_size) {C_size = b_size;}
   C_size += 1;

   BLAT("In operator+().  Just got sizes.")
   BLAT("   a_size = " << a_size << "   b_size = " << b_size << "   C_size = " << C_size)

   // Make a string of 0s of length C_size:
   std::string C (C_size, '0');

   long  i      = 1;
   long  accum  = 0;
   long  carry  = 0;

   while ( i <= C_size )
   {
      // Reset Accumulator:
      accum = 0;

      if (i <= a_size) accum += ctol(a.str()[a_size - i]);
      if (i <= b_size) accum += ctol(b.str()[b_size - i]);
      if (carry > 0  ) accum += carry;

      // Reset carry:
      carry = 0;

      // If overflow occured, transfer overflow to carry:
      while (accum > 9) {carry += 1; accum -= 10;}

      // Sanity check: assert that value in accumulator is >= 0 and <= 9:
      assert(accum >= 0 && accum <= 9);

      // Insert character representation of accumulator in C:
      C[C_size - i] = ltoc(accum);

      // Move on to next-higher place value:
      ++i;
   }
   BLAT("About to return from BigNum addition operator.")
   BLAT("   a = " << a << ", b = " << b << ", C = " << C)
   return BigNum(C);
}

// BigNum Subtraction:
rhmath::BigNum rhmath::operator-(const BigNum& a, const BigNum& b)
{
   BLAT("Just entered BigNum subtraction operator.")

   // Triage center: decide what to do based on signs of operands:
   if ( a.neg() && !b.neg()) {return -((-a)+( b));} // result will always be negative
   if (!a.neg() &&  b.neg()) {return  (( a)+(-b));} // result will always be positive
   if ( a.neg() &&  b.neg()) {return  ((-b)-(-a));} // result could go either way
   if (!a.neg() && !b.neg()) {goto BOTH_NON_NEG  ;} // result could go either way

   BOTH_NON_NEG:
   // If we get to here, a and b are both non-negative integers.

   // If a < b, we can't subtract (a-b), so use the algebraically-equivalent -(b-a) instead:
   if (a < b) {return -(b-a);}

   // Get sizes of a and b:
   long a_size = a.str().size();
   long b_size = b.str().size();

   // Sanity check: assert that a_size >= b_size and a_size > 0:
   assert(a_size >= b_size && a_size > 0);

   // Make a string of 0s of length a_size (no need for padding, because a-b < a):
   std::string C (a_size, '0');

   long  i       = 1;
   long  accum   = 0;
   long  borrow  = 0;

   while (i <= a_size)
   {
      accum = ctol(a.str()[a_size - i]);
      if (i <= b_size) accum -= ctol(b.str()[b_size - i]);
      if (borrow) accum -= borrow;

      // Reset borrow:
      borrow = 0;

      // If underflow occured, transfer underflow to borrow:
      while (accum < 0) {borrow += 1; accum += 10;}

      // Sanity check: assert that value in accumulator is >= 0 and <= 9:
      assert(accum >= 0 && accum <= 9);

      // Insert character representation of accumulator in C:
      C[a_size - i] = ltoc(accum);

      // Move on to next-higher place value:
      ++i;
   }

   // Sanity check: make sure that last pass through loop left borrow equal to zero:
   assert(0 == borrow);

   BLAT("About to return from BigNum subtraction operator.")
   BLAT("   a = " << a << ", b = " << b << ", C = " << C)
   return BigNum(C);
}

// BigNum Multiplication:
rhmath::BigNum rhmath::operator*(const BigNum& a, const BigNum& b)
{
   BLAT("Just entered operator*().")
   BLAT("a = " << a)
   BLAT("b = " << b)

   long  i      = 0;
   long  j      = 0;
   long  k      = 0;
   long  carry  = 0;

   // Get sizes of a, b:
   long a_size = a.str().size();
   long b_size = b.str().size();

   // a < 10^n && b < 10^m => ab < 10^(n+m):
   long c_size = a_size + b_size;

   // Allow one extra character in s_size for sign:
   long s_size = c_size + 1;

   BLAT("In operator*().  Just calculated sizes.")
   BLAT("a_size = " << a_size << "   b_size = " << b_size << "   c_size = " << c_size)

   // Make an accumulator array with 0th element representing LOWEST place value:
   long * accum = NULL;
   accum = static_cast<long *>(malloc(c_size*sizeof(long)));
   assert(NULL != accum);
   memset(accum, 0, c_size*sizeof(long));

   // Perform multiplication of all digits of a with all digits of b, placing results into the
   // appropriate place-value slots of the accumulator, letting all overflows accumulate:
   for ( i = 0 ; i < a_size ; ++i)
   {
      for ( j = 0 ; j < b_size ; ++j)
      {
         accum[i+j] += ctol(a.str()[a_size - 1 - i]) * ctol(b.str()[b_size - 1 - j]);
      }
   }

   for ( k = 0 ; k < c_size ; ++k )
   {
      BLAT("In operator*() before carrying.  accum[" << k << "] = " << accum[k])
   }

   // Make sure carry is zero immediately before heading into next for loop:
   carry = 0;

   // Now, rectify the overflows by carrying each overflow to the next-higher place value:
   for ( k = 0 ; k < c_size ; ++k )
   {
      // Add carry from next-lower place value to this place value:
      accum[k] += carry;

      // Reset carry:
      carry = 0;

      // Move overflow from current place value to carry:
      while (accum[k] > 9) {++carry; accum[k]-=10;}
   }

   // Sanity check - assert that all digits in accumulator are in interval [0,9]:
   for ( k = 0 ; k < c_size ; ++k )
   {
      BLAT("In operator*().  accum[" << k << "] = " << accum[k])
      assert(accum[k] >= 0 && accum[k] <= 9);
   }

   // Make a string to hold the representation of the number:
   std::string s (s_size, '0');

   // Write the digits of c from accum to s:
   for ( k = 0 ; k < c_size ; ++k )
   {
      s[s_size - 1 - k] = ltoc(accum[k]);
   }

   // Free accumulator:
   if (accum) {free(accum);}
   
   // c will be negative iff a and b have opposite signs:
   s[0] = ( a.neg() ^ b.neg() ) ? '-' : '0';

   // Create c from s:
   BigNum c (s);

   BLAT("About to return from operator*().")
   BLAT("c = " << c)

   // Return c:
   return c;
}

// BigNum Division (integer division, discards remainder):
rhmath::BigNum rhmath::operator/(const BigNum& a, const BigNum& b)
{
   BigNum c (10^(a.str().size() - b.str().size()));
   return c;       // ECHIDNA : STUB
}

// BigNum Modulus (remainder after integer division):
rhmath::BigNum rhmath::operator%(const BigNum& a, const BigNum& b)
{
   BigNum c (0);
   // (a.neg() xor b.neg()) ? c :   ???  ECHIDNA : what was I doing here?
   return a - (b * (a / b));
}


// ======= (OBSOLETE) Number Bases (OBSOLETE) ================================================================


///////////////////////////////////////////////////////////////////////////
//                                                                       //
//  (OBSOLETE) Base (OBSOLETE)                                           //
//  Represent an integer in any base from 2 to 36.                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////

// Now renamed "RepresentInBase" and completely rewritten in C for numbers of type "uint64_t" only, 
// and moved from module "rhmath" to module "rhmathc".



// ======= Combinatorial Analysis: ===========================================================================

long rhmath::Pow(long x, long y)
{
   long Accum = 1;
   for ( long i = 0 ; i < y ; ++i) {Accum *= x;}
   return Accum;
}

long rhmath::Fact(long x)
{
   long Accum = 1;
   for ( long i = 2 ; i <= x ; ++i ) {Accum *= i;}
   return Accum;
}

long rhmath::Perm(long x, long y)
{
   long Accum = 1;
   for ( long i = 1 ; i <= y ; ++i )
   {
      Accum *= (x - y + i);
   }
   return Accum;
}

long rhmath::Comb(long x, long y)
{
   // Comb(x,y) should equal x!/((x-y)!y!).

   // If y is more than one-half of x, use Comb(x, x-y) instead.
   // (Ie, always use the left half of the Pascal triangle.)
   if ( double(y) > (double(x) / 2.0) ) return Comb(x, x-y);

   long Accum = 1;
   for ( long i = x-y+1 ; i <= x ; ++i ) {Accum *= i;}
   for ( long i = 2     ; i <= y ; ++i ) {Accum /= i;}

   return Accum;
}
