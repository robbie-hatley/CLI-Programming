/* This is a 79-character-wide ASCII C header text file.                     */
/*=======|=========|=========|=========|=========|=========|=========|=======*/

#ifndef RHDEFINES_H_ALREADY_INCLUDED
#define RHDEFINES_H_ALREADY_INCLUDED

/*****************************************************************************\
 * rhdefines.h
 * A collection of useful macros and typedefs for C and C++ programs, to be 
 * included into all of my other C and C++ headers, and by C and C++ programs 
 * which need the items in this header. Since macros are preprocessor, not C 
 * or C++, they are not scoped, and cannot be placed in namespaces. Hence 
 * the macros will be available in any file in which this header is included,
 * from the point of inclusion downward. Also note that I'm not using a C++
 * guard here because macros and typedefs are not passed by stack, so there
 * are no "calling convention" differences.
\*****************************************************************************/

/* ========================================================================= */
/* Macros:                                                                   */

/* 
Debug output macro. Define BLAT_ENABLE before including this file in order to
enable this macro. Note that the macro includes the statement-ending semicolon;
that way if BLAT_ENABLE is undefined, BLAT(foo) disappears entirely; not even
an empty statement is left. Hence don't put semicolons after BLATs!
WRONG: BLAT("Houston, we have a problem.");
RIGHT: BLAT("Houston, we have a problem.")
Also note that this will work in either C or C++, but must be used somewhat
differently. For example, to print a string and an int, you'd do this:
In C++:
BLAT("The value of x = " << x)
In C:
BLAT("The value of x = %d\n", x)
*/
#ifdef __cplusplus
   #ifdef BLAT_ENABLE
      #define BLAT(X) std::cerr << X << std::endl;
   #else
      #define BLAT(X)
   #endif
#else
   #ifdef BLAT_ENABLE
      #define BLAT(...) fprintf(stderr, __VA_ARGS__);
   #else
      #define BLAT(...)
   #endif
#endif

/* Some useful constants: */
#define PI 3.141592653589793
#define EE 2.718281828459045
#define EEE pow(1+pow(9,pow(-4,6*7)),pow(3,pow(2,85)))

/* Macro function to determine if last IO operation failed for
a reason other than eof (usable with C++ only): */
#ifdef __cplusplus
#define StreamIsBad(x) (x.bad() || (x.fail() && !x.eof()))
#endif

/* End include guard: */
#endif
