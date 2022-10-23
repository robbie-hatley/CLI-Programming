/*
  complex.cpp
  homebrew complex-number class demonstrator by Robbie Hatley
  created:     Wed. Jul. 11, 2001
  last edited: Sat. Oct. 23, 2004
*/

using namespace std;

#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <cstring>
#include <cctype>
#include <cmath>
#include <ctime>
#include <new>

const double PI = 3.141592653589793;

struct Complex
{
    Complex();
    Complex(double a, double b);
    ~Complex();
    Complex operator+(Complex &t);
    Complex operator-(Complex &t);
    Complex operator*(Complex &t);
    Complex operator/(Complex &t);
    friend inline double abs(Complex a);
    friend inline double theta(Complex a);
    double real;
    double imag;
};


// Global function prototypes:

inline double sqr(double a);
inline double abs(Complex a);
inline double theta(Complex a);


// Class member-function definitions:

Complex::Complex() {
  real = 0.0;
  imag = 0.0;
}

Complex::Complex(double a, double b) {
  real = a;
  imag = b;
}

Complex::~Complex() {
  ; // Do Nothing
}

Complex Complex::operator+(Complex &t) {
  Complex temp;
  temp.real=real+t.real;
  temp.imag=imag+t.imag;
  return temp;
}

Complex Complex::operator-(Complex &t) {
  Complex temp;
  temp.real=real-t.real;
  temp.imag=imag-t.imag;
  return temp;
}

Complex Complex::operator*(Complex &t) {
  //(a+bi)(c+di)=ac-bd+(bc+ad)i
  Complex temp;
  temp.real=real*t.real-imag*t.imag;
  temp.imag=imag*t.real+real*t.imag;
  return temp;
}

Complex Complex::operator/(Complex &t) {
  //(a1+a2i)/(b1+b2i) = (a1b1+a2b2)/(b1b1+b2b2) + i(a2b1-a1b2)/(b1b1+b2b2)
  if (abs(t) < 0.000001) {printf("Error: division by zero.\n");exit(401);}
  Complex temp;
  temp.real=(real*t.real+imag*t.imag)/(sqr(t.real)+sqr(t.imag));
  temp.imag=(imag*t.real-real*t.imag)/(sqr(t.real)+sqr(t.imag));
  return temp;
}


// Non-member function definitions:

inline double sqr(double a) {return a*a;}

inline double abs(Complex a) {return sqrt(sqr(a.real)+sqr(a.imag));}

inline double theta(Complex a) {return atan2(a.imag, a.real);}


// Main:

int main(void)
{
  ios::sync_with_stdio();
  Complex a,b,c;
  printf("2.0*PI=%f\n", 2.0*PI);
  a.real=21.7;
  a.imag=2.2;
  b.real=5.7;
  b.imag=4.3;
  c=a/b;
  printf("a=%f+%fi  abs(a)=%f  theta(a)=%f\n",
          a.real, a.imag, abs(a), theta(a) );
  printf("b=%f+%fi  abs(b)=%f  theta(b)=%f\n",
          b.real, b.imag, abs(b), theta(b) );
  printf("c=a/b=%f+%fi  abs(c)=%f  theta(c)=%f\n",
          c.real, c.imag, abs(c), theta(c) );
  Complex j(5.0,0.0),k(3.3,3.3),l(0.0,5.0),m(-2.7,2.7),
          n(-3.2,0.0),o(-8.2,-8.2),p(0.0,-7.3),q(4.3,-4.3);
  printf("\n\n%6.3f  %6.3f  %6.3f  %6.3f\n%6.3f  %6.3f  %6.3f  %6.3f\n",
         theta(j),theta(k),theta(l),theta(m),
         theta(n),theta(o),theta(p),theta(q) ) ;


  return 0;
}

