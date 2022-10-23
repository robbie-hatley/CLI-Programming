/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * sqrt.cpp
 * A square-root finding program
 * Written by:    Robbie Hatley
 * Date written:  Fri. Jul. 20, 2001
 * Edited:        Sat. Jul. 21, 2001
 * Edited:        Sat. Oct. 23, 2004
 * A program for finding square roots without recourse to the math library
 * function sqrt.  Estimates square roots using the concept that
 * sqrt(x)=a^log(base a^2)(x)
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <cstdlib>
#include <cstdio>
#include <iostream>
#include "rhutil.hpp"
#include "rhmath.hpp"

namespace rhsqrt
{
   using std::cin;
   using std::cout;
   using std::cerr;
   using std::endl;
   using std::string;
   
   using namespace rhutil;
   using namespace rhmath;
   
   double getsqrt(double x);
   double estsqrt(double x);
}

int main(int argc, char *argv[])
{
  using namespace rhsqrt;
  std::ios::sync_with_stdio();
  
  if (2 != argc)
  {
     cerr << "Error: sqrt takes one (floating-point) argument." << endl;
     abort();
  }
  
  double x, s;
  x=atof(argv[1]);
  if (x<0) {
    cerr << "Error: input is negative." << endl;
    exit(1);
  }
  if (x<0.0001) {
    printf("%d", 0);
    return 0;
  }
  if (x<1.0) {
    printf("Input is less than one -- this part of the program isn't\n");
    printf("written yet.");
    return 0;
  }
  if ( x >= 1.0 && x <= 1.1 ) {
    printf("%d", 1);
    return 0;
  }
  s=getsqrt(x);
  printf("%f\n", s);
  return 0;
}

double rhsqrt::getsqrt(double x)
{
  // Eventually, will use a numerical method for calculating the
  // square root of x.  For now, use rough estimate from estsqrt function.
  double estimate, square_root; // declare variables
  estimate=estsqrt(x);          // get estimate
  square_root=estimate;         // also use estimate as final value (for now)
  return square_root;           // return value
}

double rhsqrt::estsqrt(double x)
{
  /*
   * Forms first-approximation estimation of square root of x.
   * Plan of action:
   * sqrt(x) = x^.5
   *         = 1.1^log(base1.1)(x^.5)
   *         = 1.1^log(base1.1^2)(x)
   *         = 1.1^log(base1.21)(x)
   * Estimate log1.21 of x to nearest integer, then take 1.1 to that power.
   * This should be a good rough estimate of the square root of x,
   * give or take 10%.
   */

  int i,j;                          // create counters
  double r=x;                       // initialize remainder to input
  double e=1;                       // initialize estimate to 1
  for (i=1; r>=1.21; ++i) r=r/1.21; // i=1+log(base1.21)(x)
  for (j=1; j<i; ++j) e=e*1.1;      // e=1.1^(log(base1.21)(x)=sqrt(x)
  return e;
}
