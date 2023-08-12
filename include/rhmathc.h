/* This is a 79-character-wide ASCII C header text file.                     */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

#ifndef RHMATHC_H_ALREADY_INCLUDED
#define RHMATHC_H_ALREADY_INCLUDED

/*
rhmathc.h
Header for my collection of math routines in C (not C++).
*/

#include <stdint.h>
#include <stdbool.h>

#include <gmp.h>

#include "rhdefines.h"

#ifdef __cplusplus
extern "C" {
#endif

// First four prime numbers:
extern const uint64_t FirstFour[4];

// Prime Wheel:
extern const uint64_t Wheel[48];

// integer power:
uint64_t IntPow (uint64_t a, unsigned b);

// integer square root:
uint64_t IntSqrt (uint64_t n);

// Is given integer a prime number?
bool IsPrime(uint64_t n);

// Is given integer a prime number (unlimited-accuracy version)?
bool IsPrimeUnlimited (mpz_t n);

// How many combinations of k things from a set of n exist?
unsigned long comb (unsigned long n, unsigned long k);

// Concatenate two integers:
uint64_t CatNums (uint64_t a, uint64_t b);

// Is a given pair of numbers a "prime pair"?:
bool IsPrimePair (uint64_t a, uint64_t b);

// Reverse a number:
uint64_t ReverseNumber (uint64_t n);

#if 0
// Rotate a number rightward:
mpz_t RotateNumberRight (mpz_t x);

// Rotate a number leftward:
mpz_t RotateNumberLeft (mpz_t x);
#endif

// Is a given number palindromic?
bool IsPalindrome (uint64_t n);

// Determine number of digits necessary to represent
// given number in given base:
unsigned NumberOfDigits
   (
      uint64_t Number,  // positive integer in range [1 - 2**64-1]
      unsigned Base
   );

// What is the numerical value of a character?
unsigned CharToValue (char Char);

// Convert an ASCII string representation of an integer (base 2-62)
// to a long unsigned int:
uint64_t StringToNumber
   (
      char *     String, // string representation of integer (<= 2^64-1)
      unsigned   Base    // base of integer (2-62)
   );

/* Represent an integer in any base from 2 to 62: */
void RepresentInBase
   (
      uint64_t   Number,    // must be in range [0,2**64-1]
      unsigned   Base,      // must be in range [2,62]
      unsigned   MaxDigits, // BufferSize-1 ; must be in range [1,64]
      bool       Zeros,     // does user want leading zeros?
      char     * Buffer     // Buffer size MUST be >= MaxDigits+1. Recommend 65.
   );

/* end C++ guard: */
#ifdef __cplusplus
}
#endif

/* end include guard: */
#endif
