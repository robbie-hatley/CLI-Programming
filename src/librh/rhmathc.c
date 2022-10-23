/// This is a 110-character-wide ASCII-encoded C++ source-code file.

/************************************************************************************************************\
 * Filename:             rhmathc.c
 * Source For:           rhmathc.o
 * Module description:   Math functions in C (not C++).
 * Author:               Robbie Hatley
 * Date Written:         Thu Feb 15, 2018.
 * To use in program:    #include "rhmathc.h"
 *                       Link program with rhmathc.o in librhc.a
 * Edit History:         Thu Feb 15, 2018: Created it.
\************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
#include <assert.h>
#include <limits.h>
#include <float.h>
#include <errno.h>
#include <error.h>
#include <assert.h>
#include <stdint.h>
#include <gmp.h>

//#define BLAT_ENABLE
#undef  BLAT_ENABLE

#include "rhdefines.h"
#include "rhmathc.h"

// First four prime numbers:
const uint64_t FirstFour[4] = {2,3,5,7};

// Order-4 Prime Wheel, containing those 48 elements of the set {2, 3, 4 ... 209, 210, 211} which are not
// divisible by any of the first 4 prime numbers (2,3,5,7):
const uint64_t Wheel[48] =
{
    11,  13,  17,  19,  23,  29,  31,  37,  41,  43,
    47,  53,  59,  61,  67,  71,  73,  79,  83,  89,
    97, 101, 103, 107, 109, 113, 121, 127, 131, 137,
   139, 143, 149, 151, 157, 163, 167, 169, 173, 179,
   181, 187, 191, 193, 197, 199, 209, 211
};
// This array is a "Prime Number Wheel Of Order 4". Its columns are a subset of the columns of an arrangment 
// of the set of "all integers > 1" ({2,3,4,5,6,...}) into a rectangular grid with width equal to the product
// of the first first 4 prime numbers (2*3*5*7 = 210):
// 
//   2   3   4   5   6 ... 207 208 209 210 211
// 212 213 214 215 216 ... 417 418 419 420 421
// 422 423 424 425 426 ... 627 628 629 630 631
// (etc, etc, etc, ad-infinitum)
// 
// If the integers > 1 are so arranged, ALL of the primes will be in the columns headed by the 48 numbers in
// the "Wheel". Those 48 columns of the 210-column "Grid" constitute the "prime spokes" of "Wheel", and they
// contain ALL of the prime numbers (along with some composites).  All of the other columns combined
// constitute the "composite spokes" of "Wheel", and contain NO prime numbers at all, only composites.  
// Since only about 1/4 of the columns of Grid are in Wheel, we can skip considering about 3 of every 4
// natural numbers for primeness, because we already know they aren't prime.
//
// Of course, other orders of wheels could be used (2, 3, 4, 5, 6, ...), and the higher orders do have the
// advantage of allowing us to skip an even higher portion of the natural numbers from consideration; however,
// the number of spokes in such wheels increase very rapidly:
// Order 2: 2*3           =     6 spokes
// Order 3: 2*3*5         =    30 spokes
// Order 4: 2*3*5*7       =   210 spokes
// Order 5: 2*3*5*7*11    =  2310 spokes
// Order 6: 2*3*5*7*11*13 = 30030 spokes
// Indeed, order 5 is already too unwieldy for my purposes, so I use order 4 for my PrimeTable class.

/* Integer power: */
uint64_t IntPow (uint64_t a, unsigned b)
{
   unsigned i;
   uint64_t power = 1;
   for ( i = 1 ; i <= b ; ++i ) 
   {
      if (UINT64_MAX / power < a)
      {
         errno = ERANGE;
         return 0;
      }
      power *= a;
   }
   return power;
} // end IntPow()

/* Integer Square Root: */
uint64_t IntSqrt (uint64_t n)
{
   uint64_t i = 1UL;
   while ( i * i <= n )
   {
      ++i;
   }
   return i - 1UL;
} // end InSqrt()

// IsPrime()
// Returns true if n is prime, false if n is composite, WITHOUT having to first generate all prime numbers
// not greater than the square root of n.
bool IsPrime (uint64_t n)
{
   uint64_t  i       ; // Divisor index.
   uint64_t  spoke   ; // Wheel spoke.
   uint64_t  row     ; // Wheel row.
   uint64_t  divisor ; // Divisor.
   uint64_t  limit   ; // Upper limit for divisors to try.

   // If n is less than 2, n is composite:
   if (n<2) return 0;

   // If n is one of the first 4 prime numbers, n is prime:
   if (2==n||3==n||5==n||7==n) return true;

   // If n is divisible by any of the first 4 prime numbers, n is composite:
   if ( 0 == n%2 || 0 == n%3 || 0 == n%5 || 0 == n%7 ) return false;

   // Set limit to the greatest integer not greater than the square root of n:
 //limit = IntSqrt(n); // SLOW!
   limit = (uint64_t)floor(sqrt((double)n));

   // Only bother testing divisors which are on the prime spokes, 
   // because only they could possibly be prime numbers:
   for ( i = 0 ; ; ++i )
   {
      row     = i/48; // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      spoke   = i%48; // Modulo 48.
      divisor = 210*row + Wheel[spoke];
      if (divisor > limit) break;
      if (!(n%divisor)) return false;
   }
   return true;
} // end IsPrime()

// IsPrimeUnlimited()
// Returns true if n is prime, false if n is composite, WITHOUT having to first
// generate a table of all prime numbers not greater than the square root of n.
// This version is based on GMP and has unlimited accuracy.
bool IsPrimeUnlimited (mpz_t n)
{
   uint64_t spoke; // Wheel spoke.

   mpz_t i         ; // divisor index.
   mpz_t row       ; // Wheel row #.
   mpz_t radius    ; // Spiral radius = 210 * row.
   mpz_t divisor   ; // Divisor = radius + Wheel[spoke].
   mpz_t remainder ; // Remainder = n % divisor
   mpz_t limit     ; // Upper limit for divisors to try.

   mpz_init(i);
   mpz_init(row);
   mpz_init(radius);
   mpz_init(divisor);
   mpz_init(remainder);
   mpz_init(limit);

   // If n is one of the first 4 prime numbers,
   // then n is prime, so return true:
   if
   (
      0==mpz_cmp_ui(n,2UL)
      ||
      0==mpz_cmp_ui(n,3UL)
      ||
      0==mpz_cmp_ui(n,5UL)
      ||
      0==mpz_cmp_ui(n,7UL)
   )
   return true;

   // If n is divisible by any of the first 4 prime numbers, 
   // then n is composite, so return false:
   if
   (
      mpz_divisible_ui_p(n,2UL)
      ||
      mpz_divisible_ui_p(n,3UL)
      ||
      mpz_divisible_ui_p(n,5UL)
      ||
      mpz_divisible_ui_p(n,7UL)
   )
   return false;

   // Set limit to the greatest integer not greater than the square root of n:
   mpz_sqrt(limit,n);

   // Only bother testing divisors which are on the prime spokes, 
   // because only they could possibly be prime numbers:
   for ( mpz_set_ui(i,0) ; ; mpz_add_ui(i,i,1) )
   {
      spoke = mpz_fdiv_ui(i,48); // Modulo 48.
      mpz_fdiv_q_ui(row,i,48); // Integer division by 48 (ie, 47/48 is 0; 87/48 is 1).
      mpz_mul_ui(radius,row,210); // radius = 210*row
      mpz_add_ui(divisor,radius,Wheel[spoke]); // divisor = radius + Wheel[Spoke]
      if (mpz_cmp(divisor,limit) > 0) return true;  // n is prime
      if (mpz_divisible_p(n,divisor)) return false; // n is composite
   }
} // end IsPrimeUnlimited()

// How many combinations of k things from a set of n exist?
unsigned long comb (unsigned long n, unsigned long k)
{
   unsigned long num = 1;
   unsigned long den = 1;
   unsigned long i   = 0;
   for ( i = n - k + 1 ; i <= n ; ++i )
   {
      num *= i;
   }
   for ( i = 1 ; i <= k ; ++i )
   {
      den *= i;
   }
   return num/den;
} // end comb

// Concatenate two integers:
uint64_t CatNums (uint64_t a, uint64_t b)
{
   char buffera [25] = {'\0'};
   char bufferb [25] = {'\0'};
   char bufferc [50] = {'\0'};
   sprintf(buffera, "%lu", a);
   sprintf(bufferb, "%lu", b);
   strcpy (bufferc, buffera);
   strcat (bufferc, bufferb);
   return strtoul(bufferc, NULL, 10);
} // end CatNum()

/* Are two prime numbers a "prime pair"? */
bool IsPrimePair (uint64_t a, uint64_t b)
{
   return IsPrime(CatNums(a,b)) && IsPrime(CatNums(b,a));
} // end IsPrimePair()

/* Reverse a positive integer: */
uint64_t ReverseNumber (uint64_t n)
{
   char Buffer1 [25] = {0};
   char Buffer2 [25] = {0};
   size_t Length = 0;
   size_t i = 0;

   sprintf(Buffer1, "%lu", n);
   Length = strlen(Buffer1);
   for ( i = 0 ; i < Length ; ++i )
   {
      Buffer2[Length - 1 - i] = Buffer1[i];
   }
   return strtoul(Buffer2, NULL, 10);
} // end ReverseNumber()

#if 0
// Rotate a number rightward: 
mpz_t RotateNumberRight (mpz_t x)
{
   mpz_t y;
   mpz_init(y);
   return y;
}

// Rotate a number leftward: 
mpz_t RotateNumberLeft (mpz_t x)
{
   mpz_t y;
   mpz_init(y);
   return y;
}
#endif

/* Is a given number palindromic? */
bool IsPalindrome (uint64_t n)
{
   char Buffer [25] = {0};
   size_t Length = 0;
   size_t Half = 0;
   size_t i = 0;

   sprintf(Buffer, "%lu", n);
   Length = strlen(Buffer);
   Half = Length / 2 - 1;
   for ( i = Half ; i != 0 ; --i )
   {
      if (Buffer[i] != Buffer[Length - 1 - i]) return false;
   }
   return true;
} // end IsPalindrome()

// Determine the number of digits necessary to represent 
// a given number in a given base:
unsigned NumberOfDigits (uint64_t Number, unsigned Base)
{
   unsigned Digits = 1;
   uint64_t Power  = 1;
   /*
   The following can't over-flow Power, because the "while" condition,
   while it remains true, implies the following:
   (Number/Power (float div)) >= (Number/Power (int div)) >= Base;
   hence (Power times Base) <= Number;
   hence Power can be increased by at least 1 additional factor of Base
   and still be <= than Number. 
   Hence when the "while" condition finally FAILS, 
   Number/Power will be < Base and >= 1, and hence Power <= Number <= 2^64-1.
   */ 
   while ( Number / Power >=  Base )
   {
      ++Digits;
      Power *= Base;
      BLAT("\nIn NumberOfDigits(), at bottom of while loop;\n")
      BLAT("Number = %lu, Base  = %u,\n", Number, Base)
      BLAT("Digits = %u, Power = %lu.\n", Digits, Power)
   }
   return Digits;
} // end NumberOfDigits()

// What is the numeric value of a character matching /[0-1A-Za-z\/]/ if it is interpreted as being
// a character of a representation of a positive integer in a base in the 2-64 range?
unsigned CharToValue (char Char)
{
   if (Char >= '0' && Char <= '9')          // Numeric values 0 through 9
   {
      return (unsigned)(Char - '0');
   }
   else if (Char >= 'A' && Char <= 'Z')     // Numeric values 10 through 35
   {
      return (unsigned)(10 + Char - 'A');
   }
   else if (Char >= 'a' && Char <= 'z')     // Numeric values 36 through 61
   {
      return (unsigned)(36 + Char - 'a');
   }
   else if (Char == '\\')
   {
      return (unsigned)(62);
   }
   else if (Char == '/')
   {
      return (unsigned)(63);
   }
   else
   {
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error in CharToValue: illegal character"
      );
      return 666; // can't execute but shuts-up warning
   }
}

// Convert an ASCII string representation of an integer (base 2-64)
// to a long unsigned int:
uint64_t StringToNumber
   (
      char *     String, // string representation of integer (<= 2^64-1)
      unsigned   Base    // base of integer (2-64)
   )
{
   unsigned    Index         = 0;     // index of character
   size_t      Length        = 0;     // length of string
   unsigned    LastDigit     = 0;     // index of last digit
   char        Char          = '\0';  // a character from string
   uint64_t    Value         = 0;     // value of character
   uint64_t    Power         = 0;     // Base**Index
   uint64_t    Term          = 0;     // Value * Power
   uint64_t    Number        = 0;     // value of number
   const uint64_t Max = UINT64_MAX;   // maximum number we can handle

   Length = strlen(String);
   if (Length < 1 || Length > 64)
   {
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error in StringToNumber: Length < 1 or Length > 64"
      );
   }
   LastDigit = (unsigned)(Length - 1);
   for ( Index = 0 ; Index <= LastDigit ; ++Index )
   {
      Char = String[Index];
      Value = CharToValue(Char);
      if (Value >= Base)
      {
         error
         (
            EXIT_FAILURE, 
            0, 
            "Error in StringToNumber: illegal character for given base"
         );
      }
      errno = 0;
      Power = IntPow(Base, LastDigit-Index);
      if (ERANGE == errno) {return 0;}
      if (Max / Power < Value) {errno = ERANGE; return 0;}
      Term = Value * Power;
      if (Max - Number < Term) {errno = ERANGE; return 0;}
      Number = Number + Term;
   }
   return Number;
}

/* Represent an integer in any base from 2 to 62: */
void RepresentInBase
   (
      uint64_t   Number,    // must be in range [0,2**64-1]
      unsigned   Base,      // must be in range [2,64]
      unsigned   MaxDigits, // BufferSize-1 ; must be in range [1,64]
      bool       Zeros,     // does user want leading zeros?
      char     * Buffer     // Buffer size MUST be >= MaxDigits+1. Recommend 65.
   )
{
   const char  Numerals[65]
      = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\\/";
   unsigned    Digits         = 0; // ACTUAL digits needed.
   unsigned    LeftDigit      = 0; // Index of left-most digit.
   unsigned    RghtDigit      = 0; // Index of right-most digit.
   unsigned    Index          = 0; // digit index
   uint64_t    Place          = 0; // 2**(RevColIdx)
   uint64_t    Value          = 0; // digit value of Number in Base at Index
   uint64_t    Remainder      = 0; // remainder after slicing chunks from Number

   // We don't have to worry about "Number" being out-of-range, because 
   // because C's strict type system means it will always be "in-range"
   // FROM THIS FUNCTION'S POV, even if it overflowed or underflowed  in 
   // the calling function. 
   // 
   // "Base" and "MaxDigits", however, we need to check the size of:
   if (Base < 2 || Base > 64) 
   {
      error
      (
         EXIT_FAILURE, 
         0, 
         "Error in RepresentInBase: \"Base\" is out of range.\n"
         "\"Base\" must be in the closed interval [2, 64].\n"
      );
   }
      
   if (MaxDigits < 1 || MaxDigits > 64)
   {
      error
      (
         EXIT_FAILURE, 
         0,
         "Error in RepresentInBase: \"MaxDigits\" is out of range.\n"
         "\"MaxDigits\" must be in the range of [1,64], and buffer\n"
         "size must be at least one greater than \"MaxDigits\".\n"
      );
   }

   // Determine number of digits necessary to represent 
   // given number in given base:
   Digits = NumberOfDigits(Number, Base);

   // If we need more columns than requested, that's an error:
   if (Digits > MaxDigits)
   {
      error
      (
         EXIT_FAILURE,
         0,
         "Error in RepresentInBase: can't represent given number with\n"
         "given number of digits.\n"
      );
   }

   // If using zeros, and MaxDigits > Digits, 
   // set LeftDigit to number of zeros written,
   // set RghtDigit to index of right-most writable character of Buffer,
   // right-justify, 
   // and write zero padding:
   if (Zeros && (MaxDigits > Digits))
   {
      LeftDigit = MaxDigits - Digits;
      RghtDigit = MaxDigits - 1;
      for ( Index = 0 ; Index < LeftDigit ; ++Index )
      {
         Buffer[Index] = '0';
      }
   }
   // Otherwise,
   // set LeftDigit to zero,
   // set RghtDigit to Digits - 1,
   // left-justify, 
   // and don't write zeros:
   else
   {
      LeftDigit = 0;
      RghtDigit = Digits - 1;
   }

   // Repeatedly slice-off the Most-Significant Digit (MSD) in base Base of 
   // number Number and write each current MSD to buffer:
   Remainder = Number;
   for ( Index = LeftDigit ; Index <= RghtDigit ; ++Index)
   {
      BLAT("\nIn RepresentInBase(), at top of for loop.\n" )
      BLAT("Index     = %d\n",  Index                      )
      BLAT("Remainder = %lu\n", Remainder                  )
      BLAT("Place     = %lu\n", Place                      )
      BLAT("Value     = %lu\n", Value                      )
      BLAT("Numeral   = %c\n",  Numerals[Value]            )

      // Set Place = place-value of most-significant digit:
      Place = IntPow(Base, RghtDigit - Index);

      // Get current MSD from integer division:
      Value = Remainder / Place;

      // Write current MSD to buffer:
      Buffer[Index] = Numerals[Value];

      // Slice current MSD from Remainder, since we already printed it:
      Remainder -= Value * Place;

      BLAT("\nIn RepresentBase, at bottom of for loop.\n"  )
      BLAT("Index     = %d\n",  Index                      )
      BLAT("Remainder = %lu\n", Remainder                  )
      BLAT("Place     = %lu\n", Place                      )
      BLAT("Value     = %lu\n", Value                      )
      BLAT("Numeral   = %c\n",  Numerals[Value]            )
   }

   // Write NUL terminators from one-past digits through one-past the final
   // character of the string being written (WARNING: Buffer size must be 
   // at least 1 byte larger than MaxDigits!!!):
   BLAT("In RepresentInBase, about to write NUL terminators.\n")
   for ( Index = RghtDigit + 1 ; Index <= MaxDigits ; ++Index )
   {
      Buffer[Index] = '\0';
   }

   // We're done, so return:
   BLAT("In RepresentInBase, about to return; Buffer = %s\n", Buffer)
   return;
} // end RepresentInBase()
